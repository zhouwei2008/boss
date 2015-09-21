package ismp

class CmCustomerOperator {

    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator',params: [sequence_name: 'seq_cm_customer_operator', initial_value: 1])
    }

    CmCustomer customer
    String  name
    String loginPassword
    String payPassword
    String defaultEmail
    String defaultMobile
    Date dateCreated
    Date lastUpdated
    int loginErrorTime=0
    Date lastLoginTime
    String  status
    String roleSet
    String loginFlag

    static constraints = {
        customer()
        name(maxSize:32,blank: false)
        defaultEmail(maxSize:64,blank: false)
        defaultMobile(maxSize:16,nullable: true)
        status(maxSize:16,inList:['init','normal','disabled','locked','deleted'],blank: false)
        roleSet(maxSize:64,inList:['3','2','1'],blank: false)
        loginPassword(maxSize:40,nullable: true)
        payPassword(maxSize:40,nullable: true)
        lastLoginTime(nullable: true)
        loginFlag nullable:true
    }

    String toString() {
        return "${name}(${id})"
    }

    def static roleSetMap = ['3': '普通用户', '2': '财务','1': '管理员']
    def static statusMap = ['init':'受限','normal': '正常', 'disabled': '停用', 'deleted': '删除','locked':'锁定']
}
