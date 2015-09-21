package ismp

import ebank.tools.StringUtil
import boss.AppNote

class WithdrawnBatchController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "withdrawnDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.offset = params.offset ? params.int('offset') : 0
        params.cache = true
        def query = {
            if (params.id != null && params.id != '') {
                sqlRestriction "to_char(id) like '%" + params.id + "%'"
            }
            if (params.batchCount != null && params.batchCount != '') {
                like('batchCount', params.batchCount + '%')
            }
            if (params.bankName != null && params.bankName != '') {
                eq('withdrawnBankName', params.bankName)
            }
            if (params.startBatchAmount != null && params.startBatchAmount != '') {
                ge('batchAmount', StringUtil.parseAmountFromStr(params.startBatchAmount))
            }
            if (params.endBatchAmount != null && params.endBatchAmount != '') {
                le('batchAmount', StringUtil.parseAmountFromStr(params.endBatchAmount))
            }
            eq('status', 'waiting')
            validDated(params)
            if (params.startWithdrawnDate) {
                ge('withdrawnDate', Date.parse('yyyy-MM-dd HH:mm:ss', params.startWithdrawnDate))
            }
            if(params.endWithdrawnDate) {
                lt('withdrawnDate', Date.parse('yyyy-MM-dd HH:mm:ss', params.endWithdrawnDate))
            }
        }
        def withdrawnBatch = WithdrawnBatch.createCriteria().list(params, query)
        def count = WithdrawnBatch.createCriteria().count(query)
        def totalAmAndCo = WithdrawnBatch.createCriteria().get {
            projections {
                and query
                sum('batchAmount')
                rowCount()
            }
        }
        [withdrawnBatchInstanceList: withdrawnBatch, withdrawnBatchInstanceTotal: count, totalAmount: totalAmAndCo[0], totalCount: totalAmAndCo[1]]
    }

    def listDl = {
        params.sort = params.sort ? params.sort : "withdrawnDate"
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
            if (params.bankName != null && params.bankName != '') {
                eq('withdrawnBankName', params.bankName)
            }
            if (params.startBatchAmount != null && params.startBatchAmount != '') {
                ge('batchAmount', StringUtil.parseAmountFromStr(params.startBatchAmount))
            }
            if (params.endBatchAmount != null && params.endBatchAmount != '') {
                le('batchAmount', StringUtil.parseAmountFromStr(params.endBatchAmount))
            }
            eq('status', 'waiting')
            validDated(params)
           if (params.startWithdrawnDate) {
                ge('withdrawnDate', Date.parse('yyyy-MM-dd HH:mm:ss', params.startWithdrawnDate))
            }
            if(params.endWithdrawnDate) {
                lt('withdrawnDate', Date.parse('yyyy-MM-dd HH:mm:ss', params.endWithdrawnDate))
            }
        }
        def withdrawnBatch = WithdrawnBatch.createCriteria().list(params, query)
        def count = WithdrawnBatch.createCriteria().count(query)
        def totalAmAndCo = WithdrawnBatch.createCriteria().get {
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
        render(template: "tradeList", model: [withdrawnBatchInstanceList: withdrawnBatch, withdrawnBatchInstanceTotal: count, totalAmount: totalAmAndCo[0], totalCount: totalAmAndCo[1]])
    }

    def create = {
        def withdrawnBatchInstance = new WithdrawnBatch()
        withdrawnBatchInstance.properties = params
        return [withdrawnBatchInstance: withdrawnBatchInstance]
    }

    def save = {
        def withdrawnBatchInstance = new WithdrawnBatch(params)
        if (withdrawnBatchInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'withdrawnBatch.label', default: 'WithdrawnBatch'), withdrawnBatchInstance.id])}"
            redirect(action: "list", id: withdrawnBatchInstance.id)
        }
        else {
            render(view: "create", model: [withdrawnBatchInstance: withdrawnBatchInstance])
        }
    }

    def show = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def withdrawnBatchNo = params.id
        def query = {
            eq('withdrawnBatchNo', withdrawnBatchNo)
        }
        def totalCount = TradeWithdrawn.createCriteria().count(query)
        def totalAmount = TradeWithdrawn.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def tradeWithdrawn = TradeWithdrawn.createCriteria().list(params, query)
        render(view: "show", model: [tradeWithdrawnBatchInstance: tradeWithdrawn, totalCount: totalCount, totalAmount: totalAmount, withdrawnBatchNo: withdrawnBatchNo])
    }

    //审批通过
    def batchCheck = {
        def id = params.id
        try {
            def op = session.getValue("op")
            def userName = op.account
            def userId = op.id
            def withdrawnBatchNo = WithdrawnBatch.get(id)
            if (!withdrawnBatchNo) {
                flash.message = "批次不存在"
                redirect(action: "list")
            }
            def tradeWithdrawn = TradeWithdrawn.findAllByWithdrawnBatchNo(id)
            if (tradeWithdrawn.size() > 0) {
                TradeWithdrawn.withTransaction {
                    withdrawnBatchNo.status = 'approved'
                    withdrawnBatchNo.save flush: true, failOnError: true, flash: true
                    tradeWithdrawn.each {
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
        def pcNo = params.withdrawnBatchNo
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        def withdrawnBatchNo = WithdrawnBatch.get(pcNo)
        if (!withdrawnBatchNo) {
            flash.message = "批次不存在"
            redirect(action: "list")
        }
        def tradeWithdrawn = TradeWithdrawn.findAllByWithdrawnBatchNo(pcNo)
        try {
            if (tradeWithdrawn.size() > 0) {
                TradeWithdrawn.withTransaction {
                    withdrawnBatchNo.status = 'refused'
                    withdrawnBatchNo.save(flush: true, failOnError: true)
                    def appNote = AppNote.findByAppId(id)
                    if (appNote) {
                        appNote.appNote = params.note
                        appNote.appName = 'tradeWithdrawn_first'
                    } else {
                        appNote = new AppNote()
                        appNote.appId = id
                        appNote.appName = 'tradeWithdrawn_first'
                        appNote.appNote = params.note
                        appNote.status = '2'
                    }
                    appNote.save(flush: true, failOnError: true)
                    tradeWithdrawn.each {
                        it.lastAppDate = new Date()
                        it.lastAppName = userName
                        it.lastAppId = userId
                        it.handleStatus = 'waiting'
                        it.withdrawnBatchNo = ''
                        it.save flush: true
                    }
                }
            }
            flash.message = "批量提现拒绝成功！"
        } catch (Exception e) {
            flash.message = "批量提现失败，${e.getMessage()}，可能需要重新提交"
        }

        redirect(action: "list")
    }

    def edit = {
        def withdrawnBatchInstance = WithdrawnBatch.get(params.id)
        if (!withdrawnBatchInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'withdrawnBatch.label', default: 'WithdrawnBatch'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [withdrawnBatchInstance: withdrawnBatchInstance]
        }
    }

    def update = {
        def withdrawnBatchInstance = WithdrawnBatch.get(params.id)
        if (withdrawnBatchInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (withdrawnBatchInstance.version > version) {

                    withdrawnBatchInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'withdrawnBatch.label', default: 'WithdrawnBatch')] as Object[], "Another user has updated this WithdrawnBatch while you were editing")
                    render(view: "edit", model: [withdrawnBatchInstance: withdrawnBatchInstance])
                    return
                }
            }
            withdrawnBatchInstance.properties = params
            if (!withdrawnBatchInstance.hasErrors() && withdrawnBatchInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'withdrawnBatch.label', default: 'WithdrawnBatch'), withdrawnBatchInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [withdrawnBatchInstance: withdrawnBatchInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'withdrawnBatch.label', default: 'WithdrawnBatch'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def withdrawnBatchInstance = WithdrawnBatch.get(params.id)
        if (withdrawnBatchInstance) {
            try {
                withdrawnBatchInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'withdrawnBatch.label', default: 'WithdrawnBatch'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'withdrawnBatch.label', default: 'WithdrawnBatch'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'withdrawnBatch.label', default: 'WithdrawnBatch'), params.id])}"
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
        if (params.startWithdrawnDate==null && params.endWithdrawnDate==null) {
            def gCalendar = new GregorianCalendar()
            params.endWithdrawnDate = gCalendar.time.format('yyyy-MM-dd HH:mm:ss')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startWithdrawnDate = gCalendar.time.format('yyyy-MM-dd HH:mm:ss')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startWithdrawnDate && !params.endWithdrawnDate) {
            params.endWithdrawnDate = params.startWithdrawnDate
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startWithdrawnDate && params.endWithdrawnDate) {
            params.startWithdrawnDate = params.endWithdrawnDate
        }
        if (params.startWithdrawnDate && params.endWithdrawnDate) {

        }
    }
}
