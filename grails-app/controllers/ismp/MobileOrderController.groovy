package ismp

import gateway.GwOrder

class MobileOrderController {

    def index = {
        redirect(action: "list", params: params)
    }


    def list = {

        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def cmCustomers
        def query = {
            if (params.customerNo) {
                cmCustomers = CmCustomer.findAllByCustomerNoIlike('%'+params.customerNo+'%')
                def customerNoListx = []
                for(customer in cmCustomers){
                    customerNoListx<<customer.id
                }
                if(customerNoListx.size()>0){
                    'in'('customer.id',customerNoListx)
                }else{
                    isNull('id')
                }
            }

            validDated(params)

            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
        }

        def total = MobileOrder.createCriteria().count(query)
        def mobileOrderList = MobileOrder.createCriteria().list(params, query)
        [mobileOrderList: mobileOrderList, mobileOrderTotal: total, params: params]
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
}
