package boss

import java.text.DecimalFormat

class BoChannelRateController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "id"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            eq("merchantId",Long.valueOf(params.merchantId))
        }
        def total = BoChannelRate.createCriteria().count(query)
        def results = BoChannelRate.createCriteria().list(params, query)
        [boChannelRateInstanceList: results, boChannelRateInstanceTotal: total,merchantId: params.merchantId]
    }

    def create = {
        def boChannelRateInstance = new BoChannelRate()
        boChannelRateInstance.properties = params
        return [boChannelRateInstance: boChannelRateInstance, merchantId: params.merchantId]
    }

    def save = {
        def count = 0
        params.max = 100
        def query = {
            eq("merchantId",Long.valueOf(params.merchantId))
        }
        def boChannelRateInstance = new BoChannelRate(params)
        def boChannelRateList = BoChannelRate.createCriteria().list(params,query)
        for(BoChannelRate boChannelRate : boChannelRateList){
            if(boChannelRate.isCurrent){
                count++
            }
        }
        /*def boChannelRateList = BoChannelRate.findByMerchantIdAndFeeType(Long.valueOf(params.merchantId),params.feeType)
        if(!boChannelRateList || (boChannelRateList && boChannelRateList.isCurrent==false) || boChannelRateInstance.isCurrent ==false){*/
        if(!boChannelRateList || count==0){
            if(params.feeType=='0'){
               boChannelRateInstance.isRefundFee = params.isRefundFee[0]
            }else{
               boChannelRateInstance.isRefundFee = params.isRefundFee[1]
            }
            if (boChannelRateInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.created.message', args: [message(code: 'boChannelRate.label', default: 'BoChannelRate'), boChannelRateInstance.id])}"
                redirect(action: "list", params:[merchantId: params.merchantId])
            }
            else {
                render(view: "create", model: [boChannelRateInstance: boChannelRateInstance])
            }
        }else{
            flash.message = "当前已有商户已有可用的手续费设置记录，不能重复添加"
            redirect(action: "list", params:[merchantId: params.merchantId])
        }

    }

    def show = {
        def boChannelRateInstance = BoChannelRate.get(params.id)
        if (!boChannelRateInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boChannelRate.label', default: 'BoChannelRate'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boChannelRateInstance: boChannelRateInstance]
        }
    }

    def edit = {
        def boChannelRateInstance = BoChannelRate.get(params.id)
        def df
        def strVal
        if(boChannelRateInstance.feeType=='0'){
            df = new DecimalFormat("0.00");//指定转换的格式
            strVal = df.format(boChannelRateInstance.feeRate)
        }
        if (!boChannelRateInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boChannelRate.label', default: 'BoChannelRate'), params.id])}"
            redirect(action: "list",params:[merchantId: boChannelRateInstance.merchantId])
        }
        else {
            return [boChannelRateInstance: boChannelRateInstance, strVal: strVal, merchantId:boChannelRateInstance.merchantId]
        }
    }

    def update = {
        def count = 0
        def boChannelRateId
        def boChannelRateInstance = BoChannelRate.get(params.id)
        params.max = 100
        def query = {
            eq("merchantId",Long.valueOf(params.merchantId))
            //eq("feeType",params.feeType)
        }
        def boChannelRateList = BoChannelRate.createCriteria().list(params,query)
        for(BoChannelRate boChannelRate : boChannelRateList){
            if(boChannelRate.isCurrent){
                count++
                boChannelRateId = boChannelRate.id
            }
        }
        //if(params.isCurrent==null || (params.isCurrent=='on' && ((count==1 && boChannelRateId == boChannelRateInstance.id) || count==0))){
        if(params.isCurrent==null || (params.isCurrent=='on' && ((count==1 && boChannelRateId == boChannelRateInstance.id) || count==0))){
            if (boChannelRateInstance) {
                if (params.version) {
                    def version = params.version.toLong()
                    if (boChannelRateInstance.version > version) {
                        boChannelRateInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boChannelRate.label', default: 'BoChannelRate')] as Object[], "Another user has updated this BoChannelRate while you were editing")
                        render(view: "edit", model: [boChannelRateInstance: boChannelRateInstance])
                        return
                    }
                }
                boChannelRateInstance.properties = params
                if(params.feeType=='0'){
                   boChannelRateInstance.isRefundFee = params.isRefundFee[0]
                }else{
                   boChannelRateInstance.isRefundFee = params.isRefundFee[1]
                }
                if (!boChannelRateInstance.hasErrors() && boChannelRateInstance.save(flush: true)) {
                    flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boChannelRate.label', default: 'BoChannelRate'), boChannelRateInstance.id])}"
                    redirect(action: "list", params:[merchantId: params.merchantId])
                }
                else {
                    render(view: "edit", model: [boChannelRateInstance: boChannelRateInstance])
                }
            }
            else {
                flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boChannelRate.label', default: 'BoChannelRate'), params.id])}"
                redirect(action: "list")
            }
        }
        else{
            flash.message = "当前已有商户已有可用的手续费设置记录，不能重复添加"
            redirect(action: "list", params:[merchantId: params.merchantId])
        }
    }

    def delete = {
        def boChannelRateInstance = BoChannelRate.get(params.id)
        if (boChannelRateInstance) {
            try {
                boChannelRateInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boChannelRate.label', default: 'BoChannelRate'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boChannelRate.label', default: 'BoChannelRate'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boChannelRate.label', default: 'BoChannelRate'), params.id])}"
            redirect(action: "list")
        }
    }
}
