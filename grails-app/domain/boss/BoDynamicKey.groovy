package boss

class BoDynamicKey {

    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator',params: [sequence_name: 'seq_bo_dynamic_key', initial_value: 1])
    }

    BoOperator boOperator
    Date dateCreated
    String sendType
    String sendTo
    String  parameter
    String  key
    String procMethod
    String  verification
    Date timeExpired
    Date timeUsed
    Boolean isUsed
    String  useType

    static constraints = {
        boOperator()
        sendTo(maxSize:64,blank: false)
        sendType(maxSize:8,blank: false)
        parameter(maxSize:36,blank: false)
        key(maxSize:32,blank: false)
        procMethod(maxSize:8,blank: false)
        verification(maxSize:36,blank: false)
        timeUsed(nullable: true)
        useType(maxSize: 16,blank:false)
    }

}
