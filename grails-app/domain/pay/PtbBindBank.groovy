package pay

class PtbBindBank {
    static mapping = {
        table 'TB_BIND_BANK'
         version false

         id generator: 'sequence', params: [sequence: 'SEQ_BIND_BANK'], column:'ID'

    }
     String type
     String bankAccountno
     String note
     static constraints = {
         type(size:1..2,nullable:false)
         bankAccountno(size:1..32,nullable:false)
         note(size:1..100,nullable:true)
     }
     def static ServerTypeMap = ['S':'收款','F': '付款']
}
