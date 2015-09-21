package boss

/**
 * Created by IntelliJ IDEA.
 * User: syw
 * Date: 11-11-28
 * Time: 上午9:28
 * To change this template use File | Settings | File Templates.
 */
class HbdJob {


 def hunionPayService

  static triggers = {    simple name: 'HbdTrigger', startDelay: 2000, repeatInterval: 20*60*1000    }

    def execute(){
//       try{
//        hunionPayService.autoBd()
//       }catch (Exception e){
//           e.printStackTrace()
//       }
//
//        println "自动补单over=================================="
    }

}
