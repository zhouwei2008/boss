package boss

import account.AcAccount

class BoVerifyController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def accountClientService
    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.type != null && params.type != '') {
                eq('type', params.type)
            }
            if (params.inBankAccountNo != null && params.inBankAccountNo != '') {
                like('inBankAccountNo', '%' + params.inBankAccountNo + '%')
            }
            if (params.outBankAccountNo != null && params.outBankAccountNo != '') {
                like('outBankAccountNo', '%' + params.outBankAccountNo + '%')
            }
            if (params.operName != null && params.operName != '') {
                like('operName', '%' + params.operName + '%')
            }


             //guonan update 2011-12-29
            validDated(params)
            if (params.startDateCreated) {
            ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
            lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
           // if (params.startDateCreated != null && params.startDateCreated != '') {
           //     ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
           // }
           // if (params.endDateCreated != null && params.endDateCreated != '') {
           //     le('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
           // }

            eq('status', '0')
        }
        def summ = BoVerify.createCriteria().get {
            and query
            projections {
                sum('outAmount')
            }
        }
        def results = BoVerify.createCriteria().list(params, query)
        def total = BoVerify.createCriteria().count(query)
        // [boVerifyInstanceList: BoVerify.list(params), boVerifyInstanceTotal: BoVerify.count()]
        [boVerifyInstanceList: results, boVerifyInstanceTotal: total,totalAmount:summ]
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

    /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan
     *
     */
    def validAppDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startAppDate==null && params.endAppDate==null){
            def gCalendar= new GregorianCalendar()
            params.endAppDate=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startAppDate=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startAppDate && !params.endAppDate){
             params.endAppDate=params.startAppDate
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startAppDate && params.endAppDate){
             params.startAppDate=params.endAppDate
        }
        if (params.startAppDate && params.endAppDate) {


        }
    }
    def recordList = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.inBankAccountNo != null && params.inBankAccountNo != '') {
                like('inBankAccountNo', '%' +params.inBankAccountNo+ '%')
            }
            if (params.type != null && params.type != '') {
                eq('type', params.type)
            }
            if (params.outBankAccountNo != null && params.outBankAccountNo != '') {
                like('outBankAccountNo', '%' +params.outBankAccountNo+ '%')
            }
            if (params.status != null && params.status != '') {
                eq('status', params.status)
            }
            if (params.operName != null && params.operName != '') {
                like('operName', '%' + params.operName + '%')
            }
            if (params.appName != null && params.appName != '') {
                like('appName', '%' + params.appName + '%')
            }
             //sunweiguo 增加转入转出银行名称查询
            if (params.inBankName != null && params.inBankName != '') {
                like('inBankName', '%' + params.inBankName + '%')
            }
            if (params.outBankName != null && params.outBankName != '') {
                like('outBankName', '%' + params.outBankName + '%')
            }
            //end update sunweiguo

           // if (params.startDateCreated != null && params.startDateCreated != '') {
           //     ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
           // }
           // if (params.endDateCreated != null && params.endDateCreated != '') {
           //     le('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
          //  }

          //  if (params.startAppDate != null && params.startAppDate != '') {
          //      ge('appDate', Date.parse('yyyy-MM-dd', params.startAppDate))
          //  }
          //  if (params.endAppDate != null && params.endAppDate != '') {
         //       le('appDate', Date.parse('yyyy-MM-dd', params.endAppDate) + 1)
          //  }
             //guonan update 2011-12-29
            validDated(params)
            if (params.startDateCreated) {
            ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
            lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }

             //guonan update 2011-12-29
//            validAppDated(params)
            if (params.startAppDate) {
            ge('appDate', Date.parse('yyyy-MM-dd', params.startAppDate))
            }
            if (params.endAppDate) {
            lt('appDate', Date.parse('yyyy-MM-dd', params.endAppDate) + 1)
            }
        }

        def summ = BoVerify.createCriteria().get {
            and query
            projections {
                sum('outAmount')
            }
        }
        def total = BoVerify.createCriteria().count(query)
        def results = BoVerify.createCriteria().list(params, query)
        [boVerifyInstanceList: results, boVerifyInstanceTotal: total,totalAmount:summ]

    }


    def create = {
        def boVerifyInstance = new BoVerify()
        boVerifyInstance.properties = params
        return [boVerifyInstance: boVerifyInstance]
    }

    def save = {
        def boVerifyInstance = new BoVerify(params)
        if (boVerifyInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boVerify.label', default: 'BoVerify'), boVerifyInstance.id])}"
            redirect(action: "list", id: boVerifyInstance.id)
        }
        else {
            render(view: "create", model: [boVerifyInstance: boVerifyInstance])
        }
    }

    def show = {
        def boVerifyInstance = BoVerify.get(params.id)
        if (!boVerifyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boVerify.label', default: 'BoVerify'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boVerifyInstance: boVerifyInstance]
        }
    }

    def edit = {
        def boVerifyInstance = BoVerify.get(params.id)
        if (!boVerifyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boVerify.label', default: 'BoVerify'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [boVerifyInstance: boVerifyInstance]
        }
    }

    def update = {
        def boVerifyInstance = BoVerify.get(params.id)
        if (boVerifyInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boVerifyInstance.version > version) {

                    boVerifyInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boVerify.label', default: 'BoVerify')] as Object[], "Another user has updated this BoVerify while you were editing")
                    render(view: "edit", model: [boVerifyInstance: boVerifyInstance])
                    return
                }
            }
            boVerifyInstance.properties = params
            if (!boVerifyInstance.hasErrors() && boVerifyInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boVerify.label', default: 'BoVerify'), boVerifyInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boVerifyInstance: boVerifyInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boVerify.label', default: 'BoVerify'), params.id])}"
            redirect(action: "list")
        }
    }


    def pass(params) {
        def boVerifyInstance = BoVerify.get(params.id)
        boVerifyInstance.status = "1"
        if (boVerifyInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boVerifyInstance.version > version) {

                    boVerifyInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boVerify.label', default: 'BoVerify')] as Object[], "Another user has updated this BoVerify while you were editing")
                    render(view: "edit", model: [boVerifyInstance: boVerifyInstance])
                    return
                }
            }
            boVerifyInstance.properties = params
            boVerifyInstance.status = "1"
            boVerifyInstance.appDate = new Date()
            boVerifyInstance.appName = session.op.name
            boVerifyInstance.appNo = session.op.account
            if (!boVerifyInstance.hasErrors() && boVerifyInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boVerify.label', default: 'BoVerify'), boVerifyInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "list", model: [boVerifyInstance: boVerifyInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boVerify.label', default: 'BoVerify'), params.id])}"
            redirect(action: "list")
        }
    }

    def refuse = {
        def boVerifyInstance = BoVerify.get(params.id)
        boVerifyInstance.status = "2"
        if (boVerifyInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boVerifyInstance.version > version) {

                    boVerifyInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boVerify.label', default: 'BoVerify')] as Object[], "Another user has updated this BoVerify while you were editing")
                    render(view: "edit", model: [boVerifyInstance: boVerifyInstance])
                    return
                }
            }
            def appNote = new AppNote()
            appNote.appId = params.id
            appNote.appName = 'boVerify'
            appNote.appNote = params.appNote
            appNote.status = '2'
            appNote.save()
            boVerifyInstance.properties = params
            if (!boVerifyInstance.hasErrors() && boVerifyInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boVerify.label', default: 'BoVerify'), boVerifyInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boVerifyInstance: boVerifyInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boVerify.label', default: 'BoVerify'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def boVerifyInstance = BoVerify.get(params.id)
        if (boVerifyInstance) {
            try {
                boVerifyInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boVerify.label', default: 'BoVerify'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boVerify.label', default: 'BoVerify'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boVerify.label', default: 'BoVerify'), params.id])}"
            redirect(action: "list")
        }
    }

    def dispartchImpl = {
        def boVerify = BoVerify.get(params.id)
        if (boVerify.type == '1') {
            charge(boVerify)
        } else if (boVerify.type == '2') {
            withDraw(boVerify)
        }
        else if (boVerify.type == '3') {
            transfer(boVerify)
        }
    }
    //银行账户充值

    def charge(boVerify) {
        if (boVerify.status == '0') {//如果未审核过则如下:
            def acq = BoAcquirerAccount.get(boVerify.toAcqId)
            def chargeAccNo = BoInnerAccount.findByKey('adjBalCharge').accountNo

            def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
            def cmdList = accountClientService.buildTransfer(null, acq.innerAcountNo, chargeAccNo, boVerify.outAmount.toBigDecimal(), 'transfer', '0', '0', "银行账户充值，${boVerify.note}".toString())

            def transResult = accountClientService.batchCommand(commandNo, cmdList)
            if (transResult.result == 'true') {
                flash.message = "账户充值成功"
                boVerify.status = "1"
                boVerify.appDate = new Date()
                boVerify.appName = session.op.name
                boVerify.appNo = session.op.account
                boVerify.save(flush: true)
                redirect(action: "list")
                return
            } else {
                flash.message = "账户充值失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}"
                redirect(action: "list")
                return
            }
        }
    }

    //银行账户提现

    def withDraw(boVerify) {
        if (boVerify.status == '0') {//如果未审核过则如下:
            def acq = BoAcquirerAccount.get(boVerify.fromAcqId)
            def withDrawAccNo = BoInnerAccount.findByKey('adjBalWithDraw').accountNo

            def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
            def cmdList = accountClientService.buildTransfer(null, withDrawAccNo, acq.innerAcountNo, boVerify.outAmount.toBigDecimal(), 'transfer', '0', '0', "银行账户提款，${boVerify.note}".toString())
            def transResult = accountClientService.batchCommand(commandNo, cmdList)
            if (transResult.result == 'true') {
                flash.message = "账户提款成功"
                boVerify.status = "1"
                boVerify.appDate = new Date()
                boVerify.appName = session.op.name
                boVerify.appNo = session.op.account
                boVerify.save(flush: true)
                redirect(action: "list")
                return
            } else {
                flash.message = "账户提款失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}"
                redirect(action: "list")
                return
            }
        }
    }
    //银行账户转账

    def transfer(boVerify) {
        if (boVerify.status == '0') {//如果未审核过则如下:
            def fromAcq = BoAcquirerAccount.get(boVerify.fromAcqId)
            def toAcq = BoAcquirerAccount.get(boVerify.toAcqId)
            def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
            def cmdList = []
            if (fromAcq != null) {
                cmdList = accountClientService.buildTransfer(null, toAcq.innerAcountNo, fromAcq.innerAcountNo, boVerify.outAmount.toBigDecimal(), 'transfer', '0', '0', "银行账户转账，${boVerify.note}".toString())
            }
            def transResult = accountClientService.batchCommand(commandNo, cmdList)
            if (transResult.result == 'true') {
                flash.message = "账户转账成功"
                boVerify.status = "1"
                boVerify.appDate = new Date()
                boVerify.appName = session.op.name
                boVerify.appNo = session.op.account
                boVerify.save(flush: true)
                redirect(action: "list")// render(view: 'transfer')
                return
            } else {
                flash.message = "账户转账失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}"
                redirect(action: "recordList")
                //render(view: 'recordList')
                return
            }
        }


    }

}
