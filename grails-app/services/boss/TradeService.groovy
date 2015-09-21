package boss

import ismp.TradeBase
import ismp.TradeWithdrawn
import ismp.TradePayment
import account.AcAccount
import net.sf.json.JSONObject
import ismp.CmCustomer
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class TradeService {

    static transactional = true

    def accountClientService

    def dataSource_boss
    def dataSource_account
    def dataSource_ismp
    def mobileCustomerNo = ConfigurationHolder.config.mobile.customerNo
    //提现审核

    def checkWithDraw(tradeWithdrawnInstance, flag) throws Exception {
        tradeWithdrawnInstance.handleCommandNo = UUID.randomUUID().toString().replaceAll('-', '')
        def cmdList = null
        //提现
        if ("1".equals(flag)) {
            cmdList = accountClientService.buildTransfer(cmdList, tradeWithdrawnInstance.payeeAccountNo, tradeWithdrawnInstance.payerAccountNo, tradeWithdrawnInstance.amount, 'withdrawnRef', tradeWithdrawnInstance.tradeNo ? tradeWithdrawnInstance.tradeNo : '0', tradeWithdrawnInstance.outTradeNo ? tradeWithdrawnInstance.outTradeNo : '0', '审批拒绝')
        } else if ("2".equals(flag)) {
            cmdList = accountClientService.buildTransfer(cmdList, tradeWithdrawnInstance.payeeAccountNo, tradeWithdrawnInstance.payerAccountNo, tradeWithdrawnInstance.amount, 'withdrawnRef', tradeWithdrawnInstance.tradeNo ? tradeWithdrawnInstance.tradeNo : '0', tradeWithdrawnInstance.outTradeNo ? tradeWithdrawnInstance.outTradeNo : '0', '复核拒绝')
        } else {
            //如果系统手续费不为空，转出系统手续费
            if (tradeWithdrawnInstance.transferFee) {
                //获得系统手续费账户
                def sysFeeAccount = BoInnerAccount.findByKey('feeAcc').accountNo
                //转银行转账手续费
                cmdList = accountClientService.buildTransfer(null, tradeWithdrawnInstance.payeeAccountNo, sysFeeAccount, tradeWithdrawnInstance.transferFee, 'withdrawn', tradeWithdrawnInstance.tradeNo ? tradeWithdrawnInstance.tradeNo : '0', tradeWithdrawnInstance.outTradeNo ? tradeWithdrawnInstance.outTradeNo : '0', '提现转账手续费')
            }
            def ba = BoAcquirerAccount.get(tradeWithdrawnInstance.acquirerAccountId)
            if (ba == null) {
                throw new Exception("银行账户不存在")
            }
            cmdList = accountClientService.buildTransfer(cmdList, tradeWithdrawnInstance.payeeAccountNo, ba.innerAcountNo, tradeWithdrawnInstance.realTransferAmount, 'withdrawn', tradeWithdrawnInstance.tradeNo ? tradeWithdrawnInstance.tradeNo : '0', tradeWithdrawnInstance.outTradeNo ? tradeWithdrawnInstance.outTradeNo : '0', '提现转账')
        }

        def transResult = accountClientService.batchCommand(tradeWithdrawnInstance.handleCommandNo, cmdList)
        if ("1".equals(flag)) {
            if (transResult.result == 'true') {
                tradeWithdrawnInstance.handleStatus = 'sRefuse'
                tradeWithdrawnInstance.status = 'closed'
                tradeWithdrawnInstance.lastAppDate = new Date()
                tradeWithdrawnInstance.save(flush: true, failOnError: true)
            }
            else {
                throw new RuntimeException("账务系统转账失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}")
            }
        } else if ("2".equals(flag)) {
            if (transResult.result == 'true') {
                tradeWithdrawnInstance.handleStatus = 'refFail'
                tradeWithdrawnInstance.status = 'closed'
                tradeWithdrawnInstance.withReHandleDate = new Date()
                tradeWithdrawnInstance.handleTime=new Date()
                tradeWithdrawnInstance.save(flush: true, failOnError: true)
            }
            else {
                throw new RuntimeException("账务系统转账失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}")
            }
        } else {
            if (transResult.result == 'true') {
                tradeWithdrawnInstance.handleStatus = 'completed'
                tradeWithdrawnInstance.status = 'completed'
                tradeWithdrawnInstance.withReHandleDate = new Date()
                tradeWithdrawnInstance.handleTime=new Date()
                tradeWithdrawnInstance.save(flush: true, failOnError: true)
            }
            else {
                throw new RuntimeException("账务系统转账失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}")
            }
        }

    }

    //根据服务账户得到现金账户   by hbin-yu@hnair.com
    def getCurrencyAccount(ServiceAccount) throws Exception {
        def conBoss = dataSource_boss.getConnection()
        def dbBoss =  new groovy.sql.Sql(conBoss)

        def conIsmp = dataSource_ismp.getConnection()
        def dbIsmp =  new groovy.sql.Sql(conIsmp)

        def accSql = ""

        //如果是服务账户, 取得其现金账户
        accSql = "Select CUSTOMER_ID From BO_CUSTOMER_SERVICE Where SRV_ACC_NO=?"
        def cus_id_list = dbBoss.rows(accSql, [ServiceAccount])
        if(cus_id_list.size() > 0){
            def cus_id = cus_id_list.get(0).CUSTOMER_ID
            accSql = "Select ACCOUNT_NO From CM_CUSTOMER Where ID=?"
            def acc_cur_list = dbIsmp.rows(accSql, [cus_id])
            if(acc_cur_list.size()>0){
                return acc_cur_list.get(0).ACCOUNT_NO
            }else{
                //取不到现金账户
                return ServiceAccount
            }
        }else{
            //非服务账户
            return ServiceAccount
        }
    }
    //根据trade_no得到需返还手续费金额 by hbin-yu@hnair.com 2012年7月13日
    def getBackFeeByTradeNo(tradeNo) {
        try{
            //账务系统连接信息
            def dbAccount =  new groovy.sql.Sql(dataSource_account.getConnection())
            def accSql = "Select AMOUNT From AC_TRANSACTION Where TRADE_NO=? And TRANSFER_TYPE='fee'"
            def rtn_rows = dbAccount.rows(accSql, [tradeNo])
            def fee = 0
            if(rtn_rows.size()>0){
                //有手续费, 返回手续费值
                fee = rtn_rows.get(0).AMOUNT
            }else{
                //无手续费, 返回0
                fee = 0
            }
            return fee
        }catch (Exception e){
            throw new RuntimeException("获取手续费信息失败，错误信息：${e.message}")
        }
    }

    //退款审核
    def checkRefund(tradeRefundInstance, tradeRefund, flag, sign, label,royalty) throws Exception {
//        log.error(tradeRefundInstance.tradeNo)
//        log.error(getBackFeeByTradeNo(tradeRefundInstance.tradeNo))
//                      return
        def cmdList = null
        def payfeeId
        //获得系统手续费账户
        def sysFeeAccount = BoInnerAccount.findByKey('feeAcc').accountNo
        tradeRefundInstance.handleCommandNo = UUID.randomUUID().toString().replaceAll('-', '')
        if (sign == 1 || sign==2) {
            def customerService = BoCustomerService.find(
                    "from BoCustomerService where customerId=? and serviceCode=? and enable=true and isCurrent=true",
                    [tradeRefundInstance.partnerId, 'royalty'])
            if (!customerService) {
                throw new Exception("合作伙伴商户号不存在！")
            } else {
                def serviceParams = JSONObject.fromObject(customerService.serviceParams)
                //手续费承担商户号  例如：“100000000000033”
                def payfeeCusno = serviceParams.payfee_customer_no
                if (!payfeeCusno) {
                    throw new Exception("尚未设置手续费账户！")
                }
                payfeeId = CmCustomer.findWhere(customerNo: payfeeCusno, status: 'normal', type: 'C')
            }
        }
        //初审拒绝
        if (flag == 1) {
            //sign 为1是分润退款审批
            if (sign == 1) {
                //支出中间账户退款给实时分润账户
                if (label == 1 && (tradeRefundInstance.amount != 0 && tradeRefundInstance.amount != null)) {
                    cmdList = accountClientService.buildTransfer(null, tradeRefundInstance.payeeAccountNo, tradeRefundInstance.payerAccountNo, tradeRefundInstance.amount, 'refundRef', tradeRefundInstance.tradeNo ? tradeRefundInstance.tradeNo : '0', tradeRefundInstance.outTradeNo ? tradeRefundInstance.outTradeNo : '0', '分润初审拒绝')
                } else if (label == 0 && (tradeRefund.amount != null && tradeRefund.amount != 0)) {   //实时分润账户退款给分润账户
                    cmdList = accountClientService.buildTransfer(null, tradeRefund.payeeAccountNo, tradeRefund.payerAccountNo, tradeRefund.amount, 'refundRef', tradeRefund.tradeNo ? tradeRefund.tradeNo : '0', tradeRefund.outTradeNo ? tradeRefund.outTradeNo : '0', '分润初审拒绝')
                    //如果是手续费账户，再由手续费账户退款给rongpay
                    //垫付中，payerAccountNo发生改变，要根据payerId进行查询
                    def payerAccountNo=CmCustomer.get(tradeRefund.payerId)?.accountNo
                    if (payfeeId.accountNo == payerAccountNo && (tradeRefundInstance.backFee != 0 && tradeRefundInstance.backFee != null)) {
                        cmdList = accountClientService.buildTransfer(cmdList, payerAccountNo, sysFeeAccount, tradeRefundInstance.backFee, 'fee', tradeRefundInstance.tradeNo ? tradeRefundInstance.tradeNo : '0', tradeRefundInstance.outTradeNo ? tradeRefundInstance.outTradeNo : '0', '分润退款手续费返还取消')
                    }
                }
            } else {
                //得到返还手续费金额
                def backFee = getBackFeeByTradeNo(tradeRefundInstance.tradeNo)

                //返还商户款
                if (tradeRefundInstance.amount != 0 && tradeRefundInstance.amount != null) {

                    def refundAcc = getCurrencyAccount(tradeRefundInstance.payerAccountNo)

                     cmdList = accountClientService.buildTransfer(null, tradeRefundInstance.payeeAccountNo, refundAcc,
                             tradeRefundInstance.amount - backFee, 'refundRef', tradeRefundInstance.tradeNo ? tradeRefundInstance.tradeNo : '0',
                             tradeRefundInstance.outTradeNo ? tradeRefundInstance.outTradeNo : '0', '退款失败')

                }
                //退还手续费拒绝
                //if (tradeRefundInstance.backFee != 0 && tradeRefundInstance.backFee != null)
                if (backFee !=0)
                    cmdList = accountClientService.buildTransfer(cmdList, tradeRefundInstance.payeeAccountNo/*payerAccountNo*/, sysFeeAccount,
                            /*tradeRefundInstance.*/backFee, 'fee', tradeRefundInstance.tradeNo ? tradeRefundInstance.tradeNo : '0',
                            tradeRefundInstance.outTradeNo ? tradeRefundInstance.outTradeNo : '0', '退款手续费返还取消')
            }
        } else if (flag == 2) {    // 终审拒绝
            if (sign == 2) {
                if (label == 2 && (tradeRefundInstance.amount != 0 && tradeRefundInstance.amount != null)) {
                    cmdList = accountClientService.buildTransfer(null, tradeRefundInstance.payeeAccountNo, tradeRefundInstance.payerAccountNo, tradeRefundInstance.amount, 'refundRef', tradeRefundInstance.tradeNo ? tradeRefundInstance.tradeNo : '0', tradeRefundInstance.outTradeNo ? tradeRefundInstance.outTradeNo : '0', '分润终审拒绝')
                } else if (label == 0 && (tradeRefund.amount != 0 && tradeRefund.amount != null)) {
                    cmdList = accountClientService.buildTransfer(null, tradeRefund.payeeAccountNo, tradeRefund.payerAccountNo, tradeRefund.amount, 'refundRef', tradeRefund.tradeNo ? tradeRefund.tradeNo : '0', tradeRefund.outTradeNo ? tradeRefund.outTradeNo : '0', '分润终审拒绝')
                    //如果是手续费账户，再由手续费账户退款给rongpay
                    if (payfeeId.accountNo == tradeRefund.payerAccountNo && (tradeRefundInstance.backFee != 0 && tradeRefundInstance.backFee != null)) {
                        cmdList = accountClientService.buildTransfer(cmdList, tradeRefund.payerAccountNo, sysFeeAccount, tradeRefundInstance.backFee, 'fee', tradeRefundInstance.tradeNo ? tradeRefundInstance.tradeNo : '0', tradeRefundInstance.outTradeNo ? tradeRefundInstance.outTradeNo : '0', '分润退款终审手续费返还取消')
                    }
                }

            } else {
                //得到返还手续费金额
                def backFee = getBackFeeByTradeNo(tradeRefundInstance.tradeNo)

                //退还商户款
                if (tradeRefundInstance.amount != 0 && tradeRefundInstance.amount != null) {
                    def refundAcc = getCurrencyAccount(tradeRefundInstance.payerAccountNo)
                    cmdList = accountClientService.buildTransfer(null, tradeRefundInstance.payeeAccountNo, refundAcc,
                            tradeRefundInstance.amount - backFee, 'refundRef', tradeRefundInstance.tradeNo ? tradeRefundInstance.tradeNo : '0',
                            tradeRefundInstance.outTradeNo ? tradeRefundInstance.outTradeNo : '0', '终审拒绝')
                }
                //退还手续费拒绝
                if (backFee > 0){//(tradeRefundInstance.backFee != 0 && tradeRefundInstance.backFee != null) {
                    cmdList = accountClientService.buildTransfer(cmdList, tradeRefundInstance.payeeAccountNo/*payerAccountNo*/, sysFeeAccount,
                            /*tradeRefundInstance.*/backFee, 'fee', tradeRefundInstance.tradeNo ? tradeRefundInstance.tradeNo : '0',
                            tradeRefundInstance.outTradeNo ? tradeRefundInstance.outTradeNo : '0', '退款手续费返还取消')
                }
            }

        } //审批通过
        else {
            def ba = BoAcquirerAccount.get(tradeRefundInstance.acquirer_account_id)
            if (ba == null) {
                throw new Exception("银行账户不存在")
            }

            CmCustomer cmCustomer = CmCustomer.get(tradeRefundInstance.partnerId)
            if(cmCustomer&&cmCustomer.customerNo == mobileCustomerNo){
                def innerAcc=BoInnerAccount.findByKey("middleAcc")
                TradeBase tradeBase = TradeBase.get(tradeRefundInstance.originalId)
                cmdList = accountClientService.buildTransfer(null, innerAcc.accountNo, tradeBase.payerAccountNo, tradeRefundInstance.amount, 'refund', tradeRefundInstance.tradeNo ? tradeRefundInstance.tradeNo : '0', tradeRefundInstance.outTradeNo ? tradeRefundInstance.outTradeNo : '0', '退款转账')
            }else{
                if(label==0 && tradeRefund.amount != 0 && tradeRefund.amount != null) {
                    cmdList = accountClientService.buildTransfer(null, tradeRefund.payeeAccountNo, tradeRefund.payerAccountNo, tradeRefund.amount, 'transfer', tradeRefundInstance.tradeNo ? tradeRefundInstance.tradeNo : '0', tradeRefundInstance.outTradeNo ? tradeRefundInstance.outTradeNo : '0', '退款转账结余')
                }else if (tradeRefundInstance.amount != 0 && tradeRefundInstance.amount != null) {
                    cmdList = accountClientService.buildTransfer(null, tradeRefundInstance.payeeAccountNo, ba.innerAcountNo, tradeRefundInstance.amount, 'refund', tradeRefundInstance.tradeNo ? tradeRefundInstance.tradeNo : '0', tradeRefundInstance.outTradeNo ? tradeRefundInstance.outTradeNo : '0', '退款转账')
                }
            }
        }
        def transResult = accountClientService.batchCommand(tradeRefundInstance.handleCommandNo, cmdList)
        if (flag == 1) {
            if (transResult.result == 'true') {
                if(royalty!=''){
                   tradeRefundInstance.handleStatus = 'fRefuse'
                } else{
                    tradeRefundInstance.handleStatus = 'refFail'
                }
                //def tradePayment = new TradePayment()
                //原单交易
                //def tradeBase = new TradeBase()
                //def tradeBase = TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId, 'payment')
                //通过originalId查找 tradePayment表中数据
                def tradePayment = TradePayment.get(tradeRefundInstance.originalId)
                def money
                //修改tradePayment表中的退款金额
                if (tradePayment != null) {
                    money = tradePayment.refundAmount - tradeRefundInstance.amount
                    tradePayment.refundAmount = money
                    //tradePayment.save(flush: true, failOnError: true)
                } else {
                    throw new RuntimeException("支付交易不存在！")
                }
                tradeRefundInstance.status = 'closed'
//                if (tradePayment.amount-tradePayment.refundAmount == 0) {
//                    tradePayment.status = 'closed'
//                }
                if (tradePayment.amount - tradePayment.refundAmount > 0) {
                    tradePayment.status = 'completed'
                }
//                tradeRefundInstance.status = 'completed'
                tradeRefundInstance.refundRecheckDate = new Date()
                def tradeBase = TradeBase.findAllByOriginalIdAndStatus(tradeRefundInstance.id, 'completed')
                if (tradeBase.size() > 0) {
                    tradeBase.each {
                        it.status = 'closed'

                        it.save(flush: true, failOnError: true)
                    }
                }
                tradePayment.save(flush: true, failOnError: true)
                tradeRefundInstance.save(flush: true, failOnError: true)
            } else {
                throw new RuntimeException("账务系统转账失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}")
            }
        } else if (flag == 2) {
            if (transResult.result == 'true') {
                tradeRefundInstance.handleStatus = 'sRefuse'
                //def tradePayment = new TradePayment()
                //原单交易
                //def tradeBase = new TradeBase()
                //def tradeBase = TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId, 'payment')
                //通过originalId查找 tradePayment表中数据
                def tradePayment = TradePayment.get(tradeRefundInstance.originalId)
                def money
                //修改tradePayment表中的退款金额
                if (tradePayment != null) {
                    money = tradePayment.refundAmount - tradeRefundInstance.amount
                    tradePayment.refundAmount = money
                    //tradePayment.save(flush: true, failOnError: true)
                } else {
                    throw new RuntimeException("支付交易不存在！")
                }
                tradeRefundInstance.status = 'closed'

//                if (tradePayment.amount-tradePayment.refundAmount == 0) {
//                    tradePayment.status = 'closed'
//                }
                if (tradePayment.amount - tradePayment.refundAmount > 0) {
                    tradePayment.status = 'completed'
                }
//                tradeRefundInstance.status = 'completed'
                tradeRefundInstance.handleTime = new Date()
                tradePayment.save(flush: true, failOnError: true)
                def tradeBase = TradeBase.findAllByOriginalIdAndStatus(tradeRefundInstance.id, 'completed')
                if (tradeBase.size() > 0) {
                    tradeBase.each {
                        it.status = 'closed'
                        it.save(flush: true, failOnError: true)
                    }
                }
                tradeRefundInstance.save(flush: true, failOnError: true)
            } else {
                throw new RuntimeException("账务系统转账失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}")
            }
        }
        else {
            if (transResult.result == 'true') {
                tradeRefundInstance.handleStatus = 'completed'
                tradeRefundInstance.status = 'completed'
                tradeRefundInstance.refundRecheckDate = new Date()
                tradeRefundInstance.save(flush: true, failOnError: true)
            } else {
                throw new RuntimeException("账务系统转账失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}")
            }
        }
    }

}
