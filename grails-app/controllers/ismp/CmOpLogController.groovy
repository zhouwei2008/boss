package ismp

import org.apache.xmlbeans.QNameSet

class CmOpLogController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def opRelations,cmCustomers
        def query = {
            if (params.names) {
                opRelations = CmOpRelation.findAllByNamesIlike('%'+params.names+'%')
                def controllerListx = []
                def actionListx = []
                if(opRelations!=null&&opRelations.size()>0){
                     for(opRelation in opRelations){
                         controllerListx<<opRelation.controllers
                         actionListx<<opRelation.actions
                     }
                } else{
                     controllerListx << '00'
                     actionListx << '00'
                }
                'in'('controller',controllerListx)
                'in'('action',actionListx)
            }
            if (params.customerNo) {
                 like('customerNo', "%"+params.customerNo+"%")
            }
            if (params.customerName) {
                 cmCustomers = CmCustomer.findAllByNameIlike('%'+params.customerName+'%')
                def customerNoListx = []
                 for(customer in cmCustomers){
                     customerNoListx<<customer.customerNo
                 }
                'in'('customerNo',customerNoListx)
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
        def total = CmOpLog.createCriteria().count(query)
        def gwOrderList = CmOpLog.createCriteria().list(params, query)
        [cmOpLogInstanceList: gwOrderList, cmOpLogInstanceTotal: total]
    }

    def listDownload = {

        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = 1000
        params.offset = 0

        def opRelations,cmCustomers
        def query = {
            if (params.names) {
                opRelations = CmOpRelation.findAllByNamesIlike('%'+params.names+'%')
                def controllerListx = []
                def actionListx = []
                if(opRelations!=null&&opRelations.size()>0){
                    for(opRelation in opRelations){
                        controllerListx<<opRelation.controllers
                        actionListx<<opRelation.actions
                    }
                } else{
                    controllerListx << '00'
                    actionListx << '00'
                }
                'in'('controller',controllerListx)
                'in'('action',actionListx)
            }
            if (params.customerNo) {
                like('customerNo', "%"+params.customerNo+"%")
            }
            if (params.customerName) {
                cmCustomers = CmCustomer.findAllByNameIlike('%'+params.customerName+'%')
                def customerNoListx = []
                for(customer in cmCustomers){
                    customerNoListx<<customer.customerNo
                }
                'in'('customerNo',customerNoListx)
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

        def cmOpLogs = CmOpLog.createCriteria().list(params, query)
        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "list", model: [cmOpLogs: cmOpLogs])

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
        def orderNames = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
         def opRelations,cmCustomers
        def query = {
            if (params.names) {
                opRelations = CmOpRelation.findAllByNamesIlike('%'+params.names+'%')
                def controllerListx = []
                def actionListx = []
                 for(opRelation in opRelations){
                     controllerListx<<opRelation.controllers
                     actionListx<<opRelation.actions
                 }
                'in'('controller',controllerListx)
                'in'('action',actionListx)
            }
            if (params.customerNo) {
                 like('customerNo', "%"+params.customerNo+"%")
            }
            if (params.customerName) {
                 cmCustomers = CmCustomer.findAllByNameIlike('%'+params.customerName+'%')
                def customerNoListx = []
                 for(customer in cmCustomers){
                     customerNoListx<<customer.customerNo
                 }
                'in'('customerNo',customerNoListx)
            }

            if (params.account) {
                like('account', "%"+params.account+"%")
            }
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated != null && params.endDateCreated != '') {
                le('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
        }
        def total = CmOpLog.createCriteria().count(query)
        def gwOrderList = CmOpLog.createCriteria().list(params, query)
        [cmOpLogInstanceList: gwOrderList, cmOpLogInstanceTotal: total]
    }

    def show = {
        def cmOpLogInstance = CmOpLog.get(params.id)
        if (!cmOpLogInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmOpLog.label', default: 'CmOpLog'), params.id])}"
            redirect(action: "list")
        }
        else {
            [cmOpLogInstance: cmOpLogInstance]
        }
    }
}
