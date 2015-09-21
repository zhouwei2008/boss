package boss

class BoBankDicController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [boBankDicInstanceList: BoBankDic.list(params), boBankDicInstanceTotal: BoBankDic.count()]
    }

    def create = {
        def boBankDicInstance = new BoBankDic()
        boBankDicInstance.properties = params
        return [boBankDicInstance: boBankDicInstance]
    }

    def save = {
        def boBankDicInstance = new BoBankDic(params)
        def banks=BoBankDic.list()
        for(item in banks) {
             if (item.code.toUpperCase().equals(params.code.toUpperCase())) {
                flash.message = "该银行编码已存在!"
                render(view: "create", model: [boBankDicInstance: boBankDicInstance, params: params])
                return
             }
        }
        if (boBankDicInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boBankDic.label', default: 'BoBankDic'), boBankDicInstance.name])}"
            redirect(action: "list", id: boBankDicInstance.id)
        }
        else {
            render(view: "create", model: [boBankDicInstance: boBankDicInstance])
        }
    }

    def show = {
        def boBankDicInstance = BoBankDic.get(params.id)
        if (!boBankDicInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boBankDic.label', default: 'BoBankDic'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boBankDicInstance: boBankDicInstance]
        }
    }

    def edit = {
        def boBankDicInstance = BoBankDic.get(params.id)
        if (!boBankDicInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boBankDic.label', default: 'BoBankDic'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [boBankDicInstance: boBankDicInstance]
        }
    }

    def update = {
        def boBankDicInstance = BoBankDic.get(params.id)
        if (boBankDicInstance) {
            def banks=BoBankDic.list()
            for(item in banks) {
                 if (item.code.toUpperCase().equals(params.code.toUpperCase())) {
                    flash.message = "该银行编码已存在!"
                    render(view: "create", model: [boBankDicInstance: boBankDicInstance, params: params])
                    return
                 }
            }
            if (params.version) {
                def version = params.version.toLong()
                if (boBankDicInstance.version > version) {
                    
                    boBankDicInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boBankDic.label', default: 'BoBankDic')] as Object[], "Another user has updated this BoBankDic while you were editing")
                    render(view: "edit", model: [boBankDicInstance: boBankDicInstance])
                    return
                }
            }
            boBankDicInstance.properties = params
            if (!boBankDicInstance.hasErrors() && boBankDicInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boBankDic.label', default: 'BoBankDic'), boBankDicInstance.name])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boBankDicInstance: boBankDicInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boBankDic.label', default: 'BoBankDic'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def boBankDicInstance = BoBankDic.get(params.id)
        if (boBankDicInstance) {
            try {
                boBankDicInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boBankDic.label', default: 'BoBankDic'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boBankDic.label', default: 'BoBankDic'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boBankDic.label', default: 'BoBankDic'), params.id])}"
            redirect(action: "list")
        }
    }
}
