package boss

import Constants.Constant
import groovy.sql.Sql
import ismp.CmCustomer
import ismp.TbRiskList
import ismp.TbRiskNotifier
import ismp.TradeBase
import org.apache.commons.dbcp.DelegatingResultSet
import org.codehaus.groovy.grails.commons.ConfigurationHolder

import java.sql.ResultSet


class RiskSynService {

    static transactional = true
    def dataSource_ismp;
    def sendService

    def mobileCustomerNo = ConfigurationHolder.config.mobile.customerNo

    def inputdata(def rule) {
        String sql = "";
        String qrySql = "";
        String ruleStr =  rule.rule;
        String callReturn  = ""
        def qrySqlStmt = new Sql(dataSource_ismp);
        def db = new Sql(dataSource_ismp);
        try {
            if ("onlinePay".equals(rule.bType)) {

                if(rule.ruleParams){

                      if(Constant.ONLINE_DAILY_LIMIT == rule.ruleParams ){
                          qrySqlStmt.call("call PROC_DAYQUTOR(?,?)",[rule.rule,Sql.VARCHAR]) { //当日交易限额
                              callReturn =   it
                          }
                      }else if(Constant.ONLINE_MINUTES_NUMBER_QUOTA == rule.ruleParams){ // 30分钟内5000元以上交易超过3笔
                          qrySqlStmt.call("call PROC_MINUTESNUMBERQUOTA(?,?,?,?)",[30,rule.rule,3,Sql.VARCHAR]) {
                              callReturn =   it
                          }
                      }

                      if(callReturn && callReturn.indexOf(',')>0){
                          def tradeNos = callReturn.substring(0,callReturn.lastIndexOf(','))
                          ruleStr = "t.trade_no in ("+tradeNos+")"
                      }else{
                            return;
                      }
                }

                sql = """
                insert into tb_risk_list (ID,CREATED_DATE,MERCHANT_ID,MERCHANT_NAME,MERCHANT_NO,SERIAL_NO,TRADE_TYPE,TRADE_DATE,AMOUNT,IS_SEND_MAIL,RISK_CONTROL_ID,TRADE_BASE_ID)
                select  seq_risk_list.nextval,sysdate,c.id as cid,c.NAME,c.CUSTOMER_NO,t.TRADE_NO,t.TRADE_TYPE,t.LAST_UPDATED, t.amount ,'0','"""+rule.id+"""',t.id as tid
                from trade_base t left join cm_customer c on t.payee_id=c.id where  t.trade_type='payment' and c.customer_no<>'"""+mobileCustomerNo+"""' and
                """ + ruleStr +""" and not exists (select tb.serial_no from tb_risk_list tb where serial_no=t.trade_no )"""

                qrySql = """
                select c.id cid, c.NAME,c.CUSTOMER_NO, t.TRADE_NO,t.TRADE_TYPE,t.LAST_UPDATED, t.amount ,'0','"""+rule.id+"""',t.id tid
                from trade_base t left join cm_customer c on t.payee_id=c.id  where  t.trade_type='payment'  and c.customer_no<>'"""+mobileCustomerNo+"""'  and
                """ + ruleStr +""" and not exists (select tb.serial_no from tb_risk_list tb where serial_no=t.trade_no )"""


            }else if("mobilePay".equals(rule.bType)){
                sql = """
                insert into tb_risk_list (ID,CREATED_DATE,MERCHANT_ID,MERCHANT_NAME,MERCHANT_NO,SERIAL_NO,TRADE_TYPE,TRADE_DATE,AMOUNT,IS_SEND_MAIL,RISK_CONTROL_ID,TRADE_BASE_ID)
                select  seq_risk_list.nextval,sysdate,c.id as cid,c.NAME,c.CUSTOMER_NO,t.TRADE_NO,t.TRADE_TYPE,t.LAST_UPDATED, t.amount ,'0','"""+rule.id+"""',t.id as tid
                from trade_base t left join cm_customer c on t.payer_id=c.id where  t.trade_type='payment'  and
                """ + ruleStr +""" and not exists (select tb.serial_no from tb_risk_list tb where serial_no=t.trade_no and risk_control_id = """+rule.id+""")"""

                qrySql = """
                select c.id cid, c.NAME,c.CUSTOMER_NO, t.TRADE_NO,t.TRADE_TYPE,t.LAST_UPDATED, t.amount ,'0','"""+rule.id+"""',t.id tid
                from trade_base t left join cm_customer c on t.payer_id=c.id  where  t.trade_type='payment'  and
                """ + ruleStr +""" and not exists (select tb.serial_no from tb_risk_list tb where serial_no=t.trade_no and risk_control_id = """+rule.id+""")"""
            }

            println("qrySql:"+qrySql)

            qrySqlStmt.query(qrySql, { bean ->
                sendEmailCaptcha(bean)
            });

            db.execute(sql)
        } catch (Exception e) {
            e.printStackTrace()
        }

    }

    def sendEmailCaptcha(DelegatingResultSet bean) {

        def teadeNos = ''
        def usrID = ConfigurationHolder.config.userId
        def usrPWD = ConfigurationHolder.config.userPwd

        List<TbRiskList> items = new ArrayList<TbRiskList>();
        while (bean.next()) {
            TbRiskList listBean = new TbRiskList()
            listBean.setMerchantId(bean.getString('CUSTOMER_NO'));
            listBean.setMerchantName(bean.getString('NAME'));
            listBean.setSerialNo(bean.getString('TRADE_NO'));
            listBean.setCreatedDate(bean.getDate('LAST_UPDATED'))
            listBean.setTradeType(bean.getString('TRADE_TYPE'));
            listBean.setAmount(bean.getLong('AMOUNT'));
            items.add(listBean)
            teadeNos += bean.getString('TRADE_NO') + "|"
        }

        if(items.size()>0){
            teadeNos = teadeNos.substring(0,teadeNos.lastIndexOf("|"))
            def contentSMS = """系统发现交易流水号为（"""+teadeNos+"""）疑似风险交易，请核实交易信息，并进行处理。系统自动发送短信，请不要回复，谢谢。【吉高】"""
            println("contentSMS:"+contentSMS)
            def notifierList = TbRiskNotifier.list()
            notifierList.each { item ->
                sendService.sendSMS(item.subId, contentSMS, usrID, usrPWD)
                sendService.sendEmail("/mail/template_riskcontrol", "交易预警", item.email, [riskBean: items])
            }
        }
    }
}
