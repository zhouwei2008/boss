package settle

import account.AccountClientService
import account.AcAccount
import account.AccountClientService
import boss.BoAccountAdjustInfo
import groovy.sql.Sql
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils

import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate

class FtsrvfootsettingUpdateController {

  AccountClientService accountClientService

  static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

  def index = {
    redirect(action: "list", params: params)
  }


  def dataSource_settle
  def list = {
    println "开始修改"
    params.sort = params.sort ? params.sort : "id"

    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    params.offset = params.offset ? params.int('offset') : 0
    def customerNo = params.customerNo
    def name = params.customerName

    def query = """ select t2.srv_code, t2.srv_name ,
       t2.trade_name,t2.tradeid,t2.SRVID,
            t1.*
  from ft_srv_foot_setting t1
 right join (select a1.*,a2.trade_name,a2.id tradeid,a1.id srvid  from   ft_srv_type a1,ft_srv_trade_type a2) t2
on t1.customer_no = '$customerNo' and t1.srv_id=t2.srvid and t1.trade_type_id=t2.tradeid  where 1=1 """
    println "query" + query
    def query_total = """select count(*) total from ( select t2.*
  from ft_srv_foot_setting t1
 right join (select a1.*,a2.trade_name,a2.id tradeid,a1.id srvid from   ft_srv_type a1,ft_srv_trade_type a2) t2
on t1.customer_no = '$customerNo' and t1.srv_id=t2.srvid and t1.trade_type_id=t2.tradeid  where 1=1 """
    if (params.tradeid != null && params.tradeid != "") {
      def tid = params.tradeid
      query += " and t2.tradeid='$tid'  "
      query_total += " and t2.tradeid='$tid' "
    }
    if (params.srvcode != null && params.srvcode != '') {
      def srvcode = params.srvcode
      query += " and t2.srvid='$srvcode'  "
      query_total += " and t2.srvid='$srvcode') t"
    }
    else {
      query_total += " ) t "
    }

    println "query" + query
    def sql = new Sql(dataSource_settle)
    def total = sql.firstRow(query_total).total
    HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
    def results = ht.executeFind({ Session session ->
      def sqlquery = session.createSQLQuery(query.toString())
      sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)

      return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
    } as HibernateCallback)
    [ftTradeFeeList: results, ftTradeFeeTotal: total, params: params, customerNo: customerNo, customerName: name, foottype: params.foottype, sucess: params.sucess, chosevalue: params.chosevalue]
  }

  def save = {
    println params
    //用户名
    def customerNo = params.customerNo

    println "begin"
    def sql = new Sql(dataSource_settle)
    def ftSrvFootSettingInstance = new FtSrvFootSetting()
    ftSrvFootSettingInstance.customerNo = customerNo
    def foottype = params.foottype
    def ftsrvtype = FtSrvType.get(params.srvcode)
    ftSrvFootSettingInstance.srv = ftsrvtype
    def ftSrvTradeType = new FtSrvTradeType()
    ftSrvTradeType = FtSrvTradeType.get(params.tradeid)
    ftSrvFootSettingInstance.tradeType = ftSrvTradeType
    if (params.foottype != null)
      ftSrvFootSettingInstance.footType = Integer.valueOf(params.foottype)
    else
      ftSrvFootSettingInstance.footType = 0
    ftSrvFootSettingInstance.type = Integer.valueOf(params.type)
    ftSrvFootSettingInstance.withdraw = Integer.valueOf(params.withdraw)
    if (foottype != "0") {
      if (params.mortday == null || params.mortday == "")
        params.mortday = 0


      ftSrvFootSettingInstance.mortDay = Integer.valueOf(params.mortday)
      if (params.foottimes == null)
        params.foottimes = 0
      ftSrvFootSettingInstance.footTimes = Integer.valueOf(params.foottimes)
      ftSrvFootSettingInstance.footExpr = params.footexpr
      def foot_amount = params.footamount
      if (params.footamount == null || params.footamount == "")
        foot_amount = 0
      println foot_amount
      ftSrvFootSettingInstance.footAmount = Double.valueOf(foot_amount)
    }
    else {
      ftSrvFootSettingInstance.mortDay = 0
      ftSrvFootSettingInstance.footTimes = 0
      ftSrvFootSettingInstance.footExpr = 0
      ftSrvFootSettingInstance.footAmount = 0

    }

    sql.executeUpdate("delete from ft_srv_foot_setting where  srv_id=" + params.srvcode + " and trade_type_id=" + params.tradeid + " and customer_no = '$customerNo'")
    def chosevalue = params.chosevalue
    if (chosevalue == '0' && ftSrvFootSettingInstance.save(flush: true) || chosevalue == '1') {
      println "结算周期"
      println foottype
      flash.message = "${message(code: '结算周期修改成功', args: [message(code: 'ftsrvfootsettingUpdate_sucess.label')])}"
      params.sucess = true
      redirect(action: "list", params: params, foottype: foottype, customerNo: customerNo,)
    }
    else {
      flash.message = "结算周期修改失败"
      redirect(action: "list", params: params, foottype: foottype)
    }

    redirect(action: "list", params: params, foottype: foottype)
  }


}

