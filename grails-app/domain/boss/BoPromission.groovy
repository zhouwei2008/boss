package boss

class BoPromission {
    String promissionName
    String promissionCode
    String status
//    int  level
//    int parentId
//    String promUrl
     static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_bo_promission']
    }

    static constraints = {
      promissionCode(unique: true)
    }

    static statusMap=['1':'正常','2':'停用']
}
