package boss

import org.springframework.orm.hibernate3.HibernateTemplate
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import ismp.CmCorporationInfo

class BoOperatorController {

//  static allowedMethods = [save: "POST", update: "POST", delete: "POST"]


    def dataSource_ismp

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def query = {
            if (params.account != null && params.account != '') {
                like('account', '%'+ params.account + '%')
            }
            if (params.name != null && params.name != '') {
                like('name', '%'+ params.name + '%')
            }
            if (params.role != null && params.role != '') {
                eq('role', BossRole.load(params.role))
            }
            if (params.status != null && params.status != '') {
                eq('status', params.status)
            }
	    
	    //guonan update 2012-02-19
	    
	    
	    if (params.branchCompany != null && params.branchCompany != '') {
                eq('branchCompany', params.branchCompany)
            }
//            if (params.belongToSale != null && params.belongToSale != '') {
//                eq('belongToSale', params.belongToSale)
//            }
//            if (params.startTime) {
//                ge('dateCreated', Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le('dateCreated', Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }
//            validDated(params)
             //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
            ge('dateCreated', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
            lt('dateCreated', Date.parse('yyyy-MM-dd', params.endTime) + 1)

             }
        }
        def total = BoOperator.createCriteria().count(query)
        def tradeList = BoOperator.createCriteria().list(params, query)
//        def sales = CmCorporationInfo.createCriteria().list{
//            isNotNull("belongToSale")
//            projections
//                    {
//                        groupProperty "belongToSale"
//                    }
//        }
//        println  sales
        [boOperatorInstanceList: tradeList, boOperatorInstanceTotal: total, params: params]
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
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startTime==null && params.endTime==null ){
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

    def create = {
        def boOperatorInstance = new BoOperator()
        //boOperatorInstance.properties = params
//        def sales = CmCorporationInfo.createCriteria().list{
//            isNotNull("belongToSale")
//            projections
//                    {
//                        groupProperty "belongToSale"
//                    }
//        }
        return [boOperatorInstance: boOperatorInstance]
    }

    def save = {
        def list = BoOperator.findAllByAccount(params.account)
        def flag = true
        if (list.size() > 0) {
            flash.message = "登陆名重复，请修改登陆名！"
            flag = false;
        }
        def boOperatorInstance = new BoOperator(params)
        boOperatorInstance.lastChangeTime = new Date()

        if (KeyUtils.checkPassStrength(params.password)) {
            boOperatorInstance.password = params.password.encodeAsSHA1()
        }else{
            flash.message = "密码长度必须大于8位，且必须是数字、字母和特殊字符组合而成"
            flag = false;
        }
        if (flag == true && boOperatorInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boOperator.label', default: 'BoOperator'), boOperatorInstance.name])}"
            redirect(action: "list", id: boOperatorInstance.id)
        }
        else {
//         def sales = CmCorporationInfo.createCriteria().list{
//            isNotNull("belongToSale")
//            projections
//                    {
//                        groupProperty "belongToSale"
//                    }
//        }
            render(view: "create", model: [boOperatorInstance: boOperatorInstance])
        }
    }

    def show = {
        def boOperatorInstance = BoOperator.get(params.id)
        if (!boOperatorInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOperator.label', default: 'BoOperator'), params.id])}"
            redirect(action: "list")
        }
        else {
/*         def sales = CmCorporationInfo.createCriteria().list{
            isNotNull("belongToSale")
            projections
                    {
                        groupProperty "belongToSale"
                    }
        }*/
            [boOperatorInstance: boOperatorInstance]
        }
    }

    def view = {
        def boOperatorInstance = BoOperator.get(params.id)
        if (!boOperatorInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOperator.label', default: 'BoOperator'), params.id])}"
            redirect(action: "list")
        }else{
            [boOperatorInstance: boOperatorInstance]
        }
    }


    def edit = {
        def boOperatorInstance = BoOperator.get(params.id)
        if (!boOperatorInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOperator.label', default: 'BoOperator'), params.id])}"
            redirect(action: "list")
        }
        else {
//         def sales = CmCorporationInfo.createCriteria().list{
//            isNotNull("belongToSale")
//            projections
//                    {
//                        groupProperty "belongToSale"
//                    }
//        }
            return [boOperatorInstance: boOperatorInstance]
        }
    }

    def update = {
        def boOperatorInstance = BoOperator.get(params.id)
        def list = BoOperator.findAllByAccount(params.account)
        if (list.size() > 0) {
            flash.message = "登陆名重复，请修改登陆名！"
            render(view: "edit", model: [boOperatorInstance: boOperatorInstance])
            return
        }
        if (boOperatorInstance) {
//          def sales = CmCorporationInfo.createCriteria().list{
//            isNotNull("belongToSale")
//            projections
//                    {
//                        groupProperty "belongToSale"
//                    }
//        }
            if (params.version) {
                def version = params.version.toLong()
                if (boOperatorInstance.version > version) {

                    boOperatorInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boOperator.label', default: 'BoOperator')] as Object[], "Another user has updated this BoOperator while you were editing")
                    render(view: "edit", model: [boOperatorInstance: boOperatorInstance])
                    return
                }
            }
            if (boOperatorInstance.lastChangeTime == null) {
                boOperatorInstance.lastChangeTime = boOperatorInstance.dateCreated
            }
            if (params.password != null && params.password != '') {
                if (!KeyUtils.checkPassStrength(params.password)) {
                    flash.message = "密码长度必须大于8位，且必须是数字、字母和特殊字符组合而成"
                    render(view: "edit", model: [boOperatorInstance: boOperatorInstance])
                    return
                }
                params.password = params.password.encodeAsSHA1()
                if (params.password != boOperatorInstance.password) {
                    boOperatorInstance.lastChangeTime = new Date()
                }
            } else {
                params.remove('password')
            }
            boOperatorInstance.properties = params
            if (!boOperatorInstance.hasErrors() && boOperatorInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boOperator.label', default: 'BoOperator'), boOperatorInstance.name])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boOperatorInstance: boOperatorInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOperator.label', default: 'BoOperator'), params.id])}"
            redirect(action: "list")
        }
    }

    def updateStatus = {
        def str = params.statusFlag
        if ("1".equals(str)) {
            params.setProperty("status", "normal")
        }
        if ("0".equals(str)) {
            params.setProperty("status", "disabled")
        }
        def boOperatorInstance = BoOperator.get(params.id)
        if (boOperatorInstance) {
//        def sales = CmCorporationInfo.createCriteria().list{
//            isNotNull("belongToSale")
//            projections
//                    {
//                        groupProperty "belongToSale"
//                    }
//        }
            if (params.version) {
                def version = params.version.toLong()
                if (boOperatorInstance.version > version) {

                    boOperatorInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boOperator.label', default: 'BoOperator')] as Object[], "Another user has updated this BoOperator while you were editing")
                    render(view: "edit", model: [boOperatorInstance: boOperatorInstance])
                    return
                }
            }
            boOperatorInstance.properties = params
            if (!boOperatorInstance.hasErrors() && boOperatorInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boOperator.label', default: 'BoOperator'), boOperatorInstance.name])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boOperatorInstance: boOperatorInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOperator.label', default: 'BoOperator'), params.id])}"
            redirect(action: "list")
        }
    }

    def updateUser = {
        def str = params.roleCode
        params.setProperty("roleSet", str)

        def boOperatorInstance = BoOperator.get(params.id)
        if (boOperatorInstance) {
//         def sales = CmCorporationInfo.createCriteria().list{
//            isNotNull("belongToSale")
//            projections
//                    {
//                        groupProperty "belongToSale"
//                    }
//        }
            if (params.version) {
                def version = params.version.toLong()
                if (boOperatorInstance.version > version) {

                    boOperatorInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boOperator.label', default: 'BoOperator')] as Object[], "Another user has updated this BoOperator while you were editing")
                    render(view: "edit", model: [boOperatorInstance: boOperatorInstance])
                    return
                }
            }
            boOperatorInstance.properties = params
            if (!boOperatorInstance.hasErrors() && boOperatorInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boOperator.label', default: 'BoOperator'), boOperatorInstance.name])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boOperatorInstance: boOperatorInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOperator.label', default: 'BoOperator'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def boOperatorInstance = BoOperator.get(params.id)
        if (boOperatorInstance) {
            try {
                boOperatorInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boOperator.label', default: 'BoOperator'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boOperator.label', default: 'BoOperator'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boOperator.label', default: 'BoOperator'), params.id])}"
            redirect(action: "list")
        }
    }

    def modPasswd = {
    }

    def updatePasswd = {

        if (!params.oldPass) {
            flash.message = "请输入旧密码！"
            redirect(action: "modPasswd")
            return
        }
        if (!params.newPass) {
            flash.message = "请输入新密码！"
            redirect(action: "modPasswd")
            return
        }
        if (!params.newPass2 || params.newPass != params.newPass2) {
            flash.message = "验证密码不相等！"
            redirect(action: "modPasswd")
            return
        }
        def op = BoOperator.get(session.op.id)
        if (params.oldPass.encodeAsSHA1() != op.password) {
            flash.message = "旧密码验证错误！"
            redirect(action: "modPasswd")
            return
        }

        if (!KeyUtils.checkPassStrength(params.newPass)) {
            flash.message = "密码长度必须大于8位，且必须是数字、字母和特殊字符组合而成"
            redirect(action: "modPasswd")
            return
        }

        op.password = params.newPass.encodeAsSHA1()
        op.lastChangeTime = new Date()
        op.save(failOnError: true, flush: true)
        flash.message = "修改密码成功！"
        redirect(action: "modPasswd")
    }
}
