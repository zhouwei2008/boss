package account

import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.multipart.commons.CommonsMultipartFile
import ismp.CmCustomer
import boss.BoCustomerService
import boss.BoBankDic
import boss.BoInnerAccount
import boss.BoAcquirerAccount
import ismp.TradeBase
import java.text.SimpleDateFormat
import settle.FtTrade

class AcSequentialController {

    AccountClientService accountClientService
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def query = {
            account {
                if (params.accountName != null && params.accountName != '') {
                    like("accountName","%"+params.accountName?.trim()+"%")
                }
            }
            if (params.accountNo != null && params.accountNo != '') {
                //eq('accountNo', params.accountNo)
                like("accountNo","%"+params.accountNo?.trim()+"%")
            }
            validDated(params)
            if (params.startTime) {
                ge('dateCreated', Date.parse("yyyy-MM-dd", params.startTime))
            }else{
                if(params.downloadflag=='1' && (params.accountNo == null || params.accountNo == '') && (params.transferType == null || params.transferType == '') && (params.tradeNo == null || params.tradeNo == '') && (params.outTradeNo == null || params.outTradeNo == '')){
                    def day= (new Date()-3)
                    ge('dateCreated', Date.parse("yyyy-MM-dd", day.format("yyyy-MM-dd")) + 1)
                }
            }
            if (params.endTime) {
                lt('dateCreated', Date.parse("yyyy-MM-dd", params.endTime) + 1)
            }else{
                if(params.downloadflag=='1' && (params.accountNo == null || params.accountNo == '') && (params.transferType == null || params.transferType == '') && (params.tradeNo == null || params.tradeNo == '') && (params.outTradeNo == null || params.outTradeNo == '')){
                    lt('dateCreated', Date.parse("yyyy-MM-dd", new Date().format("yyyy-MM-dd")) + 1)
                }
            }
            transaction {
                eq('resultCode', '00')
                if (params.transferType != null && params.transferType != '') {
                    eq('transferType', params.transferType)
                }
                if (params.tradeNo != null && params.tradeNo != '') {
                    //eq('tradeNo', params.tradeNo)
                    like("tradeNo","%"+params.tradeNo?.trim()+"%")
                }
                if (params.outTradeNo != null && params.outTradeNo != '') {
                    like('outTradeNo', "%"+params.outTradeNo+"%")
                }
                if (params.srvType != null && params.srvType != '') {
                    eq('srvType', params.srvType)
                }
            }
        }
        if (params.downloadflag=='1'){
            params.max = 50000
            params.offset = 0
            def result = AcSequential.createCriteria().list(params, query)

            def summary = [debit:0,credit:0,balance:0,preBalance:0,dnum:0,cnum:0]
            for(AcSequential acs : result){
                summary.put('debit',acs.debitAmount + summary.get('debit'))
                summary.put('credit',acs.creditAmount + summary.get('credit'))
                summary.put('balance',acs.balance + summary.get('balance'))
                summary.put('preBalance',acs.preBalance + summary.get('preBalance'))
                if(acs.debitAmount && acs.debitAmount > 0){
                    summary.put('dnum',summary.get('dnum') + 1)
                }
                if(acs.creditAmount && acs.creditAmount > 0){
                    summary.put('cnum',summary.get('cnum') + 1)
                }
            }

            /* def list = AcSequential.createCriteria().get {
                projections {
                    sum('debitAmount')
                    sum('creditAmount')
                }
                account {
                    if (params.accountName != null && params.accountName != '') {
                        like("accountName","%"+params.accountName+"%")
                    }
                }
                if (params.accountNo != null && params.accountNo != '') {
                    eq('accountNo', params.accountNo)
                }
                if (params.startTime) {
                    gt('dateCreated', Date.parse("yyyy-MM-dd", params.startTime))
                } else {
                    if (params.downloadflag == '1' && (params.accountNo == null || params.accountNo == '') && (params.transferType == null || params.transferType == '') && (params.tradeNo == null || params.tradeNo == '') && (params.outTradeNo == null || params.outTradeNo == '')) {
                        def day = (new Date() - 3)
                        gt('dateCreated', Date.parse("yyyy-MM-dd", day.format("yyyy-MM-dd")) + 1)
                    }
                }
                if (params.endTime) {
                    lt('dateCreated', Date.parse("yyyy-MM-dd", params.endTime) + 1)
                } else {
                    if (params.downloadflag == '1' && (params.accountNo == null || params.accountNo == '') && (params.transferType == null || params.transferType == '') && (params.tradeNo == null || params.tradeNo == '') && (params.outTradeNo == null || params.outTradeNo == '')) {
                        lt('dateCreated', Date.parse("yyyy-MM-dd", new Date().format("yyyy-MM-dd")) + 1)
                    }
                }
                transaction {
                    eq('resultCode', '00')
                    if (params.transferType != null && params.transferType != '') {
                        eq('transferType', params.transferType)
                    }
                    if (params.tradeNo != null && params.tradeNo != '') {
                        eq('tradeNo', params.tradeNo)
                    }
                    if (params.outTradeNo != null && params.outTradeNo != '') {
                        eq('outTradeNo', params.outTradeNo)
                    }
                    if (params.srvType != null && params.srvType != '') {
                        eq('srvType', params.srvType)
                    }
                }
            }

            def debitTotal = list[0]
            def creditTotal = list[1]*/
            def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.contentType = "application/x-rarx-rar-compressed"
            response.setCharacterEncoding("UTF-8")
            render(template: "acSequentialInfolist", model: [acSequentialInstanceList: result,summary:summary])//,debitTotal: debitTotal,creditTotal: creditTotal
        }else{
            def total = AcSequential.createCriteria().count(query)
            def results = AcSequential.createCriteria().list(params, query)

             def debitList = AcSequential.createCriteria().get {
                projections {
                    sum('debitAmount')
                    count('debitAmount')
                }
                gt('debitAmount', Long.parseLong('0'))
                account {
                    if (params.accountName != null && params.accountName != '') {
                        like("accountName","%"+params.accountName+"%")
                    }
                }
                if (params.accountNo != null && params.accountNo != '') {
                    like('accountNo', "%"+params.accountNo+"%")
                }
                if (params.startTime) {
                    gt('dateCreated', Date.parse("yyyy-MM-dd", params.startTime))
                } else {
                    if (params.downloadflag == '1' && (params.accountNo == null || params.accountNo == '') && (params.transferType == null || params.transferType == '') && (params.tradeNo == null || params.tradeNo == '') && (params.outTradeNo == null || params.outTradeNo == '')) {
                        def day = (new Date() - 3)
                        gt('dateCreated', Date.parse("yyyy-MM-dd", day.format("yyyy-MM-dd")) + 1)
                    }
                }
                if (params.endTime) {
                    lt('dateCreated', Date.parse("yyyy-MM-dd", params.endTime) + 1)
                } else {
                    if (params.downloadflag == '1' && (params.accountNo == null || params.accountNo == '') && (params.transferType == null || params.transferType == '') && (params.tradeNo == null || params.tradeNo == '') && (params.outTradeNo == null || params.outTradeNo == '')) {
                        lt('dateCreated', Date.parse("yyyy-MM-dd", new Date().format("yyyy-MM-dd")) + 1)
                    }
                }
                transaction {
                    eq('resultCode', '00')
                    if (params.transferType != null && params.transferType != '') {
                        eq('transferType', params.transferType)
                    }
                    if (params.tradeNo != null && params.tradeNo != '') {
                        like('tradeNo', "%"+params.tradeNo+"%")
                    }
                    if (params.outTradeNo != null && params.outTradeNo != '') {
                        like('outTradeNo', "%"+params.outTradeNo+"%")
                    }
                    if (params.srvType != null && params.srvType != '') {
                        eq('srvType', params.srvType)
                    }
                }
            }
            def creditList = AcSequential.createCriteria().get {
                projections {
                    sum('creditAmount')
                    count('creditAmount')
                }
                gt('creditAmount', Long.parseLong('0'))
                account {
                    if (params.accountName != null && params.accountName != '') {
                        like("accountName","%"+params.accountName+"%")
                    }
                }
                if (params.accountNo != null && params.accountNo != '') {
                    like('accountNo', "%"+params.accountNo+"%")
                }
                if (params.startTime) {

                    gt('dateCreated', Date.parse("yyyy-MM-dd", params.startTime))
                } else {
                    if (params.downloadflag == '1' && (params.accountNo == null || params.accountNo == '') && (params.transferType == null || params.transferType == '') && (params.tradeNo == null || params.tradeNo == '') && (params.outTradeNo == null || params.outTradeNo == '')) {
                        def day = (new Date() - 3)
                        gt('dateCreated', Date.parse("yyyy-MM-dd", day.format("yyyy-MM-dd")) + 1)
                    }
                }
                if (params.endTime) {
                    lt('dateCreated', Date.parse("yyyy-MM-dd", params.endTime) + 1)
                } else {
                    if (params.downloadflag == '1' && (params.accountNo == null || params.accountNo == '') && (params.transferType == null || params.transferType == '') && (params.tradeNo == null || params.tradeNo == '') && (params.outTradeNo == null || params.outTradeNo == '')) {
                        lt('dateCreated', Date.parse("yyyy-MM-dd", new Date().format("yyyy-MM-dd")) + 1)
                    }
                }
                transaction {
                    eq('resultCode', '00')
                    if (params.transferType != null && params.transferType != '') {
                        eq('transferType', params.transferType)
                    }
                    if (params.tradeNo != null && params.tradeNo != '') {
                        like('tradeNo', "%"+params.tradeNo+"%")
                    }
                    if (params.outTradeNo != null && params.outTradeNo != '') {
                        like('outTradeNo', "%"+params.outTradeNo+"%")
                    }
                    if (params.srvType != null && params.srvType != '') {
                        eq('srvType', params.srvType)
                    }
                }
            }
            def balance = AcSequential.createCriteria().get {
                projections {
                    sum('balance')
                }
                //gt('balance', Long.parseLong('0'))
                account {
                    if (params.accountName != null && params.accountName != '') {
                        like("accountName","%"+params.accountName+"%")
                    }
                }
                if (params.accountNo != null && params.accountNo != '') {
                    eq('accountNo', params.accountNo)
                }
                if (params.startTime) {

                    gt('dateCreated', Date.parse("yyyy-MM-dd", params.startTime))
                } else {
                    if (params.downloadflag == '1' && (params.accountNo == null || params.accountNo == '') && (params.transferType == null || params.transferType == '') && (params.tradeNo == null || params.tradeNo == '') && (params.outTradeNo == null || params.outTradeNo == '')) {
                        def day = (new Date() - 3)
                        gt('dateCreated', Date.parse("yyyy-MM-dd", day.format("yyyy-MM-dd")) + 1)
                    }
                }
                if (params.endTime) {
                    lt('dateCreated', Date.parse("yyyy-MM-dd", params.endTime) + 1)
                } else {
                    if (params.downloadflag == '1' && (params.accountNo == null || params.accountNo == '') && (params.transferType == null || params.transferType == '') && (params.tradeNo == null || params.tradeNo == '') && (params.outTradeNo == null || params.outTradeNo == '')) {
                        lt('dateCreated', Date.parse("yyyy-MM-dd", new Date().format("yyyy-MM-dd")) + 1)
                    }
                }
                transaction {
                    eq('resultCode', '00')
                    if (params.transferType != null && params.transferType != '') {
                        eq('transferType', params.transferType)
                    }
                    if (params.tradeNo != null && params.tradeNo != '') {
                        like('tradeNo', "%"+params.tradeNo+"%")
                    }
                    if (params.outTradeNo != null && params.outTradeNo != '') {
                        like('outTradeNo', "%"+params.outTradeNo+"%")
                    }
                    if (params.srvType != null && params.srvType != '') {
                        eq('srvType', params.srvType)
                    }
                }
            }
            def debitAmount = debitList[0]      //借记总金额
            def debitTotal = debitList[1]       //借记总笔数
            def creditAmount = creditList[0]     //贷记总金额
            def creditTotal = creditList[1]      //贷记总笔数
            def balanceAmount = balance
            [acSequentialInstanceList: results, acSequentialInstanceTotal: total, params: params,debitTotal: debitTotal,debitAmount: debitAmount,creditTotal: creditTotal,creditAmount: creditAmount,balanceAmount:balanceAmount]
        }
    }


    def upLoad = {
        // 银行名称
        def bankName = params.bankName
//        java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyyMMdd")
//        def upDate = format.format(new Date());
//        println id
//        if(id!=null){
//           def boBankDic= BoBankDic.get(Long.parseLong(id))
//            println boBankDic.code
//        }

        if (request instanceof MultipartHttpServletRequest) {
            InputStream is = null
            def resultmsg
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request
            CommonsMultipartFile orginalFile = (CommonsMultipartFile) multiRequest.getFile("myFile")
            List list = new ArrayList();
            // 判断是否上传文件
            if (orginalFile != null && !orginalFile.isEmpty()) {
                is = orginalFile.getInputStream()
                //判断当前文件的版本xls,xlxs
                String originalFilename = orginalFile.getOriginalFilename()
                //上传文件
                def extension = originalFilename.substring(originalFilename.indexOf(".") + 1)
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMddHHmmssssss")
                String name = bankName+"-"+sdf.format(new Date()) + "." + extension
                def filepath = request.getRealPath("/") + "/Uploadfile/"
                def filename = filepath + name
                // 获取上传文件扩展名
                //处理excel为xls版本的数据
                if (extension.equals("xls")) {
                    list = this.getXls(is)
                } else if (extension.equals("xlxs")) {
                    list = this.getXlxs(is)
                }
                orginalFile.transferTo(new File(filename))

                flash.message = "上传操作成功！"
                redirect(action: "upLoad")
            } else {
                redirect(action: "upLoad")
                flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相因数据！"
            }
        }
    }

    def show = {
        def acSequentialInstance = AcSequential.get(params.id)
        if (!acSequentialInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acSequential.label', default: 'AcSequential'), params.id])}"
            redirect(action: "list")
        }
        else {
            [acSequentialInstance: acSequentialInstance]
        }
    }

    /**
     * 账务查询列表
     */
    def accountTreatmentList = {

        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def query = {
            if (params.accountNo != null && params.accountNo != '') {
                eq('accountNo', params.accountNo)
            }
             //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
            ge('dateCreated', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
            lt('dateCreated', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }
            transaction {
                eq('resultCode', '00')
                //'in'("transferType",['agentpay','agentcoll','fee'])
                if (params.tradeNo != null && params.tradeNo != '') {
                    eq('tradeNo', params.tradeNo)
                }
                if (params.outTradeNo != null && params.outTradeNo != '') {
                    eq('outTradeNo', params.outTradeNo)
                }
            }
        }
        def total = AcSequential.createCriteria().count(query)
        def results = AcSequential.createCriteria().list(params, query)
        [acSequentialInstanceList: results, acSequentialInstanceTotal: total, params: params]
    }

    private List<List<CmCustomer>> splitList(List<CmCustomer> cmList){
        int total = cmList.size()
        int len = 300
        int s   =  total/len
        int mode = total%len
        int size = s + (mode==0?0:1)
        int fInx = 0
        int tInx = 0
        List<List<CmCustomer>> result = new ArrayList<List<CmCustomer>>()
        for(int i = 0; i<=size; i++){
            fInx = i * len
            tInx = (i + 1) * len >= total ? total : (i + 1) * len
            result.add(cmList.subList(fInx, tInx))
            if(tInx >= total){
                break
            }
        }
        return result
    }

    /**
        * 验证日期间隔有效性
        *
        * @param params 表单参数
        * @return
        * @author guonan  2011-12-29
        *
        */
       def validDated(params) {
           //如果起始日期和截止日期均为空 默认为查询当天到前一周
           if (params.startTime==null && params.endTime==null ){
               def gCalendar= new GregorianCalendar()
               params.endTime=gCalendar.time.format('yyyy-MM-dd')
               gCalendar.add(GregorianCalendar.DAY_OF_WEEK_IN_MONTH,-1)
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

    /**
     * 商户手续费结算列表
     */
    def feeSettList = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def chkCmCustomer = CmCustomer.executeQuery("select distinct t.id as id from CmCustomer as t where t.status='normal'")
        def cmCustomer = null
        if(params.merchantNo && !params.merchantName){
//            cmCustomer = CmCustomer.find("from CmCustomer as t where t.status='normal' and t.customerNo like :customerNo",[customerNo:'%'+params.merchantNo+'%'])
            cmCustomer = CmCustomer.executeQuery("select distinct t.id as id from CmCustomer as t where t.status='normal' and t.customerNo like :customerNo",[customerNo:'%'+params.merchantNo+'%'])
        }else if(params.merchantName && !params.merchantNo){
//            cmCustomer = CmCustomer.find("from CmCustomer as t where t.status='normal' and t.name like :name",[name:'%'+params.merchantName+'%'])
            cmCustomer = CmCustomer.executeQuery("select distinct t.id as id from CmCustomer as t where t.status='normal' and t.name like :name",[name:'%'+params.merchantName+'%'])
        }else if(params.merchantNo && params.merchantName){
//            cmCustomer = CmCustomer.find("from CmCustomer as t where t.status='normal' and t.customerNo like :customerNo and t.name like :name",[customerNo:'%'+params.merchantNo+'%',name:'%'+params.merchantName+'%'])
             cmCustomer = CmCustomer.executeQuery("select distinct t.id as id from CmCustomer as t where t.status='normal' and t.customerNo like :customerNo and t.name like :name",[customerNo:'%'+params.merchantNo+'%',name:'%'+params.merchantName+'%'])
        }


        def query = {
            if(params.serviceCode!="" && params.serviceCode!=null){
                eq('serviceCode',params.serviceCode)
            }else{
                eq('serviceCode','agentpay')
            }
            eq('enable',true)
            eq('isCurrent',true)
            'in'('feeAccNo',AcAccount.executeQuery("select accountNo from AcAccount  where balance>0"))
            if(!params.merchantNo && !params.merchantName)
            {
                if(chkCmCustomer!=null){
                   // 'in'("customerId",chkCmCustomer)
                     List<List<CmCustomer>> subList =  splitList(chkCmCustomer)
                    or{
                        for(List<CmCustomer> sub : subList){
                           'in'("customerId",sub)
                        }
                    }
                }
            }
            else if(params.merchantNo || params.merchantName)
            {
                if(cmCustomer!=null){
                    List<List<CmCustomer>> subList2 =  splitList(cmCustomer)
//                   'in'("customerId",[cmCustomer.id])
                    or{
                       for(List<CmCustomer> sub : subList2){
                           'in'("customerId",sub)
                        }
                    }
                }else{
                    'in'("customerId",[12134567897])
                }
            }
            order("customerId","desc")
            groupProperty("customerId")
        }
        def total = BoCustomerService.createCriteria().count(query)
        def results = BoCustomerService.createCriteria().list(params, query)

        def totalAmount = 0
        def results2 =BoCustomerService.createCriteria().list{
           and query
        }
        for(def x in results2){
            def ptr = AcAccount.findByAccountNo(x.feeAccNo)
            if(ptr!=null){
                if(ptr.balance!= null){
                    totalAmount = totalAmount + ptr.balance
                }

            }
        }
        [boCustomerServiceInstanceList: results, boCustomerServiceInstanceTotal: total, params: params,totalAmount:totalAmount]
    }

    def listDownload = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = 1000000
        params.offset = 0

        def chkCmCustomer = CmCustomer.executeQuery("select t.id as id from CmCustomer as t where t.status='normal'")
        def cmCustomer = null
        if(params.merchantNo){
//            cmCustomer = CmCustomer.findAll("from CmCustomer as t where t.status='normal' and t.customerNo like :customerNo",[customerNo:'%'+params.merchantNo+'%'])
            cmCustomer = CmCustomer.executeQuery("select distinct t.id as id from CmCustomer as t where t.status='normal' and t.customerNo like :customerNo",[customerNo:'%'+params.merchantNo+'%'])

        }else if(params.merchantName){
//            cmCustomer = CmCustomer.findAll("from CmCustomer as t where t.status='normal' and t.name like :name",[name:'%'+params.merchantName+'%'])
            cmCustomer = CmCustomer.executeQuery("select distinct t.id as id from CmCustomer as t where t.status='normal' and t.name like :name",[name:'%'+params.merchantName+'%'])

        }else if(params.merchantNo && params.merchantName){
//            cmCustomer = CmCustomer.findAll("from CmCustomer as t where t.status='normal' and t.customerNo like :customerNo and t.name like :name",[customerNo:'%'+params.merchantNo+'%',name:'%'+params.merchantName+'%'])
            cmCustomer = CmCustomer.executeQuery("select distinct t.id as id from CmCustomer as t where t.status='normal' and t.customerNo like :customerNo and t.name like :name",[customerNo:'%'+params.merchantNo+'%',name:'%'+params.merchantName+'%'])

        }


        def query = {
            if(params.serviceCode!="" && params.serviceCode!=null){
                eq('serviceCode',params.serviceCode)
            }else{
                or{
                    eq('serviceCode','agentpay')
                }
            }
            eq('enable',true)
            eq('isCurrent',true)
            'in'('feeAccNo',AcAccount.executeQuery("select accountNo from AcAccount  where balance>0"))
            if(!params.merchantNo && !params.merchantName)
            {
                if(chkCmCustomer!=null){
                    // 'in'("customerId",chkCmCustomer)
                     List<List<CmCustomer>> subList =  splitList(chkCmCustomer)
                    or{
                        for(List<CmCustomer> sub : subList){
                           'in'("customerId",sub)
                        }
                    }
                }
            }
            else if(params.merchantNo || params.merchantName)
            {
                if(cmCustomer!=null){
//                   'in'("customerId",[cmCustomer.id])
                   List<List<CmCustomer>> subList2 =  splitList(cmCustomer)
                    or{
                       for(List<CmCustomer> sub : subList2){
                           'in'("customerId",sub)
                        }
                    }
                }else{
                    'in'("customerId",[12134567897])
                }
            }
            order("customerId","desc")
            groupProperty("customerId")
        }
        def total = BoCustomerService.createCriteria().count(query)
        def results = BoCustomerService.createCriteria().list(params, query)
        def totalAmount = 0;
        for(def x in results){
            def ptr = AcAccount.findByAccountNo(x.feeAccNo)
            if(ptr!=null){
                if(ptr.balance!= null){
                    totalAmount = totalAmount + ptr.balance
                }
            }
//             + ?.balance==null?0:AcAccount.findByAccountNo(x.feeAccNo)?.balance
        }

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "feeSettList", model: [boCustomerServiceInstanceList: results,total:total,totalAmount:totalAmount])
    }

    def popSett = {
        //商户代收代付服务id
        def id = params.id
        //商户id
        def customerId = params.customerId
        //商户结算手续费的总额
        def settMoney = params.float("settMoney")
        CmCustomer cmCustomer=null
        //商户现金账户
        AcAccount acAccount=null
        //商户手续费账户
        AcAccount merFeeAccount=null
        BoCustomerService boCustomerService=null

        if(customerId!=null && customerId!=''){
            cmCustomer = CmCustomer.find("from CmCustomer t where t.id="+customerId+"")
            if(cmCustomer!=null)
                acAccount = AcAccount.find("from AcAccount t where t.accountNo='"+cmCustomer.accountNo+"'")
        }
        if(id!=null && id!=''){
            boCustomerService = BoCustomerService.find("from BoCustomerService t where t.id="+id+"")
            if(boCustomerService!=null)
                merFeeAccount = AcAccount.find("from AcAccount t where t.accountNo='"+boCustomerService.feeAccNo+"'")
        }
        //应收手续费账户 、平台收费账户 、收单银行列表
        BoInnerAccount feeAccount = BoInnerAccount.find("from BoInnerAccount t where t.key='feeInAdvance'")
        BoInnerAccount platAccount = BoInnerAccount.find("from BoInnerAccount t where t.key='feeAcc'")
        def boAcquirerAccount = BoAcquirerAccount.executeQuery("select t.innerAcountNo as innerAcountNo from BoAcquirerAccount t where t.status='normal'")
        List bankList = new ArrayList()
        bankList = AcAccount.createCriteria().list{
            eq('status','norm')
            'in'("accountNo",boAcquirerAccount)
        }

        if(acAccount!=null && feeAccount!=null && platAccount!=null){
            //商户现金账户余额、商户要结算的手续费、商户现金账户、应收手续费账户 、平台收费账户 、收单银行列表 、商户手续费账户
            [balance:acAccount.balance/100,settMoney:settMoney,baAccount:acAccount.accountNo,feeAccount:feeAccount.accountNo,platAccount:platAccount.accountNo,bankList:bankList,merFeeAccount:merFeeAccount.accountNo]
        }
    }

    /**
     * 商户手续费结算
     */
    def settFee = {
        //商户要结算的手续费总额、商户现金账户、应收手续费账户 、平台收费账户、商户手续费账户

        def msg = ""
        def resultMsg = ""
        def errorCode = ""
        def errorMsg = ""
        def settMoney = params.float("settMoney")
        def baAccount = params.baAccount
        def feeAccount = params.feeAccount
        def platAccount = params.platAccount
        def merFeeAccount = params.merFeeAccount
        //收单银行账户
        def collAccount = params.collAccount

        //单位:分
        java.math.BigDecimal settFund = new java.math.BigDecimal(params.settFund)*100

        /*AcAccount balanceAccount = AcAccount.find("from AcAccount t where t.accountNo='"+baAccount+"'")
        AcAccount sysFeeAccount = AcAccount.find("from AcAccount t where t.accountNo='"+feeAccount+"'")
        AcAccount sysPlatAccount = AcAccount.find("from AcAccount t where t.accountNo='"+platAccount+"'")
        AcAccount merchantFeeAccount = AcAccount.find("from AcAccount t where t.accountNo='"+merFeeAccount+"'")

        AcAccount sysCollAccount = AcAccount.find("from AcAccount t where t.accountNo='"+collAccount+"'")*/

        def cmdList = []
        def commandNo = UUID.randomUUID().toString().replaceAll('-', '')

        //商户现金账户结算
        if(params.merchantAcc=="0")
        {
            cmdList = accountClientService.buildTransfer(null, baAccount, merFeeAccount, settFund, 'fee', '0', '0', "手续费结算，"+params.remark)
        }
        //收单银行结算
        else if(params.merchantAcc=="1")
        {
            cmdList = accountClientService.buildTransfer(null, collAccount, merFeeAccount, settFund, 'fee', '0', '0', "手续费结算，"+params.remark)
        }
        cmdList = accountClientService.buildTransfer(cmdList, feeAccount, platAccount, settFund, 'fee', '0', '0', "手续费结算，"+params.remark)
        def transResult = accountClientService.batchCommand(commandNo, cmdList)
        if (transResult.result == 'true') {
            msg = "ok"
            resultMsg = "手续费结算成功"
            render '{msg:"'+msg+'",data:{"resultMsg":"'+resultMsg+'"}}'
        } else {
            msg = "bad"
            resultMsg = "手续费结算失败，错误码："+transResult.errorCode+",错误信息："+transResult.errorMsg.toString().replaceAll("\"","")+""
            render '{msg:"'+msg+'",data:{"resultMsg":"'+resultMsg+'"}}'
        }
    }

    //增加查看 as sunweiguo 2012-08-10
    def view = {
        def acSeq = AcSequential.get(params.id)

         if (!acSeq) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'AcSequential.label', default: 'AcSequential.label'), params.id])}"
            redirect(action: "view")
        } else {
            [acSeq: acSeq]
        }
    }

    //增加回单擦看 as sunweiguo 2012-08-13
    def receipt = {
         if (!params.id) {
            flash.message= "没找到该交易"
            return
        }
        def acSeq = AcSequential.get(params.id);
        if (!acSeq) {
            flash.message = "没找到该交易"
            return
        }
        def tBase = TradeBase.findWhere(tradeNo: acSeq.transaction.tradeNo)
        //处理交易时间
        String strdate = "";
        if (tBase != null && tBase.lastUpdated != null) {
            SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd")
            strdate = formatter2.format(tBase.lastUpdated);
        }
        //处理手续费
        def ftTrade = FtTrade.findWhere(seqNo: acSeq.transaction.tradeNo)
        Long fee = 0;
        if (ftTrade != null && ftTrade.postFee != null && Math.abs(ftTrade.postFee) != 0) {
            fee = Math.abs(ftTrade.postFee);
        } else if (ftTrade != null && ftTrade.preFee != null && Math.abs(ftTrade.preFee) != 0) {
            fee = Math.abs(ftTrade.preFee);
        }
        [tBase: tBase, strdate: strdate, ftTrade: ftTrade, acSeq: acSeq, fee: fee]
    }

/**
     * 回单下载 as sunweiguo 2012-08-13
     */
    def downReceipt = {
        if (!params.id) {
            writeInfoPage "没找到该交易"
            return
        }
        def acSeq = AcSequential.get(params.id)
        if (!acSeq) {
            writeInfoPage "没找到该交易"
            return
        }
        def tBase = TradeBase.findWhere(tradeNo: acSeq.transaction.tradeNo)
        //处理交易时间
        String strdate = "";
        if (tBase != null && tBase.lastUpdated != null) {
            SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd");
            strdate = formatter2.format(tBase.lastUpdated);
        }
        //处理手续费
        def ftTrade = FtTrade.findWhere(seqNo: acSeq.transaction.tradeNo)
        Long fee = 0;
        if (ftTrade != null && ftTrade.postFee != null && Math.abs(ftTrade.postFee) != 0) {
            fee = Math.abs(ftTrade.postFee);
        } else if (ftTrade != null && ftTrade.preFee != null && Math.abs(ftTrade.preFee) != 0) {
            fee = Math.abs(ftTrade.preFee);
        }
        //模板下载模板
        response.contentType = "application/x-rarx-rar-compressed"
        def filename = acSeq.transaction.tradeNo + '_' + new Date().format('yyyyMMdd') + '.xls'
        response.setCharacterEncoding("utf-8")
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        render(template: "receiptdetailExcel", model: [tBase: tBase, strdate: strdate, ftTrade: ftTrade, acSeq: acSeq, fee: fee])
    }

}
