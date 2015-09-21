package boss

class BoCustomerInvoiceDetail {

    static constraints = {

    }
     static billTypeMap = ['0': '初始余额', '1': '在线支付手续费', '2': '代收手续费', '3': '代付手续费', '4': '手续费调账']
     static feeTypeMap = ['0': '即扣', '1': '后返']
}
