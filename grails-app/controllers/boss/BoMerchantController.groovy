package boss

import ismp.CmCustomerBankAccount
import java.text.DecimalFormat

class BoMerchantController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def acquirerAccount
        def query = {
            if (params['acquirerAccount.id'] != null) {
                acquirerAccount = BoAcquirerAccount.get(params['acquirerAccount.id'])
                eq('acquirerAccount', acquirerAccount)
            }
        }
        def total = BoMerchant.createCriteria().count(query)
        def results = BoMerchant.createCriteria().list(params, query)
        [boMerchantInstanceList: results, boMerchantInstanceTotal: total, acquirerAccount: acquirerAccount]
    }

    def create = {
        def boMerchantInstance = new BoMerchant()
        boMerchantInstance.properties = params
        return [boMerchantInstance: boMerchantInstance]
    }

    def save = {
        def boMerchantInstance = new BoMerchant(params)
        if (params.qutor != '') {
            boMerchantInstance.qutor = Double.parseDouble(params.qutor) * 100
        }
        if (params.dayQutor != '') {
            boMerchantInstance.dayQutor = Double.parseDouble(params.dayQutor) * 100
        }

        if (boMerchantInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boMerchant.label', default: 'BoMerchant'), boMerchantInstance.acquireMerchant])}"
            redirect(action: "list", params: params)
        }
        else {
            render(view: "create", model: [boMerchantInstance: boMerchantInstance])
        }
    }

    def show = {
        def boMerchantInstance = BoMerchant.get(params.id)
        if (!boMerchantInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boMerchant.label', default: 'BoMerchant'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boMerchantInstance: boMerchantInstance]
        }
    }

    def edit = {
        def boMerchantInstance = BoMerchant.get(params.id)
        def df = new DecimalFormat("0.00");//指定转换的格式
        def strVal = df.format(boMerchantInstance.dayQutor/100);
        def strQutor= df.format(boMerchantInstance.qutor/100);
//        boMerchantInstance.dayQutor= Double.parseDouble(strVal)
        def dQutor=strVal
        def qutor=strQutor
        if (!boMerchantInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boMerchant.label', default: 'BoMerchant'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [boMerchantInstance: boMerchantInstance,dQutor:dQutor,qutor:qutor]
        }
    }

    def update = {
        def boMerchantInstance = BoMerchant.get(params.id)
        if (boMerchantInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boMerchantInstance.version > version) {

                    boMerchantInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boMerchant.label', default: 'BoMerchant')] as Object[], "Another user has updated this BoMerchant while you were editing")
                    render(view: "edit", model: [boMerchantInstance: boMerchantInstance])
                    return
                }
            }
            boMerchantInstance.properties = params
            if (params.qutor != '') {
                boMerchantInstance.qutor = Double.parseDouble(params.qutor) * 100
            }
            if (params.dayQutor != '') {
                boMerchantInstance.dayQutor = Double.parseDouble(params.dayQutor) * 100
            }
            if (!boMerchantInstance.hasErrors() && boMerchantInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boMerchant.label', default: 'BoMerchant'), boMerchantInstance.acquireMerchant])}"
                params.put('acquirerAccount.id', boMerchantInstance.acquirerAccount.id)
                redirect(action: "list", params: params)
            }
            else {
                render(view: "edit", model: [boMerchantInstance: boMerchantInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boMerchant.label', default: 'BoMerchant'), params.id])}"
            redirect(action: "list", params: params)
        }
    }

    def delete = {
        def boMerchantInstance = BoMerchant.get(params.id)
        if (boMerchantInstance) {
            try {
                boMerchantInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boMerchant.label', default: 'BoMerchant'), params.id])}"
                redirect(action: "list", params: params)
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boMerchant.label', default: 'BoMerchant'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boMerchant.label', default: 'BoMerchant'), params.id])}"
            redirect(action: "list", params: params)
        }
    }
}
