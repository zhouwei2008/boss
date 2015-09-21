package dsf

import groovy.sql.Sql
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate
import ismp.CmCustomer
/**
 * Created by IntelliJ IDEA.
 * User: syw
 * Date: 12-5-8
 * Time: 下午3:21
 * To change this template use File | Settings | File Templates.
 */
class AgentService {
    def dataSource_pay
    def dataSource_dsf
    /**
     * 交易明细查询
     * @param channelType
     * @return
     */
    def queryTradesDetail(def params){
        params.offset = params.offset ? params.int('offset'):0
        //最大设置为5W条
        params.max = Math.min(params.max ? params.int('max') : 10, 50000)
        params.offset = params.offset ? params.int('offset') : 0
        params.sort = params.sort ? params.sort : "id"
        params.order = params.order ? params.order : "desc"
        def query =
        {
            //def cmCustomer

            //guonan update 2011-12-29
            validDated(params)
            //商户提交时间 tradeSubdate
            if (params.tradeSubdateStart) {
                gt("tradeSubdate", Date.parse("yyyy-MM-dd", params.tradeSubdateStart))
            }
            if (params.tradeSubdateEnd) {
                lt("tradeSubdate", Date.parse("yyyy-MM-dd", params.tradeSubdateEnd) + 1)
            }
            if (params.startTime) {
                gt("tradeCommdate", Date.parse("yyyy-MM-dd", params.startTime))
            }
            if (params.endTime) {
                lt("tradeCommdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
            }
            //业管审核时间 tradeSysdate
            if (params.tradeSyschkdateStart) {
                gt("tradeSyschkdate", Date.parse("yyyy-MM-dd", params.tradeSyschkdateStart))
            }
            if (params.tradeSyschkdateEnd) {
                lt("tradeSyschkdate", Date.parse("yyyy-MM-dd", params.tradeSyschkdateEnd) + 1)
            }
            //交易完毕时间  tradeDonedate
            if (params.tradeDonedateStart) {
                gt("tradeDonedate", Date.parse("yyyy-MM-dd", params.tradeDonedateStart))
            }
            if (params.tradeDonedateEnd) {
                lt("tradeDonedate", Date.parse("yyyy-MM-dd", params.tradeDonedateEnd) + 1)
            }

            //先以商户编号为准
            if (params.batchBizid) {
                eq("batchBizid", params.batchBizid)
            } else {
                //如果没有输入商户编号，而输入的是商户名称
                if (params.batchBizname) {
                    def cmCustomer = CmCustomer.createCriteria().list {
                        eq("type", "C")
                        like("name", "%" + params.batchBizname + "%")
                    }
                    if (cmCustomer.size() > 0) {
                        'in'("batchBizid", cmCustomer.customerNo)
                    }else{
                            //如果没有此商户
                            eq("batchBizid",params.batchBizname)
                        }
                } else {
                    //如果刚进入页面指定假的查询条件，快速反应页面
                    //eq("batchBizid","100000000000469")
                }
            }
            if (params.tradeType && params.tradeType != "-1") {
                eq("tradeType", params.tradeType)
            }
            //证件号码
            if (params.certificateNum) {
                like("certificateNum", "%" + params.certificateNum + "%")
            }
            if (params.contractUsercode) {
                like("contractUsercode", "%" + params.contractUsercode + "%")
            }


            if (params.tradeCardname) {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum) {
                eq("tradeCardnum", params.tradeCardnum)
            }
            if (params.tradeAccountname != null && params.tradeAccountname != "") {
                //拼接字符串
                // BoBankDic bankDic= BoBankDic.get(params.tradeAccountname as long)
                //eq("tradeAccountname",bankDic.name)
                // def  tradeAccountnameStr = TbAdjustBankCard.executeQuery();
                def bankNames = findTradeAccountnames(params.tradeAccountname);
                //println  bankNames;
                'in'("tradeAccountname", bankNames);
            }
            if (params.tradeAccounttype) {
                eq("tradeAccounttype", params.tradeAccounttype)
            }
            if (params.batchId) {

                eq("batch", TbAgentpayInfo.get(params.batchId))
            }
            if (params.id) {
                eq("id", params.id)
            }
            /*if(params.tradeFeestyle!="-1" && params.tradeFeestyle!=null){
                if(params.tradeFeestyle=="T")
                   eq("tradeFeestyle",params.tradeFeestyle)
                else
                   isNull("tradeFeestyle")
            }*/
            if (params.tradeFeedbackcode && params.tradeFeedbackcode != '0') {
                eq("tradeFeedbackcode", params.tradeFeedbackcode);
            }
            /*if(params.tradeRemark2!="" && params.tradeRemark2!=null){
                like("tradeRemark2","%"+params.tradeRemark2+"%")
            }*/
            if (params.batchStatus && params.batchStatus != "-1") {
                "in"("tradeStatus", params.batchStatus)
            }
            if (params.tradeRefued && params.tradeRefued != "-1") {
                eq("tradeRefued", params.tradeRefued)
            }
            // order("id","desc")
        }
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)

        def summary = TbAgentpayDetailsInfo.createCriteria().get {
            and query
//            eq('tradeType', 'payment')
            projections {
                rowCount()
                sum('tradeAmount')
                sum('tradeFee')
            }
        }

        [resList:results,totalCount:summary[0],totalMoney:summary[1],totalFee: summary[2]]
    }

    def queryTbErrorLog(def params){
       def sql = new Sql(dataSource_dsf)
        //---解决oracle在排序、分页并且有Join的情况下驱动表与被驱动表混乱的情况 添加    /*+ ordered use_nl(t,t1)*/ 解决
         def query = """
                    select /*+ ordered use_nl(t,t1)*/ t.* , t1.* ,  t3.name  as customerName
                    from tb_error_log t1  ,tb_agentpay_details_info t

                    left join ismp.cm_customer t3 on t.batch_bizid = t3.customer_no
                    left join tb_agentpay_info t4 on t.batch_id = t4.batch_id
                    where t1.KEY_VALUE = t.DETAIL_ID
                          and t1.key_value is not null
                          and t1.is_check is null
                          ${params.tradeSubdateS ? " and t.TRADE_SUBDATE >= to_date('" + params.tradeSubdateS + " 00:00:00','yyyy-mm-dd hh24:mi:ss')" : ""}
                          ${params.tradeSubdateE ? " and t.TRADE_SUBDATE <= to_date('" + params.tradeSubdateE + " 23:59:59','yyyy-mm-dd hh24:mi:ss')" : ""}
                          ${params.customerNo ? " and t3.customer_no = '" + params.customerNo + "' "  : ""}
                          ${params.customerName ? " and t3.name like '%" + params.customerName + "%' "  : ""}
                          ${params.batchID ? " and t4.BATCH_ID = " + params.batchID : ""}
                          ${params.detailID ? " and t.DETAIL_ID = " + params.detailID: ""} order by t.${params.sort} ${params.order}
                  """
        log.info("=======query========${query}")
        String queryStr = query.toString();
        //println  " select * from (select x.*,rownum numbers from("+queryStr+") x where rownum < ${params.max+params.offset+1}) where numbers>${params.offset}"
          def res =  getQueryResultBySQLforPageList(dataSource_dsf,queryStr,params.offset,params.max);
        def count = sql.firstRow("select count(*) as total ,sum(TRADE_AMOUNT) as totalMoney from ("+queryStr+")")
        [resList:res,totalCount:count.total,totalMoney:count.totalMoney]
    }

    /**
     * 利用SQL分页查询
     * @param dataSource
     * @param sqlStr
     * @param offset
     * @param maxSize
     * @return
     */
    def getQueryResultBySQLforPageList(javax.sql.DataSource dataSource,String sqlStr,int offset,int maxSize){
             def sql = new Sql(dataSource);
        String querySql =sqlStr.toString();
        println querySql
          def res = sql.rows(" select * from (select x.*,rownum numbers from("+querySql+") x where rownum < ${maxSize+offset+1}) where numbers>${offset}");
         return res;
    }
    /**
     * 代收授权查询
     * @param channelType
     * @return
     */
    def queryTbEntrustPerm(def params){
        //最大设置为5W条
        params.max = Math.min(params.max ? params.int('max') : 50000, 100000)
        params.offset = params.offset ? params.int('offset') : 0
        params.sort = params.sort ? params.sort : "id"
        params.order = params.order ? params.order : "desc"
        def query =
        {
            //def cmCustomer

            //guonan update 2011-12-29
            validDated(params)
            //开户名
            if (params.cardname) {
                like("cardname", "%" + params.cardname + "%")
            }
            //开户银行
            if (params.accountname != null && params.accountname != "") {
                //拼接字符串
                // BoBankDic bankDic= BoBankDic.get(params.tradeAccountname as long)
                //eq("tradeAccountname",bankDic.name)
                // def  tradeAccountnameStr = TbAdjustBankCard.executeQuery();
                def bankNames = agentService.findTradeAccountnames(params.accountname);
                //println  bankNames;
                'in'("accountname", bankNames);
            }

            //开户账户
            if (params.cardnum) {
                eq("cardnum", params.cardnum)
            }
            //账户状态
            if (params.entrustStatus && params.entrustStatus != "-1") {
                eq("entrustStatus", params.entrustStatus)
            }

            //授权日期
            if (params.entrustStarttimeS) {
                ge("entrustStarttime", Date.parse("yyyy-MM-dd", params.entrustStarttimeS))
            }
            if (params.entrustStarttimeE) {
                lt("entrustStarttime", Date.parse("yyyy-MM-dd", params.entrustStarttimeE) + 1)
            }
            //账户类型
            if (params.accounttype && params.accounttype != "-1") {
                eq("accounttype", params.accounttype)
            }
            //是否生效 默认为是
            //if (params.entrustIsEffect) {
                 eq("entrustIsEffect", params.entrustIsEffect==null||params.entrustIsEffect==''?'0':params.entrustIsEffect)
            //}

            //截止日期
            if (params.entrustEndtimeS) {
                ge("entrustEndtime", Date.parse("yyyy-MM-dd", params.entrustEndtimeS))
            }
            if (params.entrustEndtimeE) {
                lt("entrustEndtime", Date.parse("yyyy-MM-dd", params.entrustEndtimeE) + 1)
            }

            //所属商户编号，先以商户编号为准
            if (params.customerNo) {
                eq("customerNo", params.customerNo)
            } else {
                //如果没有输入商户编号，而输入的是商户名称
                if (params.customerName) {
                    def customerNos = CmCustomer.executeQuery("select customerNo from CmCustomer where name like '%"+params.customerName+"%'")
                    if (customerNos) {
                        'in'("customerNo", customerNos)
                    }else{
                        //如果没有此商户
                    eq("customerNo",params.customerName)

                    }
                } else {
                    //如果刚进入页面指定假的查询条件，快速反应页面
                    //eq("batchBizid","100000000000469")
                }
            }

        }
        def results = TbEntrustPerm.createCriteria().list(params, query)

      /*  def summary = TbEntrustPerm.createCriteria().get {
            and query
//            eq('tradeType', 'payment')
            projections {
                rowCount()
            }
        }*/

        [resList:results,totalCount:results.size()]
    }



   /**
 * 验证日期间隔有效性
 *
 * @param params 表单参数
 * @return
 * @author guonan  2011-12-29
 *
 */
    def validDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startTime == null && params.endTime == null) {
            def gCalendar = new GregorianCalendar()
            params.endTime = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startTime = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startTime && !params.endTime) {
            params.endTime = params.startTime
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startTime && params.endTime) {
            params.startTime = params.endTime
        }
        //-----------验证审核时间 start----------
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.tradeSyschkdateStart == null && params.tradeSyschkdateEnd == null) {
            def gCalendar = new GregorianCalendar()
            params.tradeSyschkdateEnd = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.tradeSyschkdateStart = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.tradeSyschkdateStart && !params.tradeSyschkdateEnd) {
            params.tradeSyschkdateEnd = params.tradeSyschkdateStart
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.tradeSyschkdateStart && params.tradeSyschkdateEnd) {
            params.tradeSyschkdateStart = params.tradeSyschkdateEnd
        }
        //-----------验证审核时间 end----------
        //-----------验证交易完毕时间 start----------
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.tradeDonedateStart == null && params.tradeDonedateEnd == null) {
            def gCalendar = new GregorianCalendar()
            params.tradeDonedateEnd = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.tradeDonedateStart = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.tradeDonedateStart && !params.tradeDonedateEnd) {
            params.tradeDonedateEnd = params.tradeDonedateStart
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.tradeDonedateStart && params.tradeDonedateEnd) {
            params.tradeDonedateStart = params.tradeDonedateEnd
        }
        //-----------验证交易完毕时间 end----------
    }

   /**
 * 查询银行并拼接字符串
 * @param tradeAccountname
 * @return
 */
    def findTradeAccountnames(String tradeAccountname) {
        def tradeAccountNames = TbAdjustBankCard.executeQuery("select bankNames from TbAdjustBankCard where bankCode = '" + tradeAccountname + "'");
        return tradeAccountNames;
    }
    /**
     * 查询银行并拼接字符串
     * @param tradeAccountname
     * @return
     */
    def findTradeAccountnamesForStr(String tradeAccountname) {
        String bankNames = '';
        def sql = new Sql(DatasourcesUtils.getDataSource("dsf"))
        def strSql = "select wm_concat(''''||t.bank_names||'''') as bankNames from tb_adjust_bank_bak t where t.bank_code = '" + tradeAccountname + "'";

        sql.eachRow(strSql) {

            bankNames = it.bankNames;
        }
        println bankNames;
        return bankNames;
    }


    /**
     * 查询模糊银行，用来显示下拉列表
     */
    def bankListNew = {
        return TbAdjustBankCard.executeQuery("select distinct bankCode ,bankCode , note from TbAdjustBankCard order by bankCode");
    }


}
