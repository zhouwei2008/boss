package boss

import org.codehaus.groovy.grails.commons.ConfigurationHolder
import ismp.NotifyFailWatcher
import java.text.SimpleDateFormat
import org.codehaus.groovy.grails.plugins.web.taglib.FormatTagLib

class NofityFailJob {
    def sendService
    def notifyFailService

    static triggers = {
        //cron name: 'changePas', cronExpression: "0 0 8 * * ?"
       // simple name: 'notifyFail', startDelay: 2000, repeatInterval: 1000 * 60 * 5
    }

    def execute() {
        // execute task
        log.info('notifyFail start' + new Date())
        def sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        def contentSMS
        def usrID = ConfigurationHolder.config.userId
        def usrPWD = ConfigurationHolder.config.userPwd

        def notifyList = notifyFailService.list()
        def watcherList = NotifyFailWatcher.list()

        if(watcherList && notifyList){
            watcherList.each { watcher ->
                notifyList.each { item ->
                    contentSMS = """系统发现商户订单号（${item.OUTTRADENO}）为疑似掉单，请核实订单信息，并进行处理。系统自动发送短信，请不要回复，谢谢。【吉高】"""
                    sendService.sendSMS(watcher.mobile, contentSMS, usrID, usrPWD)

//                    def time = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
                    item.name=watcher.name
                    sendService.sendEmail("/notifyFailProof/template_notify", "BOSS系统掉单提醒", watcher.email, [item:item])
                }
            }
        }

        log.info('notifyFail end')
    }
}

