package ismp

class TradeRefundBatch {

    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator', params: [sequence_name: 'seq_trade_refund_batch', initial_value: 1000000])
//        version false
    }
    //批次笔数
    String batchCount
    //批次金额
    Long batchAmount
    //退款初审时间
    Date refundDate
    //订单类型
    String refundType
    //退款银行名称
    String refundBankName
    //退款银行编号
    String refundBankCode
    //批次状态
    String status
    //初审人名称
    String appName
    //初审人id
    String appId

    static constraints = {
        refundType nullable: true
        refundBankName nullable: true
        refundBankCode nullable: true
    }
    def static refundTypeMap = ['1': 'B2C网银', '2': 'B2B网银', '3': '预付费卡', '4': '吉高账户']
    def static statusMap = ['waiting':'处理中','approved':'初审通过','refused':'初审拒绝']
}
