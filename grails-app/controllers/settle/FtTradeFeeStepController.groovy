package settle

class FtTradeFeeStepController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [ftTradeFeeStepInstanceList: FtTradeFeeStep.list(params), ftTradeFeeStepInstanceTotal: FtTradeFeeStep.count()]
    }

    def create = {
        def ftTradeFeeStepInstance = new FtTradeFeeStep()
        ftTradeFeeStepInstance.properties = params
        return [ftTradeFeeStepInstance: ftTradeFeeStepInstance]
    }

    def save = {
        def ftTradeFeeStepInstance = new FtTradeFeeStep(params)
        if (ftTradeFeeStepInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'ftTradeFeeStep.label', default: 'FtTradeFeeStep'), ftTradeFeeStepInstance.id])}"
            redirect(action: "list", id: ftTradeFeeStepInstance.id)
        }
        else {
            render(view: "create", model: [ftTradeFeeStepInstance: ftTradeFeeStepInstance])
        }
    }

    def show = {
        def ftTradeFeeStepInstance = FtTradeFeeStep.get(params.id)
        if (!ftTradeFeeStepInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftTradeFeeStep.label', default: 'FtTradeFeeStep'), params.id])}"
            redirect(action: "list")
        }
        else {
            [ftTradeFeeStepInstance: ftTradeFeeStepInstance]
        }
    }

    def edit = {
        def ftTradeFeeStepInstance = FtTradeFeeStep.get(params.id)
        if (!ftTradeFeeStepInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftTradeFeeStep.label', default: 'FtTradeFeeStep'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [ftTradeFeeStepInstance: ftTradeFeeStepInstance]
        }
    }

    def update = {
        def ftTradeFeeStepInstance = FtTradeFeeStep.get(params.id)
        if (ftTradeFeeStepInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (ftTradeFeeStepInstance.version > version) {
                    
                    ftTradeFeeStepInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'ftTradeFeeStep.label', default: 'FtTradeFeeStep')] as Object[], "Another user has updated this FtTradeFeeStep while you were editing")
                    render(view: "edit", model: [ftTradeFeeStepInstance: ftTradeFeeStepInstance])
                    return
                }
            }
            ftTradeFeeStepInstance.properties = params
            if (!ftTradeFeeStepInstance.hasErrors() && ftTradeFeeStepInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'ftTradeFeeStep.label', default: 'FtTradeFeeStep'), ftTradeFeeStepInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [ftTradeFeeStepInstance: ftTradeFeeStepInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftTradeFeeStep.label', default: 'FtTradeFeeStep'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def ftTradeFeeStepInstance = FtTradeFeeStep.get(params.id)
        if (ftTradeFeeStepInstance) {
            try {
                ftTradeFeeStepInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'ftTradeFeeStep.label', default: 'FtTradeFeeStep'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'ftTradeFeeStep.label', default: 'FtTradeFeeStep'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftTradeFeeStep.label', default: 'FtTradeFeeStep'), params.id])}"
            redirect(action: "list")
        }
    }
}
