package ismp

class AcquireAccountTrade {

     /*账户*/
    String  acquirerAccountId
    /*订单号*/
    String  outTradeNo
    /*交易流水号*/
    String  outTradeOrderNo
    /*交易金额*/
    Long    amount      = 0
    /*退款金额*/
    Long    refundAmount      = 0
    /*交易币种*/
    String  currency    = 'CNY'
    /*交易状态*/
    String  status      = 'starting'
    /*v退货状态*/
    String  withdrawStatus      = 'starting'
    /*交易时间*/
    Date tradePayTime
    /*记账日期*/
    Integer tradeDate
    /*记录时间*/
    Date dateCreated

    static constraints = {
    }
    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator', params: [sequence_name: 'seq_acquire_acc_tra', initial_value: 1])
    }
}
