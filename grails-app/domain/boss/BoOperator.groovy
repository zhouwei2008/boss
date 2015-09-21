package boss

class BoOperator {

    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_bo_operator']
    }
    String account
    String password
    String name
    String status = 'normal'
    String roleSet = 'admin'
    int loginErrorTime = 0
    Date lastLoginTime
    Date dateCreated
    Date lastUpdated
    String email
    String mobile
    BossRole role
    Date lastChangeTime


    //guonan update branchcommpany 2012-02-17
    String branchCompany

    //guonan update belongToSale 2012-06-27
//    String belongToSale
    String loginIp
    static constraints = {
        lastLoginTime(nullable: true)
        branchCompany(nullable: true)
        loginIp(nullable: true)
//        belongToSale(nullable: true)
    }

    def static statusMap = ['normal': '正常', 'disabled': '停用', 'deleted': '删除','locked':'锁定']
}
