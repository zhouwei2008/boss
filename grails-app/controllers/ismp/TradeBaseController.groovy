package ismp

import ebank.tools.StringUtil
import gateway.GwOrder
import boss.BoOperator

class TradeBaseController {

    def index = {
        redirect(action: "list", params: params)
    }

    private List<List<TradePayment>> splitList(List<TradePayment> cmList) {
        int total = cmList.size()
        int len = 300
        int s = total / len
        int mode = total % len
        int size = s + (mode == 0 ? 0 : 1)
        int fInx = 0
        int tInx = 0
        List<List<TradePayment>> result = new ArrayList<List<TradePayment>>()
        for (int i = 0; i <= size; i++) {
            fInx = i * len
            tInx = (i + 1) * len >= total ? total : (i + 1) * len
            result.add(cmList.subList(fInx, tInx))
            if (tInx >= total) {
                break
            }
        }
        return result
    }

    def list = {
        def flag = 0
        def rootId
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        if (params.rootId != null && params.rootId != '') {
            flag = 1
            rootId = params.rootId
        }

        def query = {
            //guonan update 2012-02-17
            if (params.companyType == 'branch') {
                def account = session.op.account
                def operator = BoOperator.findByAccount(account)
                println "and s.branchCompany = ${operator.branchCompany}"
                if ((operator.branchCompany != null && operator.branchCompany != "") || operator.role.roleName == "admin") {
                    def para = [:]
                    para['branchCompany'] = operator.branchCompany
                    para['belongToBusiness'] = params.belongToBusiness
                    para['grade'] = params.grade
                    def que = {
                        if (operator.branchCompany && operator.branchCompany != "0") {
                            eq('branchCompany', para.branchCompany)
                        }
                        if (params.belongToBusiness) {
                            ilike('belongToBusiness', '%' + para.belongToBusiness + '%')
                        }
                        if (params.grade) {
                            eq('grade', para.grade)
                        }
                    }
                    def custmers = CmCorporationInfo.createCriteria().list(para, que)
                    def customerNos = []
                    custmers?.each { customer ->
                        customerNos << customer.customerNo
                    }
                    if (customerNos.size() > 0) {
                        or {
                            partner {
                                'in'('customerNo', customerNos)
                            }
                            payer {
                                'in'('customerNo', customerNos)
                            }
                            payee {
                                'in'('customerNo', customerNos)
                            }
                        }
                    } else {
                        render(view: "list", model: [tradeList: null, tradeTotal: 0, params: params, flag: flag, rootId: rootId, serviceType: params.serviceType, totalAmount: 0])
                        return
                    }
                } else {
                    flag = -1
                    render(view: "list", model: [tradeList: null, tradeTotal: 0, params: params, flag: flag, rootId: rootId, serviceType: params.serviceType, totalAmount: 0])
                    return
                }
            }
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
                    }
                    def custmers = CmCorporationInfo.createCriteria().list(para, que)
                    def customerNos = []
                    custmers?.each { customer ->
                        customerNos << customer.customerNo
                    }
                    if (customerNos.size() > 0) {
                        println "wrwerwerwerwer--------------"
                        or {
                            partner {
                                'in'('customerNo', customerNos)
                            }
                            payer {
                                'in'('customerNo', customerNos)
                            }
                            payee {
                                'in'('customerNo', customerNos)
                            }
                        }
                    } else {
                        render(view: "list", model: [tradeList: null, tradeTotal: 0, params: params, flag: flag, rootId: rootId, serviceType: params.serviceType, totalAmount: 0])
                        return
                    }
                } else {
                    flag = -2
                    render(view: "list", model: [tradeList: null, tradeTotal: 0, params: params, flag: flag, rootId: rootId, serviceType: params.serviceType, totalAmount: 0])
                    return
                }
            }
            //zhouwei update 2012-02-07 该字段在数据库中已经创建
//            if (params.serviceType != null && params.serviceType != '' && params.serviceType != '-1') {
//                def tradePayment
//                if (params.serviceType == 'royalty') {
//                    tradePayment = TradePayment.findAllByRoyaltyType('10')
//                } else if (params.serviceType == 'merge') {
//                    tradePayment = TradePayment.findAllByRoyaltyType('12')
//                } else {
//                    tradePayment = TradePayment.findAllByRoyaltyTypeIsNull()
//                }
//                if(tradePayment.size()>0){
//                    List<List<TradePayment>> subList =  splitList(tradePayment)
//                    or{
//                        for(List<TradePayment> sub : subList){
//                           'in'("id",sub.id)
//                        }
//                    }
//                }
////                'in'("id", tradePayment.id)
//            }
            def day = new Date()
            println day.time
            if (params.rootId != null && params.rootId != '') {
                eq('rootId', Long.parseLong(params.rootId.toString()))
            }
//            if (params.startTradeDate != null && params.startTradeDate != '') {
//                ge('tradeDate', Integer.parseInt(params.startTradeDate.toString()))
//            }else{
//                ge('tradeDate', Integer.parseInt((day-30).format('yyyyMMdd').toString()) )
//            }
//            if (params.endTradeDate != null && params.endTradeDate != '') {
//                le('tradeDate', Integer.parseInt(params.endTradeDate.toString()))
//            }else{
//                le('tradeDate', Integer.parseInt(day.format('yyyyMMdd').toString()))
//            }
//            if (params.startDateCreated != null && params.startDateCreated != '') {
//                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
//            }else{
//                ge('dateCreated', Date.parse('yyyy-MM-dd', (day-30).format('yyyy-MM-dd')))
//            }
//            if (params.endDateCreated != null && params.endDateCreated != '') {
//                le('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
//            }else{
//                le('dateCreated', Date.parse('yyyy-MM-dd', day.format('yyyy-MM-dd')) + 1)
//            }
//            if (params.startLastUpdated != null && params.startLastUpdated != '') {
//                ge('lastUpdated', Date.parse('yyyy-MM-dd', params.startLastUpdated))
//            }else{
//                ge('lastUpdated', Date.parse('yyyy-MM-dd', (day-30).format('yyyy-MM-dd')))
//            }
//            if (params.endLastUpdated != null && params.endLastUpdated != '') {
//                le('lastUpdated', Date.parse('yyyy-MM-dd', params.endLastUpdated) + 1)
//            }else{
//                le('lastUpdated', Date.parse('yyyy-MM-dd', day.format('yyyy-MM-dd')) + 1)
//            }

            //guonan update 2011-12-29
            //  validDated(params)

            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }

            //guonan update 2011-12-29

            //validLastDated(params)     //按照完成时间查询的验证
            //sunweiguo update 2012-06-05

            if (params.startLastUpdated) {
                ge('lastUpdated', Date.parse('yyyy-MM-dd', params.startLastUpdated))
            }
            if (params.endLastUpdated) {
                lt('lastUpdated', Date.parse('yyyy-MM-dd', params.endLastUpdated) + 1)
            }

            //guonan update 2011-12-29

            //
            if (flag != 1) {
                validTradeDated(params)
            }


            if (params.startTradeDate) {
                ge('tradeDate', Integer.parseInt(params.startTradeDate?.replace('-', '')))
            }
            if (params.endTradeDate) {
                le('tradeDate', Integer.parseInt(params.endTradeDate?.replace('-', '')))
            }

            //zhouwei update 2012-02-07
            if (params.serviceType != null && params.serviceType != '') {
                eq('serviceType', params.serviceType)
            }
            //zhouwei update 2012-02-07
            if (params.paymentType != null && params.paymentType != '') {
                eq('paymentType', params.paymentType)
            }
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.outTradeNo != null && params.outTradeNo != '') {
                like('outTradeNo', '%' + params.outTradeNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
            if (params.tradeType != null && params.tradeType != '') {
                eq('tradeType', params.tradeType)
            }

            //update sunweiguo 2012-06-05 页面关闭状态删除，当点击完成时一并把关闭状态的数据查出来
            if (params.status != null && params.status != '') {
                if (params.status != "completed") {
                    eq('status', params.status)
                }
                else {
                    'in'('status', ['completed', 'closed'])
                }
            }


            if (params.customerNo != null && params.customerNo != '') {
                partner { like('name', '%' + params.customerNo + '%') }
            }
            if (params.payerCustomerNo != null && params.payerCustomerNo != '') {
                like('payerName', '%' + params.payerCustomerNo + '%')
            }
            if (params.payeeCustomerNo != null && params.payeeCustomerNo != '') {
                like('payeeName', '%' + params.payeeCustomerNo + '%')
            }

//            if (params.customerNo) {
//                or {
//                    partner { eq 'customerNo', params.customerNo }
//                    payer { eq 'customerNo', params.customerNo }
//                    payee { eq 'customerNo', params.customerNo }
//                }
//            }
            if (params.accountNo) {
                or {
                    like('payerAccountNo', '%' + params.accountNo + '%')
                    like('payeeAccountNo', '%' + params.accountNo + '%')
                }
            }
        }
        def summ = TradeBase4Query.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }

        def total = TradeBase4Query.createCriteria().count(query)
        def tradeList = TradeBase4Query.createCriteria().list(params, query)
        [tradeList: tradeList, tradeTotal: total, params: params, flag: flag, rootId: rootId, serviceType: params.serviceType, totalAmount: summ]
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
        if (params.startDateCreated == null && params.endDateCreated == null) {
            def gCalendar = new GregorianCalendar()
            params.endDateCreated = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startDateCreated = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startDateCreated && !params.endDateCreated) {
            params.endDateCreated = params.startDateCreated
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startDateCreated && params.endDateCreated) {
            params.startDateCreated = params.endDateCreated
        }
        if (params.startDateCreated && params.endDateCreated) {


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
    def validLastDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startLastUpdated == null && params.endLastUpdated == null) {
            def gCalendar = new GregorianCalendar()
            params.endLastUpdated = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startLastUpdated = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startLastUpdated && !params.endLastUpdated) {
            params.endLastUpdated = params.startLastUpdated
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startLastUpdated && params.endTradeDate) {
            params.startLastUpdated = params.endLastUpdated
        }
        if (params.startLastUpdated && params.endLastUpdated) {


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
    def validTradeDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startTradeDate == null && params.endTradeDate == null) {
            def gCalendar = new GregorianCalendar()
            params.endTradeDate = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startTradeDate = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startTradeDate && !params.endTradeDate) {
            params.endTradeDate = params.startTradeDate
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startTradeDate && params.endTradeDate) {
            params.startTradeDate = params.endTradeDate
        }
        if (params.startTradeDate && params.endTradeDate) {


        }
    }

    def listDownload = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = 50000
        params.offset = 0
        def day = new Date()
        def customerNos = []
        //guonan update 2012-02-17
        if (params.companyType == 'branch') {
            def account = session.op.account
            def operator = BoOperator.findByAccount(account)
            println "and s.branchCompany = ${operator.branchCompany}"
            if ((operator.branchCompany != null && operator.branchCompany != "") || operator.role.roleName == "admin") {
                def para = [:]
                para['branchCompany'] = operator.branchCompany
                para['belongToBusiness'] = params.belongToBusiness
                para['grade'] = params.grade
                def que = {
                    if (operator.branchCompany && operator.branchCompany != "0") {
                        eq('branchCompany', para.branchCompany)
                    }
                    if (params.belongToBusiness) {
                        ilike('belongToBusiness', '%' + para.belongToBusiness + '%')
                    }
                    if (params.grade) {
                        eq('grade', para.grade)
                    }
                }
                def custmers = CmCorporationInfo.createCriteria().list(para, que)

                custmers?.each { customer ->
                    customerNos << customer.customerNo
                }
                if (customerNos.size() == 0) {
                    def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
                    response.setHeader("Content-disposition", "attachment; filename=" + filename)
                    response.contentType = "application/x-rarx-rar-compressed"
                    response.setCharacterEncoding("UTF-8")
                    render(template: "tradeList", model: [tradeBaseInstanceList: null, total: 0, totalAmount: 0,
                            payAmount: 0, payCount: 0, transferAmount: 0, transferCount: 0, refundAmount: 0, refundCount: 0,
                            chargeAmount: 0, chargeCount: 0, royaltyAmount: 0, royaltyCount: 0, royalty_rfdAmount: 0, royalty_rfdCount: 0, frozenAmount: 0, frozenCount: 0, unfrozenAmount: 0, unfrozenCount: 0, withdrawnAmount: 0, withdrawnCount: 0])
                    return null
                }
            } else {
                flash.message = "没有可下载内容"
                render(view: "list", model: [tradeList: null, tradeTotal: 0, params: params, flag: -1, rootId: params.rootId, serviceType: params.serviceType, totalAmount: 0])
                return null
            }
        }
        //guonan update 2012-02-17
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
                }
                def custmers = CmCorporationInfo.createCriteria().list(para, que)

                custmers?.each { customer ->
                    customerNos << customer.customerNo
                }
                if (customerNos.size() == 0) {
                    def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
                    response.setHeader("Content-disposition", "attachment; filename=" + filename)
                    response.contentType = "application/x-rarx-rar-compressed"
                    response.setCharacterEncoding("UTF-8")
                    render(template: "tradeList", model: [tradeBaseInstanceList: null, total: 0, totalAmount: 0,
                            payAmount: 0, payCount: 0, transferAmount: 0, transferCount: 0, refundAmount: 0, refundCount: 0,
                            chargeAmount: 0, chargeCount: 0, royaltyAmount: 0, royaltyCount: 0, royalty_rfdAmount: 0, royalty_rfdCount: 0, frozenAmount: 0, frozenCount: 0, unfrozenAmount: 0, unfrozenCount: 0, withdrawnAmount: 0, withdrawnCount: 0])
                    return null
                }
            } else {
                flash.message = "没有可下载内容"
                render(view: "list", model: [tradeList: null, tradeTotal: 0, params: params, flag: -2, rootId: params.rootId, serviceType: params.serviceType, totalAmount: 0])
                return null
            }
        }
        def query = {
            if (customerNos.size() > 0) {
                or {
                    partner {
                        'in'('customerNo', customerNos)
                    }
                    payer {
                        'in'('customerNo', customerNos)
                    }
                    payee {
                        'in'('customerNo', customerNos)
                    }
                }
            }
            if (params.rootId != null && params.rootId != '') {
                eq('rootId', Long.parseLong(params.rootId.toString()))
            }
//            if (params.startTradeDate != null && params.startTradeDate != '') {
//                ge('tradeDate', Integer.parseInt(params.startTradeDate.toString()))
//            }else{
//                ge('tradeDate', Integer.parseInt((day-30).format('yyyyMMdd').toString()) )
//            }
//            if (params.endTradeDate != null && params.endTradeDate != '') {
//                le('tradeDate', Integer.parseInt(params.endTradeDate.toString()))
//            }else{
//                le('tradeDate', Integer.parseInt(day.format('yyyyMMdd').toString()))
//            }
//            if (params.startDateCreated != null && params.startDateCreated != '') {
//                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
//            }else{
//                ge('dateCreated', Date.parse('yyyy-MM-dd', (day-30).format('yyyy-MM-dd')))
//            }
//            if (params.endDateCreated != null && params.endDateCreated != '') {
//                le('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
//            }else{
//                le('dateCreated', Date.parse('yyyy-MM-dd', day.format('yyyy-MM-dd')) + 1)
//            }
//            if (params.startLastUpdated != null && params.startLastUpdated != '') {
//                ge('lastUpdated', Date.parse('yyyy-MM-dd', params.startLastUpdated))
//            }else{
//                ge('lastUpdated', Date.parse('yyyy-MM-dd', (day-30).format('yyyy-MM-dd')))
//            }
//            if (params.endLastUpdated != null && params.endLastUpdated != '') {
//                le('lastUpdated', Date.parse('yyyy-MM-dd', params.endLastUpdated) + 1)
//            }else{
//                le('lastUpdated', Date.parse('yyyy-MM-dd', day.format('yyyy-MM-dd')) + 1)
//            }

            //guonan update 2011-12-29
//            validDated(params)
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
            //guonan update 2011-12-29
//            validLastDated(params)
            if (params.startLastUpdated) {
                ge('lastUpdated', Date.parse('yyyy-MM-dd', params.startLastUpdated))
            }
            if (params.endLastUpdated) {
                lt('lastUpdated', Date.parse('yyyy-MM-dd', params.endLastUpdated) + 1)
            }
            //guonan update 2011-12-29
            validTradeDated(params)
            if (params.startTradeDate) {
                ge('tradeDate', Integer.parseInt(params.startTradeDate?.replace('-', '')))
            }
            if (params.endTradeDate) {
                le('tradeDate', Integer.parseInt(params.endTradeDate?.replace('-', '')))
            }

            //zhouwei update 2012-02-07
            if (params.serviceType != null && params.serviceType != '') {
                eq('serviceType', params.serviceType)
            }
            //zhouwei update 2012-02-07
            if (params.paymentType != null && params.paymentType != '') {
                eq('paymentType', params.paymentType)
            }
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.outTradeNo != null && params.outTradeNo != '') {
                like('outTradeNo', '%' + params.outTradeNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
            if (params.tradeType != null && params.tradeType != '') {
                eq('tradeType', params.tradeType)
            }
            if (params.status != null && params.status != '') {
                eq('status', params.status)
            }
            if (params.customerNo != null && params.customerNo != '') {
                partner {
                    like('name', '%' + params.customerNo + '%')
                }
            }
            if (params.payerCustomerNo != null && params.payerCustomerNo != '') {
                like('payerName', '%' + params.payerCustomerNo + '%')
            }
            if (params.payeeCustomerNo != null && params.payeeCustomerNo != '') {
                like('payeeName', '%' + params.payeeCustomerNo + '%')
            }
            if (params.accountNo) {
                or {
//                    eq 'payerAccountNo', params.accountNo
                    like('payerAccountNo', '%' + params.accountNo + '%')
//                    eq 'payeeAccountNo', params.accountNo
                    like('payeeAccountNo', '%' + params.accountNo + '%')
                }
            }

        }
        def total = TradeBase4Query.createCriteria().count(query)
        def tradeList = TradeBase4Query.createCriteria().list(params, query)

        def payAmount = TradeBase4Query.createCriteria().get {
            and query
            eq('tradeType', 'payment')
            projections {
                sum('amount')
                rowCount()
            }
        }
        def transferAmount = TradeBase4Query.createCriteria().get {
            and query
            eq('tradeType', 'transfer')
            projections {
                sum('amount')
                rowCount()
            }
        }
        def refundAmount = TradeBase4Query.createCriteria().get {
            and query
            eq('tradeType', 'refund')
            projections {
                sum('amount')
                rowCount()
            }
        }
        def chargeAmount = TradeBase4Query.createCriteria().get {
            and query
            eq('tradeType', 'charge')
            projections {
                sum('amount')
                rowCount()
            }
        }
        def withdrawnAmount = TradeBase4Query.createCriteria().get {
            and query
            eq('tradeType', 'withdrawn')
            projections {
                sum('amount')
                rowCount()
            }
        }
        def royaltyAmount = TradeBase4Query.createCriteria().get {
            and query
            eq('tradeType', 'royalty')
            projections {
                sum('amount')
                rowCount()
            }
        }
        def royalty_rfdAmount = TradeBase4Query.createCriteria().get {
            and query
            eq('tradeType', 'royalty_rfd')
            projections {
                sum('amount')
                rowCount()
            }
        }
        def frozenAmount = TradeBase4Query.createCriteria().get {
            and query
            eq('tradeType', 'frozen')
            projections {
                sum('amount')
                rowCount()
            }
        }
        def unfrozenAmount = TradeBase4Query.createCriteria().get {
            and query
            eq('tradeType', 'unfrozen')
            projections {
                sum('amount')
                rowCount()
            }
        }
        def totalAmount = TradeBase4Query.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [tradeBaseInstanceList: tradeList, total: total, totalAmount: totalAmount,
                payAmount: payAmount[0], payCount: payAmount[1], transferAmount: transferAmount[0], transferCount: transferAmount[1], refundAmount: refundAmount[0], refundCount: refundAmount[1],
                chargeAmount: chargeAmount[0], chargeCount: chargeAmount[1], royaltyAmount: royaltyAmount[0], royaltyCount: royaltyAmount[1], royalty_rfdAmount: royalty_rfdAmount[0], royalty_rfdCount: royalty_rfdAmount[1], frozenAmount: frozenAmount[0], frozenCount: frozenAmount[1], unfrozenAmount: unfrozenAmount[0], unfrozenCount: unfrozenAmount[1], withdrawnAmount: withdrawnAmount[0], withdrawnCount: withdrawnAmount[1]])
    }

    def show = {
        def trade = TradeBase4Query.read(params.id)
        if (!trade) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeBase.label', default: 'TradeBase'), params.id])}"
            redirect(action: "list")
        } else {
            [trade: trade]
        }
    }


    def qry={

        def trade = TradeBase4Query.findByTradeNo(params.id)
        if (!trade) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeBase.label', default: 'TradeBase'), params.id])}"
            redirect(action: "list")
        } else {
            render(view:'show',model:[trade:trade])
        }


    }

}
