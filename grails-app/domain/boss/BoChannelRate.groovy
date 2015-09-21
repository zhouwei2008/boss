
package boss

class BoChannelRate {
    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_bo_channelrate']
    }
    Long merchantId
    //手续费类型：0 按笔收（元） 1 按费率收（%）
    String feeType
    //费率
    Double feeRate
    //是否退手续费：0 不退 1 全部金额退完后退全额手续费 2 退手续费：实际退款金额=申请退款金额*（1+费率）
    String isRefundFee
    //当前是否可用
    Boolean isCurrent = true

    static constraints = {
        feeType(size: 1..5, nullable: true)
        feeRate(nullable: true)
        isRefundFee(size: 1..5, nullable: true)
        isCurrent()
    }
    def static feeTypeMap = ['0': '按笔收（元）', '1': '按费率收（%）']
    def static isRefundFeeMap = ['0': '不退', '1': '全部金额退完后退全额手续费']
    def static isRefundFeeMap2 = ['0': '不退', '1': '全部金额退完后退全额手续费', '2':'退手续费：实际退款金额=申请退款金额*（1+费率）']
}
