package boss

class BoCustomerInvoice {

    static constraints = {

    }
     static statusSelect = [ '-1': '全部', '1': '已生成', '21': '已下载', '32': '发票已开', '43': '发票已寄', '54': '发票退回']
     static statusMap = [ '1': '已生成', '21': '已下载', '32': '发票已开', '43': '发票已寄', '54': '发票退回']
     static statusCancelMap = [  '-1': '全部', '1': '已生成', '21': '已下载', '32': '发票已开', '43': '发票已寄']
}
