package ismp

class ChannelRouteByAmount {

    String bankCode//银行code
    String cardType  //卡类型（2:借记卡；1;贷记卡）
    String amountStart  //起始额度
    String channel1 //渠道1
    String amountEnd   //结束额度
    String channel2
    String channel3
    Date createTime
    Date updateTime
    String opName

    static constraints = {
        amountEnd(maxSize:16,nullable:true)
        channel2(maxSize:16,nullable:true)
        channel3(maxSize:16,nullable:true)
    }
    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_channel_route_by_amount']
    }
     static cardTypeMap=['2': '借记卡', '1': '贷记卡']
}
