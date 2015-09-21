package ismp

import org.springframework.orm.hibernate3.HibernateTemplate
import javax.sql.DataSource
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.Session
import org.springframework.orm.hibernate3.HibernateCallback
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.apache.commons.lang.StringUtils
import groovy.sql.Sql
import gateway.GwTransaction

class NotifyFailProofController {
    def index = {
        redirect(action: "list", params: params)
    }

    def validAmount(amt){
        if(StringUtils.isEmpty(amt)){
            return null
        }

        def rst = amt as String
        rst = rst.replaceAll(",","")
        if(rst.indexOf('.') > 0){
            if(rst.indexOf('.') != rst.lastIndexOf('.')){
                return null
            }else{
                def arr = rst.split('.')
                def l = arr[0]
                def r = arr[1]
                if(!StringUtils.isNumeric(l) || !StringUtils.isNumeric(r)){
                    return null
                }
            }
        }
        BigDecimal deci = new BigDecimal(rst)
        deci.setScale(2,0)
        rst = deci.multiply(new BigDecimal(100)).intValue() as String

        return rst
    }

    def dataSource_ismp

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def orderCreateTimeStart = params.orderCreateTimeStart
        def orderCreateTimeEnd = params.orderCreateTimeEnd
        def payCompleteTimeStart = params.payCompleteTimeStart
        def payCompleteTimeEnd = params.payCompleteTimeEnd

        def orderAmountMin = params.orderAmountMin
        orderAmountMin = validAmount(orderAmountMin)
        def orderAmountMax = params.orderAmountMax
        orderAmountMax = validAmount(orderAmountMax)

        def outTradeNo = params.outTradeNo
        def tradeNo = params.tradeNo
        def bankTransNo = params.bankTransNo
        def orderId
        def str
        if(bankTransNo!=null && bankTransNo!=''){
            orderId=GwTransaction.findByBankTransNo(bankTransNo)?.order?.id
        }
        if(bankTransNo!=null && bankTransNo!='' && (orderId=='' || orderId==null)){
            str=1
        }
        def sellerCustomerNo = params.sellerCustomerNo
        def sellerName = params.sellerName
        def sellerAdminMail = params.sellerAdminMail

        def query = """
                     select rst.OUTTRADENO, rst.TRADENO, rst.ORDERCREATETIME,
                           rst.ORDERID, rst.ORDERAMOUNT, rst.PAYCOMPLETETIME,
                           rst.SELLERCUSTOMERNO, rst.SELLERADMINMAIL,
                           rst.SELLERNAME, rst.CONTACT, rst.CONTACTPHONE
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
                                   c.CONTACT_PHONE     contactPhone
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
                    where 1=1
                          ${orderCreateTimeStart ? " and rst.ORDERCREATETIME >= to_date('" + orderCreateTimeStart + "','yyyy-mm-dd hh24:mi:ss')" : ""}
                          ${orderCreateTimeEnd ? " and rst.ORDERCREATETIME <= to_date('" + orderCreateTimeEnd + "','yyyy-mm-dd hh24:mi:ss')" : ""}
                          ${payCompleteTimeStart ? " and rst.PAYCOMPLETETIME >= to_date('" + payCompleteTimeStart + "','yyyy-mm-dd hh24:mi:ss')" : ""}
                          ${payCompleteTimeEnd ? " and rst.PAYCOMPLETETIME <= to_date('" + payCompleteTimeEnd + "','yyyy-mm-dd hh24:mi:ss')" : ""}
                          ${orderAmountMin ? " and rst.ORDERAMOUNT >= '" + orderAmountMin + "'" : ""}
                          ${orderAmountMax ? " and rst.ORDERAMOUNT <= '" + orderAmountMax + "'" : ""}
                          ${outTradeNo ? " and rst.OUTTRADENO like '%" + outTradeNo + "%'" : ""}
                          ${tradeNo ? " and rst.TRADENO like '%" + tradeNo + "%'" : ""}
                          ${orderId ? " and rst.ORDERID = " + orderId + "" : ""}
                          ${str ? " and rst.ORDERID is null " : ""}
                          ${sellerCustomerNo ? " and rst.SELLERCUSTOMERNO like '%" + sellerCustomerNo + "%'" : ""}
                          ${sellerName ? " and rst.SELLERNAME like '%" + sellerName + "%'" : ""}
                          ${sellerAdminMail ? " and rst.SELLERADMINMAIL like '%" + sellerAdminMail + "%'" : ""}
                    order by rst.TRADENO desc
                  """

        def sql = new Sql(dataSource_ismp)
        def queryParam = []
        def count = sql.firstRow("select count(*) total from (${query})", queryParam)
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)

            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        [list: result, total: count.total, params: params]
    }

    def downloadList = {
        params.max = 50000
        params.offset = 0

        def orderCreateTimeStart = params.orderCreateTimeStart
        def orderCreateTimeEnd = params.orderCreateTimeEnd
        def payCompleteTimeStart = params.payCompleteTimeStart
        def payCompleteTimeEnd = params.payCompleteTimeEnd

        def orderAmountMin = params.orderAmountMin
        orderAmountMin = validAmount(orderAmountMin)
        def orderAmountMax = params.orderAmountMax
        orderAmountMax = validAmount(orderAmountMax)

        def outTradeNo = params.outTradeNo
        def tradeNo = params.tradeNo
        def bankTransNo = params.bankTransNo
        def orderId
        def str
        if(bankTransNo!=null && bankTransNo!=''){
            orderId=GwTransaction.findByBankTransNo(bankTransNo)?.order?.id
        }
        if(bankTransNo!=null && bankTransNo!='' && (orderId=='' || orderId==null)){
            str=1
        }
        def sellerCustomerNo = params.sellerCustomerNo
        def sellerName = params.sellerName
        def sellerAdminMail = params.sellerAdminMail

        def query = """
                    select rst.OUTTRADENO, rst.TRADENO, rst.ORDERCREATETIME,
                           rst.ORDERID, rst.ORDERAMOUNT, rst.PAYCOMPLETETIME,
                           rst.SELLERCUSTOMERNO, rst.SELLERADMINMAIL,
                           rst.SELLERNAME, rst.CONTACT, rst.CONTACTPHONE
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
                                   c.CONTACT_PHONE     contactPhone
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
                    where 1=1
                          ${orderCreateTimeStart ? " and rst.ORDERCREATETIME >= to_date('" + orderCreateTimeStart + "','yyyy-mm-dd hh24:mi:ss')" : ""}
                          ${orderCreateTimeEnd ? " and rst.ORDERCREATETIME <= to_date('" + orderCreateTimeEnd + "','yyyy-mm-dd hh24:mi:ss')" : ""}
                          ${payCompleteTimeStart ? " and rst.PAYCOMPLETETIME >= to_date('" + payCompleteTimeStart + "','yyyy-mm-dd hh24:mi:ss')" : ""}
                          ${payCompleteTimeEnd ? " and rst.PAYCOMPLETETIME <= to_date('" + payCompleteTimeEnd + "','yyyy-mm-dd hh24:mi:ss')" : ""}
                          ${orderAmountMin ? " and rst.ORDERAMOUNT >= '" + orderAmountMin + "'" : ""}
                          ${orderAmountMax ? " and rst.ORDERAMOUNT <= '" + orderAmountMax + "'" : ""}
                          ${outTradeNo ? " and rst.OUTTRADENO like '%" + outTradeNo + "%'" : ""}
                          ${tradeNo ? " and rst.TRADENO like '%" + tradeNo + "%'" : ""}
                          ${orderId ? " and rst.ORDERID = " + orderId + "" : ""}
                          ${str ? " and rst.ORDERID is null " : ""}
                          ${sellerCustomerNo ? " and rst.SELLERCUSTOMERNO like '%" + sellerCustomerNo + "%'" : ""}
                          ${sellerName ? " and rst.SELLERNAME like '%" + sellerName + "%'" : ""}
                          ${sellerAdminMail ? " and rst.SELLERADMINMAIL like '%" + sellerAdminMail + "%'" : ""}
                    order by rst.TRADENO desc
                  """

        def sql = new Sql(dataSource_ismp)
        def queryParam = []
        def count = sql.firstRow("select count(*) totalNum,nvl(sum(ORDERAMOUNT),0) totalAmount from (${query})", queryParam)
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)

            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "notifyFailProofInfolist", model: [list: result,totalNum:count.totalNum,totalAmount:count.totalAmount])
    }
}