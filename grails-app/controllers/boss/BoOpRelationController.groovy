package boss

class BoOpRelationController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST",listDownload:"POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def query = {
            if (params.controllers) {
                like("controllers","%"+params.controllers+"%")
            }
            if (params.actions) {
                like('actions', "%"+params.actions+"%")
            }
            if (params.names) {
                like('names', "%"+params.names+"%")
            }
        }
        def total = BoOpRelation.createCriteria().count(query)
        def gwOrderList = BoOpRelation.createCriteria().list(params, query)
        [boOpRelationInstanceList: gwOrderList, boOpRelationInstanceTotal: total]
    }

    def listDownload = {
        params.order = params.order ? params.order : "desc"
        params.max = 5000
        params.offset = 0
        def query = {
            if (params.controllers) {
                like("controllers","%"+params.controllers+"%")
            }
            if (params.actions) {
                like('actions', "%"+params.actions+"%")
            }
            if (params.names) {
                like('names', "%"+params.names+"%")
            }
        }
        def opRelationList = BoOpRelation.createCriteria().list(params, query)
        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "list", model: [opRelationList: opRelationList])
    }

    def create = {
        def boOpRelationInstance = new BoOpRelation()
        boOpRelationInstance.properties = params
        return [boOpRelationInstance: boOpRelationInstance]
    }

    def save = {
        def boOpRelationInstance = new BoOpRelation(params)
        if (boOpRelationInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boOpRelation.label', default: 'BoOpRelation'), boOpRelationInstance.id])}"
            redirect(action: "list", id: boOpRelationInstance.id)
        }
        else {
            render(view: "create", model: [boOpRelationInstance: boOpRelationInstance])
        }
    }

    def show = {
        def boOpRelationInstance = BoOpRelation.get(params.id)
        if (!boOpRelationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOpRelation.label', default: 'BoOpRelation'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boOpRelationInstance: boOpRelationInstance]
        }
    }

    def edit = {
        def boOpRelationInstance = BoOpRelation.get(params.id)
        if (!boOpRelationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOpRelation.label', default: 'BoOpRelation'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [boOpRelationInstance: boOpRelationInstance]
        }
    }

    def update = {
        def boOpRelationInstance = BoOpRelation.get(params.id)
        if (boOpRelationInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boOpRelationInstance.version > version) {

                    boOpRelationInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boOpRelation.label', default: 'BoOpRelation')] as Object[], "Another user has updated this BoOpRelation while you were editing")
                    render(view: "edit", model: [boOpRelationInstance: boOpRelationInstance])
                    return
                }
            }
            boOpRelationInstance.properties = params
            if (!boOpRelationInstance.hasErrors() && boOpRelationInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boOpRelation.label', default: 'BoOpRelation'), boOpRelationInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boOpRelationInstance: boOpRelationInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOpRelation.label', default: 'BoOpRelation'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def boOpRelationInstance = BoOpRelation.get(params.id)
        if (boOpRelationInstance) {
            try {
                boOpRelationInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boOpRelation.label', default: 'BoOpRelation'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boOpRelation.label', default: 'BoOpRelation'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOpRelation.label', default: 'BoOpRelation'), params.id])}"
            redirect(action: "list")
        }
    }
}
