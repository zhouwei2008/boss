package ismp

class TradeWithdrawn extends TradeBase {

    String submitType
    Long customerOperId
    String submitter
    Long transferFee
    Long realTransferAmount
    Long customerBankAccountId
    String customerBankCode
    String customerBankNo
    String customerBankAccountNo
    String customerBankAccountName
    Boolean isCorporate
    Long acquirerAccountId
    String checkStatus = 'waiting'
    Long checkOperatorId
    Date checkDate
    Long handleOperId
    String handleOperName
    String handleBatch
    String handleCommandNo
    String handleStatus
    Date handleTime
    //
    Date firstAppDate
    String firstAppName
    Long firstAppId
    Date lastAppDate
    String lastAppName
    Long lastAppId
    Date withHandleDate
    String withHandleName
    Long withHandleId
    Date withReHandleDate
    String withReHandleName
    Long withReHandleId
    String withdrawnBatchNo
    String accountProvince
    String accountCity

    static constraints = {
        submitType(maxSize: 32, inList: ['manual', 'automatic'])
        submitter(maxSize: 32)
        customerBankCode(maxSize: 16, nullable: true)
        customerBankNo(maxSize: 16)
        customerBankAccountNo(maxSize: 32)
        customerBankAccountName(maxSize: 40)
        acquirerAccountId(nullable: true)
        checkStatus(maxSize: 16)
        checkOperatorId(nullable: true)
        checkDate(nullable: true)
        handleOperId(nullable: true)
        handleOperName(maxSize: 16, nullable: true)
        handleBatch(maxSize: 16, nullable: true)
        handleCommandNo(maxSize: 40, nullable: true)
        handleStatus(maxSize: 16, inList: ['waiting','fChecked','checked','fRefuse','sRefuse','submited','completed','success','fail','refFail'])
        handleTime(nullable: true)
        firstAppDate nullable: true
        firstAppName nullable: true
        firstAppId nullable: true
        lastAppDate nullable: true
        lastAppName nullable: true
        lastAppId nullable: true
        withHandleDate nullable: true
        withHandleName nullable: true
        withHandleId nullable: true
        withReHandleDate nullable: true
        withReHandleName nullable: true
        withReHandleId nullable: true
        withdrawnBatchNo nullable:true
        accountProvince  nullable:true
        accountCity   nullable:true
    }

    def static submitTypeMap = ['manual': '人工申请', 'automatic': '自动提现']
    def static handleStatusMap = ['waiting': '待处理','fChecked':'初审通过', 'checked': '处理中','fRefuse':'初审拒绝','sRefuse':'终审拒绝','submited':'已提交','completed':'提现成功','success':'成功状态','fail':'失败状态','refFail':'提现失败']
    def static handleNotAllStatusMap = ['success':'成功状态','fail':'失败状态']
    def static handleFristStatusMap = ['fChecked':'初审通过','fRefuse':'初审拒绝']
    def static isCorporateMap = ['true': '是', 'false': '否']
}
