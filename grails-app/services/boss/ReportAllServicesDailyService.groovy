package boss

import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import ismp.CmCustomer
import groovy.sql.Sql

class ReportAllServicesDailyService {

    static transactional = true

    def integrate(day) {
        def agents=[:]
        if(!isExist(agents,day)){
          importOnline(agents,day)
          importDsf(agents,day)
          importRoyalty(agents,day)
          importOther(agents,day)
	      updateCustomerType(agents)
        }
        agents.clear()
    }


    /**
     * 判断是否当日统计，如存在，则查询出全部，放入Map，键为"商户号"，值为"ReportAllServicesDaily每日统计报表对象"
     *
     * @param agents   Map<String,ReportAllServicesDaily>
     * @param day      Date记账日期
     * @return 0:不存在,1:存在
     * @author guonan  2012-02-29
     *
     */
    def isExist(agents,day){
        //每日统计标记
        def daily =  day.format("yyyyMMdd")
        //查询是否已经存在当日统计
        def  reportAllServicesDailys = ReportAllServicesDaily.findAllByDaily(daily)
        println 'isExist reportAllServicesDailys = '+reportAllServicesDailys
        if(reportAllServicesDailys!=null&&reportAllServicesDailys.size()>0){
             reportAllServicesDailys.each { df->
                  agents[df.customerNo]=df
                  df.clear()
             }
             return 0
        }else{
             return 0
        }
    }
    /**
     * 查询在线支付，ReportOnlinePayDaily表，存入Map，键为"商户号"，值为"ReportAllServicesDaily每日统计报表对象"
     *
     * @param agents   Map<String,ReportAllServicesDaily>
     * @param day      Date记账日期
     * 
     * @author guonan  2012-02-29
     *
     */
    def  importOnline(agents,day){
      def daily = day.format("yyyyMMdd")
      def result = ReportOnlinePayDaily.findAllByDailyFlag(daily)

          println 'importOnline result = '+result

          result?.each {
             def customerNo =  it.customerNo as String
             ReportAllServicesDaily df = agents[customerNo]
             if(df==null){
                  df = new ReportAllServicesDaily()
                  agents[customerNo]=df
             }
             df.onlineTradeNetFee= it.feeAmount
             df.onlineTradeCount= ((it.bankPayNum?it.bankPayNum:0) as Long)+((it.balancePayNum?it.balancePayNum:0) as Long) +((it.bankRefundNum?it.bankRefundNum:0) as Long) +  ((it.balanceRefundNum?it.balanceRefundNum:0) as Long)
             df.onlineTradeNetAmount= ((it.bankPayAmount?it.bankPayAmount:0) as Long)+((it.balancePayAmount?it.balancePayAmount:0) as Long) -((it.bankRefundAmount?it.bankRefundAmount:0) as Long) - ((it.balanceRefundAmount?it.balanceRefundAmount:0) as Long)
             df.tradeFinishdate  = day
             df.daily = daily
             df.customerNo   = customerNo
          }
    }

    /**
     * 查询代收付，ReportAgentpayDaily表，存入Map，键为"商户号"，值为"ReportAllServicesDaily每日统计报表对象"
     *
     * @param agents   Map<String,ReportAllServicesDaily>
     * @param day      Date记账日期
     * 
     * @author guonan  2012-02-29
     *
     */
    def  importDsf(agents,day){
         
	def daily = day.format("yyyyMMdd")
        def result = ReportAgentpayDaily.findAllByDaily(daily)

        println 'importDsf result = '+result

           result.each {
             def tradeType = it.tradeType as String
             def customerNo =  it.customerNo as String
             ReportAllServicesDaily df = agents[customerNo]
             if(df==null){
                  df = new ReportAllServicesDaily()
                  agents[customerNo]=df
             }            
             if(tradeType=='F'){
                df.agentpayTradeCount=it.count
                df.agentpayTradeNetAmount=it.netAmount
                df.agentpayTradeNetFee=it.tradeSettleFee
             }else if(tradeType=='S'){
              df.agentcollTradeCount=it.count
              df.agentcollTradeNetAmount=it.netAmount
              df.agentcollTradeNetFee=it.tradeSettleFee
	        }
             df.tradeFinishdate  = day
             df.daily = daily
             df.customerNo   = customerNo
          
          }
       }

    /**
     * 查询分润，ReportRoyaltyDaily表，存入Map，键为"商户号"，值为"ReportAllServicesDaily每日统计报表对象"
     *
     * @param agents   Map<String,ReportAllServicesDaily>
     * @param day      Date记账日期
     * 
     * @author guonan  2012-02-29
     *
     */
    def  importRoyalty(agents,day){

      def daily = day.format("yyyyMMdd")
      def result = ReportRoyaltyDaily.findAllByDailyFlag(daily)

          println 'importRoyalty result = '+result

          result?.each {
             def customerNo =  it.customerNo as String
             ReportAllServicesDaily df = agents[customerNo]
             if(df==null){
                  df = new ReportAllServicesDaily()
                  agents[customerNo]=df
             }
             df.royaltyTradeNetFee= it.feeAmount
             df.royaltyTradeCount= ((it.royaltyPayNum?it.royaltyPayNum:0) as Long)+((it.royaltyRefundNum?it.royaltyRefundNum:0) as Long) 
	         df.royaltyTradeNetAmount= ((it.royaltyPayAmount?it.royaltyPayAmount:0) as Long)-((it.royaltyRefundAmount?it.royaltyRefundAmount:0) as Long)
             df.tradeFinishdate  = day
             df.daily = daily
             df.customerNo   = customerNo
          }
    }


    /**
     * 查询充提转等其他业务，report_other_biz_daily表，存入Map，键为"商户号"，值为"ReportAllServicesDaily每日统计报表对象"
     *
     * @param agents   Map<String,ReportAllServicesDaily>
     * @param day      Date记账日期
     * 
     * @author guonan  2012-02-29
     *
     */
    def  importOther(agents,day){

      def daily = day.format("yyyyMMdd")

       def query = """
                    select *
                      from report_other_biz_daily
                     where
                        date_created>=to_date('${day.format("yyyy-MM-dd 00:00:00")}','yyyy-mm-dd hh24:mi:ss')
                     and date_created<=to_date('${day.format("yyyy-MM-dd 23:59:59")}','yyyy-mm-dd hh24:mi:ss')
            """

        HibernateTemplate ht  = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list();
        } as HibernateCallback)
          println 'importOther result = '+result


          result?.each {
	     def customer = CmCustomer.get((it.CUS_ACCOUNTID) as Long)
             def customerNo =  customer.customerNo
             ReportAllServicesDaily df = agents[customerNo]
             if(df==null){
                  df = new ReportAllServicesDaily()
                  agents[customerNo]=df
             }
	     //充值
             df.chargeTradeNetFee= it.CHARGE_FEE
             df.chargeTradeCount= it.CHARGE_TOTAL_COUNT
	     df.chargeTradeNetAmount= it.CHARGE_TOTAL_AMOUNT
	     //提现
	     df.withdrawnTradeNetFee= it.WITHDRAWN_FEE
             df.withdrawnTradeCount= it.WITHDRAWN_COUNT
	     df.withdrawnTradeNetAmount= it.WITHDRAWN_AMOUNT
	     //转账
	     df.transferTradeNetFee= it.TRANSFER_FEE
             df.transferTradeCount= it.TRANSFER_COUNT
	     df.transferTradeNetAmount= it.TRANSFER_AMOUNT

             df.tradeFinishdate  = day
             df.daily = daily
             df.customerNo   = customerNo
          }
    }

    /**
     * 查询CmCustomer表商户类型（公司或个人），将Map中键为"商户号"，值为"ReportAllServicesDaily每日统计报表对象"同步数据库。
     *
     * @param agents   Map<String,ReportAllServicesDaily>
     * 
     * @author guonan  2012-02-29
     *
     */
    def  updateCustomerType(agents){
         agents.each {
             def customer = CmCustomer.findByCustomerNo((it.key))
             ReportAllServicesDaily df =((ReportAllServicesDaily)(it.value))
             //商户类型
              df.customerType=customer.type
              df.customerId=customer.id
              df.save(flush:true)
         }
    }
}
