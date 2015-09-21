package ismp

class TradeBase {

    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator', params: [sequence_name: 'seq_trade', initial_value: 1])
        tablePerHierarchy false
    }
    Date dateCreated
    Date lastUpdated
    Long rootId
    Long originalId
    String tradeNo
    String tradeType
    Long partnerId
    Long payerId
    String  payerName
    String payerCode
    String payerAccountNo
    Long payeeId
    String  payeeName
    String payeeCode
    String payeeAccountNo
    String outTradeNo
    Long amount
    Long feeAmount=0
    String currency
    String subject
    String status
    Integer tradeDate
    String  note
    // 支付方式
    String paymentType
    //服务类型
    String serviceType

    static constraints = {
        rootId(nullable: true)
        originalId(nullable: true)
        tradeNo(maxSize:36,blank: false)
        tradeType(maxSize: 16,blank:false,inList: ['payment','transfer','refund','charge','withdrawn','royalty','royalty_rfd','frozen','unfrozen','withdrawnRef','refundRef','void'])
        partnerId(nullable: true)
        payerId(nullable: true)
        payerName(maxSize: 32,nullable: true)
        payerCode(maxSize: 64,nullable: true)
        payerAccountNo(maxSize: 24,blank:false)
        payeeId(nullable: true)
        payeeName(maxSize: 32,nullable: true)
        payeeCode(maxSize: 64,nullable: true)
        payeeAccountNo(maxSize: 24,blank:false)
        outTradeNo(maxSize: 64,nullable: true)
        amount()
        feeAmount()
        currency(maxSize: 4,blank:false)
        subject(maxSize: 256,nullable: true)
        status(maxSize: 16,inList: ['starting','processing','completed','closed','fail'])
        note(maxSize: 64,nullable: true)
        paymentType(nullable:true,inList:['1','2','3','4','5'])
        serviceType(nullable:true,inList:['onlinePay','royalty','agentCol','agentPay','mobilePay','personPortal','virtualAcc','settle', 'offlinepay'])
    }

    def afterInsert(){
        if(!rootId)
        {
            rootId=id
            save()
        }
    }

    def static tradeTypeMap = ['payment': '支付', 'transfer': '转账','refund':'退款','charge':'充值','withdrawn':'提现','royalty':'分润','royalty_rfd':'退分润','frozen':'冻结','unfrozen':'解冻结', 'void':'撤销']
    //def static statusMap = ['starting': '开始', 'processing': '处理中','completed':'完成','closed':'关闭','fail':'失败']
    def static statusMap = ['starting': '开始', 'processing': '处理中','completed':'完成','fail':'失败']
    def static paymentTypeMap=['1': 'B2C网银','2': 'B2B网银','3':'预付费卡','4':'吉高账户','5':'现金']
    def static serviceTypeMap=[ 'onlinePay':'在线支付','royalty':'分润', 'agentCol': '代收','agentPay':'代付', 'mobilePay':'手机支付', 'personPortal':'个人门户','virtualAcc':'虚拟账户', 'settle':'清结算系统', 'offlinepay':'线下充值']
}
