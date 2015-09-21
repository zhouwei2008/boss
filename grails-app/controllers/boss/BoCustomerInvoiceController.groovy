package boss

import groovy.sql.Sql
import java.sql.Connection;
import grails.converters.JSON

class BoCustomerInvoiceController {

    def dataSource_boss

    def index = { }

    // 初始化 查询
    def invoiceInitShow = {

        def dbBoss =  new groovy.sql.Sql(dataSource_boss)

        // 数据检索
        params.max = Math.min(params.max ? params.int('max') : 100, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def listStart = params.offset
        def listTo = listStart + params.max
        def condition = ""

        if ((params.status == null) ||(params.status.equals(""))) {
             params.status = '0'
        }
        if ((params.status != null)&&(!params.status.equals(""))&&(!params.status.equals("-1"))) {
            condition = condition + " and to_char(init_status) = '" + params.status + "'"
        }
        if ((params.customerNo != null)&&(!params.customerNo.equals(""))) {
            condition = condition + " and customer_no like '%" + params.customerNo + "%'"
        }
        if ((params.customerName != null)&&(!params.customerName.equals(""))) {
            condition = condition + " and customer_name like '%" + params.customerName + "%'"
        }

        def cmSql = """select customer_id as customer_id,
                           customer_no,
                           customer_name,
                           to_char(init_date, 'yyyy-mm-dd') as init_date,
                           to_char(init_amount, 'fm999,999,999,999,999,990.00') as init_amount,
                           to_char(init_status) as status,
                           to_char(last_inv_date, 'yyyy-mm-dd') as last_inv_date
                      from bo_customer_invoice_init
                      where customer_tax_no is not null
                        and customer_name is not null
                        and need_invoice = 1
                        and customer_status = 'normal'"""
        cmSql = cmSql + condition + " order by customer_name asc"

        def listSql = "select t.* from (select t.*, rownum rn from (" + cmSql + ") t) t where t.rn > " + listStart + " and t.rn <= " + listTo
        def listCm = dbBoss.rows(listSql)
        def count = dbBoss.rows("select count(*) as count from (" + cmSql + ")")[0][0]

        [listCm: listCm, count: count]
    }

    // 初始化 保存 启用
    def invoiceInitSave = {

        def con = dataSource_boss.getConnection()
        con.setAutoCommit(false)
        def dbBoss =  new groovy.sql.Sql(con)

        try {
            def infoArr = params.info.split("thisIsALine")
            def size = infoArr.size()
            for (i in 0..size-1) {
                def subInfoArr = infoArr[i].split("thisIsASubLine")
                if (params.saveFlag.equals("0")) {
                    def cmUpdateSql = """update bo_customer_invoice_init
                                   set init_date = to_date('""" + subInfoArr[1] + """', 'yyyy-mm-dd'),
                                       init_amount = """ + String.valueOf(subInfoArr[2]).replaceAll(",", "") + """,
                                       last_inv_date = to_date('""" + subInfoArr[1] + """', 'yyyy-mm-dd') - 1
                                 where customer_id = """ + subInfoArr[0] + """
                                   and init_status = 0"""
                    dbBoss.execute(cmUpdateSql)
                } else {
                    def cmUpdateSql = """update bo_customer_invoice_init
                                   set init_date = to_date('""" + subInfoArr[1] + """', 'yyyy-mm-dd'),
                                       init_amount = """ + String.valueOf(subInfoArr[2]).replaceAll(",", "") + """,
                                       last_inv_date = to_date('""" + subInfoArr[1] + """', 'yyyy-mm-dd') - 1,
                                       init_status = 1
                                 where customer_id = """ + subInfoArr[0] + """
                                   and init_status = 0"""
                    dbBoss.execute(cmUpdateSql)
                    def cmInsertSql = """insert into bo_customer_invoice_detail values (0,
                                                                                   99,
                                                                                   0,
                                                                                   '0',
                                                                                   """ + subInfoArr[0] + """,
                                                                                   to_date('""" + subInfoArr[1] + """', 'yyyy-mm-dd'),
                                                                                   """ + String.valueOf(subInfoArr[2]).replaceAll(",", "") + """,
                                                                                   null)"""
                    dbBoss.execute(cmInsertSql)
                }
            }
            dbBoss.commit()
        } catch (Exception e) {
            dbBoss.rollback()
            println "e.message:" + e.message
            render e.message
        } finally {
            dbBoss.close()
            con.close()
        }

        redirect(action: "invoiceInitShow", params: params)
    }

    // 待开发票查询
    def invoiceOutstandingShow = {

        def dbBoss =  new groovy.sql.Sql(dataSource_boss)

        params.max = Math.min(params.max ? params.int('max') : 30 , 100)
        params.offset = params.offset ? params.int('offset') : 0
        params.dateFlag = params.dateFlag ? params.dateFlag : '0'
        def listStart = params.offset
        def listTo = listStart + params.max
        def condition = ""
        def amountCondition = ""
        def invDate = ""

        if ((params.startTime == null) ||(params.startTime.equals(""))) {
            Calendar calendar = Calendar.getInstance()
            calendar.add(Calendar.MONTH, -1)
            int day = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
            int year = calendar.get(Calendar.YEAR)
            int month = calendar.get(Calendar.MONTH) + 1
            invDate = year + "-" + month + "-" + day
            params.factDate = invDate
            if (month < 10) {
                params.startTime = year + "-" + "0" + month
            } else {
                params.startTime = year + "-" + month
            }
            params.minAmount = '10.00'
        } else if (params.dateFlag.equals("0")) {
            def startTime = String.valueOf(params.startTime)
            Calendar calendar = Calendar.getInstance()
            calendar.set(Integer.valueOf(startTime.substring(0, 4)), Integer.valueOf(startTime.substring(5, 7)), 1)
            calendar.add(Calendar.MONTH, -1)
            int day = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
            int year = calendar.get(Calendar.YEAR)
            int month = calendar.get(Calendar.MONTH) + 1
            invDate = year + "-" + month + "-" + day
            params.factDate = invDate
        } else {
            invDate = String.valueOf(params.startTime)
            params.factDate = invDate
        }

        if ((params.customerNoStr != null)&&(!params.customerNoStr.equals(""))) {
            def customerNos = String.valueOf(params.customerNoStr).trim().replaceAll("( )+", " ").replaceAll(" ", ",")
            params.customerNoStr = customerNos

            if ((customerNos != null)&&(!customerNos.equals(""))) {
                customerNos = "'" + customerNos.replaceAll(",", "','") + "'"
                condition = condition + " and customer_no in (" + customerNos + ")"
            }
        }

        if ((params.minAmount != null)&&(!params.minAmount.equals(""))) {
            amountCondition = " where (decode(info.amt, null, 0, info.amt) + decode(info.amt_adj, null, 0, info.amt_adj))*100 >= " + String.valueOf(params.minAmount).replace(".", "")
        }

        def cmSql = """select info.customer_id,
                           info.customer_no,
                           info.customer_name,
                           to_char(decode(info.amt, null, 0, info.amt), 'fm999,999,999,999,999,990.00') as amt,
                           to_char(decode(info.amt_adj, null, 0, info.amt_adj), 'fm999,999,999,999,999,990.00') as amt_adj,
                           to_char(decode(info.amt, null, 0, info.amt) + decode(info.amt_adj, null, 0, info.amt_adj), 'fm999,999,999,999,999,990.00') as amt_total,
                           to_char(info.customer_tax_no) as customer_tax_no,
                           to_char(info.customer_contact) as customer_contact,
                           to_char(info.customer_contact_phone) as customer_contact_phone,
                           to_char(info.customer_location) as customer_location,
                           to_char(info.customer_zip_code) as customer_zip_code
                       from (select init.customer_id,
                                   init.customer_no,
                                   init.customer_name,
                                   cash.amt,
                                   cho.amt as amt_adj,
                                   init.customer_tax_no,
                                   init.customer_contact,
                                   init.customer_contact_phone,
                                   init.customer_location,
                                   init.customer_zip_code
                              from bo_customer_invoice_init init
                              left join (select sum(amt) as amt, customer_id
                                           from (select sum(detail.bill_amount) as amt, detail.customer_id
                                                    from bo_customer_invoice_detail detail
                                                   inner join bo_customer_invoice_init init on init.customer_id = detail.customer_id
                                                   where detail.balance_id is null
                                                     and to_char(detail.bill_date, 'yyyy-mm-dd') > to_char(init.last_inv_date, 'yyyy-mm-dd')
                                                     and to_char(detail.bill_date, 'yyyy-mm-dd') <= to_char(to_date('""" + invDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                                   group by detail.customer_id
                                                  union all
                                                  select sum(-adjust.adjust_amount)/100 as amt, srv.customer_id
                                                    from bo_customer_service srv
                                                   inner join bo_account_adjust_info adjust on srv.fee_acc_no = adjust.to_account_no
                                                   inner join bo_customer_invoice_init init on init.customer_id = srv.customer_id
                                                   where adjust.status = 'pass'
                                                     and adjust.invoice_id is null
                                                     and adjust.adj_type = '1'
                                                     and to_char(adjust.sponsor_time, 'yyyy-mm-dd') > to_char(init.last_inv_date, 'yyyy-mm-dd')
                                                     and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <= to_char(to_date('""" + invDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                                   group by srv.customer_id
                                                  union all
                                                  select sum(adjust.adjust_amount)/100 as amt, srv.customer_id
                                                    from bo_customer_service srv
                                                   inner join bo_account_adjust_info adjust on srv.fee_acc_no = adjust.from_account_no
                                                   inner join bo_customer_invoice_init init on init.customer_id = srv.customer_id
                                                   where adjust.status = 'pass'
                                                     and adjust.invoice_id is null
                                                     and adjust.adj_type = '1'
                                                     and to_char(adjust.sponsor_time, 'yyyy-mm-dd') > to_char(init.last_inv_date, 'yyyy-mm-dd')
                                                     and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <= to_char(to_date('""" + invDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                                   group by srv.customer_id
                                                   union all
                                                  select sum(-adjust.adjust_amount)/100 as amt, init.customer_id
                                                    from bo_customer_invoice_init init
                                                   inner join bo_account_adjust_info adjust on init.account_no = adjust.to_account_no
                                                   inner join bo_inner_account inn on inn.account_no = adjust.from_account_no
                                                   where lower(inn.key) = 'feeacc'
                                                     and adjust.status = 'pass'
                                                     and adjust.invoice_id is null
                                                     and adjust.adj_type = '1'
                                                     and to_char(adjust.sponsor_time, 'yyyy-mm-dd') > to_char(init.last_inv_date, 'yyyy-mm-dd')
                                                     and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <= to_char(to_date('""" + invDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                                   group by init.customer_id
                                                   union all
                                                  select sum(adjust.adjust_amount)/100 as amt, init.customer_id
                                                    from bo_customer_invoice_init init
                                                   inner join bo_account_adjust_info adjust on init.account_no = adjust.from_account_no
                                                   inner join bo_inner_account inn on inn.account_no = adjust.to_account_no
                                                   where lower(inn.key) = 'feeacc'
                                                     and adjust.status = 'pass'
                                                     and adjust.invoice_id is null
                                                     and adjust.adj_type = '1'
                                                     and to_char(adjust.sponsor_time, 'yyyy-mm-dd') > to_char(init.last_inv_date, 'yyyy-mm-dd')
                                                     and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <= to_char(to_date('""" + invDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                                   group by init.customer_id)
                                          group by customer_id) cash on cash.customer_id = init.customer_id
             left join (select sum(amt)/100 as amt, customer_id
                       from (select sum(-adjust.adjust_amount) as amt, srv.customer_id
                               from bo_customer_service srv
                              inner join bo_account_adjust_info adjust on srv.fee_acc_no = adjust.to_account_no
                              inner join bo_customer_invoice_init init on init.customer_id = srv.customer_id
                              where adjust.status = 'pass'
                                and adjust.invoice_id is null
                                and adjust.adj_type = '1'
                                and adjust.choose_flag = 1
                                and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >= to_char(init.init_date, 'yyyy-mm-dd')
                                and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <= to_char(init.last_inv_date, 'yyyy-mm-dd')
                              group by srv.customer_id
                             union all
                             select sum(-adjust.adjust_amount) as amt, srv.customer_id
                               from bo_customer_service srv
                              inner join bo_account_adjust_info adjust on srv.fee_acc_no = adjust.to_account_no
                              inner join bo_customer_invoice_init init on init.customer_id = srv.customer_id
                              where adjust.status = 'pass'
                                and adjust.invoice_id is null
                                and adjust.adj_type = '1'
                                and adjust.choose_flag = 1
                                and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(to_date('""" + invDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                              group by srv.customer_id
                             union all
                             select sum(adjust.adjust_amount) as amt,
                                    srv.customer_id
                               from bo_customer_service srv
                              inner join bo_account_adjust_info adjust on srv.fee_acc_no = adjust.from_account_no
                              inner join bo_customer_invoice_init init on init.customer_id = srv.customer_id
                              where adjust.status = 'pass'
                                and adjust.invoice_id is null
                                and adjust.adj_type = '1'
                                and adjust.choose_flag = 1
                                and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >= to_char(init.init_date, 'yyyy-mm-dd')
                                and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <= to_char(init.last_inv_date, 'yyyy-mm-dd')
                              group by srv.customer_id
                             union all
                             select sum(adjust.adjust_amount) as amt,
                                    srv.customer_id
                               from bo_customer_service srv
                              inner join bo_account_adjust_info adjust on srv.fee_acc_no = adjust.from_account_no
                              inner join bo_customer_invoice_init init on init.customer_id = srv.customer_id
                              where adjust.status = 'pass'
                                and adjust.invoice_id is null
                                and adjust.adj_type = '1'
                                and adjust.choose_flag = 1
                                and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(to_date('""" + invDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                              group by srv.customer_id
                              union all
                              select sum(-adjust.adjust_amount) as amt, init.customer_id
                               from bo_customer_invoice_init init
                              inner join bo_account_adjust_info adjust on init.account_no = adjust.to_account_no
                              inner join bo_inner_account inn on inn.account_no = adjust.from_account_no
                              where lower(inn.key) = 'feeacc'
                                and adjust.status = 'pass'
                                and adjust.invoice_id is null
                                and adjust.adj_type = '1'
                                and adjust.choose_flag = 1
                                and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >= to_char(init.init_date, 'yyyy-mm-dd')
                                and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <= to_char(init.last_inv_date, 'yyyy-mm-dd')
                              group by init.customer_id
                              union all
                              select sum(-adjust.adjust_amount) as amt, init.customer_id
                               from bo_customer_invoice_init init
                              inner join bo_account_adjust_info adjust on init.account_no = adjust.to_account_no
                              inner join bo_inner_account inn on inn.account_no = adjust.from_account_no
                              where lower(inn.key) = 'feeacc'
                                and adjust.status = 'pass'
                                and adjust.invoice_id is null
                                and adjust.adj_type = '1'
                                and adjust.choose_flag = 1
                                and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(to_date('""" + invDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                              group by init.customer_id
                              union all
                              select sum(adjust.adjust_amount) as amt, init.customer_id
                               from bo_customer_invoice_init init
                              inner join bo_account_adjust_info adjust on init.account_no = adjust.from_account_no
                              inner join bo_inner_account inn on inn.account_no = adjust.to_account_no
                              where lower(inn.key) = 'feeacc'
                                and adjust.status = 'pass'
                                and adjust.invoice_id is null
                                and adjust.adj_type = '1'
                                and adjust.choose_flag = 1
                                and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >= to_char(init.init_date, 'yyyy-mm-dd')
                                and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <= to_char(init.last_inv_date, 'yyyy-mm-dd')
                              group by init.customer_id
                              union all
                              select sum(adjust.adjust_amount) as amt, init.customer_id
                               from bo_customer_invoice_init init
                              inner join bo_account_adjust_info adjust on init.account_no = adjust.from_account_no
                              inner join bo_inner_account inn on inn.account_no = adjust.to_account_no
                              where lower(inn.key) = 'feeacc'
                                and adjust.status = 'pass'
                                and adjust.invoice_id is null
                                and adjust.adj_type = '1'
                                and adjust.choose_flag = 1
                                and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(to_date('""" + invDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                              group by init.customer_id)
                      group by customer_id) cho on cho.customer_id = init.customer_id
                             where init_status = 1
                               and need_invoice = 1
                               and customer_tax_no is not null
                               and customer_name is not null
                               and init_date <= to_date('""" + invDate + """', 'yyyy-mm-dd')"""
        cmSql = cmSql + condition + ") info" + amountCondition + " order by info.customer_name asc"

        def listSql = "select t.* from (select t.*, rownum rn from (" + cmSql + ") t) t where t.rn > " + listStart + " and t.rn <= " + listTo
        def listCm = dbBoss.rows(listSql)
        def count = dbBoss.rows("select count(*) as count from (" + cmSql + ")")[0][0]

        [listCm: listCm, count: count]
    }

    // 调账页面信息
    def invoiceAdjustInfo = {

        def dbBoss =  new groovy.sql.Sql(dataSource_boss)

        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def listStart = params.offset
        def listTo = listStart + params.max

        def adjustSql = """select sub.id,
                           sub.account_no,
                           sub.opp_acc_no,
                           to_char(sub.amt/100, 'fm999,999,999,999,999,990.00') as amt,
                           sub.choose_flag,
                           sub.remark,
                           sub.sponsor_time,
                           sub.customer_id
                      from (select adjust.id,
                                   srv.fee_acc_no as account_no,
                                   adjust.from_account_no as opp_acc_no,
                                   -adjust.adjust_amount as amt,
                                   adjust.choose_flag,
                                   adjust.remark,
                                   to_char(adjust.sponsor_time, 'yyyy-mm-dd hh24:mi:ss') as sponsor_time,
                                   srv.customer_id
                              from bo_customer_service srv
                             inner join bo_account_adjust_info adjust on srv.fee_acc_no =
                                                                         adjust.to_account_no
                             inner join bo_customer_invoice_init init on init.customer_id =
                                                                         srv.customer_id
                             where adjust.status = 'pass'
                               and adjust.invoice_id is null
                               and adjust.adj_type = '1'
                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(init.init_date, 'yyyy-mm-dd')
                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <=
                                   to_char(init.last_inv_date, 'yyyy-mm-dd')
                            union all
                            select adjust.id,
                                   srv.fee_acc_no as account_no,
                                   adjust.from_account_no as opp_acc_no,
                                   -adjust.adjust_amount as amt,
                                   adjust.choose_flag,
                                   adjust.remark,
                                   to_char(adjust.sponsor_time, 'yyyy-mm-dd hh24:mi:ss') as sponsor_time,
                                   srv.customer_id
                              from bo_customer_service srv
                             inner join bo_account_adjust_info adjust on srv.fee_acc_no =
                                                                         adjust.to_account_no
                             inner join bo_customer_invoice_init init on init.customer_id =
                                                                         srv.customer_id
                             where adjust.status = 'pass'
                               and adjust.invoice_id is null
                               and adjust.adj_type = '1'
                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(to_date('""" + params.factDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                            union all
                            select adjust.id,
                                   srv.fee_acc_no as account_no,
                                   adjust.to_account_no as opp_acc_no,
                                   adjust.adjust_amount as amt,
                                   adjust.choose_flag,
                                   adjust.remark,
                                   to_char(adjust.sponsor_time, 'yyyy-mm-dd hh24:mi:ss') as sponsor_time,
                                   srv.customer_id
                              from bo_customer_service srv
                             inner join bo_account_adjust_info adjust on srv.fee_acc_no =
                                                                         adjust.from_account_no
                             inner join bo_customer_invoice_init init on init.customer_id =
                                                                         srv.customer_id
                             where adjust.status = 'pass'
                               and adjust.invoice_id is null
                               and adjust.adj_type = '1'
                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(init.init_date, 'yyyy-mm-dd')
                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <=
                                   to_char(init.last_inv_date, 'yyyy-mm-dd')
                            union all
                            select adjust.id,
                                   srv.fee_acc_no as account_no,
                                   adjust.to_account_no as opp_acc_no,
                                   adjust.adjust_amount as amt,
                                   adjust.choose_flag,
                                   adjust.remark,
                                   to_char(adjust.sponsor_time, 'yyyy-mm-dd hh24:mi:ss') as sponsor_time,
                                   srv.customer_id
                              from bo_customer_service srv
                             inner join bo_account_adjust_info adjust on srv.fee_acc_no =
                                                                         adjust.from_account_no
                             inner join bo_customer_invoice_init init on init.customer_id =
                                                                         srv.customer_id
                             where adjust.status = 'pass'
                               and adjust.invoice_id is null
                               and adjust.adj_type = '1'
                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(to_date('""" + params.factDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                            union all
                            select adjust.id,
                                   init.account_no,
                                   adjust.from_account_no as opp_acc_no,
                                   -adjust.adjust_amount as amt,
                                   adjust.choose_flag,
                                   adjust.remark,
                                   to_char(adjust.sponsor_time, 'yyyy-mm-dd hh24:mi:ss') as sponsor_time,
                                   init.customer_id
                              from bo_customer_invoice_init init
                             inner join bo_account_adjust_info adjust on init.account_no =
                                                                         adjust.to_account_no
                             inner join bo_inner_account inn on inn.account_no =
                                                                         adjust.from_account_no
                             where adjust.status = 'pass'
                               and adjust.invoice_id is null
                               and adjust.adj_type = '1'
                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(init.init_date, 'yyyy-mm-dd')
                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <=
                                   to_char(init.last_inv_date, 'yyyy-mm-dd')
                            union all
                            select adjust.id,
                                   init.account_no,
                                   adjust.from_account_no as opp_acc_no,
                                   -adjust.adjust_amount as amt,
                                   adjust.choose_flag,
                                   adjust.remark,
                                   to_char(adjust.sponsor_time, 'yyyy-mm-dd hh24:mi:ss') as sponsor_time,
                                   init.customer_id
                              from bo_customer_invoice_init init
                             inner join bo_account_adjust_info adjust on init.account_no =
                                                                         adjust.to_account_no
                             inner join bo_inner_account inn on inn.account_no =
                                                                         adjust.from_account_no
                             where adjust.status = 'pass'
                               and adjust.invoice_id is null
                               and adjust.adj_type = '1'
                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(to_date('""" + params.factDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                            union all
                            select adjust.id,
                                   init.account_no,
                                   adjust.to_account_no as opp_acc_no,
                                   adjust.adjust_amount as amt,
                                   adjust.choose_flag,
                                   adjust.remark,
                                   to_char(adjust.sponsor_time, 'yyyy-mm-dd hh24:mi:ss') as sponsor_time,
                                   init.customer_id
                              from bo_customer_invoice_init init
                             inner join bo_account_adjust_info adjust on init.account_no =
                                                                         adjust.from_account_no
                             inner join bo_inner_account inn on inn.account_no =
                                                                         adjust.to_account_no
                             where adjust.status = 'pass'
                               and adjust.invoice_id is null
                               and adjust.adj_type = '1'
                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(init.init_date, 'yyyy-mm-dd')
                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <=
                                   to_char(init.last_inv_date, 'yyyy-mm-dd')
                            union all
                            select adjust.id,
                                   init.account_no,
                                   adjust.to_account_no as opp_acc_no,
                                   adjust.adjust_amount as amt,
                                   adjust.choose_flag,
                                   adjust.remark,
                                   to_char(adjust.sponsor_time, 'yyyy-mm-dd hh24:mi:ss') as sponsor_time,
                                   init.customer_id
                              from bo_customer_invoice_init init
                             inner join bo_account_adjust_info adjust on init.account_no =
                                                                         adjust.from_account_no
                             inner join bo_inner_account inn on inn.account_no =
                                                                         adjust.to_account_no
                             where adjust.status = 'pass'
                               and adjust.invoice_id is null
                               and adjust.adj_type = '1'
                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(to_date('""" + params.factDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')) sub
                     where sub.customer_id = """ + params.customerId
        adjustSql = adjustSql + " order by sub.sponsor_time asc"

        def listSql = "select t.* from (select t.*, rownum rn from (" + adjustSql + ") t) t where t.rn > " + listStart + " and t.rn <= " + listTo
        def listAdjust = dbBoss.rows(listSql)
        def count = dbBoss.rows("select count(*) as count from (" + adjustSql + ")")[0][0]

        [listAdjust: listAdjust, count: count]
    }

    // 保存调账记录
    def saveAdjustInfo = {

        def con = dataSource_boss.getConnection()
        con.setAutoCommit(false)
        def dbBoss =  new groovy.sql.Sql(con)

        try {

            def adjustUpdateSql = """update bo_account_adjust_info
                                   set choose_flag = """ + params.chooseFlag + """
                                 where id in (""" + params.ids + """)"""
            dbBoss.execute(adjustUpdateSql)
            dbBoss.commit()
            render "success"
        } catch (Exception e) {
            dbBoss.rollback()
            println "e.message:" + e.message
            render e.message
        } finally {
            dbBoss.close()
            con.close()
        }
    }

    // 生成发票
    def invoiceCreate = {

        def con = dataSource_boss.getConnection()
        con.setAutoCommit(false)
        def dbBoss =  new groovy.sql.Sql(con)

        def invoiceIds = ""
        def node = ""

        try {

            // 取得批次号
            def batchNoSql = "select (to_char(sysdate, 'yyyymmdd') || to_char(seq_invoice_batch.nextval, 'fm000000')) as batch_no from dual"
            def batchNo = dbBoss.rows(batchNoSql).get(0).get("batch_no")

            def infoArr = params.info.split("thisIsALine")
            def size = infoArr.size()
            for (i in 0..size-1) {
                def subInfoArr = infoArr[i].split("thisIsASubLine")

                // 取得发票余额表ID
                def balanceIdSql = "select seq_bo_invoice_balance.nextval as balance_id from dual"
                def balanceId = dbBoss.rows(balanceIdSql).get(0).get("balance_id")

                // 汇总数据写入余额表
                def balanceInsertSql = """insert into bo_customer_invoice_balance
                                                              (id,
                                                               batch_no,
                                                               customer_id,
                                                               customer_no,
                                                               date_end,
                                                               amt,
                                                               amt_adj,
                                                               amt_total,
                                                               adj_reason,
                                                               canceled)
                                                              (select """ + balanceId + """,""" + batchNo + """,
                                                                      customer_id,
                                                                      customer_no,
                                                                      to_date('""" + params.factDate + """', 'yyyy-mm-dd'),
                                                                      """ + subInfoArr[1] + """,
                                                                      """ + subInfoArr[2] + """,
                                                                      """ + subInfoArr[3] + """,
                                                                      '""" + String.valueOf(subInfoArr[4]).replace("adjust_reason_null_effect_AdjustReasonNullEffect", "") + """',
                                                                      0
                                                                 from bo_customer_invoice_init
                                                                where customer_id = """ + subInfoArr[0] + """)"""
                dbBoss.execute(balanceInsertSql)

                // 汇总数据与明细数据的关联信息写入明细表
                def detailUpdateSql = """update (select /*+ BYPASS_UJVC */ balance_id
                                              from bo_customer_invoice_detail detail
                                        inner join bo_customer_invoice_init init
                                                on init.customer_id = detail.customer_id
                                             where to_char(detail.bill_date, 'yyyy-mm-dd') >
                                                   to_char(init.last_inv_date, 'yyyy-mm-dd')
                                               and to_char(detail.bill_date, 'yyyy-mm-dd') <=
                                                   to_char(to_date('""" + params.factDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                               and detail.customer_id = """ + subInfoArr[0] + """)
                                       set balance_id = """ + balanceId
                dbBoss.execute(detailUpdateSql)

                // 写入发票信息表
                def invoiceInsertSql = """insert into bo_customer_invoice
                                                              (id,
                                                               batch_no,
                                                               customer_id,
                                                               customer_no,
                                                               customer_name,
                                                               customer_tax_no,
                                                               date_end,
                                                               invoice_amt,
                                                               invoice_no,
                                                               invoice_time,
                                                               invoice_input_time,
                                                               invoice_input_user,
                                                               customer_contact,
                                                               customer_contact_phone,
                                                               customer_location,
                                                               customer_zip_code,
                                                               express_name,
                                                               express_no,
                                                               express_input_time,
                                                               express_input_user,
                                                               status,
                                                               canceled_time,
                                                               canceled_reason,
                                                               last_inv_date)
                                                              (select """ + balanceId + """,
                                                                      """ + batchNo + """,
                                                                      customer_id,
                                                                      customer_no,
                                                                      customer_name,
                                                                      customer_tax_no,
                                                                      to_date('""" + params.factDate + """', 'yyyy-mm-dd'),
                                                                      """ + subInfoArr[3] + """,
                                                                      '',
                                                                      null,
                                                                      null,
                                                                      '',
                                                                      customer_contact,
                                                                      customer_contact_phone,
                                                                      customer_location,
                                                                      customer_zip_code,
                                                                      '天天快递',
                                                                      '',
                                                                      null,
                                                                      null,
                                                                      """ + params.saveFlag + """,
                                                                      null,
                                                                      '',
                                                                      last_inv_date
                                                                 from bo_customer_invoice_init
                                                                where customer_id = """ + subInfoArr[0] + """)"""
                dbBoss.execute(invoiceInsertSql)

                // 更新调账表关联发票信息
                def adjustUpdateSql1 = """update (select /*+ BYPASS_UJVC */ adjust.invoice_id,
                                                   adjust.choose_flag
                                              from bo_customer_service srv
                                             inner join bo_account_adjust_info adjust on srv.fee_acc_no =
                                                                                         adjust.to_account_no
                                             inner join bo_customer_invoice_init init on init.customer_id =
                                                                                         srv.customer_id
                                             where adjust.status = 'pass'
                                               and adjust.invoice_id is null
                                               and adjust.adj_type = '1'
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >
                                                   to_char(init.last_inv_date, 'yyyy-mm-dd')
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <=
                                                   to_char(to_date('""" + params.factDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                               and srv.customer_id = """ + subInfoArr[0] + """)
                                       set invoice_id = """ + balanceId + """,
                                           choose_flag = 1"""
                dbBoss.execute(adjustUpdateSql1)
                def adjustUpdateSql2 = """update (select /*+ BYPASS_UJVC */ adjust.invoice_id,
                                                   adjust.choose_flag
                                              from bo_customer_service srv
                                             inner join bo_account_adjust_info adjust on srv.fee_acc_no =
                                                                                         adjust.from_account_no
                                             inner join bo_customer_invoice_init init on init.customer_id =
                                                                                         srv.customer_id
                                             where adjust.status = 'pass'
                                               and adjust.invoice_id is null
                                               and adjust.adj_type = '1'
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >
                                                   to_char(init.last_inv_date, 'yyyy-mm-dd')
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <=
                                                   to_char(to_date('""" + params.factDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                               and srv.customer_id = """ + subInfoArr[0] + """)
                                       set invoice_id = """ + balanceId + """,
                                           choose_flag = 1"""
                dbBoss.execute(adjustUpdateSql2)
                def adjustUpdateSql3 = """update (select /*+ BYPASS_UJVC */ adjust.invoice_id
                                              from bo_customer_service srv
                                             inner join bo_account_adjust_info adjust on srv.fee_acc_no =
                                                                                         adjust.to_account_no
                                             inner join bo_customer_invoice_init init on init.customer_id =
                                                                                         srv.customer_id
                                             where adjust.status = 'pass'
                                               and adjust.invoice_id is null
                                               and adjust.adj_type = '1'
                                               and adjust.choose_flag = 1
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                                   to_char(init.init_date, 'yyyy-mm-dd')
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <=
                                                   to_char(init.last_inv_date, 'yyyy-mm-dd')
                                               and srv.customer_id = """ + subInfoArr[0] + """)
                                       set invoice_id = """ + balanceId
                dbBoss.execute(adjustUpdateSql3)
                def adjustUpdateSql4 = """update (select /*+ BYPASS_UJVC */ adjust.invoice_id
                                              from bo_customer_service srv
                                             inner join bo_account_adjust_info adjust on srv.fee_acc_no =
                                                                                         adjust.from_account_no
                                             inner join bo_customer_invoice_init init on init.customer_id =
                                                                                         srv.customer_id
                                             where adjust.status = 'pass'
                                               and adjust.invoice_id is null
                                               and adjust.adj_type = '1'
                                               and adjust.choose_flag = 1
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                                   to_char(init.init_date, 'yyyy-mm-dd')
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <=
                                                   to_char(init.last_inv_date, 'yyyy-mm-dd')
                                               and srv.customer_id = """ + subInfoArr[0] + """)
                                       set invoice_id = """ + balanceId
                dbBoss.execute(adjustUpdateSql4)
                def adjustUpdateSql5 = """update (select /*+ BYPASS_UJVC */ adjust.invoice_id,
                                                   adjust.choose_flag
                                              from bo_customer_invoice_init init
                                             inner join bo_account_adjust_info adjust on init.account_no =
                                                                                         adjust.to_account_no
                                             inner join bo_inner_account inn on inn.account_no =
                                                                                         adjust.from_account_no
                                             where adjust.status = 'pass'
                                               and adjust.invoice_id is null
                                               and adjust.adj_type = '1'
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >
                                                   to_char(init.last_inv_date, 'yyyy-mm-dd')
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <=
                                                   to_char(to_date('""" + params.factDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                               and init.customer_id = """ + subInfoArr[0] + """)
                                       set invoice_id = """ + balanceId + """,
                                           choose_flag = 1"""
                dbBoss.execute(adjustUpdateSql5)
                def adjustUpdateSql6 = """update (select /*+ BYPASS_UJVC */ adjust.invoice_id,
                                                   adjust.choose_flag
                                              from bo_customer_invoice_init init
                                             inner join bo_account_adjust_info adjust on init.account_no =
                                                                                         adjust.from_account_no
                                             inner join bo_inner_account inn on inn.account_no =
                                                                                         adjust.to_account_no
                                             where adjust.status = 'pass'
                                               and adjust.invoice_id is null
                                               and adjust.adj_type = '1'
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >
                                                   to_char(init.last_inv_date, 'yyyy-mm-dd')
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <=
                                                   to_char(to_date('""" + params.factDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                               and init.customer_id = """ + subInfoArr[0] + """)
                                       set invoice_id = """ + balanceId + """,
                                           choose_flag = 1"""
                dbBoss.execute(adjustUpdateSql6)
                def adjustUpdateSql7 = """update (select /*+ BYPASS_UJVC */ adjust.invoice_id
                                              from bo_customer_invoice_init init
                                             inner join bo_account_adjust_info adjust on init.account_no =
                                                                                         adjust.to_account_no
                                             inner join bo_inner_account inn on inn.account_no =
                                                                                         adjust.from_account_no
                                             where adjust.status = 'pass'
                                               and adjust.invoice_id is null
                                               and adjust.adj_type = '1'
                                               and adjust.choose_flag = 1
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                                   to_char(init.init_date, 'yyyy-mm-dd')
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <=
                                                   to_char(init.last_inv_date, 'yyyy-mm-dd')
                                               and init.customer_id = """ + subInfoArr[0] + """)
                                       set invoice_id = """ + balanceId
                dbBoss.execute(adjustUpdateSql7)
                def adjustUpdateSql8 = """update (select /*+ BYPASS_UJVC */ adjust.invoice_id
                                              from bo_customer_invoice_init init
                                             inner join bo_account_adjust_info adjust on init.account_no =
                                                                                         adjust.from_account_no
                                             inner join bo_inner_account inn on inn.account_no =
                                                                                         adjust.to_account_no
                                             where adjust.status = 'pass'
                                               and adjust.invoice_id is null
                                               and adjust.adj_type = '1'
                                               and adjust.choose_flag = 1
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                                   to_char(init.init_date, 'yyyy-mm-dd')
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') <=
                                                   to_char(init.last_inv_date, 'yyyy-mm-dd')
                                               and init.customer_id = """ + subInfoArr[0] + """)
                                       set invoice_id = """ + balanceId
                dbBoss.execute(adjustUpdateSql8)
                def adjustUpdateSql9 = """update (select /*+ BYPASS_UJVC */ adjust.invoice_id
                                              from bo_customer_service srv
                                             inner join bo_account_adjust_info adjust on srv.fee_acc_no =
                                                                                         adjust.to_account_no
                                             inner join bo_customer_invoice_init init on init.customer_id =
                                                                                         srv.customer_id
                                             where adjust.status = 'pass'
                                               and adjust.invoice_id is null
                                               and adjust.adj_type = '1'
                                               and adjust.choose_flag = 1
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(to_date('""" + params.factDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                               and srv.customer_id = """ + subInfoArr[0] + """)
                                       set invoice_id = """ + balanceId
                dbBoss.execute(adjustUpdateSql9)
                def adjustUpdateSql10 = """update (select /*+ BYPASS_UJVC */ adjust.invoice_id
                                              from bo_customer_service srv
                                             inner join bo_account_adjust_info adjust on srv.fee_acc_no =
                                                                                         adjust.from_account_no
                                             inner join bo_customer_invoice_init init on init.customer_id =
                                                                                         srv.customer_id
                                             where adjust.status = 'pass'
                                               and adjust.invoice_id is null
                                               and adjust.adj_type = '1'
                                               and adjust.choose_flag = 1
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(to_date('""" + params.factDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                               and srv.customer_id = """ + subInfoArr[0] + """)
                                       set invoice_id = """ + balanceId
                dbBoss.execute(adjustUpdateSql10)
                def adjustUpdateSql11 = """update (select /*+ BYPASS_UJVC */ adjust.invoice_id
                                              from bo_customer_invoice_init init
                                             inner join bo_account_adjust_info adjust on init.account_no =
                                                                                         adjust.to_account_no
                                             inner join bo_inner_account inn on inn.account_no =
                                                                                         adjust.from_account_no
                                             where adjust.status = 'pass'
                                               and adjust.invoice_id is null
                                               and adjust.adj_type = '1'
                                               and adjust.choose_flag = 1
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(to_date('""" + params.factDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                               and init.customer_id = """ + subInfoArr[0] + """)
                                       set invoice_id = """ + balanceId
                dbBoss.execute(adjustUpdateSql11)
                def adjustUpdateSql12 = """update (select /*+ BYPASS_UJVC */ adjust.invoice_id
                                              from bo_customer_invoice_init init
                                             inner join bo_account_adjust_info adjust on init.account_no =
                                                                                         adjust.from_account_no
                                             inner join bo_inner_account inn on inn.account_no =
                                                                                         adjust.to_account_no
                                             where adjust.status = 'pass'
                                               and adjust.invoice_id is null
                                               and adjust.adj_type = '1'
                                               and adjust.choose_flag = 1
                                               and to_char(adjust.sponsor_time, 'yyyy-mm-dd') >=
                                   to_char(to_date('""" + params.factDate + """', 'yyyy-mm-dd'), 'yyyy-mm-dd')
                                               and init.customer_id = """ + subInfoArr[0] + """)
                                       set invoice_id = """ + balanceId
                dbBoss.execute(adjustUpdateSql12)

                // 更新发票初始化表
                def initUpdateSql = "update bo_customer_invoice_init set last_inv_date = to_date('" + params.factDate + "', 'yyyy-mm-dd') where customer_id = " + subInfoArr[0]
                dbBoss.execute(initUpdateSql)

                invoiceIds = invoiceIds + node + balanceId
                node = ","
            }
            dbBoss.commit()
        } catch (Exception e) {
            dbBoss.rollback()
            println "e.message:" + e.message
            render e.message
        } finally {
            dbBoss.close()
            con.close()
        }

        if (String.valueOf(params.saveFlag).equals("1")) {
            redirect(action: "invoiceOutstandingShow", params: params)
        } else {

            params.max = 50000
            params.offset = 0
            def db = new Sql(dataSource_boss)
            def downLoadSql = """select t.batch_no,
                                   t.customer_no,
                                   t.customer_name,
                                   t.customer_tax_no,
                                   to_char(t.date_end, 'yyyy-mm-dd') as date_end,
                                   to_char(t.invoice_amt, 'fm999,999,999,999,999,990.00') as nvoice_amt,
                                   t.customer_contact,
                                   t.customer_contact_phone,
                                   t.customer_location,
                                   t.customer_zip_code
                              from bo_customer_invoice t
                             where id in (""" + invoiceIds + """)
                             order by t.customer_name asc"""
            def infoList = db.rows(downLoadSql)

            def filename = 'EXCEL-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.contentType = "application/x-rarx-rar-compressed"
            response.setCharacterEncoding("UTF-8")
            render(template: "invoiceInfolist", model: [infolist: infoList])
        }
    }

    // 发票信息查询
    def invoiceInfoShow = {

        def dbBoss =  new groovy.sql.Sql(dataSource_boss)

        params.max = Math.min(params.max ? params.int('max') : 30, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def listStart = params.offset
        def listTo = listStart + params.max
        def condition = ""
        def invDate = ""

        if ((params.initFlag == null) ||(params.initFlag.equals(""))) {
            Calendar calendar = Calendar.getInstance()
            calendar.add(Calendar.MONTH, -1)
            int day = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
            int year = calendar.get(Calendar.YEAR)
            int month = calendar.get(Calendar.MONTH) + 1
            invDate = year + "-" + month + "-" + day
            params.factDate = invDate
            if (month < 10) {
                params.startTime = year + "-" + "0" + month
            } else {
                params.startTime = year + "-" + month
            }
            condition = condition + " and to_char(info.date_end, 'yyyy-mm') = to_char(to_date('" + invDate + "', 'yyyy-mm-dd'), 'yyyy-mm')"
            params.initFlag = 1
        } else if ((params.startTime == null) ||(params.startTime.equals(""))) {
        } else if (params.dateFlag.equals("0")) {
            def startTime = String.valueOf(params.startTime)
            Calendar calendar = Calendar.getInstance()
            calendar.set(Integer.valueOf(startTime.substring(0, 4)), Integer.valueOf(startTime.substring(5, 7)), 1)
            calendar.add(Calendar.MONTH, -1)
            int day = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
            int year = calendar.get(Calendar.YEAR)
            int month = calendar.get(Calendar.MONTH) + 1
            invDate = year + "-" + month + "-" + day
            params.factDate = invDate
            condition = condition + " and to_char(info.date_end, 'yyyy-mm') = to_char(to_date('" + invDate + "', 'yyyy-mm-dd'), 'yyyy-mm')"
        } else {
            invDate = String.valueOf(params.startTime)
            params.factDate = invDate
            condition = condition + " and info.date_end = to_date('" + invDate + "', 'yyyy-mm-dd')"
        }

        if ((params.batchNo != null)&&(!params.batchNo.equals(""))) {
            condition = condition + " and info.batch_no = '" + params.batchNo + "'"
        }
        if ((params.customerNoStr != null)&&(!params.customerNoStr.equals(""))) {
            def customerNos = String.valueOf(params.customerNoStr).trim().replaceAll("( )+", " ").replaceAll(" ", ",")
            params.customerNoStr = customerNos

            if ((customerNos != null)&&(!customerNos.equals(""))) {
                customerNos = "'" + customerNos.replaceAll(",", "','") + "'"
                condition = condition + " and info.customer_no in (" + customerNos + ")"
            }
        }
        if ((params.customerName != null)&&(!params.customerName.equals(""))) {
            condition = condition + " and info.customer_name like '%" + params.customerName + "%'"
        }
        if ((params.minAmount != null)&&(!params.minAmount.equals(""))) {
            condition = condition + " and info.invoice_amt >= " + params.minAmount
        }
        if ((params.maxAmount != null)&&(!params.maxAmount.equals(""))) {
            condition = condition + " and info.invoice_amt <= " + params.maxAmount
        }
        if ((params.status == null)||(params.status.equals(""))) {
            params.status = 1
        }
        params.factStatus = params.status

        def cmSql = """select info.id,
                           info.batch_no,
                           info.customer_id,
                           info.customer_no,
                           info.customer_name,
                           info.customer_tax_no,
                           to_char(info.date_end, 'yyyy-mm-dd') as date_end,
                           to_char(info.invoice_amt, 'fm999,999,999,999,999,990.00') as nvoice_amt,
                           info.customer_contact,
                           info.customer_contact_phone,
                           info.customer_location,
                           info.customer_zip_code,
                           to_char(info.status) as status,
                           info.invoice_no,
                           to_char(info.invoice_time, 'yyyy-mm-dd') as invoice_time,
                           to_char(info.invoice_input_time, 'yyyy-mm-dd hh24:mi:ss') as invoice_input_time,
                           info.invoice_input_user,
                           info.express_name,
                           info.express_no,
                           to_char(info.express_input_time, 'yyyy-mm-dd hh24:mi:ss') as express_input_time,
                           info.express_input_user,
                           info.canceled_reason,
                           to_char(info.canceled_time, 'yyyy-mm-dd hh24:mi:ss') as canceled_time,
                           to_char(bal.amt, 'fm999,999,999,999,999,990.00') as amt,
                           to_char(bal.amt_adj, 'fm999,999,999,999,999,990.00') as amt_adj,
                           to_char(bal.amt_total, 'fm999,999,999,999,999,990.00') as amt_total,
                           bal.adj_reason,
                           ope1.name invoice_input_name,
                           ope2.name express_input_name
                      from bo_customer_invoice info
                inner join bo_customer_invoice_balance bal on bal.id = info.id
                 left join bo_operator ope1 on ope1.id = info.invoice_input_user
                 left join bo_operator ope2 on ope2.id = info.express_input_user
                     where to_char(info.status) = '""" + params.status + """'"""
        cmSql = cmSql + condition + " order by info.customer_name asc"

        def listSql = "select t.* from (select t.*, rownum rn from (" + cmSql + ") t) t where t.rn > " + listStart + " and t.rn <= " + listTo
        def listCm = dbBoss.rows(listSql)
        def count = dbBoss.rows("select count(*) as count from (" + cmSql + ")")[0][0]

        [listCm: listCm, count: count]
    }

    // 发票下载
    def invoiceDown = {

        params.max = 50000
        params.offset = 0

        def con = dataSource_boss.getConnection()
        con.setAutoCommit(false)
        def dbBoss =  new groovy.sql.Sql(con)

        try {
            def downLoadSql = """select info.id,
                                   info.batch_no,
                                   info.customer_id,
                                   info.customer_no,
                                   info.customer_name,
                                   info.customer_tax_no,
                                   to_char(info.date_end, 'yyyy-mm-dd') as date_end,
                                   to_char(info.invoice_amt, 'fm999,999,999,999,999,990.00') as nvoice_amt,
                                   info.customer_contact,
                                   info.customer_contact_phone,
                                   info.customer_location,
                                   info.customer_zip_code,
                                   to_char(info.status) as status,
                                   info.invoice_no,
                                   to_char(info.invoice_time, 'yyyy-mm-dd') as invoice_time,
                                   to_char(info.invoice_input_time, 'yyyy-mm-dd hh24:mi:ss') as invoice_input_time,
                                   info.invoice_input_user,
                                   info.express_no,
                                   info.express_name,
                                   to_char(info.express_input_time, 'yyyy-mm-dd hh24:mi:ss') as express_input_time,
                                   info.express_input_user,
                                   info.canceled_reason,
                                   to_char(info.canceled_time, 'yyyy-mm-dd hh24:mi:ss') as canceled_time,
                                   to_char(bal.amt, 'fm999,999,999,999,999,990.00') as amt,
                                   to_char(bal.amt_adj, 'fm999,999,999,999,999,990.00') as amt_adj,
                                   to_char(bal.amt_total, 'fm999,999,999,999,999,990.00') as amt_total,
                                   bal.adj_reason,
                                   ope1.name invoice_input_name,
                                   ope2.name express_input_name
                              from bo_customer_invoice info
                             inner join bo_customer_invoice_balance bal on bal.id = info.id
                              left join bo_operator ope1 on ope1.id = info.invoice_input_user
                              left join bo_operator ope2 on ope2.id = info.express_input_user
                             where info.id in (""" + params.info + """)
                             order by info.customer_name asc"""

            def infoList = dbBoss.rows(downLoadSql)

            if (String.valueOf(params.factStatus).equals("1")) {
                def updateSql = "update bo_customer_invoice set status = '21' where id in (" + params.info + ") and status = '1'"
                dbBoss.execute(updateSql)
            }
            dbBoss.commit()

            def filename = 'EXCEL-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.contentType = "application/x-rarx-rar-compressed"
            response.setCharacterEncoding("UTF-8")
            render(template: "invoiceTotalInfolist", model: [infolist: infoList])
        } catch (Exception e) {
            dbBoss.rollback()
            println "e.message:" + e.message
            render e.message
        } finally {
            dbBoss.close()
            con.close()
        }
    }

    // 发票手续费明细页面
    def invoiceDetailInfo = {

        def dbBoss =  new groovy.sql.Sql(dataSource_boss)

        // 数据检索
        params.max = Math.min(params.max ? params.int('max') : 5, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def listStart = params.offset
        def listTo = listStart + params.max

        def detailList = ""
        def count = 0

        def infoSql = """select info.id,
                           info.batch_no,
                           info.customer_id,
                           info.customer_no,
                           info.customer_name,
                           info.customer_tax_no,
                           to_char(info.date_end, 'yyyy-mm-dd') as date_end,
                           to_char(info.invoice_amt, 'fm999,999,999,999,999,990.00') as nvoice_amt,
                           info.customer_contact,
                           info.customer_contact_phone,
                           info.customer_location,
                           info.customer_zip_code,
                           to_char(info.status) as status,
                           info.invoice_no,
                           to_char(info.invoice_time, 'yyyy-mm-dd') as invoice_time,
                           to_char(info.invoice_input_time, 'yyyy-mm-dd hh24:mi:ss') as invoice_input_time,
                           info.invoice_input_user,
                           info.express_name,
                           info.express_no,
                           to_char(info.express_input_time, 'yyyy-mm-dd hh24:mi:ss') as express_input_time,
                           info.express_input_user,
                           info.canceled_reason,
                           to_char(info.canceled_time, 'yyyy-mm-dd hh24:mi:ss') as canceled_time,
                           to_char(bal.amt, 'fm999,999,999,999,999,990.00') as amt,
                           to_char(bal.amt_adj, 'fm999,999,999,999,999,990.00') as amt_adj,
                           to_char(bal.amt_total, 'fm999,999,999,999,999,990.00') as amt_total,
                           bal.adj_reason,
                           ope1.name invoice_input_name,
                           ope2.name express_input_name
                      from bo_customer_invoice info
                inner join bo_customer_invoice_balance bal on bal.id = info.id
                 left join bo_operator ope1 on ope1.id = info.invoice_input_user
                 left join bo_operator ope2 on ope2.id = info.express_input_user
                     where info.id = """ + params.invoice_id

        def infoList = dbBoss.rows(infoSql)
        if (infoList.size() > 0) {
            def info = infoList.get(0)
            // 客户信息
            params.customer_no = info.get("customer_no")
            params.customer_name = info.get("customer_name")
            params.customer_tax_no = info.get("customer_tax_no")
            params.customer_contact = info.get("customer_contact")
            params.customer_contact_phone = info.get("customer_contact_phone")
            params.customer_location = info.get("customer_location")
            params.customer_zip_code = info.get("customer_zip_code")
            // 发票信息
            params.batch_no = info.get("batch_no")
            params.invoice_no = info.get("invoice_no")
            params.invoice_time = info.get("invoice_time")
            params.status = info.get("status")
            params.date_end = info.get("date_end")
            params.amt = info.get("amt")
            params.nvoice_amt = info.get("nvoice_amt")
            params.amt_adj = info.get("amt_adj")
            params.adj_reason = info.get("adj_reason")
            params.invoice_input_time = info.get("invoice_input_time")
            params.invoice_input_name = info.get("invoice_input_name")
            params.canceled_time = info.get("canceled_time")
            params.canceled_reason = info.get("canceled_reason")
            // 快递信息
            params.express_name = info.get("express_name")
            params.express_no = info.get("express_no")
            params.express_input_time = info.get("express_input_time")
            params.express_input_name = info.get("express_input_name")

            // 明细数据
            def detailSql = """select del.bill_type,
                               del.fee_type,
                               del.bill_id,
                               del.bill_no,
                               to_char(del.bill_date, 'yyyy-mm-dd') as bill_date,
                               to_char(del.bill_amount, 'fm999,999,999,999,999,990.00') as bill_amount
                          from bo_customer_invoice_detail del
                         where del.balance_id = """ + params.invoice_id + """
                         union all
                        select 4 as bill_type,
                                null as fee_type,
                                adj.id as bill_id,
                                null as bill_no,
                                to_char(adj.sponsor_time, 'yyyy-mm-dd') as bill_date,
                                to_char(-adj.adjust_amount/100, 'fm999,999,999,999,999,990.00') as bill_amount
                         from bo_account_adjust_info adj
                         inner join bo_customer_service srv on srv.fee_acc_no = adj.to_account_no
                         inner join bo_customer_invoice_init init on init.customer_id = srv.customer_id
                         where adj.invoice_id = """ + params.invoice_id + """
                         union all
                        select 4 as bill_type,
                                null as fee_type,
                                adj.id as bill_id,
                                null as bill_no,
                                to_char(adj.sponsor_time, 'yyyy-mm-dd') as bill_date,
                                to_char(adj.adjust_amount/100, 'fm999,999,999,999,999,990.00') as bill_amount
                         from bo_account_adjust_info adj
                         inner join bo_customer_service srv on srv.fee_acc_no = adj.from_account_no
                         inner join bo_customer_invoice_init init on init.customer_id = srv.customer_id
                         where adj.invoice_id = """ + params.invoice_id + """
                         union all
                        select 4 as bill_type,
                                null as fee_type,
                                adj.id as bill_id,
                                null as bill_no,
                                to_char(adj.sponsor_time, 'yyyy-mm-dd') as bill_date,
                                to_char(-adj.adjust_amount/100, 'fm999,999,999,999,999,990.00') as bill_amount
                         from bo_account_adjust_info adj
                         inner join bo_customer_invoice_init init on init.account_no = adj.to_account_no
                         inner join bo_inner_account inn on inn.account_no = adj.from_account_no
                         where adj.invoice_id = """ + params.invoice_id + """
                         union all
                        select 4 as bill_type,
                                null as fee_type,
                                adj.id as bill_id,
                                null as bill_no,
                                to_char(adj.sponsor_time, 'yyyy-mm-dd') as bill_date,
                                to_char(adj.adjust_amount/100, 'fm999,999,999,999,999,990.00') as bill_amount
                         from bo_account_adjust_info adj
                         inner join bo_customer_invoice_init init on init.account_no = adj.from_account_no
                         inner join bo_inner_account inn on inn.account_no = adj.to_account_no
                         where adj.invoice_id = """ + params.invoice_id
            detailSql = detailSql + " order by bill_date asc"

            def listSql = "select t.* from (select t.*, rownum rn from (" + detailSql + ") t) t where t.rn > " + listStart + " and t.rn <= " + listTo
            detailList = dbBoss.rows(listSql)
            count = dbBoss.rows("select count(*) as count from (" + detailSql + ")")[0][0]
        }

        [detailList: detailList, count: count, params:params]
    }

    // 发票手续费明细下载
    def detailDown = {

        def dbBoss =  new groovy.sql.Sql(dataSource_boss)

        // 明细数据
        def detailSql = """select del.bill_type,
                           del.fee_type,
                           del.bill_id,
                           del.bill_no,
                           to_char(del.bill_date, 'yyyy-mm-dd') as bill_date,
                           to_char(del.bill_amount, 'fm999,999,999,999,999,990.00') as bill_amount
                      from bo_customer_invoice_detail del
                     where del.balance_id = """ + params.invoice_id + """
                     union all
                    select 4 as bill_type,
                            null as fee_type,
                            adj.id as bill_id,
                            null as bill_no,
                            to_char(adj.sponsor_time, 'yyyy-mm-dd') as bill_date,
                            to_char(adj.adjust_amount/100, 'fm999,999,999,999,999,990.00') as bill_amount
                     from bo_account_adjust_info adj
                     inner join bo_customer_service srv on srv.fee_acc_no = adj.to_account_no
                     inner join bo_customer_invoice_init init on init.customer_id = srv.customer_id
                     where adj.invoice_id = """ + params.invoice_id + """
                     union all
                    select 4 as bill_type,
                            null as fee_type,
                            adj.id as bill_id,
                            null as bill_no,
                            to_char(adj.sponsor_time, 'yyyy-mm-dd') as bill_date,
                            to_char(-adj.adjust_amount/100, 'fm999,999,999,999,999,990.00') as bill_amount
                     from bo_account_adjust_info adj
                     inner join bo_customer_service srv on srv.fee_acc_no = adj.from_account_no
                     inner join bo_customer_invoice_init init on init.customer_id = srv.customer_id
                     where adj.invoice_id = """ + params.invoice_id + """
                     union all
                    select 4 as bill_type,
                            null as fee_type,
                            adj.id as bill_id,
                            null as bill_no,
                            to_char(adj.sponsor_time, 'yyyy-mm-dd') as bill_date,
                            to_char(adj.adjust_amount/100, 'fm999,999,999,999,999,990.00') as bill_amount
                     from bo_account_adjust_info adj
                     inner join bo_customer_invoice_init init on init.account_no = adj.to_account_no
                     inner join bo_inner_account inn on inn.account_no = adj.from_account_no
                     where adj.invoice_id = """ + params.invoice_id + """
                     union all
                    select 4 as bill_type,
                            null as fee_type,
                            adj.id as bill_id,
                            null as bill_no,
                            to_char(adj.sponsor_time, 'yyyy-mm-dd') as bill_date,
                            to_char(-adj.adjust_amount/100, 'fm999,999,999,999,999,990.00') as bill_amount
                     from bo_account_adjust_info adj
                     inner join bo_customer_invoice_init init on init.account_no = adj.from_account_no
                     inner join bo_inner_account inn on inn.account_no = adj.to_account_no
                     where adj.invoice_id = """ + params.invoice_id
        detailSql = detailSql + " order by bill_date asc"
        def detailList = dbBoss.rows(detailSql)

        def filename = 'EXCEL-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "invoiceDetailInfolist", model: [infolist: detailList])
    }

    // 发票信息录入 查询
    def invoiceInfoEntering = {

        def dbBoss =  new groovy.sql.Sql(dataSource_boss)

        params.max = Math.min(params.max ? params.int('max') : 30, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def listStart = params.offset
        def listTo = listStart + params.max
        def condition = ""
        def invDate = ""

        if ((params.initFlag == null) ||(params.initFlag.equals(""))) {
            Calendar calendar = Calendar.getInstance()
            calendar.add(Calendar.MONTH, -1)
            int day = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
            int year = calendar.get(Calendar.YEAR)
            int month = calendar.get(Calendar.MONTH) + 1
            invDate = year + "-" + month + "-" + day
            params.factDate = invDate
            if (month < 10) {
                params.startTime = year + "-" + "0" + month
            } else {
                params.startTime = year + "-" + month
            }
            condition = condition + " and to_char(info.date_end, 'yyyy-mm') = to_char(to_date('" + invDate + "', 'yyyy-mm-dd'), 'yyyy-mm')"
            params.initFlag = 1
        } else if ((params.startTime == null) ||(params.startTime.equals(""))) {
        } else if (params.dateFlag.equals("0")) {
            def startTime = String.valueOf(params.startTime)
            Calendar calendar = Calendar.getInstance()
            calendar.set(Integer.valueOf(startTime.substring(0, 4)), Integer.valueOf(startTime.substring(5, 7)), 1)
            calendar.add(Calendar.MONTH, -1)
            int day = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
            int year = calendar.get(Calendar.YEAR)
            int month = calendar.get(Calendar.MONTH) + 1
            invDate = year + "-" + month + "-" + day
            params.factDate = invDate
            condition = condition + " and to_char(info.date_end, 'yyyy-mm') = to_char(to_date('" + invDate + "', 'yyyy-mm-dd'), 'yyyy-mm')"
        } else {
            invDate = String.valueOf(params.startTime)
            params.factDate = invDate
            condition = condition + " and info.date_end = to_date('" + invDate + "', 'yyyy-mm-dd')"
        }

        if ((params.batchNo != null)&&(!params.batchNo.equals(""))) {
            condition = condition + " and info.batch_no = '" + params.batchNo + "'"
        }
        if ((params.customerNoStr != null)&&(!params.customerNoStr.equals(""))) {
            def customerNos = String.valueOf(params.customerNoStr).trim().replaceAll("( )+", " ").replaceAll(" ", ",")
            params.customerNoStr = customerNos

            if ((customerNos != null)&&(!customerNos.equals(""))) {
                customerNos = "'" + customerNos.replaceAll(",", "','") + "'"
                condition = condition + " and info.customer_no in (" + customerNos + ")"
            }
        }
        if ((params.customerName != null)&&(!params.customerName.equals(""))) {
            condition = condition + " and info.customer_name like '%" + params.customerName + "%'"
        }
        if ((params.minAmount != null)&&(!params.minAmount.equals(""))) {
            condition = condition + " and info.invoice_amt >= " + params.minAmount
        }
        if ((params.maxAmount != null)&&(!params.maxAmount.equals(""))) {
            condition = condition + " and info.invoice_amt <= " + params.maxAmount
        }

        def cmSql = """select info.id,
                           info.batch_no,
                           info.customer_id,
                           info.customer_no,
                           info.customer_name,
                           info.customer_tax_no,
                           to_char(info.date_end, 'yyyy-mm-dd') as date_end,
                           to_char(info.invoice_amt, 'fm999,999,999,999,999,990.00') as nvoice_amt,
                           info.customer_contact,
                           info.customer_contact_phone,
                           info.customer_location,
                           info.customer_zip_code,
                           to_char(info.status) as status,
                           info.invoice_no,
                           to_char(info.invoice_time, 'yyyy-mm-dd') as invoice_time,
                           to_char(info.invoice_input_time, 'yyyy-mm-dd hh24:mi:ss') as invoice_input_time,
                           info.invoice_input_user,
                           info.express_name,
                           info.express_no,
                           to_char(info.express_input_time, 'yyyy-mm-dd hh24:mi:ss') as express_input_time,
                           info.express_input_user,
                           info.canceled_reason,
                           to_char(info.canceled_time, 'yyyy-mm-dd hh24:mi:ss') as canceled_time,
                           to_char(bal.amt, 'fm999,999,999,999,999,990.00') as amt,
                           to_char(bal.amt_adj, 'fm999,999,999,999,999,990.00') as amt_adj,
                           to_char(bal.amt_total, 'fm999,999,999,999,999,990.00') as amt_total,
                           bal.adj_reason,
                           ope1.name invoice_input_name,
                           ope2.name express_input_name
                      from bo_customer_invoice info
                inner join bo_customer_invoice_balance bal on bal.id = info.id
                 left join bo_operator ope1 on ope1.id = info.invoice_input_user
                 left join bo_operator ope2 on ope2.id = info.express_input_user
                     where (to_char(info.status) = '21' or to_char(info.status) = '32')"""
        cmSql = cmSql + condition + " order by info.customer_name asc"

        def listSql = "select t.* from (select t.*, rownum rn from (" + cmSql + ") t) t where t.rn > " + listStart + " and t.rn <= " + listTo
        def listCm = dbBoss.rows(listSql)
        def count = dbBoss.rows("select count(*) as count from (" + cmSql + ")")[0][0]

        [listCm: listCm, count: count]
    }

    // 发票信息录入
    def invoiceInfoEnterSave = {

        def con = dataSource_boss.getConnection()
        con.setAutoCommit(false)
        def dbBoss =  new groovy.sql.Sql(con)

        try {
            def infoArr = params.info.split("thisIsALine")
            def size = infoArr.size()
            for (i in 0..size-1) {
                def subInfoArr = infoArr[i].split("thisIsASubLine")

                def invoiceUpdateSql = """update bo_customer_invoice
                               set invoice_no = '""" + String.valueOf(subInfoArr[1]).replaceAll(",", "") + """',
                                   invoice_time = to_date('""" + subInfoArr[2] + """', 'yyyy-mm-dd'),
                                   invoice_input_time = sysdate,
                                   invoice_input_user = """ + session.op.id + """,
                                   status = 32
                             where id = """ + subInfoArr[0]
                dbBoss.execute(invoiceUpdateSql)
            }
            dbBoss.commit()
        } catch (Exception e) {
            dbBoss.rollback()
            println "e.message:" + e.message
            render e.message
        } finally {
            dbBoss.close()
            con.close()
        }

        redirect(action: "invoiceInfoEntering", params: params)
    }

    // 检查发票号唯一性
    def chkInvoiceNo = {

        def dbBoss = new groovy.sql.Sql(dataSource_boss)
        def result = "success"

        def chkSql = """select id,
                            invoice_no
                       from bo_customer_invoice
                      where invoice_no = '""" + params.invoiceNo + """'
                        and id <> """ + params.id

        def chkList = dbBoss.rows(chkSql)
        if (chkList.size() > 0) {
            result = "fail"
        }
        render result
    }

    // 快递信息录入 查询
    def invoiceInfoExpressing = {

        def dbBoss =  new groovy.sql.Sql(dataSource_boss)

        params.max = Math.min(params.max ? params.int('max') : 30, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def listStart = params.offset
        def listTo = listStart + params.max
        def condition = ""
        def invDate = ""

        if ((params.initFlag == null) ||(params.initFlag.equals(""))) {
            Calendar calendar = Calendar.getInstance()
            calendar.add(Calendar.MONTH, -1)
            int day = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
            int year = calendar.get(Calendar.YEAR)
            int month = calendar.get(Calendar.MONTH) + 1
            invDate = year + "-" + month + "-" + day
            params.factDate = invDate
            if (month < 10) {
                params.startTime = year + "-" + "0" + month
            } else {
                params.startTime = year + "-" + month
            }
            condition = condition + " and to_char(info.date_end, 'yyyy-mm') = to_char(to_date('" + invDate + "', 'yyyy-mm-dd'), 'yyyy-mm')"
            params.initFlag = 1
        } else if ((params.startTime == null) ||(params.startTime.equals(""))) {
        } else if (params.dateFlag.equals("0")) {
            def startTime = String.valueOf(params.startTime)
            Calendar calendar = Calendar.getInstance()
            calendar.set(Integer.valueOf(startTime.substring(0, 4)), Integer.valueOf(startTime.substring(5, 7)), 1)
            calendar.add(Calendar.MONTH, -1)
            int day = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
            int year = calendar.get(Calendar.YEAR)
            int month = calendar.get(Calendar.MONTH) + 1
            invDate = year + "-" + month + "-" + day
            params.factDate = invDate
            condition = condition + " and to_char(info.date_end, 'yyyy-mm') = to_char(to_date('" + invDate + "', 'yyyy-mm-dd'), 'yyyy-mm')"
        } else {
            invDate = String.valueOf(params.startTime)
            params.factDate = invDate
            condition = condition + " and info.date_end = to_date('" + invDate + "', 'yyyy-mm-dd')"
        }

        if ((params.batchNo != null)&&(!params.batchNo.equals(""))) {
            condition = condition + " and info.batch_no = '" + params.batchNo + "'"
        }
        if ((params.customerNoStr != null)&&(!params.customerNoStr.equals(""))) {
            def customerNos = String.valueOf(params.customerNoStr).trim().replaceAll("( )+", " ").replaceAll(" ", ",")
            params.customerNoStr = customerNos

            if ((customerNos != null)&&(!customerNos.equals(""))) {
                customerNos = "'" + customerNos.replaceAll(",", "','") + "'"
                condition = condition + " and info.customer_no in (" + customerNos + ")"
            }
        }
        if ((params.customerName != null)&&(!params.customerName.equals(""))) {
            condition = condition + " and info.customer_name like '%" + params.customerName + "%'"
        }
        if ((params.minAmount != null)&&(!params.minAmount.equals(""))) {
            condition = condition + " and info.invoice_amt >= " + params.minAmount
        }
        if ((params.maxAmount != null)&&(!params.maxAmount.equals(""))) {
            condition = condition + " and info.invoice_amt <= " + params.maxAmount
        }

        def cmSql = """select info.id,
                           info.batch_no,
                           info.customer_id,
                           info.customer_no,
                           info.customer_name,
                           info.customer_tax_no,
                           to_char(info.date_end, 'yyyy-mm-dd') as date_end,
                           to_char(info.invoice_amt, 'fm999,999,999,999,999,990.00') as nvoice_amt,
                           info.customer_contact,
                           info.customer_contact_phone,
                           info.customer_location,
                           info.customer_zip_code,
                           to_char(info.status) as status,
                           info.invoice_no,
                           to_char(info.invoice_time, 'yyyy-mm-dd') as invoice_time,
                           to_char(info.invoice_input_time, 'yyyy-mm-dd hh24:mi:ss') as invoice_input_time,
                           info.invoice_input_user,
                           info.express_name,
                           info.express_no,
                           to_char(info.express_input_time, 'yyyy-mm-dd hh24:mi:ss') as express_input_time,
                           info.express_input_user,
                           info.canceled_reason,
                           to_char(info.canceled_time, 'yyyy-mm-dd hh24:mi:ss') as canceled_time,
                           to_char(bal.amt, 'fm999,999,999,999,999,990.00') as amt,
                           to_char(bal.amt_adj, 'fm999,999,999,999,999,990.00') as amt_adj,
                           to_char(bal.amt_total, 'fm999,999,999,999,999,990.00') as amt_total,
                           bal.adj_reason,
                           ope1.name invoice_input_name,
                           ope2.name express_input_name
                      from bo_customer_invoice info
                inner join bo_customer_invoice_balance bal on bal.id = info.id
                 left join bo_operator ope1 on ope1.id = info.invoice_input_user
                 left join bo_operator ope2 on ope2.id = info.express_input_user
                     where (to_char(info.status) = '32' or to_char(info.status) = '43')"""
        cmSql = cmSql + condition + " order by info.customer_name asc"

        def listSql = "select t.* from (select t.*, rownum rn from (" + cmSql + ") t) t where t.rn > " + listStart + " and t.rn <= " + listTo
        def listCm = dbBoss.rows(listSql)
        def count = dbBoss.rows("select count(*) as count from (" + cmSql + ")")[0][0]

        [listCm: listCm, count: count]
    }

    // 快递信息录入
    def invoiceInfoExpressSave = {

        def con = dataSource_boss.getConnection()
        con.setAutoCommit(false)
        def dbBoss =  new groovy.sql.Sql(con)

        try {
            def infoArr = params.info.split("thisIsALine")
            def size = infoArr.size()
            for (i in 0..size-1) {
                def subInfoArr = infoArr[i].split("thisIsASubLine")

                def invoiceUpdateSql = """update bo_customer_invoice
                               set express_no = '""" + String.valueOf(subInfoArr[1]).replaceAll(",", "") + """',
                                   express_input_time = sysdate,
                                   express_input_user = """ + session.op.id + """,
                                   status = 43
                             where id = """ + subInfoArr[0]
                dbBoss.execute(invoiceUpdateSql)
            }
            dbBoss.commit()
        } catch (Exception e) {
            dbBoss.rollback()
            println "e.message:" + e.message
            render e.message
        } finally {
            dbBoss.close()
            con.close()
        }

        redirect(action: "invoiceInfoExpressing", params: params)
    }

    // 检查快递号唯一性
    def chkExpressNo = {

        def dbBoss = new groovy.sql.Sql(dataSource_boss)
        def result = "success"

        def chkSql = """select id,
                            express_no
                       from bo_customer_invoice
                      where express_no = '""" + params.expressNo + """'
                        and id <> """ + params.id

        def chkList = dbBoss.rows(chkSql)
        if (chkList.size() > 0) {
            result = "fail"
        }
        render result
    }

    // 发票退回 查询
    def invoiceInfoCanceling = {

        def dbBoss =  new groovy.sql.Sql(dataSource_boss)

        params.max = Math.min(params.max ? params.int('max') : 30, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def listStart = params.offset
        def listTo = listStart + params.max
        def condition = ""
        def invDate = ""

        if ((params.initFlag == null) ||(params.initFlag.equals(""))) {
            Calendar calendar = Calendar.getInstance()
            calendar.add(Calendar.MONTH, -1)
            int day = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
            int year = calendar.get(Calendar.YEAR)
            int month = calendar.get(Calendar.MONTH) + 1
            invDate = year + "-" + month + "-" + day
            params.factDate = invDate
            if (month < 10) {
                params.startTime = year + "-" + "0" + month
            } else {
                params.startTime = year + "-" + month
            }
            condition = condition + " and to_char(info.date_end, 'yyyy-mm') = to_char(to_date('" + invDate + "', 'yyyy-mm-dd'), 'yyyy-mm')"
            params.initFlag = 1
        } else if ((params.startTime == null) ||(params.startTime.equals(""))) {
        } else if (params.dateFlag.equals("0")) {
            def startTime = String.valueOf(params.startTime)
            Calendar calendar = Calendar.getInstance()
            calendar.set(Integer.valueOf(startTime.substring(0, 4)), Integer.valueOf(startTime.substring(5, 7)), 1)
            calendar.add(Calendar.MONTH, -1)
            int day = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
            int year = calendar.get(Calendar.YEAR)
            int month = calendar.get(Calendar.MONTH) + 1
            invDate = year + "-" + month + "-" + day
            params.factDate = invDate
            condition = condition + " and to_char(info.date_end, 'yyyy-mm') = to_char(to_date('" + invDate + "', 'yyyy-mm-dd'), 'yyyy-mm')"
        } else {
            invDate = String.valueOf(params.startTime)
            params.factDate = invDate
            condition = condition + " and info.date_end = to_date('" + invDate + "', 'yyyy-mm-dd')"
        }

        if ((params.batchNo != null)&&(!params.batchNo.equals(""))) {
            condition = condition + " and info.batch_no = '" + params.batchNo + "'"
        }
        if ((params.customerNoStr != null)&&(!params.customerNoStr.equals(""))) {
            def customerNos = String.valueOf(params.customerNoStr).trim().replaceAll("( )+", " ").replaceAll(" ", ",")
            params.customerNoStr = customerNos

            if ((customerNos != null)&&(!customerNos.equals(""))) {
                customerNos = "'" + customerNos.replaceAll(",", "','") + "'"
                condition = condition + " and info.customer_no in (" + customerNos + ")"
            }
        }
        if ((params.customerName != null)&&(!params.customerName.equals(""))) {
            condition = condition + " and info.customer_name like '%" + params.customerName + "%'"
        }
        if ((params.minAmount != null)&&(!params.minAmount.equals(""))) {
            condition = condition + " and info.invoice_amt >= " + params.minAmount
        }
        if ((params.maxAmount != null)&&(!params.maxAmount.equals(""))) {
            condition = condition + " and info.invoice_amt <= " + params.maxAmount
        }
        if ((params.status == null)||(params.status.equals(""))) {
            params.status = -1
        } else if (params.status != "-1") {
            condition = condition + " and info.status = '" + params.status + "'"
        }

        def cmSql = """select info.id,
                           info.batch_no,
                           info.customer_id,
                           info.customer_no,
                           info.customer_name,
                           info.customer_tax_no,
                           to_char(info.date_end, 'yyyy-mm-dd') as date_end,
                           to_char(info.invoice_amt, 'fm999,999,999,999,999,990.00') as nvoice_amt,
                           info.customer_contact,
                           info.customer_contact_phone,
                           info.customer_location,
                           info.customer_zip_code,
                           to_char(info.status) as status,
                           info.invoice_no,
                           to_char(info.invoice_time, 'yyyy-mm-dd') as invoice_time,
                           to_char(info.invoice_input_time, 'yyyy-mm-dd hh24:mi:ss') as invoice_input_time,
                           info.invoice_input_user,
                           info.express_name,
                           info.express_no,
                           to_char(info.express_input_time, 'yyyy-mm-dd hh24:mi:ss') as express_input_time,
                           info.express_input_user,
                           info.canceled_reason,
                           to_char(info.canceled_time, 'yyyy-mm-dd hh24:mi:ss') as canceled_time,
                           to_char(bal.amt, 'fm999,999,999,999,999,990.00') as amt,
                           to_char(bal.amt_adj, 'fm999,999,999,999,999,990.00') as amt_adj,
                           to_char(bal.amt_total, 'fm999,999,999,999,999,990.00') as amt_total,
                           bal.adj_reason,
                           ope1.name invoice_input_name,
                           ope2.name express_input_name
                      from bo_customer_invoice info
                inner join bo_customer_invoice_balance bal on bal.id = info.id
                 left join bo_operator ope1 on ope1.id = info.invoice_input_user
                 left join bo_operator ope2 on ope2.id = info.express_input_user
                     where to_char(info.status) <> '54'"""
        cmSql = cmSql + condition + " order by info.customer_name asc"

        def listSql = "select t.* from (select t.*, rownum rn from (" + cmSql + ") t) t where t.rn > " + listStart + " and t.rn <= " + listTo
        def listCm = dbBoss.rows(listSql)
        def count = dbBoss.rows("select count(*) as count from (" + cmSql + ")")[0][0]

        [listCm: listCm, count: count]
    }

    // 保存发票退回信息
    def invoiceInfoCancelSave = {

        def con = dataSource_boss.getConnection()
        con.setAutoCommit(false)
        def dbBoss =  new groovy.sql.Sql(con)

        try {
            def infoArr = params.info.split("thisIsALine")
            def size = infoArr.size()
            for (i in 0..size-1) {
                def subInfoArr = infoArr[i].split("thisIsASubLine")

                // 更新发票明细表
                def detUpdateSql = """update bo_customer_invoice_detail
                                    set balance_id = null
                                  where balance_id = """ + subInfoArr[0]
                dbBoss.execute(detUpdateSql)

                // 更新调账表
                def adjUpdateSql = """update bo_account_adjust_info
                                    set invoice_id = null,
                                        choose_flag = 0
                                  where invoice_id = """ + subInfoArr[0]
                dbBoss.execute(adjUpdateSql)

                // 更新发票表
                def invUpdateSql = """update bo_customer_invoice
                                    set canceled_time = sysdate,
                                        canceled_reason = '""" + subInfoArr[1] + """',
                                        status = 54
                                  where id = """ + subInfoArr[0]
                dbBoss.execute(invUpdateSql)

                // 更新发票余额表
                def balUpdateSql = """update bo_customer_invoice_balance
                                    set canceled = 1
                                  where id = """ + subInfoArr[0]
                dbBoss.execute(balUpdateSql)

                // 更新发票初始化表
                def initUpdateSql = """update bo_customer_invoice_init
                                     set last_inv_date = (select last_inv_date
                                                            from bo_customer_invoice
                                                           where id = """ + subInfoArr[0] + """)
                                  where customer_id = """ + subInfoArr[2]
                dbBoss.execute(initUpdateSql)
            }
            dbBoss.commit()
        } catch (Exception e) {
            dbBoss.rollback()
            println "e.message:" + e.message
            render e.message
        } finally {
            dbBoss.close()
            con.close()
        }

        redirect(action: "invoiceInfoCanceling", params: params)
    }

    // 检查发票退回可行性
    def chkInvoiceInfo = {

        def dbBoss = new groovy.sql.Sql(dataSource_boss)
        def result = "success"

        def chkSql = """select inv.date_end,
                            inv.customer_id
                       from bo_customer_invoice inv
                 inner join bo_customer_invoice_init init
                    on init.customer_id = inv.customer_id
                   and init.last_inv_date = inv.date_end
                     where inv.id =  """ + params.id

        def chkList = dbBoss.rows(chkSql)
        if (chkList.size() == 0) {
            result = "fail"
        }
        render result
    }
}
