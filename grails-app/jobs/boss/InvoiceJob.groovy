package boss

/**
 * Created by IntelliJ IDEA.
 * User: zhaoshuang
 * Date: 12-2-9
 * Time: 下午1:58
 * To change this template use File | Settings | File Templates.
 */
class InvoiceJob {

    def invoiceService
    static triggers = {

        cron name: 'invoice', cronExpression: "0 30 01 * * ?"
    }
//    static triggers = {
//        simple name: 'invoice', startDelay: 2000, repeatInterval:10*60*1000
//    }

    def execute() {

        log.info('invoice start' + new Date())
        invoiceService.getCustomerInvoiceInfo()
        log.info('invoice end')
    }
}
