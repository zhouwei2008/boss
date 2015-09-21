package ismp

class AcquireSynResult {

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

    /*对账开始时间*/
    Date synDateFrom
    /*对账结束时间*/
    Date synDateTo

    /*文件上传时间*/
    Date createDate

     /*对账成功笔数*/
     Long successNum=0
    /*对账成功金额*/
     Long successAmount=0
    /*短款笔数*/
     Long shortNum=0
    /*短款金额*/
     Long shortAmount=0
    /*长款笔数*/
     Long overNum=0
    /*长款金额*/
     Long overAmount=0

    /*差异笔数*/
     Long disNum=0
     /*差异金额*/
     Long disAmount=0

     /*其他笔数*/
     Long otherNum=0
    /*其他金额*/
     Long otherAmount=0

    /*对账人*/
     String synOp
     /*对账批次号*/
     String batchnum




    static constraints = {
        bankAccountNo(maxSize:1000,nullable:true)
        acquireMerchant(maxSize:1000,nullable:true)
        serviceCode(maxSize:2000)
        acquireCode(nullable:true)
        successNum(nullable:true)
        successAmount(nullable:true)
        shortNum(nullable:true)
        shortAmount(nullable:true)
        overNum(nullable:true)
        overAmount(nullable:true)
        disNum(nullable:true)
        disAmount(nullable:true)
        otherNum(nullable:true)
        otherAmount(nullable:true)
    }

    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_acquire_syn_result']
    }
}

