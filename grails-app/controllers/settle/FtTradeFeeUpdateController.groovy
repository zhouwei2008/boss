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

class FtTradeFeeUpdateController {

  AccountClientService  accountClientService
  static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

  def index = {
    redirect(action: "list", params: params)
  }
 def dataSource_settle
 def list = {

      println params
       params.sort = params.sort ? params.sort : "id"

        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def  customerNo=params.customerNo
      def name=params.customerName
      def fetchtype=params.fetchtype
      def feetype=params.feetype
      println "=========="
      println params.srvcode
  def query = """ select t2.srv_code ,
       t2.srv_name ,
       t2.trade_name,t2.tradeid,t2.SRVID,
       decode(t1.fetch_type, 0, '即收', '1', '后返', '未设置') fetch_type_s,
       t1.fetch_type,
       decode(t1.fee_type, 0, '按笔收', '1', '按比率收', '未设置') fee_type_s,
         t1.fee_type,
         t1.trade_weight trade_weight,
       t1.fee_value fee_value
  from ft_trade_fee t1
 right join (select a1.*,a2.trade_name,a2.id tradeid,a1.id srvid  from   ft_srv_type a1,ft_srv_trade_type a2) t2
on t1.customer_no = '$customerNo' and t1.srv_id=t2.srvid and t1.trade_type_id=t2.tradeid  where 1=1 """

          def query_total = """select count(*) total from ( select t2.srv_code ,
       t2.srv_name ,
       t2.trade_name,
       decode(t1.fetch_type, 0, '即收', '1', '后返', '未设置') fetch_type,
       decode(t1.fee_type, 0, '按笔收', '1', '按比率收', '未设置') fee_type,
       t1.fee_value fee_value
  from ft_trade_fee t1
 right join (select a1.*,a2.trade_name,a2.id tradeid,a1.id srvid from   ft_srv_type a1,ft_srv_trade_type a2) t2
on t1.customer_no = '$customerNo' and t1.srv_id=t2.srvid and t1.trade_type_id=t2.tradeid  where 1=1 """
       if(params.tradeid!=null&&params.tradeid!=""){
                def tid=params.tradeid
            query+=" and t2.tradeid='$tid'  "
            query_total+=" and t2.tradeid='$tid' "
        }
        if (params.srvcode != null && params.srvcode != '') {
            def srvcode=params.srvcode
            query+=" and t2.srvid='$srvcode'  "
            query_total+=" and t2.srvid='$srvcode') t"
        }
        else
        {
            query_total+=" ) t "
        }
        
         def sql = new Sql(dataSource_settle)
         def total = sql.firstRow(query_total).total
         HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
    def results = ht.executeFind({ Session session ->
      def sqlquery = session.createSQLQuery(query.toString())
      sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)

      return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
    } as HibernateCallback)

             println "开始=========="
              println params
        [ftTradeFeeList: results, ftTradeFeeTotal: total, params: params,customerNo:customerNo,customerName:name,srvcode:params.srvcode,fetchtype:fetchtype,feetype:feetype,sucess:params.sucess,chosevalue:params.chosevalue]
  }


  def save={
      println params
      //用户名
      def customerNo=params.customerNo
    
      println "begin"
       def sql = new Sql(dataSource_settle)
            def ftTradeFeeInstance=new FtTradeFee()
            ftTradeFeeInstance.customerNo=customerNo
             println ftTradeFeeInstance
            def ftsrvtype=FtSrvType.get(params.srvcode)
            ftTradeFeeInstance.srv=ftsrvtype
            def ftSrvTradeType=new FtSrvTradeType()
            ftSrvTradeType=FtSrvTradeType.get(params.tradeid)
            ftTradeFeeInstance.tradeType=ftSrvTradeType
            ftTradeFeeInstance.tradeWeight=params.tradeWeight?.toInteger()
            if(params.fetchtype!=null)
            ftTradeFeeInstance.fetchType=Integer.valueOf(params.fetchtype)
            if(params.feetype!=null)
            ftTradeFeeInstance.feeType=Integer.valueOf(params.feetype)
            if(params.feevalue!=null)
            ftTradeFeeInstance.feeValue=Double.valueOf(params.feevalue)
          
            sql.executeUpdate("delete from ft_trade_fee where  srv_id="+params.srvcode+" and trade_type_id="+params.tradeid +" and customer_no = '$customerNo'")
           def chosevalue=params.chosevalue
           if (chosevalue=='0'&&ftTradeFeeInstance.save(flush: true)||chosevalue=='1')
            {
                flash.message = "${message(code: '手续费率修改成功', args: [message(code: 'ftTradeFeeupdateList_sucess.label')])}"
                params.sucess=true
                redirect(action: "list", params: params)
                return
            }
            else
            {
                 flash.message = "${message(code: '手续费率修改失败', args: [message(code: 'ftTradeFeeupdateList_fail.label')])}"
                redirect(action: "list", params: params)
            }
        println "end"
     
      redirect(action: "list", params: params)
  }

}
