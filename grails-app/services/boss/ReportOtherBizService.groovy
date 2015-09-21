package boss

import java.text.SimpleDateFormat

/**
 * Created by IntelliJ IDEA.
 * User: shuo_zhang
 * Date: 12-2-20
 * Time: 下午7:54
 * To change this template use File | Settings | File Templates.
 */
class ReportOtherBizService {
    static transactional = true

    def dataSource_boss
    def dataSource_ismp
    def dataSource_account

    def getOtherBizReport(day){
        def conBoss = dataSource_boss.getConnection()
        conBoss.setAutoCommit(false)
        def dbBoss =  new groovy.sql.Sql(conBoss)

        def conIsmp = dataSource_ismp.getConnection()
        conIsmp.setAutoCommit(false)
        def dbIsmp =  new groovy.sql.Sql(conIsmp)

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



//            def endDate = df.format(canlandar.getTime())
//            canlandar.add(canlandar.DATE,-1);
//            def startDate = df.format(canlandar.getTime())              s
//            System.out.println("time   now:"+df.format(canlandar.getTime()));
            //其他业务统计
            def querySql = """ select id,
                                   area,
                                   name,
                                   sum(A) as cc,
                                   sum(A1) as cs,
                                   sum(B) as wc,
                                   sum(B1) as ws,
                                   sum(C) as tc,
                                   sum(C1) as ts
                              from (select t1.id,
                                           t1.name as name,
                                           t5.belong_to_area as area,
                                           count(*) as A,
                                           sum(t2.amount) as A1,
                                           0 as B,
                                           0 as B1,
                                           0 as C,
                                           0 as C1
                                      from cm_customer t1, trade_base t2,cm_corporation_info t5,trade_charge t6
                                     where t1.type = 'C'
                                       and t6.id = t2.id
                                       and (t6.payment_request_id is null or t6.payment_request_id = '0' or
                                            t6.payment_request_id = '')
                                       and t1.id = t2.payee_id
                                       and t2.trade_type = 'charge'
                                       and t2.status = 'completed'
                                       and t1.id = t5.id
                                       and t2.date_created >= ?
                                       and t2.date_created < ?
                                     group by t1.id,t5.belong_to_area, t1.name
                                    union

                                    select t1.id,
                                           t1.name,
                                           t5.belong_to_area as area,
                                           0 as A,
                                           0 as A1,
                                           count(*) as B,
                                           sum(t2.amount) as B1,
                                           0 as C,
                                           0 as C1
                                      from cm_customer t1, trade_base t2
                                      left join trade_withdrawn t3 on t2.id = t3.id,cm_corporation_info t5
                                     where t1.type = 'C'
                                       and t1.id = t2.payer_id
                                       and t2.trade_type = 'withdrawn'
                                       and t2.status = 'completed'
                                       and t1.id = t5.id
                                       and t3.handle_time >= ?
                                       and t3.handle_time < ?
                                     group by t1.id,t5.belong_to_area, t1.name

                                    union
                                    select t1.id,
                                           t1.name,
                                           t5.belong_to_area as area,
                                           0 as A,
                                           0 as A1,
                                           0 as B,
                                           0 as B1,
                                           count(*) as C,
                                           sum(t2.amount) as C1
                                      from cm_customer t1, trade_base t2,cm_corporation_info t5
                                     where t1.type = 'C'
                                       and t1.id = t2.payee_id
                                       and t2.trade_type = 'transfer'
                                       and t2.status = 'completed'
                                       and t1.id = t5.id
                                       and t2.date_created >= ?
                                       and t2.date_created < ?
                                     group by t1.id,t5.belong_to_area, t1.name

                                    union
                                    select t1.id,
                                           t1.name,
                                           t5.belong_to_area as area,
                                           0 as A,
                                           0 as A1,
                                           0 as B,
                                           0 as B1,
                                           count(*) as C,
                                           sum(t2.amount) * -1 as C1
                                      from cm_customer t1, trade_base t2,cm_corporation_info t5
                                     where t1.type = 'C'
                                       and t1.id = t2.payer_id
                                       and t2.trade_type = 'transfer'
                                       and t2.status = 'completed'
                                       and t1.id = t5.id
                                       and t2.date_created >= ?
                                       and t2.date_created < ?
                                     group by t1.id,t5.belong_to_area, t1.name) tt
                             group by tt.id,tt.area, tt.name
            """

            //判断是否有当日数据，有则更新，无则新增
            def ptrRPDSql = """select date_created from report_other_biz_daily t where date_created >=?
            and date_created < ?
            """
//            def ptrRPD = dbBoss.firstRow(ptrRPDSql,[new java.sql.Date(endDate.getTime())])
            def ptrRPD = dbBoss.firstRow(ptrRPDSql,[new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())])
            if(ptrRPD){
                log.info("其他业务统计报表——数据更新操作！ReportOherBizDailyJob 今天已运行过！清除旧数据")
                def deleteSql = """delete report_other_biz_daily t where t.date_created >= ?
                and date_created < ?
                """
                dbBoss.execute(deleteSql,[new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())]);
                dbBoss.commit()

            }
            log.info("其他业务统计报表——数据入库操作！")
            def queryResults = dbIsmp.rows(querySql,[new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime()),new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime()),new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime()),new java.sql.Date(startDate.getTime()),new java.sql.Date(endDate.getTime())])

            for(def qrs in queryResults){
                ReportOtherBizDaily robd = new ReportOtherBizDaily()
                def id = qrs.get("ID").longValue()
                robd.setCusAccountID(id);
                def area = qrs.get("AREA")
                robd.setArea(area)
                def name = qrs.get("NAME")
                robd.setCusName(name)
                def cc = qrs.get("CC").longValue()
                robd.setChargeTotalCount(cc)
                def cs = qrs.get("CS").longValue()
                robd.setChargeTotalAmount(cs)
                def wc = qrs.get("WC").longValue()
                robd.setWithdrawnCount(wc)
                def ws = qrs.get("WS").longValue()
                robd.setWithdrawnAmount(ws)
                def tc = qrs.get("TC").longValue()
                robd.setTransferCount(tc)
                def ts =qrs.get("TS").longValue()
                robd.setTransferAmount(ts)
//                robd.setDateCreated(date)
                robd.setDateCreated(startDate)
                def insertRPDSql = """insert into report_other_biz_daily t
                                      (t.id,
                                       t.cus_accountid,
                                       t.area,
                                       t.cus_name,
                                       t.charge_total_count,
                                       t.charge_total_amount,
                                       t.withdrawn_count,
                                       t.withdrawn_amount,
                                       t.transfer_count,
                                       t.transfer_amount,
                                       t.date_created)
                                    values
                                      (SEQ_REPORTOTHERBIZ.NEXTVAL,?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"""
                dbBoss.executeInsert(insertRPDSql,[robd.cusAccountID,robd.area,robd.cusName,robd.chargeTotalCount,robd.chargeTotalAmount,robd.withdrawnCount,robd.withdrawnAmount,robd.transferCount,robd.transferAmount,new java.sql.Timestamp(robd.dateCreated.getTime())])
            }
            dbBoss.commit()
        } catch (Exception e) {
            dbBoss.rollback()
            println "e.message:" + e.printStackTrace()
            log.info("错误日志（report_adjust_daily）：" + e.message)
        } finally {
            dbBoss.close()
            dbAccount.close()
            conBoss.close()
            conIsmp.close()
            conAccount.close()
        }
    }
}
