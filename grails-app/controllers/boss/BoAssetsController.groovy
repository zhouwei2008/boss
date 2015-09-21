package boss


class BoAssetsController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

                 def list = {
                        params.sort = params.sort ? params.sort : "id"
                        params.order = params.order ? params.order : "desc"
                        params.max = Math.min(params.max ? params.int('max') : 10, 100)
                        params.offset = params.offset ? params.int('offset') : 0
                         def query = {
                            if (params.status != null && params.status != '') {
                                eq("status", params.status)
                            }

                            if (params.startDateCreated) {
                            ge('startDate', Date.parse('yyyy-MM-dd', params.startDateCreated))
                            }
                            if (params.endDateCreated) {
                            lt('startDate', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
                            }
                        }
                        def total = BoAssets.createCriteria().count(query)
                        def results =BoAssets.createCriteria().list(params, query)

                         def pageNum = 1
                         if(params.offset != null && params.offset != ""){
                             pageNum =  (params.offset / 10) + 1
                         }

                        [boAssetsInstanceList: results, boAssetsInstanceTotal: total,pageNum:pageNum]
    }


    def listDownload={
                        def query = {
                            if (params.status != null && params.status != '') {
                                eq("status", params.status)
                            }

                            if (params.startDateCreated) {
                            ge('startDate', Date.parse('yyyy-MM-dd', params.startDateCreated))
                            }
                            if (params.endDateCreated) {
                            lt('startDate', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
                            }
                        }
                        def total = BoAssets.createCriteria().count(query)
                        def results =BoAssets.createCriteria().list(params, query)


        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMdd").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "assetsList", model: [boAssetsInstanceList: results])

    }




    def create = {
        def boAssetsInstance = new BoAssets()
        boAssetsInstance.properties = params
        return [boAssetsInstance: boAssetsInstance]
    }

    def save = {
        def boAssetsInstance = new BoAssets(params)
        if (boAssetsInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boAssets.label', default: 'BoAssets'), boAssetsInstance.id])}"
            redirect(action: "list", id: boAssetsInstance.id)
        } else {
            render(view: "create", model: [boAssetsInstance: boAssetsInstance])
        }
    }

    def show = {
        def boAssetsInstance = BoAssets.get(params.id)
        if (!boAssetsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAssets.label', default: 'BoAssets'), params.id])}"
            redirect(action: "list")
        } else {
            [boAssetsInstance: boAssetsInstance]
        }
    }

    def edit = {
        def boAssetsInstance = BoAssets.get(params.id)
        if (!boAssetsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAssets.label', default: 'BoAssets'), params.id])}"
            redirect(action: "list")
        } else {
            return [boAssetsInstance: boAssetsInstance]
        }
    }

    def update = {
        def boAssetsInstance = BoAssets.get(params.id)
        if (boAssetsInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boAssetsInstance.version > version) {

                    boAssetsInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boAssets.label', default: 'BoAssets')] as Object[], "Another user has updated this BoAssets while you were editing")
                    render(view: "edit", model: [boAssetsInstance: boAssetsInstance])
                    return
                }
            }
            boAssetsInstance.properties = params
            if (!boAssetsInstance.hasErrors() && boAssetsInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boAssets.label', default: 'BoAssets'), boAssetsInstance.id])}"
                redirect(action: "list")
            } else {
                render(view: "edit", model: [boAssetsInstance: boAssetsInstance])
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAssets.label', default: 'BoAssets'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def boAssetsInstance = BoAssets.get(params.id)
        if (boAssetsInstance) {
            try {
                boAssetsInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boAssets.label', default: 'BoAssets'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boAssets.label', default: 'BoAssets'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAssets.label', default: 'BoAssets'), params.id])}"
            redirect(action: "list")
        }
    }
}
