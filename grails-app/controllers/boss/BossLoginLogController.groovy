package boss


class BossLoginLogController {

    def index = {
        redirect(action: "list", params: params)
    }


    def list = {

        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)

        def boOperator
        def query = {

            if (params.account) {
                boOperator = BoOperator.findAllByAccountIlike('%'+params.account+'%')
                def boOperatorListx = []
                for(operator in boOperator){
                    boOperatorListx<<operator.id
                }
                if(boOperatorListx.empty){
                    isNull('boOperator.id')
                }else{
                    'in'('boOperator.id',boOperatorListx)
                }

            }

            if (params.name) {
                boOperator = BoOperator.findAllByNameIlike('%'+params.name+'%')
                def boOperatorListx = []
                for(operator in boOperator){
                    boOperatorListx<<operator.id
                }
                if(boOperatorListx.empty){
                    isNull('boOperator.id')
                }else{
                    'in'('boOperator.id',boOperatorListx)
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

        def total = BossLoginLog.createCriteria().count(query)
        def bossLoginLogList = BossLoginLog.createCriteria().list(params, query)
        [bossLoginLogInstanceList: bossLoginLogList, bossLoginLogInstanceTotal: total]
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
