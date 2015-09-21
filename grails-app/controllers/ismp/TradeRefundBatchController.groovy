package ismp

import ebank.tools.StringUtil
import boss.AppNote

class TradeRefundBatchController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "refundDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.id != null && params.id != '') {
                eq('id', params.id as long)
            }
            if (params.batchCount != null && params.batchCount != '') {
                like('batchCount', params.batchCount + '%')
            }
            if (params.refundType != null && params.refundType != '') {
                eq('refundType', params.refundType)
            }
            if (params.bankName != null && params.bankName != '') {
                eq('refundBankName', params.bankName)
            }
            if (params.startBatchAmount != null && params.startBatchAmount != '') {
                ge('batchAmount', StringUtil.parseAmountFromStr(params.startBatchAmount))
            }
            if (params.endBatchAmount != null && params.endBatchAmount != '') {
                le('batchAmount', StringUtil.parseAmountFromStr(params.endBatchAmount))
            }
            eq('status', 'waiting')
            validDated(params)
            if (params.startRefundDate) {
                ge('refundDate', Date.parse('yyyy-MM-dd', params.startRefundDate))
            }
            if (params.endRefundDate) {
                lt('refundDate', Date.parse('yyyy-MM-dd', params.endRefundDate) + 1)
            }

        }
        def tradeRefundBatch = TradeRefundBatch.createCriteria().list(params, query)
        def count = TradeRefundBatch.createCriteria().count(query)
        def totalAmAndCo = TradeRefundBatch.createCriteria().get {
            projections {
                and query
                sum('batchAmount')
                rowCount()
            }
        }
        [tradeRefundBatchInstanceList: tradeRefundBatch, tradeRefundBatchInstanceTotal: count, totalAmount: totalAmAndCo[0], totalCount: totalAmAndCo[1]]
    }

    def listDl = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def query = {
            if (params.id != null && params.id != '') {
                eq('id', params.id as long)
            }
            if (params.batchCount != null && params.batchCount != '') {
                like('batchCount', params.batchCount + '%')
            }
            if (params.refundType != null && params.refundType != '') {
                eq('refundType', params.refundType)
            }
            if (params.bankName != null && params.bankName != '') {
                eq('refundBankName', params.bankName)
            }
            if (params.startBatchAmount != null && params.startBatchAmount != '') {
                ge('batchAmount', StringUtil.parseAmountFromStr(params.startBatchAmount))
            }
            if (params.endBatchAmount != null && params.endBatchAmount != '') {
                le('batchAmount', StringUtil.parseAmountFromStr(params.endBatchAmount))
            }
            eq('status', 'waiting')
            validDated(params)
            if (params.startRefundDate) {
                ge('refundDate', Date.parse('yyyy-MM-dd', params.startRefundDate))
            }
            if (params.endRefundDate) {
                lt('refundDate', Date.parse('yyyy-MM-dd', params.endRefundDate) + 1)
            }
        }
        def tradeRefundBatch = TradeRefundBatch.createCriteria().list(params, query)
        def count = TradeRefundBatch.createCriteria().count(query)
        def totalAmAndCo = TradeRefundBatch.createCriteria().get {
            projections {
                and query
                sum('batchAmount')
                rowCount()
            }
        }
        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [tradeRefundBatchInstanceList: tradeRefundBatch, tradeRefundBatchInstanceTotal: count, totalAmount: totalAmAndCo[0], totalCount: totalAmAndCo[1]])
    }

    def create = {
        def tradeRefundBatchInstance = new TradeRefundBatch()
        tradeRefundBatchInstance.properties = params
        return [tradeRefundBatchInstance: tradeRefundBatchInstance]
    }

    def save = {
        def tradeRefundBatchInstance = new TradeRefundBatch(params)
        if (tradeRefundBatchInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'tradeRefundBatch.label', default: 'TradeRefundBatch'), tradeRefundBatchInstance.id])}"
            redirect(action: "list", id: tradeRefundBatchInstance.id)
        }
        else {
            render(view: "create", model: [tradeRefundBatchInstance: tradeRefundBatchInstance])
        }
    }

    def batchDetailShow = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def refundBatchNo = params.id
        def query = {
            eq('refundBatchNo', refundBatchNo)
        }
        def totalCount = TradeRefund.createCriteria().count(query)
        def totalAmount = TradeRefund.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def tradeRefund = TradeRefund.createCriteria().list(params, query)
        render(view: "show", model: [tradeRefundBatchInstance: tradeRefund, totalCount: totalCount, totalAmount: totalAmount, refundBatchNo: refundBatchNo])
    }

    //审批通过
    def batchCheck = {
        def id = params.id
        try {
            def op = session.getValue("op")
            def userName = op.account
            def userId = op.id
            def refundBatchNo = TradeRefundBatch.get(id)
            if (!refundBatchNo) {
                flash.message = "批次不存在"
                redirect(action: "list")
            }
            def tradeRefund = TradeRefund.findAllByRefundBatchNo(id)
            if (tradeRefund.size() > 0) {
                TradeRefund.withTransaction {
                    refundBatchNo.status = 'approved'
                    refundBatchNo.save flush: true, failOnError: true, flash: true
                    tradeRefund.each {
                        it.lastAppDate = new Date()
                        it.lastAppName = userName
                        it.lastAppId = userId
                        it.handleStatus = 'checked'
                        it.save flush: true, failOnError: true
                    }
                }
            }
            flash.message = "批量退款审批通过成功！"
        } catch (Exception e) {
            flash.message = "退款失败，${e.getMessage()}，可能需要重新提交"
            log.warn("check Refund error", e)
        }
        redirect(action: "list")
        return
    }
//审批拒绝
    def selectCheckRefuse = {
        //退款订单ID
        def id = params.id
        //批次号
        def pcNo = params.refundBatchNo
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        def refundBatchNo = TradeRefundBatch.get(pcNo)
        if (!refundBatchNo) {
            flash.message = "批次不存在"
            redirect(action: "list")
        }
        def tradeRefund = TradeRefund.findAllByRefundBatchNo(pcNo)
        try {
            if (tradeRefund.size() > 0) {
                TradeRefund.withTransaction {
                    refundBatchNo.status = 'refused'
                    refundBatchNo.save(flush: true, failOnError: true)
                    def appNote = AppNote.findByAppId(id)
                    if (appNote) {
                        appNote.appNote = params.note
                        appNote.appName = 'tradeRefund_first'
                    } else {
                        appNote = new AppNote()
                        appNote.appId = id
                        appNote.appName = 'tradeRefund_first'
                        appNote.appNote = params.note
                        appNote.status = '2'
                    }
                    appNote.save(flush: true, failOnError: true)
                    tradeRefund.each {
                        it.lastAppDate = new Date()
                        it.lastAppName = userName
                        it.lastAppId = userId
                        it.handleStatus = 'waiting'
                        it.refundBatchNo = ''
                        it.save flush: true
                    }
                }
            }
            flash.message = "批量退款拒绝成功！"
        } catch (Exception e) {
            flash.message = "批量退款失败，${e.getMessage()}，可能需要重新提交"
        }

        redirect(action: "list")
    }

    def batchRefundList = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def query = {
            if (params.id != null && params.id != '') {
                eq('id', params.id)
            }
            if (params.batchCount != null && params.batchCount != '') {
                like('batchCount', params.batchCount + '%')
            }
            if (params.refundType != null && params.refundType != '') {
                eq('refundType', params.refundType)
            }
            if (params.bankName != null && params.bankName != '') {
                eq('refundBankName', params.bankName)
            }
            if (params.startBatchAmount != null && params.startBatchAmount != '') {
                ge('batchAmount', StringUtil.parseAmountFromStr(params.startBatchAmount))
            }
            if (params.endBatchAmount != null && params.endBatchAmount != '') {
                le('batchAmount', StringUtil.parseAmountFromStr(params.endBatchAmount))
            }
            eq('status', 'approved')
            validDated(params)
            if (params.startRefundDate) {
                ge('refundDate', Date.parse('yyyy-MM-dd', params.startRefundDate))
            }
            if (params.endRefundDate) {
                lt('refundDate', Date.parse('yyyy-MM-dd', params.endRefundDate) + 1)
            }
        }
        def tradeRefundBatch = TradeRefundBatch.createCriteria().list(params, query)
        def count = TradeRefundBatch.createCriteria().count(query)
        def totalAmAndCo = TradeRefundBatch.createCriteria().get {
            projections {
                and query
                sum('batchAmount')
                rowCount()
            }
        }
        [tradeRefundBatchInstanceList: tradeRefundBatch, tradeRefundBatchInstanceTotal: count, totalAmount: totalAmAndCo[0], totalCount: totalAmAndCo[1]]
    }

    def show = {
        def tradeRefundBatchInstance = TradeRefundBatch.get(params.id)
        if (!tradeRefundBatchInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeRefundBatch.label', default: 'TradeRefundBatch'), params.id])}"
            redirect(action: "list")
        }
        else {
            [tradeRefundBatchInstance: tradeRefundBatchInstance]
        }
    }

    def edit = {
        def tradeRefundBatchInstance = TradeRefundBatch.get(params.id)
        if (!tradeRefundBatchInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeRefundBatch.label', default: 'TradeRefundBatch'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [tradeRefundBatchInstance: tradeRefundBatchInstance]
        }
    }

    def update = {
        def tradeRefundBatchInstance = TradeRefundBatch.get(params.id)
        if (tradeRefundBatchInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (tradeRefundBatchInstance.version > version) {

                    tradeRefundBatchInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'tradeRefundBatch.label', default: 'TradeRefundBatch')] as Object[], "Another user has updated this TradeRefundBatch while you were editing")
                    render(view: "edit", model: [tradeRefundBatchInstance: tradeRefundBatchInstance])
                    return
                }
            }
            tradeRefundBatchInstance.properties = params
            if (!tradeRefundBatchInstance.hasErrors() && tradeRefundBatchInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'tradeRefundBatch.label', default: 'TradeRefundBatch'), tradeRefundBatchInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [tradeRefundBatchInstance: tradeRefundBatchInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeRefundBatch.label', default: 'TradeRefundBatch'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def tradeRefundBatchInstance = TradeRefundBatch.get(params.id)
        if (tradeRefundBatchInstance) {
            try {
                tradeRefundBatchInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'tradeRefundBatch.label', default: 'TradeRefundBatch'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'tradeRefundBatch.label', default: 'TradeRefundBatch'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeRefundBatch.label', default: 'TradeRefundBatch'), params.id])}"
            redirect(action: "list")
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
    def validDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startRefundDate==null && params.endRefundDate==null) {
            def gCalendar = new GregorianCalendar()
            params.endRefundDate = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startRefundDate = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startRefundDate && !params.endRefundDate) {
            params.endRefundDate = params.startRefundDate
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startRefundDate && params.endRefundDate) {
            params.startRefundDate = params.endRefundDate
        }
        if (params.startRefundDate && params.endRefundDate) {

        }
    }

}
