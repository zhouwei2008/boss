package boss

/**
 * 每月交易累计数清零
 * User: zhenghf
 * Date: 13-8-16
 * Time: 上午10:48
 * To change this template use File | Settings | File Templates.
 */
class ClearMonthQutorJob {

    def clearQuotaService
    static triggers =
    {
      cron name: 'monthQutorCount', cronExpression: "0 0 0  * * ?"       //每天0:00:00 触发
//      simple name: 'monthQutorCountTrigger', startDelay: 1000, repeatInterval: 1000
    }


    def execute()
    {
        log.info('商户每月交易累计金额清零 start' + new Date())
        try {
            String curDate = new Date().format('yyyy-MM-dd')//当前日期
            Calendar cal = Calendar.getInstance();
            cal.set(GregorianCalendar.DAY_OF_MONTH, 1);
            Date beginTime=cal.getTime();
            String monthDate = beginTime.format("yyyy-MM-dd")
            if(curDate.compareTo(monthDate) == 0){
                clearQuotaService.clearMonthQutorCount()
                println("商户每月交易累计金额清零execute")
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        log.info('商户每月交易累计金额清零 end' + new Date())
    }

}
