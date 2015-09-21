package settle

import boss.BoMerchant

class FtFeeChannelController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def srvName = params.srvName
        if (params.srvCode != null && params.srvCode != '') {
            srvName = FtSrvType.findBySrvCode(params.srvCode).srvName
        }
        def query = {
            eq('type', params.srvCode)
        }
        def result = settle.FtFeeChannel.createCriteria().list(params, query)
        def count = settle.FtFeeChannel.createCriteria().count(query)
        [ftFeeChannelInstanceList: result, ftFeeChannelInstanceTotal: count, srvName: srvName, srvCode: params.srvCode, srvId: params.srvId]
    }

    def create = {
        def ftFeeChannelInstance = new settle.FtFeeChannel()
        ftFeeChannelInstance.properties = params
        if (params.srvCode == 'online') {
            return [ftFeeChannelInstance: ftFeeChannelInstance, srvCode: params.srvCode, srvId: params.srvId, flag: '0']
        } else if (params.srvCode == 'agentpay' || params.srvCode == 'agentcoll') {
            return [ftFeeChannelInstance: ftFeeChannelInstance, srvCode: params.srvCode, srvId: params.srvId, flag: '1']
        } else {
            render(view: "feeChannel", model: [ftFeeChannelInstance: ftFeeChannelInstance, srvCode: params.srvCode, srvId: params.srvId])
            return
        }

    }

    def save = {
        def ftFeeChannelInstance = new settle.FtFeeChannel(params)
        def code
        if (params.type == 'online') {
            def boMerchant = BoMerchant.findById(params.name)
            if (boMerchant) {
                ftFeeChannelInstance.code = boMerchant.serviceCode
                ftFeeChannelInstance.name = boMerchant.acquireName
                code = boMerchant.serviceCode
            } else {
                ftFeeChannelInstance.code = '000'
            }
        } else if (params.type == 'agentpay' || params.type == 'agentcoll') {
            ftFeeChannelInstance.code = params.name
            if (params.name == 'batch') {
                ftFeeChannelInstance.name = '批量渠道'
            } else if (params.name == 'single') {
                ftFeeChannelInstance.name = '单笔渠道'
            } else if (params.name == 'interface') {
                ftFeeChannelInstance.name = '接口渠道'
            }
            code = params.name
        } else {
            code = params.code
        }
        def ftFeeChannel = settle.FtFeeChannel.findAllByCodeAndType(code, params.type)
        if (ftFeeChannel.size() > 0) {

            if (params.type == 'online') {
                flash.message = "${params.type}业务类型下通道编号${params.code}已经存在，请重新填写！"
                render(view: "create", model: [ftFeeChannelInstance: ftFeeChannelInstance, srvCode: params.type, srvId: params.ftSrvTypeId, flag: '0'])
            } else if (params.type == 'agentpay' || params.type == 'agentcoll') {
                flash.message = "代收付业务类型下的通道${ftFeeChannelInstance.name}已经存在，请重新填写！"
                render(view: "create", model: [ftFeeChannelInstance: ftFeeChannelInstance, srvCode: params.type, srvId: params.ftSrvTypeId, flag: '1'])
            } else {
                flash.message = "${params.type}业务类型下通道编号${params.code}已经存在，请重新填写！"
                render(view: "feeChannel", model: [ftFeeChannelInstance: ftFeeChannelInstance, srvCode: params.type, srvId: params.ftSrvTypeId])
            }
        } else {
            if (ftFeeChannelInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.created.message', args: [message(code: 'ftFeeChannel.label', default: 'FtFeeChannel'), ftFeeChannelInstance.code])}"
                redirect(action: "list", id: ftFeeChannelInstance.id, params: [srvCode: params.type, srvId: params.ftSrvTypeId])
            } else {
                if (params.type == 'online') {
                    render(view: "create", model: [ftFeeChannelInstance: ftFeeChannelInstance, srvCode: params.type, srvId: params.ftSrvTypeId, flag: '0'])
                } else if (params.type == 'agentpay' || params.type == 'agentcoll') {
                    render(view: "create", model: [ftFeeChannelInstance: ftFeeChannelInstance, srvCode: params.type, srvId: params.ftSrvTypeId, flag: '1'])
                } else {
                    render(view: "feeChannelEdit", model: [ftFeeChannelInstance: ftFeeChannelInstance, srvCode: params.type, srvId: params.ftSrvTypeId])
                }
            }
        }
    }

    def show = {
        def ftFeeChannelInstance = settle.FtFeeChannel.get(params.id)
        if (!ftFeeChannelInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftFeeChannel.label', default: 'FtFeeChannel'), params.id])}"
            redirect(action: "list")
        }
        else {
            [ftFeeChannelInstance: ftFeeChannelInstance]
        }
    }

    def edit = {
        def ftFeeChannelInstance = settle.FtFeeChannel.get(params.id)
        if (!ftFeeChannelInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftFeeChannel.label', default: 'FtFeeChannel'), params.id])}"
            redirect(action: "list")
        }
        else {
            if (ftFeeChannelInstance.type == 'online') {
                return [ftFeeChannelInstance: ftFeeChannelInstance, flag: '0']
            } else if (ftFeeChannelInstance.type == 'agentpay' || ftFeeChannelInstance.type == 'agentcoll') {
                return [ftFeeChannelInstance: ftFeeChannelInstance, flag: '1']
            } else {
                render(view: "feeChannelEdit", model: [ftFeeChannelInstance: ftFeeChannelInstance])
                return
            }

        }
    }

    def update = {
        def ftFeeChannelInstance = settle.FtFeeChannel.get(params.id)
        def name
        if (params.type == 'online') {
            def boMerchant = BoMerchant.findByServiceCode(params.code)
            name = boMerchant.acquireName
        }  else {
            name = params.name
        }

        if (ftFeeChannelInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (ftFeeChannelInstance.version > version) {

                    ftFeeChannelInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'ftFeeChannel.label', default: 'FtFeeChannel')] as Object[], "Another user has updated this FtFeeChannel while you were editing")
                    render(view: "edit", model: [ftFeeChannelInstance: ftFeeChannelInstance])
                    return
                }
            }
            if (params.sign == '1') {
                def ftFeeChannel = settle.FtFeeChannel.findAllByCodeAndType(params.code, params.type)
                if (ftFeeChannel.size() > 0) {
                    if (params.type == 'online') {
                        flash.message = "${params.type}业务类型下通道编号${ftFeeChannel?.name}已经存在，请重新填写！"
                        render(view: "edit", model: [ftFeeChannelInstance: ftFeeChannelInstance, srvCode: params.type, srvId: params.ftSrvTypeId, flag: '0'])
                        return
                    } else if (params.type == 'agentpay' || params.type == 'agentcoll') {
                        flash.message = "代收付业务类型下通道已经存在，请重新填写！"
                        render(view: "edit", model: [ftFeeChannelInstance: ftFeeChannelInstance, srvCode: params.type, srvId: params.ftSrvTypeId, flag: '1'])
                        return
                    } else {
                        flash.message = "${params.type}业务类型下通道编号${params.code}已经存在，请重新填写！"
                        render(view: "feeChannelEdit", model: [ftFeeChannelInstance: ftFeeChannelInstance, srvCode: params.type, srvId: params.ftSrvTypeId])
                        return
                    }
                }
            }
            ftFeeChannelInstance.properties = params
            ftFeeChannelInstance.name = name
            if (params.code == 'batch') {
                ftFeeChannelInstance.name = '批量渠道'
            } else if (params.code == 'single') {
                ftFeeChannelInstance.name = '单笔渠道'
            } else if (params.code == 'interface') {
                ftFeeChannelInstance.name = '接口渠道'
            }
            if (!ftFeeChannelInstance.hasErrors() && ftFeeChannelInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'ftFeeChannel.label', default: 'FtFeeChannel'), ftFeeChannelInstance.code])}"
                redirect(action: "list", params: [srvCode: params.type, srvId: params.ftSrvTypeId])
            }
            else {
                render(view: "edit", model: [ftFeeChannelInstance: ftFeeChannelInstance, srvCode: params.type, srvId: params.ftSrvTypeId])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftFeeChannel.label', default: 'FtFeeChannel'), params.id])}"
            redirect(action: "list")
        }

    }

    def delete = {
        def ftFeeChannelInstance = settle.FtFeeChannel.get(params.id)
        def srvCode = ftFeeChannelInstance.type
        def srvId= ftFeeChannelInstance.ftSrvTypeId
        if (ftFeeChannelInstance) {
            try {
                ftFeeChannelInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'ftFeeChannel.label', default: 'FtFeeChannel'), params.id])}"
                redirect(action: "list", params: [srvCode: srvCode, srvId: srvId])
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'ftFeeChannel.label', default: 'FtFeeChannel'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftFeeChannel.label', default: 'FtFeeChannel'), params.id])}"
            redirect(action: "list",params: [srvCode: srvCode, srvId: srvId])
        }
    }
}
