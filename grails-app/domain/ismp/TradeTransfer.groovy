package ismp

class TradeTransfer extends TradeBase{

    String  submitType
    Long    customerOperId
    String  submitter
    String  submitIp

    static constraints = {
        submitType(maxSize: 32,inList: ['manual','automatic'])
        submitter(maxSize: 32)
        submitIp(maxSize: 20)
    }
    def static submitTypeMap = ['manual': '人工提交', 'automatic': '接口提交']
}
