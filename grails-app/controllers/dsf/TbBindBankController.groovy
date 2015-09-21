package dsf

import boss.BoAcquirerAccount

class TbBindBankController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def dklist = {
        params.max = Math.min(params.max ? params.int('max') : 20, 100)
        def query = {
            eq('dsfFlag', 'F')
        }

        [tbBindBankInstanceList: TbBindBank.createCriteria().list(params, query), tbBindBankInstanceTotal: TbBindBank.createCriteria().count(query)]
    }
    def sklist = {
        params.max = Math.min(params.max ? params.int('max') : 20, 100)
        def query = {
            eq('dsfFlag', 'S')
        }
        [tbBindBankInstanceList: TbBindBank.createCriteria().list(params, query), tbBindBankInstanceTotal: TbBindBank.createCriteria().count(query)]
    }
    def skbind = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [tbBindBankInstanceList: TbBindBank.list(params), tbBindBankInstanceTotal: TbBindBank.count()]
    }
    def dkbind = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [tbBindBankInstanceList: TbBindBank.list(params), tbBindBankInstanceTotal: TbBindBank.count()]
    }
    def create = {

        def tbBindBankInstance = new TbBindBank()
        tbBindBankInstance.properties = params
        return [tbBindBankInstance: tbBindBankInstance]
    }

    def save = {
        def boAcquirerAccount = new BoAcquirerAccount()
        def tbBindBank = new TbBindBank()
        tbBindBank.bankAccountno = params.bankAccountno
        tbBindBank.dsfFlag = params.dsfFlag
        TbBindBank tbBindBankin = TbBindBank.find(tbBindBank)

        List list = BoAcquirerAccount.findAllByBankAccountNo(params.bankAccountno)
        if (list.size() == 0) {
            flash.message = "${message(code: '帐号错误', args: [message(code: '帐号错误', default: 'TbBindBank')])}"
            if (params.dsfFlag == 'F') {
                redirect(action: "dklist")
            } else {
                redirect(action: "sklist")
            }

        } else if (tbBindBankin != null) {
            flash.message = "${message(code: '此账号已与此相同服务做过绑定', args: [message(code: '此账号已与此相同服务做过绑定', default: 'TbBindBank')])}"
            if (params.dsfFlag == 'F') {
                redirect(action: "dklist")
            } else {
                redirect(action: "sklist")
            }

        }
        else {
            def tbBindBankInstance = new TbBindBank(params)
            if (tbBindBankInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.created.message', args: [message(code: 'tbBindBank.label', default: '绑定成功'), tbBindBankInstance.id])}"

                if(params.dsfFlag=='F'){
                         redirect(action: "dklist",id: tbBindBankInstance.id)
                        } else {
                         redirect(action: "sklist",id: tbBindBankInstance.id)
                        }

            }
            else {
                render(view: "create", model: [tbBindBankInstance: tbBindBankInstance])
            }
        }
    }

    def show = {
        def tbBindBankInstance = TbBindBank.get(params.id)
        if (!tbBindBankInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbBindBank.label', default: 'TbBindBank'), params.id])}"
            redirect(action: "list")
        }
        else {
            [tbBindBankInstance: tbBindBankInstance]
        }
    }

    def edit = {
        def tbBindBankInstance = TbBindBank.get(params.id)
        if (!tbBindBankInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbBindBank.label', default: 'TbBindBank'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [tbBindBankInstance: tbBindBankInstance]
        }
    }

    def update = {
        def tbBindBankInstance = TbBindBank.get(params.id)
        if (tbBindBankInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (tbBindBankInstance.version > version) {

                    tbBindBankInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'tbBindBank.label', default: 'TbBindBank')] as Object[], "Another user has updated this TbBindBank while you were editing")
                    render(view: "edit", model: [tbBindBankInstance: tbBindBankInstance])
                    return
                }
            }
            tbBindBankInstance.properties = params
            if (!tbBindBankInstance.hasErrors() && tbBindBankInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'tbBindBank.label', default: 'TbBindBank'), tbBindBankInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [tbBindBankInstance: tbBindBankInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbBindBank.label', default: 'TbBindBank'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def tbBindBankInstance = TbBindBank.get(params.id)
        if (tbBindBankInstance) {
            try {
                tbBindBankInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'tbBindBank.label', default: 'TbBindBank'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'tbBindBank.label', default: 'TbBindBank'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbBindBank.label', default: 'TbBindBank'), params.id])}"
            redirect(action: "list")
        }
    }
}
