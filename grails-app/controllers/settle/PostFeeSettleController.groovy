package settle

import account.AcAccount
import account.AccountClientService
import boss.BoAcquirerAccount
import boss.BoInnerAccount
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import grails.converters.JSON
import groovy.sql.Sql
import ismp.CmCorporationInfo
import ismp.CmCustomer
import java.text.SimpleDateFormat
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.hssf.usermodel.HSSFSheet
import org.apache.poi.hssf.usermodel.HSSFRow
import org.apache.poi.hssf.usermodel.HSSFCell
import org.apache.poi.hssf.usermodel.HSSFCellStyle
import org.apache.poi.hssf.usermodel.HSSFDataFormat

/**
 * 后返手续费结算
 */
class PostFeeSettleController {
    AccountClientService accountClientService
    def dataSource_settle

    def merchant_list = {
        println params

        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        //guonan update 2011-12-29
        validDated(params)
        def startdate = params.startTradeDate
        def enddate = params.endTradeDate

        def customer_no = params.customerNo
        def name = params.name

        def sql = new Sql(dataSource_settle)
        def queryParam = []
        /*if (customer_no != null && customer_no.trim() != "") {
            queryParam.add(customer_no)
        }*/

        def merNameList = null
        if (name != null && name.trim() != "") {
            def nameQuery = {
                or {
                    like("name", "%" + params.name.trim() + "%")
                    like("registrationName", "%" + params.name.trim() + "%")
                }
            }

            def cus = ismp.CmCustomer.createCriteria().list([:], nameQuery)

            if (cus.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def cu in cus) {
                    sb.append("'").append(cu.customerNo).append("',")
                }
                merNameList = sb.deleteCharAt(sb.length() - 1).toString()
            }
        }

        def query = """
                    select customerNo,sum(postFee) postFee, min(liqDate) minTime, max(liqDate) maxTime
                    from (select li.CUSTOMER_NO　customerNo,li.POST_FEE　postFee,li.LIQ_DATE　liqDate
                          from FT_LIQUIDATE li
                          where li.FEE_TYPE=1 and li.POST_FOOT_STATUS=0
                                ${startdate ? "and li.LIQ_DATE >= to_date('" + startdate + "','yyyy-mm-dd')" : ""} ${enddate ? "and li.LIQ_DATE <= to_date('" + enddate + "','yyyy-mm-dd')" : ""}
                                ${customer_no ? " and li.CUSTOMER_NO like '%" + customer_no + "%'" : ""} ${merNameList ? "and li.CUSTOMER_NO in (" + merNameList + ")" : ""}
                         )
                    group by customerNo
                    order by customerNo desc
                  """

        println query
        def count = sql.firstRow("select count(*) total,nvl(sum(postFee),0) totalPostFee from (${query})", queryParam)
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        //[ftCustomerList: results, ftCustomerTotal: total, params: params, startdate: startdate, enddate: enddate]
        [result: result, total: count.total,totalPostFee:count.totalPostFee, params: params]
    }

     /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan
     *
     */
    def validDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startTradeDate==null && params.endTradeDate==null){
            def gCalendar= new GregorianCalendar()
            params.endTradeDate=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startTradeDate=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startTradeDate && !params.endTradeDate){
             params.endTradeDate=params.startTradeDate
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startTradeDate && params.endTradeDate){
             params.startTradeDate=params.endTradeDate
        }
        if (params.startTradeDate && params.endTradeDate) {


        }
    }


    /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan
     *
     */
    def validFootDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startFootDate==null && params.endFootDate==null){
            def gCalendar= new GregorianCalendar()
            params.endFootDate=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startFootDate=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startFootDate && !params.endFootDate){
             params.endFootDate=params.startFootDate
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startFootDate && params.endFootDate){
             params.startFootDate=params.endFootDate
        }
        if (params.startFootDate && params.endFootDate) {


        }
    }
    /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan
     *
     */
    def validCheckDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startcheckDate==null && params.endcheckDate==null){
            def gCalendar= new GregorianCalendar()
            params.endcheckDate=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startcheckDate=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startcheckDate && !params.endcheckDate){
             params.endcheckDate=params.startcheckDate
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startcheckDate && params.endcheckDate){
             params.startcheckDate=params.endcheckDate
        }
        if (params.startcheckDate && params.endcheckDate) {


        }
    }

    /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan
     *
     */
    def validDatexd(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startDate==null && params.endDate==null){
            def gCalendar= new GregorianCalendar()
            params.endDate=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startDate=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startDate && !params.endDate){
             params.endDate=params.startDate
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startDate && params.endDate){
             params.startDate=params.endDate
        }
        if (params.startDate && params.endDate) {


        }
    }

    def create = {
        def time = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
        def sql = new Sql(dataSource_settle)
        def query = "select seq_foot.nextval from dual"
        def seq = sql.firstRow(query).NEXTVAL.toString()
        if (seq.length() > 5) {
            seq = seq.substring(seq.length() - 5)
        } else {
            def tmp = "00000"
            seq = tmp.substring(0, 5 - seq.length()) + seq
        }

        println params
        //  [customerName:TEST_X, POST_FOOT_STATUS:0, startDate:2011-07-27,  POST_FEE:1, POST_FOOT_NO:100001,   endDate:2011-07-28, :1, action:settle_list, controller:postFeeSettle]

        def customerNo = params.customerNo
        def srvcode = params.srvcode
        def tradecode = params.tradecode
        def amount = params.amount as long
        def transNum = params.transNum as int
        def postFee = params.postFee as long

        def startdate = params.startDate
        def enddate = params.endDate

        def foot = new FtFoot()
        foot.srvCode = srvcode
        foot.tradeCode = tradecode
        foot.customerNo = customerNo
        foot.amount = amount
        foot.transNum = transNum
        foot.type = 0
        foot.feeType = 1
        foot.postFee = postFee
        foot.footDate = new Date()

        def fn = "M" + time + seq
        foot.footNo = fn
        foot.preFee = 0
        foot.checkStatus = 0

        def op_id = session.op.id
        if (op_id == null) {
            op_id = 0
        }
        foot.createOpId = op_id

        FtFoot.withTransaction {tx ->
            def ft = null
            try {
                ft = foot.save(failOnError: true)
            } catch (Exception e) {
                log.warn("generate settle fail,", e)
                println "#1#"
                flash.message = "${message(code: 'postFeeSettle_fail.lable')}"
                redirect(action: "settle_list",params:['mid':customerNo,'start':startdate,'end':enddate])
                return
            }
            if (ft) {
                int i = sql.executeUpdate("""
                                        update ft_liquidate t
                                        set
                                            t.post_foot_status=1,t.post_foot_no='$fn'
                                        where t.post_foot_status=0 and t.fee_type=1 and t.srv_code='$srvcode' and t.trade_code='$tradecode' and t.customer_no='$customerNo'
                                        ${startdate ? "and t.LIQ_DATE >= to_date('" + startdate.substring(0,10) + "','yyyy-mm-dd')" : ""} ${enddate ? "and t.LIQ_DATE <= to_date('" + enddate.substring(0,10) + "','yyyy-mm-dd')" : ""}
                                    """.toString())
                if (i <= 0) {
                    println "#3#"
                    tx.setRollbackOnly()
                    flash.message = "${message(code: 'postFeeSettle_fail.lable')}"
                } else {
                    flash.message = "${message(code: 'postFeeSettle_success.lable')}"
                }
                redirect(action: "settle_list",params:['mid':customerNo,'start':params.start,'end':params.end])
            } else {
                println "#2#"
                flash.message = "${message(code: 'postFeeSettle_fail.lable')}"
                redirect(action: "settle_list",params:['mid':customerNo,'start':params.start,'end':params.end])
            }
        }
    }

    def show = {
        params.sort = params.sort ? params.sort : "id"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def customerNo = params.customerNo
        def customerName = params.customerName
        def footNo = params.FOOT_NO
        def status = params.status
        def query_srv_code = params.srvcode
        def query_trade_code = params.tradecode
        def startDate = params.startDate
        def endDate = params.endDate

        println params
        def sql_data = """
                        select t.customer_no,t.seq_no,t.trade_code,t.srv_code,t.amount,t.post_fee,t.bill_date,t.trade_date,
                               (select tr.srv_name from ft_srv_type tr where tr.srv_code = t.srv_code  and rownum<2) srv_name,
                               (select tr.trade_name from FT_SRV_TRADE_TYPE tr where tr.trade_code = t.trade_code  and rownum<2) trade_name
                        from ft_trade t
                        where t.customer_no='$customerNo' and t.srv_code='$query_srv_code' and t.trade_code='$query_trade_code'
                    """

        if (status == '0') {
            sql_data += " and t.liquidate_no in (select tl.liquidate_no from ft_liquidate tl where tl.post_Foot_Status=0 and tl.post_foot_no is null and tl.fee_type=1 and tl.srv_code='$query_srv_code' and tl.trade_code='$query_trade_code' ${startDate ? "and tl.LIQ_DATE >= to_date('" + startDate.substring(0, 10) + "','yyyy-mm-dd')" : ""} ${endDate ? "and tl.LIQ_DATE <= to_date('" + endDate.substring(0, 10) + "','yyyy-mm-dd')" : ""})"
        } else if (status == '1') {
            sql_data += " and t.liquidate_no in (select tl.liquidate_no from ft_liquidate tl where tl.post_foot_no ='$footNo' and tl.fee_type=1 and tl.srv_code='$query_srv_code' and tl.trade_code='$query_trade_code') "
        }

        sql_data += " order by t.customer_no desc"

        def sql = new Sql(dataSource_settle)
        def queryParam = []
        def count = sql.firstRow("select count(*) total from (${sql_data})", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def results = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(sql_data.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)

            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        [ftTradeFeeList: results, total: count.total, startDate: startDate, endDate: endDate, customerNo: customerNo, customerName: customerName]
    }

    def shenhe_show = {
        params.sort = params.sort ? params.sort : "id"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def customerNo = params.customerNo
        def footNo = params.FOOT_NO
        def status = params.status
        def query_trade_code = params.tradecode
        def query_srv_code = params.srvcode

        def sql_data = """
                        select t.customer_no,t.seq_no,t.trade_code,t.srv_code,t.amount,t.post_fee,t.TRADE_DATE,t.BILL_DATE,
                               (select tr.srv_name from ft_srv_type tr where tr.srv_code = t.srv_code  and rownum<2) srv_name,
                               (select tr.trade_name from FT_SRV_TRADE_TYPE tr where tr.trade_code = t.trade_code  and rownum<2) trade_name
                        from ft_trade t
                        where t.customer_no=$customerNo and t.srv_code='$query_srv_code' and t.trade_code='$query_trade_code'
                    """


        if (status == '0' || status == '2') {
            sql_data += " and t.liquidate_no in (select tl.liquidate_no from ft_liquidate tl where tl.post_foot_no is null and tl.fee_type=1 and tl.srv_code='$query_srv_code' and tl.trade_code='$query_trade_code')"
        }
        else if (status == '1') {
            sql_data += " and t.liquidate_no in (select tl.liquidate_no from ft_liquidate tl where tl.post_foot_no ='$footNo' and tl.fee_type=1 and tl.srv_code='$query_srv_code' and tl.trade_code='$query_trade_code') "
        }

        sql_data += " order by t.customer_no desc"

        def sql = new Sql(dataSource_settle)
        def queryParam = []
        def count = sql.firstRow("select count(*) total from (${sql_data})", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def results = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(sql_data.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)

            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        [ftTradeFeeList: results, total: count.total]
    }

    def shenhe_his_show = {
        params.sort = params.sort ? params.sort : "id"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def customerNo = params.customerNo
        def footNo = params.FOOT_NO
        def status = params.status
        def query_trade_code = params.tradecode
        def query_srv_code = params.srvcode

        def sql_data = """
                       select t.customer_no,t.seq_no,t.trade_code,t.srv_code,t.amount,t.post_fee,t.TRADE_DATE,t.BILL_DATE,
                              (select tr.srv_name from ft_srv_type tr where tr.srv_code = t.srv_code  and rownum<2) srv_name,
                              (select tr.trade_name from FT_SRV_TRADE_TYPE tr where tr.trade_code = t.trade_code  and rownum<2) trade_name
                       from ft_trade t
                       where t.customer_no='$customerNo' and t.srv_code='$query_srv_code' and t.trade_code='$query_trade_code'
                    """

        if (status == '2') {
            sql_data += " and t.liquidate_no in (select tl.liquidate_no from ft_liquidate tl where tl.post_foot_no is null and tl.fee_type=1 and tl.srv_code='$query_srv_code' and tl.trade_code='$query_trade_code')"
        }else if (status == '0' || status == '1') {
            sql_data += "  and t.liquidate_no in (select tl.liquidate_no from ft_liquidate tl where tl.post_foot_no ='$footNo' and tl.fee_type=1 and tl.srv_code='$query_srv_code' and tl.trade_code='$query_trade_code') "
        }

        sql_data += " order by t.customer_no desc"

        def sql = new Sql(dataSource_settle)
        def queryParam = []
        def count = sql.firstRow("select count(*) total from (${sql_data})", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def results = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(sql_data.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)

            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        [ftTradeFeeList: results, total: count.total]
    }
    //后返手续费结算历史查询明细下载
    def downloadHis = {
        params.sort = params.sort ? params.sort : "id"

        def customerNo = params.customerNo
        def footNo = params.FOOT_NO
        def status = params.status
        def query_trade_code = params.tradecode
        def query_srv_code = params.srvcode

        def sql_data = """
                       select t.customer_no,t.seq_no,t.trade_code,t.srv_code,t.amount,t.post_fee,t.TRADE_DATE,t.BILL_DATE,
                              (select tr.srv_name from ft_srv_type tr where tr.srv_code = t.srv_code  and rownum<2) srv_name,
                              (select tr.trade_name from FT_SRV_TRADE_TYPE tr where tr.trade_code = t.trade_code  and rownum<2) trade_name
                       from ft_trade t
                       where t.customer_no='$customerNo' and t.srv_code='$query_srv_code' and t.trade_code='$query_trade_code'
                    """

        if (status == '2') {
            sql_data += " and t.liquidate_no in (select tl.liquidate_no from ft_liquidate tl where tl.post_foot_no is null and tl.fee_type=1 and tl.srv_code='$query_srv_code' and tl.trade_code='$query_trade_code')"
        }else if (status == '0' || status == '1') {
            sql_data += "  and t.liquidate_no in (select tl.liquidate_no from ft_liquidate tl where tl.post_foot_no ='$footNo' and tl.fee_type=1 and tl.srv_code='$query_srv_code' and tl.trade_code='$query_trade_code') "
        }

        sql_data += " order by t.customer_no desc"

        def sql = new Sql(dataSource_settle)
        def queryParam = []
        def count = sql.firstRow("select count(*) total, nvl(sum(amount),0) amount,nvl(sum(post_fee),0) postFee from (${sql_data})", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def results = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(sql_data.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)

            return sqlquery.list();
        } as HibernateCallback)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "shenhe_his_show", model: [ftTradeFeeList: results,total:count.total, amountTotal: count.amount,postFeeTotal: count.postFee])
    }
    def settle_list = {
        params.sort = params.sort ? params.sort : "id"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def customerNo = params.mid
        def startDate = params.start
        def endDate = params.end

        def sql = new Sql(dataSource_settle)
        def queryParam = []

        // 合计
        def whereSQL = """
                       li.FEE_TYPE=1 and li.POST_FOOT_STATUS=0
                       ${startDate ? "and li.LIQ_DATE >= to_date(substr('" + startDate + "',1,10),'yyyy-mm-dd')" : ""}
                       ${endDate ? "and li.LIQ_DATE <= to_date(substr('" + endDate + "',1,10),'yyyy-mm-dd')" : ""}
                       ${customerNo ? " and CUSTOMER_NO like '%" + customerNo + "%'" : ""}
                    """
        def total_amount_sql = "select nvl(sum(li.amount),0) amount,nvl(sum(li.POST_FEE),0) postFee from FT_LIQUIDATE li where ${whereSQL}"
        def query = """
                        select max(customerNo) customerNo,srvCode,tradeCode,max(srvName) srvName,max(tradeName) tradeName,sum(transNum) transNum,
                               sum(amount) amount,sum(postFee) postFee,max(status) status,min(liqDate) minTime, max(liqDate) maxTime
                        from (select li.CUSTOMER_NO customerNo, li.SRV_CODE srvCode, li.TRADE_CODE tradeCode,
                                     li.TRANS_NUM transNum,li.AMOUNT amount, li.POST_FEE postFee,li.STATUS status,
                                     li.LIQ_DATE liqDate,na.SRV_NAME srvName, na.TRADE_NAME tradeName
                              from FT_LIQUIDATE li
                              left join (select st.SRV_NAME SRV_NAME,tt.TRADE_NAME TRADE_NAME,st.SRV_CODE SRV_CODE,tt.TRADE_CODE TRADE_CODE
                                         from FT_SRV_TRADE_TYPE tt
                                         left join FT_SRV_TYPE st
                                         on st.ID=tt.SRV_ID
                                        ) na
                              on li.SRV_CODE = na.SRV_CODE and li.TRADE_CODE = na.TRADE_CODE
                              where ${whereSQL}
                             )
                        group by srvCode,tradeCode
                        order by customerNo desc
                 """

        def count = sql.firstRow("select count(*) total from (${query})", queryParam)
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }
            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        // 合计
        println "###${total_amount_sql}"
        def total_amount_fee = sql.firstRow(total_amount_sql, queryParam)
        def totalAmount = total_amount_fee.amount
        def totalPostFee = total_amount_fee.postFee

        //[ftTradeFeeList: results, params: params, customerNo: customerNo, customerName: customerName, startDate: startDate, endDate: endDate, total_amount: total_amount, total_postfee: total_postfee]
        [result: result, total: count.total, params: params, totalAmount: totalAmount, totalPostFee: totalPostFee]
    }

    def shenhe_list = {   //modify by xiexuanhua
        params.sort = params.sort ? params.sort : "id"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        //客户号码
        def customerNo = params.customerNo
        //客户名称
        def name = params.name
        //手续费结算类型
        def feeType = params.feeType

        //guonan update 2011-12-29
//        validDated(params)
        //开始时间
        def startDate = params.startTradeDate
        //结束时间
        def endDate = params.endTradeDate
//        //提交开始时间
//        def startFootDate = params.startFootDate
//        //提交截止时间
//        def endFootDate = params.endFootDate


        //guonan update 2011-12-29
        validFootDated(params)
        def startFootDate = params.startFootDate
         def endFootDate = ""
        if(params.endFootDate){
             endFootDate = (Date.parse('yyyy-MM-dd', params.endFootDate) + 1).format('yyyy-MM-dd')
        }

        //guonan update 2011-12-29


        def merNameList = null
        if(name != null && name.trim() != ""){
            def nameQuery = {
                or {
                    like("name","%"+name.trim()+"%")
                    like("registrationName","%"+name.trim()+"%")
                }
            }
            def cus = ismp.CmCustomer.createCriteria().list([:],nameQuery)
            if(cus.size() > 0){
                def StringBuffer sb = new StringBuffer()
                for(def cu in cus){
                    sb.append("'").append(cu.customerNo).append("',")
                }
                merNameList = sb.deleteCharAt(sb.length()-1).toString()
            }
        }

        println "#merNameList#${merNameList}"

        def whereSql = """
                        fo.fee_type>=1 and fo.type=0 and fo.check_status=0
                        ${startFootDate ? "and fo.FOOT_DATE >= to_date(substr('" + startFootDate + "',1,10),'yyyy-mm-dd')" : ""}
                        ${endFootDate ? "and fo.FOOT_DATE <= to_date(substr('" + endFootDate + "',1,10),'yyyy-mm-dd')" : ""}
                        ${customerNo ? " and CUSTOMER_NO like '%"+customerNo+"%'" : ""}
                        ${merNameList ? " and CUSTOMER_NO in ("+merNameList+")":""}
                        ${feeType ? " and FEE_TYPE = ("+feeType+")":""}
                        ${startDate ? "and li.minTime >= to_date(substr('" + startDate + "',1,10),'yyyy-mm-dd')" : ""}
                        ${endDate ? "and li.maxTime <= to_date(substr('" + endDate + "',1,10),'yyyy-mm-dd')" : ""}
                    """

        def total_amount_sql="""
                            select nvl(sum(fo.amount),0) amount,nvl(sum(fo.post_fee),0) post_fee
                            from ft_foot fo
                            left join (select POST_FOOT_NO,min(LIQ_DATE) minTime,max(LIQ_DATE) maxTime
                                       from FT_LIQUIDATE
                                       where POST_FOOT_STATUS=1
                                         and POST_FOOT_NO is not null
                                       group by POST_FOOT_NO
                                      ) li
                            on fo.FOOT_NO = li.POST_FOOT_NO
                            where ${whereSql}
                         """
        println "###${total_amount_sql}"

        def query =  """
                      select fo.ID id,fo.CUSTOMER_NO,fo.FOOT_NO, fo.FOOT_DATE,fo.SRV_CODE,fo.TRADE_CODE,
                             fo.TRANS_NUM,fo.AMOUNT,fo.POST_FEE,fo.CREATE_OP_ID,fo.CHECK_STATUS,fo.FEE_TYPE,
                             li.minTime minTime,li.maxTime maxTime,na.SRV_NAME,na.TRADE_NAME
                      from FT_FOOT fo
                      left join (select POST_FOOT_NO,min(LIQ_DATE) minTime,max(LIQ_DATE) maxTime
                                 from FT_LIQUIDATE
                                 where POST_FOOT_STATUS=1
                                  and POST_FOOT_NO is not null
                                 group by POST_FOOT_NO
                                ) li
                      on fo.FOOT_NO = li.POST_FOOT_NO
                      left join (select st.SRV_NAME SRV_NAME,tt.TRADE_NAME TRADE_NAME,st.SRV_CODE SRV_CODE,tt.TRADE_CODE TRADE_CODE
                                 from FT_SRV_TRADE_TYPE tt
                                 left join FT_SRV_TYPE st
                                 on st.ID=tt.SRV_ID
                                ) na
                      on fo.SRV_CODE = na.SRV_CODE and fo.TRADE_CODE = na.TRADE_CODE
                      where ${whereSql}
                      order by fo.ID desc
                  """
        println query
        def sql = new Sql(dataSource_settle)
        def queryParam = []
        def count = sql.firstRow("select count(*) total from (${query})", queryParam)
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        //println "##########${result}"

        // 合计
        def total_amount_fee=sql.firstRow(total_amount_sql, queryParam)
        def total_amount=total_amount_fee.amount
        def total_postfee=total_amount_fee.post_fee

        [ftTradeFeeList: result, total: count.total, params: params,total_amount: total_amount, total_postfee: total_postfee]
    }

    def shenhe = {
        println params.FOOT_NO
        //def bankList = boss.BoBankDic.findAll()
        [footno: params.FOOT_NO, tradecode: params.TRADE_CODE, srvcode: params.SRV_CODE, postfee: params.POST_FEE, cus_id: params.CUSTOMR_ID]

    }

    def dataSource_boss
    def dataSource_ismp

    //trade_account_command_saf
    def shenhe_allow = {
        def foot_no = params.footno
        def result = params.result
        def zhanghuanfangshi = params.zhanghuanfangshi
        def bank = params.bank
        def check_op_id = session.op.id
        def cusNo = params.cusid
        //def postfee = new java.math.BigDecimal(params.postfee)
        def srvcode = params.srvcode
        def tradecode = params.tradecode

        def customer = CmCustomer.findByCustomerNo(cusNo)
        def foot = FtFoot.findByFootNo(foot_no)
        if (foot.checkStatus != 0) {
            flash.message = "结算单状态已审核"
            redirect(action: "shenhe_list", params: params)
            return
        }
        if (!zhanghuanfangshi) {
            flash.message = "参数错误"
            redirect(action: "shenhe_list", params: params)
            return
        }

        //      java.math.BigDecimal settFund = new java.math.BigDecimal(params.settFund)*100

        println "cusNo:${cusNo}"
        //更新结算单的结算状态
        def sql = new Sql(dataSource_settle)
        def allow_sql = """ update ft_foot set check_status=1,  reject_reason=$result,check_date=sysdate,check_op_id=$check_op_id where  check_status=0 and fee_type>=1 and foot_no=$foot_no """
        //def qingsuan_sql = """update  ft_liquidate t set t.post_foot_no='$foot_no',post_foot_status=1 where fee_type=1 and post_foot_status=0 and t.trade_code='$tradecode' and t.srv_code='$srvcode' and t.customer_no='$customer.customerNo'"""

        //查找客户服务账户和手续费账户;
        def boss_sql = new Sql(dataSource_boss)
        def account_query_sql = """ select t.fee_acc_no,t.srv_acc_no from bo_customer_service t where t.customer_id=$customer.id and t.service_code='$srvcode' and t.is_current=1 """
        println "account_query_sql"
        println account_query_sql
        def account = boss_sql.firstRow(account_query_sql)
        def fee_acc_no = account.fee_acc_no
        // def srv_acc_no=account.srv_acc_no
        println "商户手续费账户号码:" + fee_acc_no
        def merFeeAccount = null
        if (fee_acc_no != null) {
            merFeeAccount = AcAccount.find("from AcAccount t where t.accountNo='" + fee_acc_no + "'")
        }

        // println "客户服务结算账户号码:"+srv_acc_no
        //def ismp_sql = new Sql(dataSource_ismp)
        //def customer_account = ismp_sql.firstRow(""" select t.account_no from cm_customer t where t.id = '$cusNo'""")
        def customer_account_no = customer.accountNo
        println "商户资金账户:" + customer_account_no
        def acAccount = null
        if (customer_account_no != null) {
            acAccount = AcAccount.find("from AcAccount t where t.accountNo='" + customer_account_no + "'")
        }
        println "acAccount"
        println acAccount
        BoInnerAccount feeAccount = BoInnerAccount.find("from BoInnerAccount t where t.key='feeInAdvance'")
        BoInnerAccount platAccount = BoInnerAccount.find("from BoInnerAccount t where t.key='feeAcc'")
        def collAccount = BoAcquirerAccount.get(bank.toLong()) //executeQuery("select t.innerAcountNo as innerAcountNo from BoAcquirerAccount t where t.status='normal'")

        //如果是资金账户:从商户资金账户中扣除相应手续费；
        //需选择对应银行（转入银行），银行账户、手续费账户增加记账；
        //如果选择的是客户服务账户
        def cmdList = []
        def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
        //商户现金账户结算
        println "zhanghuanfangshi:${zhanghuanfangshi}"
        if (zhanghuanfangshi == "1") {
            cmdList = accountClientService.buildTransfer(null, acAccount.accountNo, merFeeAccount.accountNo, foot.postFee, 'fee', foot_no, '0', "后返手续费结算")
        }

        if (zhanghuanfangshi == "2") {
            cmdList = accountClientService.buildTransfer(null, collAccount.innerAcountNo, merFeeAccount.accountNo, foot.postFee, 'fee', foot_no, '0', "后返手续费结算")
        }


        cmdList = accountClientService.buildTransfer(cmdList, feeAccount.accountNo, platAccount.accountNo, foot.postFee, 'fee', foot_no, '0', "后返手续费结算")
        def transResult = accountClientService.batchCommand(commandNo, cmdList)

        if (transResult.result != 'true') {
            flash.message = "手续费结算失败，错误码：" + transResult.errorCode + ",错误信息：" + transResult.errorMsg.toString().replaceAll("\"", "") + ""
            log.warn "手续费结算失败,${cmdList}"
            redirect(action: "shenhe_list", params: params)
            return
        }

        sql.executeUpdate(allow_sql)
        //sql.executeUpdate(qingsuan_sql)
        //        if (transResult.result == 'true') {
        //            msg = "ok"
        //            resultMsg = "手续费结算成功"
        //            render '{msg:"'+msg+'",data:{"resultMsg":"'+resultMsg+'"}}'
        //        } else {
        //            msg = "bad"
        //            resultMsg = "手续费结算失败，错误码："+transResult.errorCode+",错误信息："+transResult.errorMsg.toString().replaceAll("\"","")+""
        //            render '{msg:"'+msg+'",data:{"resultMsg":"'+resultMsg+'"}}'
        //        }

        flash.message = "${message(code: 'postFeeSettleshenhe_success.lable')}"
        redirect(action: "shenhe_list", params: params)
    }

    def shenhe_deny = {
        println params
        def foot_no = params.footno
        def result = params.result
        def zhanghuanfangshi = params.zhanghuanfangshi
        def bank = params.bank
        def check_op_id = session.op.id
        def srvcode = params.srvcode
        def tradecode = params.tradecode
        def fee_type = params.feetype
        def cusNo = params.cusid
        def postfee = params.postfee

        def sql = new Sql(dataSource_settle)

        if (String.valueOf(fee_type).equals('2')) {

            //查询商户服务手续费账户
            def serFeeAcc = ''
            def customerId = ismp.CmCustomer.findByCustomerNo(cusNo).id
            def serCode = srvcode
            def query = {
                eq('customerId', customerId)
                eq('serviceCode', serCode)
                eq('isCurrent', true)
                eq('enable', true)
            }

            def cusSer = boss.BoCustomerService.createCriteria().list(query)
            if (cusSer) {
                serFeeAcc = cusSer[0].feeAccNo
            } else {
                return '该服务目前停用，没有可用服务账户，无法设定费率'
            }
            //查询系统应收手续费账户
            def sysFeeAdvAcc = boss.BoInnerAccount.findByKey('feeInAdvance').accountNo

            /** 预收手续费转账
             *  由商户服务手续费账户转到平台收费账户
             *  生成后返结算单
             */
            def cmdList = null
            Random random = new Random()
            def seqNo = 101202170030000 + Math.abs(random.nextInt()%10000)
            cmdList = accountClientService.buildTransfer(cmdList, sysFeeAdvAcc, serFeeAcc, postfee as Long, 'fee',seqNo, '0', "包流量预付手续费审核拒绝")

            boolean redo = false
            try {
                def transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
                if (transResult.result != 'true') {
                    log.warn("实时转账失败，错误码：${transResult.errorCode},错误信息：${transResult.errorMsg},cmdList:${cmdList}")
                    //帐户余额不足或者账务系统故障需要重新转账
                    if (transResult.errorCode == '03' || transResult.errorCode == 'ff') {
                      redo = true
                    }
                }
            } catch (Exception e) {
                log.warn("balance trans faile,cmdList:${cmdList}", e)
                redo = true
            }

            if (!redo) {
                def ftTradeInstance = FtTradeFeeStep.findByFootNo(foot_no)
                if (ftTradeInstance) {
                    def feePre = ftTradeInstance.feePre
                    def feePreNew = (feePre - (new BigDecimal(postfee)).divide(100))
                    ftTradeInstance.feePre = feePreNew
                    ftTradeInstance.save()
                }
                //更新结算单的结算状态
                def deny_sql = """ update ft_foot set check_status=2,  reject_reason=$result,check_date=sysdate,check_op_id=$check_op_id where check_status=0 and fee_type=2 and foot_no=$foot_no """
                println deny_sql
                sql.executeUpdate(deny_sql)
            }

        } else {
            //审核拒绝：更新清算单批次号为空；更新清算单结果为未清算;
            sql.executeUpdate(""" update ft_liquidate t set t.post_foot_status=0,t.post_foot_no=null where t.post_foot_status=1 and t.fee_type=1 and t.post_foot_no='$foot_no' """)
            //更新结算单的结算状态
            def deny_sql = """ update ft_foot set check_status=2,  reject_reason=$result,check_date=sysdate,check_op_id=$check_op_id where check_status=0 and fee_type=1 and foot_no=$foot_no """
            println deny_sql
            sql.executeUpdate(deny_sql)
        }
        flash.message = "${message(code: 'postFeeSettleshenhe_deny.lable')}"
        redirect(action: "shenhe_list", params: params)
    }

    def shenhe_his_list = {
        println params

        params.sort = params.sort ? params.sort : "id"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        //客户号码
        def customerNo = params.customerNo
        //客户名称
        def name = params.name

       //guonan update 2011-12-29
         validFootDated(params)
        //提交开始时间
        def startFootDate = params.startFootDate
        //提交结束时间
        def endFootDate = params.endFootDate

         //guonan update 2011-12-29
//        validCheckDated(params)
        //复核起始时间
        def startcheckDate = params.startcheckDate
        //复核截止时间
        def endcheckDate = params.endcheckDate


        //guonan update 2011-12-29
//        validDatexd(params)
        //开始时间
        def startDate = params.startDate
        //结束时间
        def endDate = params.endDate



        //提交人
        def createopt = params.createopt
        //审批人
        def checkopt = params.checkopt
        //状态
        def checkstatus = params.checkstatus

        def sql = new Sql(dataSource_settle)

        def queryParam = []

        def merNameInID = null
        if (name != null && name.trim() != "") {
            def nameQuery = {
                or {
                    like("name", "%" + name.trim() + "%")
                    like("registrationName", "%" + name.trim() + "%")
                }
            }

            def merNameList = ismp.CmCustomer.createCriteria().list([:], nameQuery)
            if (merNameList != null && merNameList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def itm in merNameList) {
                    sb.append("'").append(itm.customerNo).append("',")
                }
                merNameInID = sb.deleteCharAt(sb.length() - 1).toString()
            }
        }
        println "#merNameInID#${merNameInID}"
        def createrNameInID = null
        if (createopt != null && createopt.trim() != "") {
            def nameQuery = {
                like("account", "%" + createopt.trim() + "%")
            }

            def createrNameList = boss.BoOperator.createCriteria().list([:], nameQuery)
            if (createrNameList != null && createrNameList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def item in createrNameList) {
                    sb.append("'").append(item.id).append("',")
                }
                createrNameInID = sb.deleteCharAt(sb.length() - 1).toString()
            }
        }
        println "#createrNameInID#${createrNameInID}"
        def checkerNameInID = null
        if (checkopt != null && checkopt.trim() != "") {
            def nameQuery = {
                like("account", "%" + checkopt.trim() + "%")
            }

            def checkerNameList = boss.BoOperator.createCriteria().list([:], nameQuery)
            if (checkerNameList != null && checkerNameList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def item in checkerNameList) {
                    sb.append("'").append(item.id).append("',")
                }
                checkerNameInID = sb.deleteCharAt(sb.length() - 1).toString()
            }
        }
        println "#checkerNameInID#${checkerNameInID}"

        def whereSql = """
                        fo.fee_type>=1 ${checkstatus ? ' and fo.CHECK_STATUS=' + checkstatus : ''}
                        ${merNameInID ? ' and fo.customer_no in (' + merNameInID + ')' : ''} ${customerNo ? " and fo.customer_no like '%" + customerNo + "%'" : ""}
                        ${createrNameInID ? ' and fo.create_op_id in (' + createrNameInID + ')' : ''} ${checkerNameInID ? ' and check_op_id in (' + checkerNameInID + ')' : ''}
                        ${startFootDate ? " and fo.foot_date >= to_date('" + startFootDate + " 00:00:00','yyyy-mm-dd hh24:mi:ss')" : ""} ${endFootDate ? " and fo.foot_date <= to_date('" + endFootDate + " 23:59:59','yyyy-mm-dd hh24:mi:ss')" : ""}
                        ${startcheckDate ? " and fo.check_date >= to_date('" + startcheckDate + " 00:00:00','yyyy-mm-dd hh24:mi:ss')" : ""} ${endcheckDate ? " and fo.check_date <= to_date('" + endcheckDate + " 23:59:59','yyyy-mm-dd hh24:mi:ss')" : ""}
                        ${startDate ? " and li.minTime >= to_date('" + startDate + "','yyyy-mm-dd')" : ""} ${endDate ? " and li.maxTime <= to_date('" + endDate + "','yyyy-mm-dd')" : ""}
                    """
        println "#whereSql#${whereSql}"

        // 合计
        def total_amount_sql = """
                              select nvl(sum(fo.amount),0) amount,nvl(sum(fo.post_fee),0) postFee
                              from ft_foot fo
                              left join (select POST_FOOT_NO,min(LIQ_DATE) minTime,max(LIQ_DATE) maxTime
                                         from FT_LIQUIDATE
                                         group by POST_FOOT_NO
                                        ) li
                              on fo.FOOT_NO = li.POST_FOOT_NO
                              where ${whereSql}
                           """

        def query = """
                        select fo.ID id,fo.CUSTOMER_NO,fo.CHECK_DATE,fo.FOOT_NO,fo.FOOT_DATE,fo.SRV_CODE,fo.TRADE_CODE,fo.FEE_TYPE,
                               fo.TRANS_NUM,fo.AMOUNT,fo.PRE_FEE,fo.POST_FEE,fo.CHECK_STATUS,decode(fo.type,0,'自动','1','手动') type,fo.REJECT_REASON,
                               nvl(fo.CREATE_OP_ID, 0) CREATE_OP_ID,nvl(fo.CHECK_OP_ID, 0) CHECK_OP_ID,li.minTime,li.maxTime,na.SRV_NAME,na.TRADE_NAME
                        from ft_foot fo
                        left join (select st.SRV_NAME SRV_NAME,tt.TRADE_NAME TRADE_NAME,st.SRV_CODE SRV_CODE,tt.TRADE_CODE TRADE_CODE
                                 from FT_SRV_TRADE_TYPE tt
                                 left join FT_SRV_TYPE st
                                 on st.ID=tt.SRV_ID
                                ) na
                        on fo.SRV_CODE = na.SRV_CODE and fo.TRADE_CODE = na.TRADE_CODE
                        left join (select POST_FOOT_NO,min(LIQ_DATE) minTime,max(LIQ_DATE) maxTime
                                 from FT_LIQUIDATE
                                 group by POST_FOOT_NO
                                ) li
                        on fo.FOOT_NO = li.POST_FOOT_NO
                        where ${whereSql}
                        order by fo.id desc
                  """

        println "#query#${query}"

        def count = sql.firstRow("select count(*) total from (${query})", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list()
        } as HibernateCallback)

        // 合计
        println "###${total_amount_sql}"
        def total_amount_fee = sql.firstRow(total_amount_sql, queryParam)
        def total_amount = total_amount_fee.amount
        def total_postfee = total_amount_fee.postFee

        [ftTradeFeeList: result, total: count.total, params: params, total_amount: total_amount, total_postfee: total_postfee]
    }

     def shenhe_his_download = {
        params.sort = params.sort ? params.sort : "id"

        //客户号码
        def customerNo = params.customerNo
        //客户名称
        def name = params.name

       //guonan update 2011-12-29
         validFootDated(params)
        //提交开始时间
        def startFootDate = params.startFootDate
        //提交结束时间
        def endFootDate = params.endFootDate

         //guonan update 2011-12-29
        validCheckDated(params)
        //复核起始时间
        def startcheckDate = params.startcheckDate
        //复核截止时间
        def endcheckDate = params.endcheckDate


        //guonan update 2011-12-29
        validDatexd(params)
        //开始时间
        def startDate = params.startDate
        //结束时间
        def endDate = params.endDate



        //提交人
        def createopt = params.createopt
        //审批人
        def checkopt = params.checkopt
        //状态
        def checkstatus = params.checkstatus

        def sql = new Sql(dataSource_settle)

        def queryParam = []

        def merNameInID = null
        if (name != null && name.trim() != "") {
            def nameQuery = {
                or {
                    like("name", "%" + name.trim() + "%")
                    like("registrationName", "%" + name.trim() + "%")
                }
            }

            def merNameList = ismp.CmCustomer.createCriteria().list([:], nameQuery)
            if (merNameList != null && merNameList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def itm in merNameList) {
                    sb.append("'").append(itm.customerNo).append("',")
                }
                merNameInID = sb.deleteCharAt(sb.length() - 1).toString()
            }
        }
        println "#merNameInID#${merNameInID}"
        def createrNameInID = null
        if (createopt != null && createopt.trim() != "") {
            def nameQuery = {
                like("account", "%" + createopt.trim() + "%")
            }

            def createrNameList = boss.BoOperator.createCriteria().list([:], nameQuery)
            if (createrNameList != null && createrNameList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def item in createrNameList) {
                    sb.append("'").append(item.id).append("',")
                }
                createrNameInID = sb.deleteCharAt(sb.length() - 1).toString()
            }
        }
        println "#createrNameInID#${createrNameInID}"
        def checkerNameInID = null
        if (checkopt != null && checkopt.trim() != "") {
            def nameQuery = {
                like("account", "%" + checkopt.trim() + "%")
            }

            def checkerNameList = boss.BoOperator.createCriteria().list([:], nameQuery)
            if (checkerNameList != null && checkerNameList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def item in checkerNameList) {
                    sb.append("'").append(item.id).append("',")
                }
                checkerNameInID = sb.deleteCharAt(sb.length() - 1).toString()
            }
        }
        println "#checkerNameInID#${checkerNameInID}"

        def whereSql = """
                        fo.fee_type=1 ${checkstatus ? ' and fo.CHECK_STATUS=' + checkstatus : ''}
                        ${merNameInID ? ' and fo.customer_no in (' + merNameInID + ')' : ''} ${customerNo ? " and fo.customer_no like '%" + customerNo + "%'" : ""}
                        ${createrNameInID ? ' and fo.create_op_id in (' + createrNameInID + ')' : ''} ${checkerNameInID ? ' and check_op_id in (' + checkerNameInID + ')' : ''}
                        ${startFootDate ? " and fo.foot_date >= to_date('" + startFootDate + " 00:00:00','yyyy-mm-dd hh24:mi:ss')" : ""} ${endFootDate ? " and fo.foot_date <= to_date('" + endFootDate + " 23:59:59','yyyy-mm-dd hh24:mi:ss')" : ""}
                        ${startcheckDate ? " and fo.check_date >= to_date('" + startcheckDate + " 00:00:00','yyyy-mm-dd hh24:mi:ss')" : ""} ${endcheckDate ? " and fo.check_date <= to_date('" + endcheckDate + " 23:59:59','yyyy-mm-dd hh24:mi:ss')" : ""}
                        ${startDate ? " and li.minTime >= to_date('" + startDate + "','yyyy-mm-dd')" : ""} ${endDate ? " and li.maxTime <= to_date('" + endDate + "','yyyy-mm-dd')" : ""}
                    """
        println "#whereSql#${whereSql}"

        // 合计
        def total_amount_sql = """
                              select nvl(sum(fo.amount),0) amount,nvl(sum(fo.post_fee),0) postFee
                              from ft_foot fo
                              left join (select POST_FOOT_NO,min(LIQ_DATE) minTime,max(LIQ_DATE) maxTime
                                         from FT_LIQUIDATE
                                         group by POST_FOOT_NO
                                        ) li
                              on fo.FOOT_NO = li.POST_FOOT_NO
                              where ${whereSql}
                           """

        def query = """
                        select fo.ID id,fo.CUSTOMER_NO,fo.CHECK_DATE,fo.FOOT_NO,fo.FOOT_DATE,fo.SRV_CODE,fo.TRADE_CODE,fo.FEE_TYPE,
                               fo.TRANS_NUM,fo.AMOUNT,fo.PRE_FEE,fo.POST_FEE,fo.CHECK_STATUS,decode(fo.type,0,'自动','1','手动') type,fo.REJECT_REASON,
                               nvl(fo.CREATE_OP_ID, 0) CREATE_OP_ID,nvl(fo.CHECK_OP_ID, 0) CHECK_OP_ID,li.minTime,li.maxTime,na.SRV_NAME,na.TRADE_NAME
                        from ft_foot fo
                        left join (select st.SRV_NAME SRV_NAME,tt.TRADE_NAME TRADE_NAME,st.SRV_CODE SRV_CODE,tt.TRADE_CODE TRADE_CODE
                                 from FT_SRV_TRADE_TYPE tt
                                 left join FT_SRV_TYPE st
                                 on st.ID=tt.SRV_ID
                                ) na
                        on fo.SRV_CODE = na.SRV_CODE and fo.TRADE_CODE = na.TRADE_CODE
                        left join (select POST_FOOT_NO,min(LIQ_DATE) minTime,max(LIQ_DATE) maxTime
                                 from FT_LIQUIDATE
                                 group by POST_FOOT_NO
                                ) li
                        on fo.FOOT_NO = li.POST_FOOT_NO
                        where ${whereSql}
                        order by fo.id desc
                  """

        println "#query#${query}"

        def count = sql.firstRow("select count(*) total from (${query})", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.list()
        } as HibernateCallback)

        // 合计
        println "###${total_amount_sql}"
        def total_amount_fee = sql.firstRow(total_amount_sql, queryParam)
        def total_amount = total_amount_fee.amount
        def total_postfee = total_amount_fee.postFee
        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "shenhe_his_list", model: [ftTradeFeeList: result, total: count.total, params: params, total_amount: total_amount, total_postfee: total_postfee])
    }
    //结算单历史查询
    def settle_his_list = {
        println "#params#${params}"

        params.sort = params.sort ? params.sort : "id"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        //客户号码
        def customerNo = params.customerNo
        //客户名称
        def name = params.name

         //guonan update 2011-12-29
        validDated(params)
        //复核开始时间
        def startDate = params.startTradeDate
        //复核结束时间
        def endDate = params.endTradeDate

        //提交人
        def createopt = params.createopt
        //审批人
        def checkopt = params.checkopt

        //状态
        def checkstatus = params.checkstatus
        //业务类别
        def que_srvcode = params.bType
        //交易类别
        def que_tradecode = params.tType

        def sql = new Sql(dataSource_settle)

        def queryParam = []
        def merNameInID = null
        if (name != null && name.trim() != "") {
            def nameQuery = {
                or {
                    like("name", "%" + name.trim() + "%")
                    like("registrationName", "%" + name.trim() + "%")
                }
            }

            def merNameList = ismp.CmCustomer.createCriteria().list([:], nameQuery)
            if (merNameList != null && merNameList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def itm in merNameList) {
                    sb.append("'").append(itm.customerNo).append("',")
                }
                merNameInID = sb.deleteCharAt(sb.length() - 1).toString()
            } else{
                 merNameInID='-1'
            }
        }
        println "#merNameInID#${merNameInID}"
        def createrNameInID = null
        if (createopt != null && createopt.trim() != "") {
            def nameQuery = {
//                like("name", "%" + createopt.trim() + "%")
                like("account", "%" + checkopt.trim() + "%")
            }

            def createrNameList = boss.BoOperator.createCriteria().list([:], nameQuery)
            if (createrNameList != null && createrNameList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def item in createrNameList) {
                    sb.append("'").append(item.id).append("',")
                }
                createrNameInID = sb.deleteCharAt(sb.length() - 1).toString()
            }else{
                 createrNameInID='-1'
            }
        }
        println "#createrNameInID#${createrNameInID}"
        def checkerNameInID = null
        if (checkopt != null && checkopt.trim() != "") {
            def nameQuery = {
//                like("name", "%" + checkopt.trim() + "%")
                like("account", "%" + checkopt.trim() + "%")
            }

            def checkerNameList = boss.BoOperator.createCriteria().list([:], nameQuery)
            if (checkerNameList != null && checkerNameList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def item in checkerNameList) {
                    sb.append("'").append(item.id).append("',")
                }
                checkerNameInID = sb.deleteCharAt(sb.length() - 1).toString()
            } else{
                 checkerNameInID='-1'
            }
        }
        println "#checkerNameInID#${checkerNameInID}"

        def query = """
                        select fo.ID id,fo.CUSTOMER_NO,fo.CHECK_DATE,fo.FOOT_NO,fo.FOOT_DATE,fo.SRV_CODE,fo.TRADE_CODE,fo.FEE_TYPE,
                               fo.TRANS_NUM,fo.AMOUNT,fo.PRE_FEE,fo.POST_FEE,fo.CHECK_STATUS,decode(fo.type,0,'自动','1','手动') type,fo.REJECT_REASON,
                               nvl(fo.CREATE_OP_ID, 0) CREATE_OP_ID,nvl(fo.CHECK_OP_ID, 0) CHECK_OP_ID,li.minTime,li.maxTime,na.SRV_NAME,na.TRADE_NAME
                        from ft_foot fo
                        left join (select st.SRV_NAME SRV_NAME,tt.TRADE_NAME TRADE_NAME,st.SRV_CODE SRV_CODE,tt.TRADE_CODE TRADE_CODE
                                   from FT_SRV_TRADE_TYPE tt
                                   left join FT_SRV_TYPE st
                                   on st.ID=tt.SRV_ID
                                  ) na
                        on fo.SRV_CODE = na.SRV_CODE and fo.TRADE_CODE = na.TRADE_CODE
                        left join (select FOOT_NO,min(LIQ_DATE) minTime,max(LIQ_DATE) maxTime
                                   from FT_LIQUIDATE
                                   where 1 = 1
                                   ${startDate ? " and LIQ_DATE >= to_date('" + startDate + "','yyyy-mm-dd')" : ""} ${endDate ? " and LIQ_DATE <= to_date('" + endDate + "','yyyy-mm-dd')" : ""}
                                   group by FOOT_NO
                                  ) li
                        on fo.FOOT_NO = li.FOOT_NO
                        where fo.FEE_TYPE=0 ${merNameInID ? ' and fo.customer_no in (' + merNameInID + ')' : ''} ${createrNameInID ? ' and fo.create_op_id in (' + createrNameInID + ')' : ''} ${checkerNameInID ? ' and fo.check_op_id in (' + checkerNameInID + ')' : ''}
                              ${checkstatus ? ' and fo.CHECK_STATUS=' + checkstatus : ''} ${que_srvcode ? " and fo.SRV_CODE='" + que_srvcode + "'" : ""} ${que_tradecode ? " and fo.TRADE_CODE='" + que_tradecode + "'" : ""}
                              ${customerNo ? " and fo.customer_no like '%" + customerNo + "%'" : ""}

                        order by fo.id desc
                  """

        println "#query#${query}"

        def count = sql.firstRow("select count(*) total, nvl(sum(post_fee),0) post_fee,nvl(sum(pre_fee),0) pre_fee,nvl(sum(amount),0) amount from (${query})", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list()
        } as HibernateCallback)

        println "#result#${result}"

        // 业务类型,交易类型
        def bTypeList = FtSrvType.list()
        def tTypeList = null
        if (params.bType != null && params.bType != "") {
            tTypeList = FtSrvTradeType.findAllBySrv(FtSrvType.findBySrvCode(params.bType))
        }
        def totalAmount=0
        for(r in result){
            if(r.PRE_FEE){
                totalAmount = totalAmount +(r.AMOUNT - r.PRE_FEE)
            }
        }
        [ftTradeFeeList: result, total: count.total, params: params, bTypeList: bTypeList, tTypeList: tTypeList, preFee: count.pre_fee, postFee: count.post_fee, amount: count.amount,totalAmount:totalAmount]
    }

    //结算单历史下载
     def settle_his_Download = {
        params.sort = params.sort ? params.sort : "id"

        //客户号码
        def customerNo = params.customerNo
        //客户名称
        def name = params.name

         //guonan update 2011-12-29
        validDated(params)
        //复核开始时间
        def startDate = params.startTradeDate
        //复核结束时间
        def endDate = params.endTradeDate

        //提交人
        def createopt = params.createopt
        //审批人
        def checkopt = params.checkopt

        //状态
        def checkstatus = params.checkstatus
        //业务类别
        def que_srvcode = params.bType
        //交易类别
        def que_tradecode = params.tType

        def sql = new Sql(dataSource_settle)

        def queryParam = []
        def merNameInID = null
        if (name != null && name.trim() != "") {
            def nameQuery = {
                or {
                    like("name", "%" + name.trim() + "%")
                    like("registrationName", "%" + name.trim() + "%")
                }
            }

            def merNameList = ismp.CmCustomer.createCriteria().list([:], nameQuery)
            if (merNameList != null && merNameList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def itm in merNameList) {
                    sb.append("'").append(itm.customerNo).append("',")
                }
                merNameInID = sb.deleteCharAt(sb.length() - 1).toString()
            }
        }

        def createrNameInID = null
        if (createopt != null && createopt.trim() != "") {
            def nameQuery = {
                like("name", "%" + createopt.trim() + "%")
            }

            def createrNameList = boss.BoOperator.createCriteria().list([:], nameQuery)
            if (createrNameList != null && createrNameList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def item in createrNameList) {
                    sb.append("'").append(item.id).append("',")
                }
                createrNameInID = sb.deleteCharAt(sb.length() - 1).toString()
            }
        }

        def checkerNameInID = null
        if (checkopt != null && checkopt.trim() != "") {
            def nameQuery = {
                like("name", "%" + checkopt.trim() + "%")
            }

            def checkerNameList = boss.BoOperator.createCriteria().list([:], nameQuery)
            if (checkerNameList != null && checkerNameList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def item in checkerNameList) {
                    sb.append("'").append(item.id).append("',")
                }
                checkerNameInID = sb.deleteCharAt(sb.length() - 1).toString()
            }
        }

        def query = """
                        select fo.ID id,fo.CUSTOMER_NO,fo.CHECK_DATE,fo.FOOT_NO,fo.FOOT_DATE,fo.SRV_CODE,fo.TRADE_CODE,fo.FEE_TYPE,
                               fo.TRANS_NUM,fo.AMOUNT,fo.PRE_FEE,fo.POST_FEE,fo.CHECK_STATUS,decode(fo.type,0,'自动','1','手动') type,fo.REJECT_REASON,
                               nvl(fo.CREATE_OP_ID, 0) CREATE_OP_ID,nvl(fo.CHECK_OP_ID, 0) CHECK_OP_ID,li.minTime,li.maxTime,na.SRV_NAME,na.TRADE_NAME
                        from ft_foot fo
                        left join (select st.SRV_NAME SRV_NAME,tt.TRADE_NAME TRADE_NAME,st.SRV_CODE SRV_CODE,tt.TRADE_CODE TRADE_CODE
                                   from FT_SRV_TRADE_TYPE tt
                                   left join FT_SRV_TYPE st
                                   on st.ID=tt.SRV_ID
                                  ) na
                        on fo.SRV_CODE = na.SRV_CODE and fo.TRADE_CODE = na.TRADE_CODE
                        left join (select FOOT_NO,min(LIQ_DATE) minTime,max(LIQ_DATE) maxTime
                                   from FT_LIQUIDATE
                                   group by FOOT_NO
                                  ) li
                        on fo.FOOT_NO = li.FOOT_NO
                        where fo.FEE_TYPE=0 ${merNameInID ? ' and fo.customer_no in (' + merNameInID + ')' : ''} ${createrNameInID ? ' and fo.create_op_id in (' + createrNameInID + ')' : ''} ${checkerNameInID ? ' and fo.check_op_id in (' + checkerNameInID + ')' : ''}
                              ${checkstatus ? ' and fo.CHECK_STATUS=' + checkstatus : ''} ${que_srvcode ? " and fo.SRV_CODE='" + que_srvcode + "'" : ""} ${que_tradecode ? " and fo.TRADE_CODE='" + que_tradecode + "'" : ""}
                              ${customerNo ? " and fo.customer_no like '%" + customerNo + "%'" : ""}
                              ${startDate ? " and li.minTime >= to_date('" + startDate + "','yyyy-mm-dd')" : ""} ${endDate ? " and li.maxTime <= to_date('" + endDate + "','yyyy-mm-dd')" : ""}
                        order by fo.id desc
                  """

        def count = sql.firstRow("select count(*) total, nvl(sum(post_fee),0) post_fee,nvl(sum(pre_fee),0) pre_fee,nvl(sum(amount),0) amount from (${query})", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.list()
        } as HibernateCallback)

        // 业务类型,交易类型
        def bTypeList = FtSrvType.list()
        def tTypeList = null
        if (params.bType != null && params.bType != "") {
            tTypeList = FtSrvTradeType.findAllBySrv(FtSrvType.findBySrvCode(params.bType))
        }

        def totalAmount=0
        for(r in result){
            if(r.PRE_FEE){
                totalAmount = totalAmount +(r.AMOUNT - r.PRE_FEE)
            }
        }
         def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
         response.setHeader("Content-disposition", "attachment; filename=" + filename)
         response.contentType = "application/x-rarx-rar-compressed"
         response.setCharacterEncoding("UTF-8")
         render(template: "settle_his_list", model: [ftTradeFeeList: result, total: count.total, params: params, bTypeList: bTypeList, tTypeList: tTypeList, preFee: count.pre_fee, postFee: count.post_fee, amount: count.amount,totalAmount:totalAmount])
    }

    def settle_his_showresult = {
        println params.REJECT_REASON
        [REJECT_REASON: params.REJECT_REASON]
    }

    def settle_his_showdetails = {
        println params

        params.sort = params.sort ? params.sort : "id"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        if (!params.id) {
            flash.message = "${message(code: 'ftTrade.invalid.noId.label')}"
            redirect(controller: "postFeeSettle", action: "settle_his_list")
        }

        def sql = new Sql(dataSource_settle)
        def queryParam = []
        if (params.id != null && params.id != "") {
            queryParam.add(params.id)
        }

        println "#1###${queryParam}"

        def query = """
                  select t.CUSTOMER_NO,t.SEQ_NO, t.TRADE_DATE, t.SRV_CODE, t.TRADE_CODE, t.AMOUNT, t.PRE_FEE,
                         t.POST_FEE, t.BILL_DATE, l.LIQUIDATE_NO, l.SRV_NAME,l.TRADE_NAME
                  from FT_TRADE t
                  right join (select lf.SRV_CODE SRV_CODE,lf.TRADE_CODE TRADE_CODE,lf.LIQUIDATE_NO LIQUIDATE_NO,na.SRV_NAME SRV_NAME,na.TRADE_NAME TRADE_NAME
                       from (select li.SRV_CODE SRV_CODE,li.TRADE_CODE TRADE_CODE,li.LIQUIDATE_NO LIQUIDATE_NO,fo.FOOT_NO FOOT_NO
                             from FT_LIQUIDATE li
                             right join FT_FOOT fo
                             on li.FOOT_NO = fo.FOOT_NO
                             where li.STATUS=1 and fo.id =?
                            ) lf
                       left join (select st.SRV_NAME SRV_NAME,tt.TRADE_NAME TRADE_NAME,st.SRV_CODE SRV_CODE,tt.TRADE_CODE TRADE_CODE
                                  from FT_SRV_TRADE_TYPE tt
                                  left join FT_SRV_TYPE st
                                  on st.ID=tt.SRV_ID
                                 ) na
                       on lf.SRV_CODE = na.SRV_CODE and lf.TRADE_CODE = na.TRADE_CODE
                  ) l
                  on t.LIQUIDATE_NO = l.LIQUIDATE_NO
                  where t.CUSTOMER_NO is not null
                  order by CUSTOMER_NO desc
                 """
        //where l.LIQUIDATE_NO is not null

        def count = sql.firstRow("select count(*) total from (${query})", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list()
        } as HibernateCallback)

        println "##2#########${result}"
        println "##3#########${count}"

        [ftTradeFeeList: result, total: count.total]
    }

    def showresult = {
        println params.REJECT_REASON
        [REJECT_REASON: params.REJECT_REASON]
    }

    def bTypeList = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def query = { }
        def tList = FtSrvType.createCriteria().list(params, query)
        return tList
    }

    def queryTrade = {
        def srvCode = params.srvCode ? params.srvCode : null
        if (!srvCode) {
            flash.message = "${message(code: 'ftLiquidate.invalid.noSrvCode.label')}"
            redirect(action: "list")
        }
        def sql = "from FtSrvTradeType where srv.srvCode='" + srvCode + "'"
        def tradeLs = FtSrvTradeType.findAll(sql)
        render tradeLs as JSON
    }

    def downloadDetails = {
        params.sort = params.sort ? params.sort : "id"

        if (!params.id) {
            flash.message = "${message(code: 'ftTrade.invalid.noId.label')}"
            redirect(controller: "postFeeSettle", action: "settle_his_list")
        }

        def sql = new Sql(dataSource_settle)
        def queryParam = []
        if (params.id != null && params.id != "") {
            queryParam.add(params.id)
        }
        def query = """
                  select t.CUSTOMER_NO,t.SEQ_NO, t.TRADE_DATE, t.SRV_CODE, t.TRADE_CODE, t.AMOUNT, t.PRE_FEE,
                         t.POST_FEE, t.BILL_DATE, l.LIQUIDATE_NO, l.SRV_NAME,l.TRADE_NAME
                  from FT_TRADE t
                  right join (select lf.SRV_CODE SRV_CODE,lf.TRADE_CODE TRADE_CODE,lf.LIQUIDATE_NO LIQUIDATE_NO,na.SRV_NAME SRV_NAME,na.TRADE_NAME TRADE_NAME
                       from (select li.SRV_CODE SRV_CODE,li.TRADE_CODE TRADE_CODE,li.LIQUIDATE_NO LIQUIDATE_NO,fo.FOOT_NO FOOT_NO
                             from FT_LIQUIDATE li
                             right join FT_FOOT fo
                             on li.FOOT_NO = fo.FOOT_NO
                             where li.STATUS=1 and fo.id =?
                            ) lf
                       left join (select st.SRV_NAME SRV_NAME,tt.TRADE_NAME TRADE_NAME,st.SRV_CODE SRV_CODE,tt.TRADE_CODE TRADE_CODE
                                  from FT_SRV_TRADE_TYPE tt
                                  left join FT_SRV_TYPE st
                                  on st.ID=tt.SRV_ID
                                 ) na
                       on lf.SRV_CODE = na.SRV_CODE and lf.TRADE_CODE = na.TRADE_CODE
                  ) l
                  on t.LIQUIDATE_NO = l.LIQUIDATE_NO
                  order by CUSTOMER_NO desc
                 """
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.list()
        } as HibernateCallback)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "settle_his_showdetails", model: [ftTradeFeeList: result])
    }
}