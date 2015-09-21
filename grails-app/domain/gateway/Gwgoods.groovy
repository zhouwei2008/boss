package gateway

class Gwgoods {
//    GWORDERS_ID	VARCHAR2(22 BYTE)	Yes	1	订单流水
    String gwordersId
//    goodid	VARCHAR2(22 BYTE)	Yes	1	订单物品Id
    String goodid
//    goodname	VARCHAR2(4 BYTE)	订单物品
    String goodname
//    counts	NUMBER(2 BYTE)	No	4	订单物品数量
    int counts
//    unitprice	NUMBER(10,2)	No	5	单价
    Long unitprice
//    AMOUNT	NUMBER	No	7	交易金额
    Long amount
//    createdate	Date	创建日期
    String createdate
//    gooddesc	VARCHAR2(20 BYTE)	商品排序
    String gooddesc

    static constraints = {

    }

    static mapping = {
        table 'gwgoods'
        cache usage: 'read-only'
        version false
        id generator: 'assigned', type: 'long'
        gwordersId           column: 'GWORDERS_ID',type:"string"
        goodid     column: 'GOODID'
        goodname       column: 'GOODNAME'
        counts        column: 'COUNTS'
        unitprice   column: 'UNITPRICE'
        amount      column: 'AMOUNT'
        createdate        column: 'CREATEDATE'
        gooddesc        column: 'GOODDESC'
    }
}
