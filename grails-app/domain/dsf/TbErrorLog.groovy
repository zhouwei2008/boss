package dsf

/**
 * Created by IntelliJ IDEA.
 * User: test
 * Date: 12-5-10
 * Time: 上午10:48
 * To change this template use File | Settings | File Templates.
 */
class TbErrorLog {
     static mapping = {
        table 'TB_ERROR_LOG'
        version false
        id generator: 'sequence', params: [sequence: 'SEQ_TB_ERRORLOG'], column:'ID'
    }

    String name
    String type
    String keyValue
    String errorMsg
    Date createTime
    String summary
    String isCheck
    String errorMsgDetail


    static constraints = {
        name(nullable:true)
        type(nullable:true)
        keyValue(nullable:true)
        errorMsg(nullable:true)
        createTime(nullable:true)
        summary(nullable:true)
        isCheck(nullable:true)
        errorMsgDetail(nullable:true)
    }


}
