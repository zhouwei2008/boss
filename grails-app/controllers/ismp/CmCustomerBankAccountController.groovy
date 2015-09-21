package ismp

import boss.DesUtil

class CmCustomerBankAccountController {

  static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

  def index = {
    redirect(action: "list", params: params)
  }

  def list = {
    params.sort = params.sort ? params.sort : "dateCreated"
    params.order = params.order ? params.order : "desc"
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    params.offset = params.offset ? params.int('offset') : 0
    def customer
    def query = {
      if (params['customer.id'] != null) {
        customer = CmCustomer.get(params['customer.id'])
        eq('customer', customer)
      }
    }
    def total = CmCustomerBankAccount.createCriteria().count(query)
    def results = CmCustomerBankAccount.createCriteria().list(params, query)
    [cmCustomerBankAccountInstanceList: results, cmCustomerBankAccountInstanceTotal: total, customer: customer]
  }

  def create = {
    def cmCustomerBankAccountInstance = new CmCustomerBankAccount()
    cmCustomerBankAccountInstance.properties = params
    return [cmCustomerBankAccountInstance: cmCustomerBankAccountInstance]
  }

  def save = {
    def cmCustomerBankAccountInstance = new CmCustomerBankAccount(params)
    cmCustomerBankAccountInstance.isDefault = false
    def encrypt = DesUtil.encrypt(params.bankAccountNo,cmCustomerBankAccountInstance.customer.customerNo)
    cmCustomerBankAccountInstance.bankAccountNo = encrypt
    if (cmCustomerBankAccountInstance.save(flush: true)) {
      flash.message = "${message(code: 'default.created.message', args: [message(code: 'cmCustomerBankAccount.label', default: 'CmCustomerBankAccount'), cmCustomerBankAccountInstance.bankAccountName])}"
      redirect(action: "list", params: params)
    }
    else {
      render(view: "create", model: [cmCustomerBankAccountInstance: cmCustomerBankAccountInstance])
    }
  }

  def show = {
    def cmCustomerBankAccountInstance = CmCustomerBankAccount.get(params.id)
    if (!cmCustomerBankAccountInstance) {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmCustomerBankAccount.label', default: 'CmCustomerBankAccount'), params.id])}"
      redirect(action: "list")
    }
    else {
//      cmCustomerBankAccountInstance.bankAccountNo = DesUtil.decrypt(cmCustomerBankAccountInstance.bankAccountNo,cmCustomerBankAccountInstance.customer.customerNo)
      [cmCustomerBankAccountInstance: cmCustomerBankAccountInstance]
    }
  }

  def edit = {
    def cmCustomerBankAccountInstance = CmCustomerBankAccount.get(params.id)
    if (!cmCustomerBankAccountInstance) {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmCustomerBankAccount.label', default: 'CmCustomerBankAccount'), params.id])}"
      redirect(action: "list")
    }
    else {
//       cmCustomerBankAccountInstance.bankAccountNo = DesUtil.decrypt(cmCustomerBankAccountInstance.bankAccountNo,cmCustomerBankAccountInstance.customer.customerNo)
       return [cmCustomerBankAccountInstance: cmCustomerBankAccountInstance]
    }
  }

  def update = {
    def cmCustomerBankAccountInstance = CmCustomerBankAccount.get(params.id)
    if (cmCustomerBankAccountInstance) {
      if (params.version) {
        def version = params.version.toLong()
        if (cmCustomerBankAccountInstance.version > version) {

          cmCustomerBankAccountInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'cmCustomerBankAccount.label', default: 'CmCustomerBankAccount')] as Object[], "Another user has updated this CmCustomerBankAccount while you were editing")
          render(view: "edit", model: [cmCustomerBankAccountInstance: cmCustomerBankAccountInstance])
          return
        }
      }
      cmCustomerBankAccountInstance.properties = params
      def encrypt = DesUtil.encrypt(params.bankAccountNo,cmCustomerBankAccountInstance.customer.customerNo)
      cmCustomerBankAccountInstance.bankAccountNo = encrypt
      if (!cmCustomerBankAccountInstance.hasErrors() && cmCustomerBankAccountInstance.save(flush: true)) {
        flash.message = "${message(code: 'default.updated.message', args: [message(code: 'cmCustomerBankAccount.label', default: 'CmCustomerBankAccount'), cmCustomerBankAccountInstance.bankAccountName])}"
        redirect(action: "list", params: params)
      }
      else {
        render(view: "edit", model: [cmCustomerBankAccountInstance: cmCustomerBankAccountInstance])
      }
    }
    else {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmCustomerBankAccount.label', default: 'CmCustomerBankAccount'), params.id])}"
      redirect(action: "list", params: params)
    }
  }

  def delete = {
    def cmCustomerBankAccountInstance = CmCustomerBankAccount.get(params.id)
    if (cmCustomerBankAccountInstance) {
      try {
        cmCustomerBankAccountInstance.delete(flush: true)
        flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'cmCustomerBankAccount.label', default: 'CmCustomerBankAccount'), params.id])}"
        redirect(action: "list")
      }
      catch (org.springframework.dao.DataIntegrityViolationException e) {
        flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'cmCustomerBankAccount.label', default: 'CmCustomerBankAccount'), params.id])}"
        redirect(action: "show", id: params.id)
      }
    }
    else {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'cmCustomerBankAccount.label', default: 'CmCustomerBankAccount'), params.id])}"
      redirect(action: "list")
    }
  }

  def setDefault = {
    if (params.id) {
      def cmCustomerBankAccountInstance = CmCustomerBankAccount.get(params.id)
      println("cmCustomerBankAccountInstance:"+cmCustomerBankAccountInstance)
      CmCustomerBankAccount.executeUpdate('update CmCustomerBankAccount a set a.isDefault=false where a.customer=?', [cmCustomerBankAccountInstance.customer])
      cmCustomerBankAccountInstance.isDefault = true
      cmCustomerBankAccountInstance.save()
    }
    redirect(action: "list", params: params)
  }
}
