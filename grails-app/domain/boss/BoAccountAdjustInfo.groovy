package boss

class BoAccountAdjustInfo {

    static mapping = {
         id generator: 'sequence', params: [sequence: 'seq_ac_account_adjust']
    }
    String fromAccountNo
    String toAccountNo
    Double adjustAmount
    String remark
    String status
    Date approveTime
    String approvePerson
    String approveView
    String sponsor
    String sIP
    Date sponsorTime
    String adjType

    static constraints = {
        fromAccountNo(maxSize:16,nullable:false)
        toAccountNo(maxSize:16,nullable:false)
        adjustAmount(nullable:false)
        remark(size:1..1000,nullable:false)
        status(nullable:false)
        approveTime(nullable:true)
        approvePerson(size:0..30,nullable:true)
        approveView(size:0..1000,nullable:true)
        sponsor(size:0..30,nullable:true)
        sIP(size:0..50,nullable:true)
        sponsorTime(nullable:true)
        adjType(nullable:true)
    }

    def static statusMap = [waitApp: '待审核', pass: '通过', refuse: '拒绝']
    def static pageMap = [10: '10', 20: '20', 30: '30', 50:'50']
}