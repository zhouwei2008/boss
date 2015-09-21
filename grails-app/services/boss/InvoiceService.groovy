package boss

import groovy.sql.Sql
import java.sql.Connection;

class InvoiceService {

    static transactional = true

    def dataSource_boss
    def dataSource_ismp
    def dataSource_account
    def dataSource_settle

    def getCustomerInvoiceInfo() {

        def conBoss = dataSource_boss.getConnection()
        conBoss.setAutoCommit(false)
        def dbBoss =  new groovy.sql.Sql(conBoss)

        def conIsmp = dataSource_ismp.getConnection()
        conIsmp.setAutoCommit(false)
        def dbIsmp =  new groovy.sql.Sql(conIsmp)

        def conAccount = dataSource_account.getConnection()
        conAccount.setAutoCommit(false)
        def dbAccount =  new groovy.sql.Sql(conAccount)

        def conSettle = dataSource_settle.getConnection()
        conSettle.setAutoCommit(false)
        def dbSettle =  new groovy.sql.Sql(conSettle)

        // 发票批次号
        try {
            def dropSeqSql = "drop sequence seq_invoice_batch"
            dbBoss.execute(dropSeqSql)
            def createSeqSql = "create sequence seq_invoice_batch minvalue 1 maxvalue 9999999999999999999999999999 start with 1 increment by 1 cache 20"
            dbBoss.execute(createSeqSql)
            dbBoss.commit()
        } catch (Exception e) {
            dbBoss.rollback()
            dbBoss.close()
            dbIsmp.close()
            dbAccount.close()
            dbSettle.close()
            conBoss.close()
            conIsmp.close()
            conAccount.close()
            conSettle.close()
            println "e.message:" + e.message
            render e.message
        }

        // 客户信息
        try {
            def selectCustomerSql = """select cm.id as customer_id,
                                       cm.customer_no,
                                       cm.status as customer_status,
                                       cm.need_invoice,
                                       cm.account_no,
                                       cm.type as customer_type,
                                       cor.registration_name as customer_name,
                                       cor.tax_registration_no as customer_tax_no,
                                       cor.contact as customer_contact,
                                       cor.contact_phone as customer_contact_phone,
                                       cor.office_location as customer_location,
                                       cor.zip_code as customer_zip_code
                                  from ismp.cm_customer cm
                             left join ismp.cm_corporation_info cor on cm.id = cor.id"""
            def customerInfoList = dbIsmp.rows(selectCustomerSql);

            def customerSelectListSize = customerInfoList.size()
            if (customerSelectListSize > 0) {
                for(i in 1..customerSelectListSize) {
                    def customerInfo = customerInfoList.get(i - 1)
                    def customerId = customerInfo.get("customer_id")
                    def invoiceInitSelectSql = "select customer_id from bo_customer_invoice_init where customer_id = " + customerId
                    def invoiceInitInfo = dbBoss.rows(invoiceInitSelectSql)
                    // 备用方案
    //                def customerServiceSelectSql = """select srv_acc_no, fee_acc_no
    //                                              from bo_customer_service
    //                                             where service_code = 'agentpay'
    //                                               and enable = 1
    //                                               and is_current = 1
    //                                               and customer_id = """ + customerId
    //                def customerServiceInfo = dbBoss.rows(customerServiceSelectSql)
    //                def apSrvAccNo = ""
    //                def apFeeAccNo = ""
    //                if (customerServiceInfo.size() > 0) {
    //                    apSrvAccNo = customerServiceInfo.get(0).get("srv_acc_no")
    //                    apFeeAccNo = customerServiceInfo.get(0).get("fee_acc_no")
    //                }
                    if (invoiceInitInfo.size() == 0) {
                        // 新增客户发票信息
                        def insertCustomerInvoiceInitSql = """insert into bo_customer_invoice_init
                                                           (customer_id,
                                                            customer_no,
                                                            init_date,
                                                            init_amount,
                                                            init_status,
                                                            last_inv_date,
                                                            customer_status,
                                                            customer_type,
                                                            customer_name,
                                                            customer_tax_no,
                                                            customer_contact,
                                                            customer_contact_phone,
                                                            customer_location,
                                                            customer_zip_code,
                                                            need_invoice,
                                                            account_no,
                                                            ap_srv_acc_no,
                                                            ap_fee_acc_no
                                                            ) (select
                                                           """ + customerId + """,
                                                           '""" + customerInfo.get("customer_no") + """',
                                                           '',
                                                           0,
                                                           0,
                                                           '',
                                                           '""" + customerInfo.get("customer_status") + """',
                                                           '""" + customerInfo.get("customer_type") + """',
                                                           decode('""" + customerInfo.get("customer_name") + """', 'null', '' ,'""" + customerInfo.get("customer_name") + """'),
                                                           decode('""" + customerInfo.get("customer_tax_no") + """', 'null', '' ,'""" + customerInfo.get("customer_tax_no") + """'),
                                                           decode('""" + customerInfo.get("customer_contact") + """', 'null', '' ,'""" + customerInfo.get("customer_contact") + """'),
                                                           decode('""" + customerInfo.get("customer_contact_phone") + """', 'null', '' ,'""" + customerInfo.get("customer_contact_phone") + """'),
                                                           decode('""" + customerInfo.get("customer_location") + """', 'null', '' ,'""" + customerInfo.get("customer_location") + """'),
                                                           decode('""" + customerInfo.get("customer_zip_code") + """', 'null', '' ,'""" + customerInfo.get("customer_zip_code") + """'),
                                                           """ + customerInfo.get("need_invoice") + """,
                                                           decode('""" + customerInfo.get("account_no") + """', 'null', '' ,'""" + customerInfo.get("account_no") + """'),
                                                           decode(b.srv_acc_no, null, '', b.srv_acc_no),
                                                           decode(b.fee_acc_no, null, '', b.fee_acc_no)
                                                     from (select 1 as id from dual) a
                                                            left join (select 1 as id,
                                                                              srv_acc_no,
                                                                              fee_acc_no
                                                                         from bo_customer_service
                                                                        where service_code = 'agentpay'
                                                                          and enable = 1
                                                                          and is_current = 1
                                                                          and customer_id = """ + customerId + """) b on a.id = b.id) """
                        // 备用方案
    //                    def insertCustomerInvoiceInitSql = """insert into bo_customer_invoice_init
    //                                           (customer_id,
    //                                            customer_no,
    //                                            init_date,
    //                                            init_amount,
    //                                            init_status,
    //                                            last_inv_date,
    //                                            customer_status,
    //                                            customer_type,
    //                                            customer_name,
    //                                            customer_tax_no,
    //                                            customer_contact,
    //                                            customer_contact_phone,
    //                                            customer_location,
    //                                            customer_zip_code,
    //                                            need_invoice,
    //                                            account_no,
    //                                            ap_srv_acc_no,
    //                                            ap_fee_acc_no
    //                                            ) values (
    //                                           """ + customerId + """,
    //                                           '""" + customerInfo.get("customer_no") + """',
    //                                           '',
    //                                           0,
    //                                           0,
    //                                           '',
    //                                           '""" + customerInfo.get("customer_status") + """',
    //                                           '""" + customerInfo.get("customer_type") + """',
    //                                           decode('""" + customerInfo.get("customer_name") + """', 'null', '' ,'""" + customerInfo.get("customer_name") + """'),
    //                                           decode('""" + customerInfo.get("customer_tax_no") + """', 'null', '' ,'""" + customerInfo.get("customer_tax_no") + """'),
    //                                           decode('""" + customerInfo.get("customer_contact") + """', 'null', '' ,'""" + customerInfo.get("customer_contact") + """'),
    //                                           decode('""" + customerInfo.get("customer_contact_phone") + """', 'null', '' ,'""" + customerInfo.get("customer_contact_phone") + """'),
    //                                           decode('""" + customerInfo.get("customer_location") + """', 'null', '' ,'""" + customerInfo.get("customer_location") + """'),
    //                                           decode('""" + customerInfo.get("customer_zip_code") + """', 'null', '' ,'""" + customerInfo.get("customer_zip_code") + """'),
    //                                           """ + customerInfo.get("need_invoice") + """,
    //                                           decode('""" + customerInfo.get("account_no") + """', 'null', '' ,'""" + customerInfo.get("account_no") + """'),
    //                                           decode('""" + apSrvAccNo + """', 'null', '', '""" + apSrvAccNo + """'),
    //                                           decode('""" + apFeeAccNo + """', 'null', '', '""" + apFeeAccNo + """'))"""
                        dbBoss.execute(insertCustomerInvoiceInitSql)
                    } else {
                        // 刷新客户发票信息
                        def updateCustomerInvoiceInitSql = """update bo_customer_invoice_init
                                                       set (customer_status,
                                                            customer_name,
                                                            customer_tax_no,
                                                            customer_contact,
                                                            customer_contact_phone,
                                                            customer_location,
                                                            customer_zip_code,
                                                            need_invoice,
                                                            account_no,
                                                            ap_srv_acc_no,
                                                            ap_fee_acc_no
                                                            ) = (select
                                                           '""" + customerInfo.get("customer_status") + """',
                                                           decode('""" + customerInfo.get("customer_name") + """', 'null', '' ,'""" + customerInfo.get("customer_name") + """'),
                                                           decode('""" + customerInfo.get("customer_tax_no") + """', 'null', '' ,'""" + customerInfo.get("customer_tax_no") + """'),
                                                           decode('""" + customerInfo.get("customer_contact") + """', 'null', '' ,'""" + customerInfo.get("customer_contact") + """'),
                                                           decode('""" + customerInfo.get("customer_contact_phone") + """', 'null', '' ,'""" + customerInfo.get("customer_contact_phone") + """'),
                                                           decode('""" + customerInfo.get("customer_location") + """', 'null', '' ,'""" + customerInfo.get("customer_location") + """'),
                                                           decode('""" + customerInfo.get("customer_zip_code") + """', 'null', '' ,'""" + customerInfo.get("customer_zip_code") + """'),
                                                           """ + customerInfo.get("need_invoice") + """,
                                                           decode('""" + customerInfo.get("account_no") + """', 'null', '' ,'""" + customerInfo.get("account_no") + """'),
                                                           decode(b.srv_acc_no, null, '', b.srv_acc_no),
                                                           decode(b.fee_acc_no, null, '', b.fee_acc_no)
                                                     from (select customer_id from bo_customer_invoice_init t) a
                                                            left join (select customer_id,
                                                                              srv_acc_no,
                                                                              fee_acc_no
                                                                         from bo_customer_service
                                                                        where service_code = 'agentpay'
                                                                          and enable = 1
                                                                          and is_current = 1) b on a.customer_id = b.customer_id
                                                             where a.customer_id = """ + customerId + """)
                                                      where customer_id = """ + customerId
                        dbBoss.execute(updateCustomerInvoiceInitSql)
                    }
                }
            }
            dbBoss.commit()
        } catch (Exception e) {
            dbBoss.rollback()
            dbBoss.close()
            dbIsmp.close()
            dbAccount.close()
            dbSettle.close()
            conBoss.close()
            conIsmp.close()
            conAccount.close()
            conSettle.close()
            println "e.message:" + e.printStackTrace()
            throw new Exception(e.printStackTrace())
        }

        // 手续费
        try {

            // 平台手续费账户信息
            def selectInnerAccountSql = """select account_no as ap_fee_acc_no
                                       from bo_inner_account
                                      where lower(key) = 'feeacc'"""
            def innerAccountInfoList = dbBoss.rows(selectInnerAccountSql)
            def innerAccountListSize = innerAccountInfoList.size()
            def apInnerFeeAccountNo = ""
            if (innerAccountListSize > 0) {
                apInnerFeeAccountNo = innerAccountInfoList.get(0).get("ap_fee_acc_no")
            }

            // 已启用发票的客户信息
            def selectCustomerInvoiceSql = """select customer_id,
                                               customer_no,
                                               to_char(init_date, 'yyyy-mm-dd') as init_date,
                                               ap_srv_acc_no,
                                               ap_fee_acc_no,
                                               account_no
                                          from bo_customer_invoice_init
                                         where init_status = 1"""
            def customerInvoiceInfoList = dbBoss.rows(selectCustomerInvoiceSql)
            def customerInvoiceListSize = customerInvoiceInfoList.size()

            // 循环写入客户各种手续费
            if (customerInvoiceListSize > 0) {
                for (i in 1..customerInvoiceListSize) {

                    def customerInvoiceInfo = customerInvoiceInfoList.get(i - 1)
                    def customerId = customerInvoiceInfo.get("customer_id")
                    def customerNo = customerInvoiceInfo.get("customer_no")
                    def initDate = customerInvoiceInfo.get("init_date")
                    def apSrvAccountNo = customerInvoiceInfo.get("ap_srv_acc_no")
                    def apFeeAccountNo = customerInvoiceInfo.get("ap_fee_acc_no")
                    def accountNo = customerInvoiceInfo.get("account_no")

                    // 网上支付 即扣 历史抓取ID极值
                    def selectNetPreMaxIdSql = """select decode(max(bill_id), null, 0, max(bill_id)) as max_id
                                              from bo_customer_invoice_detail
                                             where bill_type = 1
                                               and fee_type = 0
                                               and customer_id = """ + customerId
                    def netPreMaxId = dbBoss.rows(selectNetPreMaxIdSql).get(0).get("max_id")
                    // 网上支付 后返 历史抓取ID极值
                    def selectNetPostMaxIdSql = """select decode(max(bill_id), null, 0, max(bill_id)) as max_id
                                              from bo_customer_invoice_detail
                                             where bill_type = 1
                                               and fee_type = 1
                                               and customer_id = """ + customerId
                    def netPostMaxId = dbBoss.rows(selectNetPostMaxIdSql).get(0).get("max_id")
                    // 网上支付 实时结算 历史抓取ID极值
                    def selectNetSettleMaxIdSql = """select decode(max(bill_id), null, 0, max(bill_id)) as max_id
                                              from bo_customer_invoice_detail
                                             where bill_type = 1
                                               and fee_type = 2
                                               and customer_id = """ + customerId
                    def netSettleMaxId = dbBoss.rows(selectNetSettleMaxIdSql).get(0).get("max_id")
                    // 代收 即扣 历史抓取ID极值
                    def selectCollPreMaxIdSql = """select decode(max(bill_id), null, 0, max(bill_id)) as max_id
                                              from bo_customer_invoice_detail
                                             where bill_type = 2
                                               and fee_type = 0
                                               and customer_id = """ + customerId
                    def collPreMaxId = dbBoss.rows(selectCollPreMaxIdSql).get(0).get("max_id")
                    // 代收 后返 历史抓取ID极值
                    def selectCollPostMaxIdSql = """select decode(max(bill_id), null, 0, max(bill_id)) as max_id
                                              from bo_customer_invoice_detail
                                             where bill_type = 2
                                               and fee_type = 1
                                               and customer_id = """ + customerId
                    def collPostMaxId = dbBoss.rows(selectCollPostMaxIdSql).get(0).get("max_id")
                    // 代收 实时结算 历史抓取ID极值
                    def selectCollSettleMaxIdSql = """select decode(max(bill_id), null, 0, max(bill_id)) as max_id
                                              from bo_customer_invoice_detail
                                             where bill_type = 2
                                               and fee_type = 2
                                               and customer_id = """ + customerId
                    def collSettleMaxId = dbBoss.rows(selectCollSettleMaxIdSql).get(0).get("max_id")
                    // 代付 即扣 历史抓取ID极值
                    def selectPayPreMaxIdSql = """select decode(max(bill_id), null, 0, max(bill_id)) as max_id
                                              from bo_customer_invoice_detail
                                             where bill_type = 3
                                               and fee_type = 0
                                               and customer_id = """ + customerId
                    def payPreMaxId = dbBoss.rows(selectPayPreMaxIdSql).get(0).get("max_id")
                    // 代付 后返 历史抓取ID极值
                    def selectPayPostMaxIdSql = """select decode(max(bill_id), null, 0, max(bill_id)) as max_id
                                              from bo_customer_invoice_detail
                                             where bill_type = 3
                                               and fee_type = 1
                                               and customer_id = """ + customerId
                    def payPostMaxId = dbBoss.rows(selectPayPostMaxIdSql).get(0).get("max_id")

                    // 网上支付&代收
                    def selectNetCollSql = """select 1 as bill_type,
                                               0 as fee_type,
                                               id as bill_id,
                                               customer_no,
                                               foot_no as bill_no,
                                               to_char(foot_date, 'yyyy-mm-dd hh24:mi:ss') as bill_date,
                                               pre_fee as bill_amount
                                        from ft_foot
                                        where srv_code = 'online'
                                        and check_status = 1
                                        and pre_fee <> 0
                                        and id > """ + netPreMaxId + """
                                        and customer_no = """ + customerNo + """
                                        and to_char(foot_date, 'yyyy-mm-dd') >= '""" + initDate + """'
                                        union all
                                        select 1 as bill_type,
                                               1 as fee_type,
                                               id as bill_id,
                                               customer_no,
                                               foot_no as bill_no,
                                               to_char(foot_date, 'yyyy-mm-dd hh24:mi:ss') as bill_date,
                                               post_fee as bill_amount
                                        from ft_foot
                                        where srv_code = 'online'
                                        and check_status = 1
                                        and post_fee <> 0
                                        and id > """ + netPostMaxId + """
                                        and customer_no = """ + customerNo + """
                                        and to_char(foot_date, 'yyyy-mm-dd') >= '""" + initDate + """'
                                        union all
                                        select 1 as bill_type,
                                               2 as fee_type,
                                               id as bill_id,
                                               customer_no,
                                               seq_no as bill_no,
                                               to_char(bill_date, 'yyyy-mm-dd hh24:mi:ss') as bill_date,
                                               pre_fee as bill_amount
                                        from ft_trade
                                        where srv_code = 'online'
                                        and realtime_settle = 1
                                        and pre_fee is not null
                                        and id > """ + netSettleMaxId + """
                                        and customer_no = """ + customerNo + """
                                        and to_char(bill_date, 'yyyy-mm-dd') >= '""" + initDate + """'
                                        union all
                                        select 2 as bill_type,
                                               0 as fee_type,
                                               id as bill_id,
                                               customer_no,
                                               foot_no as bill_no,
                                               to_char(foot_date, 'yyyy-mm-dd hh24:mi:ss') as bill_date,
                                               pre_fee as bill_amount
                                        from ft_foot
                                        where srv_code = 'agentcoll'
                                        and check_status = 1
                                        and pre_fee <> 0
                                        and id > """ + collPreMaxId + """
                                        and customer_no = """ + customerNo + """
                                        and to_char(foot_date, 'yyyy-mm-dd') >= '""" + initDate + """'
                                        union all
                                        select 2 as bill_type,
                                               1 as fee_type,
                                               id as bill_id,
                                               customer_no,
                                               foot_no as bill_no,
                                               to_char(foot_date, 'yyyy-mm-dd hh24:mi:ss') as bill_date,
                                               post_fee as bill_amount
                                        from ft_foot
                                        where srv_code = 'agentcoll'
                                        and check_status = 1
                                        and post_fee <> 0
                                        and id > """ + collPostMaxId + """
                                        and customer_no = """ + customerNo + """
                                        and to_char(foot_date, 'yyyy-mm-dd') >= '""" + initDate + """'
                                        union all
                                        select 2 as bill_type,
                                               2 as fee_type,
                                               id as bill_id,
                                               customer_no,
                                               seq_no as bill_no,
                                               to_char(bill_date, 'yyyy-mm-dd hh24:mi:ss') as bill_date,
                                               pre_fee as bill_amount
                                        from ft_trade
                                        where srv_code = 'agentcoll'
                                        and realtime_settle = 1
                                        and pre_fee is not null
                                        and id > """ + collSettleMaxId + """
                                        and customer_no = """ + customerNo + """
                                        and to_char(bill_date, 'yyyy-mm-dd') >= '""" + initDate + """'"""
                    def netCollInfoList = dbSettle.rows(selectNetCollSql)
                    def netCollInfoSize = netCollInfoList.size()

                    if (netCollInfoSize > 0) {
                        for (j in 1..netCollInfoSize) {
                            def netCollInfo = netCollInfoList.get(j - 1)
                            def insertNetCollInfoSql = """insert into bo_customer_invoice_detail values (""" + netCollInfo.get("bill_type") + """,
                                                                                           """ + netCollInfo.get("fee_type") + """,
                                                                                           """ + netCollInfo.get("bill_id") + """,
                                                                                           '""" + netCollInfo.get("bill_no") + """',
                                                                                           """ + customerId + """,
                                                                                           to_date('""" + netCollInfo.get("bill_date") + """', 'yyyy-mm-dd hh24:mi:ss'),
                                                                                           """ + netCollInfo.get("bill_amount")/100 + """,
                                                                                           null)"""
                            dbBoss.execute(insertNetCollInfoSql)
                        }
                    }

                    // 代付
                    def selectAgentPaySql = """select 3 as bill_type,
                                               0 as fee_type,
                                               id as bill_id,
                                               null as bill_no,
                                               to_char(date_created, 'yyyy-mm-dd hh24:mi:ss') as bill_date,
                                               amount as bill_amount
                                          from ac_transaction
                                         where transfer_type <> 'adjust'
                                         and from_account_no = '""" + apSrvAccountNo + """'
                                           and to_account_no = '""" + apInnerFeeAccountNo + """'
                                           and id > """ + payPreMaxId + """
                                           and to_char(date_created, 'yyyy-mm-dd') >= '""" + initDate + """'
                                        union all
                                        select 3 as bill_type,
                                               1 as fee_type,
                                               id as bill_id,
                                               null as bill_no,
                                               to_char(date_created, 'yyyy-mm-dd hh24:mi:ss') as bill_date,
                                               amount as bill_amount
                                          from ac_transaction
                                         where transfer_type <> 'adjust'
                                         and from_account_no = '""" + accountNo + """'
                                           and to_account_no = '""" + apFeeAccountNo + """'
                                           and id > """ + payPostMaxId + """
                                           and to_char(date_created, 'yyyy-mm-dd') >= '""" + initDate + """'"""
                    def agentPayInfoList = dbAccount.rows(selectAgentPaySql)
                    def agentPayInfoSize = agentPayInfoList.size()

                    if (agentPayInfoSize > 0) {
                        for (j in 1..agentPayInfoSize) {
                            def agentPayInfo = agentPayInfoList.get(j - 1)
                            def insertAgentPayInfoSql = """insert into bo_customer_invoice_detail values (""" + agentPayInfo.get("bill_type") + """,
                                                                                           """ + agentPayInfo.get("fee_type") + """,
                                                                                           """ + agentPayInfo.get("bill_id") + """,
                                                                                           '',
                                                                                           """ + customerId + """,
                                                                                           to_date('""" + agentPayInfo.get("bill_date") + """', 'yyyy-mm-dd hh24:mi:ss'),
                                                                                           """ + agentPayInfo.get("bill_amount")/100 + """,
                                                                                           null)"""
                            dbBoss.execute(insertAgentPayInfoSql)
                        }
                    }

                }
            }

            dbBoss.commit()

        } catch (Exception e) {
            dbBoss.rollback()
            println "e.message:" + e.printStackTrace()
            throw new Exception(e.printStackTrace())
        } finally {
            dbBoss.close()
            dbIsmp.close()
            dbAccount.close()
            dbSettle.close()
            conBoss.close()
            conIsmp.close()
            conAccount.close()
            conSettle.close()
        }
    }
}
