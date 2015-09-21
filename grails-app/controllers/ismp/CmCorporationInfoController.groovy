package ismp

import boss.KeyUtils
import account.AcAccount
import boss.BoCustomerService
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate
import settle.FtSrvFootSetting


class CmCorporationInfoController {

    def accountClientService
    def customerService
    def cmCorporationInfoService
    def f1Dir = "positive"
    def f2Dir = "opposite"
    def f3Dir = "business"
    def f4Dir = "registration"

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    private List<List<BoCustomerService>> splitList(List<BoCustomerService> cmList) {
        int total = cmList.size()
        int len = 300
        int s = total / len
        int mode = total % len
        int size = s + (mode == 0 ? 0 : 1)
        int fInx = 0
        int tInx = 0
        List<List<BoCustomerService>> result = new ArrayList<List<BoCustomerService>>()
        for (int i = 0; i <= size; i++) {
            fInx = i * len
            tInx = (i + 1) * len >= total ? total : (i + 1) * len
            result.add(cmList.subList(fInx, tInx))
            if (tInx >= total) {
                break
            }
        }
        return result
    }

    def list = {

        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        //Sure update 2012-03-06
        def customers = []

         if (params.adminEmail != null && params.adminEmail != '') {
                def operators = CmCustomerOperator.createCriteria().list {
                    eq('roleSet', '1');
                    eq('status', 'normal');
                    like('defaultEmail', '%' + params.adminEmail + '%')
                }
                for (def x in operators) {
                    customers.add(x.getCustomer().id)
                }
          }

         if(params.sort == 'adminEmail'){
                params.remove('sort')
         }


        def query = {

            if (params.customerNo != null && params.customerNo != '') {
                like('customerNo', '%' + params.customerNo.trim() + '%')
            }
            if (params.name != null && params.name != '') {
                like('name', '%' + params.name.trim() + '%')
            }
            if (params.registrationName != null && params.registrationName != '') {
                like('registrationName', '%' + params.registrationName.trim() + '%')
            }
            if (params.status != null && params.status != '') {
                eq('status', params.status)
            }
            //guonan update 2012-02-19
            if (params.branchCompany != null && params.branchCompany != '') {
                eq('branchCompany', params.branchCompany)
            }

            //guonan update 2012-02-19
            if (params.belongToSale != null && params.belongToSale != '') {
                like('belongToSale', '%' + params.belongToSale+ '%')
            }

            if (params.accountNo != null && params.accountNo != '') {
                like('accountNo', '%' + params.accountNo.trim() + '%')
            }
            if (params.registeredPlace != null && params.registeredPlace != '') {
                like('registeredPlace', '%' + params.registeredPlace.trim() + '%')
            }

            //sunweiguo update 2012-05-31
            /*
            if (params.belongToSale != null && params.belongToSale != '') {
                like('belongToSale', '%' + params.belongToSale.trim() + '%')
            }
             */
            //sunweiguo update 2012-06-12 增加业务类型查询条件

            if(params.serviceCode !=null && params.serviceCode !='') {
               // def serviceCode = BoCustomerService.findAllByServiceCode(params.serviceCode)
               def bocustomerService= BoCustomerService.findAllByServiceCode(params.serviceCode)

               if(bocustomerService.size()>0)
               {
                    List<List<BoCustomerService>> subList = splitList(bocustomerService)
                   or{
                       for(List<BoCustomerService>sub:subList){
                           'in'('id',sub.customerId)
                       }
                   }
               }else{
                   isNull('id')
               }

               // 'in'('id',bocustomerService.customerId)

            }

            //sunweiguo update 2012-06-14 增加结算周期查询条件
            if(params.footType !=null && params.footType !=''){
                def cycle= FtSrvFootSetting.findAllByFootType(params.footType)
                if(cycle){
                    List<List<FtSrvFootSetting>> subList = splitList(cycle)
                    or{
                         for(List<FtSrvFootSetting>sub:subList){
                                   'in'('customerNo',sub.customerNo)
                         }
                    }
                    //eq('customerNo',cycle.customerNo)
                }
            }
            def  boServices = []//合同号查询
            if(params.contractNo != null  && params.contractNo !=''){
                def services = BoCustomerService.createCriteria().list {
                   like('contractNo', '%' + params.contractNo + '%')
                }
                for (def x in services){
                    boServices.add(x.getCustomerId())
                }
            }
            if(params.expire != null && params.expire != ''){
                 def query = """select t1.id from cm_corporation_info t1,(select t2.id,floor(to_number((t2.license_expires+0) - sysdate))
                 as spanDays from cm_corporation_info t2) t3 where t1.id = t3.id and t3.spanDays <="""+params.expire+"""
                 and sysdate >= t1.registration_date+0 and sysdate <= t1.license_expires+0"""

                HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
                    def result = ht.executeFind({ Session session ->
                    def sqlQuery = session.createSQLQuery(query.toString())
                    sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                    return sqlQuery.list()
                } as HibernateCallback)

                if(result.size()){
                      result.each {
                          def id =  it.ID as String
                          'in'('id',Long.valueOf(id))
                      }
                }
            }


            // 商旅卡查询条件
            println "=======" + params.customerCategory
            if (params.customerCategory != null && params.customerCategory != '-1') {
                if (params.customerCategory == '')
                    isNull('customerCategory')
                else
                    eq('customerCategory', params.customerCategory)
            }

            //guonan update 2011-12-29
//            validDated(params)
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
            //Sure update 2012-03-06
            if (customers.size()>0){
                inList('id', customers.toArray())
            }

            if(boServices.size()>0){
                inList('id',boServices.toArray())
            }
        }

        def total = CmCorporationInfo.createCriteria().count(query)
        def results = CmCorporationInfo.createCriteria().list(params, query)
        [cmCorporationInfoInstanceList: results, cmCorporationInfoInstanceTotal: total]
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
        if (params.startDateCreated == null && params.endDateCreated == null) {
            def gCalendar = new GregorianCalendar()
            params.endDateCreated = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startDateCreated = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startDateCreated && !params.endDateCreated) {
            params.endDateCreated = params.startDateCreated
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startDateCreated && params.endDateCreated) {
            params.startDateCreated = params.endDateCreated
        }
        if (params.startDateCreated && params.endDateCreated) {


        }
    }

    def listDownload = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = 50000
        params.offset = 0
        def query = {

            if (params.customerNo != null && params.customerNo != '') {
                like('customerNo', '%' + params.customerNo.trim() + '%')
            }

            if (params.name != null && params.name != '') {
                like('name', '%' + params.name.trim() + '%')
            }
            if (params.registrationName != null && params.registrationName != '') {
                like('registrationName', '%' + params.registrationName.trim() + '%')
            }
            if (params.status != null && params.status != '') {
                eq('status', params.status)
            }
            if (params.accountNo != null && params.accountNo != '') {
                like('accountNo', '%' + params.accountNo.trim() + '%')
            }

            //guonan update 2012-02-19
            if (params.branchCompany != null && params.branchCompany != '') {
                eq('branchCompany', params.branchCompany)
            }

            //guonan update 2012-02-19
            if (params.belongToSale != null && params.belongToSale != '') {
                like('belongToSale', '%' + params.belongToSale+ '%')
            }

//            if (params.startDateCreated != null && params.startDateCreated != '') {
//                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
//            }
//            if (params.endDateCreated != null && params.endDateCreated != '') {
//                le('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated)+1)
//            }


            //sunweiguo update 2012-06-12 增加业务类型查询条件

            if(params.serviceCode !=null && params.serviceCode !='')
            {
                 if(params.serviceCode == '')
                 {
                       isNull('serviceCode')
                 }
                 else
                 {
                       def serviceCode = BoCustomerService.findAllByServiceCode(params.serviceCode)
                       //def bocustomerService= BoCustomerService.findAllByServiceCode(params.serviceCode)
                       if(serviceCode.size()>0)
                       {
                            List<List<BoCustomerService>> subList = splitList(serviceCode)
                           or{
                               for(List<BoCustomerService>sub:subList)
                               {
                                   'in'('id',sub.customerId)
                               }
                           }
                           // 'in'('id',serviceCode.customerId)
                       }
                 }
             }
            //guonan update 2011-12-29

            // 商旅卡查询条件
            println "=======" + params.customerCategory
            if (params.customerCategory != null && params.customerCategory != '-1') {
                if (params.customerCategory == '')
                    isNull('customerCategory')
                else
                    eq('customerCategory', params.customerCategory)
            }

            validDated(params)
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
        }
        def total = CmCorporationInfo.createCriteria().count(query)
        def results = CmCorporationInfo.createCriteria().list(params, query)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "list", model: [cmCorporationInfoInstanceList: results])
    }

    def create = {
        def cmCorporationInfoInstance = new CmCorporationInfo()
        cmCorporationInfoInstance.properties = params
        return [cmCorporationInfoInstance: cmCorporationInfoInstance]
    }

    def save = {
        def cmCorporationInfoInstance = new CmCorporationInfo(params)
        println KeyUtils.getRandKey(64)
        cmCorporationInfoInstance.apiKey = KeyUtils.getRandKey(64)
        cmCorporationInfoInstance.checkStatus = 'successed'
        cmCorporationInfoInstance.accessMode = 'protocol'
        if (!params.defaultEmail) {
            flash.message = "管理员邮箱不能为空!"
            render(view: "create", model: [cmCorporationInfoInstance: cmCorporationInfoInstance, params: params])
        }

         def nickName = TbCustomerBlackList.findByNickname(cmCorporationInfoInstance.name)
         if(!nickName){
             flash.message = "商户别称在黑名单库中存在!"
             render(view: "create", model: [cmCorporationInfoInstance: cmCorporationInfoInstance, params: params])
         }

        def name = TbCustomerBlackList.findByName(cmCorporationInfoInstance.registrationName)
        if(!name){
            flash.message = "商户名称在黑名单库中存在!"
            render(view: "create", model: [cmCorporationInfoInstance: cmCorporationInfoInstance, params: params])
        }

        def businessLicenseCode = TbCustomerBlackList.findByBusinessLicenseCode(cmCorporationInfoInstance.businessLicenseCode)
        if(!businessLicenseCode){
            flash.message = "营业执照代码在黑名单库中存在!"
            render(view: "create", model: [cmCorporationInfoInstance: cmCorporationInfoInstance, params: params])
        }

        def organizationCode = TbCustomerBlackList.findByOrganizationCode(cmCorporationInfoInstance.organizationCode)
        if(!organizationCode){
            flash.message = "组织机构代码在黑名单库中存在!"
            render(view: "create", model: [cmCorporationInfoInstance: cmCorporationInfoInstance, params: params])
        }


        def legalPerson = TbCustomerBlackList.findByLegalPerson(cmCorporationInfoInstance.legal)
        if(!legalPerson){
            flash.message = "企业法人在黑名单库中存在!"
            render(view: "create", model: [cmCorporationInfoInstance: cmCorporationInfoInstance, params: params])
        }

        def identityNo = TbCustomerBlackList.findByIdentityNo(cmCorporationInfoInstance.identityNo)
        if(!identityNo){
            flash.message = "企业法人证件号码在黑名单库中存在!"
            render(view: "create", model: [cmCorporationInfoInstance: cmCorporationInfoInstance, params: params])
        }

        try {

            def f1 = request.getFile('idPositivePhotoFile') //证件正面照
            if(!f1.empty){
                def res = cmCorporationInfoService.processData(f1.getOriginalFilename(),f1,cmCorporationInfoInstance.customerNo,f1Dir)
                if (res[0].equals("true")) {
                    cmCorporationInfoInstance.idPositivePhoto = res[2];
                } else if (res[0] == "false") {
                    println(res[1])
                }
                cmCorporationInfoInstance.idPositiveReview = "wait"
            }


            def f2 = request.getFile('idOppositePhotoFile') //证件背面照
            if(!f2.empty){
                def res = cmCorporationInfoService.processData(f2.getOriginalFilename(),f2,cmCorporationInfoInstance.customerNo,f2Dir)
                if (res[0].equals("true")) {
                    cmCorporationInfoInstance.idOppositePhoto = res[2];
                } else if (res[0] == "false") {
                    println(res[1])
                }
                cmCorporationInfoInstance.idOppositeReview = "wait"
            }

            def f3 = request.getFile('businessLicensePhotoFile') //营业执照
            if(!f3.empty){
                def res = cmCorporationInfoService.processData(f3.getOriginalFilename(),f3,cmCorporationInfoInstance.customerNo,f3Dir)
                if (res[0].equals("true")) {
                    cmCorporationInfoInstance.businessLicensePhoto = res[2];
                } else if (res[0] == "false") {
                    println(res[1])
                }

                cmCorporationInfoInstance.businessLicenseReview = "wait"
            }

            def f4 = request.getFile('taxRegistrationPhotoFile') //税务登记照
            if(!f4.empty){
                def res = cmCorporationInfoService.processData(f4.getOriginalFilename(),f4,cmCorporationInfoInstance.customerNo,f4Dir)
                if (res[0].equals("true")) {
                    cmCorporationInfoInstance.taxRegistrationPhoto = res[2];
                } else if (res[0] == "false") {
                    println(res[1])
                }
                cmCorporationInfoInstance.taxRegistrationReview = "wait"
            }


            customerService.createCorporationInfo(cmCorporationInfoInstance, params.defaultEmail, params.appId)

            flash.message = "${message(code: 'default.created.message', args: [message(code: 'cmCorporationInfo.label', default: 'CmCorporationInfo'), cmCorporationInfoInstance.name])}"
            redirect(action: "list", id: cmCorporationInfoInstance.id)

        } catch (Exception e) {
            log.warn('open account faile', e)
            flash.message = "增加帐户失败，请重试：" + e.message
            render(view: "create", model: [cmCorporationInfoInstance: cmCorporationInfoInstance, params: params])
        }



    }

    def show = {

        def str = params.id
        def ids = str
        def sign
        def flag = 0
        if (str.indexOf(",") != -1) {
            def flags = str.split(",")
            ids = flags[0]
            sign = flags[1]
        }
        if (sign != null) {
            flag = 1
        }
        def cmCorporationInfoInstance = CmCorporationInfo.get(ids)
        if (!cmCorporationInfoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmCorporationInfo.label', default: 'CmCorporationInfo'), params.id])}"
            redirect(action: "list")
        }
        else {
            [cmCorporationInfoInstance: cmCorporationInfoInstance, flag: flag]
        }
    }

    def edit = {
        def cmCorporationInfoInstance = CmCorporationInfo.get(params.id)
        if (!cmCorporationInfoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmCorporationInfo.label', default: 'CmCorporationInfo'), params.id])}"
            redirect(action: "list")
        }
        else {
            if(params.review){
                if(params.review == "pass"){
                    flash.message = "审核通过"
                }else if (params.review == "refuse"){
                    flash.message = "审核拒绝"
                }
            }
            return [cmCorporationInfoInstance: cmCorporationInfoInstance]
        }
    }

    def update = {
        def cmCorporationInfoInstance = CmCorporationInfo.get(params.id)
        if (cmCorporationInfoInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (cmCorporationInfoInstance.version > version) {

                    cmCorporationInfoInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'cmCorporationInfo.label', default: 'CmCorporationInfo')] as Object[], "Another user has updated this CmCorporationInfo while you were editing")
                    render(view: "edit", model: [cmCorporationInfoInstance: cmCorporationInfoInstance])
                    return
                }
            }

            boolean statusFlag = false
            CmCustomer cmCustomerInstance = CmCustomer.get(cmCorporationInfoInstance.id)
            CmCustomerOperator cmCustomerOperatorInstance = CmCustomerOperator.findByCustomer(cmCustomerInstance)
            if(cmCustomerInstance.status == 'normal'){

                if(cmCustomerInstance.name != params.name || cmCorporationInfoInstance.registrationName != params.registrationName
                        || cmCustomerOperatorInstance.defaultEmail != params.defaultEmail || cmCorporationInfoInstance.taxRegistrationNo != params.taxRegistrationNo
                        || cmCorporationInfoInstance.organizationCode != params.organizationCode || cmCorporationInfoInstance.businessLicenseCode != params.businessLicenseCode){
                        statusFlag = true
                }
            }

            def name = cmCorporationInfoInstance?.name
            // 现金账户
            def accountCash = AcAccount.findByAccountNo(cmCorporationInfoInstance?.accountNo)
            //现金账户的冻结账户
            def accountCashFreeze = AcAccount.findByParentId(accountCash.id)
            if (accountCash.accountName) {
                accountCash.accountName = params.name
            }
            if (accountCashFreeze.accountName) {
                accountCashFreeze.accountName = params.name
            }
            accountCash.save flash: true, flush: true
            accountCashFreeze.save flash: true, flush: true
            //修改所有账户名称
            if (name != params.name) {
                def boCustomerService = BoCustomerService.findAllByCustomerId(params.id)
                AcAccount.withTransaction {
                    if (boCustomerService.size() > 0) {
                        boCustomerService.each {
                            //服务账户
                            def account = AcAccount.findByAccountNo(it.srvAccNo)
                            //服务账户的冻结账户
                            def accountFreeze = AcAccount.findByParentId(account.id)
                            //手续费账户
                            def feeAccount = AcAccount.findByAccountNo(it.feeAccNo)
                            //手续费账户的冻结账户
                            def feeAccountFreeze = AcAccount.findByParentId(feeAccount.id)
                            if (account.accountName) {
                                account.accountName = account.accountName.replaceAll(name, params.name)
                            } else {
                                account.accountName = params.name
                            }
                            if (accountFreeze.accountName) {
                                accountFreeze.accountName = accountFreeze.accountName.replaceAll(name, params.name)
                            } else {
                                accountFreeze.accountName = params.name
                            }
                            if (feeAccount.accountName) {
                                feeAccount.accountName = feeAccount.accountName.replaceAll(name, params.name)
                            } else {
                                feeAccount.accountName = params.name
                            }
                            if (feeAccountFreeze.accountName) {
                                feeAccountFreeze.accountName = feeAccountFreeze.accountName.replaceAll(name, params.name)
                            } else {
                                feeAccountFreeze.accountName = params.name
                            }
                            account.save(flash: true, flush: true)
                            accountFreeze.save(flash: true, flush: true)
                            feeAccount.save(flash: true, flush: true)
                            feeAccountFreeze.save(flash: true, flush: true)
                        }
                    }
                }
            }
            cmCorporationInfoInstance.properties = params

            def f1 = request.getFile('idPositivePhotoFile') //证件正面照
            if(!f1.empty){

                if(cmCorporationInfoInstance.idPositivePhoto){
                       File photo = new File(cmCorporationInfoService.UPLOAD_URL+"/"+f1Dir+"/"+cmCorporationInfoInstance.idPositivePhoto)
                       if(photo.exists()){
                           photo.delete()
                       }
                }

                def res = cmCorporationInfoService.processData(f1.getOriginalFilename(),f1,cmCorporationInfoInstance.customerNo,f1Dir)
                if (res[0].equals("true")) {
                    cmCorporationInfoInstance.idPositivePhoto = res[2];
                } else if (res[0] == "false") {
                    println(res[1])
                }
                cmCorporationInfoInstance.idPositiveReview = "wait"
            }


            def f2 = request.getFile('idOppositePhotoFile') //证件背面照
            if(!f2.empty){

                if(cmCorporationInfoInstance.idOppositePhoto){
                    File photo = new File(cmCorporationInfoService.UPLOAD_URL+"/"+f2Dir+"/"+cmCorporationInfoInstance.idOppositePhoto)
                    if(photo.exists()){
                        photo.delete()
                    }
                }
                def res = cmCorporationInfoService.processData(f2.getOriginalFilename(),f2,cmCorporationInfoInstance.customerNo,f2Dir)
                if (res[0].equals("true")) {
                    cmCorporationInfoInstance.idOppositePhoto = res[2];
                } else if (res[0] == "false") {
                    println(res[1])
                }
                cmCorporationInfoInstance.idOppositeReview = "wait"
            }

            def f3 = request.getFile('businessLicensePhotoFile') //营业执照
            if(!f3.empty){

                if(cmCorporationInfoInstance.businessLicensePhoto){
                    File photo = new File(cmCorporationInfoService.UPLOAD_URL+"/"+f3Dir+"/"+cmCorporationInfoInstance.businessLicensePhoto)
                    if(photo.exists()){
                        photo.delete()
                    }
                }
                def res = cmCorporationInfoService.processData(f3.getOriginalFilename(),f3,cmCorporationInfoInstance.customerNo,f3Dir)
                if (res[0].equals("true")) {
                    cmCorporationInfoInstance.businessLicensePhoto = res[2];
                } else if (res[0] == "false") {
                    println(res[1])
                }

                cmCorporationInfoInstance.businessLicenseReview = "wait"
            }

            def f4 = request.getFile('taxRegistrationPhotoFile') //税务登记照
            if(!f4.empty){

                if(cmCorporationInfoInstance.taxRegistrationPhoto){
                    File photo = new File(cmCorporationInfoService.UPLOAD_URL+"/"+f4Dir+"/"+cmCorporationInfoInstance.taxRegistrationPhoto)
                    if(photo.exists()){
                        photo.delete()
                    }
                }
                def res = cmCorporationInfoService.processData(f4.getOriginalFilename(),f4,cmCorporationInfoInstance.customerNo,f4Dir)
                if (res[0].equals("true")) {
                    cmCorporationInfoInstance.taxRegistrationPhoto = res[2];
                } else if (res[0] == "false") {
                    println(res[1])
                }
                cmCorporationInfoInstance.taxRegistrationReview = "wait"
            }

            if(statusFlag){
                cmCorporationInfoInstance.status = "init"
            }

            if (!cmCorporationInfoInstance.hasErrors() && cmCorporationInfoInstance.save(flush: true)) {
                if (!params.defaultEmail) {
                    flash.message = "管理员邮箱不能为空!"
                    render(view: "edit", model: [cmCorporationInfoInstance: cmCorporationInfoInstance])
                }

                try {
                    def operator = CmCustomerOperator.createCriteria().list {
                        eq('customer', cmCorporationInfoInstance);
                    }
                    operator[0].defaultEmail = params.defaultEmail
                    def login = CmLoginCertificate.findByCustomerOperator(operator[0])
                    login.loginCertificate = params.defaultEmail
                    operator[0].save(flush: true)
                    login.save(flush: true)
//                    customerService.createCorporationInfo(cmCorporationInfoInstance, params.defaultEmail)

//                    flash.message = "${message(code: 'default.created.message', args: [message(code: 'cmCorporationInfo.label', default: 'CmCorporationInfo'), cmCorporationInfoInstance.name])}"
//                    redirect(action: "list", id: cmCorporationInfoInstance.id)
                } catch (Exception e) {
                    log.warn('open account faile', e)
                    flash.message = "修改帐户失败，请重试：" + e.message
                    render(view: "edit", model: [cmCorporationInfoInstance: cmCorporationInfoInstance])
                }
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'cmCorporationInfo.label', default: 'CmCorporationInfo'), cmCorporationInfoInstance.name])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [cmCorporationInfoInstance: cmCorporationInfoInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmCorporationInfo.label', default: 'CmCorporationInfo'), params.id])}"
            redirect(action: "list")
        }

        //def opeatorEmail = ConfigurationHolder.config.grails.opeatorEmail


        //operatorService.sendEmailCaptcha(cmCustomer, cmCustomerOperator, opeatorEmaill, '重发验证地址')
    }

    def preview = {

        def photoUrl = ''

        def idPositivePhoto = params.idPositivePhoto
        def idOppositePhoto = params.idOppositePhoto
        def businessLicensePhoto = params.businessLicensePhoto
        def taxRegistrationPhoto = params.taxRegistrationPhoto

        if(idPositivePhoto){
            photoUrl = cmCorporationInfoService.UPLOAD_URL+"/"+f1Dir+"/"+idPositivePhoto
        }else if(idOppositePhoto){
            photoUrl = cmCorporationInfoService.UPLOAD_URL+"/"+f2Dir+"/"+idOppositePhoto
        }else if(businessLicensePhoto){
            photoUrl = cmCorporationInfoService.UPLOAD_URL+"/"+f3Dir+"/"+businessLicensePhoto
        }else if(taxRegistrationPhoto){
            photoUrl = cmCorporationInfoService.UPLOAD_URL+"/"+f4Dir+"/"+taxRegistrationPhoto
        }
        [photoUrl:photoUrl]
    }

    def previewPhoto = {

        def photoUrl = params.photoUrl
        response.setContentType("text/html; charset=UTF-8");
        response.setContentType("image/jpeg"); //设置图片格式格式，这里可以忽略
        FileInputStream fis = new FileInputStream(photoUrl);
        OutputStream os = response.getOutputStream();
        try {
            int count = 0;
            byte[] buffer = new byte[1024*1024];
            while ( (count = fis.read(buffer)) != -1 )
                os.write(buffer, 0, count);
        } catch (IOException e){
            e.printStackTrace();
        }finally {
            if(os!=null)
                os.close();
            if(fis != null)
                fis.close();
        }
    }


    def reviewPhoto = {

        def cmCorporationInfoInstance = CmCorporationInfo.get(params.id)
        def review = ""
        if(cmCorporationInfoInstance){

            if(params.idPositiveReview){
                cmCorporationInfoInstance.idPositiveReview = params.idPositiveReview
                review = params.idPositiveReview
            }else if(params.idOppositeReview){
                cmCorporationInfoInstance.idOppositeReview = params.idOppositeReview
                review = params.idOppositeReview
            }else if(params.businessLicenseReview){
                cmCorporationInfoInstance.businessLicenseReview = params.businessLicenseReview
                review = params.businessLicenseReview
            }else if(params.taxRegistrationReview){
                cmCorporationInfoInstance.taxRegistrationReview = params.taxRegistrationReview
                review = params.taxRegistrationReview
            }

           cmCorporationInfoInstance.save(flush: true)
        }

        redirect(action: "edit",params:[id: params.id,review:review])
    }

}
