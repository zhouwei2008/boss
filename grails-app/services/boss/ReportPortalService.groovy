package boss

import org.apache.tools.ant.util.DateUtils
import java.text.SimpleDateFormat
import groovy.sql.GroovyRowResult

/**
 * Created by IntelliJ IDEA.
 * User: shuo_zhang
 * Date: 12-2-14
 * Time: 下午4:34
 * To change this template use File | Settings | File Templates.
 */
class ReportPortalService {
    static transactional = true

    def dataSource_boss
    def dataSource_ismp
    def dataSource_account

    def getPortalDailyReport(day) {


        def conBoss = dataSource_boss.getConnection()
        conBoss.setAutoCommit(false)
        def dbBoss =  new groovy.sql.Sql(conBoss)

        def conIsmp = dataSource_ismp.getConnection()
        conIsmp.setAutoCommit(false)
        def dbIsmp =  new groovy.sql.Sql(conIsmp)

        def conAccount = dataSource_account.getConnection()
        conAccount.setAutoCommit(false)
        def dbAccount =  new groovy.sql.Sql(conAccount)

        // 客户信息
        try {
//            Date   date   =   new   Date();
//
//            def former = "yyyyMMdd"
//            SimpleDateFormat   df   =   new   SimpleDateFormat(former);
////            System.out.println("time   now:"+df.format(date));
//            Calendar   calendar   =   Calendar.getInstance();
//            calendar.setTime(date);
//            Date endDate = Date.parse(former, df.format(calendar.getTime()))
//            calendar.add(calendar.DATE,-1);
//            Date startDate = Date.parse(former, df.format(calendar.getTime()))

            def former = "yyyyMMdd"
            SimpleDateFormat   df   =   new   SimpleDateFormat(former);
            Calendar   calendar   =   Calendar.getInstance();
            calendar.setTime(day);
            Date startDate = Date.parse(former, df.format(calendar.getTime()))
            calendar.add(calendar.DATE,1);
            Date endDate = Date.parse(former, df.format(calendar.getTime()))

            ReportPortalDaily rpd = new ReportPortalDaily()



//            def endDate = df.format(canlandar.getTime())
//            canlandar.add(canlandar.DATE,-1);
//            def startDate = df.format(canlandar.getTime())              s
//            System.out.println("time   now:"+df.format(canlandar.getTime()));
            //客户总数量
            def customerTotalSql = """select count(distinct(t.account_no)) from cm_customer t where type = 'P' and t.account_no is not null and t.account_no != 'null'"""
            def customerTotal = dbIsmp.firstRow(customerTotalSql)
            if(customerTotal)
                if(customerTotal[0])
                    rpd.setCustomerTotal(customerTotal[0].longValue())
//            def customerTradetotalSql = """select * from ac_sequential t where 1=1 and date_created between to_date('$startDate','$former') and to_date('$endDate','$former')"""

            //客户交易数量
//            def customerTradetotalSql = """select count(*) from ac_sequential t where 1=1 and date_created >= ? and date_created < ?"""
//            def customerTradetotal = dbAccount.firstRow(customerTradetotalSql,[new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())])
//            if(customerTradetotal)
//                if(customerTradetotal[0])
//                    rpd.setCustomerTradetotal(customerTradetotal[0].longValue())

            //账户余额
            def findAcSql = """select distinct(t.account_no) from cm_customer t where type = 'P' and t.account_no is not null and t.account_no != 'null'"""
            def findResults = dbIsmp.rows(findAcSql)
            Long balance = 0
            for(def x in findResults){
                def balanceSql = """select t.balance from ac_account t where t.account_no = ?"""
                def bResult = dbAccount.firstRow(balanceSql,x[0])
                if(bResult)
                    if(bResult[0])
                        balance = balance + bResult[0].longValue()

            }
            rpd.setBalance(balance)

            // 充值、支付、转账的金额笔数
            def tradeSql = """  select trade_type,sum(B) as B,sum(A) as A from (
                                 select t.trade_type, sum(t.amount) A, count(*) B
                                   from trade_base t, cm_customer t1
                                  where t1.type = 'P'
                                    and t1.id = t.payer_id
                                    and t.trade_type in ('payment', 'transfer')
                                    and t.date_created >= ?
                                    and t.date_created < ?
                                    and t.status = 'completed'
                                  group by t.trade_type
                                 union
                                 select t.trade_type, sum(t.amount) A, count(*) B
                                   from trade_base t, cm_customer t1
                                  where t1.type = 'P'
                                    and t1.id = t.payee_id
                                    and t.trade_type in ('charge', 'transfer')
                                    and t.date_created >= ?
                                    and t.date_created < ?
                                    and t.status = 'completed'
                                  group by t.trade_type
                                  )
                                  group by trade_type
                                  order by trade_type"""
            def trade = dbIsmp.rows(tradeSql,[new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime()),new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())])
            for(def i in trade){
               def t = i.get("TRADE_TYPE")
               if("charge".equals(t)){
                   rpd.setChargeTotalAmount(i.get("A")?i.get("A").longValue():0)
                   rpd.setChargeTotalCount(i.get("B")?i.get("B").longValue():0)
               }
               if("payment".equals(t)){
                   rpd.setPayAmount(i.get("A")?i.get("A").longValue():0)
                   rpd.setPayCount(i.get("B")?i.get("B").longValue():0)
               }
               if("transfer".equals(t)){
                   rpd.setTransferAmount(i.get("A")?i.get("A").longValue():0)
                   rpd.setTransferCount(i.get("B")?i.get("B").longValue():0)

               }

            }

            //提现的金额笔数
            def withdrawnSql = """select t.handle_status, sum(t1.amount) A, count(*) B
                                from trade_withdrawn t
                                left join trade_base t1 on t.id = t1.id, cm_customer t2
                               where t.handle_status = 'completed'
                                 and t2.type = 'P'
                                 and t2.id = t1.payer_id
                                 and t1.trade_type = 'withdrawn'
                                 and t.handle_time >= ?
                                 and t.handle_time < ?
                               group by t.handle_status"""
            def withdrawn = dbIsmp.firstRow(withdrawnSql,[new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())])
            if(withdrawn){
                if(withdrawn[1])
                    rpd.setWithdrawnAmount(withdrawn[1].longValue())
                if(withdrawn[2])
                    rpd.setWithdrawnCount(withdrawn[2].longValue())
            }


            // 退款的金额笔数
            def refundSql = """   select t.handle_status, sum(t1.amount) A, count(*) B
                                 from trade_refund t
                                 left join trade_base t1 on t.id = t1.id, cm_customer t2
                                where t.handle_status = 'completed'
                                  and t2.type = 'P'
                                  and t2.id = t1.payer_id
                                  and t1.trade_type = 'refund'
                                  and t.handle_time >= ?
                                  and t.handle_time < ?
                                group by t.handle_status"""
            def refund = dbIsmp.firstRow(refundSql,[new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())])
            if(refund){
                if(refund[1])
                    rpd.setRefundAmount(refund[1].longValue())
                if(refund[2])
                    rpd.setRefundCount(refund[2].longValue())
            }

            rpd.setCustomerTradetotal(rpd.chargeTotalCount + rpd.payCount + rpd.withdrawnCount + rpd.refundCount + rpd.transferCount)
            //当日统计时间
//            rpd.setDateCreated(new Date());
            rpd.setDateCreated(startDate);

            //判断是否有当日数据，有则更新，无则新增
            def ptrRPDSql = """select date_created from report_portal_daily t where date_created >=?
            and date_created < ?
            """
//            def ptrRPD = dbBoss.firstRow(ptrRPDSql,[new java.sql.Date(endDate.getTime())])
            def ptrRPD = dbBoss.firstRow(ptrRPDSql,[new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())])
            if(ptrRPD){
                log.info("个人门户报表——数据更新操作！ReportPortalDailyJob 今天已运行过！")
                def ptrDate = ptrRPD[0]
                def updateRPDSql = """update report_portal_daily t
                                    set t.balance = ?,
                                        t.customer_total = ?,
                                        t.customer_tradetotal = ?,
                                        t.charge_total_amount = ?,
                                        t.charge_total_count = ?,
                                        t.charge_only_amount = ?,
                                        t.charge_only_count = ?,
                                        t.charge_other_amount = ?,
                                        t.charge_other_count = ?,
                                        t.pay_amount = ?,
                                        t.pay_count = ?,
                                        t.withdrawn_amount = ?,
                                        t.withdrawn_count = ?,
                                        t.refund_amount = ?,
                                        t.refund_count = ?,
                                        t.transfer_amount = ?,
                                        t.transfer_count = ?,
                                        t.in_fee = ?,
                                        t.bank_cost = ?,
                                        t.date_created = ?
                                  where t.date_created = ?"""
                dbBoss.executeUpdate(updateRPDSql,[rpd.balance,rpd.customerTotal,rpd.customerTradetotal,rpd.chargeTotalAmount,rpd.chargeTotalCount,rpd.chargeOnlyAmount,rpd.chargeOnlyCount,
                        rpd.chargeOtherAmount,rpd.chargeOtherCount,rpd.payAmount,rpd.payCount,rpd.withdrawnAmount,rpd.withdrawnCount,rpd.refundAmount,rpd.refundCount,rpd.transferAmount,
                        rpd.transferCount,rpd.inFee,rpd.bankCost,new java.sql.Timestamp(rpd.dateCreated.getTime()),ptrDate])
                dbBoss.commit()

            }else{
                log.info("个人门户报表——数据入库操作！")
               def insertRPDSql = """insert into report_portal_daily t
                                  (t.id,
                                   t.balance,
                                   t.customer_total,
                                   t.customer_tradetotal,
                                   t.charge_total_amount,
                                   t.charge_total_count,
                                   t.charge_only_amount,
                                   t.charge_only_count,
                                   t.charge_other_amount,
                                   t.charge_other_count,
                                   t.pay_amount,
                                   t.pay_count,
                                   t.withdrawn_amount,
                                   t.withdrawn_count,
                                   t.refund_amount,
                                   t.refund_count,
                                   t.transfer_amount,
                                   t.transfer_count,
                                   t.in_fee,
                                   t.bank_cost,
                                   t.date_created)
                                values
                                  (SEQ_REPORTPORTAL.NEXTVAL,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"""

                dbBoss.executeInsert(insertRPDSql,[rpd.balance,rpd.customerTotal,rpd.customerTradetotal,rpd.chargeTotalAmount,rpd.chargeTotalCount,rpd.chargeOnlyAmount,rpd.chargeOnlyCount,
                        rpd.chargeOtherAmount,rpd.chargeOtherCount,rpd.payAmount,rpd.payCount,rpd.withdrawnAmount,rpd.withdrawnCount,rpd.refundAmount,rpd.refundCount,rpd.transferAmount,
                        rpd.transferCount,rpd.inFee,rpd.bankCost,new java.sql.Timestamp(rpd.dateCreated.getTime())])
                dbBoss.commit()
            }
//
//            Calendar calendar =


        } catch (Exception e) {
            dbBoss.rollback()
            println "e.message:" + e.printStackTrace()
            log.info("错误日志（report_portal_daily）：" + e.message)
        } finally {
            dbBoss.close()
            dbIsmp.close()
            dbAccount.close()
            conBoss.close()
            conIsmp.close()
            conAccount.close()
        }

    }


}
