package boss

/**
 * Created by IntelliJ IDEA.
 * User: syw
 * Date: 11-11-28
 * Time: 上午9:28
 * To change this template use File | Settings | File Templates.
 */
class QueryReqJob {


 def hunionPayService

  static triggers = {    simple name: 'queryTrigger', startDelay: 1000, repeatInterval: 20*60*1000    }

    def execute(){
//        try{
//          hunionPayService.sendQuery()
//        }catch(Exception e){
//            e.printStackTrace()
//        }
//
//        println "over=================================="
    }

}
