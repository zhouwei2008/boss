package gateway

import groovyx.net.http.HTTPBuilder
import groovyx.net.http.EncoderRegistry
import groovyx.net.http.ContentType
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import ebank.tools.StringUtil
import groovyx.net.http.Method

class GwTransactionController {

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def now = new Date()
        def beginningOfDay = Date.parse('yyyyMMdd', now.format('yyyyMMdd'))
        def query = {
            if (params.id)  like('id', '%' + params.id + '%')
            if (params.bankTransNo)  like('bankTransNo', '%' + params.bankTransNo + '%')
            if (params.authNo)  like('authNo', '%' + params.authNo + '%')
            if (params.startAmount) {
                ge 'amount', StringUtil.parseAmountFromStr(params.startAmount)
            }
            if (params.endAmount) {
                le 'amount', StringUtil.parseAmountFromStr(params.endAmount)
            }
            if (params.buyerCode)  like('buyerCode', '%' + params.buyerCode + '%')
            if (params.acquirerCode)  like('acquirerCode', '%' + params.acquirerCode + '%')
//            if (params.startTime || params.endTime) {
//                def startTime = params.startTime ?
//                    Date.parse("yyyyMMdd", params.startTime) : Date.parse("yyyyMMdd", params.endTime) - 30
//                def endTime = params.endTime ?
//                    Date.parse("yyyyMMdd", params.endTime) : startTime + 30
//                between 'dateCreated', startTime, endTime + 1
//            } else {
//                between 'dateCreated', beginningOfDay - 30, beginningOfDay + 1
//            }
            //sunweiguo update 2012-6-12
            if (params.startCompletionTime)
            {
                   ge('completionTime', Date.parse('yyyy-MM-dd', params.startCompletionTime))
            }
            if (params.endCompletionTime)
            {
                  lt('completionTime', Date.parse('yyyy-MM-dd', params.endCompletionTime) + 1)
            }
            else
            {
                  //guonan update 2012-1-10
                def startTime,endTime
                if (params.startTime || params.endTime) {
                    startTime = params.startTime ?
                        Date.parse("yyyy-MM-dd", params.startTime) : Date.parse("yyyy-MM-dd", params.startTime=params.endTime)
                     endTime = params.endTime ?
                        Date.parse("yyyy-MM-dd", params.endTime) : Date.parse("yyyy-MM-dd", params.endTime=params.startTime)
                     between 'dateCreated', startTime, endTime + 1
                } else {
                    if (params.startTime==null &&params.endTime==null) {
                    def gCalendar= new GregorianCalendar()
                    endTime=Date.parse('yyyy-MM-dd',  params.endTime = gCalendar.time.format('yyyy-MM-dd'))
                    gCalendar.add(GregorianCalendar.MONTH,-1)
                    startTime=Date.parse('yyyy-MM-dd', params.startTime= gCalendar.time.format('yyyy-MM-dd'))
                      between 'dateCreated', startTime, endTime + 1
                    }
                }

             }

            //guoan update end




            if (params.status) eq 'status', params.status
            if (params.orderId || params.sellerCustomerNo || params.outTradeNo) {
                order {
                    if (params.orderId)  like('id', '%' + params.orderId + '%')
                    if (params.sellerCustomerNo)  like('sellerCustomerNo', '%' + params.sellerCustomerNo + '%')
                    if (params.outTradeNo)  like('outTradeNo', '%' + params.outTradeNo + '%')
                }
            }
        }
        def summ = GwTransaction.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def total = GwTransaction.createCriteria().count(query)
        def gwTransList = GwTransaction.createCriteria().list(params, query)
        [gwTransList: gwTransList, gwTransTotal: total, params: params,totalAmount:summ]
    }

    def listDownload = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = 50000
        params.offset = 0

        def now = new Date()
        def beginningOfDay = Date.parse('yyyyMMdd', now.format('yyyyMMdd'))
        def query = {
            if (params.id)  like('id', '%' + params.id + '%')
            if (params.bankTransNo)  like('bankTransNo', '%' + params.bankTransNo + '%')
            if (params.authNo)  like('authNo', '%' + params.authNo + '%')
            if (params.statrAmount) ge 'amount', StringUtil.parseAmountFromStr(params.statrAmount)
            if (params.endAmount) le 'amount', StringUtil.parseAmountFromStr(params.endAmount)
            if (params.buyerCode) eq 'buyerCode', params.buyerCode
            if (params.acquirerCode) eq 'acquirerCode', params.acquirerCode
//            if (params.startTime || params.endTime) {
//                def startTime = params.startTime ?
//                    Date.parse("yyyyMMdd", params.startTime) : Date.parse("yyyyMMdd", params.endTime) - 30
//                def endTime = params.endTime ?
//                    Date.parse("yyyyMMdd", params.endTime) : startTime + 30
//                between 'dateCreated', startTime, endTime + 1
//            } else {
//                between 'dateCreated', beginningOfDay - 30, beginningOfDay + 1
//            }
  //sunweiguo update 2012-6-12
            if (params.startCompletionTime)
            {
                   ge('completionTime', Date.parse('yyyy-MM-dd', params.startCompletionTime))
            }
            if (params.endCompletionTime)
            {
                  lt('completionTime', Date.parse('yyyy-MM-dd', params.endCompletionTime) + 1)
            }
            else
            {
                  //guonan update 2012-1-10
                def startTime,endTime
                if (params.startTime || params.endTime) {
                    startTime = params.startTime ?
                        Date.parse("yyyy-MM-dd", params.startTime) : Date.parse("yyyy-MM-dd", params.startTime=params.endTime)
                     endTime = params.endTime ?
                        Date.parse("yyyy-MM-dd", params.endTime) : Date.parse("yyyy-MM-dd", params.endTime=params.startTime)
                     between 'dateCreated', startTime, endTime + 1
                } else {
                    if (params.startTime==null &&params.endTime==null) {
                    def gCalendar= new GregorianCalendar()
                    endTime=Date.parse('yyyy-MM-dd',  params.endTime = gCalendar.time.format('yyyy-MM-dd'))
                    gCalendar.add(GregorianCalendar.MONTH,-1)
                    startTime=Date.parse('yyyy-MM-dd', params.startTime= gCalendar.time.format('yyyy-MM-dd'))
                      between 'dateCreated', startTime, endTime + 1
                    }
                }

             }


            //guoan update end

            if (params.status) eq 'status', params.status
            if (params.orderId || params.sellerCustomerNo || params.outTradeNo) {
                order {
                    if (params.orderId)  like('id', '%' + params.orderId + '%')
                    if (params.sellerCustomerNo)  like('sellerCustomerNo', '%' + params.sellerCustomerNo + '%')
                    if (params.outTradeNo)  like('outTradeNo', '%' + params.outTradeNo + '%')
                }
            }
        }
        def total = GwTransaction.createCriteria().count(query)
        def gwTransList = GwTransaction.createCriteria().list(params, query)

        def summary = GwTransaction.createCriteria().get {
            and query
//            eq('tradeType', 'payment')
            projections {
                sum('amount')
                rowCount()
            }
        }

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [gwTransList: gwTransList,totalAmount:summary[0],total:summary[1]])
    }

    def show = {
        def gwTransactionInstance = GwTransaction.get(params.id)
        if (!gwTransactionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'gwTransaction.label', default: 'GwTransaction'), params.id])}"
            redirect(action: "list")
        }
        else {
            [gwTransactionInstance: gwTransactionInstance]
        }
    }

    def editFinished = {
        def gwTrans = GwTransaction.get(params.id)
        if (!gwTrans) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'gwTransaction.label', default: 'GwTransaction'), params.id])}"
            redirect(action: "list")
        } else if (gwTrans.status == '1') {
            flash.message = "网关支付(${gwTrans.id})状态已经是成功！"
            redirect(action: "list")
        } else {
            return [gwTrans: gwTrans]
        }
    }

    def autoCheck = {
        def gwTrans = GwTransaction.get(params.id)
        if (!gwTrans) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'gwTransaction.label', default: 'GwTransaction'), params.id])}"
        } else if (gwTrans.status != '0') {
            flash.message = "网关支付(${gwTrans.id})不能做自动核对！"
        } else {
            def args = [id: gwTrans.id, oper: session.op?.name]
            def result = invokeGwInnerApi('/ISMSApp/queryGwTrx/synAcquire', args)
            if (result instanceof Map) {
                flash.message = "网关支付(${gwTrans.id})核对. ${result.resmsg}"
            } else {
                flash.message = "网关支付(${gwTrans.id})核对. ${result}"
            }
        }
        redirect(action: "list")
    }

    def toFinished = {
        println params
        def gwTrans = GwTransaction.get(params.id)
        if (!gwTrans) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'gwTransaction.label', default: 'GwTransaction'), params.id])}"
        } else if (gwTrans.status == '1') {
            flash.message = "网关支付(${gwTrans.id})状态已经是成功！"
        } else {
            def args = [id: gwTrans.id, iniSts: gwTrans.status, changeSts: '1',authSts:'N',
                    trxamount: gwTrans.amount, oper: session.op?.name]
            if (params.acquirerSeq) args['acquireSeq'] = params.acquirerSeq
            if (params.referenceNo) args['acquireRefnum'] = params.referenceNo
            if (params.authNo) args['acquireAuthcode'] = params.authNo
            println args
            def result = invokeGwInnerApi('/ISMSApp/postFaultTrx/create', args)
            if (result instanceof Map) {
                flash.message = "网关支付(${gwTrans.id})更改状态. ${result.resmg}"
            } else {
                flash.message = "网关支付(${gwTrans.id})更改状态. ${result}"
            }
        }
        redirect(action: "list")
    }

    def toFailed = {
        def gwTrans = GwTransaction.get(params.id)
        if (!gwTrans) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'gwTransaction.label', default: 'GwTransaction'), params.id])}"
        } else if (gwTrans.status in ['1', '2']) {
            flash.message = "网关支付(${gwTrans.id})不允许变更成失败！"
        } else {
            def args = [id: gwTrans.id, iniSts: gwTrans.status, changeSts: '2',
                    trxamount: gwTrans.amount, oper: session.op?.name]
            def result = invokeGwInnerApi('/ISMSApp/postFaultTrx/create', args)
            if (result instanceof Map) {
                flash.message = "网关支付(${gwTrans.id})更改状态. ${result.resmg}"
            } else {
                flash.message = "网关支付(${gwTrans.id})更改状态. ${result}"
            }
        }
        redirect(action: "list")
    }

    private invokeGwInnerApi(String _uri, Map _args) {
        log.info "invoke Gateway inner api: $_uri \n args: $_args"
        def result = ''
        try {
            def http = new HTTPBuilder(ConfigurationHolder.config.gateway.inner.server)
            http.request(Method.POST, ContentType.JSON) { req ->
                uri.path = _uri
                send ContentType.URLENC, _args

                response.success = { resp, json ->
                    log.debug "response status: ${resp.statusLine}"
                    result = json
                }
            }
        } catch (e) {
            log.error e, e
            result = e.getMessage()
        }
        log.info "resp: $result"
        result
    }

}
