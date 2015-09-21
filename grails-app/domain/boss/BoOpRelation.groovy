package boss
/**
 * 记录操作日志controller,action,名称对应关系
 */
class BoOpRelation {
      String controllers
      String actions
      String names
    static mapping = {
    id generator: 'sequence', params: [sequence: 'seq_bo_oprelation']
  }
    static constraints = {
        controllers(unique:'actions')

  }



}
