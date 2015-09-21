package boss

import java.text.SimpleDateFormat

/**
 * Created by IntelliJ IDEA.
 * User: shuo_zhang
 * Date: 12-2-20
 * Time: 下午7:55
 * To change this template use File | Settings | File Templates.
 */
class ReportAdjustService {
    static transactional = true

    def dataSource_boss
    def dataSource_account

    def getAdjustDailyReport(day) {


        def conBoss = dataSource_boss.getConnection()
        conBoss.setAutoCommit(false)
        def dbBoss =  new groovy.sql.Sql(conBoss)


        def conAccount = dataSource_account.getConnection()
        conAccount.setAutoCommit(false)
        def dbAccount =  new groovy.sql.Sql(conAccount)

        try {
            //计算统计时间
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

            ReportAdjustDaily rad = new ReportAdjustDaily()



//            def endDate = df.format(canlandar.getTime())
//            canlandar.add(canlandar.DATE,-1);
//            def startDate = df.format(canlandar.getTime())              s
//            System.out.println("time   now:"+df.format(canlandar.getTime()));
            //计算借记账户调账金额合计
            def debitAdjustAmountSql = """select sum(A) as tt from (
                                  select sum(t1.amount) * -1 as a
                                    from ac_transaction t1, ac_account t2
                                   where t1.transfer_type = 'adjust'
                                     and t2.balance_of_direction = 'debit'
                                     and t2.id = t1.from_account_id
                                     and t1.date_created >= ? and t1.date_created < ?
                                   union
                                  select sum(t1.amount) as a
                                    from ac_transaction t1, ac_account t2
                                   where t1.transfer_type = 'adjust'
                                     and t2.balance_of_direction = 'debit'
                                     and t2.id = t1.to_account_id
                                     and t1.date_created >= ? and t1.date_created < ?
                                  )"""
            def debitAdjustAmount = dbAccount.firstRow(debitAdjustAmountSql,[new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime()),new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())])
            if(debitAdjustAmount)
                if(debitAdjustAmount[0])
                    rad.setDebitAdjustAmount(debitAdjustAmount[0].longValue())

            //计算贷记账户调帐金额
            def creditAdjustAmountSql = """select sum(A) as tt from (
                                  select sum(t1.amount) as a
                                    from ac_transaction t1, ac_account t2
                                   where t1.transfer_type = 'adjust'
                                     and t2.balance_of_direction = 'credit'
                                     and t2.id = t1.from_account_id
                                     and t1.date_created >= ? and t1.date_created < ?
                                   union
                                  select sum(t1.amount) * -1 as a
                                    from ac_transaction t1, ac_account t2
                                   where t1.transfer_type = 'adjust'
                                     and t2.balance_of_direction = 'credit'
                                     and t2.id = t1.to_account_id
                                     and t1.date_created >= ? and t1.date_created < ?
                                  )"""
            def creditAdjustAmount = dbAccount.firstRow(creditAdjustAmountSql,[new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime()),new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())])
            if(creditAdjustAmount)
                if(creditAdjustAmount[0])
                    rad.setCreditAdjustAmount(creditAdjustAmount[0].longValue())


            //计算平台已收手续费
            //1获得手续费账户
            def feeAccountSql = """select Account_no from bo_inner_account t where key = 'feeAcc'"""
            def feeAccount = dbBoss.firstRow(feeAccountSql)
            //2计算手续费
            if(feeAccount){
                if(feeAccount[0]){
                    def platFeeSql = """select sum(A) as tt from (
                                  select sum(t1.amount) * -1 as a
                                    from ac_transaction t1, ac_account t2
                                   where t1.transfer_type = 'adjust'
                                     and t2.account_no = ?
                                     and t2.id = t1.from_account_id
                                     and t1.date_created >= ? and t1.date_created < ?
                                   union
                                  select sum(t1.amount) as a
                                    from ac_transaction t1, ac_account t2
                                   where t1.transfer_type = 'adjust'
                                     and t2.account_no = ?
                                     and t2.id = t1.to_account_id
                                     and t1.date_created >= ? and t1.date_created < ?
                                  )"""
                    def platFee = dbAccount.firstRow(platFeeSql,[feeAccount[0],new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime()),feeAccount[0],new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())])
                    if(platFee)
                        if(platFee[0])
                            rad.setPlatFee(platFee[0].longValue())
                }
            }


            //计算银行调账充值账户
            //1获得充值账户
            def bankAdjustChargeAccountSql ="""select Account_no from bo_inner_account t where key = 'adjBalCharge'"""
            def bankAdjustChargeAccount = dbBoss.firstRow(bankAdjustChargeAccountSql)
            //2计算充值账户额度
            if(bankAdjustChargeAccount){
                if(bankAdjustChargeAccount[0]){
                    def bankAdjustChargeSql = """
                                    select sum(x.out_amount) as tt
                                      from bo_verify x
                                     where x.type = '1'
                                       and x.status = '1'
                                       and x.date_created >= ?
                                       and x.date_created < ?
                                  """
                    def bankAdjustChargeFee = dbBoss.firstRow(bankAdjustChargeSql,[new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())])
                    if(bankAdjustChargeFee)
                        if(bankAdjustChargeFee[0])
                            rad.setBankAdjustCharge(bankAdjustChargeFee[0].longValue())
                }
            }

            //计算银行调账提款账户
            //1获得提款账户
            def bankAdjustWithdrawnAccountSql ="""select Account_no from bo_inner_account t where key = 'adjBalWithDraw'"""
            def bankAdjustWithdrawnAccount = dbBoss.firstRow(bankAdjustWithdrawnAccountSql)
            //2计算充值账户额度
            if(bankAdjustWithdrawnAccount){
                if(bankAdjustWithdrawnAccount[0]){
                    def bankAdjustWithdrawnSql = """
                                    select sum(x.out_amount) as tt
                                      from bo_verify x
                                     where x.type = '2'
                                       and x.status = '1'
                                       and x.date_created >= ?
                                       and x.date_created < ?
                                  """
                    def bankAdjustWithdrawnFee = dbBoss.firstRow(bankAdjustWithdrawnSql,[new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())])
                    if(bankAdjustWithdrawnFee)
                        if(bankAdjustWithdrawnFee[0])
                            rad.setBankAdjustWithdrawn(bankAdjustWithdrawnFee[0].longValue())
                }
            }
//            def customerTradetotalSql = """select * from ac_sequential t where 1=1 and date_created between to_date('$startDate','$former') and to_date('$endDate','$former')"""



            //当日统计时间
//            rad.setDateCreated(new Date());
            rad.setDateCreated(startDate);


            //判断是否有当日数据，有则更新，无则新增
            def ptrRPDSql = """select date_created from report_adjust_daily t where date_created >=?
            and date_created < ?
            """
//            def ptrRPD = dbBoss.firstRow(ptrRPDSql,[new java.sql.Date(endDate.getTime())])
            def ptrRPD = dbBoss.firstRow(ptrRPDSql,[new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())])
            if(ptrRPD){
                log.info("调账类统计报表——数据更新操作！ReportAdjustDailyJob 今天已运行过！")
                def ptrDate = ptrRPD[0]
                def updateRADSql = """update report_adjust_daily t
                                    set t.debit_adjust_amount  = ?,
                                        t.credit_adjust_amount = ?,
                                        t.plat_fee             = ?,
                                        t.bank_adjust_charge   = ?,
                                        t.bank_adjust_withdrawn = ?,
                                        t.date_created         = ?
                                  where t.date_created = ?
                                  """
                dbBoss.executeUpdate(updateRADSql,[rad.debitAdjustAmount,rad.creditAdjustAmount,rad.platFee,rad.bankAdjustCharge,rad.bankAdjustWithdrawn,new java.sql.Timestamp(rad.dateCreated.getTime()),ptrDate])
                dbBoss.commit()

            }else{
                log.info("调账类统计报表——数据入库操作！")
               def insertRPDSql = """insert into report_adjust_daily t
                                       (t.id,
                                       t.debit_adjust_amount,
                                       t.credit_adjust_amount,
                                       t.plat_fee,
                                       t.bank_adjust_charge,
                                       t.bank_adjust_withdrawn,
                                       t.date_created)
                                values
                                  (SEQ_REPORTADJUST.NEXTVAL,?,?,?,?,?,?)"""

                dbBoss.executeInsert(insertRPDSql,[rad.debitAdjustAmount,rad.creditAdjustAmount,rad.platFee,rad.bankAdjustCharge,rad.bankAdjustWithdrawn,new java.sql.Timestamp(rad.dateCreated.getTime())])
                dbBoss.commit()
            }


        } catch (Exception e) {
            dbBoss.rollback()
            println "e.message:" + e.printStackTrace()
            log.info("错误日志（report_adjust_daily）：" + e.message)
        } finally {
            dbBoss.close()
            dbAccount.close()
            conBoss.close()
            conAccount.close()
        }

    }
}
