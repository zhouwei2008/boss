package boss

import java.text.SimpleDateFormat
import org.springframework.orm.hibernate3.HibernateTemplate
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback

class NotifyFailService {
    static transactional = true

    def list() {
        def max = 50000
        def offset = 0

        def cal = new GregorianCalendar()
        cal.add(Calendar.MINUTE, -5);
        def calStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(cal.getTime())

        def query = """
                    select rst.OUTTRADENO, rst.TRADENO, rst.ORDERCREATETIME,
                           rst.ORDERID, rst.ORDERAMOUNT, rst.PAYCOMPLETETIME,
                           rst.SELLERCUSTOMERNO, rst.SELLERADMINMAIL,
                           rst.SELLERNAME, rst.CONTACT, rst.CONTACTPHONE,rst.LASTUPDATED
                    from (
                            select n.RECORD_ID  orderId,
                                   o.ORDERNUM   outTradeNo,
                                   o.ID         tradeNo,
                                   o.CREATEDATE orderCreateTime,
                                   o.amount     orderAmount,
                                   o.CLOSEDATE  payCompleteTime,
                                   o.SELLER_ID         sellerCustomerNo,
                                   o.SELLER_NAME       sellerAdminMail,
                                   c.REGISTRATION_NAME sellerName,
                                   c.CONTACT           contact,
                                   c.CONTACT_PHONE     contactPhone,
                                   n.LAST_UPDATED lastUpdated
                              from MAPI_ASYNC_NOTIFY n
                              left join GWORDERS o
                                on n.RECORD_ID = o.ID
                              left join CM_CORPORATION_INFO c
                                on n.CUSTOMER_ID = c.ID
                             where o.NOTIFY_URL is not null
                               and n.ATTEMPTS_COUNT >= 4
                               and n.STATUS != 'success'
                               and o.ordersts <> 0
                         ) rst
                    where rst.LASTUPDATED >= to_date('${calStr}','yyyy-mm-dd hh24:mi:ss')
                    order by rst.TRADENO desc
                  """

        def queryParam = []
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)

            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.setFirstResult(offset).setMaxResults(max).list();
        } as HibernateCallback)

        result
    }
}