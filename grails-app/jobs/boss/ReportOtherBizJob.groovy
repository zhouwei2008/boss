package boss

/**
 * Created by IntelliJ IDEA.
 * User: shuo_zhang
 * Date: 12-2-21
 * Time: 下午2:45
 * To change this template use File | Settings | File Templates.
 */
class ReportOtherBizJob {
    def reportOtherBizService
    static triggers = {
        cron name: 'reportOtherBiz', cronExpression: "0 * * * * ?"
    }

    def execute() {
//        println "AA11"
//        log.info('report start' + new Date())
//        reportOtherBizService.getOtherBizReport()
//        log.info('report end')
    }
}
