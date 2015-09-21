package boss

import ismp.CmCorporationInfo

class BoBranchCompanyController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
	    params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def query = {
            if (params.companyName) {
                ilike('companyName', "%"+params.companyName+"%")
            }
            if (params.companyNo) {
                like('companyNo', "%"+params.companyNo+"%")
            }
            if (params.chargeMan) {
                ilike('chargeMan', "%"+params.chargeMan+"%")
            }
            if (params.phone) {
                like('phone', "%"+params.phone+"%")
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
        def total = BoBranchCompany.createCriteria().count(query)
        def gwOrderList = BoBranchCompany.createCriteria().list(params, query)
        [boBranchCompanyInstanceList: gwOrderList, boBranchCompanyInstanceTotal: total]
       
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

    def listDownload = {
            params.sort = params.sort ? params.sort : "dateCreated"
            params.order = params.order ? params.order : "desc"
            params.max = 50000
            params.offset = 0
            def query = {
                if (params.companyName) {
                    ilike('companyName', "%"+params.companyName+"%")
                }
                if (params.companyNo) {
                    like('companyNo', "%"+params.companyNo+"%")
                }
                if (params.chargeMan) {
                    ilike('chargeMan', "%"+params.chargeMan+"%")
                }
                if (params.phone) {
                    like('phone', "%"+params.phone+"%")
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
            def total = BoBranchCompany.createCriteria().count(query)
            def results = BoBranchCompany.createCriteria().list(params, query)

            def filename = 'Excel-branch-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.contentType = "application/x-rarx-rar-compressed"
            response.setCharacterEncoding("UTF-8")
            render(template: "branchList", model: [boBranchCompanyInstanceList: results])
        }

    def create = {
        def boBranchCompanyInstance = new BoBranchCompany()
        boBranchCompanyInstance.properties = params
        return [boBranchCompanyInstance: boBranchCompanyInstance]
    }

    def save = {
        def boBranchCompanyInstance = new BoBranchCompany(params)
        if (boBranchCompanyInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boBranchCompany.label', default: 'BoBranchCompany'), boBranchCompanyInstance.companyName])}"
            redirect(action: "list", id: boBranchCompanyInstance.id)
        }
        else {
            render(view: "create", model: [boBranchCompanyInstance: boBranchCompanyInstance])
        }
    }

    def show = {
        def boBranchCompanyInstance = BoBranchCompany.get(params.id)
        if (!boBranchCompanyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boBranchCompany.label', default: 'BoBranchCompany'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boBranchCompanyInstance: boBranchCompanyInstance]
        }
    }

    def edit = {
        def boBranchCompanyInstance = BoBranchCompany.get(params.id)
        if (!boBranchCompanyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boBranchCompany.label', default: 'BoBranchCompany'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [boBranchCompanyInstance: boBranchCompanyInstance]
        }
    }

    def update = {
        def boBranchCompanyInstance = BoBranchCompany.get(params.id)
        if (boBranchCompanyInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boBranchCompanyInstance.version > version) {
                    boBranchCompanyInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boBranchCompany.label', default: 'BoBranchCompany')] as Object[], "Another user has updated this BoBranchCompany while you were editing")
                    render(view: "edit", model: [boBranchCompanyInstance: boBranchCompanyInstance])
                    return
                }
            }
//            def orginNo = boBranchCompanyInstance.companyNo
//            def newNo =   params.companyNo
            boBranchCompanyInstance.properties = params
            if (!boBranchCompanyInstance.hasErrors() && boBranchCompanyInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boBranchCompany.label', default: 'BoBranchCompany'), boBranchCompanyInstance.companyName])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boBranchCompanyInstance: boBranchCompanyInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boBranchCompany.label', default: 'BoBranchCompany'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def boBranchCompanyInstance = BoBranchCompany.get(params.id)
        if (boBranchCompanyInstance) {
            try {
                boBranchCompanyInstance.delete(flush: true)
                //更新操作员中分公司状态  update by guonan 2012-002-19
               def update = """
            update BoOperator t set t.branchCompany=''
            where t.branchCompany='${boBranchCompanyInstance.id}'
             """
                BoOperator.executeUpdate(update);
                 //更新企业客户中分公司状态  update by guonan 2012-002-19
                update = """
            update CmCorporationInfo t set t.branchCompany=''
            where t.branchCompany='${boBranchCompanyInstance.id}'
             """
                CmCorporationInfo.executeUpdate(update);

                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boBranchCompany.label', default: 'BoBranchCompany'),boBranchCompanyInstance.companyName])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boBranchCompany.label', default: 'BoBranchCompany'), boBranchCompanyInstance.companyName])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boBranchCompany.label', default: 'BoBranchCompany'), params.id])}"
            redirect(action: "list")
        }
    }
}
