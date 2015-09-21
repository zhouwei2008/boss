package boss

import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import ismp.CmCustomer
import groovy.sql.Sql

class ReportAgentpayDailyService {

    static transactional = true
    def dataSource_dsf

    def integrate(day) {
        def agents=[:]
        if(!isExist(agents,day)){
          importDsfTrade(agents,day)
          importDsfAccount(agents,day)
          updateSettleColl(agents,day)
          updateCustomerType(agents)
        }
        agents.clear()
    }


    /**
     * 获取所有已经开通代收付业务的商户
     *
     * @return  boCustomerServices    List<BoCustomerService>
     * @author guonan  2012-02-29
     *
     */
    def  getCustomerServices(){
        def  query = "from BoCustomerService s where (s.serviceCode=:scodep or s.serviceCode=:scodec) and s.isCurrent=:current and s.enable=:enable"
        def boCustomerServices = BoCustomerService.findAll(query,[scodep:'agentpay',scodec:'agentcoll',current:true,enable:true])
        return boCustomerServices
    }

     /**
     * 构造一个Map，键为"代收/付+商户号"，值为"ReportAgentpayDaily每日统计报表对象"
     *
     * @param boCustomerServices      所有已经开通代收付业务的商户
     * @return  agents Map<String,ReportAgentpayDaily>
     * @author guonan  2012-02-29
     *
     */
    def  getCustomerAgents(boCustomerServices){
        def agents=[:]
        boCustomerServices?.each {
            boCustomerService ->
            def customer = CmCustomer.get(boCustomerService.customerId)
            def finishDate = new Date()-i
            def customerNo   = customer.customerNo
            def tradeType = ''
            if(boCustomerService.serviceCode=='agentcoll'){
                 tradeType='S'
            } else if(boCustomerService.serviceCode=='agentpay'){
                 tradeType='F'
            }
             agents[tradeType+customer.customerNo]=new ReportAgentpayDaily(customerNo:customerNo,tradeType:tradeType,tradeFinishdate:finishDate )
        }
        return agents
    }


    /**
     * 判断是否当日统计，如存在，则查询出全部，放入Map，键为"代收/付+商户号"，值为"ReportAgentpayDaily每日统计报表对象"
     *
     * @param agents   Map<String,ReportAgentpayDaily>
     * @param day      Date记账日期
     * @return 0:不存在,1:存在
     * @author guonan  2012-02-29
     *
     */
    def isExist(agents,day){
        //每日统计标记
        def daily =  day.format("yyyyMMdd")
        //查询是否已经存在当日统计
        def  reportAgentpayDailys = ReportAgentpayDaily.findAllByDaily(daily)
        println 'importDsfTrade reportAgentpayDailys = '+reportAgentpayDailys
        if(reportAgentpayDailys!=null&&reportAgentpayDailys.size()>0){
             reportAgentpayDailys.each { df->
                  agents[df.tradeType+df.customerNo]=df
                  df.clear()
             }
             return 0
        }else{
             return 0
        }
    }
    /**
     * 查询代收付交易笔数及金额，tb_agentpay_details_info和tb_pc_info表，存入Map，键为"代收/付+商户号"，值为"ReportAgentpayDaily每日统计报表对象"
     *
     * @param agents   Map<String,ReportAgentpayDaily>
     * @param day      Date记账日期
     * 
     * @author guonan  2012-02-29
     *
     */
    def  importDsfTrade(agents,day){
        //查询交易金额 需关联tb_pc_info
        def   query = """select
           substr(a.batch_bizid,0,15) batch_bizid
           ,a.trade_type
           ,sum(a.trade_amount*1000) tm
           ,sum(a.trade_fee*1000) tf
           ,count(*) co
      from tb_agentpay_details_info a,tb_pc_info p
      where
          a.dk_pc_no=p.tb_pc_id
      and p.tb_pc_date>=to_date('${day.format("yyyy-MM-dd 00:00:00")}','yyyy-mm-dd hh24:mi:ss')
      and p.tb_pc_date<=to_date('${day.format("yyyy-MM-dd 23:59:59")}','yyyy-mm-dd hh24:mi:ss')
      group by a.batch_bizid,a.trade_type
      """
        println   "ReportAgentpayDailyService importDsf query2=${query}"
       HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('dsf')
       def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list();
        } as HibernateCallback)

          println 'importDsfTrade result2 '+result
          result?.each {
             def tradeType = it.TRADE_TYPE as String
             def customerNo =  it.BATCH_BIZID as String
             ReportAgentpayDaily df = agents[tradeType+customerNo]
             if(df==null){
                  df = new ReportAgentpayDaily()
                  agents[tradeType+customerNo]=df
             }
             df.amount= ((it.TM?it.TM:0) as Double)/10
             df.count= ((it.CO?it.CO:0) as Long)
             if(tradeType=='F'){
                df.tradeSettleFee = ((it.TF?it.TF:0) as Double)/10
             }
             df.tradeFinishdate  = day
             df.daily = day.format("yyyyMMdd")
             df.customerNo   = customerNo
             df.tradeType    = tradeType
          }

        //保存
 //       agents.each {
 //               ((ReportAgentpayDaily)(it.value)).save(flush:true)
 //               println 'ReportAgentpayDaily id =  '+ ((ReportAgentpayDaily)(it.value)).id
 //           }
    }

    /**
     * 查询代收付对账成功和失败笔数及金额，ac_transaction和tb_agentpay_details_info表，存入Map，键为"代收/付+商户号"，值为"ReportAgentpayDaily每日统计报表对象"
     *
     * @param agents   Map<String,ReportAgentpayDaily>
     * @param day      Date记账日期
     * 
     * @author guonan  2012-02-29
     *
     */
    def  importDsfAccount(agents,day){
          def query = """select distinct trade_no
         from ac_transaction a
         where
             date_created>=to_date('${day.format("yyyy-MM-dd 00:00:00")}','yyyy-mm-dd hh24:mi:ss')
         and date_created<=to_date('${day.format("yyyy-MM-dd 23:59:59")}','yyyy-mm-dd hh24:mi:ss')
         and trade_no is not null
         """
           println   "ReportAgentpayDailyService importDsfAccount query=${query}"
           HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('account')
           def result = ht.executeFind({ Session session ->
               def sqlQuery = session.createSQLQuery(query.toString())
               sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
               return sqlQuery.list();
           } as HibernateCallback)
	//无账务流水则返回
        if(result==null||result.size()==0){
             return
        }
         def queryDropTemp = "drop table temp_tb_detail_ids"
         def queryCheckTbTemp ="select * from user_tables where table_name=upper('temp_tb_detail_ids')"

         def queryCreateTemp = "create global temporary table temp_tb_detail_ids(detail_id varchar2(36)) on commit delete rows"
         def queryCleanTbTemp ="truncate table temp_tb_detail_ids"
//        def queryCleanTbTemp ="truncate table tb_detail_ids"
         def queryInsTemp = "insert into temp_tb_detail_ids values(?)"
//         def queryInsTemp = "insert into tb_detail_ids values(?,?,?)"
         //detail_id关联成功交易。batch_id关联批次，为查询失败记录。
	 def querySelTemp   = """
         select  tx.batch_bizid
           ,tx.trade_type
           ,tx.pay_status
           ,tx.trade_feestyle
           ,sum(tx.trade_amount*1000) tm
           ,sum(tx.trade_fee*1000) tf
           ,count(*) co
           from (
         select
             a.detail_id,substr(a.batch_bizid,0,15) batch_bizid
           ,a.trade_type
           ,a.pay_status
           ,a.trade_feestyle
           ,a.trade_amount
           ,a.trade_fee
         from tb_agentpay_details_info a,temp_tb_detail_ids t
         where
             a.detail_id = t.detail_id
          and a.pay_status in ('6','7','8','9')
          and a.trade_type='F'
          union
          select
             a.detail_id,substr(a.batch_bizid,0,15) batch_bizid
           ,a.trade_type
           ,a.pay_status
           ,a.trade_feestyle
           ,a.trade_amount
           ,a.trade_fee
         from tb_agentpay_details_info a,temp_tb_detail_ids t
         where
             a.batch_id = t.detail_id
          and a.pay_status in ('6','7','8','9')
          and a.trade_type='F'
         ) tx
         group by tx.batch_bizid,tx.trade_type,tx.pay_status,tx.trade_feestyle
         """
           println   " importDsf query=${query}"


        def result2
           def db=new Sql(dataSource_dsf)
            db.withTransaction {
              if(!db.firstRow(queryCheckTbTemp)){
                  db.execute(queryCreateTemp)
              }
//              db.withBatch(100) { ps ->
//                  for(x in result){
//                    ps.addBatch("insert into temp_tb_detail_ids values('${x.TRADE_NO}')")
//                  }
//              }
                  def i=0
                result.each{
//                    i++
                    if(it.TRADE_NO){
//                       db.executeInsert(queryInsTemp,[i,it.TRADE_NO,'F'])
                        db.executeInsert(queryInsTemp,[it.TRADE_NO])
                    }
                }
                result2=db.rows(querySelTemp)
                db.execute(queryCleanTbTemp)
            }
           result=null
           println   " importDsfAccount result2=${result2}"
           result2.each {
             def tradeType = it.TRADE_TYPE as String
             def customerNo =  it.BATCH_BIZID as String
             ReportAgentpayDaily df = agents[tradeType+customerNo]
             if(df==null){
                  df = new ReportAgentpayDaily()
                  agents[tradeType+customerNo]=df
             }
             if(it.PAY_STATUS=='6'&&tradeType=='F'){
                  df.tradeCountSuccess  = df.tradeCountSuccess+((it.CO?it.CO:0) as Long)
                  df.tradeAmountSuccess = df.tradeAmountSuccess+((it.TM?it.TM:0) as Double)/10

             }else if((it.PAY_STATUS=='7'||it.PAY_STATUS=='8'||it.PAY_STATUS=='9')&&tradeType=='F'){
                 df.tradeCountFail   = df.tradeCountFail+((it.CO?it.CO:0) as Long)
                 df.tradeAmountFail  = df.tradeAmountFail+((it.TM?it.TM:0) as Double)/10
             }
//             else if(it.PAY_STATUS=='9'&&tradeType=='S'){
//                 df.tradeCountFail   = df.tradeCountFail+((it.CO?it.CO:0) as Long)
//                 df.tradeAmountFail  = df.tradeAmountFail+((it.TM?it.TM:0) as Double)/10
//             }
             //代付需要算手续费
             if(tradeType=='F'){
                //失败（已退款）因为账户资金先冻结，如需退手续费则减去，如不需退手续费则不处理
                if(it.PAY_STATUS=='9'&&it.TRADE_FEESTYLE=='T'){
                    df.tradeSettleFee = df.tradeSettleFee-((it.TF?it.TF:0) as Double)/10
                }
             }
             df.tradeFinishdate  = day
             df.daily = day.format("yyyyMMdd")
             df.customerNo   = customerNo
             df.tradeType    = tradeType
          }
         //保存或更新
//        agents.each {
  //              ((ReportAgentpayDaily)(it.value)).save(flush:true)
    //            println 'ReportAgentpayDaily id =  '+ ((ReportAgentpayDaily)(it.value)).id
      //      }
       }

    /**
     * 查询代收实时与非实时清结算及手续费，ft_liquidate和ft_trade表，存入Map，键为"代收/付+商户号"，值为"ReportAgentpayDaily每日统计报表对象"
     *
     * @param agents   Map<String,ReportAgentpayDaily>
     * @param day      Date记账日期
     * 
     * @author guonan  2012-02-29
     *
     */
    def  updateSettleColl(agents,day){
        //清算表 查代收非实时结算及手续费
       def  query = """select customer_no
       ,srv_code
       ,trade_code
       ,sum(amount) sam
       ,sum(post_fee) post
       ,sum(pre_fee) pre　
      from ft_liquidate
      where srv_code='agentcoll'
      and settle_type='0'
      and trade_code in ('coll_c_succ','coll_c_fail','coll_b_succ','coll_b_fail')
      and liq_date>=to_date('${day.format("yyyy-MM-dd 00:00:00")}','yyyy-mm-dd hh24:mi:ss')
      and liq_date<=to_date('${day.format("yyyy-MM-dd 23:59:59")}','yyyy-mm-dd hh24:mi:ss')
      group by customer_no,srv_code,trade_code
      """
          println 'updateSettleColl query '+query
        HibernateTemplate ht  = DatasourcesUtils.newHibernateTemplate('settle')
        def resultSettle = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list();
        } as HibernateCallback)

        println 'updateSettleColl resultSettle '+resultSettle

         resultSettle?.each {
             def tradeType = 'S'
             def customerNo =  it.CUSTOMER_NO as String
             ReportAgentpayDaily df = agents[tradeType+customerNo]
             if(df==null){
                  df = new ReportAgentpayDaily()
                  agents[tradeType+customerNo]=df
             }
             if(it.TRADE_CODE=='coll_c_succ'||it.TRADE_CODE=='coll_b_succ'){
                 df.tradeSettleAmount = df.tradeSettleAmount+((it.SAM?it.SAM:0) as Double)
             }
             df.tradeSettleFee = df.tradeSettleFee+((it.POST?it.POST:0) as Double)+((it.PRE?it.PRE:0) as Double)
             df.tradeFinishdate  = day
             df.daily = day.format("yyyyMMdd")
             df.customerNo   = customerNo
             df.tradeType    = tradeType
         }

         //清算表 查代收实时结算及手续费
         query = """select customer_no
       ,srv_code
       ,trade_code
       ,realtime_settle
       ,sum(net_amount) sam
       ,sum(amount) tm
       ,sum(post_fee) post
       ,sum(pre_fee) pre
       ,count(*) co  　
      from ft_trade
      where srv_code='agentcoll'
      --and realtime_settle='1'
      and trade_code in ('coll_c_succ','coll_c_fail','coll_b_succ','coll_b_fail')
      and date_created>=to_date('${day.format("yyyy-MM-dd 00:00:00")}','yyyy-mm-dd hh24:mi:ss')
      and date_created<=to_date('${day.format("yyyy-MM-dd 23:59:59")}','yyyy-mm-dd hh24:mi:ss')
      group by customer_no,srv_code,trade_code,realtime_settle
      """
         println 'updateSettleColl query '+query
         ht  = DatasourcesUtils.newHibernateTemplate('settle')
         resultSettle = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list();
        } as HibernateCallback)

           println 'updateSettleColl resultSettle '+resultSettle

         resultSettle?.each {
             def tradeType = 'S'
             def customerNo =  it.CUSTOMER_NO as String
             ReportAgentpayDaily df = agents[tradeType+customerNo]
             if(df==null){
                  df = new ReportAgentpayDaily()
                  agents[tradeType+customerNo]=df
             }
             if(it.TRADE_CODE=='coll_c_succ'||it.TRADE_CODE=='coll_b_succ'){
                 df.tradeCountSuccess  = df.tradeCountSuccess+((it.CO?it.CO:0) as Long)
                 df.tradeAmountSuccess = df.tradeAmountSuccess+((it.TM?it.TM:0) as Double)
             }
             if(it.TRADE_CODE=='coll_c_fail'||it.TRADE_CODE=='coll_b_fail'){
                 df.tradeCountFail   = df.tradeCountFail+((it.CO?it.CO:0) as Long)
                 df.tradeAmountFail  = df.tradeAmountFail+((it.TM?it.TM:0) as Double)
             }
             if(it.REALTIME_SETTLE==1){
                 df.tradeSettleAmount = df.tradeSettleAmount+((it.SAM?it.SAM:0) as Double)
                 df.tradeSettleFee = df.tradeSettleFee+((it.POST?it.POST:0) as Double)+((it.PRE?it.PRE:0) as Double)
             }
             df.tradeFinishdate  = day
             df.daily = day.format("yyyyMMdd")
             df.customerNo   = customerNo
             df.tradeType    = tradeType
         }
        // agents.each {
          //         ((ReportAgentpayDaily)(it.value)).save(flush:true)
            //   }
    }


    /**
     * 查询CmCustomer表商户类型（公司或个人），计算交易净额，将Map中键为"代收/付+商户号"，值为"ReportAgentpayDaily每日统计报表对象"同步数据库。
     *
     * @param agents   Map<String,ReportAgentpayDaily>
     * 
     * @author guonan  2012-02-29
     *
     */
    def  updateCustomerType(agents){
         agents.each {
             def customer = CmCustomer.findByCustomerNo((it.key).substring(1))
             ReportAgentpayDaily df =((ReportAgentpayDaily)(it.value))
             //商户类型
              df.customerType=customer.type
              df.customerId=customer.id
             //交易净额＝交易总金额-对账失败金额
              df.netAmount=df.amount-df.tradeAmountFail
              df.save(flush:true)
         }
    }



    def  updateSettlePay(boCustomerServices){
        if(boCustomerServices.isEmpty()){
            return
        }
        //查商户表找id
//       def customers = CmCustomer.findAllByCustomerNoInList(agents.keySet())
//       def ids = []
//         customers.each {customer ->
//                    ids << (customer.id  as Long)
//                }
//        ids= [299 as Long, 325 as Long, 386 as Long, 442 as Long, 48 as Long, 385 as Long]
//        println 'updateSettlePay ids '+ids
         //查商户服务表找对应的服务accountNo和手续费accountNo
//        def  query = "from BoCustomerService s where s.customerId in (:id) and s.serviceCode=:scode and s.isCurrent=:current and s.enable=:enable"
//        def boCustomerServices = BoCustomerService.findAll(query,[id:ids,scode:'agentpay',current:true,enable:true])
        def accountNos = [:]
         boCustomerServices?.each {boCustomerService ->
                   if(boCustomerService.serviceCode=='agentpay'){
                      accountNos[boCustomerService.srvAccNo]=['s',boCustomerService.customerId]
                      accountNos[boCustomerService.feeAccNo]=['f',boCustomerService.customerId]
                   }

                }
          println 'updateSettlePay accountNos '+accountNos
        //查服务accountNo和手续费accountNo交易金额，分贷记和借记
         query = """select s.account_no,a.balance_of_direction,sum(s.credit_amount) ca,sum(s.debit_amount) da
      from ac_sequential s,ac_account a
      where  2>1
      and s.account_no in (${accountNos.keySet().join(',')})
      and s.date_created>=to_date('${getDateDay(-i,"yyyy-MM-dd 00:00:00")}','yyyy-mm-dd hh24:mi:ss')
      and s.date_created<=to_date('${getDateDay(-i,"yyyy-MM-dd 23:59:59")}','yyyy-mm-dd hh24:mi:ss')
      and s.account_no = a.account_no
      group by s.account_no,a.balance_of_direction
      """

        HibernateTemplate ht  = DatasourcesUtils.newHibernateTemplate('account')
        def resultSettle = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list();
        } as HibernateCallback)

           println 'updateSettlePay resultSettle '+resultSettle
         resultSettle?.each {
             def amt
             //贷记账户，贷记-借记
             if(it.BALANCE_OF_DIRECTION=='credit'){
                 amt=(it.CA as Long)-(it.DA as Long)
             }
             //借记账户，借记-贷记
             else if(it.BALANCE_OF_DIRECTION=='debit'){
                 amt=(it.DA as Long)-(it.CA as Long)
             }
             def customer = CmCustomer.get(accountNos[it.ACCOUNT_NO][1])

             def update = """
            update ReportAgentpayDaily t set
            ${accountNos[it.ACCOUNT_NO][0]=='s'? " t.tradeSettleAmount='"+amt+"'":" t.tradeSettleFee='"+amt+"'"}
            where t.tradeType='F' and t.customerNo='${customer.customerNo}'
             """

             ReportAgentpayDaily.executeUpdate(update)

         }
    }

    def getDateDay(days,format){
        def gCalendar= new GregorianCalendar()
        gCalendar.add(GregorianCalendar.DATE,days)
         return  gCalendar.time.format(format)
    }

    def getDateDay(days){
        def gCalendar= new GregorianCalendar()
        gCalendar.add(GregorianCalendar.DATE,days)
         return  gCalendar.time
    }

    def getMonthDay(months,format){
        def gCalendar= new GregorianCalendar()
            gCalendar.add(GregorianCalendar.MONTH,months)
         return  gCalendar.time.format(format)
    }


    def test(){
        def customerNo = '100000000000242'
        def code = "agentcoll"
        def SAM = '20'
        def PRE = '5'
        def POST = '3'

         def update = """
            update ReportAgentpayDaily t set t.tradeSettleAmount='${((SAM?SAM:0) as Long)-((PRE?PRE:0) as Long)}',
            t.tradeSettleFee='${((POST?POST:0) as Long)+((PRE?PRE:0) as Long)}'
            where t.tradeType='${code=="agentcoll"?"S":""}' and t.customerNo='${customerNo}'
            and t.tradeFinishdate>=to_date('${getDateDay(-1,"yyyy-MM-dd 00:00:00")}','yyyy-mm-dd hh24:mi:ss')
            and t.tradeFinishdate<=to_date('${getDateDay(-1,"yyyy-MM-dd 23:59:59")}','yyyy-mm-dd hh24:mi:ss')
             """
        println "pqueryer = ${update}"
             ReportAgentpayDaily.executeUpdate(update)
    }
}
