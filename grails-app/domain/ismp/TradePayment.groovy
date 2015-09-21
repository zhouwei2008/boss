package ismp

class TradePayment extends TradeBase{

    Long    paymentRequestId
    Long    refundAmount
    Long    frozenAmount
    String  paymentIp
    String  showUrl
    String  body
    String  outRoyaltyTradeNo
    String  royaltyType
    String  royaltyParams
    String  royaltyStatus

    static constraints = {
        paymentIp(maxSize: 20,blank: false)
        showUrl(maxSize: 200,nullable: true)
        body(maxSize: 512,nullable: true)
        outRoyaltyTradeNo(maxSize: 32)
        royaltyType(maxSize: 16,inList:['10'],nullable:true)
        royaltyParams(maxSize: 512,nullable:true)
        royaltyStatus(maxSize: 16,inList:['starting','processing','completed','closed'])
    }

    def static statusMap = ['processing': '处理中','successed': '成功交易', 'failed': '失败交易','refund':'退款交易']
    def static royaltyStatusMap = ['starting': '开始', 'processing': '处理中','completed':'完成','closed':'关闭']
}
