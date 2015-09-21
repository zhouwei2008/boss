package boss

import account.AcAccount

import org.jpos.q2.cli.DATE

class BoAcquirerAccountController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def accountClientService

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [boAcquirerAccountInstanceList: BoAcquirerAccount.list(params), boAcquirerAccountInstanceTotal: BoAcquirerAccount.count()]
    }

    def create = {
        def boAcquirerAccountInstance = new BoAcquirerAccount()
        boAcquirerAccountInstance.properties = params
        return [boAcquirerAccountInstance: boAcquirerAccountInstance]
    }

    def save = {
        def boAcquirerAccountInstance = new BoAcquirerAccount(params)

        //增加帐户信息
        def result = accountClientService.openAcc(BoBankDic.get(params.bank.id).name + ' ' + params.branchName + ' 收单银行账户', 'credit')
        if (result.result == 'true') {
            boAcquirerAccountInstance.innerAcountNo = result.accountNo
        } else {
            throw new Exception("open account faile, error code:${result.errorCode}, ${result.errorMsg}")
        }

        if (boAcquirerAccountInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boAcquirerAccount.label', default: 'BoAcquirerAccount'), boAcquirerAccountInstance.bankAccountNo])}"
            redirect(action: "list")
        }
        else {
            render(view: "create", model: [boAcquirerAccountInstance: boAcquirerAccountInstance])
        }
    }

    def show = {
        def boAcquirerAccountInstance = BoAcquirerAccount.get(params.id)
        if (!boAcquirerAccountInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAcquirerAccount.label', default: 'BoAcquirerAccount'), params.id])}"
            redirect(action: "list")
        }
        else {
            def account = AcAccount.findByAccountNo(boAcquirerAccountInstance.innerAcountNo)
            [boAcquirerAccountInstance: boAcquirerAccountInstance, account: account]
        }
    }

    def edit = {
        def boAcquirerAccountInstance = BoAcquirerAccount.get(params.id)
        if (!boAcquirerAccountInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAcquirerAccount.label', default: 'BoAcquirerAccount'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [boAcquirerAccountInstance: boAcquirerAccountInstance]
        }
    }

    def update = {
        def boAcquirerAccountInstance = BoAcquirerAccount.get(params.id)
        if (boAcquirerAccountInstance) {
            if (params.version) {

                def version = params.version.toLong()
                if (boAcquirerAccountInstance.version > version) {

                    boAcquirerAccountInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boAcquirerAccount.label', default: 'BoAcquirerAccount')] as Object[], "Another user has updated this BoAcquirerAccount while you were editing")
                    render(view: "edit", model: [boAcquirerAccountInstance: boAcquirerAccountInstance])
                    return
                }
            }
            boAcquirerAccountInstance.properties = params
            if (!boAcquirerAccountInstance.hasErrors() && boAcquirerAccountInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boAcquirerAccount.label', default: 'BoAcquirerAccount'), boAcquirerAccountInstance.bankAccountNo])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boAcquirerAccountInstance: boAcquirerAccountInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAcquirerAccount.label', default: 'BoAcquirerAccount'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def boAcquirerAccountInstance = BoAcquirerAccount.get(params.id)
        if (boAcquirerAccountInstance) {
            try {
                boAcquirerAccountInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boAcquirerAccount.label', default: 'BoAcquirerAccount'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boAcquirerAccount.label', default: 'BoAcquirerAccount'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAcquirerAccount.label', default: 'BoAcquirerAccount'), params.id])}"
            redirect(action: "list")
        }
    }

    //银行账户充值
    def charge = {
        if (params.acqId) {
            def acq = BoAcquirerAccount.get(params.acqId)
            if (!acq || !params.amount || params.amount.toBigDecimal() <= 0) {

                flash.message = "参数错误"
                render(view: 'charge')
                return
            }
//            def boAcquirerAccount = new BoAcquirerAccount()
//            boAcquirerAccount.properties = params
//            def mer = new BoMerchant()
//            mer = BoMerchant.findAll()
//            if (mer != null) {
//                def flag = false
//                mer.each {
//                    if (it.acquirerAccount.id.toString().equals(params.acqId) && !flag && !it.channelSts.toString().equals("1")) {
//                        flag = true
//                    }
//                }
//                if (!flag) {
//                    flash.message = "您尚未设置收单商户或您设置收单商户通道状态不可用!"
//                    render(view: 'charge')
//                    return
//                }
//            }
            def chargeAccNo = BoInnerAccount.findByKey('adjBalCharge').accountNo
            def acc = AcAccount.findByAccountNo(acq.innerAcountNo)
            if (acc != null) {
                println acc.balance
                def boverify = new BoVerify()
                boverify.toAcqId = acq.id
                boverify.dateCreated = new Date()
                boverify.type = "1"//VerifyConstants.BOVERIFYTYPE_CHARGE
                boverify.inBankName = acq.branchName   //中国建设银行北京分行
                boverify.inBankAccountName = acq.bankAccountName
                boverify.inBankAccountNo = acq.bankAccountNo   //111111
                boverify.accountName = acq.bankAccountName          //君付通
                boverify.outAmount = (Double.parseDouble(params.amount)) * 100
                boverify.inRemainAmount = acc.balance
                boverify.status = "0"
                boverify.note = params.notes
                boverify.operNo = session.op.account
                boverify.operName = session.op.name
                if (boverify.save(flush: true)) {
                    flash.message = "账户充值申请已提交!"
                } else {
                    flash.message = "账户充值失败!"
                }
            } else {
                flash.message = "账户充值失败!银行账户不存在"
            }
            // def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
            /* def cmdList = accountClientService.buildTransfer(null, acq.innerAcountNo, chargeAccNo, params.amount.toBigDecimal() * 100.0, 'transfer', '0', '0', "银行账户充值，${params.notes}".toString())

            def transResult = accountClientService.batchCommand(commandNo, cmdList)

            if (transResult.result == 'true') {
              flash.message = "账户充值成功"
              render(view: 'charge')
              return
            } else {
              flash.message = "账户充值失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}"
              render(view: 'charge')
              return
            }*/
        }
    }

    //银行账户提现
    def withDraw = {
        if (params.acqId) {
            def acq = BoAcquirerAccount.get(params.acqId)
            if (!acq || !params.amount || params.amount.toBigDecimal() <= 0) {
                flash.message = "参数错误"
                render(view: 'withDraw')
                return
            }
            def acqAcc = AcAccount.findByAccountNo(acq.innerAcountNo)
            if (params.amount.toBigDecimal() > acqAcc.balance) {
                flash.message = "提款金额超过账户余额"
                render(view: 'withDraw')
                return
            }
//            def boAcquirerAccount = new BoAcquirerAccount()
//            boAcquirerAccount.properties = params
//            def mer = new BoMerchant()
//            mer = BoMerchant.findAll()
//            if (mer != null) {
//                def flag = false
//                mer.each {
//                    if (it.acquirerAccount.id.toString().equals(params.acqId) && !flag && !it.channelSts.toString().equals("1")) {
//                        flag = true
//                    }
//                }
//                if (!flag) {
//                    flash.message = "您尚未设置收单商户或您设置收单商户通道状态不可用!"
//                    render(view: 'charge')
//                    return
//                }
//            }
            def boverify = new BoVerify()
            boverify.fromAcqId = acq.id
            boverify.dateCreated = new Date()
            boverify.type = "2"//VerifyConstants.BOVERIFYTYPE_CHARGE
            boverify.outBankName = acq.branchName   //中国建设银行北京分行
            boverify.outBankAccountName = acq.bankAccountName
            boverify.outBankAccountNo = acq.bankAccountNo   //111111
            boverify.accountName = acq.bankAccountName          //君付通
            boverify.outAmount = java.lang.Double.parseDouble(params.amount) * 100.00
            println    acqAcc.balance
            boverify.outRemainAmount = java.lang.Double.parseDouble(acqAcc.balance.toString())
            boverify.note = params.notes
            boverify.status = "0"
            boverify.operNo = session.op.account
            boverify.operName = session.op.name
            println boverify.save(flush: true)
            if (boverify.save(flush: true,failOnError: true)) {
                flash.message = "账户提款申请已提交!!"
            } else {
                flash.message = "账户提款失败!"
            }
            /* def withDrawAccNo = BoInnerAccount.findByKey('adjBalWithDraw').accountNo

            def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
            def cmdList = accountClientService.buildTransfer(null, withDrawAccNo, acq.innerAcountNo, params.amount.toBigDecimal() * 100.0, 'transfer', '0', '0', "银行账户提款，${params.notes}".toString())
            def transResult = accountClientService.batchCommand(commandNo, cmdList)
            if (transResult.result == 'true') {
              flash.message = "账户提款成功"
              render(view: 'withDraw')
              return
            } else {
              flash.message = "账户提款失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}"
              render(view: 'withDraw')
              return
            }*/
        }
    }

    //银行账户转账
    def transfer = {
        if (params.fromAcqId && params.toAcqId) {
            def fromAcq = BoAcquirerAccount.get(params.fromAcqId)
            def toAcq = BoAcquirerAccount.get(params.toAcqId)
            if (!fromAcq || !toAcq || !params.amount || params.amount.toBigDecimal() <= 0) {
                flash.message = "参数错误"
                render(view: 'transfer')
                return
            }

            def fromAcqAcc = AcAccount.findByAccountNo(fromAcq.innerAcountNo)
            def toAcqAcc = AcAccount.findByAccountNo(toAcq.innerAcountNo)
            if (params.amount.toBigDecimal() > fromAcqAcc.balance) {
                flash.message = "转账金额超过账户余额"
                render(view: 'transfer')
                return
            }
//            def boAcquirerAccount = new BoAcquirerAccount()
//            boAcquirerAccount.properties = params
//            def mer = new BoMerchant()
//            mer = BoMerchant.findAll()
//            if (mer != null) {
//                def flag = false
//                mer.each {
//                    if (it.acquirerAccount.id.toString().equals(params.toAcqId) && !flag && !it.channelSts.toString().equals("1")) {
//                        flag = true
//                    }
//                }
//                if (!flag) {
//                    flash.message = "您尚未设置收单商户或您设置收单商户通道状态不可用!"
//                    render(view: 'charge')
//                    return
//                }
//            }
            def boverify = new BoVerify()
            boverify.fromAcqId = fromAcq.id
            boverify.toAcqId = toAcq.id
            boverify.dateCreated = new Date()
            boverify.type = "3"//VerifyConstants.BOVERIFYTYPE_CHARGE
            boverify.outBankName = fromAcq.branchName   //中国建设银行北京分行
            boverify.outBankAccountName = fromAcq.bankAccountName
            boverify.outBankAccountNo = fromAcq.bankAccountNo   //111111
            boverify.outRemainAmount = fromAcqAcc.balance
            boverify.inRemainAmount = toAcqAcc.balance
            boverify.inBankName = toAcq.branchName
            boverify.inBankAccountName = toAcq.bankAccountName
            boverify.inBankAccountNo = toAcq.bankAccountNo
            //boverify.accountName=acq.bankAccountName          //君付通
            boverify.outAmount = Double.parseDouble(params.amount) * 100.00
            boverify.status = "0"
            boverify.note = params.notes
            boverify.operNo = session.op.account
            boverify.operName = session.op.name
            if (boverify.save(flush: true)) {
                flash.message = "账户转帐申请已提交!!"
            } else {
                flash.message = "账户转帐失败!"
            }
            /* def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
            def cmdList = accountClientService.buildTransfer(null, toAcq.innerAcountNo, fromAcq.innerAcountNo, params.amount.toBigDecimal() * 100.0, 'transfer', '0', '0', "银行账户转账，${params.notes}".toString())
            def transResult = accountClientService.batchCommand(commandNo, cmdList)
            if (transResult.result == 'true') {
              flash.message = "账户转账成功"
              render(view: 'transfer')
              return
            } else {
              flash.message = "账户转账失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}"
              render(view: 'transfer')
              return
            }*/
        }
    }

    //获得银行账户信息
    def getAcqInfo = {
        def acq = BoAcquirerAccount.get(params.acqId)
        def acc = AcAccount.findByAccountNo(acq.innerAcountNo)
        render(contentType: "text/json") {
            bankAccountNo = acq.bankAccountNo
            bankAccountName = acq.bankAccountName
            balance = g.formatNumber(number: acc.balance / 100, type: 'currency', currencyCode: 'CNY')
            balanceNum = acc.balance / 100
        }
    }
    def getBank = {
        def boMer = BoMerchant.findAllByChannelSts('0')
        if (boMer != null) {
            boMer.each {
                def bo = BoAcquirerAccount.findByIdAndStatus(it.acquirerAccount.id, 'normal')
            }
        }
    }
}
