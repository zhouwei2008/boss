package gateway

class Gwlgoptions {
//    LOGISTICS_TYPE	VARCHAR2(22 BYTE)	Yes	1	物流方式
    String logicticsType
//    LOGISTICS_FEE	VARCHAR2(22 BYTE)	Yes	1	物流费用
    String logicticsFee
//    LOGISTICS_PAYMENT	VARCHAR2(4 BYTE)	物流支付方式
    String logicticsPayment
//    CREATEDATE	NUMBER(2 BYTE)	No	4	创建时间
    Date createdate
//    GWORDERS_ID	NUMBER(10,2)	No	5	订单Id
    Long gwordersId


    static constraints = {

    }

    static mapping = {
        table 'gwlgoptions'
        cache usage: 'read-only'
        version false
        id generator: 'assigned', type: 'long'
        gwordersId           column: 'GWORDERS_ID'
        logicticsType     column: 'LOGISTICS_TYPE'
        logicticsFee       column: 'LOGISTICS_FEE'
        logicticsPayment        column: 'LOGISTICS_PAYMENT'
        createdate        column: 'CREATEDATE'
    }
}
