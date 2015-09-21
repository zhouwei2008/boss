package boss

class BoDirectPayBind {

static mapping = {
    id generator: 'sequence', params: [sequence: 'seq_bo_directpaybind']
    tablePerHierarchy false
  }
  //收款客户号
  String customerNo
  //付款客户号
  String payCustomerNo
  //付款客户账号
  String accountNo
  //限额
  Double limiteAmount

  static constraints = {
    customerNo()
    payCustomerNo()
    accountNo(nullable:false)
    limiteAmount(nullable:true)
  }
}