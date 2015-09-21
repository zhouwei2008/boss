package settle
/**
 * 交易费率设置
 */
class FtTradeFee {
    //所属客户号
    String customerNo
    //所属业务类型
    FtSrvType srv
    //所属交易类型
    FtSrvTradeType tradeType
    //收取方向
    Integer tradeWeight
    //结算方式，0为即扣，1为后返
    Integer fetchType
    //费率类型，0为按比收，1为按比率收  2为包流量
    Integer feeType =-1
    //费率设置，费率类型为按笔收的话为每笔交易多少钱；费率类型为按比例收的话为交易金额收取费率的比例；
    Double feeValue
    //费率通道
    String channelCode
    //计费模式 0为固定, 2为交易量
    Integer feeModel
    //最低手续费
    Double feeMin = 0.0
    //最高手续费
    Double feeMax = 0.0
    //有效期开始
    Date dateBegin
    //有效期结束
    Date dateEnd
    //包年包月周期长度
    Integer packLen
    //包年包月类型
    Integer packType
    //首结日
    Date firstLiqDate
    //费率到期提示
    Boolean isViewDate = false
    //费率80%提示
    Boolean isViewPer = false
    //费率80%提示 是否已发信
    Boolean isViewPerMail = false
    //费率超量提示
    Boolean isViewOver = false
    //费率超量提示 是否已发信
    Boolean isViewOverMail = false
    //流量限额 单位 元
    Double feeFlow = 0.0
    //预付手续费 单位 元
    Double feePre = 0.0
    //已使用流量 单位 分
    Long feeUsedFlow = 0
    //预付手续费 对应结算单批号
    String footNo
    //审核状态
    String isverify = '0'


    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_trade_fee']
        tablePerHierarchy false
    }

    static constraints = {
        customerNo(maxSize: 24, nullable: false)
        tradeWeight(nullable: false)
        fetchType(nullable: false)
        feeMax nullable: true
        feeType(nullable: true)
        feeValue(nullable: true)
        feeMin nullable: true
        packLen nullable: true
        packType nullable: true
        firstLiqDate nullable: true
        channelCode nullable: true
        isViewDate(nullable:true)
        isViewPer(nullable:true)
        isViewOver(nullable:true)
        feeFlow(nullable:true)
        feeUsedFlow(nullable:true)
        feePre(nullable:true)
        footNo(nullable:true)
        isverify(nullable:true)
    }


    def static fetchtypeMap = ['0': '即收', '1': '后返']
    def static feetypeMap = ['0': '按笔收(元)', '1': '按比率收(%)']
    def static settleMap = ['0': '固定']
    def static tradeWeightMap = [1: '收取', 0: '返还']
    def static categoryMap = [0: '固定', 2: '交易量']
    def static feeTypeMap = [1: '按流量', 0: '按笔' ]
    def static feeType2Map = [0: '按笔', 1: '按流量', 2: '包流量']
    def static fetchTypeMap = [0: '即扣', 1: '后返']
    def static packTypeMap = [0: '月', 1: '年']
    def static isverifyMap = [0:'未审核',1:'已审核']
//     def static srvcodeMap = ['onlinepay': '在线支付', 'agentreceive': '代收']
}
