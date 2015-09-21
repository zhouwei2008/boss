package boss

class BoBalanceAccountDateRuleController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def bank
         def query = {
            if (params.bankid) {
                bank = BoBankDic.get(params.bankid)
                eq('bank',bank)
            }
        }
        def total = BoBalanceAccountDateRule.createCriteria().count(query)
        def gwOrderList = BoBalanceAccountDateRule.createCriteria().list(params, query)
        [boBalanceAccountDateRuleInstanceList: gwOrderList, boBalanceAccountDateRuleInstanceTotal: total]
    }

    def create = {
        def boBalanceAccountDateRuleInstance = new BoBalanceAccountDateRule()
        boBalanceAccountDateRuleInstance.properties = params

        def allBanks,existBanks
        allBanks = BoBankDic.list()
        existBanks = new ArrayList()
        BoBalanceAccountDateRule.list().each{ itk->
            existBanks<<itk.bank
        }
        return [boBalanceAccountDateRuleInstance: boBalanceAccountDateRuleInstance,banks:allBanks-existBanks]
    }

    def save = {

        def boBalanceAccountDateRuleInstance = new BoBalanceAccountDateRule()
        boBalanceAccountDateRuleInstance.bank=BoBankDic.get(params.bank.id)
        boBalanceAccountDateRuleInstance.acquireSynDayBeginTime   =Date.parse('HH:mm:ss', params.acquireSynDayBeginTime)
        boBalanceAccountDateRuleInstance.acquireSynDayEndTime  =Date.parse('HH:mm:ss', params.acquireSynDayEndTime)
        boBalanceAccountDateRuleInstance.settleDayTime=Date.parse('HH:mm:ss', params.settleDayTime)
        if (boBalanceAccountDateRuleInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boBalanceAccountDateRule.label', default: 'BoBalanceAccountDateRule'), boBalanceAccountDateRuleInstance.id])}"
            redirect(action: "list", id: boBalanceAccountDateRuleInstance.id)
        }
        else {
            render(view: "create", model: [boBalanceAccountDateRuleInstance: boBalanceAccountDateRuleInstance])
        }
    }

    def show = {
        def boBalanceAccountDateRuleInstance = BoBalanceAccountDateRule.get(params.id)
        if (!boBalanceAccountDateRuleInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boBalanceAccountDateRule.label', default: 'BoBalanceAccountDateRule'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boBalanceAccountDateRuleInstance: boBalanceAccountDateRuleInstance]
        }
    }

    def edit = {
        def boBalanceAccountDateRuleInstance = BoBalanceAccountDateRule.get(params.id)
        if (!boBalanceAccountDateRuleInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boBalanceAccountDateRule.label', default: 'BoBalanceAccountDateRule'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [boBalanceAccountDateRuleInstance: boBalanceAccountDateRuleInstance]
        }
    }

    def update = {
        def boBalanceAccountDateRuleInstance = BoBalanceAccountDateRule.get(params.id)

        if (boBalanceAccountDateRuleInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boBalanceAccountDateRuleInstance.version > version) {
                    
                    boBalanceAccountDateRuleInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boBalanceAccountDateRule.label', default: 'BoBalanceAccountDateRule')] as Object[], "Another user has updated this BoBalanceAccountDateRule while you were editing")
                    render(view: "edit", model: [boBalanceAccountDateRuleInstance: boBalanceAccountDateRuleInstance])
                    return
                }
            }
           // boBalanceAccountDateRuleInstance.properties = params
            boBalanceAccountDateRuleInstance.acquireSynDayBeginTime   =Date.parse('HH:mm:ss', params.acquireSynDayBeginTime)
            boBalanceAccountDateRuleInstance.acquireSynDayEndTime  =Date.parse('HH:mm:ss', params.acquireSynDayEndTime)
            boBalanceAccountDateRuleInstance.settleDayTime=Date.parse('HH:mm:ss', params.settleDayTime)
            if (!boBalanceAccountDateRuleInstance.hasErrors() && boBalanceAccountDateRuleInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boBalanceAccountDateRule.label', default: 'BoBalanceAccountDateRule'), boBalanceAccountDateRuleInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boBalanceAccountDateRuleInstance: boBalanceAccountDateRuleInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boBalanceAccountDateRule.label', default: 'BoBalanceAccountDateRule'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def boBalanceAccountDateRuleInstance = BoBalanceAccountDateRule.get(params.id)
        if (boBalanceAccountDateRuleInstance) {
            try {
                boBalanceAccountDateRuleInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boBalanceAccountDateRule.label', default: 'BoBalanceAccountDateRule'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boBalanceAccountDateRule.label', default: 'BoBalanceAccountDateRule'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boBalanceAccountDateRule.label', default: 'BoBalanceAccountDateRule'), params.id])}"
            redirect(action: "list")
        }
    }
}
