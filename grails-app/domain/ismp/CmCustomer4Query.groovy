package ismp

class CmCustomer4Query {
    String  name
    String  customerNo
    String  type
    String  status = 'init'
    String  apiKey
    String  accountNo
    Date    dateCreated
    Date    lastUpdated

    static constraints = {}

    static mapping = {
        table   'cm_customer'
        cache   usage: 'read-only'
        version false
    }
}
