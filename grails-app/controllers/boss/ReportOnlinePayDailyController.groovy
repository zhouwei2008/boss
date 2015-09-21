package boss

import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import groovy.sql.Sql
import ismp.CmCustomer
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate
import org.apache.commons.lang.StringUtils

class ReportOnlinePayDailyController {
    def dataSource_boss

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        params.sort = params.sort ? params.sort : "sa"
        params.order = params.order ? params.order : "desc"

//        def query = {
//            if (!StringUtils.isEmpty(params.customerName)) {
//                like("customerName","%"+params.customerName?.trim()+"%")
//            }
//            if (params.startTime) {
//                ge('tradeDate', Date.parse("yyyy-MM-dd", params.startTime))
//            }else{
//                def gCalendar= new GregorianCalendar()
//                gCalendar.add(GregorianCalendar.MONTH,-1)
//                params.startTime=gCalendar.time.format('yyyy-MM-dd')
//                ge('tradeDate', gCalendar.time)
//            }
//            if (params.endTime) {
//                lt('tradeDate', (Date.parse("yyyy-MM-dd", params.endTime) + 1))
//            }else{
//                def end = new Date()-1
//                params.endTime = end.format('yyyy-MM-dd')
//                lt('tradeDate', end+1)
//            }
//            projections {
//                    sum('bankPayNum')
//                    sum('bankPayAmount')
//                    sum('balancePayNum')
//                    sum('balancePayAmount')
//                    sum('bankRefundNum')
//                    sum('bankRefundAmount')
//                    sum('balanceRefundNum')
//                    sum('balanceRefundAmount')
//                    sum('settleAmount')
//                    sum('feeAmount')
//                    groupProperty("customerNo")
//            }
//        }
//
//        def result = ReportOnlinePayDaily.createCriteria().list(params, query)
//        def total = ReportOnlinePayDaily.createCriteria().count(query)
//
//        def sumList = ReportOnlinePayDaily.createCriteria().get {
//                projections {
//                    sum('bankPayNum')
//                    sum('bankPayAmount')
//                    sum('balancePayNum')
//                    sum('balancePayAmount')
//                    sum('bankRefundNum')
//                    sum('bankRefundAmount')
//                    sum('balanceRefundNum')
//                    sum('balanceRefundAmount')
//                    sum('settleAmount')
//                    sum('feeAmount')
//                }
//                if (!StringUtils.isEmpty(params.customerName)) {
//                    like("customerName","%"+params.customerName?.trim()+"%")
//                }
//                if (params.startTime) {
//                    ge('tradeDate', Date.parse("yyyy-MM-dd", params.startTime))
//                }else{
//                    def gCalendar= new GregorianCalendar()
//                    gCalendar.add(GregorianCalendar.MONTH,-1)
//                    params.startTime=gCalendar.time.format('yyyy-MM-dd')
//                    ge('tradeDate', gCalendar.time)
//                }
//                if (params.endTime) {
//                    lt('tradeDate', (Date.parse("yyyy-MM-dd", params.endTime) + 1))
//                }else{
//                    def end = new Date()-1
//                    params.endTime = end.format('yyyy-MM-dd')
//                    lt('tradeDate', end+1)
//                }
//            }
       validDated(params)
         def queryParam = []
      def  query = """select customer_no
           ,customer_name
           ,area
           ,sum(bank_pay_num) bpn
           ,sum(bank_pay_amount) bpa
           ,sum(balance_pay_num) lpn
           ,sum(balance_pay_amount) lpa
           ,sum(bank_refund_num) brn
           ,sum(bank_refund_amount) bra
           ,sum(balance_refund_num) lrn
           ,sum(balance_refund_amount) lra
           ,sum(settle_amount) sa
           ,sum(fee_amount) sf
           ,sum(bank_pay_num)+sum(balance_pay_num)+sum(bank_refund_num)+sum(balance_refund_num) nn
           ,sum(bank_pay_amount)+sum(balance_pay_amount)-sum(bank_refund_amount)-sum(balance_refund_amount) na
       from report_online_pay_daily
       where 2>1
            ${params.startTime? " and trade_date>=to_date('"+params.startTime+" 00:00:00','yyyy-mm-dd hh24:mi:ss')":""}
            ${params.endTime? " and trade_date<=to_date('"+params.endTime+" 23:59:59','yyyy-mm-dd hh24:mi:ss')":""}
            ${params.customerName ? " and customer_name like '%"+params.customerName+"%'" : ""}　　
            group by customer_no,customer_name,area
            order by ${params.sort} ${params.order}  ${params.order=='desc' ? " nulls last" : " nulls first"} ${params.sort?",":""}  customer_no ${params.order}
       """

       def sql = new Sql(dataSource_boss)
        def count = sql.firstRow("select count(*) total from (${query})", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }
            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        //合计
        def totalAgent = sql.firstRow("select sum(bpn) tbpn,sum(bpa) tbpa,sum(lpn) tlpn,sum(lpa) tlpa,sum(brn) tbrn,sum(bra) tbra,sum(lrn) tlrn,sum(lra) tlra,sum(sa) tsa,sum(sf) tsf,sum(nn) tnn,sum(na) tna  from (${query})", queryParam)

        [list: result, total:count.total, sumList:totalAgent]
    }


    def validDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startTime==null && params.endTime==null){
            def gCalendar= new GregorianCalendar()
            gCalendar.add(GregorianCalendar.DATE,-1)
            params.endTime=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startTime=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startTime && !params.endTime){
             params.endTime=params.startTime
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startTime && params.endTime){
             params.startTime=params.endTime
        }
        if (params.startTime && params.endTime) {

        }
    }

    def listDownload = {
        params.max = 50000
        params.offset = 0
        params.sort = params.sort ? params.sort : "sa"
        params.order = params.order ? params.order : "desc"
//        def query = {
//            if (!StringUtils.isEmpty(params.customerName)) {
//                like("customerName","%"+params.customerName?.trim()+"%")
//            }
//            if (params.startTime) {
//                gt('tradeDate', Date.parse("yyyy-MM-dd", params.startTime).format("yyyyMMdd"))
//            }else{
//                def gCalendar= new GregorianCalendar()
//                gCalendar.add(GregorianCalendar.MONTH,-1)
//                params.startTime=gCalendar.time.format('yyyy-MM-dd')
//                gt('tradeDate', gCalendar.time.format("yyyyMMdd"))
//            }
//            if (params.endTime) {
//                lt('tradeDate', (Date.parse("yyyy-MM-dd", params.endTime) + 1).format("yyyyMMdd"))
//            }else{
//                def end = new Date()
//                params.endTime = end.format('yyyy-MM-dd')
//                lt('tradeDate', end.format("yyyyMMdd"))
//            }
//        }
//
//        def result = ReportOnlinePayDaily.createCriteria().list(params, query)
//        //def total = ReportOnlinePayDaily.createCriteria().count(query)
//
//        def sumList = ReportOnlinePayDaily.createCriteria().get {
//            projections {
//                sum('bankPayNum')
//                sum('bankPayAmount')
//                sum('balancePayNum')
//                sum('balancePayAmount')
//                sum('bankRefundNum')
//                sum('bankRefundAmount')
//                sum('balanceRefundNum')
//                sum('balanceRefundAmount')
//                sum('settleAmount')
//                sum('feeAmount')
//            }
//
//            if (!StringUtils.isEmpty(params.customerName)) {
//                like("customerName","%"+params.customerName?.trim()+"%")
//            }
//            if (params.startTime) {
//                gt('tradeDate', Date.parse("yyyy-MM-dd", params.startTime).format("yyyyMMdd"))
//            }else{
//                def gCalendar= new GregorianCalendar()
//                gCalendar.add(GregorianCalendar.MONTH,-1)
//                params.startTime=gCalendar.time.format('yyyy-MM-dd')
//                gt('tradeDate', gCalendar.time.format("yyyyMMdd"))
//            }
//            if (params.endTime) {
//                lt('tradeDate', (Date.parse("yyyy-MM-dd", params.endTime) + 1).format("yyyyMMdd"))
//            }else{
//                def end = new Date()
//                params.endTime = end.format('yyyy-MM-dd')
//                lt('tradeDate', end.format("yyyyMMdd"))
//            }
//        }
        validDated(params)
                 def queryParam = []
              def  query = """select customer_no
                   ,customer_name
                   ,area
                   ,sum(bank_pay_num) bpn
                   ,sum(bank_pay_amount) bpa
                   ,sum(balance_pay_num) lpn
                   ,sum(balance_pay_amount) lpa
                   ,sum(bank_refund_num) brn
                   ,sum(bank_refund_amount) bra
                   ,sum(balance_refund_num) lrn
                   ,sum(balance_refund_amount) lra
                   ,sum(settle_amount) sa
                   ,sum(fee_amount) sf
                   ,sum(bank_pay_num)+sum(balance_pay_num)+sum(bank_refund_num)+sum(balance_refund_num) nn
                   ,sum(bank_pay_amount)+sum(balance_pay_amount)-sum(bank_refund_amount)-sum(balance_refund_amount) na
               from report_online_pay_daily
               where 2>1
                    ${params.startTime? " and trade_date>=to_date('"+params.startTime+" 00:00:00','yyyy-mm-dd hh24:mi:ss')":""}
                    ${params.endTime? " and trade_date<=to_date('"+params.endTime+" 23:59:59','yyyy-mm-dd hh24:mi:ss')":""}
                    ${params.customerName ? " and customer_name like '%"+params.customerName+"%'" : ""}　　
                    group by customer_no,customer_name,area
                    order by ${params.sort} ${params.order}  ${params.order=='desc' ? " nulls last" : " nulls first"} ${params.sort?",":""}  customer_no ${params.order}
               """

               def sql = new Sql(dataSource_boss)
                def count = sql.firstRow("select count(*) total from (${query})", queryParam)

                HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
                def result = ht.executeFind({ Session session ->
                    def sqlQuery = session.createSQLQuery(query.toString())
                    sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                    for (def i = 0; i < queryParam.size(); i++) {
                        sqlQuery.setParameter(i, queryParam.get(i))
                    }
                    return sqlQuery.list();
                } as HibernateCallback)

                //合计
                def totalAgent = sql.firstRow("select sum(bpn) tbpn,sum(bpa) tbpa,sum(lpn) tlpn,sum(lpa) tlpa,sum(brn) tbrn,sum(bra) tbra,sum(lrn) tlrn,sum(lra) tlra,sum(sa) tsa,sum(sf) tsf,sum(nn) tnn,sum(na) tna  from (${query})", queryParam)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "reportOnlinePayDailyInfolist", model: [list: result,total:count.total, sumList:totalAgent])
    }
}