package ismp

class AcquireSynTrx {
    String acquireAuthcode
    String acquireCardnum
    String acquireRefnum
    String acquireSeq
    String payerIp
    /*银行号*/
    String bankCode
    /*银行账户*/
    String bankAccountNo
    /*收单商户号*/
    String acquireMerchant
    /*通道号*/
    String acquireCode
    /*通道服务码*/
    String serviceCode

    /*银行订单号*/
    String trxid
     /*系统流水号*/
    String tradeNum
    /*交易金额 单位：分*/
    Double amount


    /*银行交易时间*/
    Date acquireDate
     /*银行记账时间*/
    Date accountDate
     /*系统交易时间*/
    Date tradeDate
    /*对账开始时间*/
    Date synDateFrom
    /*对账结束时间*/
    Date synDateTo

    /*文件上传时间*/
    Date createDate

    /*对账批次号*/
    String batchnum
     /*银行交易状态 (0:'进行中',1:'完成',2:'失败',3:'关闭')*/
    Integer trxsts
    /*对账结果：0:'对账成功'，1:'长款'，2:'短款', 3:'差异',4:'其他'*/
    Integer synSts=4

    /*网关交易金额 单位：元*/
    Double tradeAmount
    /*网关交易状态 (0:'进行中',1:'完成',2:'失败',3:'关闭')*/
    Integer tradeTrxsts

            /*交易手续费 单位：元*/
        Double tradeFee;

        /*银行手续费*/
       Double fee;

    /*备注*/
    String remarks



    static constraints = {
        acquireAuthcode(nullable:true)
        acquireCardnum(nullable:true)
        acquireRefnum(nullable:true)
        acquireSeq(nullable:true)
        payerIp(nullable:true)
        bankAccountNo(maxSize:1000,nullable:true)
        acquireMerchant(maxSize:1000,nullable:true)
        serviceCode(maxSize:2000)
        acquireCode(nullable:true)
        acquireDate(nullable:true)
        accountDate(nullable:true)
        tradeDate(nullable:true)
        tradeNum(nullable:true)
        remarks(maxSize:3000,nullable:true)
        tradeAmount(nullable:true)
                    tradeFee(nullable:true)
            fee(nullable:true)
        tradeTrxsts(nullable:true)
        amount(nullable:true)
        trxsts(nullable:true)
    }
    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_acquire_syn_trx']
    }
    static   trxstsMap=[0:'进行中',1:'完成',2:'失败',3:'关闭']
    static   synStsMap=[0:'成功',1:'长款',2:'短款',3:'差异',4:'其他',5:'已备注']
}
