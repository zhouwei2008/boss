package ismp

class TradeAccountCommandSaf {

    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator', params: [sequence_name: 'seq_trade_account_command', initial_value: 1])
    }

    String commandNo
    String  commandType
    Integer subSeqno
    Long    tradeId
    String  tradeNo
    String  outTradeNo
    String  fromAccountNo
    String  toAccountNo
    Long    amount
    String  currency
    String  transferType
    String  redoFlag
    Integer redoCount=0
    Date syncTime
    String syncFlag='F'
    String respCode
    String transCode
    Long transId
    String subject

    static constraints = {
        commandNo(maxSize: 40)
        commandType(maxSize: 16,inList: ['transfer','frozen','unfrozen'])
        subSeqno(nullable: true)
        tradeNo(maxSize: 36)
        outTradeNo(maxSize: 64,nullable: true)
        fromAccountNo(maxSize: 24)
        toAccountNo(maxSize: 24)
        currency(maxSize: 4)
        transferType(maxSize: 16,inList: ['payment','transfer','refund','charge','withdrawn','royalty','royalty_rfd','frozen','unfrozen','fee','fee_rfd'])
        redoFlag(maxSize: 4,inList: ['T','F'],nullable: true)
        syncFlag(maxSize: 1,inList: ['S','F'])
        respCode(maxSize: 4,nullable: true)
        transCode(maxSize: 40,nullable: true)
        transId(nullable: true)
        subject(maxSize: 255,nullable: true)
    }
    def static transferTypeMap = ['payment': '支付', 'transfer': '转账','refund':'退款','charge':'充值','withdrawn':'提现','royalty':'分润','royalty_rfd':'退分润','frozen':'冻结','unfrozen':'解冻结','fee':'手续费','fee_rfd':'退手续费']
    def static accSyncFlagMap = ['S': '同步', 'F': '未同步']
}
