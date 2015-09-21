package boss

import ebank.tools.StringUtil
import java.text.SimpleDateFormat
import java.text.DateFormat
import ismp.TradeBase
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import groovy.sql.Sql
import ismp.CmCustomer
import ismp.CmCustomerOperator

class BoOffineRechargeController {

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
        def boOfflineChargeInstance = new BoOfflineCharge(params)
        def op = session.getValue("op")
        boOfflineChargeInstance.createdate= new Date();
        boOfflineChargeInstance.status="N"
        boOfflineChargeInstance.authsts='N'
        boOfflineChargeInstance.trxtype="charge"
        boOfflineChargeInstance.creator_id=op.id
        boOfflineChargeInstance.creator_name= op.account
        boOfflineChargeInstance.branchname = op.branchCompany
        boOfflineChargeInstance.voidstatus=""
        boOfflineChargeInstance.amount=StringUtil.parseAmountFromStr(String.valueOf(params.amount));
        boOfflineChargeInstance.realamount=StringUtil.parseAmountFromStr(String.valueOf(params.realamount));
         def boBranchCom = BoBranchCompany.get(session.op.branchCompany);
        if(boBranchCom){
             boOfflineChargeInstance.branchcode= String.valueOf(boBranchCom.id)
             boOfflineChargeInstance.branchname= boBranchCom.companyName
        }
        if (boOfflineChargeInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boOffineCharge.label', default: 'boOffineCharge'), boOfflineChargeInstance.accountNo])}"
            redirect(action: "list", id: boOfflineChargeInstance.id)
        }
        else {
            render(view: "create", model: [boOfflineChargeInstance: boOfflineChargeInstance])
        }
    }

    def show = {
        def boOfflineChargeInstance = BoOfflineCharge.get(params.id)
        if (!boOfflineChargeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOffineCharge.label', default: 'boOffineCharge'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boOfflineChargeInstance: boOfflineChargeInstance]
        }
    }

    def edit = {
        def boOfflineChargeInstance = BoOfflineCharge.get(params.id)
        if (!boOfflineChargeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOffineCharge.label', default: 'boOffineCharge'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boOfflineChargeInstance: boOfflineChargeInstance]
        }
    }

      def editSave = {
        def boOfflineChargeInstance = BoOfflineCharge.get(params.id)
          def boOfflineCharge = new BoOfflineCharge(params)
          boOfflineChargeInstance.accountNo= boOfflineCharge.accountNo
          boOfflineChargeInstance.billmode= boOfflineCharge.billmode
          boOfflineChargeInstance.amount=   boOfflineCharge.amount
          boOfflineChargeInstance.realamount= boOfflineCharge.realamount
          boOfflineChargeInstance.trxSeq=   boOfflineCharge.trxSeq
        if (boOfflineChargeInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boOffineCharge.label', default: 'boOffineCharge'), boOfflineChargeInstance.accountNo])}"
            redirect(action: "list", id: boOfflineChargeInstance.id)
        }
        else {
            render(view: "create", model: [boOfflineChargeInstance: boOfflineChargeInstance])
        }
    }



    def list = {
        params.sort = params.sort ? params.sort : "createdate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def op = session.getValue("op")
        def query = {
            eq('creator_id',String.valueOf(op.id))//查询本人的单据
            eq('trxtype','charge')  //查询交易状态为充值
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
             if (params.accountNo != null && params.accountNo != '') {
                eq('accountNo', params.accountNo)
            }
            if (params.branchCode != null && params.branchCode != '') {
                eq('branchcode', params.branchCode)
            }
            if (params.authsts != null && params.authsts != '') {
                eq('authsts', params.authsts.trim())
            }
             //guonan update 2011-12-29
            validDated(params)
            ge('createdate', Date.parse('yyyy-MM-dd', params.startTime))
            lt('createdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
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
        [boOffineChargeInstanceList: results, boOffineChargeInstanceTotal: total,flag:flag]
    }


     def listDownload = {
        params.sort = params.sort ? params.sort : "createdate"
        params.order = params.order ? params.order : "desc"
//        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def op = session.getValue("op")
        def query = {
            eq('creator_id',String.valueOf(op.id))
            eq('trxtype','charge')
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
            if (params.authsts != null && params.authsts != '') {
                eq('authsts', params.authsts.trim())
            }
             if (params.accountName != null && params.accountName != '') {
                like('accountName', '%' + params.accountName.trim() + '%')
            }
             if (params.accountNo != null && params.accountNo != '') {
                eq('accountNo', params.accountNo)
            }
             //guonan update 2011-12-29
            validDated(params)
            ge('createdate', Date.parse('yyyy-MM-dd', params.startTime))
            lt('createdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
        }
        def total = BoOfflineCharge.createCriteria().count(query)
        def results = BoOfflineCharge.createCriteria().list(params, query)

       def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [boOffineChargeInstanceList: results])
    }

    def historyList = {
        params.sort = params.sort ? params.sort : "createdate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def op = session.getValue("op")
        def query = {
           def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
            if(boBranchCom!=null){
                eq('branchcode',String.valueOf(boBranchCom.id))
            }
            eq('trxtype','charge')
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
            if (params.authsts != null && params.authsts != '') {
                eq('authsts', params.authsts.trim())
            }
            if(params.billmode !=null && params.billmode !=''){
                eq('billmode',params.billmode)
            }
            if(params.status !=null && params.status !=''){
                eq('status',params.status)
            }
             if (params.accountName != null && params.accountName != '') {
                like('accountName', '%' + params.accountName.trim() + '%')
            }
             if (params.accountNo != null && params.accountNo != '') {
                eq('accountNo', params.accountNo)
             }
             //guonan update 2011-12-29
            validDated(params)
            ge('createdate', Date.parse('yyyy-MM-dd', params.startTime))
            lt('createdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
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
        [boOffineChargeInstanceList: results, boOffineChargeInstanceTotal: total,flag:flag]
    }

     def historyListDownload = {
        params.sort = params.sort ? params.sort : "createdate"
        params.order = params.order ? params.order : "desc"
//        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def op = session.getValue("op")
        def query = {
         def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
            if(boBranchCom!=null){
                eq('branchcode',String.valueOf(boBranchCom.id))
            }
            eq('trxtype','charge')
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
            if (params.authsts != null && params.authsts != '') {
                eq('authsts', params.authsts.trim())
            }
            if(params.billmode !=null && params.billmode !=''){
                eq('billmode',params.billmode)
            }
            if(params.status !=null && params.status !=''){
                eq('status',params.status)
            }
             if (params.accountName != null && params.accountName != '') {
                like('accountName', '%' + params.accountName.trim() + '%')
            }
             if (params.accountNo != null && params.accountNo != '') {
                eq('accountNo', params.accountNo)
             }
             //guonan update 2011-12-29
            validDated(params)
            ge('createdate', Date.parse('yyyy-MM-dd', params.startTime))
            lt('createdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
        }
        def total = BoOfflineCharge.createCriteria().count(query)
        def results = BoOfflineCharge.createCriteria().list(params, query)

       def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [boOffineChargeInstanceList: results])
    }

    def checkList = {
        params.sort = params.sort ? params.sort : "createdate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def op = session.getValue("op")
        String[] strs =['Y','P','F']
        def query = {
            'in'('authsts',strs)
            def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
            if(boBranchCom!=null){
                eq('branchcode',String.valueOf(boBranchCom.id))
            }
            if (params.trxsqe != null && params.trxsqe != '') {
                like('trxSeq', '%' + params.trxsqe.trim() + '%')
            }
            if (params.trxtype != null && params.trxtype != '') {
                like('trxtype', '%' + params.trxtype.trim() + '%')
            }
            if (params.amount != null && params.amount != '') {
                  String amount = StringUtil.parseAmountFromStr(String.valueOf(params.amount))
                 BigDecimal bd = new BigDecimal(amount);
                eq('amount',bd.longValue())
            }
            if (params.author_name != null && params.author_name != '') {
                like('author_name', '%' + params.author_name.trim() + '%')
            }
            if (params.branchCode != null && params.branchCode != '') {
                eq('branchcode', params.branchCode)
            }
            if (params.authsts != null && params.authsts != '') {
                eq('authsts', params.authsts.trim())
            }
            if(params.billmode !=null && params.billmode !=''){
                eq('billmode',params.billmode)
            }
            if(params.status !=null && params.status !=''){
                eq('status',params.status)
            }
             if (params.accountName != null && params.accountName != '') {
                like('accountName', '%' + params.accountName.trim() + '%')
            }
             if (params.accountNo != null && params.accountNo != '') {
                eq('accountNo', params.accountNo)
             }
             //guonan update 2011-12-29
            validDated(params)
            ge('authdate', Date.parse('yyyy-MM-dd', params.startTime))
            lt('authdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
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
        [boOffineChargeInstanceList: results, boOffineChargeInstanceTotal: total,flag:flag]
    }

      def checkListDown = {
        params.sort = params.sort ? params.sort : "createdate"
        params.order = params.order ? params.order : "desc"
//        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def op = session.getValue("op")
        String[] strs =['Y','P','F']
        def query = {
            'in'('authsts',strs)
            def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
            if(boBranchCom!=null){
                eq('branchcode',String.valueOf(boBranchCom.id))
            }
            if (params.trxsqe != null && params.trxsqe != '') {
                like('trxSeq', '%' + params.trxsqe.trim() + '%')
            }
               if (params.trxtype != null && params.trxtype != '') {
                like('trxtype', '%' + params.trxtype.trim() + '%')
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
            if (params.authsts != null && params.authsts != '') {
                eq('authsts', params.authsts.trim())
            }
            if(params.billmode !=null && params.billmode !=''){
                eq('billmode',params.billmode)
            }
            if(params.status !=null && params.status !=''){
                eq('status',params.status)
            }
             if (params.accountName != null && params.accountName != '') {
                like('accountName', '%' + params.accountName.trim() + '%')
            }
             if (params.accountNo != null && params.accountNo != '') {
                eq('accountNo', params.accountNo)
             }
             //guonan update 2011-12-29
            validDated(params)
            ge('createdate', Date.parse('yyyy-MM-dd', params.startTime))
            lt('createdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
        }
        def total = BoOfflineCharge.createCriteria().count(query)
        def results = BoOfflineCharge.createCriteria().list(params, query)
        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "historyTradeList", model: [boOffineChargeInstanceList: results])
    }

     def applist = {
        params.sort = params.sort ? params.sort : "createdate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def op = session.getValue("op")
        def query = {
            eq('authsts','N')
            eq('trxtype','charge')
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
            if(params.billmode !=null && params.billmode !=''){
                eq('billmode',params.billmode)
            }

            if (params.branchCode != null && params.branchCode != '') {
                eq('branchcode', params.branchCode)
            }
             if (params.accountName != null && params.accountName != '') {
                like('accountName', '%' + params.accountName.trim() + '%')
            }
             if (params.accountNo != null && params.accountNo != '') {
                eq('accountNo', params.accountNo)
             }
             //guonan update 2011-12-29
            validDated(params)
            ge('createdate', Date.parse('yyyy-MM-dd', params.startTime))
            lt('createdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
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
        [boOffineChargeInstanceList: results, boOffineChargeInstanceTotal: total,flag:flag]
    }

    def applistDown = {
        params.sort = params.sort ? params.sort : "createdate"
        params.order = params.order ? params.order : "desc"
//        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def op = session.getValue("op")
        def query = {
            eq('authsts','N')
            eq('trxtype','charge')
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
              if(params.billmode !=null && params.billmode !=''){
                eq('billmode',params.billmode)
            }
            if (params.branchCode != null && params.branchCode != '') {
                eq('branchcode', params.branchCode)
            }
             if (params.accountName != null && params.accountName != '') {
                like('accountName', '%' + params.accountName.trim() + '%')
            }
             if (params.accountNo != null && params.accountNo != '') {
                eq('accountNo', params.accountNo)
             }
             //guonan update 2011-12-29
            validDated(params)
            ge('createdate', Date.parse('yyyy-MM-dd', params.startTime))
            lt('createdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
        }
        def total = BoOfflineCharge.createCriteria().count(query)
        def results = BoOfflineCharge.createCriteria().list(params, query)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [boOffineChargeInstanceList: results])
    }

    def app={
       def boOfflineChargeInstance = BoOfflineCharge.get(params.id)
        if (!boOfflineChargeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOffineCharge.label', default: 'boOffineCharge'), params.id])}"
            redirect(action: "applist")
        }
        else {
             def gCalendar= new GregorianCalendar()
            params.billdate=gCalendar.time.format('yyyy-MM-dd')
            [boOfflineChargeInstance: boOfflineChargeInstance]
        }
    }

   def appsave={
       def boOfflineChargeInstance = BoOfflineCharge.get(params.id)
        if (!boOfflineChargeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOffineCharge.label', default: 'boOffineCharge'), params.id])}"
            redirect(action: "applist")
        }
        else {
            boOfflineChargeInstance.recepit=params.recepit
            boOfflineChargeInstance.billref=params.billref
            boOfflineChargeInstance.billdate=params.billdate
            boOfflineChargeInstance.authdesc=params.authdesc
            boOfflineChargeInstance.authdate = new Date()
            boOfflineChargeInstance.author_id = session.op.id
            boOfflineChargeInstance.author_name = session.op.account
            boOfflineChargeInstance.voidstatus=""
              //创建交易
            def tradeBase = new TradeBase();

             tradeBase.dateCreated  = new Date();
             tradeBase. lastUpdated = new Date();
             tradeBase.tradeNo= createTradeNo()
             tradeBase.tradeType='charge'
             def boBankDic
             def  bomer = BoMerchant.findAllByAcquireIndexc('BCARD')
             def  acq
             if(bomer!=null&&bomer.size()>0){
                 tradeBase.payerCode= 'BCARD'
                 tradeBase.payerName= bomer[0].acquireName
                  acq = bomer[0].acquirerAccount
                  tradeBase.payerAccountNo = acq.innerAcountNo
             }
             tradeBase.payeeAccountNo=boOfflineChargeInstance.accountNo
            //查询收款人信息
             def cmCustomer = CmCustomer.findAllByAccountNo(boOfflineChargeInstance.accountNo);
             if(cmCustomer!=null&&cmCustomer.size()>0){
                 def cmcoustomerInstance = cmCustomer[0];
                    tradeBase.payeeName = cmcoustomerInstance.name
                    tradeBase.payeeId = cmcoustomerInstance.id
                def cmOperate = CmCustomerOperator.findAllByCustomer(cmcoustomerInstance)
                  if(cmOperate!=null&&cmOperate.size()>0){
                     tradeBase.payeeCode = cmOperate[0].defaultEmail
                  }
             }
             tradeBase.outTradeNo=boOfflineChargeInstance.trxSeq
             tradeBase.amount= boOfflineChargeInstance.amount.toBigDecimal()
             tradeBase.feeAmount=0
             tradeBase.currency='CNY'
             tradeBase.subject='商旅卡账户充值'
             tradeBase.status='starting'
               DateFormat df = new SimpleDateFormat("yyyyMMdd");
             tradeBase.tradeDate=Integer.valueOf(df.format(new Date()));
             def note  = boOfflineChargeInstance.note;
            if(note!=null&&note!=''&&note.length()>64){
                  note=note.substring(0,64);
            }
             tradeBase. note = note
             tradeBase.paymentType =5;
             tradeBase.serviceType ='offlinepay';
//             tradeBase.save(flush: true)
              if( !tradeBase.save(flush: true) ) {
                tradeBase.errors.each {ee->
                    println ee
                }
              }
            try{
                def result=offineRechargeService.charge(tradeBase,boOfflineChargeInstance);
                  if (result== 'TRADE_SUCCESS') {
                    flash.message = "审核成功"
                    redirect(action: "applist")
                    } else {
                        flash.message = "审核成功失败"+result
                    render(view: "app", model: [boOfflineChargeInstance: boOfflineChargeInstance])
                    }
             }catch (Exception e){
                def result
                 if(e instanceof ReChargeExcepiton){
                     result = e.getResultmsg()
                  }
                    flash.message = "审核成功失败"+result
                    [boOfflineChargeInstance: boOfflineChargeInstance]
                    render(view: "app", model: [boOfflineChargeInstance: boOfflineChargeInstance])
            }
        }
    }

    def refuse={
       def boOfflineChargeInstance = BoOfflineCharge.get(params.id)
        if (!boOfflineChargeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOffineCharge.label', default: 'boOffineCharge'), params.id])}"
            redirect(action: "applist")
        }
        else {
            boOfflineChargeInstance.status = "F"
            boOfflineChargeInstance.authsts = "F"
            boOfflineChargeInstance.authdesc=params.authdesc
            boOfflineChargeInstance.authdate = new Date()
            boOfflineChargeInstance.author_id = session.op.id
            boOfflineChargeInstance.author_name = session.op.account
            boOfflineChargeInstance.voidstatus=""
            if (boOfflineChargeInstance.save(flush: true)) {
                flash.message = "审核拒绝成功"
                redirect(action: "applist")
            } else {
                flash.message = "审核拒绝失败"
                [boOfflineChargeInstance: boOfflineChargeInstance]
                render(view: "app", model: [boOfflineChargeInstance: boOfflineChargeInstance])
            }
         }
    }

    def goback={
         redirect(action: "applist")
    }

    def  generateOrderID={
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


     def createTradeNo(time = new Date()) {
        def prefix ='11'
        def middle = new java.text.SimpleDateFormat('yyMMdd').format(time) // yymmdd
        def ds=DatasourcesUtils.getDataSource('ismp')
        def sql = new Sql(ds)
        def seq = sql.firstRow('select seq_trade_no.NEXTVAL from DUAL')['NEXTVAL']
        prefix + middle + seq.toString().padLeft(7, '0')
    }


     def accountList = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def query = {
            eq('status','normal')
            eq('customerCategory','travel')
            if (params.accountNo != null && params.accountNo != '') {
                like('accountNo', '%' + params.accountNo.trim() + '%')
            }
            if (params.name != null && params.name != '') {
                like('name', '%' + params.name.trim() + '%')
            }
             if (params.customerNo != null && params.customerNo != '') {
                like('customerNo', '%' + params.customerNo.trim() + '%')
            }
        }
        def total = CmCustomer.createCriteria().count(query)
        def results = CmCustomer.createCriteria().list(params, query)
        [cmCustomerInstanceList: results, cmCustomerInstanceTotal: total]
    }

}
