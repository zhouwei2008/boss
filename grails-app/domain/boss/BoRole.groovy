package boss

class BoRole {

    String roleName
    String roleCode
    String status
    String permission_id

    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_bo_role']
    }
    static constraints = {
        permission_id(nullable: true)
        roleCode(unique: true)

    }

    static statusMap=['1': '正常', '2': '停用']
}
