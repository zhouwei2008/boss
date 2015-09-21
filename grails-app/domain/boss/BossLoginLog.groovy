package boss


class BossLoginLog {

    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator',params: [sequence_name: 'seq_boss_login_log', initial_value: 1])
        sort id:"desc"
    }

    BoOperator boOperator
    Date dateCreated
    String loginIp
    String loginResult

    static constraints = {
        boOperator()
        loginIp(maxSize:20,blank: false)
        loginResult(maxSize:50,blank: false)
    }
}
