package boss

class AppNote {
    String appName//那张表做的审批
    String appId  //表中的那条记录进行的审批
    String status  //审批状态（1,通过 2，拒绝）
    String appNote //审批通过或拒绝原因
    static constraints = {

    }
    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_app_note']
    }
     static statusMap=['1': '通过', '2': '拒绝']
}
