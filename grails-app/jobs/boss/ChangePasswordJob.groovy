package boss

import org.codehaus.groovy.grails.commons.ConfigurationHolder


class ChangePasswordJob {
//    def timeout = 5000l // execute job once in 5 seconds
    def sendService
    static triggers = {
        //每天执行一次
//       cron name: 'changePas', cronExpression: "0 0 8 * * ?"
//        simple name: 'changePas', startDelay: 2000, repeatInterval: 10000
    }

    def execute() {
        // execute task
        log.info('changePassword start' + new Date())
        def date = new Date()
        def content
        def usrID = ConfigurationHolder.config.userId
        def usrPWD = ConfigurationHolder.config.userPwd
        def operator = BoOperator.findAllByStatus('normal')
        if (operator.size() > 0) {
            operator.each {  item ->
                if (item.lastChangeTime != null && item.lastChangeTime != '') {
                    if ((date - item.lastChangeTime) == 83) {
                        def passDate = ebank.tools.StringUtil.getFullDateTime(date + 7)
                        content = '您的BOSS操作员密码将于' + passDate + '失效，请尽快登录修改！【吉高】'
                        def result = sendService.sendSMS(item.mobile, content, usrID, usrPWD)
                    }
                    if ((date - item.lastChangeTime) == 87) {
                        def passDate = ebank.tools.StringUtil.getFullDateTime(date + 3)
                        content = '您的BOSS操作员密码将于' + passDate + '失效，请尽快登录修改！【吉高】'
                        def result = sendService.sendSMS(item.mobile, content, usrID, usrPWD)
                    }
                    if ((date - item.lastChangeTime) == 90) {
                        def passDate = ebank.tools.StringUtil.getFullDateTime(date + 1)
                        content = '您的BOSS操作员密码将于' + passDate + '失效，请尽快登录修改！【吉高】'
                        def result = sendService.sendSMS(item.mobile, content, usrID, usrPWD)
                    }
                    if ((date - item.lastChangeTime) > 90) {
                        item.status = 'disabled'
                        item.save(flush:true)
                    }
                }
            }
        }
        log.info('changePassword end')
    }
}

