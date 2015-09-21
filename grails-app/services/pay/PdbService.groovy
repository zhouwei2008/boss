package pay

import groovy.sql.Sql
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import ismp.CmCorporationInfo
import ismp.CmCustomer
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate
import boss.BoAcquirerAccount
import boss.BoMerchant
import java.util.concurrent.ThreadPoolExecutor
import java.util.concurrent.TimeUnit
import java.util.concurrent.LinkedBlockingQueue
import java.text.SimpleDateFormat

class PdbService {
    final static int makeBatchPoolSize = 5
    final static ThreadPoolExecutor makeBatchPool = new ThreadPoolExecutor(makeBatchPoolSize, makeBatchPoolSize,
                                      0L, TimeUnit.MILLISECONDS,
                                      new LinkedBlockingQueue<Runnable>());
    static transactional = true
    def dataSource_pay
    def ipayService
    /**
     * 绑定银行 账户下拉框
     * 筛选状态为可用,服务类型匹配，并且未绑定过相同服务的账户
     * @param channelType
     * @return
     */
    def boAcquirerAccountList(String channelType) {
        def query = """  select distinct  a.bank_id,a.bank_account_no as bankAccountNo,b.name as bankName from bo_acquirer_account a
            left join bo_merchant m on a.id=m.acquirer_account_id
            left join bo_bank_dic b on a.bank_id=b.id
            where m.channel_type='${channelType}' and a.status='normal' and m.channel_sts='0'
            and m.acquirer_account_id is not null order by a.bank_id
          """
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def resList = ht.executeFind({ Session session ->
          def sqlquery = session.createSQLQuery(query.toString())
          sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
          return sqlquery.list()
        } as HibernateCallback)
        def list = PtbBindBank.list()
        def result = []
        if (list && resList) {
            for (def map:resList) {
                boolean flag = false;
                for (PtbBindBank ptbBindBank:list) {
                  if((map.BANKACCOUNTNO.equals(ptbBindBank.bankAccountno))&&(channelType.equals(ptbBindBank.type))){
                      flag = true
                      break
                  }
                }
                if(!result.contains(map)&&(!flag)){
                    result.add(map)
                }
            }
        }else{
           result = resList
        }
        return result
    }

    /**
     * 保存绑定账户
     * @param params
     * @return
     */
    def savePtbBindBank(def params){
        def msg
        def isSuccess
        def tbBindBankInstance = null;
        def tbBindBank = new PtbBindBank()
        tbBindBank.bankAccountno = params.bankAccountno
        tbBindBank.type = params.type
        PtbBindBank ptbBindBankin = PtbBindBank.find(tbBindBank)
        List list = BoAcquirerAccount.findAllByBankAccountNo(params.bankAccountno)

        msg = params.bankAccountno
        if (list.size() == 0) {
            isSuccess = false
            msg += " 帐号错误"
        } else if (ptbBindBankin != null) {
            isSuccess = false
            msg += " 此账号已与此相同服务做过绑定"
        }
        else {
            tbBindBankInstance = new PtbBindBank(params)
            if (tbBindBankInstance.save(flush: true)) {
                isSuccess = true
                msg += " 绑定成功"
            }
            else {
                isSuccess = false
                msg += " 网络连接错误"
            }
        }
        [isSuccess:isSuccess,msg:msg,tbBindBankInstance:tbBindBankInstance]
    }

    /**
     * 创建交易类型
     * @param params
     * @return
     */
    def savePtbPayTradeType(def params){
         def msg
        def isSuccess
        def ptbPayTradeType = null;
        def queryPtbPayTradeType = new PtbPayTradeType()
        queryPtbPayTradeType.payCode = params.payCode
        PtbPayTradeType tempPtbPayTradeType = PtbPayTradeType.find(queryPtbPayTradeType)

        msg = params.payCode
        if (tempPtbPayTradeType != null) {
            isSuccess = false
            msg += " 交易Code重复"
        }else {
            ptbPayTradeType = new PtbPayTradeType(params)
            if (ptbPayTradeType.save(flush: true)) {
                isSuccess = true
                msg += " 创建成功"
            }
            else {
                isSuccess = false
                msg += " 网络连接错误"
            }
        }
        [isSuccess:isSuccess,msg:msg,ptbPayTradeType:ptbPayTradeType]
    }
    /**
     * 查询渠道
     * @param channelType
     * @return
     */
    def bankChanelList(String channelType){
         def query = """  select distinct  m.id as merchantId,a.bank_id,a.bank_account_no as bankAccountNo,
            b.name as bankName,a.branch_name as branchName,m.service_code as serviceCode,
            a.ALIAS_NAME as ALIAS_NAME
            from bo_acquirer_account a
            left join bo_merchant m on a.id=m.acquirer_account_id
            left join bo_bank_dic b on a.bank_id=b.id
            where m.channel_type='${channelType}' and a.status='normal' and m.channel_sts='0'
            and m.acquirer_account_id is not null order by a.bank_id
          """
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def resList = ht.executeFind({ Session session ->
          def sqlquery = session.createSQLQuery(query.toString())
          sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
          return sqlquery.list()
        } as HibernateCallback)

        return resList
    }

    /**
     *  查询渠道
     * @param channelType
     * @param bankId
     * @return
     */
    def bankChanelList(String channelType,def bankId){
         def query = """  select distinct  m.id as merchantId,a.bank_id,a.bank_account_no as bankAccountNo,
            b.name as bankName,a.branch_name as branchName,m.service_code as serviceCode,
            a.ALIAS_NAME as ALIAS_NAME
            from bo_acquirer_account a
            left join bo_merchant m on a.id=m.acquirer_account_id
            left join bo_bank_dic b on a.bank_id=b.id
            where m.channel_type='${channelType}'"""+(bankId?"""and a.bank_id=${bankId}""":""" """)+""" and a.status='normal' and m.channel_sts='0'
            and m.acquirer_account_id is not null order by a.bank_id
          """
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def resList = ht.executeFind({ Session session ->
          def sqlquery = session.createSQLQuery(query.toString())
          sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
          return sqlquery.list()
        } as HibernateCallback)

        return resList
    }


    /**
     * 查询银行   旧版
     * @param channelType
     * @return
     */
   /* def bankList(String channelType){
         def  query
         if("F".equals(channelType)){
             query = """  select distinct b.id as bankid,b.code as bankCode,
                    b.name as bankName
                    from  bo_bank_dic b order by b.id
                  """
         } else{
             query = """  select distinct a.bank_id as bankid,b.code as bankCode,
                    b.name as bankName
                    from bo_acquirer_account a
                    left join bo_merchant m on a.id=m.acquirer_account_id
                    left join bo_bank_dic b on a.bank_id=b.id
                    where m.channel_type='${channelType}' and a.status='normal' and m.channel_sts='0'
                    and m.acquirer_account_id is not null order by a.bank_id
                  """
         }
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def resList = ht.executeFind({ Session session ->
          def sqlquery = session.createSQLQuery(query.toString())
          sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
          return sqlquery.list()
        } as HibernateCallback)

        return resList
    }*/


    /**
     * 查询银行   新版
     * @param channelType
     * @return
     */
    def bankList(String channelType){
         def  query

         query = """  select distinct min(t.id) as bankid,t.bank_code as bankCode,
                   t.bank_authorityname as bankName
                 from tb_adjust_bank t
                 where t.trade_type='${channelType}'
                 group by t.bank_code,t.bank_authorityname
                 order by bankName desc
              """

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('pay')
        def resList = ht.executeFind({ Session session ->
          def sqlquery = session.createSQLQuery(query.toString())
          sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
          return sqlquery.list()
        } as HibernateCallback)

        return resList
    }

    /**
     * 多选条件筛选
     */
    def checkboxBankList (String channelType) {
        def dataList = new ArrayList();
        def list = bankList(channelType)
        list.each {
            if(it.BANKCODE.equals("BOC") || it.BANKCODE.equals("ABC") || it.BANKCODE.equals("ICBC") || it.BANKCODE.equals("CCB") || it.BANKCODE.equals("GDB")
                    || it.BANKCODE.equals("CEB") || it.BANKCODE.equals("PSBC")){
                dataList.add(it)
            }
        }
        for ( int i = 0 ; i < dataList.size() - 1 ; i ++ ) {
            for ( int j = dataList.size() - 1 ; j > i; j -- ) {
                if (dataList.get(j).BANKCODE == dataList.get(i).BANKCODE) {
                    dataList.remove(j);
                }
            }
        }
        return  dataList
    }

    /**
     *  查询交易List   包含 交易汇总 信息
     * @param query
     * @param isPage  是否分页
     * @param params
     * @return
     */
    def ptbPayTradeList(def queryList,def queryTotal,boolean isPage,def params){
         List res = null
         def criteria =  PtbPayTrade.createCriteria()
         if(isPage){
              res = criteria.list(params, queryList.query)
         }else{
              res = criteria.list(queryList.query)
         }
         //不能用 criteria
         def total = PtbPayTrade.createCriteria().get(queryTotal.query)
         [res:res,totalCount:total[0],totalMoney:total[1]]
    }

    /**
     * 查询交易汇总
     * @param query
     * @return
     */
     def ptbPayTradeTotal(def queryTotal){
         def total = PtbPayTrade.createCriteria().get(queryTotal.query)
         [totalCount:total[0],totalMoney:total[1]]
     }

    /**
     * 生成批次
     * @param query
     * @param params
     * @param tradesCount
     * @return
     */
    def makeBatch(def queryList,def queryTotal,def params) {
        def chanelParams = ipayService.getChanelParams(params.merchantId,params.tradeType)
        if(chanelParams.sysCode&&chanelParams.maxCount){
            def maxCount = chanelParams.maxCount
            def sysCode  = chanelParams.sysCode
            BoMerchant boMerchant = BoMerchant.get(params.merchantId)
            def chanelName = boMerchant.acquirerAccount.bank.name+"-"+boMerchant.acquirerAccount.aliasName
            def total = ptbPayTradeTotal(queryTotal)
            def tradesCount = total.totalCount

            if(params&&(tradesCount>0)){
                def batchsCount = Math.ceil(tradesCount / maxCount)
                String updateSql
                for (int n = 0; n < batchsCount; n++) {
                    if(n==batchsCount-1){
                        updateSql = """
                                   update TB_PAY_TRADE set BATCH_ID='temp${n}'
                                   where TRADE_ID in
                                   (
                                     select TRADE_ID from
                                     (
                                       select row_.*, rownum rownum_ from
                                       (
                                          select * from TB_PAY_TRADE
                                          ${queryList.sqlWhere}
                                       ) row_
                                       where
                                         rownum <= ${total.totalCount}
                                     )
                                     where
                                        rownum_ >=${n*maxCount+1}
                                   )
                                   """
                    }else{
                        updateSql = """update TB_PAY_TRADE set BATCH_ID='temp${n}'
                                   where TRADE_ID in
                                   (
                                     select TRADE_ID from
                                     (
                                       select row_.*, rownum rownum_ from
                                       (
                                          select * from TB_PAY_TRADE
                                          ${queryList.sqlWhere}
                                       ) row_
                                       where
                                         rownum <= ${(n+1)*maxCount}
                                     )
                                     where
                                        rownum_ >=${n*maxCount+1}
                                   )
                                   """
                    }
                    HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('pay')
                    ht.execute({ Session session ->
                        try{
                            session.createSQLQuery(updateSql).executeUpdate()
                            session.flush()
                        }catch (Throwable e){
                            e.printStackTrace()
                        }
                    } as HibernateCallback)

                }

                String[] ids = new String[batchsCount]
                params.max = maxCount
                PtbPayBatch ptbPayBatch = null
                for (int i = 0; i < batchsCount; i++) {
                    List tempTrades = PtbPayTrade.findAllByBatchId("temp${i}",[sort: "id",order: "asc"])
                    if(tempTrades){
                        ptbPayBatch = new PtbPayBatch()
                        ptbPayBatch.batchDate = new Date()
                        ptbPayBatch.batchCount = tempTrades.size()
                        ptbPayBatch.batchAmount = 0.0
                        tempTrades.each {
                            ptbPayBatch.batchAmount = ptbPayBatch.batchAmount.toBigDecimal() + (it.tradeAmount.toBigDecimal())
                        }
                        ptbPayBatch.batchChanel = Integer.valueOf(params.merchantId)
                        ptbPayBatch.batchChanelsyscode = sysCode
                        ptbPayBatch.batchChanelname = chanelName
                        ptbPayBatch.batchChanelaccountno =  params.bankAccountno
                        ptbPayBatch.batchStatus = '0'
                        ptbPayBatch.batchType = params.tradeType
                        ptbPayBatch.batchStyle = params.batchStyle

                        savePayBatch(ptbPayBatch,tempTrades)

                        ids[i] = ptbPayBatch.id
                    }
                }
                return ids  //可能有空值哦
            }else{
                return null
            }
        }else{
            return null
        }
    }

    /**
     * 保存批次
     * @return
     */
    def savePayBatch(final PtbPayBatch ptbPayBatch,final List trades){
        if(ptbPayBatch&&trades){
            if (ptbPayBatch.save(failOnError: true)) {
                String sql1 = "update PtbPayTrade t set t.tradeStatus = '1', t.batchId='${ptbPayBatch.id}' where t.batchId = '${trades[0].batchId}'"
                PtbPayTrade.executeUpdate(sql1)
                Thread t = new Thread(new Runnable(){
                    void run() {
                        try{
                            for(int i=0;i<trades.size();i++){
                                String sql = "update PtbPayTrade t set t.tradeBatchseqno="+(i+1)+ " where t.id = '" + trades.get(i).id +"'"
                                PtbPayTrade.executeUpdate(sql)
                            }
                        }catch (Throwable e) {
                            log.error("${ptbPayBatch.id}",e,"生成批次时，更新交易异常")
                        }
                    }
                })
                makeBatchPool.execute(t)
            }
        }
    }

    /**
     * 交易明细查询
     * @param channelType
     * @return
     */
    def queryTradesDetail(def params){
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
        params.offset = params.offset ? params.int('offset'):0
        String bankNamesStr = ""
        if(params.bankCode){
            List  bankNames = null;
            def bankType = PtbAdjustBank.executeQuery(" select distinct t.bankType from PtbAdjustBank t where t.bankCode ='"+ params.bankCode.toUpperCase()+"'" )
            if ("TH".equals(bankType?.get(0)?.toString())) {  //第三方，如 UNIONPAY,HCHINAPAY
                bankNames = PtbAdjustBank.executeQuery(""" select Trim(t0.bankNames) from PtbAdjustBank t0
                    where t0.bankCode in
                    (
                    select t.bankNames from PtbAdjustBank t where t.tradeType='${params.tradeType}'
                    and t.bankCode ='${params.bankCode.toUpperCase()}'
                    ) """ )
                if(!bankNames){
                   bankNamesStr = bankNamesStr + "'-1'"
                }
            }else{
                bankNames = PtbAdjustBank.executeQuery(" select Trim(t.bankNames) from PtbAdjustBank t where t.bankCode ='"+ params.bankCode.toUpperCase()+"'" )
                if(!bankNames){
                    bankNamesStr = bankNamesStr + "${params.bankName}"
                }
            }

            if(bankNames){
                for(int i=0;i<bankNames.size();i++){
                    bankNamesStr = bankNamesStr+"'${bankNames.get(i)}'"
                    if(i<bankNames.size()-1){
                        bankNamesStr = bankNamesStr + ","
                    }
                }
            }
        }
        String cmCustomerNoStr = ""
        if(params.name){
                List cmCustomerNos = CmCustomer.executeQuery("select c.customerNo from CmCustomer c where c.name like  '%"+params.name+"%'")
                println("cmCustomerNos:"+cmCustomerNos)

                if(cmCustomerNos){
                    for(int i=0;i<cmCustomerNos.size();i++){
                        cmCustomerNoStr = cmCustomerNos.get(i)
                        if(i<cmCustomerNos.size()-1){
                            cmCustomerNoStr = cmCustomerNoStr + ","
                        }
                    }
                }

            println("cmCustomerNoStr:"+cmCustomerNoStr)
        }
        String batchStr = ""

        if(params.batchIdStart && params.batchIdEnd){

            batchStr = "and t.BATCH_ID >= "+params.batchIdStart+" and t.BATCH_ID <= "+ params.batchIdEnd+""
        }else {
            if(params.batchIdStart){
                batchStr =  "and t.BATCH_ID="+params.batchIdStart+""
            }

            if(params.batchIdEnd){
                batchStr =  "and t.BATCH_ID="+params.batchIdEnd+""
            }
        }


         //${params.batchId?(" and t.BATCH_ID='"+params.batchId+"' "):""}
        def whereStr = """ where t.TRADE_TYPE='${params.tradeType}'
                    ${params.startTime?(" and t.TRADE_SUBDATE>=to_date('"+params.startTime+"','yyyy-MM-dd') "):""}
                    ${params.endTime?(" and t.TRADE_SUBDATE<to_date('"+sf.format(Date.parse('yyyy-MM-dd', params.endTime)+1)+"','yyyy-MM-dd') "):""}
                    ${params.batchSTime?(" and b.BATCH_DATE>=to_date('"+params.batchSTime+"','yyyy-MM-dd') "):""}
                    ${params.batchETime?(" and b.BATCH_DATE<to_date('"+sf.format(Date.parse('yyyy-MM-dd', params.batchETime)+1)+"','yyyy-MM-dd') "):""}
                    ${params.donedateSTime?(" and t.TRADE_DONEDATE>=to_date('"+params.donedateSTime+"','yyyy-MM-dd') "):""}
                    ${params.donedateETime?(" and t.TRADE_DONEDATE<to_date('"+sf.format(Date.parse('yyyy-MM-dd', params.donedateETime)+1)+"','yyyy-MM-dd') "):""}
                    ${params.tradeAcctype?(" and t.TRADE_ACCTYPE='"+params.tradeAcctype+"' "):""}
                    ${params.tradeCardname?(" and t.TRADE_CARDNAME='"+params.tradeCardname+"' "):""}
                    ${params.tradeCardnum?(" and t.TRADE_CARDNUM='"+params.tradeCardnum+"' "):""}
                    ${params.merchantId?(" and b.BATCH_CHANEL='"+params.merchantId+"' "):""}
                    ${params.tradeBatchseqno?(" and t.TRADE_BATCHSEQNO='"+params.tradeBatchseqno+"' "):""}
                    ${params.tradeId?(" and t.TRADE_ID='"+params.tradeId+"' "):""}
                    ${params.batchId?(" and t.BATCH_ID='"+params.batchId+"' "):""}
                    ${params.outTradeorder?(" and t.OUT_TRADEORDER='"+params.outTradeorder+"' "):""}
                    ${params.tradeStatus?(" and t.TRADE_STATUS='"+params.tradeStatus+"' "):""}
                    ${params.tradeCode?(" and t.TRADE_CODE='"+params.tradeCode+"' "):""}
                    ${params.tradeAmount?(" and t.TRADE_AMOUNT='"+params.tradeAmount+"' "):""}
                    ${bankNamesStr?(" and t.TRADE_BANK in ("+bankNamesStr+") "):""}
                    ${cmCustomerNoStr?(" and c.batch_bizid in ("+cmCustomerNoStr+") "):""}
                    """+batchStr




        def orderStr = """  ${params.sort?(" order by "+params.sort+" "+params.order):""}"""

        // ${params.tradeCardtype?(" and t.TRADE_CARDTYPE='"+params.tradeCardtype+"' "):""}  这个先不要
        def query = """select distinct t.*,b.BATCH_DATE,b.BATCH_CHANEL,b.BATCH_CHANELNAME,b.BATCH_STYLE from tb_pay_trade t
                       left join tb_pay_batch b on t.BATCH_ID=b.BATCH_ID left join temp_dsf.tb_agentpay_details_info c on
                       t.out_tradeorder=c.detail_id ${whereStr} ${orderStr}"""

        println("query:"+query)

        def queryTotal = """  select sum(t.TRADE_AMOUNT) as TOTAL_MONEY,count(1) as TOTAL_COUNT from tb_pay_trade t
                              left join tb_pay_batch b on t.BATCH_ID=b.BATCH_ID  left join temp_dsf.tb_agentpay_details_info c on
                              t.out_tradeorder=c.detail_id ${whereStr} """

        def sql = new Sql(dataSource_pay)
        def total = sql.firstRow(queryTotal,[])

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('pay')
        def resList = ht.executeFind({ Session session ->
          def sqlquery = session.createSQLQuery(query.toString())
          sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
          return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        [resList:resList,totalMoney:total.TOTAL_MONEY,totalCount:total.TOTAL_COUNT]
    }


    static void main (String [] ars){
        def da = (Date.parse('yyyy-MM-dd', '2012-01-31')+1)
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
        println   sf.format(da)

        println   sf.format(Date.parse('yyyy-MM-dd', '2012-01-31')+1)

    }

}
