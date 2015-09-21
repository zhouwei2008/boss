package ismp

import ebank.tools.StringUtil

class MapiAsyncNotifyController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def query = {
            if (params.orderNum != null && params.orderNum != '') {
                record {
                    like('outTradeNo', '%'+params.orderNum+'%')
                }
            }
            if (params.subject != null && params.subject != '') {
                record {
                    like('subject','%'+ params.subject+'%')
                }
            }
            if (params.bodys != null && params.bodys != '') {
                record {
                    like('body', '%'+params.bodys+'%')
                }
            }
            if (params.amount != null && params.amount != '') {
                record {
                    eq('amount', StringUtil.parseAmountFromStr(params.amount))
                }
            }
//            if (params.startDateCreated != null && params.startDateCreated != '') {
//                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
//            }
//            if (params.endDateCreated != null && params.endDateCreated != '') {
//                le('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
//            }
//            if (params.startLastUpdated != null && params.startLastUpdated != '') {
//                ge('lastUpdated', Date.parse('yyyy-MM-dd', params.startLastUpdated))
//            }
//            if (params.endLastUpdated != null && params.endLastUpdated != '') {
//                le('lastUpdated', Date.parse('yyyy-MM-dd', params.endLastUpdated) + 1)
//            }
//            if (params.startNotifyTime != null && params.startNotifyTime != '') {
//                ge('notifyTime', Date.parse('yyyy-MM-dd', params.startNotifyTime))
//            }
//            if (params.endNotifyTime != null && params.endNotifyTime != '') {
//                le('notifyTime', Date.parse('yyyy-MM-dd', params.endNotifyTime) + 1)
//            }
            if (params.status != null && params.status != '') {
                eq('status', params.status)
            }
            if (params.notifyMethod != null && params.notifyMethod != '') {
                eq('notifyMethod', params.notifyMethod)
            }
            if (params.notifyAddress != null && params.notifyAddress != '') {
                like('notifyAddress', '%'+params.notifyAddress+'%')
            }
            if (params.response != null && params.response != '') {
                like('response', '%'+params.response+'%')
            }


            //guonan update 2011-12-29
            validDated(params)
            if (params.startDateCreated) {
            ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
            lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
            //guonan update 2011-12-29
//            validLastDated(params)
            if (params.startLastUpdated) {
            ge('lastUpdated', Date.parse('yyyy-MM-dd', params.startLastUpdated))
            }
            if (params.endLastUpdated) {
            lt('lastUpdated', Date.parse('yyyy-MM-dd', params.endLastUpdated) + 1)
            }
            //guonan update 2011-12-29
//            validNotifyTimed(params)
            if (params.startNotifyTime) {
            ge('notifyTime', Date.parse('yyyy-MM-dd', params.startNotifyTime))
            }
             if (params.endNotifyTime) {
            lt('notifyTime', Date.parse('yyyy-MM-dd', params.endNotifyTime) + 1)
             }
            eq('recordTable', 'GWORDERS')
        }
        def total = MapiAsyncNotify.createCriteria().count(query)
        def gwOrderList = MapiAsyncNotify.createCriteria().list(params, query)
        [mapiAsyncNotifyInstanceList: gwOrderList, mapiAsyncNotifyInstanceTotal: total]
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

        /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan
     *
     */
    def validLastDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startLastUpdated==null && params.endLastUpdated==null){
            def gCalendar= new GregorianCalendar()
            params.endLastUpdated=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startLastUpdated=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startLastUpdated && !params.endLastUpdated){
             params.endLastUpdated=params.startLastUpdated
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startLastUpdated && params.endLastUpdated){
             params.startLastUpdated=params.endLastUpdated
        }
        if (params.startLastUpdated && params.endLastUpdated) {


        }
    }

        /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan
     *
     */
    def validNotifyTimed(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startNotifyTime==null && params.endNotifyTime==null){
            def gCalendar= new GregorianCalendar()
            params.endNotifyTime=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startNotifyTime=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startNotifyTime && !params.endNotifyTime){
             params.endNotifyTime=params.startNotifyTime
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startNotifyTime && params.endNotifyTime){
             params.startNotifyTime=params.endNotifyTime
        }
        if (params.startNotifyTime && params.endNotifyTime) {


        }
    }

    def create = {
        def mapiAsyncNotifyInstance = new MapiAsyncNotify()
        mapiAsyncNotifyInstance.properties = params
        return [mapiAsyncNotifyInstance: mapiAsyncNotifyInstance]
    }

    def save = {
        def mapiAsyncNotifyInstance = new MapiAsyncNotify(params)
        if (mapiAsyncNotifyInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'mapiAsyncNotify.label', default: 'MapiAsyncNotify'), mapiAsyncNotifyInstance.id])}"
            redirect(action: "list", id: mapiAsyncNotifyInstance.id)
        }
        else {
            render(view: "create", model: [mapiAsyncNotifyInstance: mapiAsyncNotifyInstance])
        }
    }

    def show = {
        def mapiAsyncNotifyInstance = MapiAsyncNotify.get(params.id)
        if (!mapiAsyncNotifyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'mapiAsyncNotify.label', default: 'MapiAsyncNotify'), params.id])}"
            redirect(action: "list")
        }
        else {
            [mapiAsyncNotifyInstance: mapiAsyncNotifyInstance]
        }
    }

    def edit = {
        def mapiAsyncNotifyInstance = MapiAsyncNotify.get(params.id)
        if (!mapiAsyncNotifyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'mapiAsyncNotify.label', default: 'MapiAsyncNotify'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [mapiAsyncNotifyInstance: mapiAsyncNotifyInstance]
        }
    }
    def updateStatus = {
        def mapiAsyncNotifyInstance = MapiAsyncNotify.get(params.id)
        def now = new Date()
        mapiAsyncNotifyInstance.status = 'processing'
        mapiAsyncNotifyInstance.nextAttemptTime = new Date(now.time - 3600000)
        mapiAsyncNotifyInstance.timeExpired = new Date(now.time + 3600000)
        mapiAsyncNotifyInstance.notifyMethod = 'http'
        mapiAsyncNotifyInstance.save(flush: true, flash: true)
        redirect(action: "list", id: mapiAsyncNotifyInstance.id)
    }

    def update = {
        def mapiAsyncNotifyInstance = MapiAsyncNotify.get(params.id)
        if (mapiAsyncNotifyInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (mapiAsyncNotifyInstance.version > version) {

                    mapiAsyncNotifyInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'mapiAsyncNotify.label', default: 'MapiAsyncNotify')] as Object[], "Another user has updated this MapiAsyncNotify while you were editing")
                    render(view: "edit", model: [mapiAsyncNotifyInstance: mapiAsyncNotifyInstance])
                    return
                }
            }
            mapiAsyncNotifyInstance.properties = params
            if (!mapiAsyncNotifyInstance.hasErrors() && mapiAsyncNotifyInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'mapiAsyncNotify.label', default: 'MapiAsyncNotify'), mapiAsyncNotifyInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [mapiAsyncNotifyInstance: mapiAsyncNotifyInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'mapiAsyncNotify.label', default: 'MapiAsyncNotify'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def mapiAsyncNotifyInstance = MapiAsyncNotify.get(params.id)
        if (mapiAsyncNotifyInstance) {
            try {
                mapiAsyncNotifyInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'mapiAsyncNotify.label', default: 'MapiAsyncNotify'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'mapiAsyncNotify.label', default: 'MapiAsyncNotify'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'mapiAsyncNotify.label', default: 'MapiAsyncNotify'), params.id])}"
            redirect(action: "list")
        }
    }
}
