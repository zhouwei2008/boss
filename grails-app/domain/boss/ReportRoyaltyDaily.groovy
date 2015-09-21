package boss

class ReportRoyaltyDaily {
    static mapping = {
        table 'report_royalty_daily'
        version false
        id generator: 'sequence', params: [sequence: 'SEQ_REPORTROYALTY']
    }

    String area
    String customerNo
    String customerName
    String customerId
    String customerType
    String dailyFlag
    Date tradeDate
    Long royaltyPayNum=0
    Long royaltyPayAmount=0
    Long royaltyRefundNum=0
    Long royaltyRefundAmount=0
    Long settleAmount=0
    Long feeAmount=0
    Date dateCreated

    static constraints = {
        area(maxSize: 32, nullable:true)
        customerNo(maxSize: 24, blank: false)
        customerName(maxSize: 32, nullable:true)
        customerId(nullable:true)
        customerType(nullable:true)
        dailyFlag(maxSize: 10, blank: false)
        tradeDate(nullable:true)
        royaltyPayNum(nullable:true)
        royaltyPayAmount(nullable:true)
        royaltyRefundNum(nullable:true)
        royaltyRefundAmount(nullable:true)
        settleAmount(nullable:true)
        feeAmount(nullable:true)
    }

    def  clear(){
         royaltyPayNum=0
         royaltyPayAmount=0
         royaltyRefundNum=0
         royaltyRefundAmount=0
         settleAmount=0
         feeAmount=0
    }
}