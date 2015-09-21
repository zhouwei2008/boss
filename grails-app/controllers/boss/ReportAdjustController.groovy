package boss

import groovy.sql.Sql
import org.springframework.orm.hibernate3.HibernateTemplate
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import java.text.SimpleDateFormat

/**
 * Created by IntelliJ IDEA.
 * User: shuo_zhang
 * Date: 12-2-17
 * Time: 上午11:33
 * To change this template use File | Settings | File Templates.
 */
class ReportAdjustController {
    def dataSource_boss

    def queryAdjustDailyShow = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null

        if(startDate && endDate){
            Calendar   calendar   =   Calendar.getInstance();
            calendar.setTime(startDate);

            calendar.add(Calendar.MONTH,6)
            def maxDate = calendar.getTime();
            if(startDate.getTime()>endDate.getTime()){
                flash.message ="起始日期应小于截止日期"
                return
            }
            if(maxDate.getTime()<endDate.getTime()){
                flash.message ="起始日期与截止日期间隔应小于6个月"
                return
            }



            def former = "yyyyMMdd"
            SimpleDateFormat   df   =   new   SimpleDateFormat(former);

            def nowDate = new Date()
            if(nowDate + 1< endDate){
                flash.message ="截止日期最大应为今天"
                return
            }

            //获得数据总数
            def queryParam = []
            queryParam.add(new java.sql.Date(startDate.getTime()))
            queryParam.add(new java.sql.Date(endDate.getTime()))

            def sql = new Sql(dataSource_boss)
            def totalSql = """select count(*) as tt
                        from report_adjust_daily t
                     where t.date_created >= ?
                       and t.date_created < ?
                     order by t.date_created desc
            """

            HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
            def ttResult = ht.execute({ Session session ->
                def sqlquery = session.createSQLQuery(totalSql.toString())
                sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                for (def i = 0; i < queryParam.size(); i++) {
                    sqlquery.setParameter(i, queryParam.get(i))
                }
                return sqlquery.list()//setFirstResult(params.offset).setMaxResults(params.max).list();
            } as HibernateCallback)

            //获得数据
            def querySql = """
                    select t.debit_adjust_amount,
                           t.credit_adjust_amount,
                           t.plat_fee,
                           t.bank_fee,
                           t.bank_adjust_charge,
                           t.bank_adjust_withdrawn,
                           t.debit_sum,
                           t.credit_sum,
                           to_char(t.date_created,'yyyy-mm-dd') as dc
                      from report_adjust_daily t
                     where t.date_created >= ?
                       and t.date_created < ?
                     order by t.date_created desc
            """


//            def queryResults = sql.rows(querySql,[queryParam])

//            ht = DatasourcesUtils.newHibernateTemplate('boss')
            def queryResults = ht.executeFind({ Session session ->
                def sqlquery = session.createSQLQuery(querySql.toString())
                sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                for (def i = 0; i < queryParam.size(); i++) {
                    sqlquery.setParameter(i, queryParam.get(i))
                }
                return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
            } as HibernateCallback)
            //数据统计
            def queryTotalSql = """
                    select sum(t.debit_adjust_amount) as da,
                           sum(t.credit_adjust_amount) as ca,
                           sum(t.plat_fee) as pf,
                           sum(t.bank_fee) as bf,
                           sum(t.bank_adjust_charge) as bac,
                           sum(t.bank_adjust_withdrawn) as baw,
                           sum(t.debit_sum) as ds,
                           sum(t.credit_sum) as cs
                      from report_adjust_daily t
                     where t.date_created >= ?
                       and t.date_created < ?
            """

            def queryTotalResults = sql.firstRow(queryTotalSql,queryParam)


            [list:queryResults,total:ttResult?ttResult[0]?ttResult[0].get("TT"):0:0,
                    dA:queryTotalResults.get("DA")?queryTotalResults.get("DA")/100:0,
                    cA:queryTotalResults.get("CA")?queryTotalResults.get("CA")/100:0,
                    pF:queryTotalResults.get("PF")?queryTotalResults.get("PF")/100:0,
                    bF:queryTotalResults.get("BF")?queryTotalResults.get("BF")/100:null,
                    bAC:queryTotalResults.get("BAC")?queryTotalResults.get("BAC")/100:0,
                    bAW:queryTotalResults.get("BAW")?queryTotalResults.get("BAW")/100:0,
                    dS:queryTotalResults.get("DS")?queryTotalResults.get("DS")/100:null,
                    cS:queryTotalResults.get("CS")?queryTotalResults.get("CS")/100:null,
                    params: params]

        }else{
            if(startDate){
                if(!endDate){
                    flash.message ="截止日期不能为空"
                    return
                }
            }
            if(endDate){
                if(!startDate){
                    flash.message ="起始日期不能为空"
                    return
                }
            }
        }
    }

    def queryAdjustDailyDownload ={
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null
        def area = params.area ? params.area : null
        def bizName = params.bizName ? params.bizName: null

        if(startDate && endDate){
            def queryParam = []
            queryParam.add(new java.sql.Date(startDate.getTime()))
            queryParam.add(new java.sql.Date(endDate.getTime()))

            def sql = new Sql(dataSource_boss)

            def querySql = """
                    select t.debit_adjust_amount,
                           t.credit_adjust_amount,
                           t.plat_fee,
                           t.bank_fee,
                           t.bank_adjust_charge,
                           t.bank_adjust_withdrawn,
                           t.debit_sum,
                           t.credit_sum,
                           to_char(t.date_created,'yyyy-mm-dd') as dc
                      from report_adjust_daily t
                     where t.date_created >= ?
                       and t.date_created < ?
                     order by t.date_created desc
            """


//            def queryResults = sql.rows(querySql,[queryParam])

            HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
            def queryResults = ht.executeFind({ Session session ->
                def sqlquery = session.createSQLQuery(querySql.toString())
                sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                for (def i = 0; i < queryParam.size(); i++) {
                    sqlquery.setParameter(i, queryParam.get(i))
                }
                return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
            } as HibernateCallback)
            //数据统计
            def queryTotalSql = """
                    select sum(t.debit_adjust_amount) as da,
                           sum(t.credit_adjust_amount) as ca,
                           sum(t.plat_fee) as pf,
                           sum(t.bank_fee) as bf,
                           sum(t.bank_adjust_charge) as bac,
                           sum(t.bank_adjust_withdrawn) as baw,
                           sum(t.debit_sum) as ds,
                           sum(t.credit_sum) as cs
                      from report_adjust_daily t
                     where t.date_created >= ?
                       and t.date_created < ?
            """

            def queryTotalResults = sql.firstRow(queryTotalSql,queryParam)


        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "adjustXls", model: [list:queryResults,total:queryResults.size(),
                    dA:queryTotalResults.get("DA")?queryTotalResults.get("DA")/100:0,
                    cA:queryTotalResults.get("CA")?queryTotalResults.get("CA")/100:0,
                    pF:queryTotalResults.get("PF")?queryTotalResults.get("PF")/100:0,
                    bF:queryTotalResults.get("BF")?queryTotalResults.get("BF")/100:null,
                    bAC:queryTotalResults.get("BAC")?queryTotalResults.get("BAC")/100:0,
                    bAW:queryTotalResults.get("BAW")?queryTotalResults.get("BAW")/100:0,
                    dS:queryTotalResults.get("DS")?queryTotalResults.get("DS")/100:null,
                    cS:queryTotalResults.get("CS")?queryTotalResults.get("CS")/100:null])

        }else{
            flash.message ="日期错误"
            render(view:"queryAdjustDailyShow",params:params)
        }
    }
}
