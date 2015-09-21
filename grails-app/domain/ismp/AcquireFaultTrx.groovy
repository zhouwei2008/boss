package ismp

class AcquireFaultTrx {
    String trxid               //系统交易号
    String acquireTrxnum;    //交易号
    String trxdate           //交易时间
    int trxamount;          //交易金额
    String acquireCode;      //收单行编码
    String acquireMerchant  //收单商户
    String acquireSeq        //收单流水
    String acquireRefnum      //参考号
    String acquireAuthcode   //授权号
    String acquireCardnum    //收单卡号
    String acquireDate       //收单日期
    String payerIp           //付款方IP

    int iniSts         //创建时的初始状态
    String authSts           //审核状态
    int changeSts         //处理成状态

    Date createDate        //创建时间
    Date updateDate        //更新时间
    Date authDate          //审核时间

    String finalSts          //处理状态
    String finalResult       //处理结果

    String changeApplier    //处理申请人
    String authOper         //审核人
    String datasrc          //数据来源
    String faultAdvice     //处理意见

    String batchnum        //处理批号

    static constraints = {
        trxid(nullable: false, maxsize: 19)
        acquireTrxnum(nullable: false, maxsize: 64)
        trxdate(size: 0..14, blank: true)
        iniSts(inList: [0, 1, 2, 3])
        changeSts(inList: [1, 2, 3])
        authSts(inList: ['Y', 'N', 'F', 'U'], nullable: false)
        datasrc(inList: ['MANUAL', 'AUTOCHECK', 'OTHER', 'FILE'], nullable: true)

        acquireCode(nullable: false, maxsize: 64)
        acquireAuthcode(maxsize: 6, blank: true, nullable: true)
        acquireCardnum(maxSize: 19, blank: true, nullable: true)
        acquireDate(maxsize: 14, blank: true, nullable: true)
        acquireRefnum(maxsize: 64, blank: true, nullable: true)
        acquireSeq(maxsize: 128, blank: true, nullable: true)
        payerIp(maxsize: 30, blank: true, nullable: true)

        finalSts(inList: ['SUCCESS', 'FAILURE', 'WAIT', 'CLOSED', 'OPERATING'])
        authOper(blank: true, maxsize: 20, nullable: true)
        faultAdvice(blank: true, maxsize: 256, nullable: true)
        finalResult(blank: true, nullable: true, maxsize: 256)

        batchnum(blank: true, maxsize: 64, nullable: true)
    }
    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_orderext']
    }

    static finalStsMap = ['SUCCESS': '成功', 'FAILURE': '失败', 'WAIT': '等待', 'CLOSED': '关闭', 'OPERATING': '打开']

    static datasrcMap = ['MANUAL': '手动', 'AUTOCHECK': '自动', 'OTHER': '其他', 'FILE': '文本']

    static iniStsMap = [0: '未支付', 1: '付款成功', 2: '付款失败', 3: '交易关闭', 5: '交易状态不确定']

    static changeStsMap = [1: '付款成功', 2: '付款失败', 3: '交易关闭']

    static authStsMap = ['Y': '审核通过', 'U': '不审核', 'N': '未审核', 'F': '未通过']

}