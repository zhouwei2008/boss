package ismp

class CmApplicationController {

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {

        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)

        def query = {
            if (params.registrationName) {
                ilike('registrationName', '%' + params.registrationName.trim() + '%')
            }
            if (params.bizMan) {
                ilike('bizMan', '%' + params.bizMan.trim() + '%')
            }
            if (params.bizMan) {
                ilike('bizMan', '%' + params.bizMan.trim() + '%')
            }
            if (params.status) {
                eq('status', params.status)
            }
            if (params.registrationType) {
                eq('registrationType', params.registrationType)
            }
            if (params.companyWebsite) {
                ilike('companyWebsite', '%' + params.companyWebsite.trim() + '%')
            }
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
        }

        def total = CmApplicationInfo.createCriteria().count(query)
        def results = CmApplicationInfo.createCriteria().list(params, query)

        [cmApplicationInfoInstanceList: results, cmApplicationInfoInstanceTotal: total]
    }

    def downLoad = {

        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = 50000
        params.offset = 0

        def query = {
            if (params.registrationName) {
                ilike('registrationName', '%' + params.registrationName.trim() + '%')
            }
            if (params.bizMan) {
                ilike('bizMan', '%' + params.bizMan.trim() + '%')
            }
            if (params.bizMan) {
                ilike('bizMan', '%' + params.bizMan.trim() + '%')
            }
            if (params.status) {
                eq('status', params.status)
            }
            if (params.registrationType) {
                eq('registrationType', params.registrationType)
            }
            if (params.companyWebsite) {
                ilike('companyWebsite', '%' + params.companyWebsite.trim() + '%')
            }
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
        }

        def results = CmApplicationInfo.createCriteria().list(params, query)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template:"applicationList", model: [cmApplicationInfoInstanceList: results])
    }

    def show = {

        def cmApplicationInfo = CmApplicationInfo.get(params.id)
        if (cmApplicationInfo) {
            [cmApplicationInfoInstance: cmApplicationInfo]
        } else {
            flash.message = "该申请商户已被删除!"
            redirect(action: "list", params: params)
        }
    }

    def delete = {

        def cmApplicationInfo = CmApplicationInfo.get(params.id)
        cmApplicationInfo.delete(flush: true)

        flash.message = "在线申请商户 " + cmApplicationInfo.registrationName + " 删除成功!"
        redirect(action: "list", params: params)
    }

    def createCustomer = {

        def cmApplicationInfo = CmApplicationInfo.findByIdAndStatus(params.id, '0')

        if (cmApplicationInfo) {
            if (cmApplicationInfo.registrationType.equals('P')) {
                params.name=cmApplicationInfo.registrationName
                params.defaultEmail = cmApplicationInfo.bizEmail
                params.appId = params.id
                redirect(controller:"cmPersonalInfo",action:"create", params:params)
            } else {
                params.registrationName = cmApplicationInfo.registrationName
                params.defaultEmail = cmApplicationInfo.bizEmail
                params.defaultEmail = cmApplicationInfo.bizEmail
                params.companyWebsite = cmApplicationInfo.companyWebsite
                params.belongToBusiness = cmApplicationInfo.belongToBusiness
                params.belongToArea = cmApplicationInfo.belongToArea
                params.officeLocation = cmApplicationInfo.officeLocation
                params.companyPhone = cmApplicationInfo.bizPhone
                params.zipCode = cmApplicationInfo.zipCode
                params.bizMan = cmApplicationInfo.bizMan
                params.bizMPhone = cmApplicationInfo.bizMPhone
                params.bizPhone = cmApplicationInfo.bizPhone
                params.bizEmail = cmApplicationInfo.bizEmail
                params.appId = params.id
                redirect(controller:"cmCorporationInfo",action:"create", params:params)
            }
        } else {
            flash.message = "该申请商户已注册成功或被删除!"
            redirect(action: "list", params: params)
        }
    }
}
