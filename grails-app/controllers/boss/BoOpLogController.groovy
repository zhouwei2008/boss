package boss

class BoOpLogController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST",listDownload:"POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def opRelations
         def query = {
            if (params.names) {
                opRelations = BoOpRelation.findAllByNamesIlike('%'+params.names+'%')
                def controllerListx = []
                def actionListx = []
                if(opRelations!=null&&opRelations.size()>0){
                    opRelations.each {opRelation ->
                        controllerListx << opRelation.controllers
                        actionListx << opRelation.actions
                    }
                }else{
                     controllerListx << '00'
                     actionListx << '00'
                }
                 'in'('controller',controllerListx)
                 'in'('action',actionListx)

            }
            if (params.account) {
                like('account', "%"+params.account+"%")
            }
            //guonan update 2011-12-29
            validDated(params)
             if (params.startDateCreated) {
            ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
             }
             if (params.endDateCreated) {
            lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
             }
        }
        def total = BoOpLog.createCriteria().count(query)
        def gwOrderList = BoOpLog.createCriteria().list(params, query)
        [boOpLogInstanceList: gwOrderList, boOpLogInstanceTotal: total]
    }

    def listDownload = {

        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = 1000
        params.offset = 0

        def opRelations
        def query = {
            if (params.names) {
                opRelations = BoOpRelation.findAllByNamesIlike('%'+params.names+'%')
                def controllerListx = []
                def actionListx = []
                if(opRelations!=null&&opRelations.size()>0){
                    opRelations.each {opRelation ->
                        controllerListx << opRelation.controllers
                        actionListx << opRelation.actions
                    }
                }else{
                    controllerListx << '00'
                    actionListx << '00'
                }
                'in'('controller',controllerListx)
                'in'('action',actionListx)

            }
            if (params.account) {
                like('account', "%"+params.account+"%")
            }
            //guonan update 2011-12-29
            validDated(params)
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
        }

        def opLogList = BoOpLog.createCriteria().list(params, query)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "list", model: [opLogList: opLogList])
    }


    /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan  2011-12-29
     *
     */
    def validDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startDateCreated==null && params.endDateCreated==null){
            def gCalendar= new GregorianCalendar()
            params.endDateCreated=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startDateCreated=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startDateCreated && !params.endDateCreated){
             params.endDateCreated=params.startDateCreated
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startDateCreated && params.endDateCreated){
             params.startDateCreated=params.endDateCreated
        }
        if (params.startDateCreated && params.endDateCreated) {


        }
    }

    def create = {
        def boOpLogInstance = new BoOpLog()
        boOpLogInstance.properties = params
        return [boOpLogInstance: boOpLogInstance]
    }

    def save = {
        def boOpLogInstance = new BoOpLog(params)
        if (boOpLogInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boOpLog.label', default: 'BoOpLog'), boOpLogInstance.id])}"
            redirect(action: "list", id: boOpLogInstance.id)
        }
        else {
            render(view: "create", model: [boOpLogInstance: boOpLogInstance])
        }
    }

    def show = {
        def boOpLogInstance = BoOpLog.get(params.id)
        if (!boOpLogInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOpLog.label', default: 'BoOpLog'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boOpLogInstance: boOpLogInstance]
        }
    }

    def edit = {
        def boOpLogInstance = BoOpLog.get(params.id)
        if (!boOpLogInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOpLog.label', default: 'BoOpLog'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [boOpLogInstance: boOpLogInstance]
        }
    }

    def update = {
        def boOpLogInstance = BoOpLog.get(params.id)
        if (boOpLogInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boOpLogInstance.version > version) {

                    boOpLogInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boOpLog.label', default: 'BoOpLog')] as Object[], "Another user has updated this BoOpLog while you were editing")
                    render(view: "edit", model: [boOpLogInstance: boOpLogInstance])
                    return
                }
            }
            boOpLogInstance.properties = params
            if (!boOpLogInstance.hasErrors() && boOpLogInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boOpLog.label', default: 'BoOpLog'), boOpLogInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boOpLogInstance: boOpLogInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOpLog.label', default: 'BoOpLog'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def boOpLogInstance = BoOpLog.get(params.id)
        if (boOpLogInstance) {
            try {
                boOpLogInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boOpLog.label', default: 'BoOpLog'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boOpLog.label', default: 'BoOpLog'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOpLog.label', default: 'BoOpLog'), params.id])}"
            redirect(action: "list")
        }
    }
}
