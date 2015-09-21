package ismp


class CmCustomerController {

    static allowedMethods = [save: "POST", save: "GET", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)

        def type = ''
        if(params.type == null || params.type == ''){
            type = 'C'
        }else{
            type = params.type
        }

        def query = {
            if (params.customerNo != null && params.customerNo != '') {
                eq("customerNo",params.customerNo)
            }
            if (params.name != null && params.name != '') {
                like("name", "%" + params.name.trim() + "%")
            }

            eq("type",type)

            if (params.status != null && params.status != '') {
                eq("status",params.status)
            }
        }
        if(type == 'C'){
            def  cmCorporationInfo = CmCorporationInfo.createCriteria().list(params,query)
            def total = CmCustomer.createCriteria().count(query)
            [cmCorporationInfoInstanceList: cmCorporationInfo, cmCorporationInfoInstanceTotal: total,type:type]

        }else if(type == 'P'){
            def total = CmPersonalInfo.createCriteria().count(query)
            def results = CmPersonalInfo.createCriteria().list(params, query)
            [cmPersonalInfoInstanceList: results, cmPersonalInfoInstanceTotal: total,type:type]
        }
    }


    def save = {
        def cmCustomerInstant = CmCustomer.get(params.id)
        if(cmCustomerInstant.status=='normal'){
              cmCustomerInstant.openStatus = 0
              cmCustomerInstant.closeStatus =  ''
//            cmCustomerInstant.status='disabled'
        }else{
//           cmCustomerInstant.status='normal'
             cmCustomerInstant.closeStatus = 0
             cmCustomerInstant.openStatus =  ''
        }
        cmCustomerInstant.save(flash: true, flush: true)

        redirect(action: "list",type:cmCustomerInstant.type)
    }

    def verify = {
        def cmCustomerInstant = CmCustomer.get(params.id)

        if(cmCustomerInstant.openStatus == '0'){
            cmCustomerInstant.openStatus = 1
            cmCustomerInstant.closeStatus = ''
            cmCustomerInstant.status='disabled'

        }else if(cmCustomerInstant.closeStatus == '0'){
            cmCustomerInstant.closeStatus = 1
            cmCustomerInstant.openStatus = ''
            cmCustomerInstant.status='normal'
        }
        cmCustomerInstant.save(flash: true, flush: true)
        redirect(action: "list",type:cmCustomerInstant.type)

    }
}
