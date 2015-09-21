package settle

import groovyx.net.http.ContentType
import groovyx.net.http.HTTPBuilder
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import static groovyx.net.http.ContentType.JSON
import static groovyx.net.http.Method.POST
import settle.FtTradeFee

class FtTradeFeeService {

    static transactional = true
    def accountClientService

    def createTradeFee(def sql, FtTradeFeeStep ftTradeFeeInstance) {

        if (ftTradeFeeInstance.feeType == 2) {
            def msg = createFtFoot(sql, ftTradeFeeInstance)
            if (!msg) {
                return ''
            } else {
                return msg
            }
        } else {
            if (ftTradeFeeInstance.save(flush: true, failOnError: true)) {
                return ''
            } else {
                return '费率创建失败'
            }
        }
    }

  //生成结算单
    def createFtFoot(def sql, FtTradeFeeStep ftTradeFeeInstance) {

        //查询商户服务手续费账户
        def serFeeAcc = ''
        def customerId = ismp.CmCustomer.findByCustomerNo(ftTradeFeeInstance.customerNo).id
        def serCode = FtSrvType.findById(ftTradeFeeInstance.srv.id).srvCode
        def query = {
            eq('customerId', customerId)
            eq('serviceCode', serCode)
            eq('isCurrent', true)
            eq('enable', true)
        }

        def cusSer = boss.BoCustomerService.createCriteria().list(query)
        if (cusSer) {
            serFeeAcc = cusSer[0].feeAccNo
        } else {
            return '该服务目前停用，没有可用服务账户，无法设定费率'
        }
        //查询系统应收手续费账户
        def sysFeeAdvAcc = boss.BoInnerAccount.findByKey('feeInAdvance').accountNo

        /** 预收手续费转账
         *  由商户服务手续费账户转到平台收费账户
         *  生成后返结算单
         */
        def cmdList = null
        Random random = new Random()
        def seqNo = 101202170030000 + Math.abs(random.nextInt()%10000)
        cmdList = accountClientService.buildTransfer(cmdList, serFeeAcc, sysFeeAdvAcc, (ftTradeFeeInstance.feePre as Double)*100 as Long, 'fee',seqNo, '0', "包流量预付手续费")

        boolean redo = false
        try {
            def transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
            if (transResult.result != 'true') {
                log.warn("实时转账失败，错误码：${transResult.errorCode},错误信息：${transResult.errorMsg},cmdList:${cmdList}")
                //帐户余额不足或者账务系统故障需要重新转账
                if (transResult.errorCode == '03' || transResult.errorCode == 'ff') {
                  redo = true
                  return '费率创建失败'
                }
            }
        } catch (Exception e) {
            log.warn("balance trans faile,cmdList:${cmdList}", e)
            redo = true
            return '费率创建失败'
        }

        if (!redo) {

            def seq = sql.firstRow('select seq_foot.nextval from dual').nextval.toString()
            if (seq.length() > 5) {
                seq = seq.substring(seq.length() - 5, seq.length() - 1)
            } else {
                seq = seq.padLeft(5, '0')
            }

            def footNo = 'A' + new Date().format('yyyyMMddHHmmss') + seq
            def foot = new FtFoot()
            foot.srvCode = serCode
            foot.tradeCode = FtSrvTradeType.findById(ftTradeFeeInstance.tradeType.id).tradeCode
            foot.customerNo = ftTradeFeeInstance.customerNo
            foot.type = 0
            foot.feeType = 2
            foot.preFee = 0
            foot.postFee = (ftTradeFeeInstance.feePre as Double)*100 as Long
            foot.transNum = 1
            foot.amount = 0l
            foot.footNo = footNo
            foot.footDate = new Date()
            foot.checkStatus = 0
            foot.freezeAmount = 0l
            foot.autoCheck = 0
            foot.autoWithdraw = 0
            foot.withdraw = 0
            if (foot.save()) {
                // 关联结算单号
                ftTradeFeeInstance.footNo = footNo
                if (ftTradeFeeInstance.save()) {
                    return ''
                } else {
                    return '费率创建或更新失败'
                }
            }
        }
    }
}
