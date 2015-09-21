package ismp

import boss.KeyUtils

class CmPersonalInfoController {

    def accountClientService
    def operatorService
    def customerService

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def query = {
            if (params.customerNo != null && params.customerNo != '') {
                like("customerNo", "%" + params.customerNo.trim() + "%")
            }
            if (params.name != null && params.name != '') {
                like("name", "%" + params.name.trim() + "%")
            }
            if (params.status != null && params.status != '') {
                eq("status", params.status)
            }
            if (params.accountNo != null && params.accountNo != '') {
                like("accountNo", "%" + params.accountNo.trim() + "%")
            }
            if (params.identityNo != null && params.identityNo != '') {
                like("identityNo", "%" + params.identityNo.trim() + "%")
            }
//            if (params.startDateCreated != null && params.startDateCreated != '') {
//                ge("dateCreated", Date.parse('yyyy-MM-dd', params.startDateCreated))
//            }
//            if (params.endDateCreated != null && params.endDateCreated != '') {
//                le("dateCreated", Date.parse('yyyy-MM-dd', params.endDateCreated)+1)
//            }

            //guonan update 2011-12-29
//            validDated(params)
            if (params.startDateCreated) {
            ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
            lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
        }
        def total = CmPersonalInfo.createCriteria().count(query)
        def results = CmPersonalInfo.createCriteria().list(params, query)
        [cmPersonalInfoInstanceList: results, cmPersonalInfoInstanceTotal: total]
    }
       /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan
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
    def listDownload = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = 50000
        params.offset = 0
        def query = {
            if (params.customerNo != null && params.customerNo != '') {
                like("customerNo", "%" + params.customerNo.trim() + "%")
            }
            if (params.name != null && params.name != '') {
                like("name", "%" + params.name.trim() + "%")
            }
            if (params.status != null && params.status != '') {
                eq("status", params.status)
            }
            if (params.accountNo != null && params.accountNo != '') {
                like("accountNo", "%" + params.accountNo.trim() + "%")
            }
            if (params.identityNo != null && params.identityNo != '') {
                like("identityNo", "%" + params.identityNo.trim() + "%")
            }
//            if (params.startDateCreated != null && params.startDateCreated != '') {
//                ge("dateCreated", Date.parse('yyyy-MM-dd', params.startDateCreated))
//            }
//            if (params.endDateCreated != null && params.endDateCreated != '') {
//                le("dateCreated", Date.parse('yyyy-MM-dd', params.endDateCreated))
//            }
            //guonan update 2011-12-29
            validDated(params)
            if (params.startDateCreated) {
            ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
            lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
        }
        def total = CmPersonalInfo.createCriteria().count(query)
        def results = CmPersonalInfo.createCriteria().list(params, query)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [cmPersonalInfoInstanceList: results])
    }

    def create = {
        def cmPersonalInfoInstance = new CmPersonalInfo()
        cmPersonalInfoInstance.properties = params
        return [cmPersonalInfoInstance: cmPersonalInfoInstance]
    }

    def save = {
        def cmPersonalInfoInstance = new CmPersonalInfo(params)
        cmPersonalInfoInstance.lastTrxsUpdateDate=new Date()
        cmPersonalInfoInstance.apiKey = KeyUtils.getRandKey(64)
        if (!params.defaultEmail) {
            flash.message = "登录邮箱不能为空!"
            render(view: "create", model: [cmPersonalInfoInstance: cmPersonalInfoInstance])
        }

        def nickName = TbPersonBlackList.findByName(cmPersonalInfoInstance.name)
        if(!nickName){
            flash.message = "客户名称在黑名单库中存在!"
            render(view: "create", model: [cmPersonalInfoInstance: cmPersonalInfoInstance])
        }

        def identityNo = TbPersonBlackList.findByIdentityNo(cmPersonalInfoInstance.identityNo)
        if(!identityNo){
            flash.message = "客户证件号码在黑名单库中存在!"
            render(view: "create", model: [cmPersonalInfoInstance: cmPersonalInfoInstance])
        }

        try {
            customerService.createCorporationInfo(cmPersonalInfoInstance, params.defaultEmail, params.appId)

            flash.message = "${message(code: 'default.created.message', args: [message(code: 'cmPersonalInfo.label', default: 'CmPersonalInfo'), cmPersonalInfoInstance.name])}"
            redirect(action: "list", id: cmPersonalInfoInstance.id)

        } catch (Exception e) {
            log.warn('open account faile', e)
            flash.message = "增加帐户失败，请重试"
            render(view: "create", model: [cmPersonalInfoInstance: cmPersonalInfoInstance])
        }
    }

    def show = {
        def str = params.id
        def ids = str
        def sign
        def flag = 0
        if (str.indexOf(",")!=-1) {
            def flags = str.split(",")
            ids = flags[0]
            sign = flags[1]
        }
        if (sign!=null) {
            flag = 1
        }
        def cmPersonalInfoInstance = CmPersonalInfo.get(ids)
        if (!cmPersonalInfoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmPersonalInfo.label', default: 'CmPersonalInfo'), params.id])}"
            redirect(action: "list")
        }
        else {
            [cmPersonalInfoInstance: cmPersonalInfoInstance,flag:flag]
        }
    }

    def edit = {
        def cmPersonalInfoInstance = CmPersonalInfo.get(params.id)
        cmPersonalInfoInstance.lastTrxsUpdateDate=new Date()
        if (!cmPersonalInfoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmPersonalInfo.label', default: 'CmPersonalInfo'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [cmPersonalInfoInstance: cmPersonalInfoInstance]
        }
    }

    def update = {
        def cmPersonalInfoInstance = CmPersonalInfo.get(params.id)

        if (cmPersonalInfoInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (cmPersonalInfoInstance.version > version) {

                    cmPersonalInfoInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'cmPersonalInfo.label', default: 'CmPersonalInfo')] as Object[], "Another user has updated this CmPersonalInfo while you were editing")
                    render(view: "edit", model: [cmPersonalInfoInstance: cmPersonalInfoInstance])
                    return
                }
            }
            cmPersonalInfoInstance.properties = params
            if (!cmPersonalInfoInstance.hasErrors() && cmPersonalInfoInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'cmPersonalInfo.label', default: 'CmPersonalInfo'), cmPersonalInfoInstance.name])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [cmPersonalInfoInstance: cmPersonalInfoInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmPersonalInfo.label', default: 'CmPersonalInfo'), params.id])}"
            redirect(action: "list")
        }
    }
}
