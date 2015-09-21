package boss

import ismp.TradeBase
import java.text.SimpleDateFormat
import java.text.DateFormat

class OffineRechargeService {

    static transactional = true
    def accountClientService

    def charge(tradeBase,boOfflineCharge) {
        def resultmsg="TRADE_SUCCESS"
        if (boOfflineCharge.authsts == 'N') {//如果未审核过则如下:
            //查询付款账户
             def  bomer = BoMerchant.findAllByAcquireIndexc('BCARD')
             def  innerAccount
             if(bomer!=null&&bomer.size()>0){
                 def acq = bomer[0].acquirerAccount
                 if(acq!=null){
                     innerAccount = acq.innerAcountNo
                 }
             }
              //修改订单状态等信息
              boOfflineCharge.status = "Y"
              boOfflineCharge.authsts = "Y"
             if( !boOfflineCharge.save() ) {
                boOfflineCharge.errors.each {ee->
                    println ee
                }
                resultmsg = "TRADE_FALSE"
               throw new ReChargeExcepiton(resultmsg);
            }
            //账户充值
            def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
            def cmdList = accountClientService.buildTransfer(null,innerAccount, boOfflineCharge.accountNo, boOfflineCharge.amount.toBigDecimal(), 'charge', '0', boOfflineCharge.trxSeq, "充值户充值，${boOfflineCharge.authdesc}".toString())
            def transResult = accountClientService.batchCommand(commandNo, cmdList)
            if (transResult.result == 'true') {

                tradeBase.status='completed'
                tradeBase.save(flush: true)
                 resultmsg="TRADE_SUCCESS"
            } else {
                resultmsg="错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}"
                tradeBase.status='faild'
                tradeBase.save(flush: true)
                throw new ReChargeExcepiton(resultmsg);
            }
             return resultmsg;
        }
    }
      def voids(tradeBase,boOfflineCharge) {
        def resultmsg="TRADE_SUCCESS"
        if (boOfflineCharge.authsts == 'N') {//如果未审核过则如下:
            //查询付款账户
             def  bomer = BoMerchant.findAllByAcquireIndexc('BCARD')
             def  innerAccount
             if(bomer!=null&&bomer.size()>0){
                def   acq = bomer[0].acquirerAccount
                 if(acq!=null){
                     innerAccount = acq.innerAcountNo
                 }
             }
              //修改订单状态等信息
              boOfflineCharge.status = "Y"
              boOfflineCharge.authsts = "Y"
             if( !boOfflineCharge.save() ) {
                boOfflineCharge.errors.each {ee->
                    println ee
                }
                resultmsg = "TRADE_FALSE"
               throw new ReChargeExcepiton(resultmsg);
            }
            //账户充值
            def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
            def cmdList = accountClientService.buildTransfer(null, boOfflineCharge.accountNo,innerAccount,boOfflineCharge.amount.toBigDecimal(), 'void', '0', boOfflineCharge.trxSeq, "充值户充值撤销，${boOfflineCharge.authdesc}".toString())
            def transResult = accountClientService.batchCommand(commandNo, cmdList)
            if (transResult.result == 'true') {

                tradeBase.status='completed'
                tradeBase.save(flush: true)
                 resultmsg="TRADE_SUCCESS"
            } else {
                resultmsg="错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}"
                tradeBase.status='faild'
                tradeBase.save(flush: true)
                throw new ReChargeExcepiton(resultmsg);
            }
             return resultmsg;
        }
    }
}

