package boss

import java.text.SimpleDateFormat
import java.text.ParsePosition

class BoSecurityEventsController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {

           params.sort = params.sort ? params.sort : "startDateCreated"
           params.order = params.order ? params.order : "desc"
           params.max = Math.min(params.max ? params.int('max') : 10, 100)

            def query = {

                if (params.boStatus != null && params.boStatus != '') {
                    eq("boStatus", params.boStatus)
                }
                 if (params.boSort != null && params.boSort != '') {
                    eq("boSort", params.boSort)
                }

                if (params.startDateCreated) {
                ge('startDateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
                }
                if (params.endDateCreated) {
                lt('startDateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
                }
            }
            def total = BoSecurityEvents.createCriteria().count(query)
            def results =BoSecurityEvents.createCriteria().list(params, query)

             def pageNum = 1
             println("params.offset:"+params.offset)
             if(params.offset != null && params.offset != ""){
                 pageNum =  (Integer.parseInt(params.offset) / 10) + 1
             }
            [boSecurityEventsInstanceList: results, boSecurityEventsInstanceTotal: total,pageNum:pageNum]

    }

    def listDownload={

//        params.sort = params.sort ? params.sort : "dateCreated"
//        params.order = params.order ? params.order : "desc"
//        params.max = 50000
//        params.offset = 0

               def query = {
                            if (params.boStatus != null && params.boStatus != '') {
                                eq("boStatus", params.boStatus)
                            }
                             if (params.boSort != null && params.boSort != '') {
                                eq("boSort", params.boSort)
                            }

                            if (params.startDateCreated) {
                            ge('startDateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
                            }
                            if (params.endDateCreated) {
                            lt('startDateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
                            }
                        }
//
                        def total = BoSecurityEvents.createCriteria().count(query)
                        def results =BoSecurityEvents.createCriteria().list(params, query)



        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMdd").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "securityList", model: [boSecurityEventsInstanceList: results])

    }



    def create = {
        def boSecurityEventsInstance = new BoSecurityEvents()
        boSecurityEventsInstance.properties = params
        return [boSecurityEventsInstance: boSecurityEventsInstance]
    }







    def save = {
        def boSecurityEventsInstance = new BoSecurityEvents(params)

        if (boSecurityEventsInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boSecurityEvents.label', default: 'BoSecurityEvents'), boSecurityEventsInstance.id])}"
            redirect(action: "list", id: boSecurityEventsInstance.id)
        }
        else {
            render(view: "create", model: [boSecurityEventsInstance: boSecurityEventsInstance])
        }
    }

    def show = {
        def boSecurityEventsInstance = BoSecurityEvents.get(params.id)
        if (!boSecurityEventsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boSecurityEvents.label', default: 'BoSecurityEvents'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boSecurityEventsInstance: boSecurityEventsInstance]
        }
    }

    def edit = {
        def boSecurityEventsInstance = BoSecurityEvents.get(params.id)
        if (!boSecurityEventsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boSecurityEvents.label', default: 'BoSecurityEvents'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [boSecurityEventsInstance: boSecurityEventsInstance]
        }
    }

    def update = {
        def boSecurityEventsInstance = BoSecurityEvents.get(params.id)
        if (boSecurityEventsInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boSecurityEventsInstance.version > version) {
                    
                    boSecurityEventsInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boSecurityEvents.label', default: 'BoSecurityEvents')] as Object[], "Another user has updated this BoSecurityEvents while you were editing")
                    render(view: "edit", model: [boSecurityEventsInstance: boSecurityEventsInstance])
                    return
                }
            }
            boSecurityEventsInstance.properties = params
            if (!boSecurityEventsInstance.hasErrors() && boSecurityEventsInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boSecurityEvents.label', default: 'BoSecurityEvents'), boSecurityEventsInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boSecurityEventsInstance: boSecurityEventsInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boSecurityEvents.label', default: 'BoSecurityEvents'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def boSecurityEventsInstance = BoSecurityEvents.get(params.id)
        if (boSecurityEventsInstance) {
            try {
                boSecurityEventsInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boSecurityEvents.label', default: 'BoSecurityEvents'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boSecurityEvents.label', default: 'BoSecurityEvents'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boSecurityEvents.label', default: 'BoSecurityEvents'), params.id])}"
            redirect(action: "list")
        }
    }
}
