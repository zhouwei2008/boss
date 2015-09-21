package boss

/**
 * Created by IntelliJ IDEA.
 * User: shuo_zhang
 * Date: 12-2-21
 * Time: 下午2:44
 * To change this template use File | Settings | File Templates.
 */
class ReportAdjustDailyJob {
    def reportAdjustService
    static triggers = {
        cron name: 'reportAdjust', cronExpression: "0 * * * * ?"
    }

    def execute() {
//        println "AA11"
//        log.info('report start' + new Date())
//        reportAdjustService.getAdjustDailyReport()
//        log.info('report end')
    }
}
