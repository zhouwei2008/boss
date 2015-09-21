package boss

class RolePerm {
  static mapping = {
        //id generator: 'sequence', params: [sequence: 'seq_role_perm']
  }

  Perm perm
  static belongsTo = [role: BossRole]

  static constraints = {
  }
}
