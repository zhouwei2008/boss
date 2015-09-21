package boss

import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import ismp.CmCustomer
import java.text.SimpleDateFormat
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate
import ismp.CmCorporationInfo

class ReportRoyaltyService {
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
//
//        computeRoyaltyPay(now)
//        computeRoyaltyRefund(now)
//        computeSettleAndFeeAmount(now)

        def now = new GregorianCalendar()
        now.setTime(day+1)
        def tmp = new GregorianCalendar()
        tmp.setTime(day)
        def sdf = new SimpleDateFormat("yyyy-MM-dd")
        startTime = sdf.format(tmp.getTime())+" 00:00:00"
        endTime = sdf.format(now.getTime())+" 00:00:00"

        def agents=[:]
        isExist(agents,tmp)
        computeRoyaltyPay(agents,tmp)
        computeRoyaltyRefund(agents,tmp)
        computeSettleAndFeeAmount(agents,tmp)
        updateCustomerType(agents)
    }

   def isExist(agents,time){
        //每日统计标记
        def dailyStr = new SimpleDateFormat("yyyyMMdd").format(time.getTime())
        //查询是否已经存在当日统计
        def  reportRoyaltyDaily = ReportRoyaltyDaily.findAllByDailyFlag(dailyStr)
        println ' isExist = '+reportRoyaltyDaily
        if(reportRoyaltyDaily!=null&&reportRoyaltyDaily.size()>0){
             reportRoyaltyDaily.each { df->
                  agents[df.customerNo]=df
                  df.clear()
             }
        }
    }
    def computeRoyaltyPay(agents,time){
//        select t.PAYEE_ID, max(c.CUSTOMER_NO) CUSTOMER_NO, max(c.NAME),
//                           count(t.ID) royaltyPayNum, sum(t.AMOUNT) royaltyPayAmount
//                    from TRADE_BASE t
//                    left join CM_CUSTOMER c
//                    on t.PAYEE_ID = c.id
//                    where c.id is not null
//                          and t.DATE_CREATED >= to_date('${startTime}','yyyy-mm-dd hh24:mi:ss')
//                          and t.DATE_CREATED <= to_date('${endTime}','yyyy-mm-dd hh24:mi:ss')
//                          and t.TRADE_TYPE='royalty'
//                          and t.status='completed'
//                    group by t.PAYEE_ID
//                    order by t.PAYEE_ID
        def query = """
                    select t.PARTNER_ID, t.royaltyPayNum, t.royaltyPayAmount,t.royaltyFeeAmount, c.CUSTOMER_NO, c.NAME
                    from (
                            select tb.PARTNER_ID, count(tp.ID) royaltyPayNum, sum(tb.AMOUNT) royaltyPayAmount , sum(tb.FEE_AMOUNT) royaltyFeeAmount
                            from TRADE_PAYMENT tp, TRADE_BASE tb
                            where tp.ID = tb.ID
                                  and tp.ROYALTY_TYPE=10
                                  and tp.ROYALTY_STATUS='completed'
                                  and tb.TRADE_TYPE='payment'
                                  and tb.STATUS='completed'
                                  and tb.DATE_CREATED >= to_date('${startTime}','yyyy-mm-dd hh24:mi:ss')
                                  and tb.DATE_CREATED < to_date('${endTime}','yyyy-mm-dd hh24:mi:ss')
                            group by tb.PARTNER_ID
                            order by tb.PARTNER_ID
                         ) t
                    left join CM_CUSTOMER c
                    on t.PARTNER_ID = c.ID
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

//        result?.each {
//            def rep = ReportRoyaltyDaily.findByCustomerNoAndDailyFlag(it.CUSTOMER_NO, dailyStr)
//            if(rep){
//                rep.royaltyPayNum = it.ROYALTYPAYNUM
//                rep.royaltyPayAmount = it.ROYALTYPAYAMOUNT
//            }else{
//                rep = new ReportRoyaltyDaily()
//                def corpCM = CmCustomer.findByCustomerNo(it.CUSTOMER_NO)
//                rep.area = corpCM?.belongToArea
//                rep.customerNo = it.CUSTOMER_NO
//                rep.customerName = corpCM?.registrationName
//                rep.dailyFlag = dailyStr
//                rep.tradeDate = it.TRADEDATE
//                rep.royaltyPayNum = it.ROYALTYPAYNUM
//                rep.royaltyPayAmount = it.ROYALTYPAYAMOUNT
//                rep.royaltyRefundNum = 0
//                rep.royaltyRefundAmount = 0
//                rep.settleAmount = 0
//                rep.feeAmount = 0
//            }
//
//            rep.save(failOnError: true)
//        }

        result?.each {
            def customerNo = it.CUSTOMER_NO as String
            ReportRoyaltyDaily rep = agents[customerNo]
            if(rep==null){
                rep = new ReportRoyaltyDaily()
                agents[customerNo]=rep
            }
            rep.customerNo = customerNo
            rep.dailyFlag = dailyStr
            rep.tradeDate = time.getTime()
            rep.royaltyPayNum = it.ROYALTYPAYNUM
            rep.royaltyPayAmount = it.ROYALTYPAYAMOUNT
            rep.feeAmount = it.ROYALTYFEEAMOUNT
        }
    }

    def computeRoyaltyRefund(agents,time){
        def query = """
                    select t.PARTNER_ID, max(c.CUSTOMER_NO) CUSTOMER_NO, max(c.NAME),
                           count(t.ID) royaltyRefundNum, sum(t.AMOUNT) royaltyRefundAmount
                    from TRADE_BASE t
                    left join CM_CUSTOMER c
                    on t.PARTNER_ID = c.id
                    where c.id is not null
                          and t.DATE_CREATED >= to_date('${startTime}','yyyy-mm-dd hh24:mi:ss')
                          and t.DATE_CREATED < to_date('${endTime}','yyyy-mm-dd hh24:mi:ss')
                          and t.TRADE_TYPE='royalty_rfd'
                          and t.status='completed'
                    group by t.PARTNER_ID
                    order by t.PARTNER_ID
                  """
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list();
        } as HibernateCallback)

        def dailyStr = new SimpleDateFormat("yyyyMMdd").format(time.getTime())

        log.info "####${result}"

//        result?.each {
//            def rep = ReportRoyaltyDaily.findByCustomerNoAndDailyFlag(it.CUSTOMER_NO, dailyStr)
//            if(rep){
//                rep.royaltyRefundNum = it.ROYALTYREFUNDNUM
//                rep.royaltyRefundAmount = it.ROYALTYREFUNDAMOUNT
//                rep.save(failOnError: true)
//            }else{
//
//                log.error("${it.CUSTOMER_NO} have royaltyRefund, but does not have record of report!")
//            }
//        }

        result?.each {
            def customerNo = it.CUSTOMER_NO as String
            ReportRoyaltyDaily rep = agents[customerNo]
            if(rep==null){
                rep = new ReportRoyaltyDaily()
                agents[customerNo]=rep
            }
//            if(rep!=null){
                rep.customerNo = customerNo
                rep.dailyFlag = dailyStr
                rep.tradeDate = time.getTime()
                rep.royaltyRefundNum = rep.royaltyRefundNum +it.ROYALTYREFUNDNUM
                rep.royaltyRefundAmount = rep.royaltyRefundAmount+it.ROYALTYREFUNDAMOUNT
//            }
        }
    }

    def computeSettleAndFeeAmount(agents,time){
//        def query = """
//                        select c.CUSTOMER_NO, t2.FEE_AMOUNT, t3.BACK_FEE
//                        from (
//                               select t.PAYEE_ID, t.ROOT_ID
//                               from TRADE_BASE t
//                               where t.TRADE_TYPE='royalty'
//                                     and t.status='completed'
//                                     and t.DATE_CREATED >= to_date('${startTime}','yyyy-mm-dd hh24:mi:ss')
//                                     and t.DATE_CREATED < to_date('${endTime}','yyyy-mm-dd hh24:mi:ss')
//                               group by t.PAYEE_ID, t.ROOT_ID
//                               order by t.PAYEE_ID
//                             ) t1
//                        left join (
//                                    select t.PAYEE_ID, t.ROOT_ID, sum(t.FEE_AMOUNT) FEE_AMOUNT
//                                    from TRADE_BASE t
//                                    where t.TRADE_TYPE='payment'
//                                          and t.status='completed'
//                                    group by t.PAYEE_ID, t.ROOT_ID
//                                  ) t2
//                        on t1.ROOT_ID = t2.ROOT_ID
//                        left join (
//                                    select t.PAYEE_ID, t.ROOT_ID, sum(tr.BACK_FEE) BACK_FEE
//                                    from TRADE_BASE t, TRADE_REFUND tr
//                                    where t.ID = tr.ID
//                                          and t.TRADE_TYPE='refund'
//                                          and t.status='completed'
//                                    group by t.PAYEE_ID, t.ROOT_ID
//                                  ) t3
//                        on t1.ROOT_ID = t3.ROOT_ID
//                        left join CM_CUSTOMER c
//                        on t1.PAYEE_ID = c.id
//                        where
//                        t2.ROOT_ID is not null
//                        and c.id is not null
//                  """

                def query = """
                        select c.CUSTOMER_NO, t3.BACK_FEE
                        from (
                               select t.PARTNER_ID, t.ROOT_ID
                               from TRADE_BASE t
                               where t.TRADE_TYPE='royalty_rfd'
                                     and t.status='completed'
                                     and t.DATE_CREATED >= to_date('${startTime}','yyyy-mm-dd hh24:mi:ss')
                                     and t.DATE_CREATED < to_date('${endTime}','yyyy-mm-dd hh24:mi:ss')
                               group by t.PARTNER_ID, t.ROOT_ID
                               order by t.PARTNER_ID
                             ) t1
                        left join (
                                    select t.PARTNER_ID, t.ROOT_ID, sum(tr.BACK_FEE) BACK_FEE
                                    from TRADE_BASE t, TRADE_REFUND tr
                                    where t.ID = tr.ID
                                          and t.TRADE_TYPE='refund'
                                          and t.status='completed'
                                    group by t.PARTNER_ID, t.ROOT_ID
                                  ) t3
                        on t1.ROOT_ID = t3.ROOT_ID
                        left join CM_CUSTOMER c
                        on t1.PARTNER_ID = c.id
                        where
                         c.id is not null
                  """
                HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
                def result = ht.executeFind({ Session session ->
                    def sqlQuery = session.createSQLQuery(query.toString())
                    sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                    return sqlQuery.list();
                } as HibernateCallback)

                def dailyStr = new SimpleDateFormat("yyyyMMdd").format(time.getTime())

                log.info "####${result}"


//        result?.each {
//            def rep = ReportRoyaltyDaily.findByCustomerNoAndDailyFlag(it.CUSTOMER_NO, dailyStr)
//            def fee = it.FEE_AMOUNT?it.FEE_AMOUNT:0 - it.BACK_FEE?it.BACK_FEE:0
//            if(rep){
//                rep.settleAmount = rep.royaltyPayAmount - rep.royaltyRefundAmount - fee
//                if(rep.settleAmount < 0){
//                    rep.settleAmount = 0
//                }
//                rep.feeAmount = fee
//                rep.save(failOnError: true)
//            }else{
//
//                log.error("${it.CUSTOMER_NO} have fee_amount, but does not have record of report!")
//            }
//        }

         result?.each {
            def customerNo = it.CUSTOMER_NO as String
            ReportRoyaltyDaily rep = agents[customerNo]
            if(rep==null){
                rep = new ReportRoyaltyDaily()
                agents[customerNo]=rep
            }
//            if(rep!=null){
               rep.customerNo = customerNo
               rep.dailyFlag = dailyStr
               rep.tradeDate = time.getTime()
               def b =it.BACK_FEE?it.BACK_FEE:0
               rep.feeAmount =rep.feeAmount-b
               rep.settleAmount = (rep.royaltyPayAmount?rep.royaltyPayAmount:0) - (rep.royaltyRefundAmount?rep.royaltyRefundAmount:0) - (rep.feeAmount?rep.feeAmount:0)
//            }
         }
    }


    def  updateCustomerType(agents){
         agents?.each {
            ReportRoyaltyDaily rep =((ReportRoyaltyDaily)(it.value))
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