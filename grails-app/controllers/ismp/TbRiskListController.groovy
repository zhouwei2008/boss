package ismp

import java.text.SimpleDateFormat

class TbRiskListController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "createdDate"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def max = params.max
        def offset =  params.offset

        def query = {

            if(params.serialNo !=null && params.serialNo != ''){
                like("serialNo","%" +params.serialNo.trim()+ "%")
            }

            if (params.startDate != null && params.startDate != '') {
                gt("tradeDate", new Date(new SimpleDateFormat("yyyy-MM-dd").parse(params.startDate).getTime()))
            }

            if (params.endDate != null && params.endDate != '') {
                lt("tradeDate", new Date(new SimpleDateFormat("yyyy-MM-dd").parse(params.endDate).getTime()))
            }

            if (params.tradeType != null && params.tradeType != '') {
                eq("tradeType", params.tradeType.trim())
            }

            if(params.merchantName !=null && params.merchantName != ''){
                like("merchantName","%" +params.merchantName.trim()+ "%")
            }

            if(params.beginAmount != null && params.beginAmount != ''){
                ge("amount",Long.valueOf(params.beginAmount))
            }

            if(params.endAmount != null && params.endAmount != ''){
                le("amount",Long.valueOf(params.endAmount))
            }

            if (params.riskControlId != null && params.riskControlId != '') {
                eq("riskControl.id", Long.valueOf(params.riskControlId.trim()))
            }

            firstResult(offset)
            maxResults(max)
            order("tradeDate", "desc")
        }
        def cmCustomerInstance = TbRiskList.createCriteria().list(query)
        def  total = TbRiskList.createCriteria().count {
            if(params.serialNo !=null && params.serialNo != ''){
                like("serialNo","%" +params.serialNo.trim()+ "%")
            }

            if (params.startDate != null && params.startDate != '') {
                gt("tradeDate", new Date(new SimpleDateFormat("yyyy-MM-dd").parse(params.startDate).getTime()))
            }

            if (params.endDate != null && params.endDate != '') {
                lt("tradeDate", new Date(new SimpleDateFormat("yyyy-MM-dd").parse(params.endDate).getTime()))
            }

            if (params.tradeType != null && params.tradeType != '') {
                eq("tradeType", params.tradeType.trim())
            }

            if(params.merchantName !=null && params.merchantName != ''){
                like("merchantName","%" +params.merchantName.trim()+ "%")
            }

            if(params.beginAmount != null && params.beginAmount != ''){
                ge("amount",Long.valueOf(params.beginAmount))
            }

            if(params.endAmount != null && params.endAmount != ''){
                le("amount",Long.valueOf(params.endAmount))
            }

            if (params.riskControlId != null && params.riskControlId != '') {
                eq("riskControl.id", Long.valueOf(params.riskControlId.trim()))
            }
        }

        [tbRiskListInstanceList: cmCustomerInstance, tbRiskListInstanceTotal: total]
    }

    def listDownload = {

        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = 10000
        params.offset = 0

         def query = {

            if(params.serialNo !=null && params.serialNo != ''){
                like("serialNo","%" +params.serialNo.trim()+ "%")
            }

            if (params.startDate != null && params.startDate != '') {
                gt("tradeDate", new Date(new SimpleDateFormat("yyyy-MM-dd").parse(params.startDate).getTime()))
            }

            if (params.endDate != null && params.endDate != '') {
                lt("tradeDate", new Date(new SimpleDateFormat("yyyy-MM-dd").parse(params.endDate).getTime()))
            }

            if (params.tradeType != null && params.tradeType != '') {
                eq("tradeType", params.tradeType.trim())
            }

            if(params.merchantName !=null && params.merchantName != ''){
                like("merchantName","%" +params.merchantName.trim()+ "%")
            }

            if(params.beginAmount != null && params.beginAmount != ''){
                ge("amount",Long.valueOf(params.beginAmount))
            }

            if(params.endAmount != null && params.endAmount != ''){
                le("amount",Long.valueOf(params.endAmount))
            }

            if (params.riskControlId != null && params.riskControlId != '') {
                eq("riskControl.id", Long.valueOf(params.riskControlId.trim()))
            }

            order("tradeDate", "desc")
        }
        def tbRiskList = TbRiskList.createCriteria().list(query)

        def filename = 'RiskList-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "list", model: [tbRiskListInstanceList: tbRiskList])
    }

    def create = {
        def tbRiskListInstance = new TbRiskList()
        tbRiskListInstance.properties = params
        return [tbRiskListInstance: tbRiskListInstance]
    }

    def save = {
            def tbRiskListInstance = new TbRiskList(params)
            if (tbRiskListInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.created.message', args: [message(code: 'tbRiskList.label', default: 'TbRiskList'), tbRiskListInstance.id])}"
                redirect(action: "list", id: tbRiskListInstance.id)
        } else {
            render(view: "create", model: [tbRiskListInstance: tbRiskListInstance])
        }
    }

    def show = {
        def tbRiskListInstance = TbRiskList.get(params.id)
        if (!tbRiskListInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbRiskList.label', default: 'TbRiskList'), params.id])}"
            redirect(action: "list")
        } else {
            [tbRiskListInstance: tbRiskListInstance]
        }
    }

    def edit = {
        def tbRiskListInstance = TbRiskList.get(params.id)
        if (!tbRiskListInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbRiskList.label', default: 'TbRiskList'), params.id])}"
            redirect(action: "list")
        } else {
            return [tbRiskListInstance: tbRiskListInstance]
        }
    }

    def update = {
        def tbRiskListInstance = TbRiskList.get(params.id)
        if (tbRiskListInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (tbRiskListInstance.version > version) {

                    tbRiskListInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'tbRiskList.label', default: 'TbRiskList')] as Object[], "Another user has updated this TbRiskList while you were editing")
                    render(view: "edit", model: [tbRiskListInstance: tbRiskListInstance])
                    return
                }
            }
            tbRiskListInstance.properties = params
            if (!tbRiskListInstance.hasErrors() && tbRiskListInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'tbRiskList.label', default: 'TbRiskList'), tbRiskListInstance.id])}"
                redirect(action: "list")
            } else {
                render(view: "edit", model: [tbRiskListInstance: tbRiskListInstance])
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbRiskList.label', default: 'TbRiskList'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def tbRiskListInstance = TbRiskList.get(params.id)
        if (tbRiskListInstance) {
            try {
                tbRiskListInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'tbRiskList.label', default: 'TbRiskList'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'tbRiskList.label', default: 'TbRiskList'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbRiskList.label', default: 'TbRiskList'), params.id])}"
            redirect(action: "list")
        }
    }
}
