package ismp

class CmOpRelationController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def query = {
            if (params.controllers) {
                like('controllers', "%"+params.controllers+"%")
            }
            if (params.actions) {
                like('actions', "%"+params.actions+"%")
            }
            if (params.names) {
                like('names', "%"+params.names+"%")
            }
        }
        def total = CmOpRelation.createCriteria().count(query)
        def gwOrderList = CmOpRelation.createCriteria().list(params, query)
        [cmOpRelationInstanceList: gwOrderList, cmOpRelationInstanceTotal: total]
    }

    def listDownload = {

        params.order = params.order ? params.order : "desc"
        params.max = 1000
        params.offset = 0

        def query = {
            if (params.controllers) {
                like('controllers', "%"+params.controllers+"%")
            }
            if (params.actions) {
                like('actions', "%"+params.actions+"%")
            }
            if (params.names) {
                like('names', "%"+params.names+"%")
            }
        }
        def opRelationList = CmOpRelation.createCriteria().list(params, query)
        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "list", model: [opRelationList: opRelationList])
    }

    def create = {
        def cmOpRelationInstance = new CmOpRelation()
        cmOpRelationInstance.properties = params
        return [cmOpRelationInstance: cmOpRelationInstance]
    }

    def save = {
        def cmOpRelationInstance = new CmOpRelation(params)
        if (cmOpRelationInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'cmOpRelation.label', default: 'CmOpRelation'), cmOpRelationInstance.id])}"
            redirect(action: "list", id: cmOpRelationInstance.id)
        }
        else {
            render(view: "create", model: [cmOpRelationInstance: cmOpRelationInstance])
        }
    }

    def show = {
        def cmOpRelationInstance = CmOpRelation.get(params.id)
        if (!cmOpRelationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmOpRelation.label', default: 'CmOpRelation'), params.id])}"
            redirect(action: "list")
        }
        else {
            [cmOpRelationInstance: cmOpRelationInstance]
        }
    }

    def edit = {
        def cmOpRelationInstance = CmOpRelation.get(params.id)
        if (!cmOpRelationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmOpRelation.label', default: 'CmOpRelation'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [cmOpRelationInstance: cmOpRelationInstance]
        }
    }

    def update = {
        def cmOpRelationInstance = CmOpRelation.get(params.id)
        if (cmOpRelationInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (cmOpRelationInstance.version > version) {

                    cmOpRelationInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'cmOpRelation.label', default: 'CmOpRelation')] as Object[], "Another user has updated this CmOpRelation while you were editing")
                    render(view: "edit", model: [cmOpRelationInstance: cmOpRelationInstance])
                    return
                }
            }
            cmOpRelationInstance.properties = params
            if (!cmOpRelationInstance.hasErrors() && cmOpRelationInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'cmOpRelation.label', default: 'CmOpRelation'), cmOpRelationInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [cmOpRelationInstance: cmOpRelationInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmOpRelation.label', default: 'CmOpRelation'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def cmOpRelationInstance = CmOpRelation.get(params.id)
        if (cmOpRelationInstance) {
            try {
                cmOpRelationInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'cmOpRelation.label', default: 'CmOpRelation'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'cmOpRelation.label', default: 'CmOpRelation'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmOpRelation.label', default: 'CmOpRelation'), params.id])}"
            redirect(action: "list")
        }
    }
}
