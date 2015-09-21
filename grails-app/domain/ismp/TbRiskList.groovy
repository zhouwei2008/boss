package ismp

class TbRiskList {

    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator', params: [sequence_name: 'seq_risk_list', initial_value: 1])
        tablePerHierarchy false
    }

       static constraints = {
        serialNo(size: 1..32,nullable: false)
        tradeType(size: 1..15,nullable: false)
        amount()
        merchantNo (size: 1..20,nullable: false)
        merchantName(size: 1..100,nullable: false)
        merchantId (size: 1..30,nullable: false)
        tradeBase()
        riskControl()
        isSendMail(size: 1..10,nullable: false)
        createdDate()
        tradeDate()
    }



    def static TradeTypeMap = ['onlinePay':'互联网支付','mobilePay':'移动电话支付']

    String serialNo
    Date  createdDate
    String tradeType
    Long amount
    String merchantNo
    TradeBase tradeBase
    TbRiskControl riskControl
    String merchantName
    String merchantId
    String isSendMail
    Date tradeDate
}
