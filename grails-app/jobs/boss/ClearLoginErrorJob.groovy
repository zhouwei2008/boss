package boss

/**
 * BOSS操作员登陆错误次数清零
 * User: admin
 * Date: 13-8-16
 * Time: 下午12:20
 * To change this template use File | Settings | File Templates.
 */
class ClearLoginErrorJob {

    static triggers = {
        //每天执行一次
          cron name: 'changePas', cronExpression: "0 0 0 * * ?"
//        simple name: 'changePas', startDelay: 2000, repeatInterval: 10000
    }

    def execute() {
         log.info("ClearLoginErrorJob start")
         try {
             def operator = BoOperator.list()
             if(operator.size() > 0 ){
                 operator.each {item ->
                      if(item.lastLoginTime != null && item.lastLoginTime != ''){
                          String curDate = new Date().format('yyyy-MM-dd')
                          String  lastLoginTime = item.lastLoginTime.format('yyyy-MM-dd')
                          if(curDate.compareTo(lastLoginTime) > 0 && (item.loginErrorTime > 0 || item.status.equals("locked"))){
                              log.info("ClearLoginErrorJob execute")
                              item.loginErrorTime = 0
                              item.status = 'normal'
                              item.save(flush:true)
                          }
                      }
                 }
             }
         }catch (Exception e){
              log.warn("boss操作员登陆次数清零"+e)
         }
        log.info("ClearLoginErrorJob end")
    }

}
