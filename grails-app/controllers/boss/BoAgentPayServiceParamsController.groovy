package boss

import groovy.sql.Sql
import org.codehaus.groovy.grails.commons.ApplicationHolder
import org.springframework.context.ApplicationContext
import ismp.CmCustomer
import ismp.CmCustomerBankAccount

class BoAgentPayServiceParamsController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def query = {
            isNotNull("gatherWay")
            if(params.id){
                eq("id",params.long('id'))
            }
        }
        def count = BoAgentPayServiceParams.createCriteria().count(query)
        def results = BoAgentPayServiceParams.createCriteria().list(params,query)
        return [boAgentPayServiceParamsInstanceList: results, boAgentPayServiceParamsInstanceTotal: count, id:params.int('id')]
    }

    def accountList(def id) {
        def customer
        def query = {
            if (id != null) {
                customer = CmCustomer.get(id)
                eq('customer', customer)
                eq('status','normal')
            }
        }

        def results = CmCustomerBankAccount.createCriteria().list(params, query)
        return results
    }
    def create = {
        println params
        println params.customerId
        println "===="
        def cmCustomerBankAccountInstanceList = accountList(params.customerId);
        def boAgentPayServiceParamsInstance = new BoAgentPayServiceParams()
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        println params.id
        def query = {
            if(params.id){
                eq("id",params.long('id'))
            }
           // isNotNull("gatherWay")
        }
        def count = BoAgentPayServiceParams.createCriteria().count(query)
         BoCustomerService boCustomerService = BoCustomerService.get(params.long('id'))
            def serviceCode = ""
            if(boCustomerService!=null){
                 serviceCode = boCustomerService.serviceCode
            }
            boAgentPayServiceParamsInstance.properties = params
        def results = BoAgentPayServiceParams.createCriteria().list(params,query)
        if(count==1){
            redirect(action:'edit',params:[id:params.int('id'),serviceCode:serviceCode,customerId:params.customerId])
        }
        else if(count==0){
//            BoCustomerService boCustomerService = BoCustomerService.get(params.long('id'))
//            def serviceCode = ""
//            if(boCustomerService!=null){
//                 serviceCode = boCustomerService.serviceCode
//            }
//            boAgentPayServiceParamsInstance.properties = params

            return [boAgentPayServiceParamsInstance: results,id:params.int('id'),serviceCode:serviceCode,cmCustomerBankAccountInstanceList:cmCustomerBankAccountInstanceList]
        }
    }

    def save = {

        if(params.id!=null && params.id!="")
        {
            BoAgentPayServiceParams boAgentPayServiceParamsInstance = BoAgentPayServiceParams.get(params.id)
            if(boAgentPayServiceParamsInstance.serviceCode=="agentcoll"){
                params.backFee=""
                params.gatherWay=" "
                params.settWay=""
                params.procedureFee=null
                params.perprocedureFee=null
            }
            boAgentPayServiceParamsInstance.properties=params

            if (boAgentPayServiceParamsInstance.save(flush:true)) {
                flash.message="服务参数"+boAgentPayServiceParamsInstance.id+"已创建成功"
                redirect(controller: "boCustomerService",action: "list",params:[customerId:boAgentPayServiceParamsInstance.customerId])
            }
            else {
                render(view: "create", model: [boAgentPayServiceParamsInstance: boAgentPayServiceParamsInstance])
            }
        }
    }

    def show = {
        def boAgentPayServiceParamsInstance = BoAgentPayServiceParams.get(params.id)
        if (!boAgentPayServiceParamsInstance) {
            redirect(controller: "boCustomerService",action: "list",params:[customerId:boAgentPayServiceParamsInstance.customerId])
        }
        else {
            [boAgentPayServiceParamsInstance: boAgentPayServiceParamsInstance]
        }
    }

    def edit = {
        def boAgentPayServiceParamsInstance = BoAgentPayServiceParams.get(params.id)
         def cmCustomerBankAccountInstanceList = accountList(params.customerId);
        def serviceCode = params.serviceCode
        if (!boAgentPayServiceParamsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAgentPayServiceParams.label', default: 'BoAgentPayServiceParams'), params.id])}"
            redirect(action: "list",params:["id":boAgentPayServiceParamsInstance.id])
        }
        else {
            return [boAgentPayServiceParamsInstance: boAgentPayServiceParamsInstance,serviceCode:serviceCode,cmCustomerBankAccountInstanceList:cmCustomerBankAccountInstanceList]
        }
    }

    def update = {
        def boAgentPayServiceParamsInstance = BoAgentPayServiceParams.get(params.id)
        if (boAgentPayServiceParamsInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boAgentPayServiceParamsInstance.version > version) {
                    
                    boAgentPayServiceParamsInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boAgentPayServiceParams.label', default: 'BoAgentPayServiceParams')] as Object[], "Another user has updated this BoAgentPayServiceParams while you were editing")
                    render(view: "edit", model: [boAgentPayServiceParamsInstance: boAgentPayServiceParamsInstance])
                    return
                }
            }
            if(boAgentPayServiceParamsInstance.serviceCode=="agentcoll"){
                params.backFee=""
                params.gatherWay=" "
                params.settWay=""
                params.procedureFee=null
                params.perprocedureFee=null
            }
            boAgentPayServiceParamsInstance.properties = params
            boAgentPayServiceParamsInstance.batchChannel = params.batchChannel=="on"||params.batchChannel=="open"?"open":""; //批量代付
             boAgentPayServiceParamsInstance.singleChannel = params.singleChannel=="on"||params.singleChannel=="open"?"open":"";  //单笔代付
             boAgentPayServiceParamsInstance.interfaceChannel = params.interfaceChannel=="on"||params.interfaceChannel=="open"?'open':"";  //接口代付
            boAgentPayServiceParamsInstance.dqAccountId = params.dqId as Integer;
            if(params.windowTime)boAgentPayServiceParamsInstance.windowTime =  Float.parseFloat(params.windowTime) * 3600; //存到库里面单位为秒
            if (!boAgentPayServiceParamsInstance.hasErrors() && boAgentPayServiceParamsInstance.save(flush: true)) {
                flash.message="服务参数"+boAgentPayServiceParamsInstance.id+"已更新成功"
                redirect(controller: "boCustomerService",action: "list",params:[customerId:boAgentPayServiceParamsInstance.customerId])
            }
            else {
                render(view: "edit", model: [boAgentPayServiceParamsInstance: boAgentPayServiceParamsInstance])
            }
        }
        else {
            redirect(controller: "boCustomerService",action: "list",params:[customerId:boAgentPayServiceParamsInstance.customerId])
        }
    }

    def delete = {
        def boAgentPayServiceParamsInstance = BoAgentPayServiceParams.get(params.id)
        if (boAgentPayServiceParamsInstance) {
            try {
                boAgentPayServiceParamsInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boAgentPayServiceParams.label', default: 'BoAgentPayServiceParams'), params.id])}"
                redirect(action: "list",params:["id":boAgentPayServiceParamsInstance.id])
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boAgentPayServiceParams.label', default: 'BoAgentPayServiceParams'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAgentPayServiceParams.label', default: 'BoAgentPayServiceParams'), params.id])}"
            redirect(action: "list")
        }
    }
}
