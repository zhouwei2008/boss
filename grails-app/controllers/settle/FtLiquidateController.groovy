package settle

import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import grails.converters.JSON
import groovy.sql.Sql
import java.text.SimpleDateFormat
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate

class FtLiquidateController {
    def dataSource_settle

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def sql = new Sql(dataSource_settle)
        def queryParam = []

        def merNameList = null
        if(params.name != null && params.name.trim() != ""){
            def nameQuery = {
                or {
                    like("name","%"+params.name.trim()+"%")
                    like("registrationName","%"+params.name.trim()+"%")
                }
            }

            def cus = ismp.CmCustomer.createCriteria().list([:],nameQuery)

            println "#cus#${cus}"

            if(cus.size() > 0){
                def StringBuffer sb = new StringBuffer()
                for(def cu in cus){
                    sb.append("'").append(cu.customerNo).append("',")
                }
                merNameList = sb.deleteCharAt(sb.length()-1).toString()
            }
        }

        println "#merNameList#${merNameList}"

        def query = """
                    select customerNo,srvCode,tradeCode,feeType,max(srvName) srvName,max(tradeName) tradeName,sum(transNum) transNum,sum(amount) amount,sum(preFee) preFee,sum(postFee) postFee,
                           min(liqDate) minTime, max(liqDate) maxTime
                    from (select li.CUSTOMER_NO customerNo, li.SRV_CODE srvCode, li.TRADE_CODE tradeCode, li.fee_type feeType,
                                 li.TRANS_NUM transNum,li.AMOUNT amount, li.PRE_FEE preFee, li.POST_FEE postFee,
                                 li.LIQ_DATE liqDate,na.SRV_NAME srvName, na.TRADE_NAME tradeName
                          from FT_LIQUIDATE li
                          left join (select st.SRV_NAME SRV_NAME,tt.TRADE_NAME TRADE_NAME,st.SRV_CODE SRV_CODE,tt.TRADE_CODE TRADE_CODE
                                     from FT_SRV_TRADE_TYPE tt
                                     left join FT_SRV_TYPE st
                                     on st.ID=tt.SRV_ID
                                    ) na
                          on li.SRV_CODE = na.SRV_CODE and li.TRADE_CODE = na.TRADE_CODE
                          where li.STATUS=0 and li.settle_type<>1
                                ${params.mid ? " and CUSTOMER_NO like '%"+params.mid+"%'" : ""}
                                ${params.bType ? " and li.SRV_CODE='"+params.bType+"'" :""}
                                ${params.tType ? " and li.TRADE_CODE='"+params.tType+"'" :""}
                                ${merNameList ? " and li.CUSTOMER_NO in ("+merNameList+")":""}
                         )
                    group by customerNo,srvCode,tradeCode,feeType
                    order by customerNo desc
                 """

        def count = sql.firstRow("select count(*) total,nvl(sum(transNum),0) totalTransNum,nvl(sum(amount),0) totalAmount,nvl(sum(preFee),0) totalPreFee,nvl(sum(postFee),0) totalPostFee from (${query})", queryParam)
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('settle')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        //println "##########${result}"

        def bTypeList = FtSrvType.list()
        def tTypeList = null
        if(params.bType != null && params.bType != ""){
            tTypeList = FtSrvTradeType.findAllBySrv(FtSrvType.findBySrvCode(params.bType))
        }

        [result: result, total: count.total,totalTransNum:count.totalTransNum,totalAmount:count.totalAmount,totalPreFee:count.totalPreFee,totalPostFee:count.totalPostFee, bTypeList: bTypeList,tTypeList:tTypeList,params:params]
    }

    def queryTrade = {
        def srvCode = params.srvCode ? params.srvCode : null
        if (!srvCode) {
            flash.message = "${message(code: 'ftLiquidate.invalid.noSrvCode.label')}"
            redirect(action: "list")
        }
        def sql = "from FtSrvTradeType where srv.srvCode='" + srvCode + "'"
        def tradeLs = FtSrvTradeType.findAll(sql)
        render tradeLs as JSON
    }

    def generate = {
        if (!params.mid || !params.bt || !params.tt) {
            flash.message = "${message(code: 'ftLiquidate.invalid.noId.label')}"
            redirect(action: "list")
            return
        }

        def time = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
        def sql = new Sql(dataSource_settle)
        def query = "select seq_foot.nextval from dual"
        def seq = sql.firstRow(query).NEXTVAL.toString()
        if (seq.length() > 5) {
            seq = seq.substring(seq.length() - 5)
        } else {
            def tmp = "00000"
            seq = tmp.substring(0, 5 - seq.length()) + seq
        }

        def fn = "M" + time + seq
        def update = "update FtLiquidate set status=1,footNo='${fn}' where customerNo='${params.mid}' and srvCode='${params.bt}' and tradeCode='${params.tt}' and settleType<>1 and feeType=${params.feeType} and status=0"
        FtLiquidate.withTransaction {tx->
            def lines = FtLiquidate.executeUpdate(update);
            if (lines > 0) {
                def foot = new FtFoot()
                foot.srvCode = params.bt
                foot.tradeCode = params.tt
                foot.amount = params.amt as long
                foot.transNum = params.tn as int
                foot.customerNo = params.mid

                foot.type = 1 // manual
                //foot.feeType = 0
                //foot.feeType = 0 // jinge
                foot.preFee = params.pref as long
                foot.postFee = params.postf as long
                foot.footDate = new Date()
                foot.footNo = fn
                foot.checkStatus = 0 //wait to check
                def opId = session.op.id
                foot.createOpId = opId
                try{
                    foot.save(failOnError:true)
                }catch (Exception e){
                    log.warn("generate settle fail,", e)
                    tx.setRollbackOnly()
                    flash.message = "${message(code: 'ftLiquidate.generate.fail.label')}"
                    redirect(action: "list")
                    return
                }

                flash.message = "${message(code: 'ftLiquidate.generate.success.label')}"
                redirect(action: "list")
            } else {
                flash.message = "${message(code: 'ftLiquidate.generate.fail.label')}"
                redirect(action: "list")
            }
        }
    }
}