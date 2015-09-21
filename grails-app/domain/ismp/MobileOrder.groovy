package ismp

class MobileOrder {

    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator',params: [sequence_name: 'seq_mobile_order', initial_value: 1])
    }
    CmCustomer customer
    String orderTitle
    String orderDetail
    Long amount
    Date dateCreated
    Date lastUpdated
    String status

    static constraints = {
        customer()
        orderTitle(maxSize:64,nullable: true)
        orderDetail(maxSize:64)
        amount()
        status(maxSize:16,inList:['created','completed','canceled','refused'])
    }

    def static statusMap = ['created':'等待支付', 'completed':'支付完成', 'canceled':'撤销', 'refused':'风控拒绝']
}
