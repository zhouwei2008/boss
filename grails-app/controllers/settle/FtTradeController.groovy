package settle

import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import groovy.sql.Sql
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate

class FtTradeController {

    // static allowedMethods = [save: "POST", update: "POST", delete: "POST", detail:"GET"]

    def dataSource_settle

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [ftTradeInstanceList: FtTrade.list(params), ftTradeInstanceTotal: FtTrade.count()]
    }

    def detailLiquidate = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        if (!params.mid || !params.bt || !params.tt) {
            flash.message = "${message(code: 'ftTrade.invalid.noId.label')}"
            redirect(controller: "ftLiquidate", action: "list")
        }

        def sql = new Sql(dataSource_settle)
        def queryParam = []
        def startDate
        def endDate

        if (params.bt != null && params.bt != "") {
            queryParam.add(params.bt)
        }
        if (params.tt != null && params.tt != "") {
            queryParam.add(params.tt)
        }
        if (params.mid != null && params.mid != "") {
            queryParam.add(params.mid)
        }
        if (params.start != null && params.start != "") {
            startDate =  params.start.substring(0,10)
            queryParam.add(startDate)
        }
        if (params.end != null && params.end != "") {
            endDate =   params.end.substring(0,10)
            queryParam.add(endDate)
        }

        queryParam.add(params.feeType)

        println "####${queryParam}"

        /*
        def query = """

                    select CUSTOMER_NO customerNo,SEQ_NO seqNo, TRADE_DATE tradeDate, SRV_CODE srvCode, TRADE_CODE tradeCode, AMOUNT amount, PRE_FEE preFee, POST_FEE postFee
                    from FT_TRADE
                    where LIQUIDATE_NO
                    in (select LIQUIDATE_NO
                        from FT_LIQUIDATE
                        where STATUS=0 ${params.bt ? ' and SRV_CODE=?' : ''} ${params.tt ? ' and TRADE_CODE=?' : ''} ${params.mid ? ' and CUSTOMER_NO=?' : ''}
                    )
                    order by tradeDate
                  """

        def query = """
                    select t.CUSTOMER_NO customerNo,t.SEQ_NO seqNo, t.TRADE_DATE tradeDate, t.SRV_CODE srvCode, t.TRADE_CODE tradeCode, t.AMOUNT amount, t.PRE_FEE preFee, t.POST_FEE postFee, l.LIQUIDATE_NO liquidateNo
                    from FT_TRADE t
                    left join (select LIQUIDATE_NO
                               from FT_LIQUIDATE
                               where STATUS=0 ${params.bt ? ' and SRV_CODE=?' : ''} ${params.tt ? ' and TRADE_CODE=?' : ''} ${params.mid ? ' and CUSTOMER_NO=?' : ''}
                    ) l
                    on t.LIQUIDATE_NO = l.LIQUIDATE_NO
                    where l.LIQUIDATE_NO is not null
                   """
        */
        def query = """
                    select t.CUSTOMER_NO customerNo,t.SEQ_NO seqNo, t.TRADE_DATE tradeDate, t.SRV_CODE srvCode, t.TRADE_CODE tradeCode, t.AMOUNT amount, t.PRE_FEE preFee,
                           t.POST_FEE postFee, l.LIQUIDATE_NO liquidateNo, l.SRV_NAME srvName,l.TRADE_NAME tradeName
                    from FT_TRADE t
                    left join (select li.LIQUIDATE_NO LIQUIDATE_NO,na.SRV_NAME SRV_NAME,na.TRADE_NAME TRADE_NAME
                               from FT_LIQUIDATE li
                               left join (select st.SRV_NAME SRV_NAME,tt.TRADE_NAME TRADE_NAME,st.SRV_CODE SRV_CODE,tt.TRADE_CODE TRADE_CODE
                                          from FT_SRV_TRADE_TYPE tt
                                          left join FT_SRV_TYPE st
                                          on st.ID=tt.SRV_ID
                                         ) na
                               on li.SRV_CODE = na.SRV_CODE and li.TRADE_CODE = na.TRADE_CODE
                               where
                               li.STATUS=0
                               ${params.bt ? ' and li.SRV_CODE=?' : ''}
                               ${params.tt ? ' and li.TRADE_CODE=?' : ''}
                               ${params.mid ? ' and li.CUSTOMER_NO=?' : ''}
                               ${startDate ? " and li.LIQ_DATE >=to_date(?,'yyyy-mm-dd')" : ""}
                               ${endDate ? " and li.LIQ_DATE <=to_date(?,'yyyy-mm-dd')" : ""}
                               and li.settle_type<>1
                               and li.fee_type=?
                    ) l
                    on t.LIQUIDATE_NO = l.LIQUIDATE_NO
                    where l.LIQUIDATE_NO is not null
                   """

        def count = sql.firstRow("select count(*) total from (${query})", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list()
        } as HibernateCallback)

        //println "###########${result}"
        //println "###########${count}"

        [result: result, total: count.total]
    }

    def detailFoot = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        if (!params.id) {
            flash.message = "${message(code: 'ftTrade.invalid.noId.label')}"
            redirect(controller: "ftFoot", action: "list")
        }

        def sql = new Sql(dataSource_settle)
        def queryParam = []
        if (params.id != null && params.id != "") {
            queryParam.add(params.id)
        }

        println "#1###${queryParam}"

        def query = """
                    select t.CUSTOMER_NO customerNo,t.SEQ_NO seqNo, t.TRADE_DATE tradeDate, t.SRV_CODE srvCode, t.TRADE_CODE tradeCode, t.AMOUNT amount, t.PRE_FEE preFee,
                           t.POST_FEE postFee, l.LIQUIDATE_NO liquidateNo, l.SRV_NAME srvName,l.TRADE_NAME tradeName
                    from FT_TRADE t
                    left join (select lf.SRV_CODE SRV_CODE,lf.TRADE_CODE TRADE_CODE,lf.LIQUIDATE_NO LIQUIDATE_NO,na.SRV_NAME SRV_NAME,na.TRADE_NAME TRADE_NAME
                               from (select li.SRV_CODE SRV_CODE,li.TRADE_CODE TRADE_CODE,li.LIQUIDATE_NO LIQUIDATE_NO,fo.FOOT_NO FOOT_NO
                                     from FT_LIQUIDATE li
                                     left join (select ff.FOOT_NO FOOT_NO
                                                from FT_FOOT ff
                                                where ff.id=?
                                     ) fo
                                     on li.FOOT_NO = fo.FOOT_NO
                                     where li.STATUS=1 and fo.FOOT_NO is not null
                                    ) lf
                               left join (select st.SRV_NAME SRV_NAME,tt.TRADE_NAME TRADE_NAME,st.SRV_CODE SRV_CODE,tt.TRADE_CODE TRADE_CODE
                                          from FT_SRV_TRADE_TYPE tt
                                          left join FT_SRV_TYPE st
                                          on st.ID=tt.SRV_ID
                                         ) na
                               on lf.SRV_CODE = na.SRV_CODE and lf.TRADE_CODE = na.TRADE_CODE
                    ) l
                    on t.LIQUIDATE_NO = l.LIQUIDATE_NO
                    where l.LIQUIDATE_NO is not null
                    """

        def count = sql.firstRow("select count(*) total from (${query})", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list()
        } as HibernateCallback)

        println "##2#########${result}"
        println "##3#########${count}"

        [result: result, total: count.total]
    }

    def create = {
        def ftTradeInstance = new FtTrade()
        ftTradeInstance.properties = params
        return [ftTradeInstance: ftTradeInstance]
    }

    def save = {
        def ftTradeInstance = new FtTrade(params)
        if (ftTradeInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'ftTrade.label', default: 'FtTrade'), ftTradeInstance.id])}"
            redirect(action: "list", id: ftTradeInstance.id)
        }
        else {
            render(view: "create", model: [ftTradeInstance: ftTradeInstance])
        }
    }

    def show = {
        def ftTradeInstance = FtTrade.get(params.id)
        if (!ftTradeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftTrade.label', default: 'FtTrade'), params.id])}"
            redirect(action: "list")
        }
        else {
            [ftTradeInstance: ftTradeInstance]
        }
    }

    def edit = {
        def ftTradeInstance = FtTrade.get(params.id)
        if (!ftTradeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftTrade.label', default: 'FtTrade'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [ftTradeInstance: ftTradeInstance]
        }
    }

    def update = {
        def ftTradeInstance = FtTrade.get(params.id)
        if (ftTradeInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (ftTradeInstance.version > version) {

                    ftTradeInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'ftTrade.label', default: 'FtTrade')] as Object[], "Another user has updated this FtTrade while you were editing")
                    render(view: "edit", model: [ftTradeInstance: ftTradeInstance])
                    return
                }
            }
            ftTradeInstance.properties = params
            if (!ftTradeInstance.hasErrors() && ftTradeInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'ftTrade.label', default: 'FtTrade'), ftTradeInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [ftTradeInstance: ftTradeInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftTrade.label', default: 'FtTrade'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def ftTradeInstance = FtTrade.get(params.id)
        if (ftTradeInstance) {
            try {
                ftTradeInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'ftTrade.label', default: 'FtTrade'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'ftTrade.label', default: 'FtTrade'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'ftTrade.label', default: 'FtTrade'), params.id])}"
            redirect(action: "list")
        }
    }
}
