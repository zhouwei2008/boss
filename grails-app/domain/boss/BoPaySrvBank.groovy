package boss
//服务银行列表
class BoPaySrvBank {
  static mapping = {
    id generator: 'sequence', params: [sequence: 'seq_bo_paysrvbank']
  }
  //大额额度
  Long quota

  static belongsTo = [bank: BoMerchant, service: BoCustomerService]
  static constraints = {
     quota(nullable: true)
  }
}
