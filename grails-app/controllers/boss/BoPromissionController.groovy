package boss

class BoPromissionController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        def sql="select t,rownum from BoPromission t where 1=1 order by t.promissionCode asc ,t.id desc"
        def list = BoPromission.executeQuery(sql)
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [boPromissionInstanceList: BoPromission.list(params), boPromissionInstanceTotal: BoPromission.count()]
    }
    def addPromission = {
        def roleId = params.uid
        def str = params.permId
//        println str
        params.max = 1000
        params.offset = 0
        def query = {
            eq('status', '1')
        }
        def sql="select t from BoPromission t where t.status='1' order by t.promissionCode asc ,t.id desc"
        def list = BoPromission.executeQuery(sql)
        def total = BoPromission.createCriteria().count(query)
        def results = BoPromission.createCriteria().list(params, query)
        [boPromissionInstanceList: list, boPromissionInstanceTotal: total, roleId: roleId, promission: str]
    }

    def updatePromission = {
        def boRoleInstance = BoRole.get(params.roleId)
        def box = params.box.toString()
        box = box.replace("[", "")
        box = box.replace("]", "")
        println box
        boRoleInstance.setPermission_id(box)
        redirect(controller: "boRole", action: "list")
//        render(view: "list", model: [boPromissionInstance: boPromissionInstance])
    }

    def create = {
        def boPromissionInstance = new BoPromission()
        params.setProperty("role_id", "0")
        boPromissionInstance.properties = params
        return [boPromissionInstance: boPromissionInstance]
    }

    def save = {
        def boPromissionInstance = new BoPromission(params)
        if (boPromissionInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boPromission.label', default: 'BoPromission'), boPromissionInstance.id])}"
            redirect(action: "list", id: boPromissionInstance.id)
        }
        else {
            render(view: "create", model: [boPromissionInstance: boPromissionInstance])
        }
    }

    def show = {
        def boPromissionInstance = BoPromission.get(params.id)
        if (!boPromissionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boPromission.label', default: 'BoPromission'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boPromissionInstance: boPromissionInstance]
        }
    }

    def edit = {
        def boPromissionInstance = BoPromission.get(params.id)
        if (!boPromissionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boPromission.label', default: 'BoPromission'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [boPromissionInstance: boPromissionInstance]
        }
    }

    def update = {
        def boPromissionInstance = BoPromission.get(params.id)
        if (boPromissionInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boPromissionInstance.version > version) {

                    boPromissionInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boPromission.label', default: 'BoPromission')] as Object[], "Another user has updated this BoPromission while you were editing")
                    render(view: "edit", model: [boPromissionInstance: boPromissionInstance])
                    return
                }
            }
            boPromissionInstance.properties = params
            if (!boPromissionInstance.hasErrors() && boPromissionInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boPromission.label', default: 'BoPromission'), boPromissionInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boPromissionInstance: boPromissionInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boPromission.label', default: 'BoPromission'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def boPromissionInstance = BoPromission.get(params.id)
        if (boPromissionInstance) {
            try {
                boPromissionInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boPromission.label', default: 'BoPromission'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boPromission.label', default: 'BoPromission'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boPromission.label', default: 'BoPromission'), params.id])}"
            redirect(action: "list")
        }
    }
}
