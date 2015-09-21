package gateway

class Gwlogistic {
    String recname
    String recpid
    String recphone
    String recaddr
    String recmphone

    String recpost
    String deliver
    String delivertime
    String delivers
    Date createdate

    String gwordersId

    static constraints = {

    }

    static mapping = {
        table 'gwlogistic'
        cache usage: 'read-only'
        version false
        id generator: 'assigned', type: 'long'
        gwordersId           column: 'GWORDERS_ID'
        recname     column: 'RECNAME'
        recpid       column: 'RECPID'
        recphone        column: 'RECPHONE'

        recaddr           column: 'RECADDR'
        recmphone     column: 'RECMPHONE'
        recpost       column: 'RECPOST'
        deliver        column: 'DELIVER'
        delivertime        column: 'DELIVERTIME'

        delivers        column: 'DELIVERS'
        createdate        column: 'CREATEDATE'
    }
}
