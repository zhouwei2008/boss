package ismp

class TbRiskNotifier {

    static constraints = {

         name (size:1..20,nullable: false)

         subId (size:1..20,nullable: false)

         email (size:1..20,nullable: false)

    }

    static mapping = {

        table 'TB_RISK_NOTIFIER'

        version false

        id generator: 'sequence', params: [sequence: 'SEQ_RISK_NOTIFIER'], column: 'ID'

    }

    String name

    String subId

    String email

}
