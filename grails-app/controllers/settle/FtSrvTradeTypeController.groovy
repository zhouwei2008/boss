package settle

class FtSrvTradeTypeController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        if(params.fanhui=="1")
          flash.message = ""
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [ftSrvTradeTypeInstanceList: FtSrvTradeType.list(params), ftSrvTradeTypeInstanceTotal: FtSrvTradeType.count()]
    }

    def create = {
        def ftSrvTradeTypeInstance = new FtSrvTradeType()
        ftSrvTradeTypeInstance.properties = params
        return [ftSrvTradeTypeInstance: ftSrvTradeTypeInstance]
    }

    def save = {
        def ftSrvTradeTypeInstance = new FtSrvTradeType(params)

        if(params.tradeCode == null || params.tradeCode.trim() == ""){
            flash.message = "${message(code: 'ftSrvTradeType.invalid.notnull.tradeCode.label')}"
            render(view: "create", model: [ftSrvTradeTypeInstance: ftSrvTradeTypeInstance])
            return
        }else if(params.tradeName == null || params.tradeName.trim() == ""){
            flash.message = "${message(code: 'ftSrvTradeType.invalid.notnull.tradeName.label')}"
            render(view: "create", model: [ftSrvTradeTypeInstance: ftSrvTradeTypeInstance])
            return
        }

        //判断是否已经存在业务交易类型编码
        def isExist = FtSrvTradeType.findByTradeCode(ftSrvTradeTypeInstance.tradeCode?.trim())
        if(isExist){
            flash.message = "${message(code: 'ftSrvTradeType.invalid.tradeCode.label', args: [ftSrvTradeTypeInstance.tradeCode])}"
            render(view: "create", model: [ftSrvTradeTypeInstance: ftSrvTradeTypeInstance])
            return
        }

        if (ftSrvTradeTypeInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'ftSrvTradeType.label', default: 'FtSrvTradeType'), ftSrvTradeTypeInstance.tradeName])}"
            redirect(action: "list", id: ftSrvTradeTypeInstance.id)
        }
        else {
            render(view: "create", model: [ftSrvTradeTypeInstance: ftSrvTradeTypeInstance])
        }
    }

    def show = {
        def ftSrvTradeTypeInstance = FtSrvTradeType.get(params.id)
        if (!ftSrvTradeTypeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftSrvTradeType.label', default: 'FtSrvTradeType'), params.id])}"
            redirect(action: "list")
        }else {
            flash.message = null
            [ftSrvTradeTypeInstance: ftSrvTradeTypeInstance]
        }
    }

    def edit = {
        def ftSrvTradeTypeInstance = FtSrvTradeType.get(params.id)
        if (!ftSrvTradeTypeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftSrvTradeType.label', default: 'FtSrvTradeType'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [ftSrvTradeTypeInstance: ftSrvTradeTypeInstance]
        }
    }

    def update = {
        def ftSrvTradeTypeInstance = FtSrvTradeType.get(params.id)
        if (ftSrvTradeTypeInstance) {
            if(params.tradeCode == null || params.tradeCode.trim() == ""){
                flash.message = "${message(code: 'ftSrvTradeType.invalid.notnull.tradeCode.label')}"
                render(view: "edit", model: [ftSrvTradeTypeInstance: ftSrvTradeTypeInstance])
                return
            }else if(params.tradeName == null || params.tradeName.trim() == ""){
                flash.message = "${message(code: 'ftSrvTradeType.invalid.notnull.tradeName.label')}"
                render(view: "edit", model: [ftSrvTradeTypeInstance: ftSrvTradeTypeInstance])
                return
            }

            if (params.version) {
                def version = params.version.toLong()
                if (ftSrvTradeTypeInstance.version > version) {
                    
                    ftSrvTradeTypeInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'ftSrvTradeType.label', default: 'FtSrvTradeType')] as Object[], "Another user has updated this FtSrvTradeType while you were editing")
                    render(view: "edit", model: [ftSrvTradeTypeInstance: ftSrvTradeTypeInstance])
                    return
                }
            }

            //判断是否已经存在业务交易类型编码
            def isExist = FtSrvTradeType.findByTradeCode(params.tradeCode?.trim())
            if(isExist&&ftSrvTradeTypeInstance.id!=isExist.id){
                flash.message = "${message(code: 'ftSrvTradeType.invalid.tradeCode.label', args: [params.tradeCode])}"
                render(view: "edit", model: [ftSrvTradeTypeInstance: ftSrvTradeTypeInstance])
                return
            }

            ftSrvTradeTypeInstance.properties = params
            if (!ftSrvTradeTypeInstance.hasErrors() && ftSrvTradeTypeInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'ftSrvTradeType.label', default: 'FtSrvTradeType'), ftSrvTradeTypeInstance.tradeName])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [ftSrvTradeTypeInstance: ftSrvTradeTypeInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftSrvTradeType.label', default: 'FtSrvTradeType'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def ftSrvTradeTypeInstance = FtSrvTradeType.get(params.id)
        if (ftSrvTradeTypeInstance) {
            try {
                ftSrvTradeTypeInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'ftSrvTradeType.label', default: 'FtSrvTradeType'), ftSrvTradeTypeInstance.tradeName])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'ftSrvTradeType.label', default: 'FtSrvTradeType'), ftSrvTradeTypeInstance.tradeName])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftSrvTradeType.label', default: 'FtSrvTradeType'), params.id])}"
            redirect(action: "list")
        }
    }
}
