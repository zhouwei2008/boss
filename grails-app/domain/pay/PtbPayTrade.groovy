package pay

class PtbPayTrade {
    static mapping = {
        table 'TB_PAY_TRADE'
         version false
        id generator:"assigned", column:'TRADE_ID'
    }
    String tradeCode
    String tradeType
    String batchId
    String tradeCardtype
    String tradeCardnum
    String tradeCardname
    //开户总行
    String tradeBank
    //分行
    String tradeBranchbank
    //支行
    String tradeSubbank
    String tradeProvince
    String tradeCity
    String tradeAcctype
    Double tradeAmount
    String tradeAmttype
    String tradeUsercode
    String tradeCerttype
    String tradeCertno
    String tradeNote
    String outTradeorder
    Date tradeSubdate
    //0待处理 1处理中 2成功 3失败
    String tradeStatus
    String tradeReason
    Date tradeDonedate
    String tradeNote1
    String tradeNote2
    String tradeName
    Integer tradeBatchseqno
    String checkway
    static constraints = {

    }

    def static TradeStatusMap = ['0': '待处理', '1': '处理中', '2': '成功', '3': '失败']
    def static TradeTypeMap = ['S': '收款', 'F': '付款']
    def static TradeCardTypeMap=['16':'贷记卡','19':'借记卡']
    def static TradeAccTypeMap = ['0': '个人', '1': '公司']
    def static TradeCheckResultMap = ['2': 'succ', '3': 'fail']
    def static TradeCerttypeMap = ['身份证':'身份证','户口簿':'户口簿','护照':'护照','军官证':'军官证',
            '士兵证':'士兵证','台胞证':'台胞证',
            '0':'身份证','1': '户口簿','2':'护照','3':'军官证','4':'士兵证',
            '5': '台胞证']
}
