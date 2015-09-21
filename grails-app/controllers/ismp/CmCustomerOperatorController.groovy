package ismp

import java.util.regex.Pattern
import java.util.regex.Matcher

class CmCustomerOperatorController {
    def operatorService
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def customerNo = params.customerNo
        def status = params.status
        def query = {
            customer {
                eq('customerNo', customerNo)
            }
        }
        def cmCustomerOperatorInstance = CmCustomerOperator.createCriteria().list(query)
        def total = CmCustomerOperator.createCriteria().count(query)
        [cmCustomerOperatorInstanceList: cmCustomerOperatorInstance, cmCustomerOperatorInstanceTotal: total, status: status]
    }

    def create = {
        def cmCustomerOperatorInstance = new CmCustomerOperator()
        cmCustomerOperatorInstance.properties = params
        return [cmCustomerOperatorInstance: cmCustomerOperatorInstance]
    }

    def save = {
        def cmCustomerOperatorInstance = new CmCustomerOperator(params)
        if (cmCustomerOperatorInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'cmCustomerOperator.label', default: 'CmCustomerOperator'), cmCustomerOperatorInstance.id])}"
            redirect(action: "list", id: cmCustomerOperatorInstance.id)
        }
        else {
            render(view: "create", model: [cmCustomerOperatorInstance: cmCustomerOperatorInstance])
        }
    }

    def show = {
        def cmCustomerOperatorInstance = CmCustomerOperator.get(params.id)
        if (!cmCustomerOperatorInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmCustomerOperator.label', default: 'CmCustomerOperator'), params.id])}"
            redirect(action: "list")
        }
        else {
            [cmCustomerOperatorInstance: cmCustomerOperatorInstance]
        }
    }

    def edit = {
        def cmCustomerOperatorInstance = CmCustomerOperator.get(params.id)
        def cmCustoemr = CmCustomer.get(cmCustomerOperatorInstance.customer.id)
        if (!cmCustomerOperatorInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmCustomerOperator.label', default: 'CmCustomerOperator'), params.id])}"
            redirect(action: "list", params: [customerNo: cmCustoemr.customerNo, status: cmCustoemr.status])
        }
        else {
            return [cmCustomerOperatorInstance: cmCustomerOperatorInstance]
        }
    }

    def sendEmail = {
        def cmCustomerOperator = CmCustomerOperator.get(params.id)
        def cmCustomer = CmCustomer.get(cmCustomerOperator.customer.id)
        operatorService.sendEmailCaptcha(cmCustomer, cmCustomerOperator, cmCustomerOperator.defaultEmail, '重发验证地址')
        flash.message = "发送完成！"
        redirect(action: "list", params: [customerNo: cmCustomer.customerNo, status: cmCustomer.status])
    }

    def updateStatus = {
        def cmCustomerOperatorInstance = CmCustomerOperator.get(params.id)
        def str = params.status
        if ("disabled".equals(str)) {
            cmCustomerOperatorInstance.status = "disabled"
        }
        if ("normal".equals(str)) {
            cmCustomerOperatorInstance.status = "normal"
            cmCustomerOperatorInstance.loginErrorTime = 0

        }
        if (cmCustomerOperatorInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (cmCustomerOperatorInstance.version > version) {

                    cmCustomerOperatorInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'cmCustomerOperator.label', default: 'CmCustomerOperator')] as Object[], "Another user has updated this CmCustomerOperator while you were editing")
                    render(view: "edit", model: [cmCustomerOperatorInstance: cmCustomerOperatorInstance])
                    return
                }
            }
            if (!cmCustomerOperatorInstance.hasErrors() && cmCustomerOperatorInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'cmCustomerOperator.label', default: 'CmCustomerOperator'), cmCustomerOperatorInstance.id])}"
                redirect(action: "list", params: [customerNo: cmCustomerOperatorInstance.customer.customerNo, status: cmCustomerOperatorInstance.customer.status])
            }
            else {
                render(view: "list", model: [cmCustomerOperatorInstance: cmCustomerOperatorInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmCustomerOperator.label', default: 'CmCustomerOperator'), params.id])}"
            redirect(action: "list")
        }
    }

    def update = {
        def mLoginCertificate
        def cmCustomerOperatorInstance = CmCustomerOperator.get(params.id)
        def cmLoginCertificate = CmLoginCertificate.findByCustomerOperator(cmCustomerOperatorInstance)
        def reg = /^[-_A-Za-z0-9]+@([_A-Za-z0-9]+.)+[A-Za-z0-9]{2,3}$/
        def regx = /^1[3|5|8][0-9]\d{4,8}$/
        if (params.defaultMobile != null && params.defaultMobile != '') {
            Pattern patNo = Pattern.compile(regx);
            Matcher matNo = patNo.matcher(params.defaultMobile);
            if (!matNo.find()) {
                flash.message = "手机号格式不正确，请重新填写！"
                render(view: "edit", model: [cmCustomerOperatorInstance: cmCustomerOperatorInstance])
                return
            }
        }
        Pattern patternNo = Pattern.compile(reg);
        Matcher matcherNo = patternNo.matcher(params.defaultEmail);
        if (!matcherNo.find()) {
            flash.message = "邮箱格式不正确，请重新填写！"
            render(view: "edit", model: [cmCustomerOperatorInstance: cmCustomerOperatorInstance])
            return
        }
//        if (!(params.defaultEmail == ~/^[-_A-Za-z0-9]+@([_A-Za-z0-9]+.)+[A-Za-z0-9]{2,3}$/)) {
//            flash.message = "邮箱格式不正确，请重新填写！"
//            render(view: "edit", model: [cmCustomerOperatorInstance: cmCustomerOperatorInstance])
//            return
//        }
        if (!params.defaultEmail.equals(cmCustomerOperatorInstance.defaultEmail)) {
            mLoginCertificate = CmLoginCertificate.findAllByLoginCertificate(params.defaultEmail)
            if (mLoginCertificate.size() > 0) {
                flash.message = "邮箱已经被使用，请重新填写！"
                render(view: "edit", model: [cmCustomerOperatorInstance: cmCustomerOperatorInstance])
                return
            } else {
                cmLoginCertificate.loginCertificate = params.defaultEmail
                cmLoginCertificate.lastUpdated = new Date()
                cmLoginCertificate.save(flush: true)
                cmCustomerOperatorInstance.defaultEmail = params.defaultEmail
                cmCustomerOperatorInstance.defaultMobile = params.defaultMobile
                cmCustomerOperatorInstance.name = params.name
//                cmCustomerOperatorInstance.status = "init"
                cmCustomerOperatorInstance.save(flush: true)
                redirect(action: "list", params: [customerNo: cmCustomerOperatorInstance.customer.customerNo, status: cmCustomerOperatorInstance.customer.status])
            }
        } else {
            cmCustomerOperatorInstance.defaultMobile = params.defaultMobile
            cmCustomerOperatorInstance.name = params.name
            cmCustomerOperatorInstance.save(flush: true)
            redirect(action: "list", params: [customerNo: cmCustomerOperatorInstance.customer.customerNo, status: cmCustomerOperatorInstance.customer.status])
        }
    }

    def delete = {
        def cmCustomerOperatorInstance = CmCustomerOperator.get(params.id)
        if (cmCustomerOperatorInstance) {
            try {
                cmCustomerOperatorInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'cmCustomerOperator.label', default: 'CmCustomerOperator'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'cmCustomerOperator.label', default: 'CmCustomerOperator'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmCustomerOperator.label', default: 'CmCustomerOperator'), params.id])}"
            redirect(action: "list")
        }
    }
}
