package ismp

import boss.BoBankDic
import grails.converters.JSON
import boss.BoAcquirerAccount
import boss.BoMerchant
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.multipart.commons.CommonsMultipartFile
import groovyx.net.http.ContentType
import groovyx.net.http.HTTPBuilder
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import groovyx.net.http.Method
import org.springframework.orm.hibernate3.HibernateTemplate
import org.hibernate.Session
import org.springframework.orm.hibernate3.HibernateCallback
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.transform.AliasToEntityMapResultTransformer
import groovy.sql.Sql

class AcquireAccountTradeController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') :params.fmax? params.int('fmax'): 10, 100)
        params.offset = params.offset ? params.int('offset') : params.foffset? params.int('foffset'):0
        params.bankCode = params.fbankCode? params.fbankCode:params.bankCode
        params.beginTime = params.fbeginTime? params.fbeginTime:params.beginTime
        params.endTime = params.fendTime? params.fendTime:params.endTime

        println "max---${params.max}---"
        println "offset---${params.offset}---"
        println "bankCode---${params.bankCode}---"
        println "beginTime---${params.beginTime}---"
        println "endTime---${params.endTime}---"
        validDated(params)
        def query = {
            if (params.bankCode) {
                eq('bankCode', params.bankCode)
            }
            if (params.beginTime) {
                ge('synDateFrom', Date.parse('yyyy-MM-dd HH:mm:ss', params.beginTime))
            }
            if (params.endTime) {
                le('synDateTo', Date.parse('yyyy-MM-dd HH:mm:ss', params.endTime))
            }
        }
        def total = 0
        def results =null
        total = AcquireSynResult.createCriteria().count(query)
        results = AcquireSynResult.createCriteria().list(params, query)
        def allBanks = BoBankDic.list()
        [acquireSynResultList: results, acquireSynResultInstanceTotal:total,banks:allBanks]
    }

    def download = {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max = 100000
        params.offset = 0
        validDated(params)
        def query = {
            if (params.bankCode) {
                eq('bankCode', params.bankCode)
            }
            if (params.beginTime) {
                ge('synDateFrom', Date.parse('yyyy-MM-dd HH:mm:ss', params.beginTime))
            }
            if (params.endTime) {
                le('synDateTo', Date.parse('yyyy-MM-dd HH:mm:ss', params.endTime))
            }
        }
        def total = AcquireSynResult.createCriteria().count(query)
        def results = AcquireSynResult.createCriteria().list(params, query)
        def allBanks = BoBankDic.list()
        def filename = 'Excel-AcquireSynResult-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "list", model: [acquireSynResultList: results,banks:allBanks])
    }

    def detailList = {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.synSts) {
               eq('synSts', params.synSts as int)
            }
            if (params.batchnum) {
               eq('batchnum', params.batchnum)
            }
        }
        def total = AcquireSynTrx.createCriteria().count(query)
        def results = AcquireSynTrx.createCriteria().list(params, query)
        [acquireSynTrxList: results, acquireSynTrxInstanceTotal:total]
    }

    def detailDownload = {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max = 100000
        params.offset = 0
        def query = {
            if (params.synSts) {
               eq('synSts', params.synSts as int)
            }
            if (params.batchnum) {
               eq('batchnum', params.batchnum)
            }
        }
        def total = AcquireSynTrx.createCriteria().count(query)
        def results = AcquireSynTrx.createCriteria().list(params, query)
        def filename = 'Excel-AcquireSynTrx-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "detailList", model: [acquireSynTrxList: results])
    }

    def upfile = {
        def allBanks = BoBankDic.list()
        def allBankAccounts = []
        if(params.bankCode){
          def bank=BoBankDic.findByCode(params.bankCode)
          allBankAccounts=BoAcquirerAccount.findAllByBank(bank)
        }
        validDated(params)
        [banks:allBanks,bankAccounts:allBankAccounts]
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
        //如果起始日期和截止日期均为空 默认为查询前一天
        if (params.beginTime==null && params.endTime==null){
            def gCalendar= new GregorianCalendar()
            params.endTime=gCalendar.time.format('yyyy-MM-dd 23:59:59')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.beginTime=gCalendar.time.format('yyyy-MM-dd 00:00:00')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.beginTime && !params.endTime){
             params.endTime=params.beginTime
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.beginTime && params.endTime){
             params.beginTime=params.endTime
        }
        if (params.beginTime && params.endTime) {


        }
    }

    def getBanksJson = {
        def selectId = params.selectId
        def allBanks = BoBankDic.list()
        render allBanks as JSON
    }

    def getAcquireAccountsJson = {
        def bank,allAcquireAccounts,allMerchants
        bank=BoBankDic.findByCode(params.bankCode)
        allAcquireAccounts=BoAcquirerAccount.findAllByBank(bank)
        render allAcquireAccounts as JSON
    }

    def getMerchantsJson = {
        def acquireAccount,allMerchants
        def query="select distinct acquire_merchant from bo_merchant where acquirer_account_id='${params.acquirerAccountId}'"
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            return sqlQuery.list();
        } as HibernateCallback)
        render result as JSON
    }

    def getInterfacesJson2 = {
        def bankId = params.bankId
        def bank,allAcquireAccounts,allMerchants
        bank= BoBankDic.get(bankId)
        allAcquireAccounts=BoAcquirerAccount.findAllByBank(bank)
        allMerchants=BoMerchant.findAllByAcquirerAccountInList(allAcquireAccounts)
        render allMerchants as JSON
    }
    def getInterfacesJson = {
        def acquireMerchant = params.acquireMerchant
        def allMerchants=BoMerchant.findAllByAcquireMerchant(acquireMerchant)
        render allMerchants as JSON
    }

    def upLoad= {

        println "bankCode  is ${params.bankCode} "
        println "acquirerAccountId  is ${params.acquirerAccountId} "
        println "acquireMerchant  is ${params.acquireMerchant} "
        println "interfaceIds  is ${params.interfaceIds}  ${params.interfaceIds instanceof String[]}"
        println "beginTime  is ${params.beginTime} "
        println "endTime  is ${params.endTime} "
        println "oper  is ${session.op.account} "


        if (request instanceof MultipartHttpServletRequest) {
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request
            List<CommonsMultipartFile> orginalFiles = (List<CommonsMultipartFile>) multiRequest.getFiles("myFile")
            // 判断是否上传文件
            if (orginalFiles != null && !orginalFiles.isEmpty()) {
                //银行号必选
                def bankCode =  params.bankCode
                //银行账号
                def bankAccountNo=[]
                //如果页面选择了银行账号
                if(params.acquirerAccountId){
                    bankAccountNo<<BoAcquirerAccount.get(params.acquirerAccountId as Long).getBankAccountNo()
                }
                //如果页面选择了全部
                else{
                    def bank=BoBankDic.findByCode(bankCode)
                    def allAcquireAccounts=BoAcquirerAccount.findAllByBank(bank)
                    allAcquireAccounts?.each {
                       bankAccountNo<< it.bankAccountNo
                    }
                }
                if(bankAccountNo.isEmpty()){
                     showUpfile(params,"没有任何银行账户，请确认是否有数据！")
                     return
                }
                //收单商户号
                def acquireMerchant=[]
                 //如果页面选择了收单商户号
                if(params.acquireMerchant){
                    acquireMerchant<<params.acquireMerchant
                }
                //如果页面选择了全部
                else{
                    def query
                    //如果页面选择了银行账户，收单商户为全部
                    if(params.acquirerAccountId){
                        query="select distinct acquire_merchant from bo_merchant where acquirer_account_id in(${params.acquirerAccountId})"
                    }
                    //如果页面银行账户，收单商户均为全部
                    else{
                        def bank=BoBankDic.findByCode(bankCode)
                        def allAcquireAccounts=BoAcquirerAccount.findAllByBank(bank)
                        def acquirerAccountIds=[]
                        allAcquireAccounts?.each {
                           acquirerAccountIds<<it.id
                        }
                        if(!acquirerAccountIds.isEmpty()){
                          query="select distinct acquire_merchant from bo_merchant where acquirer_account_id in(${acquirerAccountIds.join(',')})"
                        }
                    }
                    if(query){
                        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
                        def result = ht.executeFind({ Session session ->
                            def sqlQuery = session.createSQLQuery(query.toString())
                            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                            return sqlQuery.list();
                        } as HibernateCallback)
                        result?.each {
                             acquireMerchant<<it.ACQUIRE_MERCHANT
                        }
                    }
                 }
                if(acquireMerchant.isEmpty()){
                     showUpfile(params,"没有任何收单商户号，请确认是否有数据！")
                     return
                }
                //通道服务码
                def interfaceIds =[]
                //如果页面选择了通道服务码
                if(params.interfaceIds){
                    if(params.interfaceIds instanceof String[]){
                        params.interfaceIds.each {
                            interfaceIds<<it.toString()
                        }
                    }else{
                       interfaceIds<<params.interfaceIds.toString()
                    }
                }
                //如果页面选择了全部
                else{
                    def allMerchants
                    //如果页面选择了银行账户，收单商户为全部
                    if(params.acquirerAccountId){
                        def acquireAccount = BoAcquirerAccount.get(params.acquirerAccountId as Long)
                        allMerchants=BoMerchant.findAllByAcquirerAccount(acquireAccount)

                    }
                    //如果页面银行账户，收单商户均为全部
                    else{
                        def bank=BoBankDic.findByCode(bankCode)
                        def allAcquireAccounts=BoAcquirerAccount.findAllByBank(bank)
                        allMerchants=BoMerchant.findAllByAcquirerAccountInList(allAcquireAccounts)
                    }
                    allMerchants.each {
                        interfaceIds<<it.serviceCode
                    }
                }
                if(interfaceIds.isEmpty()){
                     showUpfile(params,"没有任何通道服务，请确认是否有数据！")
                     return
                }
                // 获取系统默认文件路径分隔符
                def separator = System.getProperty("file.separator")
                println "file separator is ${separator} "
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMddHHmmssSSS")
                //获取上传文件夹的实际路径
                def filepath = request.getRealPath(separator) +"Uploadfile"+separator
                def fileNames =[]

                orginalFiles.each{ orginalFile->
                     // 获取原文件名称
                    def originalFilename = orginalFile.getOriginalFilename()
                    // 获取上传文件扩展名
                    def extension = originalFilename.substring(originalFilename.lastIndexOf(".") + 1)
                    println "extension is ${extension}"

                  if(['txt','xls','xlsx','csv','TXT','XLS','XLSX','CSV'].contains(extension)){

                    //以银行代码+当前时间戳重构文件名
                    def name = bankCode + "-" + sdf.format(new Date()) + "." + extension

                    def filename = filepath + name
                    //文件网络路径
                    def fileName = "/Uploadfile/" + name

                    println "file name is : ${filename}"
                    println "fileName  is : ${fileName}"

                     if(extension.equalsIgnoreCase("txt")||extension.equalsIgnoreCase("csv")){
                         transferFileCode(orginalFile,filename)
                     }else{
                         orginalFile.transferTo(new File(filename))
                     }
                     fileNames<< fileName
                    }
                }
                if(fileNames.size()>0){
                    println "uri  is ${fileNames} "
                    println "bankCode  is ${bankCode} "
                    println "bankAccountNo  is ${bankAccountNo} "
                    println "acquireMerchant  is ${acquireMerchant} "
                    println "serviceCodes  is ${interfaceIds} "

                    def args = ['uri': fileNames
                            ,'bankCode':bankCode
                            ,'bankAccountNo':bankAccountNo
                            ,'acquireMerchant':acquireMerchant
                            ,'serviceCodes':interfaceIds
                            ,'beginTime':params.beginTime
                            ,'endTime':params.endTime
                            ,'oper':session.op.account]


                    def result = invokeAcquireSynTrxApi('/procBatchTrx/parse', args)
                    if (result instanceof Map) {
                        if (result.response==0) {
                            showUpfile(params,"上传失败，请确认上传文件中格式跟模板一样，并且有数据！")
                        }else{
                            showList(params,result)
                        }
                    } else {
                        showList(params,result)
                    }
                }else{
                    showUpfile(params,"文件类型不正确，只能上传txt,xls,xlsx,csv类型文件")
                    return
                }

            } else {
                showUpfile(params,"上传失败，请确认上传文件中格式跟模板一样，并且有数据！")
                return
            }
        }
    }


    def showList(params,result) {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            eq('bankCode', params.bankCode)
            ge('synDateFrom', Date.parse('yyyy-MM-dd HH:mm:ss', params.beginTime))
            le('synDateTo', Date.parse('yyyy-MM-dd HH:mm:ss', params.endTime) )
        }
        def total = AcquireSynResult.createCriteria().count(query)
        def results = AcquireSynResult.createCriteria().list(params, query)
        def allBanks = BoBankDic.list()

        def msg=""
        def err=""
        if (result instanceof Map) {
            if (1==result.response) {
                msg= result.resmsg
            } else{
                err= result.resmsg
            }
        }else{
            err="文件处理应用连接错误"
        }
        render(view: "list", model: [acquireSynResultList: results, acquireSynResultInstanceTotal: total,banks:allBanks,msg:msg,err:err])
    }

    def showUpfile(params,result) {
        def allBanks = BoBankDic.list()
        def allBankAccounts = []
        if(params.bankCode){
          def bank=BoBankDic.findByCode(params.bankCode)
          allBankAccounts=BoAcquirerAccount.findAllByBank(bank)
        }
        render(view: "upfile", model:[banks:allBanks,bankAccounts:allBankAccounts,err:result])
    }

    //文件保存并转码
   def transferFileCode(orginalFile,filename){
        InputStreamReader reader = new InputStreamReader(orginalFile.getInputStream(), "GBK");
        def content= reader.text
       File j = new File(filename);
       Writer ow = new OutputStreamWriter(new FileOutputStream(j), "utf-8");
        ow.write(content.toString());
        ow.close();
    }

    private invokeAcquireSynTrxApi(String _uri, Map _args) {
        log.info "invoke Acquire Syn Trx api: $_uri \n args:$_args"
        def result = ''
        try {
            println  "9000000000000000000000000"+ ConfigurationHolder.config.gateway.inner.server +_uri
            def http = new HTTPBuilder(ConfigurationHolder.config.gateway.inner.server)
            http.request(Method.POST, ContentType.JSON) { req ->
                uri.path = "ISMSApp/"+_uri
                send ContentType.URLENC, _args
                response.success = { resp, json ->
                    log.debug "response status: ${resp.statusLine}"
                    result = json
                }
            }
        } catch (e) {
            log.error e, e
            result = e.getMessage()
        }
        log.info "resp: $result"
        result
    }


    def create = {
        def acquireAccountTradeInstance = new AcquireAccountTrade()
        acquireAccountTradeInstance.properties = params
        return [acquireAccountTradeInstance: acquireAccountTradeInstance]
    }

    def save = {
        def acquireAccountTradeInstance = new AcquireAccountTrade(params)
        if (acquireAccountTradeInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), acquireAccountTradeInstance.id])}"
            redirect(action: "list", id: acquireAccountTradeInstance.id)
        }
        else {
            render(view: "create", model: [acquireAccountTradeInstance: acquireAccountTradeInstance])
        }
    }

    def show = {
        def acquireAccountTradeInstance = AcquireAccountTrade.get(params.id)
        if (!acquireAccountTradeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), params.id])}"
            redirect(action: "list")
        }
        else {
            [acquireAccountTradeInstance: acquireAccountTradeInstance]
        }
    }

    def showRemarks = {
        def acquireSynTrx = AcquireSynTrx.get(params.id)
        if (!acquireSynTrx) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), params.id])}"
            redirect(action: "detailList",params:params)
        }
        else {
            [acquireSynTrxInstance: acquireSynTrx]
        }
    }

    def edit = {
        def acquireAccountTradeInstance = AcquireAccountTrade.get(params.id)
        if (!acquireAccountTradeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [acquireAccountTradeInstance: acquireAccountTradeInstance]
        }
    }

    def editRemarks = {
        def acquireSynTrx = AcquireSynTrx.get(params.id)
        if (!acquireSynTrx) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), params.id])}"
            redirect(action: "detailList",params:params)
        }
        else {
            return [acquireSynTrxInstance: acquireSynTrx]
        }
    }

    def update = {
        def acquireAccountTradeInstance = AcquireAccountTrade.get(params.id)
        if (acquireAccountTradeInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (acquireAccountTradeInstance.version > version) {

                    acquireAccountTradeInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade')] as Object[], "Another user has updated this AcquireAccountTrade while you were editing")
                    render(view: "edit", model: [acquireAccountTradeInstance: acquireAccountTradeInstance])
                    return
                }
            }
            acquireAccountTradeInstance.properties = params
            if (!acquireAccountTradeInstance.hasErrors() && acquireAccountTradeInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), acquireAccountTradeInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [acquireAccountTradeInstance: acquireAccountTradeInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), params.id])}"
            redirect(action: "list")
        }
    }

    def updateRemarks = {
        def acquireSynTrx = AcquireSynTrx.get(params.id)
        if (acquireSynTrx) {
            if (params.version) {
                def version = params.version.toLong()
                if (acquireSynTrx.version > version) {

                    acquireSynTrx.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade')] as Object[], "Another user has updated this AcquireAccountTrade while you were editing")
                    render(view: "editRemarks", model: [acquireSynTrxInstance: acquireSynTrx,params:params])
                    return
                }
            }
            acquireSynTrx.properties = params
            if (!acquireSynTrx.hasErrors() && acquireSynTrx.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), acquireSynTrx.batchnum])}"
                redirect(action: "detailList",params:params)
            }
            else {
                render(view: "editRemarks", model: [acquireSynTrxInstance: acquireSynTrx,params:params])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), params.id])}"
            redirect(action: "detailList",params:params)
        }
    }

    def delete = {
        def acquireAccountTradeInstance = AcquireAccountTrade.get(params.id)
        if (acquireAccountTradeInstance) {
            try {
                acquireAccountTradeInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), params.id])}"
            redirect(action: "list")
        }
    }

    def deleteRemarks = {
        def acquireSynTrx = AcquireSynTrx.get(params.id)
        if (acquireSynTrx) {
            try {
                acquireSynTrx.remarks=''
                acquireSynTrx.save(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), params.id])}"
                redirect(action: "detailList",params:params)
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), params.id])}"
                redirect(action: "showRemarks", id: params.id,params:params)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade'), params.id])}"
            redirect(action: "detailList",params:params)
        }
    }
}
