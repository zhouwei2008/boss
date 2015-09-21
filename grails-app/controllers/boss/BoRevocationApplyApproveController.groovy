package boss

import ismp.TradeBase
import java.text.DateFormat
import java.text.SimpleDateFormat
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import groovy.sql.Sql
import ismp.CmCustomerOperator
import ismp.CmCustomer
import ebank.tools.StringUtil

class BoRevocationApplyApproveController {
       def  offineRechargeService
  static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

   def index = {
        redirect(action: "list", params: params)
    }

//    def list = {
//        params.max = Math.min(params.max ? params.int('max') : 10, 100)
//        [boOffineChargeInstanceList: BoOfflineCharge.list(params),boOffineChargeInstanceTotal: BoOfflineCharge.count()]
//    }

    def create = {
        def boOfflineChargeInstance = new BoOfflineCharge()


        boOfflineChargeInstance.properties = params
        boOfflineChargeInstance.trxSeq = this.generateOrderID()
        return [boOfflineChargeInstance: boOfflineChargeInstance]
    }


    def save = {
        def boOfflineChargeInstance = new BoOfflineCharge(params)
        def op = session.getValue("op")
        boOfflineChargeInstance.createdate= new Date();
        boOfflineChargeInstance.status="N"
        boOfflineChargeInstance.authsts='N'
        boOfflineChargeInstance.trxtype="void"
        boOfflineChargeInstance.creator_id=op.id
        boOfflineChargeInstance.creator_name= op.account
        boOfflineChargeInstance.branchname = op.branchCompany
        if (boOfflineChargeInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boOffineCharge.label', default: 'boOffineCharge'), boOfflineChargeInstance.accountNo])}"
            redirect(action: "list", id: boOfflineChargeInstance.id)
        }
        else {
            render(view: "create", model: [boOfflineChargeInstance: boOfflineChargeInstance])
        }
    }

    def show = {
        def boRevocationApplyApproveInstance = BoOfflineCharge.get(params.id)
        if (!boRevocationApplyApproveInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRevocationApplyApprove.label', default: 'boRevocationApplyApprove'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boRevocationApplyApproveInstance: boRevocationApplyApproveInstance]
        }
    }






    def list = {
        params.sort = params.sort ? params.sort : "createdate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def op = session.getValue("op")
        def query = {
              def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
            if(boBranchCom!=null){
                eq('branchcode',String.valueOf(boBranchCom.id))
            }
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
              if (params.accountName != null && params.accountName != '') {
                like('accountName', '%' + params.accountName.trim() + '%')
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
               if(params.billmode !=null && params.billmode !=''){
                eq('billmode',params.billmode)
            }
             //guonan update 2011-12-29
            validDated(params)
            ge('createdate', Date.parse('yyyy-MM-dd', params.startTime))
            lt('createdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            eq('trxtype', 'void')
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
        [boRevocationApplyApproveInstanceList: results, boRevocationApplyApproveInstanceTotal: total,flag:flag]
    }


     def listDownload = {
        params.sort = params.sort ? params.sort : "createdate"
        params.order = params.order ? params.order : "desc"
//        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def op = session.getValue("op")
       def query = {
                def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
            if(boBranchCom!=null){
                eq('branchcode',String.valueOf(boBranchCom.id))
            }
            if (params.trxsqe != null && params.trxsqe != '') {
                like('trxSeq', '%' + params.trxsqe.trim() + '%')
            }
            if (params.amount != null && params.amount != '') {
                  String amount = StringUtil.parseAmountFromStr(String.valueOf(params.amount))
                 BigDecimal bd = new BigDecimal(amount);
                eq('amount',bd.longValue())
            }
             if (params.accountName != null && params.accountName != '') {
                like('accountName', '%' + params.accountName.trim() + '%')
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
              if(params.billmode !=null && params.billmode !=''){
                eq('billmode',params.billmode)
            }
             //guonan update 2011-12-29
            validDated(params)
            ge('createdate', Date.parse('yyyy-MM-dd', params.startTime))
            lt('createdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            eq('trxtype', 'void')
        }
        def total = BoOfflineCharge.createCriteria().count(query)
        def results = BoOfflineCharge.createCriteria().list(params, query)

       def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [boOffineChargeInstanceList: results])
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

        def app={
       def boRevocationApplyApproveInstance = BoOfflineCharge.get(params.id)
        if (!boRevocationApplyApproveInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRevocationApplyApprove.label', default: 'boRevocationApplyApprove'), params.id])}"
            redirect(action: "list")
        }
        else {
             def gCalendar= new GregorianCalendar()
            params.billdate=gCalendar.time.format('yyyy-MM-dd')
            [boRevocationApplyApproveInstance: boRevocationApplyApproveInstance]
        }
    }
        def goback={
         redirect(action: "list")
    }
        def refuse={
       def boRevocationApplyApproveInstance = BoOfflineCharge.get(params.id)
        if (!boRevocationApplyApproveInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRevocationApplyApprove.label', default: 'boRevocationApplyApprove'), params.id])}"
            redirect(action: "list")
        }
        else {
            boRevocationApplyApproveInstance.status = "C"
            boRevocationApplyApproveInstance.authsts = "F"
            boRevocationApplyApproveInstance.authdesc=params.authdesc
            boRevocationApplyApproveInstance.authdate = new Date()
            boRevocationApplyApproveInstance.author_id = session.op.id
            boRevocationApplyApproveInstance.author_name = session.op.account
            boRevocationApplyApproveInstance.voidstatus = ""
           if (boRevocationApplyApproveInstance.save(flush: true)) {
                  def _boRevocationApplyApproveInstance = BoOfflineCharge.findByTrxSeq(params.oldSeq);
                      _boRevocationApplyApproveInstance.voidstatus=""
                     _boRevocationApplyApproveInstance.save(flush: true)
                flash.message = "审核拒绝成功"
                redirect(action: "list")
            } else {
                flash.message = "审核拒绝失败"
                [boRevocationApplyApproveInstance: boRevocationApplyApproveInstance]
                render(view: "app", model: [boRevocationApplyApproveInstance: boRevocationApplyApproveInstance])
            }
         }
    }
       def appsave={
       def boRevocationApplyApproveInstance = BoOfflineCharge.get(params.id)
        if (!boRevocationApplyApproveInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRevocationApplyApprove.label', default: 'boRevocationApplyApprove'), params.id])}"
            redirect(action: "list")
        }
        else {
            boRevocationApplyApproveInstance.authdesc=params.authdesc
            boRevocationApplyApproveInstance.authdate = new Date()
            boRevocationApplyApproveInstance.author_id = session.op.id
            boRevocationApplyApproveInstance.author_name = session.op.account
            boRevocationApplyApproveInstance.voidstatus = ""
            //获得原来交易
              def oldTradeBase= TradeBase.findAllByOutTradeNo(boRevocationApplyApproveInstance.oldSeq);
              //创建交易
            def tradeBase = new TradeBase();
             tradeBase.dateCreated  = new Date();
             tradeBase. lastUpdated = new Date();
             tradeBase.tradeNo= createTradeNo()
             tradeBase.tradeType='void'
            if(oldTradeBase!=null&&oldTradeBase.size()>0){
                 tradeBase.payeeCode=oldTradeBase[0].payerCode
                 tradeBase.payeeName=oldTradeBase[0].payerName
                 tradeBase.payeeAccountNo = oldTradeBase[0].payerAccountNo
                 tradeBase.payerAccountNo=oldTradeBase[0].payeeAccountNo
                 tradeBase.payerName = oldTradeBase[0].payeeName
                 tradeBase.payerId = oldTradeBase[0].payeeId
                 tradeBase.payerCode = oldTradeBase[0].payeeCode
            }
             tradeBase.outTradeNo=boRevocationApplyApproveInstance.trxSeq
             tradeBase.amount= boRevocationApplyApproveInstance.amount.toBigDecimal()
             tradeBase.feeAmount=0
             tradeBase.currency='CNY'
             tradeBase.subject='商旅卡账户充值撤销'
             tradeBase.status='starting'
               DateFormat df = new SimpleDateFormat("yyyyMMdd");
             tradeBase.tradeDate=Integer.valueOf(df.format(new Date()));
             tradeBase.note ='';
             tradeBase.paymentType =5;
             tradeBase.serviceType ='offlinepay';
//             tradeBase.save(flush: true)
              if( !tradeBase.save(flush: true) ) {
                tradeBase.errors.each {ee->
                    println ee
                }
              }
            try{
                def result=offineRechargeService.voids(tradeBase,boRevocationApplyApproveInstance);
                  if (result== 'TRADE_SUCCESS') {
                      def _boRevocationApplyApproveInstance = BoOfflineCharge.findByTrxSeq(params.oldSeq);
                      _boRevocationApplyApproveInstance.voidstatus='Y'
                     _boRevocationApplyApproveInstance.save(flush: true)
                    flash.message = "审核成功"
                    redirect(action: "list")
                    } else {
                        flash.message = "审核成功失败}"+result
                    render(view: "app", model: [boRevocationApplyApproveInstance: boRevocationApplyApproveInstance])
                    }
             }catch (Exception e){
                def result
                 if(e instanceof ReChargeExcepiton){
                     result = e.getResultmsg()
                  }
                    flash.message = "审核成功失败}"+result
                    [boRevocationApplyApproveInstance: boRevocationApplyApproveInstance]
                    render(view: "app", model: [boRevocationApplyApproveInstance: boRevocationApplyApproveInstance])
            }
        }
    }
             def createTradeNo(time = new Date()) {
        def prefix ='11'
        def middle = new java.text.SimpleDateFormat('yyMMdd').format(time) // yymmdd
        def ds=DatasourcesUtils.getDataSource('ismp')
        def sql = new Sql(ds)
        def seq = sql.firstRow('select seq_trade_no.NEXTVAL from DUAL')['NEXTVAL']
        prefix + middle + seq.toString().padLeft(7, '0')
    }
}
