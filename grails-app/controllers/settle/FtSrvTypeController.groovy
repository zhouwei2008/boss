package settle

class FtSrvTypeController {

    static allowedMethods = [save: "POST", update: "POST"]

    def index = {
        
        redirect(action: "list", params: params)
    }

    def list = {
         if(params.fanhui=="1")
         flash.message = ""
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [ftSrvTypeInstanceList: FtSrvType.list(params), ftSrvTypeInstanceTotal: FtSrvType.count()]
    }

    def create = {
        def ftSrvTypeInstance = new FtSrvType()
        ftSrvTypeInstance.properties = params
        return [ftSrvTypeInstance: ftSrvTypeInstance]
    }

    def save = {
        def ftSrvTypeInstance = new FtSrvType(params)

        if(params.srvCode == null || params.srvCode.trim() == ""){
            flash.message = "${message(code: 'ftSrvType.invalid.notnull.srvCode.label')}"
            render(view: "create", model: [ftSrvTypeInstance: ftSrvTypeInstance])
            return
        }else if(params.srvName == null || params.srvName.trim() == ""){
            flash.message = "${message(code: 'ftSrvType.invalid.notnull.srvName.label')}"
            render(view: "create", model: [ftSrvTypeInstance: ftSrvTypeInstance])
            return
        }
        /*else if(!(params.srvCode ==~ /\w+/)){
            flash.message = "${message(code: 'ftSrvType.invalid.notpattern.srvCode.label')}"
            render(view: "create", model: [ftSrvTypeInstance: ftSrvTypeInstance])
            return
        }else if(!(params.srvName ==~ /\w+/)){
            flash.message = "${message(code: 'ftSrvType.invalid.notpattern.srvName.label')}"
            render(view: "create", model: [ftSrvTypeInstance: ftSrvTypeInstance])
            return
        }*/

        //判断是否已经存在业务类型编码
        def isExist = FtSrvType.findBySrvCode(ftSrvTypeInstance.srvCode?.trim())
        if(isExist){
            flash.message = "${message(code: 'ftSrvType.invalid.srvCode.label', args: [ftSrvTypeInstance.srvCode])}"
            render(view: "create", model: [ftSrvTypeInstance: ftSrvTypeInstance])
            return
        }

        def isName = FtSrvType.findBySrvCode(ftSrvTypeInstance.srvName?.trim())
        if(isName){
            flash.message = "${message(code: '业务名称'+ftSrvTypeInstance.srvName?.trim()+'已经存在')}"
            render(view: "create", model: [ftSrvTypeInstance: ftSrvTypeInstance])
            return
        }

        if (ftSrvTypeInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'ftSrvType.label', default: 'FtSrvType'), ftSrvTypeInstance.srvName])}"
            redirect(action: "list", id: ftSrvTypeInstance.id)
        }
        else {
            render(view: "create", model: [ftSrvTypeInstance: ftSrvTypeInstance])
        }
    }

    def show = {
        def ftSrvTypeInstance = FtSrvType.get(params.id)
        if (!ftSrvTypeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftSrvType.label', default: 'FtSrvType'), params.id])}"
            redirect(action: "list")
        }
        else {
            flash.message = null
            [ftSrvTypeInstance: ftSrvTypeInstance]
        }
    }

    def edit = {
        def ftSrvTypeInstance = FtSrvType.get(params.id)
        if (!ftSrvTypeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftSrvType.label', default: 'FtSrvType'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [ftSrvTypeInstance: ftSrvTypeInstance]
        }
    }

    def update = {
        def ftSrvTypeInstance = FtSrvType.get(params.id)
        if (ftSrvTypeInstance) {
            if(params.srvCode == null || params.srvCode.trim() == ""){
                flash.message = "${message(code: 'ftSrvType.invalid.notnull.srvCode.label')}"
                render(view: "edit", model: [ftSrvTypeInstance: ftSrvTypeInstance])
                return
            }else if(params.srvName == null || params.srvName.trim() == ""){
                flash.message = "${message(code: 'ftSrvType.invalid.notnull.srvName.label')}"
                render(view: "edit", model: [ftSrvTypeInstance: ftSrvTypeInstance])
                return
            }

            if (params.version) {
                def version = params.version.toLong()
                if (ftSrvTypeInstance.version > version) {
                    
                    ftSrvTypeInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'ftSrvType.label', default: 'FtSrvType')] as Object[], "Another user has updated this FtSrvType while you were editing")
                    render(view: "edit", model: [ftSrvTypeInstance: ftSrvTypeInstance])
                    return
                }
            }

            //判断是否已经存在业务类型编码
            def isExist = FtSrvType.findBySrvCode(params.srvCode?.trim())
        
            if(isExist&&ftSrvTypeInstance.id!=isExist.id){
                flash.message = "${message(code: 'ftSrvType.invalid.srvCode.label', args: [params.srvCode])}"
                render(view: "edit", model: [ftSrvTypeInstance: ftSrvTypeInstance])
                return
            }

            ftSrvTypeInstance.properties = params
            if (!ftSrvTypeInstance.hasErrors() && ftSrvTypeInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'ftSrvType.label', default: 'FtSrvType'), ftSrvTypeInstance.srvName])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [ftSrvTypeInstance: ftSrvTypeInstance])
            }
        }else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftSrvType.label', default: 'FtSrvType'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def ftSrvTypeInstance = FtSrvType.get(params.id)
        println("id:"+params.id)

        if (ftSrvTypeInstance) {
            try {
                def ftTradeFee = FtFeeChannel.findByFtSrvTypeId(ftSrvTypeInstance.id)
                if(ftTradeFee){
                    flash.message = "该业务类型已经设置业务通道，不能删除！"
                }else{
                    ftSrvTypeInstance.delete(flush: true)
                    flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'ftSrvType.label', default: 'FtSrvType'), params.id])}"
                }
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'ftSrvType.label', default: 'FtSrvType'), params.id])}"
                redirect(action: "list", params: [id :params.id])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftSrvType.label', default: 'FtSrvType'), params.id])}"
            redirect(action: "list")
        }
    }
}
