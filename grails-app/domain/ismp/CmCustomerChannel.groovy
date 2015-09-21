package ismp

class CmCustomerChannel {

    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator',params: [sequence_name: 'seq_cm_customer_channel', initial_value: 1])
    }

    CmCustomer customer
     //通道类型: 1:b2c借记 ；2：b2c贷记；3:b2b
    String channelType
    //付款类型 :0:立即到账 1 担保
    String paymentType
    //付款方式 :1:借记卡 2贷记 3:借记和贷记
    String paymentMode
     //通道类型：2大额通道1普通通道
    String bankType
    //所属银行编码
    String bankCode
    //渠道银行编码
    String channelCode



    static constraints = {
        channelType(size: 1..2, blank: false)
        paymentType(size: 1..2, blank: false)
        paymentMode(size: 1..2, blank: false)
        bankType(size: 1..2, blank: false)
        bankCode(size: 1..64, blank: false)
        channelCode(size: 1..64, blank: false)
    }
}
