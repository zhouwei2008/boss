package boss

import ismp.RefundAuth
import ismp.CmCustomer

class BoRefundModelController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        def boRefundModel
        if (params.customerId != null && params.customerId != '') {
            boRefundModel = BoRefundModel.findByCustomerServerId(params.customerId)
        }
        if (params.id != null && params.id != '') {
            boRefundModel = BoRefundModel.findByCustomerServerId(params.id)
        }
        [refundModel: boRefundModel, customerId: params.customerId]
    }

    def payList = {
        def boRefundModel
        if (params.customerId != null && params.customerId != '') {
            boRefundModel = BoRefundModel.findByCustomerServerId(params.customerId)
        }
        if (params.id != null && params.id != '') {
            boRefundModel = BoRefundModel.findByCustomerServerId(params.id)
        }
        [payModel: boRefundModel?.payModel, customerId: params.customerId]
    }

    def create = {
        def boRefundModelInstance = new BoRefundModel()
        boRefundModelInstance.properties = params
        return [boRefundModelInstance: boRefundModelInstance]
    }

    def save = {
        def boRefundModelInstance = new BoRefundModel(params)
        if (boRefundModelInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'boRefundModel.label', default: 'BoRefundModel'), boRefundModelInstance.id])}"
            redirect(action: "list", id: boRefundModelInstance.id)
        }
        else {
            render(view: "create", model: [boRefundModelInstance: boRefundModelInstance])
        }
    }

    def show = {
        def boRefundModelInstance = BoRefundModel.get(params.id)
        if (!boRefundModelInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRefundModel.label', default: 'BoRefundModel'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boRefundModelInstance: boRefundModelInstance]
        }
    }

    def edit = {
        def boRefundModelInstance = BoRefundModel.get(params.customerId)
        if (!boRefundModelInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRefundModel.label', default: 'BoRefundModel'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [boRefundModelInstance: boRefundModelInstance]
        }
    }

    def update = {
        if ((params.refundModel == null || params.refundModel == '') && (params.payModel == null || params.payModel == '') && (params.transferModel == null || params.transferModel == '')) {
            flash.message = "${message(code: '请选择至少一个服务模式！')}"
            redirect(action: "list", params: params)
            return
        }
        def boRefundModelInstance = BoRefundModel.findByCustomerServerId(params.customerId)
        def customerId=BoCustomerService.get(params.customerId).customerId
        if (boRefundModelInstance) {
            //println params.refundModel
            log.info 'local is ' + boRefundModelInstance.refundModel + ' params is ' + params.refundModel
            if (params.refundModel == 'payPassword' && boRefundModelInstance.refundModel != 'payPassword') {
                def customer = CmCustomer.get(customerId)//根据雷真讨论结果，删除对状态的判断条件，以免在将退款模式设置为“支付密码”时失败
                def refundAuth = RefundAuth.findWhere(customerNo: customer.customerNo, status: 'pass', type: 'starting', flag: true)
                if (refundAuth) {
                    flash.message = "${message(code: '请先处理待审核的退款单，然后再进行操作')}"
                    redirect(action: "list", params: params)
                    return
                }
            }
//            if(boRefundModelInstance.refundModel == params.refundModel){
//                flash.message = "${message(code: '设置成功')}"
//                redirect(action: "list", params: params)
//                return
//            }
//            if (params.refundModel == 'payPassword') {
//                //def customer = CmCustomer.findWhere(id: BoCustomerService.get(params.customerId).customerId, status: 'normal', type: 'C')
//                def customer = CmCustomer.findWhere(id: BoCustomerService.get(params.customerId).customerId)//根据雷真讨论结果，删除对状态的判断条件，以免在将退款模式设置为“支付密码”时失败
//                def refundAuth = RefundAuth.findWhere(customerNo: customer.customerNo, status: 'pass', type: 'starting', flag: true)
//                if (refundAuth) {
//                    flash.message = "${message(code: '请先处理待审核的退款单，然后再进行操作')}"
//                    redirect(action: "list", params: params)
//                    return
//                }
//            }
            boRefundModelInstance.properties = params
            if (!boRefundModelInstance.hasErrors() && boRefundModelInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: '服务模式', default: '服务模式'), ''])}"
                redirect(controller: "boCustomerService", action: "list", params: [id: boRefundModelInstance.customerServerId])
            }
            else {
                render(view: "list", model: [boRefundModelInstance: boRefundModelInstance])
            }
        }
        else {
            if (params.refundModel == 'payPassword') {
                def customer = CmCustomer.get(customerId)
                def refundAuth = RefundAuth.findWhere(customerNo: customer.customerNo, status: 'pass', type: 'starting', flag: true)
                if (refundAuth) {
                    flash.message = "${message(code: '请先处理待审核的退款单，然后再进行操作')}"
                    redirect(action: "list", params: params)
                    return
                }
            }
            boRefundModelInstance = new BoRefundModel()
            boRefundModelInstance.refundModel = params.refundModel
            boRefundModelInstance.customerServerId = params.customerId
            boRefundModelInstance.payModel = params.payModel
            boRefundModelInstance.transferModel = params.transferModel
            boRefundModelInstance.save failOnError: true
            flash.message = "${message(code: 'default.created.message', args: [message(code: '服务模式', default: '服务模式'), ''])}"
            redirect(controller: "boCustomerService", action: "list", params: [id: boRefundModelInstance.customerServerId])

        }
    }

    def updatePay = {
        if (!params.payModel) {
            flash.message = "${message(code: '请选择支付模式')}"
            redirect(action: "payList", params: params)
            return
        }
        def boRefundModelInstance = BoRefundModel.findByCustomerServerId(params.customerId)
        if (boRefundModelInstance) {
            //println params.refundModel
            log.info 'local is ' + boRefundModelInstance.payModel + ' params is ' + params.payModel
            if (boRefundModelInstance.payModel == params.payModel) {
                flash.message = "${message(code: '设置成功')}"
                redirect(action: "payList", params: params)
                return
            }

            boRefundModelInstance.properties = params
            if (!boRefundModelInstance.hasErrors() && boRefundModelInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: '支付模式', default: '支付模式'), boRefundModelInstance.id])}"
                redirect(controller: "boCustomerService", action: "list", params: [id: boRefundModelInstance.customerServerId])
            } else {
                render(view: "payList", model: [boRefundModelInstance: boRefundModelInstance])
            }
        } else {
            boRefundModelInstance = new BoRefundModel()
            boRefundModelInstance.payModel = params.payModel
            boRefundModelInstance.customerServerId = params.customerId
            boRefundModelInstance.save failOnError: true
            flash.message = "${message(code: 'default.created.message', args: [message(code: '支付模式', default: '支付模式'), boRefundModelInstance.id])}"
            redirect(controller: "boCustomerService", action: "list", params: [id: boRefundModelInstance.customerServerId])

        }
    }

    def delete = {
        def boRefundModelInstance = BoRefundModel.get(params.id)
        if (boRefundModelInstance) {
            try {
                boRefundModelInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boRefundModel.label', default: 'BoRefundModel'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boRefundModel.label', default: 'BoRefundModel'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boRefundModel.label', default: 'BoRefundModel'), params.id])}"
            redirect(action: "list")
        }
    }
}
