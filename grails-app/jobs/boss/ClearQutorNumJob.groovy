package boss

/**
 * 每日交易累计笔数清零
 * User: zhenghf
 * Date: 13-8-16
 * Time: 上午9:36
 * To change this template use File | Settings | File Templates.
 */
class ClearQutorNumJob {

        def clearQuotaService

        static triggers =
        {
           cron name: 'qutorNumCount', cronExpression: "0 0 0  * * ?"       //每天0:00:00 触发
//           simple name: 'qutorNumCountTrigger', startDelay: 1000, repeatInterval: 1000
        }


        def execute()
        {
            log.info('商户每日交易累计笔数清零 start' + new Date())

            clearQuotaService.clearQutorNumCount()

            log.info('商户每日交易累计笔数清零 end' + new Date())
        }
}
