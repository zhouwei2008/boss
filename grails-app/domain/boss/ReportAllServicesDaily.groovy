package boss

class ReportAllServicesDaily {

  static mapping = {
      id generator: 'sequence', params: [sequence: 'SEQ_REPORTALLBIZ']
       version false
  }
  /*在线支付交易总笔数*/
  Long   onlineTradeCount=0
  /*在线支付交易净额*/
  Double onlineTradeNetAmount=0
  /*在线支付手续费总收入*/
  Double onlineTradeNetFee=0
  /*在线支付银行手续费成本*/
  Double onlineTradeBankFee=0

  /*代收交易总笔数*/
  Long   agentcollTradeCount=0
  /*代收交易净额*/
  Double agentcollTradeNetAmount=0
  /*代收手续费总收入*/
  Double agentcollTradeNetFee=0
  /*代收银行手续费成本*/
  Double agentcollTradeBankFee=0

  /*代付交易总笔数*/
  Long   agentpayTradeCount=0
  /*代付交易净额*/
  Double agentpayTradeNetAmount=0
  /*代付手续费总收入*/
  Double agentpayTradeNetFee=0
  /*代付银行手续费成本*/
  Double agentpayTradeBankFee=0


  /*分润交易总笔数*/
  Long   royaltyTradeCount=0
  /*分润交易净额*/
  Double royaltyTradeNetAmount=0
  /*分润手续费总收入*/
  Double royaltyTradeNetFee=0
  /*分润银行手续费成本*/
  Double royaltyTradeBankFee=0
    
  /*充值交易总笔数*/
  Long   chargeTradeCount=0
  /*充值交易净额*/
  Double chargeTradeNetAmount=0
  /*充值手续费总收入*/
  Double chargeTradeNetFee=0
  /*充值银行手续费成本*/
  Double chargeTradeBankFee=0


  /*提现交易总笔数*/
  Long   withdrawnTradeCount=0
  /*提现交易净额*/
  Double withdrawnTradeNetAmount=0
  /*提现手续费总收入*/
  Double withdrawnTradeNetFee=0
  /*提现银行手续费成本*/
  Double withdrawnTradeBankFee=0


  /*转账交易总笔数*/
  Long   transferTradeCount=0
  /*转账交易净额*/
  Double transferTradeNetAmount=0
  /*转账手续费总收入*/
  Double transferTradeNetFee=0
  /*转账银行手续费成本*/
  Double transferTradeBankFee=0


  /*结算日期*/
  Date   tradeFinishdate
  /*商户号*/
  String customerNo
   /*服务代码*/
  String serviceCode

   /*结算日*/
  String   daily

    /*商户类型 P:个人,C:企业*/
  String   customerType

       /*商户ID*/
  String   customerId

  static constraints = {
     onlineTradeCount(nullable:true)
     onlineTradeNetAmount(nullable:true)
     onlineTradeNetFee(nullable:true)
     onlineTradeBankFee(nullable:true)
     agentcollTradeCount(nullable:true)
     agentcollTradeNetAmount(nullable:true)
     agentcollTradeNetFee(nullable:true)
     agentcollTradeBankFee(nullable:true)
     agentpayTradeCount(nullable:true)
     agentpayTradeNetAmount(nullable:true)
     agentpayTradeNetFee(nullable:true)
     agentpayTradeBankFee(nullable:true)
     royaltyTradeCount(nullable:true)
     royaltyTradeNetAmount(nullable:true)
     royaltyTradeNetFee(nullable:true)
     royaltyTradeBankFee(nullable:true)
     chargeTradeCount(nullable:true)
     chargeTradeNetAmount(nullable:true)
     chargeTradeNetFee(nullable:true)
     chargeTradeBankFee(nullable:true)
     withdrawnTradeCount(nullable:true)
     withdrawnTradeNetAmount(nullable:true)
     withdrawnTradeNetFee(nullable:true)
     withdrawnTradeBankFee(nullable:true)
     transferTradeCount(nullable:true)
     transferTradeNetAmount(nullable:true)
     transferTradeNetFee(nullable:true)
     transferTradeBankFee(nullable:true)
     tradeFinishdate(nullable:true)
     customerNo(nullable:true)
     serviceCode(nullable:true)
     daily(nullable:true)
     customerType(nullable:true)
     customerId(nullable:true)
  }

   def  clear(){
     onlineTradeCount=0
     onlineTradeNetAmount=0
     onlineTradeNetFee=0
     onlineTradeBankFee=0
     agentcollTradeCount=0
     agentcollTradeNetAmount=0
     agentcollTradeNetFee=0
     agentcollTradeBankFee=0
     agentpayTradeCount=0
     agentpayTradeNetAmount=0
     agentpayTradeNetFee=0
     agentpayTradeBankFee=0
     royaltyTradeCount=0
     royaltyTradeNetAmount=0
     royaltyTradeNetFee=0
     royaltyTradeBankFee=0
     chargeTradeCount=0
     chargeTradeNetAmount=0
     chargeTradeNetFee=0
     chargeTradeBankFee=0
     withdrawnTradeCount=0
     withdrawnTradeNetAmount=0
     withdrawnTradeNetFee=0
     withdrawnTradeBankFee=0
     transferTradeCount=0
     transferTradeNetAmount=0
     transferTradeNetFee=0
     transferTradeBankFee=0
   }
  def static serviceMap = ['online': '在线支付', 'royalty': '分润','agentcoll':'代收','agentpay':'代付', 'transfer': '转账','charge':'充值','withdrawn':'提现']

     def static customerTypeMap=['P':'个人','C':'企业']
     def static selTypeMap = ['2': '全部显示', '1': '只显示有交易商户','0':'只显示无交易商户']

}
