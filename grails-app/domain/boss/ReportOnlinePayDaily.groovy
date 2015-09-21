package boss

class ReportOnlinePayDaily {
    static mapping = {
        table 'report_online_pay_daily'
        version false
        id generator: 'sequence', params: [sequence: 'SEQ_REPORTONLINEPAY']
    }

    String area
    String customerNo
    String customerName
    String customerId
    String customerType
    String dailyFlag
    Date tradeDate
    Long bankPayNum=0
    Long bankPayAmount=0
    Long balancePayNum=0
    Long balancePayAmount=0
    Long bankRefundNum=0
    Long bankRefundAmount=0
    Long balanceRefundNum=0
    Long balanceRefundAmount=0
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
        bankPayNum(nullable:true)
        bankPayAmount(nullable:true)
        balancePayNum(nullable:true)
        balancePayAmount(nullable:true)
        bankRefundNum(nullable:true)
        bankRefundAmount(nullable:true)
        balanceRefundNum(nullable:true)
        balanceRefundAmount(nullable:true)
        settleAmount(nullable:true)
        feeAmount(nullable:true)
    }

    def  clear(){
         bankPayNum=0
         bankPayAmount=0
         balancePayNum=0
         balancePayAmount=0
         bankRefundNum=0
         bankRefundAmount=0
         balanceRefundNum=0
         balanceRefundAmount=0
         settleAmount=0
         feeAmount=0
    }

}