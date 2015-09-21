package boss

class BoMerchant {
    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_bo_merchant']
    }
    //银行收单码
    String acquireIndexc
    //收单商户号
    String acquireMerchant
    //收单终端号
    String terminal
    //收单机构名称
    String acquireName
    //系统编码
    String serviceCode
    //通道类型: 1:网上银行
    String channelType
    //付款类型 :0:立即到账 1 担保
    String paymentType
    //付款方式 :0:借记卡 1贷记 2 ALL
    String paymentMode
    //通道状态 :0 可用 1 停用
    String channelSts
    //通道备注
    String channelDesc
    //每日限额
    Double dayQutor
    //单笔限额
    Double qutor
    //收单账户
    BoAcquirerAccount acquirerAccount
    //创建时间
    Date dateCreated
    //更新时间
    Date lastUpdated
    //通道类型：2大额通道1普通通道
    String bankType
    static hasMany = [ paySrvBanks : BoPaySrvBank ]
    static constraints = {
        acquireIndexc(size: 1..20, blank: false)
        acquireMerchant(size: 1..64, blank: false)
        terminal(size: 1..10, blank: false)
        acquireName(size: 1..20, blank: false)
        serviceCode(size: 1..10, blank: false)
        channelType(size: 1..2, blank: false)
        paymentType(size: 1..2, blank: false)
        paymentMode(size: 1..2, blank: false)
        channelSts(size: 1..2, blank: false)
        channelDesc(size: 1..128, nullable: true)
        dayQutor(nullable: false)
        qutor(nullable: false)
        paySrvBanks(nullable: true)
    }
    def static channelTypeMap = ['1': 'B2C网银','2': 'B2B网银','3':'预付费卡','4':'吉高账户','S':'收款','F':'付款']
    def static paymentTypeMap = ['0': '立即到账', '1': '担保']
    def static paymentModeMap = ['0': '借记卡', '1': '贷记', '2': 'ALL']
    def static statusMap = ['0': '可用', '1': '停用']
    def static bankTypeMap=['2':'大额通道','1':'普通通道','3':'打款通道']
}
