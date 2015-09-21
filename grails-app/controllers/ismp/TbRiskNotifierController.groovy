package ismp

class TbRiskNotifierController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [tbRiskNotifierInstanceList: TbRiskNotifier.list(params), tbRiskNotifierInstanceTotal: TbRiskNotifier.count()]
    }

    def create = {
        def tbRiskNotifierInstance = new TbRiskNotifier()
        tbRiskNotifierInstance.properties = params
        return [tbRiskNotifierInstance: tbRiskNotifierInstance]
    }

    def save = {
        def tbRiskNotifierInstance = new TbRiskNotifier(params)
        if (tbRiskNotifierInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'tbRiskNotifier.label', default: 'TbRiskNotifier'), tbRiskNotifierInstance.id])}"
            redirect(action: "list", id: tbRiskNotifierInstance.id)
        } else {
            render(view: "create", model: [tbRiskNotifierInstance: tbRiskNotifierInstance])
        }
    }

    def show = {
        def tbRiskNotifierInstance = TbRiskNotifier.get(params.id)
        if (!tbRiskNotifierInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbRiskNotifier.label', default: 'TbRiskNotifier'), params.id])}"
            redirect(action: "list")
        } else {
            [tbRiskNotifierInstance: tbRiskNotifierInstance]
        }
    }

    def edit = {
        def tbRiskNotifierInstance = TbRiskNotifier.get(params.id)
        if (!tbRiskNotifierInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbRiskNotifier.label', default: 'TbRiskNotifier'), params.id])}"
            redirect(action: "list")
        } else {
            return [tbRiskNotifierInstance: tbRiskNotifierInstance]
        }
    }

    def update = {
        def tbRiskNotifierInstance = TbRiskNotifier.get(params.id)
        if (tbRiskNotifierInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (tbRiskNotifierInstance.version > version) {

                    tbRiskNotifierInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'tbRiskNotifier.label', default: 'TbRiskNotifier')] as Object[], "Another user has updated this TbRiskNotifier while you were editing")
                    render(view: "edit", model: [tbRiskNotifierInstance: tbRiskNotifierInstance])
                    return
                }
            }
            tbRiskNotifierInstance.properties = params
            if (!tbRiskNotifierInstance.hasErrors() && tbRiskNotifierInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'tbRiskNotifier.label', default: 'TbRiskNotifier'), tbRiskNotifierInstance.id])}"
                redirect(action: "list")
            } else {
                render(view: "edit", model: [tbRiskNotifierInstance: tbRiskNotifierInstance])
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbRiskNotifier.label', default: 'TbRiskNotifier'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def tbRiskNotifierInstance = TbRiskNotifier.get(params.id)
        if (tbRiskNotifierInstance) {
            try {
                tbRiskNotifierInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'tbRiskNotifier.label', default: 'TbRiskNotifier'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'tbRiskNotifier.label', default: 'TbRiskNotifier'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbRiskNotifier.label', default: 'TbRiskNotifier'), params.id])}"
            redirect(action: "list")
        }
    }
}
