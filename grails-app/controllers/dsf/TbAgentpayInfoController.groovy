package dsf

import boss.BoAcquirerAccount
import boss.BoBankDic
import boss.BoInnerAccount
import ismp.CmCustomer
import boss.BoCustomerService
import boss.EntrustService
import groovy.sql.Sql
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import boss.BoOperator
import ismp.CmCorporationInfo
import org.apache.http.conn.HttpHostConnectException

class TbAgentpayInfoController {
    def accountClientService
    def dataSource_boss
    def dataSource_dsf
    def index = { }
    def entrustService
    def  agentService;
    def agentDownloadForExcelService;
    def dkTypeMap = {tradeRemark2 ->
        def dkTypeMap = ""
        if (params.tradeRemark2 == "05") {
            dkTypeMap = "代收"
        } else if (params.tradeRemark2 == "06") {
            dkTypeMap = "代付"
        }
        return dkTypeMap
    }

    def bankList = {
        def listAccountNo = TbBindBank.executeQuery("select distinct t.bankAccountno as bankAccountno from TbBindBank t where t.dsfFlag in ('F','S')")
        def bankDic = new ArrayList()
        if (listAccountNo != null && listAccountNo != "") {
            def boAcquirerAccount = BoAcquirerAccount.createCriteria().list {
                eq("status", "normal")
                'in'("bankAccountNo", listAccountNo)
            }
            println boAcquirerAccount.bank.id
            bankDic = BoBankDic.createCriteria().list {
                'in'("id", boAcquirerAccount.bank.id)
            }
        }
        return bankDic
    }
    def bankListNew = {

        return TbAdjustBankCard.executeQuery("select distinct bankCode ,bankCode , note from TbAdjustBankCard order by bankCode");
    }
/**
 * 查询银行并拼接字符串
 * @param tradeAccountname
 * @return
 */
    def findTradeAccountnames(String tradeAccountname) {
        def tradeAccountNames = TbAdjustBankCard.executeQuery("select bankNames from TbAdjustBankCard where bankCode = '" + tradeAccountname + "'");
        return tradeAccountNames;
    }
    /**
     * 查询银行并拼接字符串
     * @param tradeAccountname
     * @return
     */
    def findTradeAccountnamesForStr(String tradeAccountname) {
        String bankNames = '';
        def sql = new Sql(DatasourcesUtils.getDataSource("dsf"))
        def strSql = "select wm_concat(''''||t.bank_names||'''') as bankNames from tb_adjust_bank t where t.bank_code = '" + tradeAccountname + "'";

        sql.eachRow(strSql) {

            bankNames = it.bankNames;
        }
        println bankNames;
        return bankNames;
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
        if (params.startTime == null && params.endTime == null) {
            def gCalendar = new GregorianCalendar()
            params.endTime = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startTime = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startTime && !params.endTime) {
            params.endTime = params.startTime
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startTime && params.endTime) {
            params.startTime = params.endTime
        }
        //-----------验证审核时间 start----------
        /*//如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.tradeSyschkdateStart == null && params.tradeSyschkdateEnd == null) {
            def gCalendar = new GregorianCalendar()
            params.tradeSyschkdateEnd = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.tradeSyschkdateStart = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.tradeSyschkdateStart && !params.tradeSyschkdateEnd) {
            params.tradeSyschkdateEnd = params.tradeSyschkdateStart
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.tradeSyschkdateStart && params.tradeSyschkdateEnd) {
            params.tradeSyschkdateStart = params.tradeSyschkdateEnd
        }*/
        //-----------验证审核时间 end----------
        //-----------验证交易完毕时间 start----------
       /* //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.tradeDonedateStart == null && params.tradeDonedateEnd == null) {
            def gCalendar = new GregorianCalendar()
            params.tradeDonedateEnd = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.tradeDonedateStart = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.tradeDonedateStart && !params.tradeDonedateEnd) {
            params.tradeDonedateEnd = params.tradeDonedateStart
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.tradeDonedateStart && params.tradeDonedateEnd) {
            params.tradeDonedateStart = params.tradeDonedateEnd
        }*/
        //-----------验证交易完毕时间 end----------
    }


    def transactionList = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        params.sort = params.sort ? params.sort : "id"
        params.order = params.order ? params.order : "desc"
        def query =
        {
            //def cmCustomer
            //guonan update 2012-06-27
            if (params.saleType == 'sale') {
                def account = session.op.account
                def operator = BoOperator.findByAccount(account)
                println "and s.belongToSale = ${operator.name}"
                if ((operator.name != null && operator.name != "") || operator.role.roleName == "admin") {
                    def para = [:]
                    para['belongToSale'] = operator.name
                    para['belongToBusiness'] = params.belongToBusiness
                    para['grade'] = params.grade
                    def que = {
                        if (operator.name && operator.role.roleName != "admin") {
                            eq('belongToSale', para.belongToSale)
                        }
                        if (params.belongToBusiness) {
                            ilike('belongToBusiness', '%' + para.belongToBusiness + '%')
                        }
                        if (params.grade) {
                            eq('grade', para.grade)
                        }
                        //先以商户编号为准
                        if (params.batchBizid) {
                            like("customerNo", "%" + params.batchBizid + "%")
                        } else {
                            //如果没有输入商户编号，而输入的是商户名称
                            if (params.batchBizname) {
                                ilike("name", "%" + params.batchBizname + "%")
                            }
                        }
                    }

                    def custmers = CmCorporationInfo.createCriteria().list(para, que)
                    def customerNos = []
                    custmers?.each { customer ->
                        customerNos << customer.customerNo
                    }
                    if (customerNos.size() > 0) {
                        println "wrwerwerwerwer--------------"
                        'in'("batchBizid", customerNos)
                    } else {
                        render(view: "transactionList", model: [tbAgentpayDetailsInfoInstanceList: null, tbAgentpayDetailsInfoInstanceTotal: 0, bankNameList: null, totalAmount: 0, totalFee: 0, params: params, flag: 0])

                        return
                    }
                } else {
                    render(view: "transactionList", model: [tbAgentpayDetailsInfoInstanceList: null, tbAgentpayDetailsInfoInstanceTotal: 0, bankNameList: null, totalAmount: 0, totalFee: 0, params: params, flag: -2])
                    return
                }
            }
            //guonan update 2011-12-29
            validDated(params)

            //商户提交时间 tradeSubdate
            if (params.tradeSubdateStart) {
                gt("tradeSubdate", Date.parse("yyyy-MM-dd", params.tradeSubdateStart))
            }
            if (params.tradeSubdateEnd) {
                lt("tradeSubdate", Date.parse("yyyy-MM-dd", params.tradeSubdateEnd) + 1)
            }

            if (params.startTime) {
                gt("tradeCommdate", Date.parse("yyyy-MM-dd", params.startTime))
            }
            if (params.endTime) {
                lt("tradeCommdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
            }
            //业管审核时间 tradeSyschkdate
            if (params.tradeSyschkdateStart) {
                gt("tradeSyschkdate", Date.parse("yyyy-MM-dd", params.tradeSyschkdateStart))
            }
            if (params.tradeSyschkdateEnd) {
                lt("tradeSyschkdate", Date.parse("yyyy-MM-dd", params.tradeSyschkdateEnd) + 1)
            }
            //交易完毕时间  tradeDonedate
            if (params.tradeDonedateStart) {
                gt("tradeDonedate", Date.parse("yyyy-MM-dd", params.tradeDonedateStart))
            }
            if (params.tradeDonedateEnd) {
                lt("tradeDonedate", Date.parse("yyyy-MM-dd", params.tradeDonedateEnd) + 1)
            }
            if (!params.saleType) {
                //先以商户编号为准
                if (params.batchBizid) {
                    like("batchBizid","%" + params.batchBizid+ "%")
                } else {
                    //如果没有输入商户编号，而输入的是商户名称
                    if (params.batchBizname) {
                        def cmCustomer = CmCustomer.createCriteria().list {
                            ilike("name", "%" + params.batchBizname + "%")
                        }
                        if (cmCustomer.size() > 0) {
                            'in'("batchBizid", cmCustomer.customerNo)
                        }else{
                            //如果没有此商户
                            eq("batchBizid",params.batchBizname)
                        }
                    } else {
                        //如果刚进入页面指定假的查询条件，快速反应页面
                        //eq("batchBizid","100000000000469")
                    }
                }
            }
            if (params.tradeType && params.tradeType != "-1") {
                eq("tradeType", params.tradeType)
            }
            //证件号码
            if (params.certificateNum) {
                like("certificateNum", "%" + params.certificateNum + "%")
            }
            if (params.contractUsercode) {
                like("contractUsercode", "%" + params.contractUsercode + "%")
            }


            if (params.tradeCardname) {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum) {
                eq("tradeCardnum", params.tradeCardnum)
            }
            if (params.tradeAccountname != null && params.tradeAccountname != "") {
                //拼接字符串
                // BoBankDic bankDic= BoBankDic.get(params.tradeAccountname as long)
                //eq("tradeAccountname",bankDic.name)
                // def  tradeAccountnameStr = TbAdjustBankCard.executeQuery();
                def bankNames = findTradeAccountnames(params.tradeAccountname);
                //println  bankNames;
                'in'("tradeAccountname", bankNames);
            }
            if (params.tradeAccounttype) {
                eq("tradeAccounttype", params.tradeAccounttype)
            }
            if (params.batchId) {

                eq("batch", TbAgentpayInfo.get(params.batchId))
            }
            if (params.id) {
                eq("id", params.id)
            }
            /*if(params.tradeFeestyle!="-1" && params.tradeFeestyle!=null){
                if(params.tradeFeestyle=="T")
                   eq("tradeFeestyle",params.tradeFeestyle)
                else
                   isNull("tradeFeestyle")
            }*/
            if (params.tradeFeedbackcode && params.tradeFeedbackcode != '0') {
                eq("tradeFeedbackcode", params.tradeFeedbackcode);
            }
            /*if(params.tradeRemark2!="" && params.tradeRemark2!=null){
                like("tradeRemark2","%"+params.tradeRemark2+"%")
            }*/
            if (params.batchStatus && params.batchStatus != "-1") {
                "in"("tradeStatus", params.batchStatus)
            }
            if (params.tradeRefued && params.tradeRefued != "-1") {
                eq("tradeRefued", params.tradeRefued)
            }
            // order("id","desc")
        }
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)

        def summary = TbAgentpayDetailsInfo.createCriteria().get {
            and query
//            eq('tradeType', 'payment')
            projections {
                sum('tradeAmount')
                rowCount()
                sum('tradeFee')
            }
        }
        /*def total =   TbAgentpayDetailsInfo.createCriteria().count(query)
        def summ = TbAgentpayDetailsInfo.createCriteria().get {
            and query
            projections {
                sum('tradeAmount')
            }
        }
        def totalFee =0
        def results2 = TbAgentpayDetailsInfo.createCriteria().list{
            and query
        }
        for(def r in results2){
            if(r!=null){
                if(r.tradeType=='F'){
                   totalFee =totalFee + r.tradeFee
                }
            }
        }*/
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: summary[1], bankNameList: bankListNew(), totalAmount: summary[0], totalFee: summary[2], params: params,flag:0]
    }

    def listDownload = {
        params.max = 10000000
        params.offset = 0
        def query =
        {
            //guonan update 2012-06-27
            if (params.saleType == 'sale') {
                def account = session.op.account
                def operator = BoOperator.findByAccount(account)
                println "and s.belongToSale = ${operator.name}"
                if ((operator.name != null && operator.name != "") || operator.role.roleName == "admin") {
                    def para = [:]
                    para['belongToSale'] = operator.name
                    para['belongToBusiness'] = params.belongToBusiness
                    para['grade'] = params.grade
                    def que = {
                        if (operator.name && operator.role.roleName != "admin") {
                            eq('belongToSale', para.belongToSale)
                        }
                        if (params.belongToBusiness) {
                            ilike('belongToBusiness', '%' + para.belongToBusiness + '%')
                        }
                        if (params.grade) {
                            eq('grade', para.grade)
                        }
                        //先以商户编号为准
                        if (params.batchBizid) {
                            like("customerNo", "%" + params.batchBizid + "%")
                        } else {
                            //如果没有输入商户编号，而输入的是商户名称
                            if (params.batchBizname) {
                                ilike("name", "%" + params.batchBizname + "%")
                            }
                        }
                    }

                    def custmers = CmCorporationInfo.createCriteria().list(para, que)
                    def customerNos = []
                    custmers?.each { customer ->
                        customerNos << customer.customerNo
                    }
                    if (customerNos.size() > 0) {
                        println "wrwerwerwerwer--------------"
                        'in'("batchBizid", customerNos)
                    } else {
                        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
                        response.setHeader("Content-disposition", "attachment; filename=" + filename)
                        response.contentType = "application/x-rarx-rar-compressed"
                        response.setCharacterEncoding("UTF-8")
                        render(template: "transactionList", model: [tbAgentpayDetailsInfoInstanceList: null, totalAmount: 0, total: 0, totalFee: 0, flag: 0])
                        return
                    }
                } else {
                    flash.message = "没有可下载内容"
                    render(view: "transactionList", model: [tbAgentpayDetailsInfoInstanceList: null, tbAgentpayDetailsInfoInstanceTotal: 0, bankNameList: null, totalAmount: 0, totalFee: 0, params: params, flag: -2])
                    return
                }
            }
            validDated(params)
            //商户提交时间 tradeSubdate
            if (params.tradeSubdateStart) {
                gt("tradeSubdate", Date.parse("yyyy-MM-dd", params.tradeSubdateStart))
            }
            if (params.tradeSubdateEnd) {
                lt("tradeSubdate", Date.parse("yyyy-MM-dd", params.tradeSubdateEnd) + 1)
            }
            if (params.startTime) {
                gt("tradeCommdate", Date.parse("yyyy-MM-dd", params.startTime))
            }
            if (params.endTime) {
                lt("tradeCommdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
            }
            //业管审核时间 tradeSyschkdate
            if (params.tradeSyschkdateStart) {
                gt("tradeSyschkdate", Date.parse("yyyy-MM-dd", params.tradeSyschkdateStart))
            }
            if (params.tradeSyschkdateEnd) {
                lt("tradeSyschkdate", Date.parse("yyyy-MM-dd", params.tradeSyschkdateEnd) + 1)
            }
            //交易完毕时间  tradeDonedate
            if (params.tradeDonedateStart) {
                gt("tradeDonedate", Date.parse("yyyy-MM-dd", params.tradeDonedateStart))
            }
            if (params.tradeDonedateEnd) {
                lt("tradeDonedate", Date.parse("yyyy-MM-dd", params.tradeDonedateEnd) + 1)
            }
            if (!params.saleType) {
            //先以商户编号为准
            if (params.batchBizid) {
                like("batchBizid","%" +  params.batchBizid+ "%")
            } else {
                //如果没有输入商户编号，而输入的是商户名称
                if (params.batchBizname) {
                    def cmCustomer = CmCustomer.createCriteria().list {
                        ilike("name", "%" + params.batchBizname + "%")
                    }
                    if (cmCustomer.size() > 0) {
                        'in'("batchBizid", cmCustomer.customerNo)
                    }else{
                            //如果没有此商户
                            eq("batchBizid",params.batchBizname)
                        }
                } else {
                    //如果刚进入页面指定假的查询条件，快速反应页面
                    //eq("batchBizid","100000000000469")
                }
            }
            }
            if (params.tradeType && params.tradeType != "-1") {
                eq("tradeType", params.tradeType)
            }
            //证件号码
            if (params.certificateNum) {
                like("certificateNum", "%" + params.certificateNum + "%")
            }
            if (params.contractUsercode) {
                like("contractUsercode", "%" + params.contractUsercode + "%")
            }


            if (params.tradeCardname) {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum) {
                eq("tradeCardnum", params.tradeCardnum)
            }
            if (params.tradeAccountname != null && params.tradeAccountname != "") {
                //拼接字符串
                // BoBankDic bankDic= BoBankDic.get(params.tradeAccountname as long)
                //eq("tradeAccountname",bankDic.name)
                // def  tradeAccountnameStr = TbAdjustBankCard.executeQuery();
                def bankNames = findTradeAccountnames(params.tradeAccountname);
                //println  bankNames;
                'in'("tradeAccountname", bankNames);
            }
            if (params.tradeAccounttype) {
                eq("tradeAccounttype", params.tradeAccounttype)
            }
            if (params.batchId) {
                eq("dkPcNo", params.batchId)
            }
            if (params.id) {
                eq("id", params.id)
            }
            /*if(params.tradeFeestyle!="-1" && params.tradeFeestyle!=null){
                if(params.tradeFeestyle=="T")
                   eq("tradeFeestyle",params.tradeFeestyle)
                else
                   isNull("tradeFeestyle")
            }*/
            if (params.tradeFeedbackcode && params.tradeFeedbackcode != '0') {
                eq("tradeFeedbackcode", params.tradeFeedbackcode == '1' ? "成功" : "失败");
            }
            /*if(params.tradeRemark2!="" && params.tradeRemark2!=null){
                like("tradeRemark2","%"+params.tradeRemark2+"%")
            }*/
            if (params.batchStatus && params.batchStatus != "-1") {
                "in"("tradeStatus", params.batchStatus)
            }
            order("id", "desc")
        }
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        //def total =   TbAgentpayDetailsInfo.createCriteria().count(query)

        def summary = TbAgentpayDetailsInfo.createCriteria().get {
            and query
//            eq('tradeType', 'payment')
            projections {
                sum('tradeAmount')
                rowCount()
                sum('tradeFee')
            }
        }

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "transactionList", model: [tbAgentpayDetailsInfoInstanceList: results, totalAmount: summary[0], total: summary[1], totalFee: summary[2],flag:0])
    }

    /**
     * 交易明细下载
     */
    def downTrades = {
        try{
            params.max = 50000 //最多5万条
            params.offset = 0
            params.sort = params.sort ? params.sort : "id"
            params.order = params.order ? params.order : "desc"
            //initParams(params)

            def res = agentService.queryTradesDetail(params)
            def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.contentType = "application/vnd.ms-excel"
            response.setCharacterEncoding("UTF-8")
            def wb = agentDownloadForExcelService.exportTrades(request,res.resList as List,Integer.parseInt(res.totalCount==null?'0':res.totalCount.toString()),BigDecimal.valueOf(Double.valueOf(res.totalMoney==null?'0':res.totalMoney.toString())),BigDecimal.valueOf(Double.valueOf(res.totalFee==null?'0':res.totalFee.toString())),params.tradeType)
            wb.write(response.outputStream)

            response.outputStream.close()
        }catch (Throwable e){
            log.error("交易明细下载异常",e)
        }
    }
     /**
     * 交易明细下载 CSV
     */
    def downTradesCSV = {
        try{
            params.max = 50000 //最多5万条
            params.offset = 0
            params.sort = params.sort ? params.sort : "id"
            params.order = params.order ? params.order : "desc"
            def res = agentService.queryTradesDetail(params)
            def filename = 'csv-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.csv'
            response.contentType = "text/csv"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            String tlpt="transactionList_csv"
            render(template: tlpt, model: [tbAgentpayDetailsInfoInstanceList:res.resList,
                    totalCount:res.totalCount,totalMoney:res.totalMoney,totalFee:BigDecimal.valueOf(Double.valueOf(res.totalFee==null?'0':res.totalFee.toString()))])
        }catch (Throwable e){
            log.error("交易明细下载异常",e)
        }
    }



    def dklist1 = {    //打款   初审
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.sort = params.sort ? params.sort : "tradeCommdate"
        params.order = params.order ? params.order : "desc"
        def query = {

            eq('tradeStatus', '2')
            // eq('payStatus', '0')
            eq('tradeType', 'F')
            //只显示手工审核的数据
            eq('tradeSystype','1')
//            if (params.startTime) {
//                ge("tradeCommdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeCommdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }
            //guonan update 2011-12-29
            validDated(params)
            //商户的审核时间
            if (params.startTime) {
                ge('tradeCommdate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
                lt('tradeCommdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }

            if (params.batchBizid != null && params.batchBizid != "") {
                eq("batchBizid", params.batchBizid)
            }
            // if (params.tradeType != "" && params.tradeType != null) {//类型
            //     eq('tradeType', params.tradeType)
            //  }
            if (params.tradeStyle != "" && params.tradeStyle != null) { //业务类型
                eq('tradeType', params.tradeStyle)
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                eq("tradeCardnum", params.tradeCardnum)
            }

            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }

            if (params.bankName != null && params.bankName != "") {
                def bankNames = findTradeAccountnames(params.bankName);
                //println  bankNames;
                'in'("tradeAccountname", bankNames);
            }

            /*if (params.bankName != null && params.bankName != "") {
                def bank = BoBankDic.get((params.bankName) as long)
                eq("tradeAccountname", bank.name)
            }*/
        }

        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)

        def summary = TbAgentpayDetailsInfo.createCriteria().get {
            and query
//            eq('tradeType', 'payment')
            projections {
                sum('tradeAmount')
                rowCount()
                sum('tradeFee')
                sum('tradeAccamount')
            }
        }

        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: summary[1], bankNameList: bankListNew(), totalMoney: summary[0], totalFee: summary[2], totalAccMoney: summary[3], params: params]
    }

    def dklist={

        def dbdsf =  new groovy.sql.Sql(dataSource_dsf)
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def listStart = params.offset
        def listTo = listStart + params.max

             validDated(params)

           def condition = ""

            if (params.batchBizid != null && params.batchBizid != "") {
                condition = condition + " and t.batch_Bizid = '" + params.batchBizid + "'"
            }
            // if (params.tradeType != "" && params.tradeType != null) {//类型
            //     eq('tradeType', params.tradeType)
            //  }
            if (params.tradeStyle != "" && params.tradeStyle != null) { //业务类型
                condition = condition + " and t.trade_Type = '" + params.tradeStyle + "'"
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                condition = condition + " and t.trade_Cardname like '%" + params.tradeCardname + "%'"
            }
            if (params.name != null && params.name != "") {
                condition = condition + " and cm.name like '%" + params.name + "%'"
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                condition = condition + " and t.trade_Cardnum = '" + params.tradeCardnum + "'"
            }

            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                condition = condition + " and t.trade_Accounttype = '" + params.tradeAccounttype + "'"
            }

            if (params.bankName != null && params.bankName != "") {
                def bankNames = findTradeAccountnames(params.bankName);
                if(bankNames!=null&&bankNames.size()>0){
                    condition = condition + " and t.trade_Accountname in("
                       for(int i=0;i<bankNames.size();i++){
                               condition = condition + "'" +bankNames[i] +"',"
                       }
                    condition = condition.substring(0,condition.size()-1)
                     condition =condition +")"
                }
                //println  bankNames;
            }

             def channelSql = """
                        select t.*,cm.name name
                        from tb_agentpay_details_info t ,ismp.cm_customer cm
                        where t.trade_status = '2'
                        and t.trade_type='F'
                        and t.trade_systype='1'
                        and t.batch_bizid = cm.customer_no(+)
                        and    to_char(t.trade_commdate, 'yyyy-mm-dd') >= '""" + params.startTime + """'
                        and    to_char(t.trade_commdate, 'yyyy-mm-dd') <= '""" + params.endTime + """'"""+condition+"""
               """
        println       channelSql

        def str = "select t.* from (select t.*, rownum rn from (" + channelSql + ") t) t where t.rn > " + listStart + " and t.rn <= " + listTo

        println      "===============:"+str

        def outAndInList = dbdsf.rows("select t.* from (select t.*, rownum rn from (" + channelSql + ") t) t where t.rn > " + listStart + " and t.rn <= " + listTo)
        def count = dbdsf.rows("select count(*) as count from (" + channelSql + ")")[0][0]
        def tradeAmount = dbdsf.rows("select sum(t.trade_amount)  sumamount from ("+channelSql+") t ")[0][0];
        def feeAmount = dbdsf.rows("select sum(t.trade_fee)  sumamount from ("+channelSql+") t ")[0][0];
        def accAmount = dbdsf.rows("select sum(t.trade_accamount)  sumamount from ("+channelSql+") t ")[0][0];

        [tbAgentpayDetailsInfoInstanceList:outAndInList,tbAgentpayDetailsInfoInstanceTotal: count, bankNameList: bankListNew(), totalMoney: tradeAmount, totalFee:feeAmount, totalAccMoney: accAmount, params: params]


    }

    def sklist = {  //收款   初审
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.sort = params.sort ? params.sort : "tradeCommdate"
        params.order = params.order ? params.order : "desc"
        def query = {

            eq('tradeStatus', '2')
            //只显示手工审核的数据
            eq('tradeSystype','1')
            eq('tradeType', 'S')
//            if (params.startTime) {
//                ge("tradeCommdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeCommdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }
            //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
                ge('tradeCommdate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
                lt('tradeCommdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }

            if (params.batchBizid != null && params.batchBizid != "") {
                eq("batchBizid", params.batchBizid)
            }
            // if (params.tradeType != "" && params.tradeType != null) {//类型
            //     eq('tradeType', params.tradeType)
            // }
            if (params.tradeStyle != "" && params.tradeStyle != null) { //业务类型
                eq('tradeType', params.tradeStyle)
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                eq("tradeCardnum", params.tradeCardnum)
            }

            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }
            if (params.bankName != null && params.bankName != "") {
                def bankNames = findTradeAccountnames(params.bankName);
                //println  bankNames;
                'in'("tradeAccountname", bankNames);
            }
        }



        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        def summary = TbAgentpayDetailsInfo.createCriteria().get {
            and query
//            eq('tradeType', 'payment')
            projections {
                sum('tradeAmount')
                rowCount()
                sum('tradeFee')
                sum('tradeAccamount')
            }
        }

        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: summary[1], bankNameList: bankListNew(), totalMoney: summary[0], totalFee: summary[2], totalAccMoney: summary[3]]
    }
    def reFcheckPage = {            //查询待退款的所有明细
         params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        params.sort = params.sort ? params.sort : "tradeDonedate"
        params.order = params.order ? params.order : "desc"
        def query = {
            eq("tradeRefued", "0")
//            if (params.startTime) {
//                ge("tradeCommdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeCommdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }

            //guonan update 2011-12-29
            validDated(params)
            //查询对账时间
            if (params.startTime) {
                ge('tradeDonedate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
                lt('tradeDonedate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }


            if (params.batchBizid != null && params.batchBizid != "") {
                eq("batchBizid", params.batchBizid)
            }
            if (params.tradeType != "" && params.tradeType != null) {
                eq('tradeType', params.tradeType)
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                eq("tradeCardnum", params.tradeCardnum)
            }
            if (params.tradeAccountname != null && params.tradeAccountname != "") {
                eq("tradeAccountname", params.tradeAccountname)
            }
            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }

            if (params.id != null && params.id != "") {
                eq("batch", TbAgentpayInfo.get(params.id))
            }
            if (params.bankNameSearch != null && params.bankNameSearch != "") {
                eq("tradeAccountname", BoBankDic.get(params.bankNameSearch).name)
            }

            if (params.tbPcDkChanel != null && params.tbPcDkChanel != "") {
                def list = TbPcInfo.findAllByTbPcDkChanel(params.tbPcDkChanel)
                if (list != null && list.size() > 0) {
                    def ids = new String[list.size()]
                    def i = 0
                    list.each {
                        ids[i] = it.id
                        i++
                    }

                    'in'("dkPcNo", ids)
                } else {
                    isNull("id")
                }
            }

            if (params.bankNames != null && params.bankNames != "") {
                def bankNames = findTradeAccountnames(params.bankNames);
                //println  bankNames;
                'in'("tradeAccountname", bankNames);
            }

        }
        def summ = TbAgentpayDetailsInfo.createCriteria().get {
            and query
            projections {
                sum('tradeAmount')
                sum('tradeFee')
                rowCount()
            }
        }
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: summ[2], bankNameList: bankListNew(), bankChanelList: bankChanelList('F'), totalAmount: summ[0], totalFee: summ[1]]
    }
    def reTcheckPage = {
        params.sort = params.sort ? params.sort : "tradeDonedate"
        params.order = params.order ? params.order : "desc"
        def query = {
            //查询退款已经初审的
            eq("tradeRefued", "1")
//            if (params.startTime) {
//                ge("tradeCommdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeCommdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }

            //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
                ge('tradeDonedate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
                lt('tradeDonedate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }

            if (params.batchBizid != null && params.batchBizid != "") {
                eq("batchBizid", params.batchBizid)
            }
            if (params.tradeType != "" && params.tradeType != null) {
                eq('tradeType', params.tradeType)
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                eq("tradeCardnum", params.tradeCardnum)
            }
            if (params.tradeAccountname != null && params.tradeAccountname != "") {
                eq("tradeAccountname", params.tradeAccountname)
            }
            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }


            if (params.id != null && params.id != "") {
                eq("batch", TbAgentpayInfo.get(params.id))
            }
            if (params.bankNameSearch != null && params.bankNameSearch != "") {
                eq("tradeAccountname", BoBankDic.get(params.bankNameSearch).name)
            }
            if (params.tbPcDkChanel != null && params.tbPcDkChanel != "") {
                def list = TbPcInfo.findAllByTbPcDkChanel(params.tbPcDkChanel)
                if (list != null && list.size() > 0) {
                    def ids = new String[list.size()]
                    def i = 0
                    list.each {
                        ids[i] = it.id
                        i++
                    }

                    'in'("dkPcNo", ids)
                } else {
                    isNull("id")
                }
            }

            if (params.bankNames != null && params.bankNames != "") {
                def bankNames = findTradeAccountnames(params.bankNames);
                //println  bankNames;
                'in'("tradeAccountname", bankNames);
            }
        }
        def summ = TbAgentpayDetailsInfo.createCriteria().get {
            and query
            projections {
                sum('tradeAmount')
                sum('tradeFee')
                rowCount()
            }
        }
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        // def total = TbAgentpayDetailsInfo.createCriteria().count(query)
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: summ[2], bankNameList: bankListNew(), bankChanelList: bankChanelList('F'), totalAmount: summ[0], totalFee: summ[1]]
    }
    /**
     * 审核通过
     */
    def frTrialPass = {

        String name = session.op.name
        def ids = "";
        def ref
        int updateCount;
        if (params.allCheck == "true") {       //全部选中通过页面条件进行更新
            /* def results = allChecked(params.flag)
            results.each {
                ids+=it.id+","
            }
            if(ids){
            ids = ids.substring(0, ids.length() - 1);
            }*/
            StringBuffer sb = new StringBuffer();
            sb.append(" update TbAgentpayDetailsInfo t set tradeSyschkname='" + name + "',tradeSyschkdate = sysdate , tradeStatus = '5'   where 1=1 ");
            sb.append(" and tradeStatus = 2");
            sb.append(" and tradeType = '" + params.flag + "'");
            if (params.startTime) {
                sb.append(" and tradeCommdate >= to_date('" + params.startTime + "','yyyy-MM-dd')");
            }
            if (params.endTime) {
                sb.append(" and tradeCommdate <= to_date('" + (Date.parse("yyyy-MM-dd", params.endTime) + 1).format("yyyy-MM-dd") + "','yyyy-MM-dd')");
            }
            if (params.batchBizid != null && params.batchBizid != "") {
                sb.append(" and batchBizid = " + params.batchBizid);
            }
            if (params.tradeType != "" && params.tradeType != null) {//类型
                sb.append(" and tradeType = '" + params.tradeType + "'");
            }
            if (params.tradeStyle != "" && params.tradeStyle != null) { //业务类型
                sb.append(" and tradeType = '" + params.tradeStyle + "'");
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                sb.append(" and tradeCardname like '%" + params.tradeCardname + "%'");
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                sb.append(" and tradeCardnum = " + params.tradeCardnum);
            }
            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                sb.append(" and tradeAccounttype = '" + params.tradeAccounttype + "'");
            }
            if (params.bankName != null && params.bankName != "") {
                /*def bankNames =  findTradeAccountnames(params.bankName);
                 //println  bankNames;
                'in'("tradeAccountname",bankNames);*/
                sb.append(" and tradeAccountname in ( " + findTradeAccountnamesForStr(params.bankName) + " )");
            }
            /*Map updateMap = new HashMap();
            updateMap.put("tradeSyschkname",name);
            updateMap.put("tradeSyschkdate",new Date());
            updateMap.put("tradeStatus","5");*/
            updateCount = TbAgentpayDetailsInfo.executeUpdate(sb.toString());
        } else {
                 //部分选中
                ids = params.ids.substring(0, params.ids.length() - 1)
                updateCount = TbAgentpayDetailsInfo.executeUpdate("update TbAgentpayDetailsInfo t set tradeSyschkname='" + name + "',tradeSyschkdate = sysdate , tradeStatus = '5'   where t.id in (" + ids + ")")

        }

        /* ref=entrustService.opensysverify(ids,params.flag,"pass",name)
        if(ref.result == 'true'){
               println '审核成功!'
               flash.message = '审核成功！'
               log.info"对以下数据审核成功:"+ids
        }else if(ref.result == 'false'){
               println '审核失败！'
               flash.message = '审核失败！'
               flash.message=ref.errorMsg
               log.info"对以下数据审核失败,请重试:"+ids
        }*/
        if (updateCount > 0) {
            println '审核成功!'
            flash.message = '审核成功！'
            log.info "对以下数据审核成功:" + ids
        } else {
            println '审核失败！'
            flash.message = '审核失败！'
            log.info "对以下数据审核失败,请重试:" + ids
        }
        if (params.flag == 'F') {
            // params.action = "dklist";
            //redirect(action: "dklist",params:params)
            redirect(action: "dklist")
        } else {
            redirect(action: "sklist")
        }
    }

    def allChecked(String type) {
        def query = {
            eq('tradeStatus', '2')
            eq('tradeType', type)
            if (params.startTime) {
                ge("tradeCommdate", Date.parse("yyyy-MM-dd", params.startTime))
            }
            if (params.endTime) {
                le("tradeCommdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
            }
            if (params.batchBizid != null && params.batchBizid != "") {
                eq("batchBizid", params.batchBizid)
            }
            if (params.tradeType != "" && params.tradeType != null) {//类型
                eq('tradeType', params.tradeType)
            }
            if (params.tradeStyle != "" && params.tradeStyle != null) { //业务类型
                eq('tradeType', params.tradeStyle)
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                eq("tradeCardnum", params.tradeCardnum)
            }

            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }
            if (params.bankName != null && params.bankName != "") {
                def bankNames = findTradeAccountnames(params.bankName);
                //println  bankNames;
                'in'("tradeAccountname", bankNames);
            }
        }
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        return results
    }

    //审核拒绝      refuse
    def frTrialRefuse = {
        def name = session.op.name
        def ref
        try {
            def ids
            if (params.allCheck == "true") {
                def results = allChecked(params.flag)
                results.each {
                    ids = it.id + ","
                }
                ids = ids.substring(0, ids.length() - 1)
            }
            else {
                ids = params.ids.substring(0, params.ids.length() - 1)
            }
            ref = entrustService.opensysverify(ids, params.flag, "refuse", name)
            if (ref.result == 'true') {
                println '审核拒绝成功!'
                flash.message = '审核拒绝成功！'
                log.info "对以下数据审核拒绝成功:" + ids
            } else if (ref.result == 'false') {
                println '审核拒绝失败！'
                flash.message = '审核拒绝失败！'
                flash.message = ref.errorMsg
                log.info "对以下数据审核拒绝失败,请重试:" + ids
            }
            //int updateCount = TbAgentpayDetailsInfo.executeUpdate("update TbAgentpayDetailsInfo t set t.payStatus='2',t.tradeStatus='2',t.tradeFeedbackcode='失败',t.tradeReason='拒绝',fcheckName='"+name+"'  where t.id in (" + ids + ")")
            //for (int i = 0; i < id.size(); i++) {
            //    TbAgentpayDetailsInfo tbAgentpayDetailsInfoInstance = TbAgentpayDetailsInfo.get(String.valueOf(id[i]))
            //    fDealAccount(tbAgentpayDetailsInfoInstance)
            //}

        } catch (Exception e) {
            //roll back
            log.warn(e.message, e)
            flash.message = e.message
            if (params.flag == 'F') {
                redirect(action: "dklist")
            } else {
                redirect(action: "sklist")
            }
            return
        }
        if (params.flag == 'F') {
            redirect(action: "dklist")
        }
        else {
            redirect(action: "sklist")
        }


    }
    /**
     * 拒绝退款记账
     * @param tbAgentpayDetailsInfoTemp
     * @return
     */
    def fDealAccount(TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp) throws Exception {

        def sysFeeAccNo = BoInnerAccount.findByKey('feeAcc').accountNo//平台手续费账户
        def sysFeeInAdvAccNo = BoInnerAccount.findByKey('feeInAdvance').accountNo//系统应收手续费账号
        CmCustomer cmCustomer = CmCustomer.findByCustomerNo(tbAgentpayDetailsInfoTemp.getBatchBizid())
        def billAccountNo = cmCustomer.accountNo//商户现金账户
        BoCustomerService boCustomerService = new BoCustomerService()
        boCustomerService.customerId = cmCustomer.id
        //boCustomerService.serviceCode = "agentpay"
        def type = tbAgentpayDetailsInfoTemp.tradeType
        if (type == 'S') {
            boCustomerService.serviceCode = "agentcoll"
        } else if (type == 'F') {
            boCustomerService.serviceCode = "agentpay"
        }
        boCustomerService = BoCustomerService.find(boCustomerService)
        def serverAccountNo = boCustomerService.srvAccNo //商户服务账户
        def feeInAdvAccNo = boCustomerService.feeAccNo

        if (tbAgentpayDetailsInfoTemp.tradeFeetype == "0") {//即扣的

            if (type == 'F') {
                def cmdList = accountClientService.buildTransfer(null, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeAmount as BigDecimal) * 100) as Integer, 'agentpay', tbAgentpayDetailsInfoTemp.id, '0', " 代付退款记账")
                if ((tbAgentpayDetailsInfoTemp.tradeFee * 100) as Integer != 0) {
                    // if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {
                    cmdList = accountClientService.buildTransfer(cmdList, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代付退手续费记账")
                    /* } else {
                        cmdList = accountClientService.buildTransfer(cmdList, serverAccountNo, sysFeeAccNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代付退手续费记账")
                    }*/
                }

                def transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
                if ((transResult.result == 'true')) {
                    print "成功"
                } else {
                    throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                    print "失败"
                }
            }/*else if(type == 'S'){
                def cmdList = null
                if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {
                    cmdList = accountClientService.buildTransfer(null, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代收退手续费记账")
                } else {
                    cmdList = accountClientService.buildTransfer(null, serverAccountNo, sysFeeAccNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代收退手续费记账")
                }
                def transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
                if ((transResult.result == 'true')) {
                    print "成功"
                } else {
                    throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                    print "失败"
                }
            }*/
        }
        else if (tbAgentpayDetailsInfoTemp.tradeFeetype == "1") {  //后返的

            def cmdList = null
            if (tbAgentpayDetailsInfoTemp.tradeType == 'F') {
                cmdList = accountClientService.buildTransfer(null, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeAmount as BigDecimal) * 100) as Integer, 'agentpay', tbAgentpayDetailsInfoTemp.id, '0', "代付退款记账")
                if ((tbAgentpayDetailsInfoTemp.tradeFee * 100) as Integer != 0) {
                    // if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {  // 若退手续费刚下,若不退,则不动了
                    cmdList = accountClientService.buildTransfer(cmdList, sysFeeInAdvAccNo, feeInAdvAccNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代付退手续费记账")
                    //  }
                }


                def transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
                if (transResult.result == 'true') {
                    print "成功" + "==================="
                } else {
                    throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                }
            }/*else if(tbAgentpayDetailsInfoTemp.tradeType=='S'){
                def transResult
                if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {  // 若退手续费刚下,若不退,则不动了
                    cmdList = accountClientService.buildTransfer(null, sysFeeInAdvAccNo, feeInAdvAccNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代收退手续费记账")
                     transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
                     if (transResult.result == 'true') {
                    print "成功" + "==================="
                } else {
                    throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                }
                }


            }*/

        }

    }

    def reFcheck = {
        def ids = params.ids.substring(0, params.ids.length() - 1)
        def name = session.op.name
        int updateCount = TbAgentpayDetailsInfo.executeUpdate("update TbAgentpayDetailsInfo t set t.tradeRefued='1',refundFirstname='" + name + "' where t.id in (" + ids + ")")
        if (updateCount > 0) {
            flash.message = "退款初审成功" + updateCount + "条记录"
        }
        redirect(action: "reFcheckPage",params:params)
    }
     def reTcheck = {

        def name = session.op.name
        def ref;
        try {
            def ids = params.ids.substring(0, params.ids.length() - 1)
            log.error("退款终审发送HTTP请求，交易ID：" + ids + "操作员" + name);
            //调用委托结算
            ref = entrustService.refuseCheckForEntrust(ids, name);
            log.error("退款终审发送HTTP请求，交易ID：" + ids + "操作员" + name + ",返回成功，返回内容：" + ref.toString());
            if (ref.result == 'true') {

                flash.message = '退款终审成功！'
                log.info "对以下数据退款终审成功:" + ids
            } else if (ref.result == 'false') {

                flash.message = '退款终审失败！' + ref.errorMsg
                log.info "对以下数据退款终审失败,请重试:" + ids
            }

        } catch (HttpHostConnectException e1) {
            log.error(e1.message, e1)
            flash.message = '连接委托结算平台异常请联系管理员或稍后再试！' + e1.message
            redirect(action: "reTcheckPage")
            return
        } catch (java.lang.IllegalStateException e2) {
            log.error(e2.message, e2)
            flash.message = '连接委托结算平台正在处理中，请等待！'
            redirect(action: "reTcheckPage")
            return
        }  catch (Exception e) {
            log.error(e.message, e)
            flash.message = e.message
            redirect(action: "reTcheckPage")
            return
        }
        redirect(action: "reTcheckPage")

    }
    /**
     * 终审退款记账
     * @param tbAgentpayDetailsInfoTemp
     * @return
     */
    def refusefDealAccount(TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp) throws Exception {

        def sysFeeAccNo = BoInnerAccount.findByKey('feeAcc').accountNo//平台手续费账户
        def sysFeeInAdvAccNo = BoInnerAccount.findByKey('feeInAdvance').accountNo//系统应收手续费账号
        CmCustomer cmCustomer = CmCustomer.findByCustomerNo(tbAgentpayDetailsInfoTemp.getBatchBizid())
        def billAccountNo = cmCustomer.accountNo//商户现金账户
        BoCustomerService boCustomerService = new BoCustomerService()
        boCustomerService.customerId = cmCustomer.id
        //boCustomerService.serviceCode = "agentpay"
        def type = tbAgentpayDetailsInfoTemp.tradeType
        if (type == 'S') {
            boCustomerService.serviceCode = "agentcoll"
        } else if (type == 'F') {
            boCustomerService.serviceCode = "agentpay"
        }
        boCustomerService = BoCustomerService.find(boCustomerService)
        def serverAccountNo = boCustomerService.srvAccNo //商户服务账户
        def feeInAdvAccNo = boCustomerService.feeAccNo

        if (tbAgentpayDetailsInfoTemp.tradeFeetype == "0") {//即扣的

            if (type == 'F') {
                def cmdList = accountClientService.buildTransfer(null, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeAmount as BigDecimal) * 100) as Integer, 'agentpay', tbAgentpayDetailsInfoTemp.id, '0', " 代付退款记账")
                if ((tbAgentpayDetailsInfoTemp.tradeFee * 100) as Integer != 0) {
                    if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {
                        cmdList = accountClientService.buildTransfer(cmdList, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代付退手续费记账")
                    } else {
                        cmdList = accountClientService.buildTransfer(cmdList, serverAccountNo, sysFeeAccNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代付退手续费记账")
                    }
                }

                def transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
                if ((transResult.result == 'true')) {
                    print "成功"
                } else {
                    throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                    print "失败"
                }
            }
        }
        else if (tbAgentpayDetailsInfoTemp.tradeFeetype == "1") {  //后返的

            def cmdList = null
            if (tbAgentpayDetailsInfoTemp.tradeType == 'F') {
                cmdList = accountClientService.buildTransfer(null, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeAmount as BigDecimal) * 100) as Integer, 'agentpay', tbAgentpayDetailsInfoTemp.id, '0', "代付退款记账")
                if ((tbAgentpayDetailsInfoTemp.tradeFee * 100) as Integer != 0) {
                    if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {  // 若退手续费刚下,若不退,则不动了
                        cmdList = accountClientService.buildTransfer(cmdList, sysFeeInAdvAccNo, feeInAdvAccNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代付退手续费记账")
                    }
                }


                def transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
                if (transResult.result == 'true') {
                    print "成功" + "==================="
                } else {
                    throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                }
            }
        }

    }

    def bankChanelList(def flag) {
        TbBindBank tbBindBank = new TbBindBank()
        tbBindBank.dsfFlag = flag
        List list = TbBindBank.findAll(tbBindBank)
        List bankChanelList = new ArrayList()

        for (int i = 0; i < list.size(); i++) {

            String no = list.get(i).bankAccountno
            def boList = BoAcquirerAccount.findAll("from BoAcquirerAccount where bankAccountNo='" + no + "' and status='normal'")
            for (int j = 0; j < boList.size(); j++) {
                //boList.get(j).aliasName=boList.get(j).bank.name+"-"+boList.get(j).aliasName
                bankChanelList.add(boList.get(j))
            }
        }
        return bankChanelList
    }


    def bankChanelList(def flag, def id) {
        TbBindBank tbBindBank = new TbBindBank()
        tbBindBank.dsfFlag = flag
        List list = TbBindBank.findAll(tbBindBank)
        //BoAcquirerAccount boAcquirerAccount = new BoAcquirerAccount()
        List<BoAcquirerAccount> bankChanelList = new ArrayList<BoAcquirerAccount>()
        for (int i = 0; i < list.size(); i++) {
            String no = list.get(i).bankAccountno
            def boList = BoAcquirerAccount.executeQuery(" from BoAcquirerAccount where bank.id= " + id + " and bankAccountNo='" + no + "' and status='normal'")

            for (int j = 0; j < boList.size(); j++) {
//                BoAcquirerAccount boAcquirerAccount = new BoAcquirerAccount()
//                boAcquirerAccount.id = boList.get(j)[0]
//                boAcquirerAccount.aliasName = boList.get(j)[1]
                bankChanelList.add(boList.get(j))
            }
        }
        return bankChanelList
    }
}
