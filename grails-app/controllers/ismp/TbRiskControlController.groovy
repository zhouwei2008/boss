package ismp

class TbRiskControlController {

    static allowedMethods = [save: "POST",update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {

        params.sort = params.sort ? params.sort : "id"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def query = {
            if (params.bType != null && params.bType != '') {
                eq("bType",params.bType.trim())
            }

        }
        def pageNum = 1
        if(params.offset != null && params.offset != ""){
             pageNum =  (params.offset / 10) + 1
        }

        def cmCustomerInstance =TbRiskControl.createCriteria().list(params,query)
        def total = TbRiskControl.createCriteria().count(query)
        [tbRiskControlInstanceList: cmCustomerInstance, tbRiskControlInstanceTotal: total,pageNum:pageNum]


    }

    def create = {
        def tbRiskControlInstance = new TbRiskControl()
        tbRiskControlInstance.properties = params
        return [tbRiskControlInstance: tbRiskControlInstance]
    }

    def save = {
        def tbRiskControlInstance = new TbRiskControl(params)
        tbRiskControlInstance.status='0'
        tbRiskControlInstance.createOp = session.op?.account
        tbRiskControlInstance.createTime = new Date()
        if (tbRiskControlInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'tbRiskControl.label', default: '交易规则'), tbRiskControlInstance.ruleAbout])}"
            redirect(action: "list", id: tbRiskControlInstance.id)
        }
        else {
            render(view: "create", model: [tbRiskControlInstance: tbRiskControlInstance])
        }
    }

    def show = {
        def tbRiskControlInstance = TbRiskControl.get(params.id)
        if (!tbRiskControlInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbRiskControl.label', default: '交易规则'), tbRiskControlInstance.ruleAbout])}"
            redirect(action: "list")
        }
        else {
            [tbRiskControlInstance: tbRiskControlInstance]
        }
    }

    def edit = {
        def tbRiskControlInstance = TbRiskControl.get(params.id)
        def verify = params.verify==null?'':params.verify
        if (!tbRiskControlInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbRiskControl.label', default: '交易规则'), tbRiskControlInstance.ruleAbout])}"
            redirect(action: "list")
        }
        else {
            return [tbRiskControlInstance: tbRiskControlInstance,verify:verify]
        }
    }


    def updateStatus={

        def tbRiskControlInstance = TbRiskControl.get(params.id)
        tbRiskControlInstance.status = params.status
        tbRiskControlInstance.verifyTime = new Date()
        tbRiskControlInstance.verifyOp = session.op?.account
        tbRiskControlInstance.save([flash:true])
        redirect([action:'list'])
    }


    def update = {
        def tbRiskControlInstance = TbRiskControl.get(params.id)
        if (tbRiskControlInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (tbRiskControlInstance.version > version) {

                    tbRiskControlInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'tbRiskControl.label', default: '交易规则')] as Object[], "Another user has updated this TbRiskControl while you were editing")
                    render(view: "edit", model: [tbRiskControlInstance: tbRiskControlInstance])
                    return
                }
            }
            tbRiskControlInstance.properties = params
            tbRiskControlInstance.editTime = new Date()
            tbRiskControlInstance.editOp = session.op?.account
            if (!tbRiskControlInstance.hasErrors() && tbRiskControlInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'tbRiskControl.label', default: '交易规则'), tbRiskControlInstance.ruleAbout])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [tbRiskControlInstance: tbRiskControlInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbRiskControl.label', default: '交易规则'), tbRiskControlInstance.ruleAbout])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def tbRiskControlInstance = TbRiskControl.get(params.id)
        if (tbRiskControlInstance) {
            try {
                def tbRiskList = TbRiskList.findByRiskControl(tbRiskControlInstance)
                if(tbRiskList){
                    flash.message = "已有交易触发该交易规则，不能删除！"
                    redirect(action: "list")
                    return
                }

                tbRiskControlInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'tbRiskControl.label', default: '交易规则'), tbRiskControlInstance.ruleAbout])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'tbRiskControl.label', default: '交易规则'), tbRiskControlInstance.ruleAbout])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbRiskControl.label', default: '交易规则'), tbRiskControlInstance.ruleAbout])}"
            redirect(action: "list")
        }
    }
}
