package boss

/**
 * Created by IntelliJ IDEA.
 * User: shuo_zhang
 * Date: 12-2-17
 * Time: 上午11:16
 * To change this template use File | Settings | File Templates.
 */
class ReportOtherBizDaily {
    static mapping = {
         version false
         id generator: 'sequence', params: [sequence: 'SEQ_REPORTOTHERBIZ']
      }
    Date dateCreated
    String area;
    String cusName;
    Long cusAccountID;
    //所有充值笔数
    Long chargeTotalCount = 0
    //所有值金额
    Long chargeTotalAmount = 0
    //充值手续费收入
    Long chargeFee=0
    //充值银行手续费成本
    Long chargeBankCost=0

    //提现笔数
    Long withdrawnCount = 0
    //提现金额
    Long withdrawnAmount = 0
    //提现手续费收入
    Long withdrawnFee=0
    //提现银行手续费成本
    Long withdrawnBankCost=0

    //转账笔数
    Long transferCount = 0
    //转账金额
    Long transferAmount = 0
    //转账手续费收入
    Long transferFee =0
    //转账银行手续费成本
    Long transferBankCost =0


    static constraints = {
        area(nullable: true)
        cusName(nullable: true)
        cusAccountID(nullable: true)
        chargeTotalCount(nullable: true)
        chargeTotalAmount(nullable: true)
        withdrawnCount(nullable: true)
        withdrawnAmount(nullable: true)
        transferCount(nullable: true)
        transferAmount(nullable: true)
        chargeFee(nullable: true)
        chargeBankCost(nullable: true)
        withdrawnFee(nullable: true)
        withdrawnBankCost(nullable: true)
        transferFee(nullable: true)
        transferBankCost(nullable: true)
        dateCreated(nullable: true)
    }
}
