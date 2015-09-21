package ismp

import jxl.Sheet
import jxl.Workbook
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.multipart.commons.CommonsMultipartFile

import java.text.SimpleDateFormat

/**
 * 黑名单管理
 */
class BackListController {

    static allowedMethods = [save: "POST", save: "GET", delete: "POST"]
    def backListService

    def index = {
        redirect(action: "list", params: params)
    }


    def list = {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)

        def type = ''
        if(params.type == null || params.type == ''){
            type = 'C'
        }else{
            type = params.type
        }

        def query = {
            if (params.name != null && params.name != '') {
                like("name", "%" + params.name.trim() + "%")
            }

            if(type == 'C'){
                if(params.businessLicenseCode != null && params.businessLicenseCode != ''){
                    like("businessLicenseCode","%" +params.businessLicenseCode.trim()+ "%")
                }

                if(params.legalPerson != null && params.legalPerson != ''){
                    like("legalPerson","%" +params.legalPerson.trim()+ "%")
                }

                if(params.organizationCode != null && params.organizationCode != ''){
                    like("organizationCode","%" +params.organizationCode.trim()+ "%")
                }
            }else if(type == 'P'){

                if(params.identityNo != null && params.identityNo != ''){
                    like("identityNo","%" +params.identityNo.trim()+ "%")
                }

                if(params.bankAccount != null && params.bankAccount != ''){
                    like("bankAccount","%" +params.bankAccount.trim()+ "%")
                }
            }
        }

        if(type == 'C'){
            def customerBlackList = TbCustomerBlackList.createCriteria().list(params,query)
            def total = TbCustomerBlackList.createCriteria().count(query)
            [customerBlackList: customerBlackList, customerBlackListTotal: total,type:type]
        }else if(type == 'P'){
            def personBlackList = TbPersonBlackList.createCriteria().list(params,query)
            def total = TbPersonBlackList.createCriteria().count(query)
            [personBlackList: personBlackList, personBlackListTotal: total,type:type]
        }
    }

    //个人用户

    def  createPer = {

        def tbPersonBlackList = new TbPersonBlackList()
        tbPersonBlackList.properties = params
        return [tbPersonBlackListInstance: tbPersonBlackList]
    }

    def savePer = {

        def tbPersonBlackList = new TbPersonBlackList(params)
        /**
         * 判断是否重复
         * @auther wanglei
         */
        String identityNo    = request.getParameter('identityNo')       //法人证件代码
        def    identityNoa    =    TbPersonBlackList.findByIdentityNo(identityNo)

        try {
            tbPersonBlackList.createDate = new Date()
            if (identityNoa){
//                paintln(identityNo)
                flash.message = "增加个体客户黑名失败，法人身份证号"+identityNo+"重复!"
                redirect(action: "list", params: [type :"P"])
                println(identityNo)
            }   else{

            tbPersonBlackList.save(flush: true)
                /**
                 * @auther wanglei
                 * 判断是否与商户列表重复
                 */
               def identityNoaa = CmPersonalInfo.findByIdentityNo(identityNo)
                if (identityNoaa){
                     flash.message ="此用户的身份证号"+identityNo+"在系统中存在，请管理员注意！"
                     redirect(action: "list", params: [type :"P"])
                } else{


            flash.message = "${message(code: 'default.created.message', args: [message(code: 'tbPersonBlackList.label', default: '个人客户黑名单'), tbPersonBlackList.name])}"
            redirect(action: "list", params: [type :"P"])
                }
            }
        }catch (Exception e){
            log.warn('save tbCustomerBlackList faile', e)
            flash.message = "增加个人客户黑名失败，请重试"
            render(view: "create", model: [tbPersonBlackListInstance: tbPersonBlackList])
        }
    }

    def showPer = {

        def tbPersonBlackList = TbPersonBlackList.get(params.id)
        if (!tbPersonBlackList) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbPersonBlackList.label', default: '个人客户黑名单'), params.id])}"
            redirect(action: "list", params: [type :"P"])
        }
        else {
            [tbPersonBlackListInstance: tbPersonBlackList]
        }
    }

    def editPer = {
        def tbPersonBlackList = TbPersonBlackList.get(params.id)
        if (!tbPersonBlackList) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbCustomerBlackList.label', default: '个人客户黑名单'), params.id])}"
            redirect(action: "list", params: [type :"P"])
        }
        else {
            [tbPersonBlackListInstance: tbPersonBlackList]
        }
    }

    def audit = {

        def type = params.type
        def id = params.id
        def idList = new ArrayList()
        idList = id.split(',')
        def msg = ''

        if (idList.size() > 0) {
            idList.each {
                if(type == 'C'){
                    def customerBlackList = TbCustomerBlackList.get(it)
                    def businessLicenseCode = CmCorporationInfo.findByBusinessLicenseCode(customerBlackList.businessLicenseCode)
                    if(businessLicenseCode){

                    }

                    def organizationCode =  CmCorporationInfo.findByOrganizationCode(customerBlackList.organizationCode)

                    def identityNo = CmCorporationInfo.findByIdentityNo(customerBlackList.identityNo)

                }else if(type == 'P'){
                    def personBlackList = TbPersonBlackList.get(it)

                    def identityNo = CmPersonalInfo.findByIdentityNo(personBlackList.id)
                }
            }
        }

        redirect(action: "list", params: [type :type])
    }

    def updatePer = {
        def tbPersonBlackList = TbPersonBlackList.get(params.id)
        if(tbPersonBlackList){
            tbPersonBlackList.properties = params
            if (!tbPersonBlackList.hasErrors() && tbPersonBlackList.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'tbPersonBlackList.label', default: '个人客户黑名单'), tbPersonBlackList.name])}"
                redirect(action: "list", params: [type :"P"])
            }
            else {
                render(view: "editPer", model: [tbPersonBlackListInstance: tbPersonBlackList])
            }
        }else{
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbPersonBlackList.label', default: '个人客户黑名单'), params.id])}"
            redirect(action: "list", params: [type :"P"])
        }
    }

    def deletePer = {
        def tbPersonBlackList = TbPersonBlackList.get(params.id)
        if (tbPersonBlackList) {
            tbPersonBlackList.hasErrors()
            tbPersonBlackList.delete(flush: true)
            flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'tbPersonBlackList.label', default: '个人客户黑名单'), tbPersonBlackList.name])}"
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbPersonBlackList.label', default: '个人客户黑名单'), params.id])}"
        }
        redirect(action: "list", params: [type :"P"])
    }


    //企业用户
    def createCust = {
        def tbCustomerBlackList = new TbCustomerBlackList()
        tbCustomerBlackList.properties = params
        return [tbCustomerBlackListInstance: tbCustomerBlackList]
    }


    def saveCust = {


        def tbCustomerBlackList = new TbCustomerBlackList(params)

        /**
         * 判断是否存在
         * @auther wanglei
         */
        String businessLicenseCode = request.getParameter('businessLicenseCode')                //营业执照
        String organizationCode    = request.getParameter('organizationCode')   //组织机构代码证
        String identityNo           =request.getParameter('identityNo')       //法人证件代码
        def businessLicenseCodes = TbCustomerBlackList.findByBusinessLicenseCode(businessLicenseCode)
        def     organizationCodes =   TbCustomerBlackList.findByOrganizationCode(organizationCode)
        def        identityNos     =    TbCustomerBlackList.findByIdentityNo(identityNo)
        try {
            tbCustomerBlackList.createDate = new Date()
            if (businessLicenseCodes)             {
                flash.message = "增加企业客户黑名失败，营业执照号"+businessLicenseCode+"重复!"
                redirect(action: "list", params: [type :"C"])
            }
            else  if (organizationCodes){
                flash.message = "增加企业客户黑名失败，组织机构代码证"+organizationCode+"重复!"
                redirect(action: "list", params: [type :"C"])
            }
            else   if (identityNos){
                flash.message = "增加企业客户黑名失败，法人身份证"+identityNo+"重复!"
                redirect(action: "list", params: [type :"C"])
            }


            else{
                tbCustomerBlackList.save(flush: true)

                /**
                 * @auther   wanglei
                 * 判断是否在客户表中真实存在
                 */
                def     businessLicenseCodess =       CmCorporationInfo.findByBusinessLicenseCode(businessLicenseCode)
                def     organizationCodess    =       CmCorporationInfo.findByOrganizationCode(organizationCode)
                def      identityNoss         =       CmCorporationInfo.findByIdentityNo(identityNo)

                if(businessLicenseCodess){
                    businessLicenseCodess.status="init"             //added by xyj, 20140915
                    businessLicenseCodess.save(flush: true)
                    flash.message = "此用户的营业执照号"+businessLicenseCode+"在企业客户列表存在，请管理员注意！"
                    redirect(action: "list", params: [type :"C"])
                }else if (organizationCodess){
                    organizationCodess.status="init"
                    organizationCodess.save(flush: true)
                    flash.message = "此用户的组织结构代码证号"+organizationCode+"在企业客户列表存在，请管理员注意！"
                    redirect(action: "list", params: [type :"C"])
                }else if (identityNoss){
                    identityNoss.status="init"
                    identityNoss.save(flush: true)
                    flash.message = "此用户的身份证号"+identityNo+"在企业客户列表存在，请管理员注意！"
                    redirect(action: "list", params: [type :"C"])
                }

//                if (businessLicenseCodess || organizationCodess || identityNoss ){
//                    flash.message = "此用户在企业客户列表存在，请手动修改"
//                    redirect(action: "list", params: [type :"C"])
//                }
                else{


                flash.message = "${message(code: 'default.created.message', args: [message(code: 'tbCustomerBlackList.label', default: '企业客户黑名单'), tbCustomerBlackList.name])}"
                redirect(action: "list", params: [type :"C"])
                }
            }
        }catch (Exception e){
            log.warn('save tbCustomerBlackList faile', e)
            flash.message = "增加企业客户黑名失败，请重试"
            render(view: "create", model: [tbCustomerBlackListInstance: tbCustomerBlackList])
        }
    }

    def showCust = {
        def tbCustomerBlackList = TbCustomerBlackList.get(params.id)
        if (!tbCustomerBlackList) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbCustomerBlackList.label', default: '企业客户黑名单'), params.id])}"
            redirect(action: "list", params: [type :"C"])
        }
        else {
            [tbCustomerBlackListInstance: tbCustomerBlackList]
        }
    }

    def editCust = {
        def tbCustomerBlackList = TbCustomerBlackList.get(params.id)
        if (!tbCustomerBlackList) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbCustomerBlackList.label', default: '企业客户黑名单'), params.id])}"
            redirect(action: "list", params: [type :"C"])
        }
        else {
            [tbCustomerBlackListInstance: tbCustomerBlackList]
        }
    }

    def inspectCust = {
        def tbCustomerBlackList = TbCustomerBlackList.get(params.id)
        if (!tbCustomerBlackList) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbCustomerBlackList.label', default: '企业客户黑名单'), params.id])}"
            redirect(action: "list", params: [type :"C"])
        }
        else {


            redirect(action: "list", params: [type :"C"])
        }
    }

    def updateCust = {
        def tbCustomerBlackList = TbCustomerBlackList.get(params.id)
        if(tbCustomerBlackList){
            tbCustomerBlackList.properties = params
            if (!tbCustomerBlackList.hasErrors() && tbCustomerBlackList.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'tbCustomerBlackList.label', default: '企业客户黑名单'), tbCustomerBlackList.name])}"
                redirect(action: "list", parWWams: [type :"C"])
            }
            else {
                render(view: "editCust", model: [tbCustomerBlackListInstance: tbCustomerBlackList])
            }
        }else{
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbCustomerBlackList.label', default: '企业客户黑名单'), params.id])}"
            redirect(action: "list", params: [type :"C"])
        }
    }

    def deleteCust = {

        def tbCustomerBlackList = TbCustomerBlackList.get(params.id)
        if (tbCustomerBlackList) {
            tbCustomerBlackList.hasErrors()
            tbCustomerBlackList.delete(flush: true)
            flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'tbCustomerBlackList.label', default: '企业客户黑名单'), tbCustomerBlackList.name])}"
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbCustomerBlackList.label', default: '企业客户黑名单'), params.id])}"
        }
        redirect(action: "list", params: [type :"C"])
    }


    def uploadBackCust = {
        def f = request.getFile('backlistFile')
        def filePath = ''
        if (f.empty) {
            flash.message = '企业黑名单文件内容为空，请重新输入企业黑名单文件。'
            redirect(action: "list", params: [type: "C"])
            return
        }
        try {
            def res = backListService.processData(f.getOriginalFilename(), f, 'C')
            if (res[0].equals("true")) {
                filePath = res[2];
            } else if (res[0] == "false") {
                log.warn res[1];
                flash.message = res[1];
                redirect(action: "list", params: [type: "C"])
                return
            }
            File file = new File(filePath)
            def wb = Workbook.getWorkbook(file)
            def sheet = wb.getSheet(0)
            def rows = sheet.getRows()
            def customerBlackList
            def count = 0

            List<TbCustomerBlackList> presongss = new  LinkedList<TbCustomerBlackList>()
                 Map<Integer,String> num = new HashMap<Integer,String>()
            for (int i = 1; i < rows; i++) {
                customerBlackList = new TbCustomerBlackList()
                def cell = sheet.getRow(i)
                //别称
                if (cell[1].getContents() != null && cell[1].getContents() != "") {
                    if (getWordCount(cell[1].getContents().trim()) > 64) {
                        flash.message = '第' + (i + 1) + "行的别称长度大于64个字符！"
                        redirect(action: "list", params: [type: "C"])
                        return
                    } else {
                        customerBlackList.nickname = cell[1].getContents().trim()
                    }
                } else {
                    flash.message = '第' + (i + 1) + "行的别称为空！"
                    redirect(action: "list", params: [type: "C"])
                    return
                }

                //客户名称
                if (cell[2].getContents() != null && cell[2].getContents() != "") {
                    if (getWordCount(cell[2].getContents().trim()) > 64) {
                        flash.message = '第' + (i + 1) + "行的客户名称长度大于64个字符！"
                        redirect(action: "list", params: [type: "C"])
                        return
                    } else {
                        customerBlackList.name = cell[2].getContents().trim()
                    }
                } else {
                    flash.message = '第' + (i + 1) + "行的客户名称为空！"
                    redirect(action: "list", params: [type: "C"])
                    return
                }

                //营业执照代码
                if (cell[3].getContents() != null && cell[3].getContents() != "") {
                    if (getWordCount(cell[3].getContents().trim()) > 20) {
                        flash.message = '第' + (i + 1) + "行的营业执照代码长度大于20个字符！"
                        redirect(action: "list", params: [type: "C"])
                        return
                    } else {
                        customerBlackList.businessLicenseCode = cell[3].getContents().trim()
                        def businessLicenseCode = TbCustomerBlackList.findByBusinessLicenseCode(customerBlackList.businessLicenseCode)
                        if(businessLicenseCode){
                            flash.message = '第' + (i + 1) + "行的营业执照代码已存在黑名单库中，请勿重复导入！"
                            redirect(action: "list", params: [type: "C"])
                            return
                        }
                    }
                } else {
                    flash.message = '第' + (i + 1) + "行的营业执照代码为空！"
                    redirect(action: "list", params: [type: "C"])
                    return
                }

                //营业执照有效期
                if (cell[4].getContents() != null && cell[4].getContents() != "") {
                    SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
                    try {
                        Date businessValidity = format.parse(cell[4].getContents().trim());
                        customerBlackList.businessValidity = businessValidity
                    } catch (Exception e) {
                        e.printStackTrace()
                        flash.message = '第' + (i + 1) + "行的营业执照有效期格式有误，请检查！"
                        redirect(action: "list", params: [type: "C"])
                        return
                    }
                } else {
                    flash.message = '第' + (i + 1) + "行的营业执照有效期为空！"
                    redirect(action: "list", params: [type: "C"])
                    return
                }

                //组织机构代码
                if (cell[5].getContents() != null && cell[5].getContents() != "") {
                    if (getWordCount(cell[5].getContents().trim()) > 20) {
                        flash.message = '第' + (i + 1) + "行的组织机构代码长度大于20个字符！"
                        redirect(action: "list", params: [type: "C"])
                        return
                    } else {
                        customerBlackList.organizationCode = cell[5].getContents().trim()
                        def organizationCode = TbCustomerBlackList.findByOrganizationCode(customerBlackList.organizationCode)
                        if(organizationCode){
                            flash.message = '第' + (i + 1) + "行的组织机构代码已存在黑名单库中，请勿重复导入！"
                            redirect(action: "list", params: [type: "C"])
                            return
                        }
                    }
                } else {
                    flash.message = '第' + (i + 1) + "行的组织机构代码为空！"
                    redirect(action: "list", params: [type: "C"])
                    return
                }

                //来源
                if (cell[6].getContents() != null && cell[6].getContents() != "") {
                    if (cell[6].getContents().trim().equals("人民银行")) {
                        customerBlackList.source = 'PBOC'
                    } else if (cell[6].getContents().trim().equals("公安部")) {
                        customerBlackList.source = 'MPS'
                    } else {
                        flash.message = '第' + (i + 1) + "行的来源信息有误，请检查！"
                        redirect(action: "list", params: [type: "C"])
                        return
                    }
                } else {
                    flash.message = '第' + (i + 1) + "行的来源为空！"
                    redirect(action: "list", params: [type: "C"])
                    return
                }

                //客户地址
                if (cell[7].getContents() != null && cell[7].getContents() != "") {
                    customerBlackList.address = cell[7].getContents().trim()
                }

                //经营范围
                if (cell[8].getContents() != null && cell[8].getContents() != "") {
                    customerBlackList.businessScope = cell[8].getContents().trim()
                }

                //法定代表人
                if (cell[9].getContents() != null && cell[9].getContents() != "") {
                    customerBlackList.legalPerson = cell[9].getContents().trim()
                } else {
                    flash.message = '第' + (i + 1) + "行的法定代表人为空！"
                    redirect(action: "list", params: [type: "C"])
                    return
                }

                //有效证件
                if (cell[10].getContents() != null && cell[10].getContents() != "") {
                    if (cell[10].getContents().trim().equals("身份证")) {
                        customerBlackList.identityType = "id"
                    } else if (cell[10].getContents().trim().equals("军官证")) {
                        customerBlackList.identityType = "arm"
                    } else if (cell[10].getContents().trim().equals("护照")) {
                        customerBlackList.identityType = "passp"
                    } else {
                        flash.message = '第' + (i + 1) + "行的有效证件信息有误，请检查！"
                        redirect(action: "list", params: [type: "C"])
                        return
                    }
                } else {
                    flash.message = '第' + (i + 1) + "行的法定代表人为空！"
                    redirect(action: "list", params: [type: "C"])
                    return
                }

                //证件号码
                if (cell[11].getContents() != null && cell[11].getContents() != "") {
                    if (getWordCount(cell[11].getContents().trim()) > 20) {
                        flash.message = '第' + (i + 1) + "行的证件号码长度大于20个字符！"
                        redirect(action: "list", params: [type: "C"])
                        return
                    } else {
                        customerBlackList.identityNo = cell[11].getContents().trim()
                        def identityNo = TbCustomerBlackList.findByIdentityNo(customerBlackList.identityNo)
                        if(identityNo){
                            flash.message = '第' + (i + 1) + "行的证件号码已存在黑名单库中，请勿重复导入！"
                            redirect(action: "list", params: [type: "C"])
                            return
                        }
                    }

                } else {
                    flash.message = '第' + i + "行的证件号码为空！"
                    redirect(action: "list", params: [type: "C"])
                    return
                }
                //证件有效期
                if (cell[12].getContents() != null && cell[12].getContents() != "") {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd")
                    try {
                        Date identityValidity = sdf.parse(cell[12].getContents().trim())
                        customerBlackList.identityValidity = identityValidity
                    } catch (Exception e) {
                        e.printStackTrace()
                        flash.message = '第' + (i + 1) + "行的证件有效期格式有误，请检查！"
                        redirect(action: "list", params: [type: "C"])
                        return
                    }
                } else {
                    flash.message = '第' + (i + 1) + "行的证件有效期为空！"
                    redirect(action: "list", params: [type: "C"])
                    return
                }

                 presongss.add(customerBlackList)
                count++


                /**
                 * @auther  wanglei
                 * 判断是否真实存在
                 */

                def     businessLicenseCodeas =       CmCorporationInfo.findByBusinessLicenseCode(customerBlackList.businessLicenseCode)
                def     organizationCodeas    =       CmCorporationInfo.findByOrganizationCode(customerBlackList.organizationCode)
                def      identityNoas         =       CmCorporationInfo.findByIdentityNo(customerBlackList.identityNo)
                if (businessLicenseCodeas){
//                    flash.message ='第' + (i + 1) +"行这个账户在企业用户中存在，请手动修改权限！"
//                    redirect(action: "list", params: [type: "C"])
//                    return
                    num.put(i+1,'营业执照'+customerBlackList.businessLicenseCode)
                }else  if (organizationCodeas){
                    num.put(i+1,'组织结构代码证'+customerBlackList.organizationCode)
                } else if (identityNoas){
                    num.put(i+1,'身份证号'+customerBlackList.identityNo)
                }


            }


            customerBlackList.createDate = new Date()
                   for (TbCustomerBlackList g: presongss){
                        g.save(flush:true)
                   }

            if (num.size()>0){
                            println(num.size())
//          for (int j=0;j<num.size();j++){
//              flash.message = '第'+num.get(num[j])
//          }
                flash.message=""
                //遍历集合
                Iterator its =num.entrySet().iterator()
                while (its.hasNext()){
                    Map.Entry entry =  its.next();
                    Object key = entry.getKey();
                    Object value = entry.getValue();
                     flash.message=flash.message+ '第'+key+'行的'+value+'在系统中存在，请管理员注意！  '
                }

                redirect(action: "list", params: [type: "C"])

            }  else{

//              if (num.size()>0){
//                  println(num.size())
////                  for (int j=0;j<num.size();j++){
////                       flash.message = "第"+num.get(key)+'行'
//                  }
//
//              }  else{
            flash.message = "成功导入" + count + "条企业客户黑名单记录。"
            redirect(action: "list", params: [type: "C"])
            }
        } catch (Exception e) {
            e.printStackTrace()
            flash.message = '企业黑名单上传出现异常，请检查上传文件！'
            redirect(action: "list", params: [type: "C"])
            return
        }
    }

    def uploadBackPer = {

        def f = request.getFile('backlistFile')
        def filePath = ''
        if(f.empty) {
            flash.message = '个人客户黑名单文件内容为空，请重新输入个人客户黑名单文件。'
            redirect(action: "list", params: [type :"P"])
            return
        }
        try {
            def res=backListService.processData(f.getOriginalFilename(),f,'P')
            if(res[0].equals("true")){
                filePath= res[2];
            }
            else if(res[0]=="false"){
                log.warn res[1];
                flash.message =res[1];
                redirect(action: "list", params: [type :"P"])
                return
            }
            File file = new File(filePath)
            def wb = Workbook.getWorkbook(file)
            def sheet = wb.getSheet(0)
            def rows = sheet.getRows()
            def personBlackList
            def count = 0

            Map<Integer,String> num = new HashMap<Integer,String>()
             List<TbPersonBlackList>  persons = new LinkedList<TbPersonBlackList>()
            for (int i = 1; i < rows; i++) {
                personBlackList = new TbPersonBlackList()

                def cell = sheet.getRow(i)

                //姓名
                if(cell[1].getContents()!=null && !cell[1].getContents().equals("")){
                    if (getWordCount(cell[1].getContents().trim()) > 32) {
                        flash.message = '第' + (i + 1) + "行的姓名长度大于32个字符！"
                        redirect(action: "list", params: [type: "P"])
                        return
                    } else {
                        personBlackList.name = cell[1].getContents().trim()
                    }
                }else{
                    flash.message = '第'+(i+1)+"行的客户名称为空！"
                    redirect(action: "list", params: [type :"P"])
                    return
                }
                //国籍
                if(cell[2].getContents()!=null  && !cell[2].getContents().equals("")){
                    if(cell[2].getContents().trim().equals("中国")){
                        personBlackList.nationality = "China"
                    }else{
                        flash.message = '第'+(i+1)+"行的国籍信息有误，国籍只能输入中国！"
                        redirect(action: "list", params: [type :"P"])
                        return
                    }
                }else{
                    flash.message = '第'+(i+1)+"行的国籍不能为空！"
                    redirect(action: "list", params: [type :"P"])
                    return
                }
                //性别
                if(cell[3].getContents()!=null  && !cell[3].getContents().equals("")){
                    if(cell[3].getContents().trim().equals("男")){
                        personBlackList.gender = "M"
                    }else if(cell[3].getContents().trim().equals("女")){
                        personBlackList.gender = "F"
                    }else{
                        flash.message = '第'+(i+1)+"行的性别信息有误，性别只能输入男、女！"
                        redirect(action: "list", params: [type :"P"])
                        return
                    }
                }else{
                    flash.message = '第'+(i+1)+"行的性别不能为空！"
                    redirect(action: "list", params: [type :"P"])
                    return
                }
                //职业
                if(cell[4].getContents()!=null  && !cell[4].getContents().equals("")){
                    if(cell[4].getContents().trim().equals("国家机关、党群组织、企业、事业单位负责人")){
                        personBlackList.occupation = "1"
                    }else if(cell[4].getContents().trim().equals("专业技术人员")){
                        personBlackList.occupation = "2"
                    }else if(cell[4].getContents().trim().equals("办事人员和有关人员")){
                        personBlackList.occupation = "3"
                    }else if(cell[4].getContents().trim().equals("商业、服务业人员")){
                        personBlackList.occupation = "4"
                    }else if(cell[4].getContents().trim().equals("农、林、牧、渔、水利业生产人员")){
                        personBlackList.occupation = "5"
                    }else if(cell[4].getContents().trim().equals("生产、运输设备操作人员及有关人员")){
                        personBlackList.occupation = "6"
                    }else if(cell[4].getContents().trim().equals("军人")){
                        personBlackList.occupation = "7"
                    }else{
                        personBlackList.occupation = "8"
                    }
                }else{
                    flash.message = '第'+(i+1)+"行的职业不能为空！"
                    redirect(action: "list", params: [type :"P"])
                    return
                }
                //住址
                if(cell[5].getContents()!=null  && !cell[5].getContents().equals("")){
                    personBlackList.address = cell[5].getContents().trim()
                }
                //联系方式
                if(cell[6].getContents()!=null  && !cell[6].getContents().equals("")){
                    personBlackList.contactWay = cell[6].getContents().trim()
                }
                //证件类型
                if(cell[7].getContents()!=null  && !cell[7].getContents().equals("")){
                    if(cell[7].getContents().trim().equals("身份证")){
                        personBlackList.identityType = "id"
                    }else if(cell[7].getContents().trim().equals("军官证")){
                        personBlackList.identityType = "arm"
                    }else if(cell[7].getContents().trim().equals("护照")){
                        personBlackList.identityType = "passp"
                    }else{
                        flash.message = '第'+(i+1)+"行的个人证件类型信息有误，国籍只能输入身份证、军官证、护照！"
                        redirect(action: "list", params: [type :"P"])
                        return
                    }
                }else{
                    flash.message = '第'+(i+1)+"行的个人证件类型不能为空！"
                    redirect(action: "list", params: [type :"P"])
                    return
                }
                //证件号码
                if(cell[8].getContents()!=null  && !cell[8].getContents().equals("")){
                    if (getWordCount(cell[8].getContents().trim()) > 20) {
                        flash.message = '第' + (i + 1) + "行的证件号码长度大于20个字符！"
                        redirect(action: "list", params: [type: "P"])
                        return
                    } else {
                        personBlackList.identityNo = cell[8].getContents().trim()
                        def identityNo = TbPersonBlackList.findByIdentityNo(personBlackList.identityNo)
                        if(identityNo){
                            flash.message = '第' + (i + 1) + "行的证件号码"+personBlackList.identityNo+"已存在黑名单库中，请勿重复导入！"
                            redirect(action: "list", params: [type: "P"])
                            return
                        }

                    }
                }else{
                    flash.message = '第'+(i+1)+"行的证件号码为空！"
                    redirect(action: "list", params: [type :"P"])
                    return
                }

                //证件有效期
                if(cell[9].getContents() != null && cell[9].getContents() != ""){
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd")
                    try {
                        Date identityValidity = sdf.parse(cell[9].getContents().trim())
                        personBlackList.validTime = identityValidity
                    }catch (Exception e){
                        e.printStackTrace()
                        flash.message = '第'+(i+1)+"行的证件有效期格式有误，请检查！"
                        redirect(action: "list", params: [type :"P"])
                        return
                    }
                }else{
                    flash.message = '第'+(i+1)+"行的证件有效期为空！"
                    redirect(action: "list", params: [type :"P"])
                }

                //来源
                if(cell[10].getContents() != null && cell[10].getContents() != ""){
                    if(cell[10].getContents().trim().equals("人民银行")){
                        personBlackList.source = 'PBOC'
                    }else if (cell[10].getContents().trim().equals("公安部")){
                        personBlackList.source = 'MPS'
                    }else{
                        flash.message = '第'+(i+1)+"行的来源信息有误，来源信息只能输入人民银行、公安部！"
                        redirect(action: "list", params: [type :"P"])
                        return
                    }
                }else{
                    flash.message = '第'+(i+1)+"行的来源为空！"
                    redirect(action: "list", params: [type :"P"])
                    return
                }

                /**
                 * @auther wanglei
                 * 添加成功后与数据库对比，提示风险人员那些名单是真实存在的
                 *
                 */

                    def identityNos = CmPersonalInfo.findByIdentityNo(personBlackList.identityNo)
                    if (identityNos){
                        int x = i+1
                        num.put(x,personBlackList.identityNo)
                    }

                persons.add(personBlackList)
                count++

            }


            personBlackList.createDate = new Date()
            for (TbPersonBlackList g : persons){
                g.save(flush: true)
            }


             if (num.size()>0){
                 println(num.size())
//                 for (int j=0;j<num.size();j++){
//                     println(num[j]+"dasdad")
//                     String ids =persons.get(j).identityNo
//                     flash.message += '第'+ num[j]+ '行证件号码'+ids  +'在系统中存在，请管理员注意！'
//                 }
                 flash.message=""
                 for(Integer s : num.keySet()){
                        String ids = num.get(s)
                     flash.message =flash.message+ '第'+s+ '行证件号码'+ids  +'在系统中存在，请管理员注意！'
                 }

                 redirect(action: "list", params: [type :"P"])
             } else{


//
//            for (int i = 1; i < rows; i++) {
//                personBlackList = new TbPersonBlackList()
//                def cell = sheet.getRow(i)
//
//                personBlackList.identityNo = cell[8].getContents().trim()
//                def identityNos = CmPersonalInfo.findByIdentityNo(personBlackList.identityNo)
//                if (identityNos){
//                    flash.message =  '第' + (i + 1) +"行在用户里存在，请自己修改"
//                    println('第'+i)
//                }
//                count++
//                redirect(action: "list", params: [type :"P"])
//                return
//            }

            flash.message = "成功导入"+count+"条个人客户黑名单记录。"
            redirect(action: "list", params: [type :"P"])
             }
        }catch (Exception e){
            e.printStackTrace()
            flash.message = '个人客户黑名单上传出现异常，请检查上传文件！'
            redirect(action: "list", params: [type :"P"])
            return
        }
    }

    def getCustBackListXlsFile = {
        def filepath = request.getRealPath("/")+"templates-excel"+ File.separator +"customer_model.xls"
        downfile(filepath, '企业客户黑名单Excel模板.XLS')
    }

    def getPerBackListXlsFile = {
        def filepath = request.getRealPath("/")+"templates-excel"+ File.separator +"person_model.xls"
        downfile(filepath, '个人客户黑名单Excel模板.XLS')
    }

    def downfile(String filepath, String fn){
        OutputStream out=response.getOutputStream()
        byte [] bs = new byte[500]
        File fileLoad=new File(filepath)
        response.setContentType("application/octet-stream;charset=gbk");
        response.setHeader("content-disposition","attachment; filename=" + java.net.URLEncoder.encode(fn, "UTF-8"));
        long fileLength=fileLoad.length();
        String length1=String.valueOf(fileLength);
        response.setHeader("Content_Length",length1)
        InputStream inputStream = new FileInputStream(fileLoad)
        int len
        while((len = inputStream.read(bs))!=-1){
            out.write(bs,0,len)
        }
        inputStream.close()
        out.flush()
        out.close()
    }

    def getWordCount(String s)
    {
        int length = 0;
        for(int i = 0; i < s.length(); i++)
        {
            int ascii = Character.codePointAt(s, i);
            if(ascii >= 0 && ascii <=255)
                length++;
            else
                length += 2;

        }
        return length;

    }

}