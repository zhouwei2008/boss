package gateway

class GwSubOrdersController {
    def list = {
        params.sort = params.sort ? params.sort : "createdate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        println "###################params${params}"

        def query = {
            if (params.gwordersid) eq 'gwordersid', params.gwordersid
        }

        def count = GwSubOrders.createCriteria().count(query)
        def list = GwSubOrders.createCriteria().list(params,query)

        println "###################list${list}"
        println "###################count${count}"

        [gwSubOrdersInstanceList: list, gwSubOrdersInstanceTotal: count]
    }
}