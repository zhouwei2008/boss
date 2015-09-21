package boss
import ismp.CmCustomer
import org.springframework.orm.hibernate3.HibernateTemplate
import org.hibernate.Session
import org.springframework.orm.hibernate3.HibernateCallback
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.transform.AliasToEntityMapResultTransformer
import groovy.sql.Sql
import ismp.CmCorporationInfo

class ReportAllServicesDailyController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def dataSource_boss
    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "saa"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        params.selType = params.selType ? params.selType : "1"


//       println "start ----------serviceType==="  +  params.serviceType
//       println params.serviceType instanceof List
//       println params.serviceType instanceof String[]
//       println params.serviceType instanceof String
       params.allServiceTypes='0'
       if (params.serviceType==null||params.serviceType=="") {
            params.serviceType=ReportAllServicesDaily.serviceMap.keySet()
            params.allServiceTypes='2'
       }else{
            if(params.serviceType instanceof String){
                def list=[]
                list<<params.serviceType
                params.serviceType=list
                params.allServiceTypes='1'
	        }else{
                 if(params.serviceType.size()<ReportAllServicesDaily.serviceMap.size()){
                     params.allServiceTypes='1'
                 }
                 if(params.serviceType.size()==ReportAllServicesDaily.serviceMap.size()){
                     params.allServiceTypes='2'
                 }
            }

       }

       println "end ----------serviceType==="  +  params.serviceType
       println params.serviceType instanceof List
       println params.serviceType instanceof String[]
       println params.serviceType instanceof String
       println params.serviceType instanceof Set
       println "end ----------allServiceTypes==="  +  params.allServiceTypes

       println "end ----------applyTest==="  +  params.applyTest
        println "end ----------selType==="  +  params.selType

        validDated(params)
        def customers
        //按商户名称模糊
        def customerIds = []
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

       def map=[:]
       def result
       def columns=[]
       def totals=[]
       def totalAllCounts=[]
       def totalAllNetAmounts=[]
       def totalAllNetFees=[]

       def gCounts=[]
       def gNetAmounts=[]
       def gNetFees=[]


      params.serviceType.each{
            switch(it){
                case 'online':
		    def column = """
		   ,nvl(sum(online_trade_count),0) oc
		   ,nvl(sum(online_trade_net_amount),0) oa
		   ,nvl(sum(online_trade_net_fee),0) nf
		    """
		    def tot ="""
		    sum(oc) toc
		   ,sum(oa) toa
		   ,sum(nf) tnf
		    """
            columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(online_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(online_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(online_trade_net_fee),0)"
            gCounts<<"oc"
            gNetAmounts<<"oa"
            gNetFees<<"nf"
                    break
                case 'royalty':
                    def column = """
		   ,nvl(sum(royalty_trade_count),0) rc
		   ,nvl(sum(royalty_trade_net_amount),0) ra
		   ,nvl(sum(royalty_trade_net_fee),0) rf
		    """
		    def tot ="""
		    sum(rc) trc
		   ,sum(ra) tra
		   ,sum(rf) trf
		    """
                    columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(royalty_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(royalty_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(royalty_trade_net_fee),0)"
            gCounts<<"rc"
            gNetAmounts<<"ra"
            gNetFees<<"rf"
                    break
                case 'agentcoll':
                    def column = """
		   ,nvl(sum(agentcoll_trade_count),0) sc
		   ,nvl(sum(agentcoll_trade_net_amount),0) sa
		   ,nvl(sum(agentcoll_trade_net_fee),0) sf
		    """
		    def tot ="""
		    sum(sc) tsc
		   ,sum(sa) tsa
		   ,sum(sf) tsf
		    """
                    columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(agentcoll_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(agentcoll_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(agentcoll_trade_net_fee),0)"
            gCounts<<"sc"
            gNetAmounts<<"sa"
            gNetFees<<"sf"
                    break
                case 'agentpay':
                    def column = """
		   ,nvl(sum(agentpay_trade_count),0) fc
		   ,nvl(sum(agentpay_trade_net_amount),0) fa
		   ,nvl(sum(agentpay_trade_net_fee),0) ff
		    """
		    def tot ="""
		    sum(fc) tfc
		   ,sum(fa) tfa
		   ,sum(ff) tff
		    """
                    columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(agentpay_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(agentpay_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(agentpay_trade_net_fee),0)"
            gCounts<<"fc"
            gNetAmounts<<"fa"
            gNetFees<<"ff"
                    break
                case 'transfer':
                    def column = """
		   ,nvl(sum(transfer_trade_count),0) tc
		   ,nvl(sum(transfer_trade_net_amount),0) ta
		   ,nvl(sum(transfer_trade_net_fee),0) tf
		    """
		    def tot ="""
		    sum(tc) ttc
		   ,sum(ta) tta
		   ,sum(tf) ttf
		    """
                    columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(transfer_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(transfer_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(transfer_trade_net_fee),0)"
            gCounts<<"tc"
            gNetAmounts<<"ta"
            gNetFees<<"tf"
                    break
                case 'charge':
                    def column = """
		   ,nvl(sum(charge_trade_count),0) cc
		   ,nvl(sum(charge_trade_net_amount),0) ca
		   ,nvl(sum(charge_trade_net_fee),0) cf
		    """
		    def tot ="""
		    sum(cc) tcc
		   ,sum(ca) tca
		   ,sum(cf) tcf
		    """
                    columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(charge_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(charge_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(charge_trade_net_fee),0)"
            gCounts<<"cc"
            gNetAmounts<<"ca"
            gNetFees<<"cf"
                    break
                case 'withdrawn':
            def column = """
		   ,nvl(sum(withdrawn_trade_count),0) wc
		   ,nvl(sum(withdrawn_trade_net_amount),0) wa
		   ,nvl(sum(withdrawn_trade_net_fee),0) wf
		    """
		    def tot ="""
		    sum(wc) twc
		   ,sum(wa) twa
		   ,sum(wf) twf
		    """
            columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(withdrawn_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(withdrawn_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(withdrawn_trade_net_fee),0)"
            gCounts<<"wc"
            gNetAmounts<<"wa"
            gNetFees<<"wf"
                    break
            }

    }


       def queryParam = []
       def query
       if(params.selType=="1"){
        query = """select * from
        (select customer_id
	${columns.join(" ")}
	,${totalAllCounts.join("+")} as sac
	,${totalAllNetAmounts.join("+")} as saa
	,${totalAllNetFees.join("+")} as saf

       from report_all_services_daily
       where  2>1
            ${params.startDateCreated? " and trade_finishdate>=to_date('"+params.startDateCreated+" 00:00:00','yyyy-mm-dd hh24:mi:ss')":""}
            ${params.endDateCreated? " and trade_finishdate<=to_date('"+params.endDateCreated+" 23:59:59','yyyy-mm-dd hh24:mi:ss')":""}
            ${params.customerNo ? " and customer_no like '%"+params.customerNo+"%'" : ""}　
            ${(params.customerName||params.region)? " and customer_id in ("+customerIds.join(',')+")" : ""}
            ${params.customerType ? " and customer_type='"+params.customerType+"'" : ""}　　
            group by customer_id
            )
            where
       ${gCounts.join(">0 or ")}>0 or
	    ${gNetAmounts.join(">0 or ")}>0 or
	    ${gNetFees.join(">0 or ")}>0
            order by ${params.sort} ${params.order}  ${params.order=='desc' ? " nulls last" : " nulls first"} ${params.sort?",":""}  customer_id ${params.order}
       """
	}else{
		query = """
		select * from(
		select c.customer_id
		   ${columns.join()}
		   ,${totalAllCounts.join("+")} as sac
	       ,    ${totalAllNetAmounts.join("+")} as saa
	       ,    ${totalAllNetFees.join("+")} as saf
	       from bo_customer_service c
	       left join  report_all_services_daily r
	       on    c.customer_id = r.customer_id
	       ${params.startDateCreated? " and trade_finishdate>=to_date('"+params.startDateCreated+" 00:00:00','yyyy-mm-dd hh24:mi:ss')":""}
          ${params.endDateCreated? " and trade_finishdate<=to_date('"+params.endDateCreated+" 23:59:59','yyyy-mm-dd hh24:mi:ss')":""}
	       where
	              c.service_code in (${joinInlist(params.serviceType)})
		    and c.is_current=1
		    and c.enable=1
		    ${(params.customerName||params.region||params.customerNo||params.customerType)? " and c.customer_id in ("+customerIds.join(',')+")" : ""}   　　
		    group by c.customer_id
		    )
        ${params.selType=='0' ? "  where  ${gCounts.join("=0 and ")}=0 and ${gNetAmounts.join("=0 and ")}=0 and ${gNetFees.join("=0 and ")}=0" : ""}
		    order by ${params.sort} ${params.order} ${params.order=='desc' ? " nulls last" : " nulls first"}　${params.sort?",":""}  customer_id ${params.order}　
	       """
	}
          println(query)
        def sql = new Sql(dataSource_boss)
        def count = sql.firstRow("select count(*) total from ("+query+")")

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        //合计
        def queryAll ="""
	select
        ${totals.join(",")}
	,sum(sac) tsac
	,sum(saa) tsaa
	,sum(saf) tsaf
           from ("""+query+""") x
	"""
        def totalAgent = sql.firstRow(queryAll, queryParam)

        [reportAllServicesDailyInstanceList: result, reportAllServicesDailyInstanceTotal: count.total,totalAgent:totalAgent]
    }

    def listDownload = {
        params.sort = params.sort ? params.sort : "saa"
        params.order = params.order ? params.order : "desc"
        params.max = 10000
        params.selType = params.selType ? params.selType : "1"

         params.allServiceTypes='0'
       if (params.serviceType==null||params.serviceType=="") {
            params.serviceType=ReportAllServicesDaily.serviceMap.keySet()
            params.allServiceTypes='2'
       }else{
            if(params.serviceType instanceof String){
                def list=[]
                list<<params.serviceType
                params.serviceType=list
                params.allServiceTypes='1'
	        }else{
                 if(params.serviceType.size()<ReportAllServicesDaily.serviceMap.size()){
                     params.allServiceTypes='1'
                 }
                 if(params.serviceType.size()==ReportAllServicesDaily.serviceMap.size()){
                     params.allServiceTypes='2'
                 }
            }

       }

        validDated(params)
        def customers
        //按商户名称模糊
        def customerIds = []
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

       def map=[:]
       def result
       def columns=[]
       def totals=[]
       def totalAllCounts=[]
       def totalAllNetAmounts=[]
       def totalAllNetFees=[]

       def gCounts=[]
       def gNetAmounts=[]
       def gNetFees=[]

      params.serviceType.each{
            switch(it){
                case 'online':
		    def column = """
		   ,nvl(sum(online_trade_count),0) oc
		   ,nvl(sum(online_trade_net_amount),0) oa
		   ,nvl(sum(online_trade_net_fee),0) nf
		    """
		    def tot ="""
		    sum(oc) toc
		   ,sum(oa) toa
		   ,sum(nf) tnf
		    """
            columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(online_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(online_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(online_trade_net_fee),0)"
            gCounts<<"oc"
            gNetAmounts<<"oa"
            gNetFees<<"nf"
                    break
                case 'royalty':
                    def column = """
		   ,nvl(sum(royalty_trade_count),0) rc
		   ,nvl(sum(royalty_trade_net_amount),0) ra
		   ,nvl(sum(royalty_trade_net_fee),0) rf
		    """
		    def tot ="""
		    sum(rc) trc
		   ,sum(ra) tra
		   ,sum(rf) trf
		    """
                    columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(royalty_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(royalty_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(royalty_trade_net_fee),0)"
            gCounts<<"rc"
            gNetAmounts<<"ra"
            gNetFees<<"rf"
                    break
                case 'agentcoll':
                    def column = """
		   ,nvl(sum(agentcoll_trade_count),0) sc
		   ,nvl(sum(agentcoll_trade_net_amount),0) sa
		   ,nvl(sum(agentcoll_trade_net_fee),0) sf
		    """
		    def tot ="""
		    sum(sc) tsc
		   ,sum(sa) tsa
		   ,sum(sf) tsf
		    """
                    columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(agentcoll_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(agentcoll_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(agentcoll_trade_net_fee),0)"
            gCounts<<"sc"
            gNetAmounts<<"sa"
            gNetFees<<"sf"
                    break
                case 'agentpay':
                    def column = """
		   ,nvl(sum(agentpay_trade_count),0) fc
		   ,nvl(sum(agentpay_trade_net_amount),0) fa
		   ,nvl(sum(agentpay_trade_net_fee),0) ff
		    """
		    def tot ="""
		    sum(fc) tfc
		   ,sum(fa) tfa
		   ,sum(ff) tff
		    """
                    columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(agentpay_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(agentpay_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(agentpay_trade_net_fee),0)"
            gCounts<<"fc"
            gNetAmounts<<"fa"
            gNetFees<<"ff"
                    break
                case 'transfer':
                    def column = """
		   ,nvl(sum(transfer_trade_count),0) tc
		   ,nvl(sum(transfer_trade_net_amount),0) ta
		   ,nvl(sum(transfer_trade_net_fee),0) tf
		    """
		    def tot ="""
		    sum(tc) ttc
		   ,sum(ta) tta
		   ,sum(tf) ttf
		    """
                    columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(transfer_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(transfer_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(transfer_trade_net_fee),0)"
            gCounts<<"tc"
            gNetAmounts<<"ta"
            gNetFees<<"tf"
                    break
                case 'charge':
                    def column = """
		   ,nvl(sum(charge_trade_count),0) cc
		   ,nvl(sum(charge_trade_net_amount),0) ca
		   ,nvl(sum(charge_trade_net_fee),0) cf
		    """
		    def tot ="""
		    sum(cc) tcc
		   ,sum(ca) tca
		   ,sum(cf) tcf
		    """
                    columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(charge_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(charge_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(charge_trade_net_fee),0)"
            gCounts<<"cc"
            gNetAmounts<<"ca"
            gNetFees<<"cf"
                    break
                case 'withdrawn':
            def column = """
		   ,nvl(sum(withdrawn_trade_count),0) wc
		   ,nvl(sum(withdrawn_trade_net_amount),0) wa
		   ,nvl(sum(withdrawn_trade_net_fee),0) wf
		    """
		    def tot ="""
		    sum(wc) twc
		   ,sum(wa) twa
		   ,sum(wf) twf
		    """
            columns<<column
		    totals<<tot
		    totalAllCounts<<"nvl(sum(withdrawn_trade_count),0)"
		    totalAllNetAmounts<<"nvl(sum(withdrawn_trade_net_amount),0)"
		    totalAllNetFees<<"nvl(sum(withdrawn_trade_net_fee),0)"
            gCounts<<"wc"
            gNetAmounts<<"wa"
            gNetFees<<"wf"
                    break
            }

    }


       def queryParam = []
       def query
       if(params.selType=="1"){
        query = """
        select * from(
        select customer_id
	${columns.join(" ")}
	,${totalAllCounts.join("+")} as sac
	,${totalAllNetAmounts.join("+")} as saa
	,${totalAllNetFees.join("+")} as saf

       from report_all_services_daily
       where  2>1
            ${params.startDateCreated? " and trade_finishdate>=to_date('"+params.startDateCreated+" 00:00:00','yyyy-mm-dd hh24:mi:ss')":""}
            ${params.endDateCreated? " and trade_finishdate<=to_date('"+params.endDateCreated+" 23:59:59','yyyy-mm-dd hh24:mi:ss')":""}
            ${params.customerNo ? " and customer_no like '%"+params.customerNo+"%'" : ""}　
            ${(params.customerName||params.region)? " and customer_id in ("+customerIds.join(',')+")" : ""}
            ${params.customerType ? " and customer_type='"+params.customerType+"'" : ""}　　
            group by customer_id
        )
            where
       ${gCounts.join(">0 or ")}>0 or
	    ${gNetAmounts.join(">0 or ")}>0 or
	    ${gNetFees.join(">0 or ")}>0
            order by ${params.sort} ${params.order}  ${params.order=='desc' ? " nulls last" : " nulls first"} ${params.sort?",":""}  customer_id ${params.order}
       """
	}else{
		query = """
		select * from(
		select c.customer_id
		   ${columns.join()}
		   ,${totalAllCounts.join("+")} as sac
	       ,    ${totalAllNetAmounts.join("+")} as saa
	       ,    ${totalAllNetFees.join("+")} as saf
	       from bo_customer_service c
	       left join  report_all_services_daily r
	       on    c.customer_id = r.customer_id
	       ${params.startDateCreated? " and trade_finishdate>=to_date('"+params.startDateCreated+" 00:00:00','yyyy-mm-dd hh24:mi:ss')":""}
          ${params.endDateCreated? " and trade_finishdate<=to_date('"+params.endDateCreated+" 23:59:59','yyyy-mm-dd hh24:mi:ss')":""}
	       where
	              c.service_code in (${joinInlist(params.serviceType)})
		    and c.is_current=1
		    and c.enable=1
		    ${(params.customerName||params.region||params.customerNo||params.customerType)? " and c.customer_id in ("+customerIds.join(',')+")" : ""}   　　
		    group by c.customer_id
		       )
        ${params.selType=='0' ? "  where  ${gCounts.join("=0 and ")}=0 and ${gNetAmounts.join("=0 and ")}=0 and ${gNetFees.join("=0 and ")}=0" : ""}
		    order by ${params.sort} ${params.order} ${params.order=='desc' ? " nulls last" : " nulls first"}　${params.sort?",":""}  customer_id ${params.order}　
	       """
	}
//          println(query)
        def sql = new Sql(dataSource_boss)
        def count = sql.firstRow("select count(*) total from ("+query+")")

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list()
        } as HibernateCallback)

        //合计
        def queryAll ="""
	select
        ${totals.join(",")}
	,sum(sac) tsac
	,sum(saa) tsaa
	,sum(saf) tsaf
           from ("""+query+""") x
	"""
        def totalAgent = sql.firstRow(queryAll, queryParam)

	    def filename = 'Excel-All-Services-' +new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "list", model: [reportAllServicesDailyInstanceList: result, reportAllServicesDailyInstanceTotal: count.total,totalAgent:totalAgent,date:new Date()])
    }


     def joinInlist(serviceCodes){
        StringBuilder ids= new StringBuilder()
        if((serviceCodes instanceof String[])||(serviceCodes instanceof List)){
            println "-------------==============2323423423==="    +    serviceCodes
            int len = serviceCodes.size();
            for(int i=0 ;i<len;i++){
                if(i>0&&i<len){
                 ids.append(",")
                }
               ids.append("'").append(serviceCodes[i]).append("'")
            }
        }else{
            println "-------------==============6564534343==="    +    serviceCodes
             ids.append("'").append(serviceCodes).append("'")
        }

        return ids
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
        def reportAllServicesDailyInstance = new ReportAllServicesDaily()
        reportAllServicesDailyInstance.properties = params
        return [reportAllServicesDailyInstance: reportAllServicesDailyInstance]
    }

    def save = {
        def reportAllServicesDailyInstance = new ReportAllServicesDaily(params)
        if (reportAllServicesDailyInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'reportAllServicesDaily.label', default: 'ReportAllServicesDaily'), reportAllServicesDailyInstance.id])}"
            redirect(action: "list", id: reportAllServicesDailyInstance.id)
        }
        else {
            render(view: "create", model: [reportAllServicesDailyInstance: reportAllServicesDailyInstance])
        }
    }

    def show = {
        def reportAllServicesDailyInstance = ReportAllServicesDaily.get(params.id)
        if (!reportAllServicesDailyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reportAllServicesDaily.label', default: 'ReportAllServicesDaily'), params.id])}"
            redirect(action: "list")
        }
        else {
            [reportAllServicesDailyInstance: reportAllServicesDailyInstance]
        }
    }

    def edit = {
        def reportAllServicesDailyInstance = ReportAllServicesDaily.get(params.id)
        if (!reportAllServicesDailyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reportAllServicesDaily.label', default: 'ReportAllServicesDaily'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [reportAllServicesDailyInstance: reportAllServicesDailyInstance]
        }
    }

    def update = {
        def reportAllServicesDailyInstance = ReportAllServicesDaily.get(params.id)
        if (reportAllServicesDailyInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (reportAllServicesDailyInstance.version > version) {

                    reportAllServicesDailyInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'reportAllServicesDaily.label', default: 'ReportAllServicesDaily')] as Object[], "Another user has updated this ReportAllServicesDaily while you were editing")
                    render(view: "edit", model: [reportAllServicesDailyInstance: reportAllServicesDailyInstance])
                    return
                }
            }
            reportAllServicesDailyInstance.properties = params
            if (!reportAllServicesDailyInstance.hasErrors() && reportAllServicesDailyInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'reportAllServicesDaily.label', default: 'ReportAllServicesDaily'), reportAllServicesDailyInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [reportAllServicesDailyInstance: reportAllServicesDailyInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reportAllServicesDaily.label', default: 'ReportAllServicesDaily'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def reportAllServicesDailyInstance = ReportAllServicesDaily.get(params.id)
        if (reportAllServicesDailyInstance) {
            try {
                reportAllServicesDailyInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'reportAllServicesDaily.label', default: 'ReportAllServicesDaily'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'reportAllServicesDaily.label', default: 'ReportAllServicesDaily'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reportAllServicesDaily.label', default: 'ReportAllServicesDaily'), params.id])}"
            redirect(action: "list")
        }
    }
}