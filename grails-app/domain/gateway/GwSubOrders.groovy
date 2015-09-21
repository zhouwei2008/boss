package gateway

class GwSubOrders {
    String  id
    String gwordersid
    String outtradeno
    String seller_name
    String seller_custno
    String seller_code
    String seller_ext
    Long amount
    Date createdate

    static constraints = {
        id(maxSize: 16)
        gwordersid(maxSize: 16)
        outtradeno(maxSize: 64)
        seller_name(maxSize: 128,nullable:true)
        seller_custno(maxSize: 18)
        seller_code(maxSize: 128)
        seller_ext(maxSize: 256,nullable:true)
        //amount()
        //createdate()
    }

    static mapping = {
        table 'gwsuborders'
        cache   usage: 'read-only'
        version false
        id  generator:'assigned', type: 'string'
    }
}