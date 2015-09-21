package boss

class BossRole {

    String roleName
    Date dateCreated
    static hasMany = [ rolePerms : RolePerm ]

    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_boss_role']
    }
    static constraints = {
      roleName(unique: true)
      rolePerms(nullable: true)
    }
}

