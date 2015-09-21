package boss

/**
 * Created by IntelliJ IDEA.
 * User: shuo_zhang
 * Date: 12-2-13
 * Time: 下午6:06
 * To change this template use File | Settings | File Templates.
 */
class ReportPortalDaily {
//    static mapping = {
//       id generator: 'sequence', params: [sequence: 'report_portal_daily']
//    }

   static mapping = {
     version false
     id generator: 'sequence', params: [sequence: 'SEQ_REPORTPORTAL']
  }
    //客户数总量
    Long customerTotal = 0
    //客户发生交易数量
    Long customerTradetotal = 0
    //账户余额
    Long balance = 0
    //所有充值笔数
    Long chargeTotalCount = 0
    //所有值金额
    Long chargeTotalAmount = 0
    //仅充值笔数
    Long chargeOnlyCount = 0
    //仅充值金额
    Long chargeOnlyAmount  = 0
    //为其他业务进行充值笔数
    Long chargeOtherCount   = 0
    //为其他业务进行充值金额
    Long chargeOtherAmount    = 0
    //支付笔数
    Long payCount = 0
    //支付金额
    Long payAmount = 0
    //提现笔数
    Long withdrawnCount = 0
    //提现金额
    Long withdrawnAmount = 0
    //退款笔数
    Long refundCount = 0
    //退款金额
    Long refundAmount = 0
    //转账笔数
    Long transferCount = 0
    //转账金额
    Long transferAmount = 0
    //银行成本
    Long bankCost  = 0
    //手续费收入
    Long inFee  = 0
    //统计时间
    Date dateCreated

    static constraints = {
        customerTotal(nullable: false)
        customerTradetotal(nullable: false)
        chargeTotalCount(nullable: false)
        chargeTotalAmount(nullable: false)
        chargeOnlyCount(nullable: true)
        chargeOnlyAmount(nullable: true)
        chargeOtherCount(nullable: true)
        chargeOtherAmount(nullable: true)
        payCount(nullable: false)
        payAmount(nullable: false)
        withdrawnCount(nullable: false)
        withdrawnAmount(nullable: false)
        refundCount(nullable: false)
        refundAmount(nullable: false)
        transferCount(nullable: false)
        transferAmount(nullable: false)
        bankCost(nullable: true)
        inFee(nullable: true)
        dateCreated(nullable: false)
    }

}
