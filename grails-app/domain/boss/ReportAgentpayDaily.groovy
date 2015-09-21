package boss

class ReportAgentpayDaily {

  static mapping = {
     table 'report_agentpay_daily'
     version false
     id generator: 'sequence', params: [sequence: 'SEQ_REPORTAGENTPAY']
  }
  /*交易总笔数*/
  Long   count=0
  /*交易总金额*/
  Double amount=0

  /*对账成功总笔数*/
  Long   tradeCountSuccess=0
  /*对账失败总笔数*/
  Long   tradeCountFail=0
  /*对账成功总金额*/
  Double tradeAmountSuccess=0
  /*对账失败总金额*/
  Double tradeAmountFail=0
  /*结算总金额*/
  Double tradeSettleAmount=0
  /*手续费总收入*/
  Double tradeSettleFee=0
  /*结算日期*/
  Date   tradeFinishdate
  /*商户号*/
  String customerNo
  /*交易类型　S:代收 F:代付*/
  String tradeType

  /*结算日*/
  String   daily

  /*交易净额*/
  Double netAmount=0


   /*商户ID*/
  String   customerId

  /*商户类型 P:个人,C:企业*/
  String   customerType

  static constraints = {
     count(nullable:true)
     amount(nullable:true)
     tradeCountSuccess(nullable:true)
     tradeCountFail(nullable:true)
     tradeAmountSuccess(nullable:true)
     tradeAmountFail(nullable:true)
     tradeSettleAmount(nullable:true)
     tradeSettleFee(nullable:true)
     tradeFinishdate(nullable:true)
     customerNo(nullable:true)
     tradeType(nullable:true)
     daily(nullable:true)
     netAmount(nullable:true)
     customerType(nullable:true)
     customerId(nullable:true)
  }

   def  clear(){
     count=0
     amount=0
     tradeCountSuccess=0
     tradeCountFail=0
     tradeAmountSuccess=0
     tradeAmountFail=0
     tradeSettleAmount=0
     tradeSettleFee=0
     netAmount=0
   }

  def static typeMap=['F':'代付','S':'代收']

    def static customerTypeMap=['':'全部','P':'个人','C':'企业']

    def static selTypeMap = ['2': '全部显示', '1': '只显示有交易商户','0':'只显示无交易商户']
}

