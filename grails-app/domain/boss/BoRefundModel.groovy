package boss

class BoRefundModel {
    String refundModel
    String payModel
    String customerServerId
    //转账审核模式的开启、关闭
    String transferModel
    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_bo_refund_model']
    }

    static constraints = {
        refundModel(maxSize: 32,nullable:true, inList: ['recheck', 'payPassword'])
        payModel(maxSize: 32,nullable:true,inList: ['no_merge', 'merge'])
    }

    def static refundModelMap = ['recheck': '商户审核', 'payPassword': '支付密码']
    def static payModelMap = ['no_merge': '非合单支付', 'merge': '合单支付']
    def static transferModelMap=['open':'开启','close':'关闭']
}