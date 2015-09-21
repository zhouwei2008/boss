package ismp

class TradeRefund extends TradeBase{

    String  submitBatch
    String  submitType
    Long    customerOperId
    String  submitter
    Long    backFee
    Long    realRefundAmount
    Long    realityRefundAmount=0  // 实际退款金额 贺连鑫 20120319
    Long    refundedAmount=0      // 已退订单金额   贺连鑫
    String  refundType
    String  refundParams
    String  royaltyRefundStatus
    String  acquirerCode
    String  acquirerMerchantNo
    Long    acquirer_account_id
    String  checkStatus
    Long    checkOperatorId
    Date    checkDate
    Long    handleOperId
    String  handleOperName
    String  handleBatch
    String  handleCommandNo
    String  handleStatus
    Date    handleTime
    //2012-01-09新增
    String channel
    String trxnum
    //2012-02-20  add by zhouwei
    //退款批次号对应批次表中的id
    String refundBatchNo
    //初审时间
    Date firstAppDate
    //初审人
    String firstAppName
    //ID
    Long firstAppId
    //退款处理时间
    Date refundHandleDate
    //退款处理人
    String refundHandleName
    //ID
    Long refundHandleId
    //终审时间
    Date lastAppDate
    //终审人
    String lastAppName
    //ID
    Long lastAppId
    //退款复核时间
    Date refundRecheckDate
    // 退款复核人
    String refundRecheckName
    //ID
    Long refundRecheckId

    String refundBankType

    //交易表支付宝流水号
    String acquirerSeq

    static constraints = {
        submitBatch(maxSize: 16,blank: false)
        submitType(maxSize: 32,inList: ['manual','automatic'])
        customerOperId(nullable: true)
        submitter(maxSize: 32)
        refundType(maxSize: 16,inList: ['normal','royalty'])
        refundParams(maxSize: 512,nullable: true)
        royaltyRefundStatus(maxSize: 16,inList: ['starting','processing','successed','failed'])
        acquirerCode(maxSize: 16,nullable: true)
        acquirerMerchantNo(maxSize: 20,nullable: true)
        checkStatus(maxSize: 16)
        checkOperatorId(nullable: true)
        checkDate(nullable: true)
        handleOperId(nullable: true)
        handleOperName(maxSize: 16,nullable: true)
        handleBatch(maxSize: 16,nullable: true)
        handleCommandNo(maxSize: 40,nullable: true)
        handleStatus(maxSize: 16,inList: ['waiting','fChecked','checked','fRefuse','sRefuse','submited','completed','success','fail','refFail'])
        handleTime(nullable: true)
        channel(nullable:true)
        trxnum(nullable:true)
        refundBatchNo nullable:true
        firstAppDate nullable:true
        firstAppId nullable:true
        firstAppName nullable:true
        lastAppDate nullable:true
        lastAppId nullable:true
        lastAppName nullable:true
        refundHandleDate nullable:true
        refundHandleId nullable:true
        refundHandleName nullable:true
        refundRecheckDate nullable:true
        refundRecheckId nullable:true
        refundRecheckName nullable:true
        refundBankType(nullable: true)
        refundedAmount(nullable: true)
        realityRefundAmount(nullable: true)
        acquirerSeq(nullable: true)
    }

    def static submitTypeMap = ['manual': '人工提交', 'automatic': '接口提交']
    def static refundTypeMap = ['normal': '普通退款', 'royalty': '分润退款']
    def static royaltyRefundStatusMap = ['starting': '开始', 'processing': '处理中','successed':'成功','failed':'失败']
    def static handleStatusMap = ['waiting': '待处理','fChecked':'初审通过', 'checked': '处理中','fRefuse':'初审拒绝','sRefuse':'终审拒绝','submited':'已提交','completed':'退款成功','success':'成功状态','fail':'失败状态','refFail':'退款失败']
    def static handleMap = ['fRefuse':'初审拒绝','sRefuse':'终审拒绝','completed':'完毕']
    def static channelMap = ['1': 'B2C网银','2': 'B2B网银','3':'预付费卡','4':'吉高账户','5':'现金']
    def static refundBankTypeMap = ['0':'B2C线上退款','1':'B2B线上退款','2':'B2B线下退款']
}
