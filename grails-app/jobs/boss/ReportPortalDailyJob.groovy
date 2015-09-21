package boss

/**
 * Created by IntelliJ IDEA.
 * User: shuo_zhang
 * Date: 12-2-14
 * Time: 下午6:09
 * To change this template use File | Settings | File Templates.
 */
class ReportPortalDailyJob {
    def reportPortalService
    static triggers = {
        cron name: 'reportPortal', cronExpression: "0 * * * * ?"
    }

    def execute() {
//        println "AA11"
//        log.info('report start' + new Date())
//        reportPortalService.getPortalDailyReport()
//        log.info('report end')
    }
}
