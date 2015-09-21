package settle

import account.AccountClientService
import ismp.CmCustomer
import ismp.CmCorporationInfo

class StCustomerController {

    AccountClientService  accountClientService

      static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

      def index = {
          redirect(action: "list", params: params)
      }


      def list = {
          
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def query = {
               if (params.customerNo != null && params.customerNo != '') {
                    like("customerNo", "%" +params.customerNo + "%")
            }
             if (params.name != null && params.name != '') {
                   like("registrationName", "%" + params.name.trim() + "%")
            }
        }
        def total = CmCorporationInfo.createCriteria().count(query)
        def    results=CmCorporationInfo.createCriteria().list(params,query)
        [ftCustomerList: results, ftCustomerTotal: total, params: params]

      }


}

