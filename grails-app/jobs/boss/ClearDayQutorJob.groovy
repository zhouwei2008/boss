package boss

/**
 * 每日交易累计金额清零
 * User: admin
 * Date: 13-8-16
 * Time: 上午10:46
 * To change this template use File | Settings | File Templates.
 */
class ClearDayQutorJob {

    def clearQuotaService

    static triggers =
    {
        cron name: 'dayQutorCount', cronExpression: "0 0 0  * * ?"       //每天0:00:00 触发
//        simple name: 'dayQutorCountTrigger', startDelay: 1000, repeatInterval: 1000
    }


    def execute()
    {
        log.info('商户每日交易累计金额清零 start' + new Date())

        clearQuotaService.clearDayQutorCount()

        log.info('商户每日交易累计金额清零 end' + new Date())
    }

}
