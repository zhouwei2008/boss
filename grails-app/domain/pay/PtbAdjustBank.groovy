package pay

class PtbAdjustBank {
     static mapping = {
        table 'TB_ADJUST_BANK'
        version false
        id generator: 'sequence', params: [sequence: 'SEQ_ADJUST_BANK'], column:'ID'
     }

     String bankCode
     String bankNames
     String bankAuthorityname
     String tradeType
     String bankType
     def static BankTypeMap = ['TH':'第三方','SD': '标准']
}
