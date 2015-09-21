package boss

/**
 * Created by IntelliJ IDEA.
 * User: shuo_zhang
 * Date: 12-2-20
 * Time: 下午3:54
 * To change this template use File | Settings | File Templates.
 */
class ReportAdjustDaily {
    static mapping = {
         version false
         id generator: 'sequence', params: [sequence: 'SEQ_REPORTADJUST']
      }

    Date dateCreated
    //借记账户调账金额合计
    Long debitAdjustAmount = 0
    //贷记账户调账金额合计
    Long creditAdjustAmount = 0
    //平台手续费（已收）
    Long platFee = 0
    //银行手续费
    Long bankFee=0
    //银行调账充值账户
    Long bankAdjustCharge = 0
    //银行调账提款账户
    Long bankAdjustWithdrawn = 0
    //借记账户其他合计
    Long debitSum=0
    //贷记账户其他合计
    Long creditSum=0

    static constraints = {
        debitAdjustAmount(nullable: true)
        creditAdjustAmount(nullable: true)
        platFee(nullable: true)
        bankFee(nullable: true)
        bankAdjustCharge(nullable: true)
        bankAdjustWithdrawn(nullable: true)
        debitSum(nullable: true)
        creditSum(nullable: true)
        dateCreated(nullable: true)
    }


}
