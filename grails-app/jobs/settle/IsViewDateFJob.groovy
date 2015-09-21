package settle

import org.codehaus.groovy.grails.commons.ConfigurationHolder

/**
 * Created by IntelliJ IDEA.
 * User: SunWeiGuo
 * Date: 12-6-25
 * Time: 上午10:07
 * To change this template use File | Settings | File Templates.
 */
class IsViewDateFJob {
    def isViewDateFService

    static triggers =
    {
        cron name: 'isViewDatef', cronExpression: "0 0 6  * * ?"       //每天一点四十五分触发
    }

    def execute() {
        def date = new Date()

        def str = ConfigurationHolder.config.grails.opeatorEmail
        def opeatorEmail = str
        def sellerEmail
        def flag = 0
        if (str.indexOf(",") != -1) {
            def flags = str.split(",")
            opeatorEmail = flags[0]
            sellerEmail = flags[1]

        }

        def operator = FtTradeFee.createCriteria().list(fetch:[srv:'eager']){
            and{
               eq("isViewDate",true)
            }
        }
        if (operator.size() > 0) {
            operator.each {
                if (it.dateEnd != null && it.dateEnd != '') {
                    if ((date - it.dateEnd) == -15) {
                        def srvName = FtSrvType.get(Long.valueOf(it.srv?.id))?.srvName
                        isViewDateFService.sendEmail("/isViewDate/isViewDateMailF", "费率到期提示", opeatorEmail, [item: it, srvName: srvName])
                        isViewDateFService.sendEmail("/isViewDate/isViewDateMailF", "费率到期提示", sellerEmail, [item: it, srvName: srvName])
                    }
                }
            }
        }
    }
}