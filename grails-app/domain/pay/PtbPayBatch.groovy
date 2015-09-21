package pay

class PtbPayBatch {
    static mapping = {
        table 'TB_PAY_BATCH'
         version false
        id generator: 'sequence', params: [sequence: 'SEQ_PAY_BATCH'], column:'BATCH_ID'
    }
    Date batchDate
    Integer batchCount
    Double batchAmount
    //打款渠道系统编码（与自动打款接口实现多对一）
    String batchChanelsyscode
    String batchChanelaccountno
    Integer batchChanel
    String batchChanelname
    //打款状态:0 等待打款  1 已发送银行 2 对账完毕
    String batchStatus
    //收付标识: 收S，付F
    String batchType
    //打款方式: 手工handle,自动auto
    String batchStyle
    Date batchDonedate
    String batchNote


    static constraints = {
        batchDonedate(nullable:true)
        batchNote(nullable:true)

    }
    def static BatchStatusMap= ['0':'等待打款','1': '已发送银行','2': '对账完毕']
    def static BatchTypeMap= ['S':'收款','F': '付款']
    def static BatchStyleMap= ['handle':'手工','auto': '自动']
}
