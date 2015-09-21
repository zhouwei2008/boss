package boss

import org.codehaus.groovy.grails.commons.ConfigurationHolder
import ismp.CmCorporationInfo

/**
 * Created by IntelliJ IDEA.
 * User: SunWeiGuo
 * Date: 12-7-19
 * Time: 上午10:51
 * To change this template use File | Settings | File Templates.
 */
class ViewJob {
    def    isViewDateService

    static triggers =
    {
        cron name: 'isViewDate', cronExpression: "0 0 6  * * ?"       //每天一点四十五分触发
    }

    def execute()
    {
        log.info('合同到期 start' + new Date())
        def date = new Date()

        def str = ConfigurationHolder.config.grails.opeatorEmail
        def opeatorEmail = str
        def sellerEmail
        def flag = 0
        if (str.indexOf(",") != -1)


        {
                   def flags = str.split(",")
                   opeatorEmail = flags[0]
                   sellerEmail = flags[1]
        }

        def operator = CmCorporationInfo.findAllByIsViewDate('1')

        def operator1 = BoCustomerService.findAllByIsViewDate('1')

        if (operator.size() > 0)
        {
                 operator.each {item ->
                 if (item.licenseExpires != null && item.licenseExpires != '')
                 {
                        if ((date - item.licenseExpires) == -60)
                        {
                            println("--------------------test")
                             isViewDateService.sendEmail("/isViewDate/isViewDateMail","营业执照到期提示",opeatorEmail,[item:item])
                             isViewDateService.sendEmail("/isViewDate/isViewDateMail","营业执照到期提示",sellerEmail,[item:item])
                        }
                }
            }
        }

        if (operator1.size() > 0)
        {
           operator1.each {item1 ->
                 if(item1.isCurrent && item1.enable)
                 {
                        if ((date - item1.endTime) == -60)
                        {
                            isViewDateService.sendEmail("/isViewDate/isViewDateMailS","服务到期提示",opeatorEmail,[item1:item1])
                            isViewDateService.sendEmail("/isViewDate/isViewDateMailS","服务到期提示",sellerEmail,[item1:item1])
                        }
                 }
        }



    }
}
}
