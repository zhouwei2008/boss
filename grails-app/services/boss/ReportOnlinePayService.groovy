package boss

import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import ismp.CmCustomer
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate
import java.text.SimpleDateFormat
import settle.FtSrvFootSetting
import settle.FtTrade
import ismp.CmCorporationInfo

class ReportOnlinePayService {
    static transactional = true

    def startTime = ""
    def endTime = ""

    def report(day) {
//        def now = new GregorianCalendar()
//        def tmp = new GregorianCalendar()
//        tmp.add(Calendar.DAY_OF_MONTH, -1)
//        def sdf = new SimpleDateFormat("yyyy-MM-dd")
//        startTime = sdf.format(tmp.getTime())+" 00:00:00"
//        endTime = sdf.format(new Date())+" 00:00:00"
//        computeBankPay(now)
//        computeBalancePay(now)
//        computeBankRefund(now)
//        computeBalanceRefund(now)
//        computeSettleAndFeeAmount(now)

        def now = new GregorianCalendar()
        now.setTime(day+1)
        def tmp = new GregorianCalendar()
        tmp.setTime(day)
        def sdf = new SimpleDateFormat("yyyy-MM-dd")
        startTime = sdf.format(tmp.getTime())+" 00:00:00"
        endTime = sdf.format(now.getTime())+" 00:00:00"

        def agents=[:]
        def guestAcc
        isExist(agents,tmp)
        computeBankPay(agents,tmp)
        computeBalancePay(agents,tmp)
        guestAcc= queryGuestAcc()
        computeBankRefund(agents,tmp,guestAcc)
        computeBalanceRefund(agents,tmp,guestAcc)
        computeSettleAndFeeAmount(agents,tmp)
        updateCustomerType(agents)
    }

    def isExist(agents,time){
        //每日统计标记
        def dailyStr = new SimpleDateFormat("yyyyMMdd").format(time.getTime())
        //查询是否已经存在当日统计
        def  reportOnlineDailys = ReportOnlinePayDaily.findAllByDailyFlag(dailyStr)
        println ' isExist = '+reportOnlineDailys
        if(reportOnlineDailys!=null&&reportOnlineDailys.size()>0){
             reportOnlineDailys.each { df->
                  agents[df.customerNo]=df
                  df.clear()
             }
        }
    }


    def computeBankPay(agents,time){
        def query = """
                    select o.PARTNERID,count(o.ID) bankPayNum,sum(t.AMOUNT) bankPayAmount
                    from GWORDERS o
                    left join (
                                select g.GWORDERS_ID,g.AMOUNT
                                from GWTRXS g
                                where g.TRXSTS='1' and g.TRXTYPE='100' and (g.CHANNEL='1' or g.CHANNEL='2')
                              ) t
                    on o.ID = t.GWORDERS_ID
                    where t.GWORDERS_ID is not null
                          and o.AMOUNT = t.AMOUNT
                          and o.ORDERSTS = '3'
                          and (o.ROYALTY_TYPE != '10' or o.ROYALTY_TYPE is null)
                          and o.CLOSEDATE >= to_date('${startTime}','yyyy-mm-dd hh24:mi:ss')
                          and o.CLOSEDATE < to_date('${endTime}','yyyy-mm-dd hh24:mi:ss')
                    group by o.PARTNERID
                    order by o.PARTNERID
                  """
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list();
        } as HibernateCallback)

        def dailyStr = new SimpleDateFormat("yyyyMMdd").format(time.getTime())

        log.info "####${result}"

        result?.each {
            def customerNo = it.PARTNERID as String
            ReportOnlinePayDaily rep = agents[customerNo]
            if(rep==null){
                rep = new ReportOnlinePayDaily()
                agents[customerNo]=rep
            }
            rep.customerNo = customerNo
            rep.dailyFlag = dailyStr
            rep.tradeDate = time.getTime()
            rep.bankPayNum = it.BANKPAYNUM
            rep.bankPayAmount = it.BANKPAYAMOUNT
        }

         //银行+余额要分开
         query = """
                    select o.PARTNERID,o.ID,o.AMOUNT om,t.AMOUNT tm
                    from GWORDERS o
                    left join (
                                select g.GWORDERS_ID,g.AMOUNT
                                from GWTRXS g
                                where g.TRXSTS='1' and g.TRXTYPE='100' and (g.CHANNEL='1' or g.CHANNEL='2')
                              ) t
                    on o.ID = t.GWORDERS_ID
                    where t.GWORDERS_ID is not null
                          and o.AMOUNT != t.AMOUNT
                          and o.ORDERSTS = '3'
                          and (o.ROYALTY_TYPE != '10' or o.ROYALTY_TYPE is null)
                          and o.CLOSEDATE >= to_date('${startTime}','yyyy-mm-dd hh24:mi:ss')
                          and o.CLOSEDATE < to_date('${endTime}','yyyy-mm-dd hh24:mi:ss')
                    order by o.PARTNERID
                  """
         ht = DatasourcesUtils.newHibernateTemplate('ismp')
         result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list();
        } as HibernateCallback)

        log.info "####${result}"
        result?.each {
            def customerNo = it.PARTNERID as String
            ReportOnlinePayDaily rep = agents[customerNo]
            if(rep==null){
                rep = new ReportOnlinePayDaily()
                agents[customerNo]=rep
            }
            rep.customerNo = customerNo
            rep.dailyFlag = dailyStr
            rep.tradeDate = time.getTime()
            rep.bankPayNum = rep.bankPayNum + 1
            rep.bankPayAmount = rep.bankPayAmount + it.TM
            rep.balancePayNum = rep.balancePayNum + 1
            rep.balancePayAmount =rep.balancePayAmount + it.OM-it.TM
        }
    }

    def computeBalancePay(agents,time){
        def query = """
                    select o.PARTNERID,count(o.ID) balancePayNum,sum(o.AMOUNT) balancePayAmount
                    from GWORDERS o
                    left join (
                                select g.GWORDERS_ID,g.AMOUNT
                                from GWTRXS g
                                where g.TRXSTS='1' and g.TRXTYPE='100' and (g.CHANNEL='1' or g.CHANNEL='2')
                              ) t
                    on o.ID = t.GWORDERS_ID
                    where t.GWORDERS_ID is null
                          and o.ORDERSTS = '3'
                          and (o.ROYALTY_TYPE != '10' or o.ROYALTY_TYPE is null)
                          and o.CLOSEDATE >= to_date('${startTime}','yyyy-mm-dd hh24:mi:ss')
                          and o.CLOSEDATE < to_date('${endTime}','yyyy-mm-dd hh24:mi:ss')
                    group by o.PARTNERID
                    order by o.PARTNERID
                  """
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list();
        } as HibernateCallback)

        def dailyStr = new SimpleDateFormat("yyyyMMdd").format(time.getTime())

        log.info "####${result}"

        result?.each {
            def customerNo = it.PARTNERID as String
            ReportOnlinePayDaily rep = agents[customerNo]
            if(rep==null){
                rep = new ReportOnlinePayDaily()
                agents[customerNo]=rep
            }
            rep.customerNo = customerNo
            rep.dailyFlag = dailyStr
            rep.tradeDate = time.getTime()
            rep.balancePayNum = rep.balancePayNum+ it.BALANCEPAYNUM
            rep.balancePayAmount = rep.balancePayAmount+ it.BALANCEPAYAMOUNT
        }
    }

    def queryGuestAcc(){
       def gue = BoInnerAccount.findByKey("guestAcc").accountNo
       return gue
    }

    def computeBankRefund(agents,time,guestAcc){
        def query = """
         select td.PAYER_ID,td.bankRefundNum,td.bankRefundAmount,c.CUSTOMER_NO, c.NAME
              from(
                    select tb.PAYER_ID,count(tb.IDX) bankRefundNum,sum(tb.AMOUNT) bankRefundAmount
                     from (
                        select ta.ROOT_ID,ta.AMOUNT,ta.PAYER_ID,ta.ID IDX,t3.ID IDY
                        from (
                        select t1.ROOT_ID,t1.AMOUNT,t1.PAYER_ID,t1.ID
                        from (
                                select t.ROOT_ID,t.ID,t.AMOUNT,t.PAYER_ID
                                from TRADE_BASE t
                                where t.TRADE_TYPE='refund'
                                and t.STATUS='completed'
                             ) t1
                         left join (
                                    select t.ID
                                    from TRADE_REFUND t
                                    where t.HANDLE_STATUS='completed'
                                            and (
                                            (t.HANDLE_TIME >= to_date('${startTime}','yyyy-mm-dd hh24:mi:ss')
                                            and t.HANDLE_TIME < to_date('${endTime}','yyyy-mm-dd hh24:mi:ss')
                                            )
                                            or
                                            (t.REFUND_RECHECK_DATE >= to_date('${startTime}','yyyy-mm-dd hh24:mi:ss')
                                            and t.REFUND_RECHECK_DATE < to_date('${endTime}','yyyy-mm-dd hh24:mi:ss')
                                            )
                                        )
                                  ) t2
                        on t1.ID = t2.ID
                        where t2.ID is not null
                         ) ta
                        left join (
                                    select t.ROOT_ID,t.ID
                                    from TRADE_BASE t
                                    where t.TRADE_TYPE='payment' and (t.STATUS='completed' or t.STATUS='closed')
                                    and t.PAYER_ACCOUNT_NO ='${guestAcc}'
                                  ) t3
                        on ta.ROOT_ID = t3.ROOT_ID
                        where t3.ROOT_ID is not null
                        )  tb
                        left join TRADE_PAYMENT tc
                        on tb.IDY = tc.ID
                        where tc.ID is not null
                        and (tc.ROYALTY_TYPE != '10' or tc.ROYALTY_TYPE is null)
                        group by tb.PAYER_ID
                         ) td
                    left join CM_CUSTOMER c
                    on td.PAYER_ID = c.ID
                    where c.id is not null

                  """
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list();
        } as HibernateCallback)

        def dailyStr = new SimpleDateFormat("yyyyMMdd").format(time.getTime())

        log.info "####${result}"

        result?.each {
            def customerNo = it.CUSTOMER_NO as String
            ReportOnlinePayDaily rep = agents[customerNo]
            if(rep==null){
                rep = new ReportOnlinePayDaily()
                agents[customerNo]=rep
            }
            rep.customerNo = customerNo
            rep.dailyFlag = dailyStr
            rep.tradeDate = time.getTime()
            rep.bankRefundNum = it.BANKREFUNDNUM
            rep.bankRefundAmount = it.BANKREFUNDAMOUNT
        }
    }


    def computeBalanceRefund(agents,time,guestAcc){
        def query = """

          select td.PAYER_ID,td.balanceRefundNum,td.balanceRefundAmount,c.CUSTOMER_NO, c.NAME
              from(
                    select tb.PAYER_ID,count(tb.IDX) balanceRefundNum,sum(tb.AMOUNT) balanceRefundAmount
                     from (
                       select ta.ROOT_ID,ta.AMOUNT,ta.PAYER_ID,ta.ID IDX,t3.ID IDY
                        from (
                        select t1.ROOT_ID,t1.AMOUNT,t1.PAYER_ID,t1.ID
                        from (
                                select t.ROOT_ID,t.ID,t.AMOUNT,t.PAYER_ID
                                from TRADE_BASE t
                                where t.TRADE_TYPE='refund' and t.STATUS='completed'
                                and t.DATE_CREATED >= to_date('${startTime}','yyyy-mm-dd hh24:mi:ss')
                                and t.DATE_CREATED < to_date('${endTime}','yyyy-mm-dd hh24:mi:ss')

                             ) t1
                         left join (
                                    select t.ID
                                    from TRADE_REFUND t
                                    where t.HANDLE_STATUS='completed'
                                  ) t2
                        on t1.ID = t2.ID
                        where t2.ID is not null
                         ) ta
                        left join (
                                    select t.ROOT_ID,t.ID
                                    from TRADE_BASE t
                                    where t.TRADE_TYPE='payment' and (t.STATUS='completed' or t.STATUS='closed')
                                    and t.PAYER_ACCOUNT_NO !='${guestAcc}'
                                  ) t3
                        on ta.ROOT_ID = t3.ROOT_ID
                        where t3.ROOT_ID is not null
                        )  tb
                        left join TRADE_PAYMENT tc
                        on tb.IDY = tc.ID
                        where tc.ID is not null
                        and (tc.ROYALTY_TYPE != '10' or tc.ROYALTY_TYPE is null)
                        group by tb.PAYER_ID
                         ) td
                    left join CM_CUSTOMER c
                    on td.PAYER_ID = c.ID
                    where c.id is not null
                  """
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list();
        } as HibernateCallback)

        def dailyStr = new SimpleDateFormat("yyyyMMdd").format(time.getTime())

        log.info "####${result}"

        result?.each {
            def customerNo = it.CUSTOMER_NO as String
            ReportOnlinePayDaily rep = agents[customerNo]
            if(rep==null){
                rep = new ReportOnlinePayDaily()
                agents[customerNo]=rep
            }

            rep.customerNo = customerNo
            rep.dailyFlag = dailyStr
            rep.tradeDate = time.getTime()
            rep.balanceRefundNum = it.BALANCEREFUNDNUM
            rep.balanceRefundAmount = it.BALANCEREFUNDAMOUNT
        }
    }

    def computeSettleAndFeeAmount(agents,time){
//        def query = """
//                    select l.CUSTOMER_NO,max(l.FEE_TYPE) feeType,sum(l.PRE_FEE) preFeeAmount,
//                           sum(l.POST_FEE) postFeeAmount,sum(l.AMOUNT) settleAmount
//                    from FT_LIQUIDATE l
//                    where l.SRV_CODE='online'
//                          and l.LIQ_DATE >= to_date('${startTime.substring(0,10)}','yyyy-mm-dd')
//                          and l.LIQ_DATE <= to_date('${endTime.substring(0,10)}','yyyy-mm-dd')
//                    group by l.CUSTOMER_NO
//                    order by l.CUSTOMER_NO
//                  """

                def query = """
                    select l.CUSTOMER_NO,sum(l.PRE_FEE) preFeeAmount,
                           sum(l.POST_FEE) postFeeAmount,sum(l.AMOUNT) settleAmount
                    from FT_LIQUIDATE l
                    where l.SRV_CODE='online'
                          and SETTLE_TYPE='0'
                          and l.LIQ_DATE >= to_date('${startTime}','yyyy-mm-dd hh24:mi:ss')
                          and l.LIQ_DATE < to_date('${endTime}','yyyy-mm-dd hh24:mi:ss')
                    group by l.CUSTOMER_NO
                    union all
                    select t.CUSTOMER_NO,sum(t.PRE_FEE) preFeeAmount,
                           sum(t.POST_FEE) postFeeAmount,sum(t.net_amount) settleAmount
                    from ft_trade t
                    where t.SRV_CODE='online'
                          and REALTIME_SETTLE='1'
                          and t.DATE_CREATED >= to_date('${startTime}','yyyy-mm-dd hh24:mi:ss')
                          and t.DATE_CREATED < to_date('${endTime}','yyyy-mm-dd hh24:mi:ss')
                    group by t.CUSTOMER_NO
                  """
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list();
        } as HibernateCallback)

        def dailyStr = new SimpleDateFormat("yyyyMMdd").format(time.getTime())

        log.info "####${result}"

        result?.each {
            def customerNo = it.CUSTOMER_NO as String
            ReportOnlinePayDaily rep = agents[customerNo]
            if(rep==null){
                rep = new ReportOnlinePayDaily()
                agents[customerNo]=rep
            }
            def a = ((it.SETTLEAMOUNT?it.SETTLEAMOUNT:0) as Long)
            rep.settleAmount = rep.settleAmount+ a
            def b = ((it.POSTFEEAMOUNT?it.POSTFEEAMOUNT:0) as Long)
            def c = ((it.PREFEEAMOUNT?it.PREFEEAMOUNT:0) as Long)
            rep.feeAmount = rep.feeAmount+b+c
//            def fee = (it.FEETYPE == 0) ? it.PREFEEAMOUNT : it.POSTFEEAMOUNT
//            def amt = it.SETTLEAMOUNT
//
//            def footSetting = FtSrvFootSetting.findByCustomerNo(customerNo)
//
//            if(footSetting && footSetting.footType == 0){// 实时结算情况
//                def q = {
//                    eq('customerNo', customerNo)
//                }
//                FtTrade.createCriteria().list([:],q)
//                //fee = 0
//                //amt = 0
//            }
//
//            if(rep){
//                rep.settleAmount = amt
//                rep.feeAmount = fee
//                 rep.save(failOnError: true)
//            }
        }
    }

    def  updateCustomerType(agents){
         agents?.each {
            ReportOnlinePayDaily rep =((ReportOnlinePayDaily)(it.value))
             //商户类型
            def customer
            if(!rep.area){
               customer=CmCorporationInfo.findByCustomerNo(it.key)
               rep.area = customer?.belongToArea
            }
            if(!rep.customerName){
                if(!customer){
                  customer=CmCustomer.findByCustomerNo(it.key)
                }
                rep.customerName = customer?.name
            }
             if(!rep.customerType){
               rep.customerType=customer?.type
             }
             if(!rep.customerId){
               rep.customerId=customer?.id
             }
             rep.save(flush:true)
         }
    }
}