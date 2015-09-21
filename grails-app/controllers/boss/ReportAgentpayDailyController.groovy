package boss

import ismp.CmCustomer
import ismp.CmCorporationInfo
import org.springframework.orm.hibernate3.HibernateTemplate
import org.hibernate.Session
import org.springframework.orm.hibernate3.HibernateCallback
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.transform.AliasToEntityMapResultTransformer
import groovy.sql.Sql

class ReportAgentpayDailyController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def dataSource_boss

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "sn"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

	    params.selType = params.selType ? params.selType : "1"
	   //guonan update 2011-12-29
       //日期
       validDated(params)
        def customerIds=[]
        def customers
        if(params.selType=="1"){
            if (params.customerName||params.region) {
                def sqls = {
                    if (params.customerName) {
                        ilike('name', "%"+params.customerName+"%")
                    }
                    if (params.region) {
                        customers = CmCorporationInfo.findAllByBelongToAreaIlike('%'+params.region+'%')
                        if(customers.size()>0){
                            customers?.each {customer ->
                                customerIds << customer.id
                            }
                            'in'('id',customerIds)
                        }else{
                             lt('id',1.longValue())
                        }
                    }
                }

                customers = CmCustomer.createCriteria().list(sqls)
                customerIds=[]
                if(customers.size()>0){
                    customers?.each {customer ->
                        customerIds << ((CmCustomer)customer).id
                    }
                }else{
                    customerIds<<0
                }
            }
        }else {
            if (params.customerName||params.region||params.customerType||params.customerNo) {
            def sqls = {
                if (params.customerNo) {
                    like('customerNo', "%"+params.customerNo+"%")
                }
                if (params.customerType) {
                    eq('type', params.customerType)
                }
                if (params.customerName) {
                    ilike('name', "%"+params.customerName+"%")
                }
                if (params.region) {
                    customers = CmCorporationInfo.findAllByBelongToAreaIlike('%'+params.region+'%')
                    if(customers.size()>0){
                        customers?.each {customer ->
                            customerIds << customer.id
                        }
                        'in'('id',customerIds)
                    }else{
                        lt('id',1.longValue())
                    }
                }
            }
            customers = CmCustomer.createCriteria().list(sqls)
            customerIds=[]
            if(customers.size()>0){
                customers?.each {customer ->
                    customerIds << ((CmCustomer)customer).id
                }
            }else{
                 customerIds<<0
             }
            }
        }
        println "customerIds 8= "+ customerIds
       
       def queryParam = []
	def query 
       if(params.selType=="1"){
        query = """select customer_id
           ,sum(amount) aa
           ,sum(count) cc
           ,sum(trade_amount_success) ts
           ,sum(trade_count_success) cs
           ,sum(trade_amount_fail) af
           ,sum(trade_count_fail) cf
           ,sum(trade_settle_amount) sa
           ,sum(trade_settle_fee) sf
           ,sum(net_amount) sn
       from report_agentpay_daily
       where trade_type='${params.tradeType?params.tradeType:'S'}'
            ${params.startDateCreated? " and trade_finishdate>=to_date('"+params.startDateCreated+" 00:00:00','yyyy-mm-dd hh24:mi:ss')":""}
            ${params.endDateCreated? " and trade_finishdate<=to_date('"+params.endDateCreated+" 23:59:59','yyyy-mm-dd hh24:mi:ss')":""}
            ${params.customerNo ? " and customer_no like '%"+params.customerNo+"%'" : ""}　　
            ${(params.customerName||params.region)? " and customer_id in ("+customerIds.join(',')+")" : ""}
            ${params.customerType ? " and customer_type='"+params.customerType+"'" : ""}	　　
            group by customer_id
            order by ${params.sort} ${params.order}  ${params.order=='desc' ? " nulls last" : " nulls first"} ${params.sort?",":""}  customer_id ${params.order}
       """
	}else{
		query = """select c.customer_id
		   ,nvl(sum(amount),0) aa
		   ,nvl(sum(count),0) cc
		   ,nvl(sum(trade_amount_success),0) ts
		   ,nvl(sum(trade_count_success),0) cs
		   ,nvl(sum(trade_amount_fail),0) af
		   ,nvl(sum(trade_count_fail),0) cf
		   ,nvl(sum(trade_settle_amount),0) sa
		   ,nvl(sum(trade_settle_fee),0) sf
		   ,nvl(sum(net_amount),0) sn
	       from bo_customer_service c 
	       left join  report_agentpay_daily r
	       on    c.customer_id = r.customer_id
	       ${params.startDateCreated? " and trade_finishdate>=to_date('"+params.startDateCreated+" 00:00:00','yyyy-mm-dd hh24:mi:ss')":""}
          ${params.endDateCreated? " and trade_finishdate<=to_date('"+params.endDateCreated+" 23:59:59','yyyy-mm-dd hh24:mi:ss')":""}
		   and  r.trade_type='${params.tradeType?params.tradeType:'S'}'  　　
	       where
	             c.service_code = '${params.tradeType=='S'?'agentcoll':'agentpay'}'
		    and c.is_current=1
		    and c.enable=1
		    ${params.selType=='0' ? " and r.customer_no is null" : ""}		    　
		    ${(params.customerName||params.region||params.customerNo||params.customerType)? " and c.customer_id in ("+customerIds.join(',')+")" : ""} 　
		    group by c.customer_id
		    order by ${params.sort} ${params.order} ${params.order=='desc' ? " nulls last" : " nulls first"}　${params.sort?",":""}  c.customer_id ${params.order}
	       """

	}

        println(query)


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
        def totalAgent = sql.firstRow("select sum(aa) taa,sum(cc) tcc,sum(ts) tts,sum(cs) tcs,sum(af) taf,sum(cf) tcf,sum(sa) tsa,sum(sf) tsf,sum(sn) tsn from (${query})", queryParam)
	
        [reportAgentpayDailyInstanceList: result, reportAgentpayDailyInstanceTotal: count.total,totalAgent:totalAgent]
    }


def listDownload = {
        params.sort = params.sort ? params.sort : "sn"
        params.order = params.order ? params.order : "desc"
        params.max = 10000
        params.offset = 0
	    params.selType = params.selType ? params.selType : "1"

       //日期
       validDated(params)

       def customerIds=[]
        def customers
        if(params.selType=="1"){
            if (params.customerName||params.region) {
                def sqls = {
                    if (params.customerName) {
                        ilike('name', "%"+params.customerName+"%")
                    }
                    if (params.region) {
                        customers = CmCorporationInfo.findAllByBelongToAreaIlike('%'+params.region+'%')
                        if(customers.size()>0){
                            customers?.each {customer ->
                                customerIds << customer.id
                            }
                            'in'('id',customerIds)
                        }else{
                             lt('id',1.longValue())
                        }
                    }
                }

                customers = CmCustomer.createCriteria().list(sqls)
                customerIds=[]
                if(customers.size()>0){
                    customers?.each {customer ->
                        customerIds << ((CmCustomer)customer).id
                    }
                }else{
                    customerIds<<0
                }
            }
        }else {
            if (params.customerName||params.region||params.customerType||params.customerNo) {
            def sqls = {
                if (params.customerNo) {
                    like('customerNo', "%"+params.customerNo+"%")
                }
                if (params.customerType) {
                    eq('type', params.customerType)
                }
                if (params.customerName) {
                    ilike('name', "%"+params.customerName+"%")
                }
                if (params.region) {
                    customers = CmCorporationInfo.findAllByBelongToAreaIlike('%'+params.region+'%')
                    if(customers.size()>0){
                        customers?.each {customer ->
                            customerIds << customer.id
                        }
                        'in'('id',customerIds)
                    }else{
                        lt('id',1.longValue())
                    }
                }
            }
            customers = CmCustomer.createCriteria().list(sqls)
            customerIds=[]
            if(customers.size()>0){
                customers?.each {customer ->
                    customerIds << ((CmCustomer)customer).id
                }
            }else{
                 customerIds<<0
             }
            }
        }
        println "customerIds 8= "+ customerIds

       def queryParam = []
	def query
       if(params.selType=="1"){
        query = """select customer_id
           ,sum(amount) aa
           ,sum(count) cc
           ,sum(trade_amount_success) ts
           ,sum(trade_count_success) cs
           ,sum(trade_amount_fail) af
           ,sum(trade_count_fail) cf
           ,sum(trade_settle_amount) sa
           ,sum(trade_settle_fee) sf
           ,sum(net_amount) sn
       from report_agentpay_daily
       where trade_type='${params.tradeType?params.tradeType:'S'}'
            ${params.startDateCreated? " and trade_finishdate>=to_date('"+params.startDateCreated+" 00:00:00','yyyy-mm-dd hh24:mi:ss')":""}
            ${params.endDateCreated? " and trade_finishdate<=to_date('"+params.endDateCreated+" 23:59:59','yyyy-mm-dd hh24:mi:ss')":""}
            ${params.customerNo ? " and customer_no like '%"+params.customerNo+"%'" : ""}　　
            ${(params.customerName||params.region)? " and customer_id in ("+customerIds.join(',')+")" : ""}
            ${params.customerType ? " and customer_type='"+params.customerType+"'" : ""}	　　
            group by customer_id
            order by ${params.sort} ${params.order}  ${params.order=='desc' ? " nulls last" : " nulls first"} ${params.sort?",":""}  customer_id ${params.order}
       """
	}else{
		query = """select c.customer_id
		   ,nvl(sum(amount),0) aa
		   ,nvl(sum(count),0) cc
		   ,nvl(sum(trade_amount_success),0) ts
		   ,nvl(sum(trade_count_success),0) cs
		   ,nvl(sum(trade_amount_fail),0) af
		   ,nvl(sum(trade_count_fail),0) cf
		   ,nvl(sum(trade_settle_amount),0) sa
		   ,nvl(sum(trade_settle_fee),0) sf
		   ,nvl(sum(net_amount),0) sn
	       from bo_customer_service c
	       left join  report_agentpay_daily r
	       on    c.customer_id = r.customer_id
	       ${params.startDateCreated? " and trade_finishdate>=to_date('"+params.startDateCreated+" 00:00:00','yyyy-mm-dd hh24:mi:ss')":""}
          ${params.endDateCreated? " and trade_finishdate<=to_date('"+params.endDateCreated+" 23:59:59','yyyy-mm-dd hh24:mi:ss')":""}
		   and  r.trade_type='${params.tradeType?params.tradeType:'S'}'  　　
	       where
	             c.service_code = '${params.tradeType=='S'?'agentcoll':'agentpay'}'
		    and c.is_current=1
		    and c.enable=1
		    ${params.selType=='0' ? " and r.customer_no is null" : ""}		    　
		    ${(params.customerName||params.region||params.customerNo||params.customerType)? " and c.customer_id in ("+customerIds.join(',')+")" : ""} 　
		    group by c.customer_id
		    order by ${params.sort} ${params.order} ${params.order=='desc' ? " nulls last" : " nulls first"}　${params.sort?",":""}  c.customer_id ${params.order}
	       """

	}

       println(query)

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
        def totalAgent = sql.firstRow("select sum(aa) taa,sum(cc) tcc,sum(ts) tts,sum(cs) tcs,sum(af) taf,sum(cf) tcf,sum(sa) tsa,sum(sf) tsf,sum(sn) tsn from (${query})", queryParam)

        def type=params.tradeType=='S'?'agentcoll':'agentpay'
	    def filename = 'Excel-' +type +'-' +new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "list", model: [reportAgentpayDailyInstanceList: result, reportAgentpayDailyInstanceTotal: count.total,totalAgent:totalAgent,date:new Date()])
    }

     /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan  2011-12-29
     *
     */
    def validDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startDateCreated==null && params.endDateCreated==null){
            def gCalendar= new GregorianCalendar()
            gCalendar.add(GregorianCalendar.DATE,-1)
            params.endDateCreated=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startDateCreated=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startDateCreated && !params.endDateCreated){
             params.endDateCreated=params.startDateCreated
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startDateCreated && params.endDateCreated){
             params.startDateCreated=params.endDateCreated
        }
        if (params.startDateCreated && params.endDateCreated) {

        }
    }

    def create = {
        def reportAgentpayDailyInstance = new ReportAgentpayDaily()
        reportAgentpayDailyInstance.properties = params
        return [reportAgentpayDailyInstance: reportAgentpayDailyInstance]
    }

    def save = {
        def reportAgentpayDailyInstance = new ReportAgentpayDaily(params)
        if (reportAgentpayDailyInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'reportAgentpayDaily.label', default: 'ReportAgentpayDaily'), reportAgentpayDailyInstance.id])}"
            redirect(action: "list", id: reportAgentpayDailyInstance.id)
        }
        else {
            render(view: "create", model: [reportAgentpayDailyInstance: reportAgentpayDailyInstance])
        }
    }

    def show = {
        def reportAgentpayDailyInstance = ReportAgentpayDaily.get(params.id)
        if (!reportAgentpayDailyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reportAgentpayDaily.label', default: 'ReportAgentpayDaily'), params.id])}"
            redirect(action: "list")
        }
        else {
            [reportAgentpayDailyInstance: reportAgentpayDailyInstance]
        }
    }

    def edit = {
        def reportAgentpayDailyInstance = ReportAgentpayDaily.get(params.id)
        if (!reportAgentpayDailyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reportAgentpayDaily.label', default: 'ReportAgentpayDaily'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [reportAgentpayDailyInstance: reportAgentpayDailyInstance]
        }
    }

    def update = {
        def reportAgentpayDailyInstance = ReportAgentpayDaily.get(params.id)
        if (reportAgentpayDailyInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (reportAgentpayDailyInstance.version > version) {

                    reportAgentpayDailyInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'reportAgentpayDaily.label', default: 'ReportAgentpayDaily')] as Object[], "Another user has updated this ReportAgentpayDaily while you were editing")
                    render(view: "edit", model: [reportAgentpayDailyInstance: reportAgentpayDailyInstance])
                    return
                }
            }
            reportAgentpayDailyInstance.properties = params
            if (!reportAgentpayDailyInstance.hasErrors() && reportAgentpayDailyInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'reportAgentpayDaily.label', default: 'ReportAgentpayDaily'), reportAgentpayDailyInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [reportAgentpayDailyInstance: reportAgentpayDailyInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reportAgentpayDaily.label', default: 'ReportAgentpayDaily'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def reportAgentpayDailyInstance = ReportAgentpayDaily.get(params.id)
        if (reportAgentpayDailyInstance) {
            try {
                reportAgentpayDailyInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'reportAgentpayDaily.label', default: 'ReportAgentpayDaily'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'reportAgentpayDaily.label', default: 'ReportAgentpayDaily'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reportAgentpayDaily.label', default: 'ReportAgentpayDaily'), params.id])}"
            redirect(action: "list")
        }
    }
}
