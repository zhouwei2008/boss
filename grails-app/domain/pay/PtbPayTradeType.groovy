package pay

class PtbPayTradeType {
    static mapping = {
        table 'TB_PAY_TRADETYPE'
         version false
         id generator: 'sequence', params: [sequence: 'SEQ_PAY_TRADETYPE'], column:'ID'
    }
     String payCode
     String payName
     String payType
     String note

     static constraints = {
         payCode(size:1..10,nullable:false)
         payName(size:1..50,nullable:false)
         payType(size:1..2,nullable:false)
         note(size:1..100,nullable:true)
     }
     def static PayTypeMap = ['S':'收款','F': '付款']

}
