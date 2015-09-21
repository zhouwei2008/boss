package boss

class BoVerify {

    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_bo_verify']
    }
    Integer fromAcqId      //关联ID
    Integer toAcqId
    Date dateCreated  //创建时间
    String type   //类型
    String outBankCode                        //转出银行CODE码
    String outBankName                        //转出银行名称
    String outBankAccountNo    //转出银行账户号
    String outBankAccountName    //转出银行账户名称
    Double outRemainAmount      //账户余额
    Double outAmount      //转出金额
    String accountNo            // 帐户号
    String accountName         // 帐户名称
    String inBankCode                        //转入银行CODE码
    String inBankName                        //转入银行名称
    String inBankAccountNo    //转入银行账户号
    String inBankAccountName    //转入银行账户名称
    Double inRemainAmount      //账户余额
    String status                        //状态
    String operNo        //操作员编号
    String operName       //操作员名称
    String appNo          //审核员编号
    String appName        //审核员名称
    Date appDate          //审核日期
    String note          //备注


    static constraints = {
        fromAcqId(nullable: true)
        toAcqId(nullable: true)
        dateCreated(nullable: true)
        type(size: 1..2, nullable: true)
        status(size: 1..2, nullable: true)
        outBankCode(size: 1..10, nullable: true)
        outBankName(size: 1..64, nullable: true)
        outBankAccountNo(size: 1..32, nullable: true)
        outBankAccountName(size: 1..40, nullable: true)
        outRemainAmount( nullable: true)
        outAmount( nullable: true)
        accountNo(size: 1..18, nullable: true)
        accountName(size: 1..64, nullable: true)
        inBankCode(size: 1..10, nullable: true)
        inBankName(size: 1..64, nullable: true)
        inBankAccountNo(size: 1..32, nullable: true)
        inBankAccountName(size: 1..64, nullable: true)
       inRemainAmount( nullable: true)
        note(size: 1..100, nullable: true)
        appName(nullable:true)
        appDate(nullable:true)
        appNo(nullable:true)
    }

    def static typeMap = ['1': '充值', '2': '提款', '3': '转帐']
    def static statusMap = ['0': '待处理', '1': '通过', '2': '拒绝']
}
