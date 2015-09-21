package ismp

import ebank.tools.StringUtil
import boss.AppNote
import account.AcAccount
import boss.BoInnerAccount
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import groovy.sql.Sql
import boss.BoBankDic
import boss.BoAcquirerAccount
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.multipart.commons.CommonsMultipartFile
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import org.apache.poi.xssf.usermodel.XSSFSheet
import org.apache.poi.xssf.usermodel.XSSFRow
import boss.GetRandom
import boss.GetNumRandom
import grails.converters.JSON

class TradeWithdrawnController {

    def tradeService
    def accountClientService
    // static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def unCheckList = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.offset = params.offset ? params.int('offset') : 0
        println params.isCorporate
        def cor
        if (params.isCorporate.equals("true")) {
            cor = true
        } else {
            cor = false
        }
        def query = {
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.isCorporate != null && params.isCorporate != '') {
                eq('isCorporate', cor)
            }
            if (params.acquirerAccountId != null && params.acquirerAccountId != '') {
//                eq('acquirerAccountId', Long.parseLong(params.acquirerAccountId))
                sqlRestriction "to_char(acquirer_account_id)  like '%" + params.acquirerAccountId + "%'"
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', '%' + params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', '%' + params.payerAccountNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
            if (params.bankCode != null && params.bankCode != '') {
                eq('customerBankCode', params.bankCode)
            }
//            if (params.startTime) {
//                ge('dateCreated', Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le('dateCreated', Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }
            //guonan update 2011-12-29
            validTimed(params)
            if (params.startTime) {
                ge('dateCreated', Date.parse('yyyy-MM-dd HH:mm:ss', params.startTime))
            }
            if (params.endTime) {
                lt('dateCreated', Date.parse('yyyy-MM-dd HH:mm:ss', params.endTime))
            }
            eq('handleStatus', 'waiting')
        }

        def summ = TradeWithdrawn.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def total = TradeWithdrawn.createCriteria().count(query)
        def results = TradeWithdrawn.createCriteria().list(params, query)
        [tradeWithdrawnInstanceList: results, tradeWithdrawnInstanceTotal: total, totalAmount: summ]
    }

    def checkList = {
        params.sort = params.sort ? params.sort : "lastAppDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def cor
        if (params.isCorporate.equals("true")) {
            cor = true
        } else {
            cor = false
        }
        def query = {
            if (params.tradeNo != null && params.tradeNo != '') {
                eq('tradeNo', params.tradeNo)
            }
            if (params.isCorporate != null && params.isCorporate != '') {
                eq('isCorporate', cor)
            }
            if (params.acquirerAccountId != null && params.acquirerAccountId != '') {
                eq('acquirerAccountId', Long.parseLong(params.acquirerAccountId))
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', params.payerAccountNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
            if (params.bankCode != null && params.bankCode != '') {
                eq('customerBankCode', params.bankCode)
            }
            if (params.withdrawnBatchNo != null && params.withdrawnBatchNo != '') {
                eq('withdrawnBatchNo', params.withdrawnBatchNo)
            }
            //guonan update 2011-12-29
            validTimed(params)
            if (params.startTime) {
                ge('dateCreated', Date.parse('yyyy-MM-dd HH:mm:ss', params.startTime))
            }
            if (params.endTime) {
                lt('dateCreated', Date.parse('yyyy-MM-dd HH:mm:ss', params.endTime))
            }
            if (params.startLastAppDate != null && params.startLastAppDate != '') {
                ge('lastAppDate', Date.parse('yyyy-MM-dd HH:mm:ss', params.startLastAppDate))
            }
            if (params.endLastAppDate != null && params.endLastAppDate != '') {
                lt('lastAppDate', Date.parse('yyyy-MM-dd HH:mm:ss', params.endLastAppDate))
            }
            eq('handleStatus', 'checked')
        }

        def summ = TradeWithdrawn.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def total = TradeWithdrawn.createCriteria().count(query)
        def results = TradeWithdrawn.createCriteria().list(params, query)
        [tradeWithdrawnInstanceList: results, tradeWithdrawnInstanceTotal: total, totalAmount: summ]
    }

    def checkShowBatch = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def sign = params.sign ? params.sign : '0'
        def query = {
            eq('withdrawnBatchNo', params.id)
        }
        def total = TradeWithdrawn.createCriteria().count(query)
        def results = TradeWithdrawn.createCriteria().list(params, query)
        def withdrawnAmount = TradeWithdrawn.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        [tradeWithdrawnInstanceList: results, tradeWithdrawnInstanceTotal: total, withdrawnAmount: withdrawnAmount, sign: sign, withdrawnBatchNo: params.id, bankCode: params.bankCode]
    }

    def checkBatchShow = {
        def withdrawnBatch = WithdrawnBatch.get(params.id)
        [withdrawnBatch: withdrawnBatch]
    }

    def reCheckList = {
        params.sort = params.sort ? params.sort : "withHandleDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def cor
        if (params.isCorporate.equals("true")) {
            cor = true
        } else {
            cor = false
        }
        def query = {
            if (params.tradeNo != null && params.tradeNo != '') {
                eq('tradeNo', params.tradeNo)
            }
            if (params.isCorporate != null && params.isCorporate != '') {
                eq('isCorporate', cor)
            }
            if (params.acquirerAccountId != null && params.acquirerAccountId != '') {
                eq('acquirerAccountId', Long.parseLong(params.acquirerAccountId))
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                eq('payerAccountNo', params.payerAccountNo)
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
            if (params.bankCode != null && params.bankCode != '') {
                eq('customerBankCode', params.bankCode)
            }
            validTimed(params)
            if (params.startTime) {
                ge('dateCreated', Date.parse('yyyy-MM-dd HH:mm:ss', params.startTime))
            }
            if (params.endTime) {
                lt('dateCreated', Date.parse('yyyy-MM-dd HH:mm:ss', params.endTime))
            }
            if (params.startWithHandleDate != null && params.startWithHandleDate != '') {
                ge('withHandleDate', Date.parse('yyyy-MM-dd HH:mm:ss', params.startWithHandleDate))
            }
            if (params.endWithHandleDate != null && params.endWithHandleDate != '') {
                lt('withHandleDate', Date.parse('yyyy-MM-dd HH:mm:ss', params.endWithHandleDate))
            }
            if (params.handleStatus != null && params.handleStatus != '') {
                eq('handleStatus', params.handleStatus)
            } else {
                'in'('handleStatus', ['success', 'fail'])
            }
        }

        def summ = TradeWithdrawn.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def total = TradeWithdrawn.createCriteria().count(query)
        def results = TradeWithdrawn.createCriteria().list(params, query)
        [tradeWithdrawnInstanceList: results, tradeWithdrawnInstanceTotal: total, totalAmount: summ]
    }

    /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan
     *
     */
    def validTimed(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startTime == null && params.endTime == null) {
            def gCalendar = new GregorianCalendar()
            params.endTime = gCalendar.time.format('yyyy-MM-dd HH:mm:ss')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startTime = gCalendar.time.format('yyyy-MM-dd HH:mm:ss')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startTime && !params.endTime) {
            params.endTime = params.startTime
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startTime && params.endTime) {
            params.startTime = params.endTime
        }
        if (params.startTime && params.endTime) {


        }
    }

    def listDownload = {
        def flags = params.flag
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = 50000
        params.offset = 0
        def cor
        if (params.isCorporate.equals("true")) {
            cor = true
        } else {
            cor = false
        }
        def query = {
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.isCorporate != null && params.isCorporate != '') {
                eq('isCorporate', cor)
            }
            if (params.acquirerAccountId != null && params.acquirerAccountId != '') {
//                eq('acquirerAccountId', params.acquirerAccountId)
                sqlRestriction "to_char(acquirer_account_id)  like '%" + params.acquirerAccountId + "%'"
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', '%' + params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', '%' + params.payerAccountNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', (params.startAmount.toDouble() * 100).toLong())
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', (params.endAmount.toDouble() * 100).toLong())
            }
            if (params.bankCode != null && params.bankCode != '') {
                eq('customerBankCode', params.bankCode)
            }

//            if (params.startTime) {
//                ge('dateCreated', Date.parse("yyyy-MM-dd HH:mm:ss", params.startTime))
//            }
//            if (params.endTime) {
//                le('dateCreated', Date.parse("yyyy-MM-dd HH:mm:ss", params.endTime))
//            }
            //guonan update 2011-12-29
            validTimed(params)
            if (flags != '2') {
                if (params.startTime) {
                    ge('dateCreated', Date.parse('yyyy-MM-dd HH:mm:ss', params.startTime))
                }
                if (params.endTime) {
                    lt('dateCreated', Date.parse('yyyy-MM-dd HH:mm:ss', params.endTime))
                }
            }
            if (flags.toString().equals("1")) {
                isNull('withdrawnBatchNo')
                'in'('handleStatus', ['fChecked', 'fRefuse'])
            }
            if (flags.toString().equals("2")) {
                like('withdrawnBatchNo', '%' + params.withdrawnBatchNo + '%')
                eq('handleStatus', 'fChecked')
            }
            if (flags.toString().equals("3")) {
                eq('handleStatus', 'checked')
            }
            if (flags.toString().equals("4")) {
                'in'('handleStatus', ['success', 'fail'])
            }
            if (flags.toString().equals("5")) {
                if (params.bankCode != null && params.bankCode != '') {
                    def acc = BoAcquirerAccount.findAllByBank(BoBankDic.findByCode(params.bankCode)).id
                    'in'('acquirerAccountId', acc)
                }
                if (params.withdrawnBatchNo != null && params.withdrawnBatchNo != '') {
                    like('withdrawnBatchNo', '%' + params.withdrawnBatchNo + '%')
                }
                if (params.handleStatus != null && params.handleStatus != '') {
                    eq('handleStatus', params.handleStatus)
                    if (params.handleStatus == 'waiting') {
                        if (params.startTimeHandle) {
                            ge('handleTime', Date.parse("yyyy-MM-dd HH:mm:ss", params.startTimeHandle))
                        }
                        if (params.endTimeHandle) {
                            le('handleTime', Date.parse("yyyy-MM-dd HH:mm:ss", params.endTimeHandle))
                        }
                    }
                    if (params.handleStatus == 'fChecked' || params.handleStatus == 'fRefuse') {
                        if (params.startTimeHandle) {
                            ge('firstAppDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.startTimeHandle))
                        }
                        if (params.endTimeHandle) {
                            le('firstAppDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.endTimeHandle))
                        }
                    }
                    if (params.handleStatus == 'sRefuse' || params.handleStatus == 'checked') {
                        if (params.startTimeHandle) {
                            ge('lastAppDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.startTimeHandle))
                        }
                        if (params.endTimeHandle) {
                            le('lastAppDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.endTimeHandle))
                        }
                    }
                    if (params.handleStatus == 'success' || params.handleStatus == 'fail') {
                        if (params.startTimeHandle) {
                            ge('withHandleDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.startTimeHandle))
                        }
                        if (params.endTimeHandle) {
                            le('withHandleDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.endTimeHandle))
                        }
                    }
                    if (params.handleStatus == 'refFail' || params.handleStatus == 'completed') {
                        if (params.startTimeHandle) {
                            ge('withReHandleDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.startTimeHandle))
                        }
                        if (params.endTimeHandle) {
                            le('withReHandleDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.endTimeHandle))
                        }
                    }
                }
            }
            else if (flags.toString().equals("0")) {
                eq('handleStatus', 'waiting')
            }

        }
//        def total = TradeWithdrawn.createCriteria().count(query)
        def results = TradeWithdrawn.createCriteria().list(params, query)

        def summary = TradeWithdrawn.createCriteria().get {
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
        render(template: "tradeList", model: [tradeWithdrawnInstanceList: results, totalAmount: summary[0], total: summary[1], flag: flags])
    }

    def histList = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def cor
        if (params.isCorporate.equals("true")) {
            cor = true
        } else {
            cor = false
        }
        def query = {
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.isCorporate != null && params.isCorporate != '') {
                eq('isCorporate', cor)
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', '%' + params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', '%' + params.payerAccountNo + '%')
            }
            if (params.customerBankAccountName != null && params.customerBankAccountName != '') {
                like('customerBankAccountName', '%' + params.customerBankAccountName + '%')
            }

            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', (params.startAmount.toDouble() * 100).toLong())
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', (params.endAmount.toDouble() * 100).toLong())
            }
            if (params.handleStatus != null && params.handleStatus != '') {
                eq('handleStatus', params.handleStatus)
                if (params.handleStatus == 'waiting') {
                    if (params.startTimeHandle) {
                        ge('handleTime', Date.parse("yyyy-MM-dd HH:mm:ss", params.startTimeHandle))
                    }
                    if (params.endTimeHandle) {
                        le('handleTime', Date.parse("yyyy-MM-dd HH:mm:ss", params.endTimeHandle))
                    }
                }
                if (params.handleStatus == 'fChecked' || params.handleStatus == 'fRefuse') {
                    if (params.startTimeHandle) {
                        ge('firstAppDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.startTimeHandle))
                    }
                    if (params.endTimeHandle) {
                        le('firstAppDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.endTimeHandle))
                    }
                }
                if (params.handleStatus == 'sRefuse' || params.handleStatus == 'checked') {
                    if (params.startTimeHandle) {
                        ge('lastAppDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.startTimeHandle))
                    }
                    if (params.endTimeHandle) {
                        le('lastAppDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.endTimeHandle))
                    }
                }
                if (params.handleStatus == 'success' || params.handleStatus == 'fail') {
                    if (params.startTimeHandle) {
                        ge('withHandleDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.startTimeHandle))
                    }
                    if (params.endTimeHandle) {
                        le('withHandleDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.endTimeHandle))
                    }
                }
                if (params.handleStatus == 'refFail' || params.handleStatus == 'completed') {
                    if (params.startTimeHandle) {
                        ge('withReHandleDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.startTimeHandle))
                    }
                    if (params.endTimeHandle) {
                        le('withReHandleDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.endTimeHandle))
                    }
                }
            }
            if (params.startLastAppDate!=null && params.startLastAppDate!='') {
                ge('lastAppDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.startLastAppDate))
            }
            if (params.endLastAppDate!=null && params.endLastAppDate!='') {
                le('lastAppDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.endLastAppDate))
            }
            if (params.startWithReHandleDate!=null && params.startWithReHandleDate!='') {
                ge('withReHandleDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.startWithReHandleDate))
            }
            if (params.endWithReHandleDate!=null && params.endWithReHandleDate!='') {
                le('withReHandleDate', Date.parse("yyyy-MM-dd HH:mm:ss", params.endWithReHandleDate))
            }
            if (params.handleOperName != null && params.handleOperName != '') {
                like('handleOperName', '%' + params.handleOperName + '%')
            }
            if (params.bankCode != null && params.bankCode != '') {
                def acc = BoAcquirerAccount.findAllByBank(BoBankDic.findByCode(params.bankCode)).id
                'in'('acquirerAccountId', acc)
            }
            if (params.withdrawnBatchNo != null && params.withdrawnBatchNo != '') {
                like('withdrawnBatchNo', '%' + params.withdrawnBatchNo + '%')
            }
            //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
                ge('dateCreated', Date.parse('yyyy-MM-dd HH:mm:ss', params.startTime))
            }
            if (params.endTime) {
                lt('dateCreated', Date.parse('yyyy-MM-dd HH:mm:ss', params.endTime))
            }
            //guonan update 2011-12-29
//            validHandled(params)
//            ge('handleTime', Date.parse('yyyy-MM-dd HH:mm:ss', params.startTimeHandle))
//            lt('handleTime', Date.parse('yyyy-MM-dd HH:mm:ss', params.endTimeHandle))

//            or {
//                eq('handleStatus', 'completed')
//                eq('handleStatus', 'fRefuse')
//                eq('handleStatus', 'sRefuse')
//            }
        }

        def summ = TradeWithdrawn.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def total = TradeWithdrawn.createCriteria().count(query)
        def results = TradeWithdrawn.createCriteria().list(params, query)
        [tradeWithdrawnInstanceList: results, tradeWithdrawnInstanceTotal: total, totalAmount: summ]
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
        if (params.startTimeCreate == null && params.endTimeCreate == null) {
            def gCalendar = new GregorianCalendar()
            params.endTimeCreate = gCalendar.time.format('yyyy-MM-dd HH:mm:ss')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startTimeCreate = gCalendar.time.format('yyyy-MM-dd HH:mm:ss')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startTimeCreate && !params.endTimeCreate) {
            params.endTimeCreate = params.startTime
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startTimeCreate && params.endTimeCreate) {
            params.startTimeCreate = params.endTimeCreate
        }
        if (params.startTimeCreate && params.endTimeCreate) {


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
    def validHandled(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startTimeHandle == null && params.endTimeHandle == null) {
            def gCalendar = new GregorianCalendar()
            params.endTimeHandle = gCalendar.time.format('yyyy-MM-dd HH:mm:ss')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startTimeHandle = gCalendar.time.format('yyyy-MM-dd HH:mm:ss')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startTimeHandle && !params.endTimeHandle) {
            params.endTimeHandle = params.startTimeHandle
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startTimeHandle && params.endTimeHandle) {
            params.startTimeHandle = params.endTimeHandle
        }
        if (params.startTimeHandle && params.endTimeHandle) {


        }
    }

    def refuseList = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def cor
        if (params.isCorporate.equals("true")) {
            cor = true
        } else {
            cor = false
        }
        def query = {
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', '%' + params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', '%' + params.payerAccountNo + '%')
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', (params.endAmount.toDouble() * 100).toLong())
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', (params.startAmount.toDouble() * 100).toLong())
            }
            if (params.handleStatus != null && params.handleStatus != '') {
                eq('handleStatus', params.handleStatus)
            }
            if (params.bankCode != null && params.bankCode != '') {
                eq('customerBankCode', params.bankCode)
            }
            if (params.isCorporate != null && params.isCorporate != '') {
                eq('isCorporate', cor)
            }
            //guonan update 2011-12-29
            validDated(params)
            if (params.startTimeCreate) {
                ge('dateCreated', Date.parse('yyyy-MM-dd HH:mm:ss', params.startTimeCreate))
            }
            if (params.endTimeCreate) {
                lt('dateCreated', Date.parse('yyyy-MM-dd HH:mm:ss', params.endTimeCreate))
            }
            if (params.startFirstAppDate != null && params.startFirstAppDate != '') {
                ge('firstAppDate', Date.parse('yyyy-MM-dd HH:mm:ss', params.startFirstAppDate))
            }
            if (params.startFirstAppDate != null && params.startFirstAppDate != '') {
                lt('firstAppDate', Date.parse('yyyy-MM-dd HH:mm:ss', params.endFirstAppDate))
            }
            //guonan update 2011-12-29
//            validHandled(params)
//            ge('handleTime', Date.parse('yyyy-MM-dd HH:mm:ss', params.startTimeHandle))
//            lt('handleTime', Date.parse('yyyy-MM-dd HH:mm:ss', params.endTimeHandle))
            isNull('withdrawnBatchNo')
            if (params.handleStatus != null && params.handleStatus != '') {
                eq('handleStatus', params.handleStatus)
            }
            else {
                'in'('handleStatus', ['fChecked', 'fRefuse'])
            }
        }
        def summ = TradeWithdrawn.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def total = TradeWithdrawn.createCriteria().count(query)
        def results = TradeWithdrawn.createCriteria().list(params, query)
        [tradeWithdrawnInstanceList: results, tradeWithdrawnInstanceTotal: total, totalAmount: summ]
    }

//单笔退款处理成功批量审批通过
    def selectSingleCheck = {
        def id = params.id
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        def idList = new ArrayList()
        idList = id.split(',')
        TradeWithdrawn.withTransaction {

            if (idList.size() > 0) {
                idList.each {
                    def tradeWithdrawnInstance = TradeWithdrawn.get(it)
                    //初审通过，只改变单据状态
                    tradeWithdrawnInstance.handleStatus = 'checked'
                    tradeWithdrawnInstance.lastAppId = userId
                    tradeWithdrawnInstance.lastAppName = userName
                    tradeWithdrawnInstance.lastAppDate = new Date()
                    if (!tradeWithdrawnInstance.hasErrors() && tradeWithdrawnInstance.save(flush: true)) {
                        flash.message = "退款审批通过成功！"
                    }
                    else {
                        flash.message = "退款审批通过失败！"
                        return
                    }
                }
            }
        }
        redirect(action: "refuseList")
    }

    def checkShow = {
        def tradeWithdrawnInstance = TradeWithdrawn.get(params.id)
        if (!tradeWithdrawnInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeWithdrawn.label', default: 'TradeWithdrawn'), params.id])}"
            redirect(action: "unCheckList")
        }
        else {
            [tradeWithdrawnInstance: tradeWithdrawnInstance]
        }
    }

    def refuseShow = {
        def sign = params.sign ? params.sign : ''
        def tradeWithdrawnInstance = TradeWithdrawn.get(params.id)
        if (!tradeWithdrawnInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeWithdrawn.label', default: 'TradeWithdrawn'), params.id])}"
            redirect(action: "refuseList")
        }
        else {
            [tradeWithdrawnInstance: tradeWithdrawnInstance, sign: sign]
        }
    }

    def show = {
        def tradeWithdrawnInstance = TradeWithdrawn.get(params.id)
        if (!tradeWithdrawnInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeWithdrawn.label', default: 'TradeWithdrawn'), params.id])}"
            redirect(action: "unCheckList")
        }
        else {
            [tradeWithdrawnInstance: tradeWithdrawnInstance]
        }
    }
//单笔初审通过的审批通过
    def pass = {
        def tradeWithdrawnInstance = TradeWithdrawn.get(params.id)
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        tradeWithdrawnInstance.checkStatus = 'checked'
        tradeWithdrawnInstance.handleStatus = 'checked'
        tradeWithdrawnInstance.lastAppName = userName
        tradeWithdrawnInstance.lastAppId = userId
        tradeWithdrawnInstance.lastAppDate = new Date()
        if (tradeWithdrawnInstance.save(flush: true, failOnError: true)) {
            flash.message = "审批处理成功！"
        }
        else {
            flash.message = "审批处理失败！"
        }
        redirect(action: "refuseList")
    }

//初审审批通过
    def check = {
        def tradeWithdrawnInstance = TradeWithdrawn.get(params.id)
        if (tradeWithdrawnInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (tradeWithdrawnInstance.version > version) {

                    tradeWithdrawnInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'tradeWithdrawn.label', default: 'TradeWithdrawn')] as Object[], "Another user has updated this TradeWithdrawn while you were editing")
                    render(view: "checkShow", model: [tradeWithdrawnInstance: tradeWithdrawnInstance])
                    return
                }
            }
            def errorMsg
            if (params.transferFee == null || params.transferFee.trim() == '') {
                errorMsg = "转账手续费不能为空"
            }
            if (params.realTransferAmount == null || params.realTransferAmount.trim() == '') {
                errorMsg = "实际转账金额不能为空"
            }
            if (params.transferFee.toBigDecimal() < 0) {
                errorMsg = "转账手续费不能小于0"
            }
            if (params.realTransferAmount.toBigDecimal() <= 0) {
                errorMsg = "实际转账金额应大于0，请修改实际转账金额！"
            }
            if (errorMsg != null) {
                flash.message = errorMsg
                render(view: "checkShow", model: [tradeWithdrawnInstance: tradeWithdrawnInstance])
                return
            }
            tradeWithdrawnInstance.properties = params
            tradeWithdrawnInstance.transferFee = (params.transferFee.toBigDecimal() * 100.0).toLong()
            tradeWithdrawnInstance.realTransferAmount = (params.realTransferAmount.toBigDecimal() * 100.0).toLong()
            if (tradeWithdrawnInstance.amount != tradeWithdrawnInstance.feeAmount + tradeWithdrawnInstance.transferFee + tradeWithdrawnInstance.realTransferAmount) {
                errorMsg = "实际转账金额应该等于提现金额减去提现手续费和转账手续费"
            }
            if (tradeWithdrawnInstance.acquirerAccountId == null) {
                errorMsg = "收单银行账户不能为空"
            }
            if (errorMsg != null) {
                flash.message = errorMsg
                render(view: "checkShow", model: [tradeWithdrawnInstance: tradeWithdrawnInstance])
                return
            }
            if (errorMsg == null) {
                def op = session.getValue("op")
                def userName = op.account
                def userId = op.id
                tradeWithdrawnInstance.checkStatus = 'checked'
                tradeWithdrawnInstance.handleStatus = 'fChecked'
                tradeWithdrawnInstance.firstAppId = userId
                tradeWithdrawnInstance.firstAppName = userName
                tradeWithdrawnInstance.firstAppDate = new Date()
                println tradeWithdrawnInstance.hasErrors()
                if (!tradeWithdrawnInstance.hasErrors() && tradeWithdrawnInstance.save(flush: true, failOnError: true)) {
                    flash.message = "待处理提现审批通过！"
                    redirect(action: "unCheckList")
                }
                else {
                    render(view: "checkShow", model: [tradeWithdrawnInstance: tradeWithdrawnInstance])
                    return
                }
            }
        }
        else {
            flash.message = "待处理提现审批失败！"
            redirect(action: "unCheckList")
            return
        }
    }

//待处理提现批量审批通过或单笔批量审批通过
    def selectCheck = {
        def id = params.id
        def flag = params.flag
        def bankName = params.bankName
        def boBankDic = BoBankDic.findByCode(bankName)
        def boAcquirerAccountId = params.acquirerAccountId
        def ids = id.toString().substring(0, id.toString().length() - 1)
        def query = "from TradeWithdrawn where id in (${ids})"
        def trade = TradeWithdrawn.findAll(query)
        def count
        def amount = 0
        def type
        if (trade.size() > 0) {
            count = trade.size()
            trade.each {
                amount = amount + (it.amount ? it.amount : 0)
            }
        }
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        def idList = new ArrayList()
        idList = id.split(',')
        if (idList.size() > 0) {
            TradeWithdrawn.withTransaction {
                def withdrawnBatch = new WithdrawnBatch()
                try {
                    if (flag == '1') {
                        withdrawnBatch.batchCount = count
                        withdrawnBatch.batchAmount = amount
                        withdrawnBatch.withdrawnDate = new Date()
                        withdrawnBatch.withdrawnBankName = boBankDic?.name
                        withdrawnBatch.withdrawnBankCode = boBankDic?.code
                        withdrawnBatch.status = 'waiting' //待处理状态
                        withdrawnBatch.appId = userId
                        withdrawnBatch.appName = userName
                        withdrawnBatch.save(flush: true, failOnError: true)
                    }
                    idList.each {
                        def tradeWithdrawnInstance = TradeWithdrawn.get(it)
                        tradeWithdrawnInstance.handleStatus = 'fChecked'
                        tradeWithdrawnInstance.firstAppId = userId
                        tradeWithdrawnInstance.firstAppName = userName
                        tradeWithdrawnInstance.firstAppDate = new Date()
                        tradeWithdrawnInstance.acquirerAccountId = boAcquirerAccountId as Long
                        tradeWithdrawnInstance.realTransferAmount = tradeWithdrawnInstance.amount - tradeWithdrawnInstance.feeAmount
                        if (flag == '1') {
                            tradeWithdrawnInstance.withdrawnBatchNo = withdrawnBatch.id
                        }
                        tradeWithdrawnInstance.save(flush: true, failOnError: true)
                        flash.message = '待审批提现审批通过成功！'
                    }
                } catch (Exception e) {
                    flash.message = e.getMessage()
                }
            }
        } else {
            flash.message = '待审批提现审批通过失败！'
        }
        redirect(action: "unCheckList")
    }

//
    def getAcquireAccountsJson = {
        def bank, allAcquireAccounts
        bank = BoBankDic.findByCode(params.bankCode)
        allAcquireAccounts = BoAcquirerAccount.findAllByBankAndStatus(bank, 'normal')
        render allAcquireAccounts as JSON
    }

//单笔待处理审批拒绝
    def firstCheckUnPass = {
        def tradeWithdrawnInstance = TradeWithdrawn.get(params.id)
        if (tradeWithdrawnInstance) {
            def appNote = AppNote.findByAppId(params.id)
            if (appNote) {
                appNote.appNote = params.appNote
                appNote.appName = 'tradeWithdrawn_first'
            } else {
                appNote = new AppNote()
                appNote.appId = params.id
                appNote.appName = 'tradeWithdrawn_first'
                appNote.appNote = params.appNote
                appNote.status = '2'
            }
            if (!tradeWithdrawnInstance.hasErrors()) {
                try {
                    def op = session.getValue("op")
                    def userName = op.account
                    def userId = op.id
                    tradeWithdrawnInstance.handleStatus = 'fRefuse'
                    tradeWithdrawnInstance.firstAppId = userId
                    tradeWithdrawnInstance.firstAppName = userName
                    tradeWithdrawnInstance.firstAppDate = new Date()
                    tradeWithdrawnInstance.save(flush: true, failOnError: true)
                    flash.message = "待审批提现请求拒绝成功"
                } catch (Exception e) {
                    flash.message = "待审批提现请求拒绝失败，系统异常，${e.getMessage()}，可能需要重新提交"
                    log.warn("check WithDraw error", e)
                }
                redirect(action: "unCheckList")
                return
            }
            else {
                render(view: "checkShow", model: [tradeWithdrawnInstance: tradeWithdrawnInstance])
                return
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeWithdrawn.label', default: 'TradeWithdrawn'), params.id])}"
            redirect(action: "unCheckList")
            return
        }
    }

//审批处理  单笔待处理审批拒绝的审批通过
    def checkFailPass = {
        def flag = '1'
        def tradeWithdrawnInstance = TradeWithdrawn.get(params.id)
        if (tradeWithdrawnInstance) {
            def appNote = AppNote.findByAppId(params.id)
            if (appNote) {
                appNote.appNote = params.appNote
                appNote.appName = 'tradeWithdrawn_second'
            } else {
                appNote = new AppNote()
                appNote.appId = params.id
                appNote.appName = 'tradeWithdrawn_second'
                appNote.appNote = params.appNote
                appNote.status = '2'
            }
            if (!tradeWithdrawnInstance.hasErrors()) {
                try {
                    def op = session.getValue("op")
                    def userName = op.account
                    def userId = op.id
                    tradeWithdrawnInstance.lastAppId = userId
                    tradeWithdrawnInstance.lastAppName = userName
                    tradeService.checkWithDraw(tradeWithdrawnInstance, flag)
                    flash.message = "提现审批拒绝成功"
                } catch (Exception e) {
                    flash.message = "提现审批拒绝失败，系统异常，${e.getMessage()}，可能需要重新提交"
                    log.warn("check WithDraw error", e)
                }
                redirect(action: "refuseList")
                return
            }
            else {
                render(view: "resuseShow", model: [tradeWithdrawnInstance: tradeWithdrawnInstance])
                return
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeWithdrawn.label', default: 'TradeWithdrawn'), params.id])}"
            redirect(action: "refuseList")
            return
        }
    }

//审批处理  单笔待处理审批拒绝的多笔审批通过
    def selectCheckFailPass = {
        def flag = "1"
        def id = params.id
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        def ids = id.toString().substring(0, id.toString().length() - 1)
        def query = "from TradeWithdrawn where id in (${ids})"
        def trade = TradeWithdrawn.findAll(query)
        if (trade.size() > 0) {
            TradeWithdrawn.withTransaction {
                trade.each {
                    try {
                        it.lastAppId = userId
                        it.lastAppName = userName
                        tradeService.checkWithDraw(it, flag)
                        flash.message = "提现审批通过成功！"
                    } catch (Exception e) {
                        flash.message = "提现审批通过失败，系统异常，${e.getMessage()}，可能需要重新提交"
                    }
                }
            }
        } else {
            flash.message = "提现审批通过失败！"
        }
        redirect(action: "refuseList")
    }

//审批处理  待处理审批拒绝的拒绝和待处理审批通过的拒绝，返回上一层处理
    def failOrPassRefuse = {

        def tradeWithdrawnInstance = TradeWithdrawn.get(params.id)
        if (tradeWithdrawnInstance) {
            def appNote = AppNote.findByAppId(params.id)
            if (appNote) {
                appNote.appNote = params.appNote
                appNote.appName = 'tradeWithdrawn_second'
            } else {
                appNote = new AppNote()
                appNote.appId = params.id
                appNote.appName = 'tradeWithdrawn_second'
                appNote.appNote = params.appNote
                appNote.status = '2'
            }
            if (!tradeWithdrawnInstance.hasErrors()) {
                try {
                    def op = session.getValue("op")
                    def userName = op.account
                    def userId = op.id
                    tradeWithdrawnInstance.lastAppId = userId
                    tradeWithdrawnInstance.lastAppName = userName
                    tradeWithdrawnInstance.handleStatus = 'waiting'
                    tradeWithdrawnInstance.save(flush: true, failOnError: true)
                    flash.message = "提现审批处理成功"
                } catch (Exception e) {
                    flash.message = "提现审批处理失败，系统异常，${e.getMessage()}，可能需要重新提交"
                    log.warn("check WithDraw error", e)
                }
                redirect(action: "refuseList")
                return
            }
            else {
                render(view: "resuseShow", model: [tradeWithdrawnInstance: tradeWithdrawnInstance])
                return
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeWithdrawn.label', default: 'TradeWithdrawn'), params.id])}"
            redirect(action: "refuseList")
            return
        }
    }

    def withdraw = {}

    def getCusInfo = {
        def cus = CmCustomer.findByCustomerNo(params.customerNo)
        //println '' + cus + "," + params.customerNo
        if (cus) {
            def acc = AcAccount.findByAccountNo(cus.accountNo)
            def result = "客户名称:${cus instanceof CmCorporationInfo ? cus.registrationName : cus.name}, 账户余额:${acc?.balance / 100}"
            render(contentType: 'text/html', text: result)
        }
        render(contentType: 'text/html', text: '')
    }

    def createWithdraw = {
        def cmCustomer = CmCustomer.findByCustomerNo(params.customerNo)
        if (!cmCustomer) {
            flash.message = "客户不存在。"
            redirect(action: "withdraw")
            return
        }
        def amount = new BigDecimal(params.amount).multiply(new BigDecimal("100"))
        amount= amount.setScale(0, BigDecimal.ROUND_HALF_UP).longValue()
        println "###${amount}"
        def cmCustomerBankAccount = CmCustomerBankAccount.findByCustomerAndIsDefault(cmCustomer, true)
        if (!cmCustomerBankAccount) {
            flash.message = "客户还没有设定提现银行，无法进行提现操作。"
            redirect(action: "withdraw")
            return
        }
        //1.检查账户余额是否足够提现
        def payerAccount = AcAccount.findByAccountNo(cmCustomer.accountNo)
        if (payerAccount.balance < amount) {
            flash.message = "余额不足"
            redirect(action: "withdraw")
            return
        }
        //2.写提现交易表
        //交易号
        def prefix = '12'
        def middle = new java.text.SimpleDateFormat('yyMMdd').format(new Date()) // yymmdd
        def ds = DatasourcesUtils.getDataSource('ismp')
        def sql = new Sql(ds)
        def seq = sql.firstRow('select seq_trade_no.NEXTVAL from DUAL')['NEXTVAL']
        def tradeNo = prefix + middle + seq.toString().padLeft(7, '0')

        def boInnerAccount = BoInnerAccount.findByKey("middleAcc")
        log.info "boInnerAccount=" + boInnerAccount
        def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
        def cmdList = accountClientService.buildTransfer(null, payerAccount.accountNo, boInnerAccount.accountNo, amount, 'withdrawn', tradeNo, '0', "后台手工提现")
        def transResult = accountClientService.batchCommand(commandNo, cmdList)

        if (transResult.result != 'true') {
            flash.message = "手工提现失败，错误码：" + transResult.errorCode + ",错误信息：" + transResult.errorMsg.toString().replaceAll("\"", "") + ""
            log.warn "手工提现失败,${cmdList}"
            redirect(action: "withdraw")
            return
        }

        def today = new Date()
        def trade = new TradeWithdrawn()
        trade.rootId = null
        trade.originalId = null
        trade.tradeNo = tradeNo
        trade.tradeType = 'withdrawn'
        trade.partnerId = null
        trade.payerId = cmCustomer.id
        trade.payerName = cmCustomer.name
        trade.payerCode = cmCustomer.customerNo
        trade.payerAccountNo = cmCustomer.accountNo
        trade.payeeName = boInnerAccount.note
        trade.payeeCode = boInnerAccount.key
        trade.payeeAccountNo = boInnerAccount.accountNo
        trade.outTradeNo = null
        trade.amount = amount
        trade.currency = 'CNY'
        trade.subject = null
        trade.status = 'processing'
        trade.tradeDate = new java.text.SimpleDateFormat('yyyyMMdd').format(today) as Integer
        trade.note = '后台手工提现,' + params.notes
        //提现表属性
        trade.submitType = 'manual'
        trade.customerOperId = 0
        trade.submitter = session.op.name
        trade.transferFee = 0
        trade.realTransferAmount = 0
        trade.customerBankAccountId = cmCustomerBankAccount.id
        trade.customerBankCode = cmCustomerBankAccount.bankCode
        trade.customerBankNo = cmCustomerBankAccount.bankNo
        trade.customerBankAccountName = cmCustomerBankAccount.bankAccountName
        trade.customerBankAccountNo = cmCustomerBankAccount.bankAccountNo
        trade.isCorporate = cmCustomerBankAccount.isCorporate
        trade.handleStatus = 'waiting'
        trade.save flush: true, failOnError: true

        flash.message = "申请提现成功"
        redirect(action: "withdraw")
    }

//提现处理审批拒绝
    def checkRefused = {
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        TradeWithdrawn.withTransaction {
            def appNote = AppNote.findByAppId(params.id)
            if (appNote) {
                appNote.appNote = params.appNote
                appNote.appName = 'tradeWithdrawn_third'
            } else {
                appNote = new AppNote()
                appNote.appId = params.id
                appNote.appName = 'tradeWithdrawn_third'
                appNote.appNote = params.appNote
                appNote.status = '2'
            }
            appNote.save flash: true, flush: true, fieldError: true

            def note = params.note
            println("note:"+note)
            def tradeWithdrawnInstance = TradeWithdrawn.get(params.id)
            //初审通过，只改变单据状态
            tradeWithdrawnInstance.note = note
            tradeWithdrawnInstance.handleStatus = 'fail'
            tradeWithdrawnInstance.withHandleId = userId
            tradeWithdrawnInstance.withHandleName = userName
            tradeWithdrawnInstance.withHandleDate = new Date()
            if (!tradeWithdrawnInstance.hasErrors() && tradeWithdrawnInstance.save(flush: true, failOnError: true)) {
                flash.message = "提现处理拒绝成功！"
            }
            else {
                flash.message = "提现处理拒绝失败！"
                return
            }
        }
        redirect(action: "checkList")
    }
//提现处理审批通过
    def checkPass = {
        def id = params.id
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        def idList = new ArrayList()
        idList = id.split(',')
        TradeWithdrawn.withTransaction {
            if (idList.size() > 0) {
                idList.each {
                    def tradeWithdrawnInstance = TradeWithdrawn.get(it)
                    //初审通过，只改变单据状态
                    tradeWithdrawnInstance.handleStatus = 'success'  //成功状态
                    tradeWithdrawnInstance.withHandleId = userId
                    tradeWithdrawnInstance.withHandleName = userName
                    tradeWithdrawnInstance.withHandleDate = new Date()
                    if (!tradeWithdrawnInstance.hasErrors() && tradeWithdrawnInstance.save(flush: true, failOnError: true)) {
                        flash.message = "提现处理审批通过成功！"
                    }
                    else {
                        flash.message = "提现处理审批通过失败！"
                        return
                    }
                }
            }
        }
        redirect(action: "checkList")
    }

//批量提现成功的复核拒绝及批量提现失败的复核拒绝
    def reCheckRefused = {
        def id = params.id
        def note = params.appNote
        def idList = new ArrayList()
        idList = id.split(',')
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        try {
            TradeWithdrawn.withTransaction {
                if (idList.size() > 0) {
                    idList.each {
                        def appNote = AppNote.findByAppId(it)
                        if (appNote) {
                            appNote.appNote = note
                            appNote.appName = 'tradeWithdrawn_last'
                        } else {
                            appNote = new AppNote()
                            appNote.appId = it
                            appNote.appName = 'tradeWithdrawn_last'
                            appNote.appNote = note
                            appNote.status = '2'
                        }
                        appNote.save(flush: true, failOnError: true)
                        //批量复核拒绝，只改变单据状态
                        def refund = TradeWithdrawn.get(it)
                        refund.handleStatus = 'checked'  //退款失败，返回上一层审批状态
                        refund.withReHandleId = userId
                        refund.withReHandleName = userName
                        refund.withReHandleDate = new Date()
                        refund.save flush: true, failOnError: true
                    }
                }
                flash.message = "退款复核拒绝成功！"
            }
        } catch (Exception e) {
            flash.message = "退款复核失败，${e.getMessage()}，可能需要重新提交"
//            flash.message = "退款复核拒绝失败！"
        }
        redirect(action: "reCheckList")
    }

//复核 失败状态的单子通过
    def reCheckFailPass = {
        def flag = '2' //2表示复核拒绝
        def id = params.id
        def idList = new ArrayList()
        idList = id.split(',')
        if (idList.size() > 0) {
            TradeWithdrawn.withTransaction {
                idList.each {
                    def tradeWithdrawnInstance = TradeWithdrawn.get(it)
                    if (tradeWithdrawnInstance) {
                        try {
                            def op = session.getValue("op")
                            def userName = op.account
                            def userId = op.id
                            tradeWithdrawnInstance.withReHandleId = userId
                            tradeWithdrawnInstance.withReHandleName = userName
                            tradeService.checkWithDraw(tradeWithdrawnInstance, flag)
                            flash.message = "复核提现拒绝成功！"
                        } catch (Exception e) {
                            flash.message = "提现通过失败，${e.getMessage()}，可能需要重新提交"
                        }
                    }
                }
            }
        }
        redirect(action: "reCheckList")
    }

//复核成功状态的通过
    def reCheckSuccessPass = {
        def flag = 0
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        def id = params.id
        def idList = new ArrayList()
        idList = id.split(',')
        if (idList.size() > 0) {
            TradeWithdrawn.withTransaction {
                idList.each {
                    def tradeWithdrawnInstance = TradeWithdrawn.get(it)
                    tradeWithdrawnInstance.checkStatus = 'checked'
                    tradeWithdrawnInstance.withReHandleName = userName
                    tradeWithdrawnInstance.withReHandleId = userId
                    try {
                        tradeService.checkWithDraw(tradeWithdrawnInstance, flag)
                        flash.message = "复核提现通过处理成功！"
                    } catch (Exception e) {
                        flash.message = "复核提现通过失败，系统异常，${e.getMessage()}，可能需要重新提交"
                    }
                }
            }
        }
        redirect(action: "reCheckList")

    }
    def upLoad = {
        // 银行名称
        def bankCode = params.bankCode
        //批次号
        def withdrawnBatchNo = params.withdrawnBatchNo
        if (request instanceof MultipartHttpServletRequest) {
            InputStream is = null
            def resultmsg
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request
            CommonsMultipartFile orginalFile = (CommonsMultipartFile) multiRequest.getFile("myFile")
            // 判断是否上传文件
            if (orginalFile != null && !orginalFile.isEmpty()) {
                //判断当前文件的版本xls,xlxs
                String originalFilename = orginalFile.getOriginalFilename()
                //上传文件
                def extension = originalFilename.substring(originalFilename.indexOf("."))
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMddHHmmssssss")
                String name = bankCode + "-" + sdf.format(new Date()) + "." + extension
                def filepath = request.getRealPath("/") + "/Uploadfile/"
                def filename = filepath + name
                orginalFile.transferTo(new File(filename))
                flash.message = "上传操作成功！"
                redirect(action: "autoCheck", params: ['name': filename, 'withdrawnBatchNo': withdrawnBatchNo, 'bankCode': bankCode, 'extension': extension])
            }
        }
    }
    def autoCheck = {
        def withdrawnBatchNo = params.withdrawnBatchNo
        def bankCode = BoBankDic.get(BoAcquirerAccount.get(params.bankCode as Long)?.bank?.id)?.code
        def errorLine = ''
        def failDetail = []
        def randomNum = GetNumRandom.generateString(10)
        def i = 0
        def j = 0
        if (params.name != null && params.name != '') {
            if (bankCode.toString().equalsIgnoreCase('ccb')) {
                if (params.extension != 'txt') {
                    errorLine = '上传文档的扩展名不正确！'
                } else {
                    try {
                        BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(params.name), "GBK"));
                        for (String line = br.readLine(); line != null; line = br.readLine()) {
                            def tradeWithdrawnFailDetail = new TradeWithdrawnFailDetail()
                            i++
                            def list = new ArrayList()
                            list = line.tokenize('|')
                            def amount = Double.parseDouble(list[2].toString().replaceAll(',', '')) * 100
                            def tradeWithdrawn = TradeWithdrawn.findAllWhere(customerBankAccountNo: list[0], amount: amount as Long, withdrawnBatchNo: withdrawnBatchNo)
                            def status
                            if (list[3] == '成功') {
                                status = 'success'
                            } else {
                                status = 'fail'
                            }
                            if (tradeWithdrawn.size() == 1) {
                                if (tradeWithdrawn[0].handleStatus == 'success' || tradeWithdrawn[0].handleStatus == 'fail') {
                                    j++
                                    tradeWithdrawnFailDetail.num = i
                                    tradeWithdrawnFailDetail.detail = list
                                    tradeWithdrawnFailDetail.reason = '已经被处理过了'
                                    tradeWithdrawnFailDetail.randomNum = randomNum
                                    tradeWithdrawnFailDetail.save(flush: true, failOnError: true)
                                } else if (tradeWithdrawn[0].handleStatus == 'checked') {
                                    tradeWithdrawn[0].handleStatus = status
                                    if (status == 'fail') {
                                        def appNote = AppNote.findByAppId(it)
                                        if (appNote) {
                                            appNote.appNote = list[4]
                                            appNote.appName = 'tradeWithdrawn_third'
                                        } else {
                                            appNote = new AppNote()
                                            appNote.appId = it
                                            appNote.appName = 'tradeWithdrawn_third'
                                            appNote.appNote = list[4]
                                            appNote.status = '2'
                                        }
                                        appNote.save flush: true, failOnError: true
                                    }
                                    tradeWithdrawn[0].save(flush: true, failOnError: true)
                                } else {
                                    j++
                                    tradeWithdrawnFailDetail.num = i
                                    tradeWithdrawnFailDetail.detail = list
                                    tradeWithdrawnFailDetail.reason = '该条记录不是处理中的记录'
                                    tradeWithdrawnFailDetail.randomNum = randomNum
                                    tradeWithdrawnFailDetail.save(flush: true, failOnError: true)
                                }
                            } else if (tradeWithdrawn.size() == 0) {
                                j++
                                tradeWithdrawnFailDetail.num = i
                                tradeWithdrawnFailDetail.detail = list
                                tradeWithdrawnFailDetail.reason = '数据不存在'
                                tradeWithdrawnFailDetail.randomNum = randomNum
                                tradeWithdrawnFailDetail.save(flush: true, failOnError: true)
                            } else {
                                j++
                                tradeWithdrawnFailDetail.num = i
                                tradeWithdrawnFailDetail.detail = list
                                tradeWithdrawnFailDetail.reason = '数据重复'
                                tradeWithdrawnFailDetail.randomNum = randomNum
                                tradeWithdrawnFailDetail.save(flush: true, failOnError: true)
                            }
                        }
                        br.close();
                    }
                    catch (Exception e) {
                        j++
                        flash.message = e.getMessage()
                    }
                }
            }
            if (bankCode.toString().equalsIgnoreCase('icbc')) {
                if (params.extension != 'txt') {
                    errorLine = '上传文档的扩展名不正确！'
                } else {
                    try {
                        BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(params.name), "GBK"));
                        for (String line = br.readLine(); line != null; line = br.readLine()) {
                            def tradeWithdrawnFailDetail = new TradeWithdrawnFailDetail()
                            i++
                            if (i > 4) {
                                def list = new ArrayList()
                                list = line.tokenize('|')
                                def am = list[6].toString().replace('元', '')
                                def amount = Double.parseDouble(am.toString().replaceAll(',', '')) * 100
                                def tradeWithdrawn = TradeWithdrawn.findAllWhere(customerBankAccountNo: list[2], amount: amount as Long, withdrawnBatchNo: withdrawnBatchNo)
                                def status
                                if (list[8] == '处理成功') {
                                    status = 'success'
                                } else {
                                    status = 'fail'
                                }
                                if (tradeWithdrawn.size() == 1) {
                                    if (tradeWithdrawn[0].handleStatus == 'success' || tradeWithdrawn[0].handleStatus == 'fail') {
                                        j++
                                        tradeWithdrawnFailDetail.num = i
                                        tradeWithdrawnFailDetail.detail = list
                                        tradeWithdrawnFailDetail.reason = '已经被处理过了'
                                        tradeWithdrawnFailDetail.randomNum = randomNum
                                        tradeWithdrawnFailDetail.save(flush: true, failOnError: true)
                                    } else if (tradeWithdrawn[0].handleStatus == 'checked') {
                                        tradeWithdrawn[0].handleStatus = status
                                        if (status == 'fail') {
                                            def appNote = AppNote.findByAppId(it)
                                            if (appNote) {
                                                appNote.appNote = list[9]
                                                appNote.appName = 'tradeWithdrawn_third'
                                            } else {
                                                appNote = new AppNote()
                                                appNote.appId = it
                                                appNote.appName = 'tradeWithdrawn_third'
                                                appNote.appNote = list[9]
                                                appNote.status = '2'
                                            }
                                            appNote.save flush: true, failOnError: true
                                        }
                                        tradeWithdrawn[0].save(flush: true, failOnError: true)
                                    } else {
                                        j++
                                        tradeWithdrawnFailDetail.num = i
                                        tradeWithdrawnFailDetail.detail = list
                                        tradeWithdrawnFailDetail.reason = '该条记录不是处理中的记录'
                                        tradeWithdrawnFailDetail.randomNum = randomNum
                                        tradeWithdrawnFailDetail.save(flush: true, failOnError: true)
                                    }
                                } else if (tradeWithdrawn.size() == 0) {
                                    j++
                                    tradeWithdrawnFailDetail.num = i
                                    tradeWithdrawnFailDetail.detail = list
                                    tradeWithdrawnFailDetail.reason = '数据不存在'
                                    tradeWithdrawnFailDetail.randomNum = randomNum
                                    tradeWithdrawnFailDetail.save(flush: true, failOnError: true)
                                } else {
                                    j++
                                    tradeWithdrawnFailDetail.num = i
                                    tradeWithdrawnFailDetail.detail = list
                                    tradeWithdrawnFailDetail.reason = '数据重复'
                                    tradeWithdrawnFailDetail.randomNum = randomNum
                                    tradeWithdrawnFailDetail.save(flush: true, failOnError: true)
                                }
                            }
                        }
                        br.close();
                    }
                    catch (Exception e) {
                        j++
                        flash.message = e.getMessage()
                    }
                    i = i - 4
                }
            }
            if (bankCode.toString().equalsIgnoreCase('abc')) {
                if (params.extension != 'xlsx') {
                    errorLine = '上传文档的扩展名不正确！'
                } else {
                    try {
                        XSSFWorkbook xwb = new XSSFWorkbook(params.name)
                        // 读取第一章表格内容
                        XSSFSheet sheet = xwb.getSheetAt(0)
                        // 定义 row、cell
                        XSSFRow row
                        String cell
                        // 循环输出表格中的内容
                        for (int k = 2; k < sheet.getPhysicalNumberOfRows(); k++) {
                            def tradeWithdrawnFailDetail = new TradeWithdrawnFailDetail()
                            row = sheet.getRow(k);
                            println row.getPhysicalNumberOfCells()
                            // 通过 row.getCell(j).toString() 获取单元格内容，
                            def tradeWithdrawn = TradeWithdrawn.findAllWhere(customerBankAccountNo: row.getCell(4).toString(), amount: Double.parseDouble(row.getCell(7).toString().replaceAll(',', '')) * 100 as Long, withdrawnBatchNo: withdrawnBatchNo)
                            def status
                            if (row.getCell(9).toString() == '批量交易成功') {
                                status = 'success'
                            } else {
                                status = 'fail'
                            }
                            if (tradeWithdrawn.size() == 1) {
                                if (tradeWithdrawn[0].handleStatus == 'success' || tradeWithdrawn[0].handleStatus == 'fail') {
                                    tradeWithdrawnFailDetail.num = k
                                    tradeWithdrawnFailDetail.detail = row.getCell(0).toString() + '，' + row.getCell(1).toString() + '，' + row.getCell(2).toString() + '，' + row.getCell(3).toString() + '，' + row.getCell(4).toString() + row.getCell(5).toString() + '，' + row.getCell(6).toString() + '，' + row.getCell(7).toString() + '，' + row.getCell(8).toString() + '，' + row.getCell(9).toString() + '，' + row.getCell(10).toString() + '，' + row.getCell(11).toString() + '，'
                                    tradeWithdrawnFailDetail.reason = '已经被处理过了'
                                    tradeWithdrawnFailDetail.randomNum = randomNum
                                    tradeWithdrawnFailDetail.save(flush: true, failOnError: true)
                                } else if (tradeWithdrawn[0].handleStatus == 'checked') {
                                    tradeWithdrawn[0].handleStatus = status
                                    if (status == 'fail') {
                                        def appNote = AppNote.findByAppId(it)
                                        if (appNote) {
                                            appNote.appNote = row.getCell(10).toString()
                                            appNote.appName = 'tradeWithdrawn_third'
                                        } else {
                                            appNote = new AppNote()
                                            appNote.appId = it
                                            appNote.appName = 'tradeWithdrawn_third'
                                            appNote.appNote = row.getCell(10).toString()
                                            appNote.status = '2'
                                        }
                                        appNote.save flush: true, failOnError: true
                                    }
                                    tradeWithdrawn[0].save(flush: true, failOnError: true)
                                } else {
                                    j++
                                    tradeWithdrawnFailDetail.num = k
                                    tradeWithdrawnFailDetail.detail = row.getCell(0).toString() + '，' + row.getCell(1).toString() + '，' + row.getCell(2).toString() + '，' + row.getCell(3).toString() + '，' + row.getCell(4).toString() + row.getCell(5).toString() + '，' + row.getCell(6).toString() + '，' + row.getCell(7).toString() + '，' + row.getCell(8).toString() + '，' + row.getCell(9).toString() + '，' + row.getCell(10).toString() + '，' + row.getCell(11).toString() + '，'
                                    tradeWithdrawnFailDetail.reason = '该条记录不是处理中的记录'
                                    tradeWithdrawnFailDetail.randomNum = randomNum
                                    tradeWithdrawnFailDetail.save(flush: true, failOnError: true)
                                }
                            } else if (tradeWithdrawn.size() == 0) {
                                j++
                                tradeWithdrawnFailDetail.num = k
                                tradeWithdrawnFailDetail.detail = row.getCell(0).toString() + '，' + row.getCell(1).toString() + '，' + row.getCell(2).toString() + '，' + row.getCell(3).toString() + '，' + row.getCell(4).toString() + row.getCell(5).toString() + '，' + row.getCell(6).toString() + '，' + row.getCell(7).toString() + '，' + row.getCell(8).toString() + '，' + row.getCell(9).toString() + '，' + row.getCell(10).toString() + '，' + row.getCell(11).toString() + '，'
                                tradeWithdrawnFailDetail.reason = '数据不存在'
                                tradeWithdrawnFailDetail.randomNum = randomNum
                                tradeWithdrawnFailDetail.save(flush: true, failOnError: true)
                            } else {
                                j++
                                tradeWithdrawnFailDetail.num = k
                                tradeWithdrawnFailDetail.detail = row.getCell(0).toString() + '，' + row.getCell(1).toString() + '，' + row.getCell(2).toString() + '，' + row.getCell(3).toString() + '，' + row.getCell(4).toString() + row.getCell(5).toString() + '，' + row.getCell(6).toString() + '，' + row.getCell(7).toString() + '，' + row.getCell(8).toString() + '，' + row.getCell(9).toString() + '，' + row.getCell(10).toString() + '，' + row.getCell(11).toString() + '，'
                                tradeWithdrawnFailDetail.reason = '数据重复'
                                tradeWithdrawnFailDetail.randomNum = randomNum
                                tradeWithdrawnFailDetail.save(flush: true, failOnError: true)
                            }
                        }
                        i = sheet.getPhysicalNumberOfRows() - 2
//                    Workbook workbook = Workbook.getWorkbook(new FileInputStream("c:/a.xls"))
//                    // 获取excel中的sheet
//                    Sheet sheet = workbook.getSheet(0)
//                    for (int row = 2; row < sheet.rows; row++) {
//                        def resName = sheet.getCell(0, row).contents // 注意 这里的0是列 row是行 这是获取第0列的函数 getCell
//                    }
                    } catch (Exception e) {
                        j++
                        errorLine = e.getMessage()
                    }

                }
            }
        }
        if (errorLine != '') {
            flash.message = errorLine
        }
        def query = {
            eq('randomNum', randomNum)
        }
        params.sort = params.sort ? params.sort : "num"
        params.order = params.order ? params.order : "asc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def count = TradeWithdrawnFailDetail.createCriteria().count(query)
        def result = TradeWithdrawnFailDetail.createCriteria().list(params, query)
        [bankCode: params.bankCode, withdrawnBatchNo: withdrawnBatchNo, count: i, failCount: j, errorDetail: result, totalCount: count]
    }

    def selectDl = {
        def id = params.id
        def bankName = params.bankName
        def boBankDic = BoBankDic.findByCode(bankName)
        def acquirerAccountId = params.acquirerAccountId
        id = id.toString().substring(0, id.toString().length() - 1)
        def query = "from TradeWithdrawn where id in (${id})"
        def result = TradeWithdrawn.findAll(query)
        def amount = 0
        def count = result.size() ? result.size() : 0
        if (result.size() > 0) {
            result.each {
                amount += it.amount
            }
        }
        def filename
        if (boBankDic.code.equalsIgnoreCase('icbc')) {
            filename = 'icbc-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.bpt'
            response.contentType = "application/x-rarx-rar-compressed"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            render(template: "icbcList", model: [tradeWithdrawnInstanceList: result, totalAmount: amount, totalCount: count, bankId: boBankDic?.id, acquirerAccountId: acquirerAccountId])
        } else if (boBankDic.code.equalsIgnoreCase('abc')) {
            filename = 'abc-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.txt'
            response.contentType = "text/plain"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            render(template: "abcList", model: [tradeWithdrawnInstanceList: result, totalAmount: amount, totalCount: count])
        } else if (boBankDic.code.equalsIgnoreCase('ccb')) {
            filename = 'ccb-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.txt'
            response.contentType = "text/plain"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            render(template: "ccbList", model: [tradeWithdrawnInstanceList: result, totalAmount: amount, totalCount: count])
        }
    }

}
