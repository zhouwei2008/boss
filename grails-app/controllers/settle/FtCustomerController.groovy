package settle

import account.AccountClientService
import org.springframework.orm.hibernate3.HibernateTemplate
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import groovy.sql.Sql
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils

class FtCustomerController {
    AccountClientService accountClientService
    def dataSource_settle
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def sql = new Sql(dataSource_settle)
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def queryParam = []
        def customerNo = params.customerNo?:''
        def name = params.name ?: ''
        def type = params.type ?: ''
        if (type) {
            queryParam.add(type)
        }
        def query = """
         select distinct b.srv_name srvname,b.customer_no no, b.name
            from (select a.srv_name,c.customer_no,c.name
                  from ft_srv_type a
                  full outer join ismp.cm_customer c
                    on 1 = 1
                 where 1=1
                   ${customerNo ? " and c.customer_no like '%"+customerNo+"%' " : ''}
                   ${name ? " and c.name like '%"+name+"%' " : ''}
                   ${type ? ' and a.srv_code = ? ' : ''}
                   ) b
          left join FT_TRADE_FEE t
            on b.customer_no = t.customer_no
         where 1 = 1
         order by  b.customer_no desc
        """
        def results = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        def total = sql.firstRow("select count(*) total from (${query})", queryParam)
        [ftCustomerList: results, ftCustomerTotal: total.total, params: params]
    }
}