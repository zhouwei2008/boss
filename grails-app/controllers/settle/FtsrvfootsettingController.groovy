package settle


import account.AcAccount
import account.AccountClientService
import boss.BoAccountAdjustInfo
import groovy.sql.Sql
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils

import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate

class FtsrvfootsettingController {

  AccountClientService accountClientService

  static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

  def index = {
    redirect(action: "list", params: params)
  }

  def dataSource_settle
  def list = {
    params.sort = params.sort ? params.sort : "id"

    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    params.offset = params.offset ? params.int('offset') : 0
    def customerNo = params.customerNo
    def name = params.customerName

    def query = """ select t2.srv_code, t2.srv_name ,
       t2.trade_name,t2.tradeid,t2.SRVID,
            t1.*
  from ft_srv_foot_setting t1
 right join (select a1.*,a2.trade_name,a2.id tradeid,a1.id srvid  from   ft_srv_type a1,ft_srv_trade_type a2
where  1=1 and a1.id=a2.srv_id  ) t2
on t1.customer_no = '$customerNo' and t1.srv_id=t2.srvid and t1.trade_type_id=t2.tradeid  where 1=1 """
    println query
    def query_total = """select count(*) total from ( select t2.*
  from ft_srv_foot_setting t1
 right join (select a1.*,a2.trade_name,a2.id tradeid,a1.id srvid from   ft_srv_type a1,ft_srv_trade_type a2
where  1=1 and a1.id=a2.srv_id  ) t2
on t1.customer_no = '$customerNo' and t1.srv_id=t2.srvid and t1.trade_type_id=t2.tradeid  where 1=1 """
    if (params.srvcode != null && params.srvcode != '') {
      def srvcode = params.srvcode
      query += " and t2.srv_code='$srvcode'  "
      query_total += " and t2.srv_code='$srvcode') t"
    }
    else {
      query_total += " ) t "
    }
    def sql = new Sql(dataSource_settle)
    def total = sql.firstRow(query_total).total
    HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
    def results = ht.executeFind({ Session session ->
      def sqlquery = session.createSQLQuery(query.toString())
      sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)

      return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
    } as HibernateCallback)
    def bTypeList = FtSrvType.list()

    [ftTradeFeeList: results, ftTradeFeeTotal: total, params: params, customerNo: customerNo, customerName: name, bTypeList: bTypeList]
  }


}

