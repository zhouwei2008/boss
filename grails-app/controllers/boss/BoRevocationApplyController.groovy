package boss

import ebank.tools.StringUtil

class BoRevocationApplyController {

     static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

   def index = {
        redirect(action: "list", params: params)
    }



    def create = {
       def boRevocationApplyInstance = BoOfflineCharge.get(params.id)
        if (!boRevocationApplyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRevocationApply.label', default: 'boRevocationApply'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boRevocationApplyInstance: boRevocationApplyInstance]
        }
    }


    def save = {
          //判断是否在日终时间之前，如果在则可以申请，如果不在则不允许申请
         def timelist = BoRechargeTime.findAllByStatus(0);
        def startDate,startHour,startMins
        def endDate,endHour,endMins
        if(timelist!=null&&timelist.size()>1){
            startHour = Integer.valueOf(timelist.get(0).allowHour)
            startMins = Integer.valueOf(timelist.get(0).allowMits)
            endHour = Integer.valueOf(timelist.get(1).allowHour)
            endMins = Integer.valueOf(timelist.get(1).allowMits)
        }else{
            flash.message = "请联系总部设置日终时间！"
            redirect(action: "list")
        }
        def nowHour = new Date().hours;
        def nowMins = new Date().minutes;
        if(nowHour<startHour||(nowHour==startHour&&startMins>nowMins)){
            flash.message = "申请尚未开始，请耐心等待！"
            redirect(action: "list")
            return
        }
        if(nowHour>endHour||(nowHour==endHour&&endMins<nowMins)){
            flash.message = "申请已经结束，请下一时间段申请！"
            redirect(action: "list")
            return
        }

              def _boRevocationApplyInstance = BoOfflineCharge.get(params.id)
         _boRevocationApplyInstance.voidstatus='N'
        def boRevocationApplyInstance = new BoOfflineCharge(params)
        def op = session.getValue("op")
        boRevocationApplyInstance.createdate= new Date();
        boRevocationApplyInstance.status="N"
        boRevocationApplyInstance.authsts='N'
        boRevocationApplyInstance.trxtype="void"
        boRevocationApplyInstance.creator_id=op.id
        boRevocationApplyInstance.creator_name= op.account
        boRevocationApplyInstance.branchname = op.branchCompany
        boRevocationApplyInstance.voidstatus = ""
         def boBranchCom = BoBranchCompany.get(session.op.branchCompany);
         boRevocationApplyInstance.branchcode= String.valueOf(boBranchCom?.id)
         boRevocationApplyInstance.branchname= boBranchCom?.companyName
        boRevocationApplyInstance.trxSeq = this.generateOrderID()
        boRevocationApplyInstance.oldSeq = _boRevocationApplyInstance.trxSeq
         boRevocationApplyInstance.recepit = _boRevocationApplyInstance.recepit
         boRevocationApplyInstance.billdate = _boRevocationApplyInstance.billdate
         boRevocationApplyInstance.billref = _boRevocationApplyInstance.billref
        if (boRevocationApplyInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boRevocationApply.label', default: 'boRevocationApply'), boRevocationApplyInstance.accountNo])}"
            redirect(action: "list", id: boRevocationApplyInstance.id)

            _boRevocationApplyInstance.save(flush: true)
        }
        else {
            render(view: "create", model: [boRevocationApplyInstance: boRevocationApplyInstance])
        }
    }

    def show = {
        def boRevocationApplyInstance = BoOfflineCharge.get(params.id)
        if (!boRevocationApplyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRevocationApply.label', default: 'boRevocationApply'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boRevocationApplyInstance: boRevocationApplyInstance]
        }
    }

    def list = {
        params.sort = params.sort ? params.sort : "createdate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def op = session.getValue("op")
        def query = {
            eq('creator_id',String.valueOf(op.id))
            if (params.trxsqe != null && params.trxsqe != '') {
                like('trxSeq', '%' + params.trxsqe.trim() + '%')
            }
            if (params.amount != null && params.amount != '') {
                 String amount = StringUtil.parseAmountFromStr(String.valueOf(params.amount))
                 BigDecimal bd = new BigDecimal(amount);
                eq('amount',bd.longValue())
            }
            if (params.creator_name != null && params.creator_name != '') {
                like('creator_name', '%' + params.creator_name.trim() + '%')
            }
            if (params.branchCode != null && params.branchCode != '') {
                eq('branchcode', params.branchCode)
            }
               if (params.accountName != null && params.accountName != '') {
                like('accountName', '%' + params.accountName.trim() + '%')
            }
              if (params.oldSeq != null && params.oldSeq != '') {
                like('oldSeq', '%' + params.oldSeq.trim() + '%')
            }
            if (params.authsts != null && params.authsts != '') {
                eq('authsts', params.authsts.trim())
            }
             //guonan update 2011-12-29
            validDated(params)
            ge('createdate', Date.parse('yyyy-MM-dd', params.startTime))
            lt('createdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
           // eq('trxtype', 'void')

        }
        def total = BoOfflineCharge.createCriteria().count(query)
        def results = BoOfflineCharge.createCriteria().list(params, query)
        def flag
          def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
            if(boBranchCom!=null){
                params.branchCode =String.valueOf(boBranchCom.id)
                flag = true
            }else{
                flag = false
            }
        [boRevocationApplyInstanceList: results, boRevocationApplyInstanceTotal: total,flag:flag]
    }


     def listDownload = {
        params.sort = params.sort ? params.sort : "createdate"
        params.order = params.order ? params.order : "desc"
//        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def op = session.getValue("op")
       def query = {
            eq('creator_id',String.valueOf(op.id))
            if (params.trxsqe != null && params.trxsqe != '') {
                like('trxSeq', '%' + params.trxsqe.trim() + '%')
            }
            if (params.amount != null && params.amount != '') {
                 String amount = StringUtil.parseAmountFromStr(String.valueOf(params.amount))
                 BigDecimal bd = new BigDecimal(amount);
                eq('amount',bd.longValue())
            }
            if (params.creator_name != null && params.creator_name != '') {
                like('creator_name', '%' + params.creator_name.trim() + '%')
            }
            if (params.branchCode != null && params.branchCode != '') {
                eq('branchcode', params.branchCode)
            }

              if (params.oldSeq != null && params.oldSeq != '') {
                like('oldSeq', '%' + params.oldSeq.trim() + '%')
            }
            if (params.authsts != null && params.authsts != '') {
                eq('authsts', params.authsts.trim())
            }
             if (params.accountName != null && params.accountName != '') {
                like('accountName', '%' + params.accountName.trim() + '%')
            }
             //guonan update 2011-12-29
            validDated(params)
            ge('createdate', Date.parse('yyyy-MM-dd', params.startTime))
            lt('createdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
        //    eq('trxtype', 'void')
        }

        def results = BoOfflineCharge.createCriteria().list(params, query)

       def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [boRevocationApplyInstanceList: results])
    }

    def String generateOrderID(){
		String str="";
		Random rd=new Random();
        java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyyMMddHHmmss");
        Date date = new Date();
		for(int i=0;i<2;i++) str+=rd.nextInt(10);
		rd=null;
		return sdf.format(date)+str;
	}

    def validDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (!params.startTime && !params.endTime){
            def gCalendar= new GregorianCalendar()
            params.endTime=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startTime=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startTime && !params.endTime){
             params.endTime=params.startTime
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startTime && params.endTime){
             params.startTime=params.endTime
        }
        if (params.startTime && params.endTime) {


        }
    }
}
