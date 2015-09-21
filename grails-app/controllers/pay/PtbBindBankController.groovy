package pay

import boss.BoAcquirerAccount


class PtbBindBankController {
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def pdbService
    def pdklist = {
        params.max = Math.min(params.max ? params.int('max') : 20, 100)
        def query = {
            eq('type', 'F')
        }
        [tbBindBankInstanceList: PtbBindBank.createCriteria().list(params, query), tbBindBankInstanceTotal: PtbBindBank.createCriteria().count(query)]
    }

    def psklist = {
        params.max = Math.min(params.max ? params.int('max') : 20, 100)
        def query = {
            eq('type', 'S')
        }
        [tbBindBankInstanceList: PtbBindBank.createCriteria().list(params, query), tbBindBankInstanceTotal: PtbBindBank.createCriteria().count(query)]
    }

    def pdkbind = {
         def result = pdbService.boAcquirerAccountList("F")
        [tbBindBankInstanceList:result]
    }

    def pskbind = {
         def result = pdbService.boAcquirerAccountList("S")
        [tbBindBankInstanceList:result]
    }

    def save = {
        def result = pdbService.savePtbBindBank(params)
        flash.message = "${message(code: result.msg, args: [message(code: result.msg, default: result.msg), result.tbBindBankInstance?.id])}"
        if (params.type == 'F') {
            redirect(action: "pdklist")
        } else {
            redirect(action: "psklist")
        }
    }
}
