package boss

class BoOfflineCharge {

     static mapping = {
    }
    String trxSeq;           //交易流水
    Date createdate;    //创建时间
    String trxtype;          //充值(charge)、充值撤销(void)

    String oldSeq; //原交易流水

    Long amount;            //充值金额（充到虚拟账户金额）
    Long realamount;     //到账金额
    String accountNo;     //充值账号
    String accountName;  //账户名称

    String billmode;        //到账方式[现金cashier,支票check,转账transfer,其他other]
    String recepit;          //凭证号
    String billdate;         //到账日期
    String billref;            //参考号
    String recepitacct;  //到账账户号
    String billext;            //到账备注

        String status;      //交易状态[完成Y,待处理N，处理中P,失败F,取消C]

    String authsts;    //审核状态[待审N,审核中P,审核通过Y,审核拒绝F]
    Date   authdate;  //审核时间
    String authdesc;  //审核备注

    String voidstatus;  //撤销状态[已撤销Y,处理中N]

    String creator_id;       //申请人ID
    String creator_name; //申请人name
    String create_desc;   //申请说明

    String author_id;       //最终审核人ID
    String author_name; //最终审核人name

    String note;              //备注
    String batchnum;     //批号

    String branchcode;//分公司编码
    String branchname; //分公司名称



    static constraints = {

        trxSeq(size: 1..25, blank: false)
        createdate(nullable: false)
        trxtype(size: 1..10)
        oldSeq(size: 1..25, nullable: true)
        accountNo(size: 1..25, blank: false)
        accountName(size: 1..32,nullable: true)
        billmode(size: 1..10, blank: false)
        recepit(size: 1..25, nullable: true)
        billdate(nullable: true)
        billdate(nullable: true)
        billref(nullable: true)
        recepitacct(nullable: true)
        billext(nullable: true)
        amount()
        realamount()
        status(size: 1..2, blank: false)
        authsts(size: 1..2,nullable: true)
        authdate(nullable: true)
        authdesc(nullable: true)
        creator_id(nullable: true)
        creator_name(nullable: true)
        create_desc(nullable: true)
        author_id(nullable: true)
        author_name(nullable: true)
        note(nullable: true)
        batchnum(nullable: true)
        branchcode(nullable: true)
        branchname(nullable: true)
        voidstatus(nullable: true)
    }
    def static billmodeMap = ['cashier': '现金', 'check': '支票', 'transfer': '转账', 'other': '其他']
    def static statusMap = ['Y': '完成', 'N': '待处理','P':'处理中','F':'失败','C':'取消']
    def static authstsMap = ['N': '待审', 'P': '审核中','Y':'审核通过','F':'审核拒绝']
    //zhangwei  add
    def static trxtypeMap=['charge':'充值','void':'撤销']
}
