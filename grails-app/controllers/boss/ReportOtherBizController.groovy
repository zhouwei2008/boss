package boss

import java.text.SimpleDateFormat
import groovy.sql.Sql
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer

/**
 * Created by IntelliJ IDEA.
 * User: shuo_zhang
 * Date: 12-2-17
 * Time: 上午11:32
 * To change this template use File | Settings | File Templates.
 */
class ReportOtherBizController {
    def dataSource_boss

    def queryOtherBizDailyShow={
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null
        def area = params.area ? params.area : null
        def bizName = params.bizName ? params.bizName: null

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

            //获得数据
            def queryParam = []
            queryParam.add(new java.sql.Date(startDate.getTime()))
            queryParam.add(new java.sql.Date(endDate.getTime()))

            def sql = new Sql(dataSource_boss)

            def querySql = """
                    select t.area,
                           t.cus_accountid,
                           t.cus_name,
                           sum(t.charge_total_count) cc,
                           sum(t.charge_total_amount) cs,
                           sum(t.charge_fee) cf,
                           sum(t.charge_bank_cost) cbc,
                           sum(t.withdrawn_count) wc,
                           sum(t.withdrawn_amount) ws,
                           sum(t.withdrawn_fee) wf,
                           sum(t.withdrawn_bank_cost) wbc,
                           sum(t.transfer_count) tc,
                           sum(t.transfer_amount) ts,
                           sum(t.transfer_fee) tf,
                           sum(t.transfer_bank_cost) tbc
                      from report_other_biz_daily t
                     where 1 = 1
                       and t.date_created >= ?
                       and t.date_created < ?

            """
            if(area){
//                queryParam.add(area)
                querySql = querySql + "and t.area like '%"+area+"%'"
            }

            if(bizName){
//                queryParam.add(bizName)
                querySql = querySql + "and t.cus_name like '%"+ bizName + "%'"
            }

            querySql = querySql +"""
            group by t.area,       t.cus_accountid,       t.cus_name
                     order by t.area,t.cus_name
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

            //数据总数统计
            def ttSql = """
                   select count(*) as tt from (
                    select t.area,
                           t.cus_accountid,
                           t.cus_name,
                           sum(t.charge_total_count) cc,
                           sum(t.charge_total_amount) cs,
                           sum(t.charge_fee) cf,
                           sum(t.charge_bank_cost) cbc,
                           sum(t.withdrawn_count) wc,
                           sum(t.withdrawn_amount) ws,
                           sum(t.withdrawn_fee) wf,
                           sum(t.withdrawn_bank_cost) wbc,
                           sum(t.transfer_count) tc,
                           sum(t.transfer_amount) ts,
                           sum(t.transfer_fee) tf,
                           sum(t.transfer_bank_cost) tbc
                      from report_other_biz_daily t
                     where 1 = 1
                       and t.date_created >= ?
                       and t.date_created < ?

            """
            if(area){
//                queryParam.add(area)
                ttSql = ttSql + "and t.area like '%"+area+"%'"
            }

            if(bizName){
//                queryParam.add(bizName)
                ttSql = ttSql + "and t.cus_name like '%"+ bizName + "%'"
            }
            ttSql = ttSql +"""
            group by t.area,       t.cus_accountid,       t.cus_name)

                     """

//            def queryResults = sql.rows(querySql,[queryParam])

            ht = DatasourcesUtils.newHibernateTemplate('boss')
            def ttResult = ht.execute({ Session session ->
                def sqlquery = session.createSQLQuery(ttSql.toString())
                sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                for (def i = 0; i < queryParam.size(); i++) {
                    sqlquery.setParameter(i, queryParam.get(i))
                }
                return sqlquery.list();
            } as HibernateCallback)

            //数据统计
            def queryTotalSql = """
                    select sum(t.charge_total_count) as cc,
                           sum(t.charge_total_amount) as ca,
                           sum(t.charge_fee) as cf,
                           sum(t.charge_bank_cost) as cb,
                           sum(t.withdrawn_count) as wc,
                           sum(t.withdrawn_amount) as wa,
                           sum(t.withdrawn_fee) as wf,
                           sum(t.withdrawn_bank_cost) as wb,
                           sum(t.transfer_count) as tc,
                           sum(t.transfer_amount) as ta,
                           sum(t.transfer_fee) as tf,
                           sum(t.transfer_bank_cost) as tb
                      from report_other_biz_daily t
                     where 1=1
                       and t.date_created >=?
                       and t.date_created <?
            """
            if(area){
                queryTotalSql = queryTotalSql + "and t.area like '%"+area+"%'"
            }

            if(bizName){
                queryTotalSql = queryTotalSql + "and t.cus_name like '%"+ bizName + "%'"
            }

            def queryTotalResults = sql.firstRow(queryTotalSql,queryParam)


            [list:queryResults,total:ttResult?ttResult[0]?ttResult[0].get("TT"):0:0,
                    cC:queryTotalResults.get("CC")?queryTotalResults.get("CC"):0,
                    cA:queryTotalResults.get("CA")?queryTotalResults.get("CA")/100:0,
                    cF:queryTotalResults.get("CF")?queryTotalResults.get("CF")/100:null,
                    cB:queryTotalResults.get("CB")?queryTotalResults.get("CB")/100:null,
                    wC:queryTotalResults.get("WC")?queryTotalResults.get("WC"):0,
                    wA:queryTotalResults.get("WA")?queryTotalResults.get("WA")/100:0,
                    wF:queryTotalResults.get("WF")?queryTotalResults.get("WF")/100:null,
                    wB:queryTotalResults.get("WB")?queryTotalResults.get("WB")/100:null,
                    tC:queryTotalResults.get("TC")?queryTotalResults.get("TC"):0,
                    tA:queryTotalResults.get("TA")?queryTotalResults.get("TA")/100:0,
                    tF:queryTotalResults.get("TF")?queryTotalResults.get("TF")/100:null,
                    tB:queryTotalResults.get("TB")?queryTotalResults.get("TB")/100:null,
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
            if(area){
                flash.message ="起始日期、截止日期不能为空"
                return
            }
            if(bizName){
                flash.message ="起始日期、截止日期不能为空"
                return
            }
        }
    }

    def queryOtherBizDailyDownload ={
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null
        def area = params.area ? params.area : null
        def bizName = params.bizName ? params.bizName: null

        if(startDate && endDate){
            //获得数据
            def queryParam = []
            queryParam.add(new java.sql.Date(startDate.getTime()))
            queryParam.add(new java.sql.Date(endDate.getTime()))

            def sql = new Sql(dataSource_boss)

            def querySql = """
                    select t.area,
                           t.cus_accountid,
                           t.cus_name,
                           sum(t.charge_total_count) cc,
                           sum(t.charge_total_amount) cs,
                           sum(t.charge_fee) cf,
                           sum(t.charge_bank_cost) cbc,
                           sum(t.withdrawn_count) wc,
                           sum(t.withdrawn_amount) ws,
                           sum(t.withdrawn_fee) wf,
                           sum(t.withdrawn_bank_cost) wbc,
                           sum(t.transfer_count) tc,
                           sum(t.transfer_amount) ts,
                           sum(t.transfer_fee) tf,
                           sum(t.transfer_bank_cost) tbc
                      from report_other_biz_daily t
                     where 1 = 1
                       and t.date_created >= ?
                       and t.date_created < ?
                     group by t.area,       t.cus_accountid,       t.cus_name
                     order by t.area,t.cus_name
            """
            if(area){
//                queryParam.add(area)
                querySql = querySql + "and t.area like '%"+area+"%'"
            }

            if(bizName){
//                queryParam.add(bizName)
                querySql = querySql + "and t.cus_name like '%"+ bizName + "%'"
            }


//            def queryResults = sql.rows(querySql,[queryParam])

            HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
            def queryResults = ht.executeFind({ Session session ->
                def sqlquery = session.createSQLQuery(querySql.toString())
                sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                for (def i = 0; i < queryParam.size(); i++) {
                    sqlquery.setParameter(i, queryParam.get(i))
                }
                return sqlquery.list();
            } as HibernateCallback)
            //数据统计
            def queryTotalSql = """
                    select sum(t.charge_total_count) as cc,
                           sum(t.charge_total_amount) as ca,
                           sum(t.charge_fee) as cf,
                           sum(t.charge_bank_cost) as cb,
                           sum(t.withdrawn_count) as wc,
                           sum(t.withdrawn_amount) as wa,
                           sum(t.withdrawn_fee) as wf,
                           sum(t.withdrawn_bank_cost) as wb,
                           sum(t.transfer_count) as tc,
                           sum(t.transfer_amount) as ta,
                           sum(t.transfer_fee) as tf,
                           sum(t.transfer_bank_cost) as tb
                      from report_other_biz_daily t
                     where 1=1
                       and t.date_created >=?
                       and t.date_created <?
            """
            if(area){
                queryTotalSql = queryTotalSql + "and t.area like '%"+area+"%'"
            }

            if(bizName){
                queryTotalSql = queryTotalSql + "and t.cus_name like '%"+ bizName + "%'"
            }

            def queryTotalResults = sql.firstRow(queryTotalSql,queryParam)


         def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "otherBizXls", model: [list:queryResults,total:queryResults.size(),
                    cC:queryTotalResults.get("CC")?queryTotalResults.get("CC"):0,
                    cA:queryTotalResults.get("CA")?queryTotalResults.get("CA")/100:0,
                    cF:queryTotalResults.get("CF")?queryTotalResults.get("CF")/100:null,
                    cB:queryTotalResults.get("CB")?queryTotalResults.get("CB")/100:null,
                    wC:queryTotalResults.get("WC")?queryTotalResults.get("WC"):0,
                    wA:queryTotalResults.get("WA")?queryTotalResults.get("WA")/100:0,
                    wF:queryTotalResults.get("WF")?queryTotalResults.get("WF")/100:null,
                    wB:queryTotalResults.get("WB")?queryTotalResults.get("WB")/100:null,
                    tC:queryTotalResults.get("TC")?queryTotalResults.get("TC"):0,
                    tA:queryTotalResults.get("TA")?queryTotalResults.get("TA")/100:0,
                    tF:queryTotalResults.get("TF")?queryTotalResults.get("TF")/100:null,
                    tB:queryTotalResults.get("TB")?queryTotalResults.get("TB")/100:null])

        }else{
            flash.message ="日期错误"
            render(view:"queryOtherBizDailyShow",params:params)
        }

    }
}
