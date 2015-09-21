package boss

class BoRoleController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "id"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def query = {
            if (params.roleCode != null && params.roleCode != '') {
                like('roleCode', params.roleCode + '%')
            }
            if (params.roleName != null && params.roleName != '') {
                like('roleName', params.roleName + '%')
            }
            if (params.status != null && params.status != '') {
                eq('status', params.status)
            }
        }
        def total = BoRole.createCriteria().count(query)
        def roleList = BoRole.createCriteria().list(params, query)
        [boRoleInstanceList: roleList, boRoleInstanceTotal: total]
    }

    def listDownload = {
        params.max = 50000
        params.offset = 0
        def query = {
            if (params.roleCode != null && params.roleCode != '') {
                like('roleCode', params.roleCode + '%')
            }
            if (params.roleName != null && params.roleName != '') {
                like('roleName', params.roleName + '%')
            }
            if (params.status != null && params.status != '') {
                eq('status', params.status)
            }
        }
        def total = BoRole.createCriteria().count(query)
        def roleList = BoRole.createCriteria().list(params, query)
        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [boRoleInstanceList: roleList])
    }

    def addUser = {
//        params.sort = params.sort ? params.sort : "id"
//        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def customer
        def query = {
            eq('status', '1')
        }
        def total = BoRole.createCriteria().count(query)
        def results = BoRole.createCriteria().list(params, query)
        [boRoleInstanceList: results, boRoleInstanceTotal: total]
    }

    def create = {
        def boRoleInstance = new BoRole()
        boRoleInstance.properties = params
        return [boRoleInstance: boRoleInstance]
    }

    def updatePromission = {

    }

    def save = {
//         def boRoleInstance = new BoRole(params)
//        def permIds = [].addAll(params.permIds)
//        permIds.each {
//          boRoleInstance.addToPermissions(BoPromission.get()).addToPermissions(BoPromission.get(it))
//        }
//        println  params.roleCode
//       def list= BoRole.findAllByRoleCode(params.roleCode)
//        if(list.size()>0){
//           flash.message = "角色编码已经存在，请更换角色编码！"
//        }
        def boRoleInstance = new BoRole(params)
        if (boRoleInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boRole.label', default: 'BoRole'), boRoleInstance.id])}"
            redirect(action: "list", id: boRoleInstance.id)
        }
        else {
            render(view: "create", model: [boRoleInstance: boRoleInstance])
        }
    }

    def show = {
        def boRoleInstance = BoRole.get(params.id)
        if (!boRoleInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRole.label', default: 'BoRole'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boRoleInstance: boRoleInstance]
        }
    }

    def edit = {
        def boRoleInstance = BoRole.get(params.id)
        if (!boRoleInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRole.label', default: 'BoRole'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [boRoleInstance: boRoleInstance]
        }
    }

    def updateStatus = {
        def str = params.statusFlag
        if ("1".equals(str)) {
            params.setProperty("status", "1")
        }
        if ("0".equals(str)) {
            params.setProperty("status", "2")
        }
        println params.id
        def boRoleInstance = BoRole.get(params.id)
        if (boRoleInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boRoleInstance.version > version) {

                    boRoleInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boRole.label', default: 'BoRole')] as Object[], "Another user has updated this BoRole while you were editing")
                    render(view: "edit", model: [boRoleInstance: boRoleInstance])
                    return
                }
            }
            boRoleInstance.properties = params
            if (!boRoleInstance.hasErrors() && boRoleInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boRole.label', default: 'BoRole'), boRoleInstance.roleName])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boRoleInstance: boRoleInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRole.label', default: 'BoRole'), params.id])}"
            redirect(action: "list")
        }
    }

    def update = {
        def boRoleInstance = BoRole.get(params.id)
        if (boRoleInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boRoleInstance.version > version) {

                    boRoleInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boRole.label', default: 'BoRole')] as Object[], "Another user has updated this BoRole while you were editing")
                    render(view: "edit", model: [boRoleInstance: boRoleInstance])
                    return
                }
            }
            boRoleInstance.properties = params
            if (!boRoleInstance.hasErrors() && boRoleInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boRole.label', default: 'BoRole'), boRoleInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boRoleInstance: boRoleInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRole.label', default: 'BoRole'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def boRoleInstance = BoRole.get(params.id)
        if (boRoleInstance) {
            try {
                boRoleInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boRole.label', default: 'BoRole'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boRole.label', default: 'BoRole'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRole.label', default: 'BoRole'), params.id])}"
            redirect(action: "list")
        }
    }
}
