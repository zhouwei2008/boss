package ismp

class WithdrawnBatch {

    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator', params: [sequence_name: 'seq_withdrawn_batch', initial_value: 1000000])
//        version false
    }
    //批次笔数
    String batchCount
    //批次金额
    Long batchAmount
    //提现初审时间
    Date withdrawnDate
    //提现银行名称
    String withdrawnBankName
    //提现银行编号
    String withdrawnBankCode
    //批次状态
    String status
    //初审人名称
    String appName
    //初审人id
    String appId

    static constraints = {
        withdrawnBankCode nullable: true
        withdrawnBankName nullable: true
    }
    def static statusMap = ['waiting':'处理中','approved':'初审通过','refused':'初审拒绝']
}
