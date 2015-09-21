package boss

import org.codehaus.groovy.grails.commons.ConfigurationHolder

/**
 * Created by IntelliJ IDEA.
 * User: guonan
 * Date: 12-2-14
 * Time: 下午1:40
 * To change this template use File | Settings | File Templates.
 */
class ReportJob {

 def reportAgentpayDailyService
    def reportOnlinePayService
    def reportRoyaltyService
    def reportAdjustService
    def reportOtherBizService
    def reportPortalService
    def reportAllServicesDailyService
    def static cron = ConfigurationHolder.config.report.job.cron?ConfigurationHolder.config.report.job.cron.replace("\"",""):"0 0 3 * * ?"
  static triggers = {
      cron name: 'ReportTrigger', cronExpression: cron
  }
   static int i = 1
    def execute(){
        def day = new Date()-i
        println  "integrate i=${i}"
        println  "integrate date=${day}"

        println 'start reportAgentpayDailyService'
        reportAgentpayDailyService.integrate(day)
        println 'end reportAgentpayDailyService'

        println 'start reportOnlinePayService'
        reportOnlinePayService.report(day)
        println 'end reportOnlinePayService'

        println 'start reportRoyaltyService'
        reportRoyaltyService.report(day)
        println 'end reportRoyaltyService'

        println 'start reportAdjustService'
        reportAdjustService.getAdjustDailyReport(day)
        println 'end reportAdjustService'

        println 'start reportOtherBizService'
        reportOtherBizService.getOtherBizReport(day)
        println 'end reportOtherBizService'

        println 'start reportPortalService'
        reportPortalService.getPortalDailyReport(day)
        println 'end reportPortalService'


        println 'start reportAllServicesDailyService'
        reportAllServicesDailyService.integrate(day)
        println 'end reportAllServicesDailyService'

    }

}

