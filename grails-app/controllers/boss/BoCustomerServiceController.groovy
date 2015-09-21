package boss

import ismp.CmCustomer
import groovy.sql.Sql
import ismp.CmCustomerChannel

class BoCustomerServiceController {

    def accountClientService
    def dataSource_ismp

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
        if (params['customerId'] != null) {
            customer = CmCustomer.get(params['customerId'])
        }
        def query = {
            if (params['customerId'] != null) {
                customer = CmCustomer.get(params['customerId'])
                eq('customerId', customer.id)
            }
            if (params.id != null && params.id != '') {
                eq('id', params.id as Long)
            }
        }
        def total = BoCustomerService.createCriteria().count(query)
        def results = BoCustomerService.createCriteria().list(params, query)
        [boCustomerServiceInstanceList: results, boCustomerServiceInstanceTotal: total, customer: customer]
    }

    def create = {
        def boCustomerServiceInstance = new BoCustomerService()
        boCustomerServiceInstance.properties = params
        return [boCustomerServiceInstance: boCustomerServiceInstance]
    }

    def save = {
        def boCustomerServiceInstance
        if (params.serviceCode == 'agentcoll' || params.serviceCode == 'agentpay'||params.serviceCode == 'online') {
            params.feeParams = ""
            params.serviceParams = ""
            boCustomerServiceInstance = new BoAgentPayServiceParams(params)
        } 
        
        if (params.serviceCode == 'online' || params.serviceCode == 'royalty' || params.serviceCode == 'selfSign' || params.serviceCode == 'precharge') {
            boCustomerServiceInstance = new BoCustomerService(params)
        }

        //判断同个客户的同样服务类型，不能有多个当前可用服务
        if (boCustomerServiceInstance.isCurrent) {
            def currentService = BoCustomerService.createCriteria().get {
                eq('customerId', boCustomerServiceInstance.customerId)
                eq('serviceCode', boCustomerServiceInstance.serviceCode)
                eq('isCurrent', true)
            }
            if (currentService) {
                flash.message = "同个客户的同样服务类型，不能有多个当前可用服务。合同号为 [${currentService.contractNo}] 的\"${BoCustomerService.serviceMap[currentService.serviceCode]}\"服务已经是当前可用状态"
                render(view: "create", model: [boCustomerServiceInstance: boCustomerServiceInstance])
                return
            }
        }


        //查询以前的同类型服务，如果有的话继承之前的服务帐户和手续费账户
//        def preSrv = BoCustomerService.findWhere(customerId: boCustomerServiceInstance.customerId, serviceCode: boCustomerServiceInstance.serviceCode)
       def preSrvList= BoCustomerService.createCriteria().list {
                eq('customerId', boCustomerServiceInstance.customerId)
                eq('serviceCode', boCustomerServiceInstance.serviceCode)
                order("dateCreated", "desc")
            }
       def preSrv
        if(preSrvList){
            preSrv =  preSrvList.get(0)
        }

        if (preSrv) {
            boCustomerServiceInstance.srvAccNo = preSrv.srvAccNo
            boCustomerServiceInstance.feeAccNo = preSrv.feeAccNo
            if (boCustomerServiceInstance.save(failOnError: true)) {
                flash.message = "${message(code: 'default.created.message', args: [message(code: 'boCustomerService.label', default: 'BoCustomerService'), boCustomerServiceInstance.contractNo])}"
                redirect(action: "list", params: params)
            } else {
                flash.message = "${message(code: 'default.created.message', args: [message(code: 'boCustomerService.label', default: 'BoCustomerService'), boCustomerServiceInstance.contractNo])}"
                render(view: "create", model: [boCustomerServiceInstance: boCustomerServiceInstance])
            }
        } else {
            //分配新账号，开启事务，保证帐户开设同步
            BoCustomerService.withTransaction {status ->
                if (boCustomerServiceInstance.save(failOnError: true)) {
                    //增加帐户信息
                    try {
                        //开通服务账户
                        def result = accountClientService.openAcc("客户${CmCustomer.get(boCustomerServiceInstance.customerId)?.name} ${BoCustomerService.serviceMap[boCustomerServiceInstance.serviceCode]}服务帐户".toString(), 'debit', true)
                        if (result.result == 'true') {
                            //更新帐户号
                            boCustomerServiceInstance.srvAccNo = result.accountNo
                        } else {
                            throw new Exception("开设服务帐户失败，error code:${result.errorCode}, ${result.errorMsg}")
                        }
                        //开通手续费账户
                        result = accountClientService.openAcc("客户${CmCustomer.get(boCustomerServiceInstance.customerId)?.name} ${BoCustomerService.serviceMap[boCustomerServiceInstance.serviceCode]}服务手续费帐户".toString(), 'credit', false)
                        if (result.result == 'true') {
                            //更新帐户号
                            boCustomerServiceInstance.feeAccNo = result.accountNo
                        } else {
                            throw new Exception("开设服务手续费帐户失败，error code:${result.errorCode}, ${result.errorMsg}")
                        }
                        boCustomerServiceInstance.save()
                    } catch (Exception e) {
                        //roll back
                        status.setRollbackOnly()
                        log.warn(e.message, e)
                        flash.message = e.message
                        render(view: "create", model: [boCustomerServiceInstance: boCustomerServiceInstance])
                        return
                    }

                    flash.message = "${message(code: 'default.created.message', args: [message(code: 'boCustomerService.label', default: 'BoCustomerService'), boCustomerServiceInstance.contractNo])}"
                    redirect(action: "list", params: params)
                } else {
                    render(view: "create", model: [boCustomerServiceInstance: boCustomerServiceInstance])
                }
            }
        }

    }

    def show = {
        def boCustomerServiceInstance = BoCustomerService.get(params.id)
        if (!boCustomerServiceInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boCustomerService.label', default: 'BoCustomerService'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boCustomerServiceInstance: boCustomerServiceInstance]
        }
    }

    def edit = {
        def boCustomerServiceInstance = BoCustomerService.get(params.id)
        if (!boCustomerServiceInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boCustomerService.label', default: 'BoCustomerService'), params.id])}"
            redirect(action: "list", params: params)
        }
        else {
            return [boCustomerServiceInstance: boCustomerServiceInstance]
        }
    }

    def update = {
        def boCustomerServiceInstance = BoCustomerService.get(params.id)
        if (boCustomerServiceInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boCustomerServiceInstance.version > version) {

                    boCustomerServiceInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boCustomerService.label', default: 'BoCustomerService')] as Object[], "Another user has updated this BoCustomerService while you were editing")
                    render(view: "edit", model: [boCustomerServiceInstance: boCustomerServiceInstance])
                    return
                }
            }

            //判断服务不能同时可用
            if (params.isCurrent) {
                def currentService = BoCustomerService.createCriteria().get {
                    eq('customerId', Long.parseLong(params.customerId))
                    eq('serviceCode', params.serviceCode)
                    eq('isCurrent', true)
                }
                if (currentService && !params.id.equals(currentService.id.toString())) {
                    flash.message = "同个客户的同样服务类型，不能有多个当前可用服务。合同号为 [${currentService.contractNo}] 的\"${BoCustomerService.serviceMap[currentService.serviceCode]}\"服务已经是当前可用状态"
                    render(view: "edit", model: [boCustomerServiceInstance: boCustomerServiceInstance])
                    return
                }
            }
            println params.batchChannel+"ssssssssssss"
            boCustomerServiceInstance.properties = params
            if(params.isFanDian=='0') boCustomerServiceInstance.fanDianAmount=""
            if (!boCustomerServiceInstance.hasErrors() && boCustomerServiceInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boCustomerService.label', default: 'BoCustomerService'), boCustomerServiceInstance.contractNo])}"
                redirect(action: "list", params: params)
            }
            else {
                render(view: "edit", model: [boCustomerServiceInstance: boCustomerServiceInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boCustomerService.label', default: 'BoCustomerService'), params.id])}"
            redirect(action: "list", params: params)
        }
    }

    def delete = {
        def boCustomerServiceInstance = BoCustomerService.get(params.id)
        if (boCustomerServiceInstance) {
            try {
                boCustomerServiceInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boCustomerService.label', default: 'BoCustomerService'), params.id])}"
                redirect(action: "list", params: params)
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boCustomerService.label', default: 'BoCustomerService'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boCustomerService.label', default: 'BoCustomerService'), params.id])}"
            redirect(action: "list", params: params)
        }
    }

    def bankList = {
        def boCustomerServiceInstance = BoCustomerService.get(params.id)
        [bankList: boCustomerServiceInstance.paySrvBanks]
    }

    def updateBankLs = {
        def boCustomerService = BoCustomerService.get(params.id)
        def bankIds = []
        if (params.bank != null) {
            bankIds.addAll(params.bank)
        }
        boCustomerService.paySrvBanks.each {
            it.delete()
        }
        boCustomerService.paySrvBanks.clear();
        boCustomerService.save(flush: true)
        bankIds.each {
            def bank = BoMerchant.load(it)
            def quota = params['quota_' + it]
            quota = (quota && (quota.isInteger() || quota.isDouble())) ? quota.toDouble().intValue() : null
            def paySrvBank = new BoPaySrvBank()
            paySrvBank.bank = bank
            paySrvBank.quota = quota * 100
            boCustomerService.addToPaySrvBanks(paySrvBank)
            paySrvBank.save()
        }
        boCustomerService.save()
        flash.message = "修改成功"
        redirect(action: "list", params: ['customerId': boCustomerService.customerId])
    }


    def channelList={
           def dbismp =  new groovy.sql.Sql(dataSource_ismp)
        def boCustomerServiceInstance = BoCustomerService.get(params.id)

               def b2clistSql = """select t.id,t.acquire_indexc,t.bankid
                          from gwchannel  t
                          where t.acquire_indexc not like '%-%'
                            and t.channel_type ='1'
                            and t.bank_type='1'
                            and t.channel_sts=0"""
           def b2cchannellist =  dbismp.rows(b2clistSql)

           def b2blistSql = """select t.id,t.acquire_indexc,t.bankid
                      from gwchannel  t
                      where t.acquire_indexc not like '%-%'
                        and t.channel_type ='2'
                        and t.bank_type='1'
                        and t.channel_sts=0"""
           def b2bchannellist =  dbismp.rows(b2blistSql)


          def clistSql = """select t.id,t.acquire_indexc,t.bankid
                      from gwchannel  t
                      where t.acquire_indexc not like '%-%'
                         and t.channel_type ='1'
                        and t.bank_type='1'
                        and t.channel_sts=0"""
           def cchannellist =  dbismp.rows(clistSql)

        //查询该客户开通的支付渠道
         def cmChannelList = CmCustomerChannel.findAllByCustomer(CmCustomer.get(boCustomerServiceInstance.customerId));




        [b2cchannellist:b2cchannellist,b2bchannellist:b2bchannellist,cchannellist:cchannellist,cmChannelList:cmChannelList]

    }

    def updateChannelLs = {
        def boCustomerService = BoCustomerService.get(params.id)
        //删除该用户下的所有渠道
         def cmcustlist = CmCustomerChannel.findAllByCustomer(CmCustomer.get(boCustomerService.customerId));
            if(cmcustlist.size()>0){
                 cmcustlist.each {
                        it.delete();
                 }
            }
        def b2cchannelIds = []
        def b2bchannelIds = []
        def cchannelIds = []
        if (params.b2cbank != null) {
            b2cchannelIds.addAll(params.b2cbank)
        }
         if (params.b2bbank != null) {
            b2bchannelIds.addAll(params.b2bbank)
        }
         if (params.cbank != null) {
            cchannelIds.addAll(params.cbank)
        }
        b2cchannelIds.each {
            def cmCustomerChannel = new CmCustomerChannel();
            cmCustomerChannel.customer = CmCustomer.get(boCustomerService.customerId);
            cmCustomerChannel.channelCode = it.toString().toUpperCase();
            cmCustomerChannel.channelType="1";
            cmCustomerChannel.paymentMode="0";
            cmCustomerChannel.paymentType="1";
            cmCustomerChannel.bankType="1";
            cmCustomerChannel.bankCode=it.toString().toUpperCase();
            cmCustomerChannel.save()
        }
         b2bchannelIds.each {
            def cmCustomerChannel = new CmCustomerChannel();
            cmCustomerChannel.customer = CmCustomer.get(boCustomerService.customerId);
            cmCustomerChannel.channelCode = it.toString().toUpperCase();
            cmCustomerChannel.channelType="3";
            cmCustomerChannel.paymentMode="0";
            cmCustomerChannel.paymentType="1";
            cmCustomerChannel.bankType="1";
             if(it.toString().contains("_")){
                   cmCustomerChannel.bankCode=(it.toString().substring(0,it.toString().indexOf("_"))).toUpperCase();
             }else{
                 cmCustomerChannel.bankCode=it;
             }
             cmCustomerChannel.save()
        }

          cchannelIds.each {
            def cmCustomerChannel = new CmCustomerChannel();
            cmCustomerChannel.customer = CmCustomer.get(boCustomerService.customerId);
            cmCustomerChannel.channelCode = it.toString().toUpperCase();
            cmCustomerChannel.channelType="2";
            cmCustomerChannel.paymentMode="0";
            cmCustomerChannel.paymentType="2";
            cmCustomerChannel.bankType="1";
            cmCustomerChannel.bankCode=it.toString().toUpperCase();
             cmCustomerChannel.save()
        }
        flash.message = "分配成功"
         redirect(action: "channelList",params: ['id': boCustomerService.id])
    }
}
