package ismp


class TbRiskControl {

    String bType
    String bDesc
    String status //开启状态
    String rule
    String ruleAbout
    String ruleParams

    String createOp //创建人
    Date createTime //创建时间

    String editOp //编辑时间
    Date editTime //编辑时间

    String verifyOp //审核时间
    Date verifyTime //审核时间

    static constraints = {

        bDesc(nullable:false,size:1..300)
        rule(nullable:false,size:1..300)
        ruleAbout(nullable:false,size:1..32)
        ruleParams(nullable:true,size:1..100)
        createOp(nullable:true,size:1..50)
        createTime(nullable:true)
        editOp(nullable:true,size:1..50)
        editTime(nullable:true)
        verifyOp(nullable:true,size:1..50)
        verifyTime(nullable:true)

    }


    static mapping={

        table 'TB_RISK_CONTROL_RULE'

        version false

        id generator: 'sequence' ,params:[sequence:'SEQ_RISK_CONTROL_RULE'],column:'ID'

    }

    def static StatusMap=['1':'启用','0':'关闭']
    def static BTypeMap=['onlinePay':'在线支付','mobilePay':'移动电话支付']
}
