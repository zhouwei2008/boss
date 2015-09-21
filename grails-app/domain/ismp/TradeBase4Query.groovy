package ismp

class TradeBase4Query {
    Long    rootId
    Long    originalId
    String  tradeNo
    String  tradeType
    String  payerCode
    String  payerName
    String  payerAccountNo
    String  payeeCode
    String  payeeName
    String  payeeAccountNo
    String  outTradeNo
    Long    amount      = 0
    Long    feeAmount   = 0
    String  currency    = 'CNY'
    String  subject
    String  status      = 'starting'
    Integer tradeDate
    String  note
    Date    dateCreated
    Date    lastUpdated
    String  paymentType
    String  serviceType

    CmCustomer4Query partner
    CmCustomer4Query payer
    CmCustomer4Query payee

    static constraints = {}

    static mapping = {
        // id      generator: 'sequence', params: [sequence: 'seq_trade']
        table   'trade_base'
        cache   usage: 'read-only'
        version false
    }
}
