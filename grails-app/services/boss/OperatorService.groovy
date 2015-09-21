package boss

import ismp.CmCustomer
import ismp.CmCustomerOperator
import ismp.CmDynamicKey
import ismp.CmLoginCertificate
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import groovyx.net.http.HTTPBuilder
import static groovyx.net.http.Method.GET
import static groovyx.net.http.Method.POST
import static groovyx.net.http.ContentType.TEXT
import static groovyx.net.http.ContentType.JSON
import groovyx.net.http.ContentType


class OperatorService {

    static transactional = true
    def grailsTemplateEngineService
    def asynchronousMailService
    def http = new HTTPBuilder(ConfigurationHolder.config.emis.serverUrl + 'inAccess/email')

    def addOperator(CmCustomer cmCustomer, CmCustomerOperator cmCustomerOperatorInstance) {
//        cmCustomerOperatorInstance.loginPassword='111111'
//        cmCustomerOperatorInstance.payPassword='111111'
        //产生随机的登录密码和支付密码
        def loginpass = KeyUtils.getRandKey(8)
        def paypass = KeyUtils.getRandKey(8)
        cmCustomerOperatorInstance.loginPassword = loginpass.encodeAsSHA1()
        cmCustomerOperatorInstance.payPassword = paypass.encodeAsSHA1()
        cmCustomerOperatorInstance.roleSet = '1'
        cmCustomerOperatorInstance.status = 'normal'
        cmCustomerOperatorInstance.save()

        def cmLoginCertificate = new CmLoginCertificate()
        cmLoginCertificate.customerOperator = cmCustomerOperatorInstance
        cmLoginCertificate.loginCertificate = cmCustomerOperatorInstance.defaultEmail
        cmLoginCertificate.certificateType = 'email'
        cmLoginCertificate.isVerify = false
        if (!cmLoginCertificate.hasErrors() && cmLoginCertificate.save()) {
            //1.发送重置密码的邮件
            sendEmailCaptcha(cmCustomer, cmCustomerOperatorInstance, cmCustomerOperatorInstance.defaultEmail, '获取登录密码')
        } else {
            cmCustomerOperatorInstance.errors.rejectValue("defaultEmail", "该邮件已被注册了，请换一个再试")
            throw new RuntimeException("该邮件${cmCustomerOperatorInstance.defaultEmail}已被注册")
        }
    }


    def sendEmailCaptcha = {CmCustomer cmCustomer, CmCustomerOperator cmCustomerOperator, String sendTo, String mailTitle ->
        //1.发送重置密码的邮件
        //1.1写动态口令表
        def cmDynamicKey = new CmDynamicKey()
        cmDynamicKey.customer = cmCustomer
        cmDynamicKey.sendType = 'email'
        cmDynamicKey.sendTo = sendTo
        cmDynamicKey.parameter = cmCustomerOperator.id                                                                //运算参数
        cmDynamicKey.key = KeyUtils.getRandKey(8)                                                                      //动态口令
        cmDynamicKey.procMethod = 'md5'                                                                              //运算方法
        cmDynamicKey.verification = (cmDynamicKey.parameter + cmDynamicKey.key).encodeAsMD5()                        //验证值，等于运算参数加动态口令的md5值
        cmDynamicKey.timeExpired = new Date(System.currentTimeMillis() + 3600000)                                      //过期时间,设为1小时后
        //cmDynamicKey.timeUsed=''                                                                                   //使用时间
        cmDynamicKey.isUsed = false                                                                                  //是否使用过
        cmDynamicKey.useType = 'reset_login_pass'                                                                  //使用类型
        cmDynamicKey.save(flush: true)
        println "=====mail ${sendTo}: ${ConfigurationHolder.config.grails.ismpURL}/login/resetloginpass/${cmDynamicKey.parameter}?verification=${cmDynamicKey.verification}"
        //1.2异步发送邮件
//    asynchronousMailService.sendAsynchronousMail {
//      to cmDynamicKey.sendTo
//      subject mailTitle
//      //html '<u>Test</u>'
//      body(view: "/mail/template_resetloginpass", model: [cmDynamicKey: cmDynamicKey])
//      maxAttemptsCount 3
//    }

        String txt = grailsTemplateEngineService.renderView("/mail/template_resetloginpass", [cmDynamicKey: cmDynamicKey,cmCustomerOperator:cmCustomerOperator])
        mailTitle = URLEncoder.encode(mailTitle, 'GBK')
        def args = [to: sendTo, subject: mailTitle, body: URLEncoder.encode(txt, 'GBK'), charset: 'GBK']
        http.request(POST) {req ->
            requestContentType = ContentType.URLENC
            body = args
            req.getParams().setParameter("http.connection.timeout", new Integer(60000));
            req.getParams().setParameter("http.socket.timeout", new Integer(60000));
            response.success = { resp, reader ->
                return reader.text
            }
            response.failure = { resp ->
                println 'execute error' + resp
                throw new Exception('request error')
            }
        }
    }
}
