package boss

import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import groovy.sql.Sql
import java.text.SimpleDateFormat
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate
import org.apache.kahadb.util.DiskBenchmark.Report

class ReportController {

    def dataSource_ismp
    def dataSource_account
    def dataSource_dsf
    def dataSource_boss

    def index = { }

    //update 时间验证函数 as sunweiguo 2012-06-01
    def validDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startDate==null && params.endDate==null){
            def gCalendar= new GregorianCalendar()
            gCalendar.add(GregorianCalendar.DATE,-1)
            params.endDate=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startDate=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startTime && !params.endTime){
             params.endTime=params.startTime
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startTime && params.endTime){
             params.startTime=params.endTime
        }
        if (params.startTime && params.endTime) {

        }
    }
    def queryBank = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null

        def sql = new Sql(dataSource_ismp)
        def queryParam = []
        if (startDate) {
            queryParam.add(new java.sql.Date(startDate.getTime()))
        }
        if (endDate) {
            queryParam.add(new java.sql.Date(endDate.getTime()))
        }
        def query = """select sum(amount) am,count(*) co, payer_name, to_char(date_created,'yyyy-mm-dd') da
      from trade_base where trade_type='charge' and payer_name is not null ${startDate ? ' and date_created>=? ' : ''} ${endDate ? ' and date_created<=? ' : ''}
      group by payer_name, to_char(date_created,'yyyy-mm-dd') order by to_char(date_created,'yyyy-mm-dd') desc,payer_name"""

        def count = sql.firstRow("select count(*) total,nvl(sum(am),0) am,nvl(sum(co),0) co from (${query})", queryParam)
        //def result = sql.rows(query.toString() + " ", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        //println result.dump()
        //println count.total
        [result: result, total: count.total, am: count.am, co: count.co, params: params]
    }
    //update 银行交易日报表下载 as sunweiguo
    def queryBankDownLoad = {
        //params.max = Math.min(params.max ? params.int('max') : 01, 100)
        params.max = 5000   //下载记录最大值
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null

        def sql = new Sql(dataSource_ismp)
        def queryParam = []
        if (startDate) {
            queryParam.add(new java.sql.Date(startDate.getTime()))
        }
        if (endDate) {
            queryParam.add(new java.sql.Date(endDate.getTime()))
        }
        def query = """select sum(amount) am,count(*) co, payer_name, to_char(date_created,'yyyy-mm-dd') da
      from trade_base where trade_type='charge' and payer_name is not null ${startDate ? ' and date_created>=? ' : ''} ${endDate ? ' and date_created<=? ' : ''}
      group by payer_name, to_char(date_created,'yyyy-mm-dd') order by to_char(date_created,'yyyy-mm-dd') desc,payer_name"""

        def count = sql.firstRow("select count(*) total,nvl(sum(am),0) am,nvl(sum(co),0) co from (${query})", queryParam)
        //def result = sql.rows(query.toString() + " ", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        validDated(params)
        //println result.dump()
        //println count.total
        [result: result, total: count.total, am: count.am, co: count.co, params: params]

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")

        render(view:"_queryBankList",model:[result: result, total: count.total, am: count.am, co: count.co, params: params])
    }
    def bankType = {
        log.info('bank report begin')
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null
        def startTradeDate = params.startDate ? params.startDate.toString().replace('-', '') : null
        def endTradeDate=params.endDate?params.endDate.toString().replace('-',''):null
        def bankAccount = params.bankName ? params.bankName : null
//        if(params.bankName!=null && params.bankName!='')  {
//           bankAccount= BoAcquirerAccount.findByBranchName(params.bankName)?.id
//        }
        def bankChannel
        if (params.paymentType != '-1' && params.paymentType != null && params.paymentType != '') {
            bankChannel = params.paymentType
        } else {
            bankChannel = '0'
        }
        def sql = new Sql(dataSource_ismp)
        def queryParam = []
        def queryParam1 = []
        def queryParam2 = []
        if (startDate) {
            queryParam.add(new java.sql.Date(startDate.getTime()))
            queryParam2.add(startTradeDate)
        }
        if (endDate) {
            queryParam.add(new java.sql.Date(endDate.getTime()))
            queryParam2.add(endTradeDate)
        }
        if (bankAccount) {
            queryParam.add(bankAccount)
            queryParam1.add(bankAccount)
            queryParam2.add(bankAccount)
        }
        if (bankChannel != '0' && bankChannel != null) {
            queryParam.add(bankChannel)
            queryParam2.add(bankChannel)
        }
        log.info('除代收外的交易入账 begin')
        def query = """select sum(b.amount) am,count(*) co,fromacctnum num,channel
          from gwtrxs t ,agentcoll a,trade_base b
          where t.fromacctnum=a.inner_acount_no
          and t.trxnum=b.out_trade_no
          and (trxsts='1' or trxsts='3')
          ${startTradeDate ? ' and b.trade_date>=? ' : ''} ${endTradeDate ? ' and b.trade_date<=? ' : ''}
          ${bankAccount ? ' and a.id=? ' : ''}
          ${bankChannel != '0' ? ' and channel=? ' : ''}
          group by fromacctnum,channel order by fromacctnum desc"""
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        //除代收外的交易入账
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam2.size(); i++) {
                sqlquery.setParameter(i, queryParam2.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)
        def inTotalCoAndAm = sql.firstRow("select sum(co) totalCo,sum(am) totalAm from (${query})", queryParam2)
        log.info('除代收外的交易入账 end')

        log.info('银行类贷记账户 begin')
        def query1 = """select inner_acount_no no,branch_name name,id
      from agentcoll  ${bankAccount ? ' where id=? ' : ''}
      order by inner_acount_no desc"""
        //银行类贷记账户
        def accountNo = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query1.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam1.size(); i++) {
                sqlquery.setParameter(i, queryParam1.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        def count = sql.firstRow("select count(*) total from (${query1})", queryParam1)
        log.info('银行类贷记账户 end')

        log.info('除代付外的退款金额 begin')
        def query2 = """select count(*) co,
                           sum(t.money) am,
                           a.inner_acount_no no,
                           a.branch_name name,
                           g.channel channel,
                           a.id id
                      from (select c.money, b.trade_type, b.out_trade_no,c.last_updated,c.id
                              from trade_base b,
                                   (select d.amount money,d.root_id,d.last_updated,d.id
                                      from trade_base d
                                     where d.trade_type = 'refund'
                                       and d.status = 'completed') c
                             where b.id = c.root_id
                               and b.trade_type = 'charge') t,
                           gwtrxs g,
                           agentcoll a,
                           trade_refund r
                     where t.out_trade_no = g.trxnum
                       and r.id=t.id
                       and r.acquirer_account_id=a.id
                       ${startDate ? ' and t.last_updated>=? ' : ''} ${endDate ? ' and t.last_updated<? ' : ''}
                       ${bankAccount ? ' and a.id=? ' : ''}
                       ${bankChannel != '0' ? ' and g.channel=? ' : ''}
                       and (g.trxsts = '1' or g.trxsts = '3')
                       group by a.inner_acount_no ,
                       a.branch_name ,
                       g.channel ,
                       a.id """
        //除代付外的退款金额
        def refund = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query2.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)
        def totalCoAndAm = sql.firstRow("select sum(co) totalCo,sum(am) totalAm from (${query2})", queryParam)
        log.info('除代付外的退款金额 end')

        log.info('代收付 begin')
        //代收付
        def query4 = """ select trade_type channel,sum(trade_amount) am,count(*) co ,p.tb_pc_dk_chanel id
                          from tb_agentpay_details_info t,tb_pc_info p
                          where trade_status='2'
                          and t.dk_pc_no=p.tb_pc_id
                          and trade_feedbackcode='成功'
                          ${startDate ? ' and t.trade_finishdate>=? ' : ''} ${endDate ? ' and t.trade_finishdate<? ' : ''}
                          ${bankAccount ? ' and p.tb_pc_dk_chanel=? ' : ''}
                          ${bankChannel != '0' ? ' and trade_type=? ' : ''}
                          group by trade_type,tb_pc_dk_chanel """
        HibernateTemplate htq = DatasourcesUtils.newHibernateTemplate('dsf')
        def sql1 = new Sql(dataSource_dsf)
        def dsf = htq.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query4.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)
        def totalDs = sql1.firstRow("select sum(co) totalCo,sum(am) totalAm from (${query4}) where channel='S'", queryParam)
        def totalDf = sql1.firstRow("select sum(co) totalCo,sum(am) totalAm from (${query4}) where channel='F'", queryParam)

        log.info('代收付 end')
        def dsAm = 0
        def dsCo = 0
        def dfAm = 0
        def dfCo = 0
        if (totalDs[0] != null) {
            dsCo = totalDs.totalCo
        }
        if (totalDs[1] != null) {
            dsAm = totalDs.totalAm
        }
        if (totalDf[0] != null) {
            dfCo = totalDf.totalCo
        }
        if (totalDf[1] != null) {
            dfAm = totalDf.totalAm
        }
        def query3 = """select count(*) co,
                           sum(t.real_transfer_amount) am,
                           a.branch_name name, a.inner_acount_no no
                           from TRADE_WITHDRAWN t, agentcoll a,trade_base b
                           where t.acquirer_account_id = a.id
                           and t.id=b.id
                           ${startDate ? ' and b.last_updated>=? ' : ''} ${endDate ? ' and b.last_updated<? ' : ''}
                           ${bankAccount ? ' and a.id=? ' : ''}
                           and t.handle_status = 'completed'
                     group by a.branch_name, a.inner_acount_no
                     order by a.inner_acount_no desc"""
        def withdrawn = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query3.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            queryParam.remove(bankChannel)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)
        def totalWithdrawn = sql.firstRow("select sum(co) totalWithdrawnCo,sum(am) totalWithdrawnAm from (${query3})", queryParam)
        if (bankChannel == '1') {
            render(view: "bankType1", model: [result: result, result1: accountNo, result2: refund, result3: withdrawn, params: params, total: count.total, totalCo: totalCoAndAm.totalCo,
                    totalAm: totalCoAndAm.totalAm, inTotalCo: inTotalCoAndAm.totalCo, inTotalAm: inTotalCoAndAm.totalAm,
                    totalWithdrawnCo: totalWithdrawn.totalWithdrawnCo, totalWithdrawnAm: totalWithdrawn.totalWithdrawnAm, date: new Date(), bankChannel: bankChannel, result4: dsf])
        } else if (bankChannel == '2') {
            render(view: "bankType2", model: [result: result, result1: accountNo, result2: refund, result3: withdrawn, params: params, total: count.total, totalCo: totalCoAndAm.totalCo,
                    totalAm: totalCoAndAm.totalAm, inTotalCo: inTotalCoAndAm.totalCo, inTotalAm: inTotalCoAndAm.totalAm,
                    totalWithdrawnCo: totalWithdrawn.totalWithdrawnCo, totalWithdrawnAm: totalWithdrawn.totalWithdrawnAm, date: new Date(), bankChannel: bankChannel, result4: dsf])
        } else if (bankChannel == '3') {
            render(view: "bankType3", model: [result: result, result1: accountNo, result2: refund, result3: withdrawn, params: params, total: count.total, totalCo: totalCoAndAm.totalCo,
                    totalAm: totalCoAndAm.totalAm, inTotalCo: inTotalCoAndAm.totalCo, inTotalAm: inTotalCoAndAm.totalAm,
                    totalWithdrawnCo: totalWithdrawn.totalWithdrawnCo, totalWithdrawnAm: totalWithdrawn.totalWithdrawnAm, date: new Date(), bankChannel: bankChannel, result4: dsf])
        } else if (bankChannel == 'S') {
            render(view: "bankType4", model: [result: result, result1: accountNo, result2: refund, result3: withdrawn, params: params, total: count.total, totalCo: 0,
                    totalAm: 0, inTotalCo: totalDs.totalCo ? totalDs.totalCo : 0, inTotalAm: totalDs.totalAm ? totalDs.totalAm * 100 : 0,
                    totalWithdrawnCo: totalWithdrawn.totalWithdrawnCo, totalWithdrawnAm: totalWithdrawn.totalWithdrawnAm, date: new Date(), bankChannel: bankChannel, result4: dsf])
        } else if (bankChannel == 'F') {
            render(view: "bankType5", model: [result: result, result1: accountNo, result2: refund, result3: withdrawn, params: params, total: count.total, totalCo: totalDf.totalCo ? totalDf.totalCo : 0,
                    totalAm: totalDf.totalAm ? totalDf.totalAm * 100 : 0, inTotalCo: 0, inTotalAm: 0,
                    totalWithdrawnCo: totalWithdrawn.totalWithdrawnCo, totalWithdrawnAm: totalWithdrawn.totalWithdrawnAm, date: new Date(), bankChannel: bankChannel, result4: dsf])
        } else {
            render(view: "bankType", model: [result: result, result1: accountNo, result2: refund, result3: withdrawn, params: params, total: count.total, totalCo: (totalCoAndAm.totalCo ? totalCoAndAm.totalCo : 0 as int) + dfCo,
                    totalAm: (totalCoAndAm.totalAm ? totalCoAndAm.totalAm : 0 as int) + dfAm * 100, inTotalCo: (inTotalCoAndAm.totalCo ? inTotalCoAndAm.totalCo : 0 as int) + dsCo, inTotalAm: (inTotalCoAndAm.totalAm ? inTotalCoAndAm.totalAm : 0 as int) + dsAm * 100,
                    totalWithdrawnCo: totalWithdrawn.totalWithdrawnCo, totalWithdrawnAm: totalWithdrawn.totalWithdrawnAm, date: new Date(), bankChannel: bankChannel, result4: dsf])
        }
        log.info('bank report end')
    }
    //银行分类报表下载
    def bankListDownload = {

        log.info('bank reportDl begin')
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null
        def startTradeDate = params.startDate ? params.startDate.toString().replace('-', '') : null
        def endTradeDate=params.endDate?params.endDate.toString().replace('-',''):null
        def bankAccount = params.bankName ? params.bankName : null
//        if(params.bankName!=null && params.bankName!='')  {
//           bankAccount= BoAcquirerAccount.findByBranchName(params.bankName)?.id
//        }

        def bankChannel
        if (params.paymentType != '-1' && params.paymentType != null && params.paymentType != '') {
            bankChannel = params.paymentType
        } else {
            bankChannel = '0'
        }
        def sql = new Sql(dataSource_ismp)
        def queryParam = []
        def queryParam1 = []
        def queryParam2 = []
        if (startDate) {
            queryParam.add(new java.sql.Date(startDate.getTime()))
            queryParam2.add(startTradeDate)
        }
        if (endDate) {
            queryParam.add(new java.sql.Date(endDate.getTime()))
            queryParam2.add(endTradeDate)
        }
        if (bankAccount) {
            queryParam.add(bankAccount)
            queryParam1.add(bankAccount)
            queryParam2.add(bankAccount)
        }
        if (bankChannel != '0' && bankChannel != null) {
            queryParam.add(bankChannel)
            queryParam2.add(bankChannel)
        }
        log.info('除代收外的交易入账 begin')
        def query = """select sum(b.amount) am,count(*) co,fromacctnum num,channel
          from gwtrxs t ,agentcoll a,trade_base b
          where t.fromacctnum=a.inner_acount_no
          and t.trxnum=b.out_trade_no
          and (trxsts='1' or trxsts='3')
          ${startTradeDate ? ' and b.trade_date>=? ' : ''} ${endTradeDate ? ' and b.trade_date<=? ' : ''}
          ${bankAccount ? ' and a.id=? ' : ''}
          ${bankChannel != '0' ? ' and channel=? ' : ''}
          group by fromacctnum,channel order by fromacctnum desc"""
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        //除代收外的交易入账
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam2.size(); i++) {
                sqlquery.setParameter(i, queryParam2.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)
        def inTotalCoAndAm = sql.firstRow("select sum(co) totalCo,sum(am) totalAm from (${query})", queryParam2)
        log.info('除代收外的交易入账 end')

        log.info('银行类贷记账户 begin')
        def query1 = """select inner_acount_no no,branch_name name,id
      from agentcoll  ${bankAccount ? ' where id=? ' : ''}
      order by inner_acount_no desc"""
        //银行类贷记账户
        def accountNo = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query1.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam1.size(); i++) {
                sqlquery.setParameter(i, queryParam1.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        def count = sql.firstRow("select count(*) total from (${query1})", queryParam1)
        log.info('银行类贷记账户 end')

        log.info('除代付外的退款金额 begin')
        def query2 = """select count(*) co,
                           sum(t.money) am,
                           a.inner_acount_no no,
                           a.branch_name name,
                           g.channel channel,
                           a.id id
                      from (select c.money, b.trade_type, b.out_trade_no,c.last_updated,c.id
                              from trade_base b,
                                   (select d.amount money,d.root_id,d.last_updated,d.id
                                      from trade_base d
                                     where d.trade_type = 'refund'
                                       and d.status = 'completed') c
                             where b.id = c.root_id
                               and b.trade_type = 'charge') t,
                           gwtrxs g,
                           agentcoll a,
                           trade_refund r
                     where t.out_trade_no = g.trxnum
                       and r.id=t.id
                       and r.acquirer_account_id=a.id
                       ${startDate ? ' and t.last_updated>=? ' : ''} ${endDate ? ' and t.last_updated<? ' : ''}
                       ${bankAccount ? ' and a.id=? ' : ''}
                       ${bankChannel != '0' ? ' and g.channel=? ' : ''}
                       and (g.trxsts = '1' or g.trxsts = '3')
                       group by a.inner_acount_no ,
                       a.branch_name ,
                       g.channel ,
                       a.id """
        //除代付外的退款金额
        def refund = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query2.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)
        def totalCoAndAm = sql.firstRow("select sum(co) totalCo,sum(am) totalAm from (${query2})", queryParam)
        log.info('除代付外的退款金额 end')

        log.info('代收付 begin')
        //代收付
        def query4 = """ select trade_type channel,sum(trade_amount) am,count(*) co ,p.tb_pc_dk_chanel id
                          from tb_agentpay_details_info t,tb_pc_info p
                          where trade_status='2'
                          and t.dk_pc_no=p.tb_pc_id
                          and trade_feedbackcode='成功'
                          ${startDate ? ' and t.trade_finishdate>=? ' : ''} ${endDate ? ' and t.trade_finishdate<? ' : ''}
                          ${bankAccount ? ' and p.tb_pc_dk_chanel=? ' : ''}
                          ${bankChannel != '0' ? ' and trade_type=? ' : ''}
                          group by trade_type,tb_pc_dk_chanel """
        HibernateTemplate htq = DatasourcesUtils.newHibernateTemplate('dsf')
        def sql1 = new Sql(dataSource_dsf)
        def dsf = htq.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query4.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)
        def totalDs = sql1.firstRow("select sum(co) totalCo,sum(am) totalAm from (${query4}) where channel='S'", queryParam)
        def totalDf = sql1.firstRow("select sum(co) totalCo,sum(am) totalAm from (${query4}) where channel='F'", queryParam)

        log.info('代收付 end')
        def dsAm = 0
        def dsCo = 0
        def dfAm = 0
        def dfCo = 0
        if (totalDs[0] != null) {
            dsCo = totalDs.totalCo
        }
        if (totalDs[1] != null) {
            dsAm = totalDs.totalAm
        }
        if (totalDf[0] != null) {
            dfCo = totalDf.totalCo
        }
        if (totalDf[1] != null) {
            dfAm = totalDf.totalAm
        }
        def query3 = """select count(*) co,
                           sum(t.real_transfer_amount) am,
                           a.branch_name name, a.inner_acount_no no
                           from TRADE_WITHDRAWN t, agentcoll a,trade_base b
                           where t.acquirer_account_id = a.id
                           and t.id=b.id
                           ${startDate ? ' and b.last_updated>=? ' : ''} ${endDate ? ' and b.last_updated<? ' : ''}
                           ${bankAccount ? ' and a.id=? ' : ''}
                           and t.handle_status = 'completed'
                     group by a.branch_name, a.inner_acount_no
                     order by a.inner_acount_no desc"""
        def withdrawn = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query3.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            queryParam.remove(bankChannel)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)
        def totalWithdrawn = sql.firstRow("select sum(co) totalWithdrawnCo,sum(am) totalWithdrawnAm from (${query3})", queryParam)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        if (bankChannel == '1') {
            render(template: "bankB2CList", model: [result: result, result1: accountNo, result2: refund, result3: withdrawn, params: params, total: count.total, totalCo: totalCoAndAm.totalCo,
                    totalAm: totalCoAndAm.totalAm, inTotalCo: inTotalCoAndAm.totalCo, inTotalAm: inTotalCoAndAm.totalAm,
                    totalWithdrawnCo: totalWithdrawn.totalWithdrawnCo, totalWithdrawnAm: totalWithdrawn.totalWithdrawnAm, date: new Date(), bankChannel: bankChannel, result4: dsf])
        } else if (bankChannel == '2') {
            render(template: "bankB2BList", model: [result: result, result1: accountNo, result2: refund, result3: withdrawn, params: params, total: count.total, totalCo: totalCoAndAm.totalCo,
                    totalAm: totalCoAndAm.totalAm, inTotalCo: inTotalCoAndAm.totalCo, inTotalAm: inTotalCoAndAm.totalAm,
                    totalWithdrawnCo: totalWithdrawn.totalWithdrawnCo, totalWithdrawnAm: totalWithdrawn.totalWithdrawnAm, date: new Date(), bankChannel: bankChannel, result4: dsf])
        } else if (bankChannel == '3') {
            render(template: "bankDEList", model: [result: result, result1: accountNo, result2: refund, result3: withdrawn, params: params, total: count.total, totalCo: totalCoAndAm.totalCo,
                    totalAm: totalCoAndAm.totalAm, inTotalCo: inTotalCoAndAm.totalCo, inTotalAm: inTotalCoAndAm.totalAm,
                    totalWithdrawnCo: totalWithdrawn.totalWithdrawnCo, totalWithdrawnAm: totalWithdrawn.totalWithdrawnAm, date: new Date(), bankChannel: bankChannel, result4: dsf])
        } else if (bankChannel == 'S') {
            render(template: "bankDsList", model: [result: result, result1: accountNo, result2: refund, result3: withdrawn, params: params, total: count.total, totalCo: 0,
                    totalAm: 0, inTotalCo: totalDs.totalCo ? totalDs.totalCo : 0, inTotalAm: totalDs.totalAm ? totalDs.totalAm * 100 : 0,
                    totalWithdrawnCo: totalWithdrawn.totalWithdrawnCo, totalWithdrawnAm: totalWithdrawn.totalWithdrawnAm, date: new Date(), bankChannel: bankChannel, result4: dsf])
        } else if (bankChannel == 'F') {
            render(template: "bankDfList", model: [result: result, result1: accountNo, result2: refund, result3: withdrawn, params: params, total: count.total, totalCo: totalDf.totalCo ? totalDf.totalCo : 0,
                    totalAm: totalDf.totalAm ? totalDf.totalAm * 100 : 0, inTotalCo: 0, inTotalAm: 0,
                    totalWithdrawnCo: totalWithdrawn.totalWithdrawnCo, totalWithdrawnAm: totalWithdrawn.totalWithdrawnAm, date: new Date(), bankChannel: bankChannel, result4: dsf])
        } else {
            render(template: "bankList", model: [result: result, result1: accountNo, result2: refund, result3: withdrawn, params: params, total: count.total, totalCo: (totalCoAndAm.totalCo ? totalCoAndAm.totalCo : 0 as int) + dfCo,
                    totalAm: (totalCoAndAm.totalAm ? totalCoAndAm.totalAm : 0 as int) + dfAm * 100, inTotalCo: (inTotalCoAndAm.totalCo ? inTotalCoAndAm.totalCo : 0 as int) + dsCo, inTotalAm: (inTotalCoAndAm.totalAm ? inTotalCoAndAm.totalAm : 0 as int) + dsAm * 100,
                    totalWithdrawnCo: totalWithdrawn.totalWithdrawnCo, totalWithdrawnAm: totalWithdrawn.totalWithdrawnAm, date: new Date(), bankChannel: bankChannel, result4: dsf])
        }
        log.info('bank reportDl end')


    }
    def queryCustom = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null

        def sql = new Sql(dataSource_ismp)
        def queryParam = []
        if (startDate) {
            queryParam.add(new java.sql.Date(startDate.getTime()))
        }
        if (endDate) {
            queryParam.add(new java.sql.Date(endDate.getTime()))
        }
        def query = """select sum(amount) am,count(*) co, payee_name, to_char(date_created,'yyyy-mm-dd') da
      from trade_base where trade_type='payment' and payee_name is not null ${startDate ? ' and date_created>=? ' : ''} ${endDate ? ' and date_created<=? ' : ''}
      group by payee_name, to_char(date_created,'yyyy-mm-dd') order by to_char(date_created,'yyyy-mm-dd') desc,payee_name"""

        def count = sql.firstRow("select count(*) total,nvl(sum(am),0) am,nvl(sum(co),0) co from (${query})", queryParam)
        //def result = sql.rows(query.toString() + " ", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        //println result.dump()
        //println count.total
        [result: result, total: count.total, am: count.am, co: count.co, params: params]
    }
    // update 增加客户交易日报报表下载功能 as sunweiguo 2012-06-01
    def queryCustomDownLoad ={
        //params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.max = 5000
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null

        def sql = new Sql(dataSource_ismp)
        def queryParam = []
        if (startDate) {
            queryParam.add(new java.sql.Date(startDate.getTime()))
        }
        if (endDate) {
            queryParam.add(new java.sql.Date(endDate.getTime()))
        }
        def query = """select sum(amount) am,count(*) co, payee_name, to_char(date_created,'yyyy-mm-dd') da
      from trade_base where trade_type='payment' and payee_name is not null ${startDate ? ' and date_created>=? ' : ''} ${endDate ? ' and date_created<=? ' : ''}
      group by payee_name, to_char(date_created,'yyyy-mm-dd') order by to_char(date_created,'yyyy-mm-dd') desc,payee_name"""

        def count = sql.firstRow("select count(*) total,nvl(sum(am),0) am,nvl(sum(co),0) co from (${query})", queryParam)
        //def result = sql.rows(query.toString() + " ", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        //println result.dump()
        //println count.total
        [result: result, total: count.total, am: count.am, co: count.co, params: params]

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(view: "_queryCustomList", model: [result: result, total: count.total, am: count.am, co: count.co, params: params])
    }

    def queryFee = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null

        def sql = new Sql(dataSource_account)
        def queryParam = []
        def feeAccount = BoInnerAccount.findByKey('feeAcc')

        queryParam.add(feeAccount.accountNo)

        if (startDate) {
            queryParam.add(new java.sql.Date(startDate.getTime()))
        }
        if (endDate) {
            queryParam.add(new java.sql.Date(endDate.getTime()))
        }
        def sqlParams = []
        sqlParams.addAll(queryParam)
        sqlParams.addAll(queryParam)

//    def query = """select count(*) co, sum(amount) am, to_char(date_created,'yyyy-mm-dd') da from trade_base
//       where payee_account_no=? ${startDate ? ' and date_created>=? ' : ''} ${endDate ? ' and date_created<=? ' : ''}
//       group by to_char(date_created,'yyyy-mm-dd') order by to_char(date_created,'yyyy-mm-dd')"""

        def query = """
    select da,sum(in_am) in_am,sum(in_co) in_co,sum(out_am) out_am,sum(out_co) out_co from (
      select to_char(date_created,'yyyy-mm-dd') da, sum(amount) in_am,count(*) in_co, 0 out_am, 0 out_co from ac_transaction where to_account_no=? ${startDate ? ' and date_created>=? ' : ''} ${endDate ? ' and date_created<=? ' : ''}
      group by to_char(date_created,'yyyy-mm-dd')
      union all
      select to_char(date_created,'yyyy-mm-dd') da, 0 in_am,0 in_co, sum(amount) out_am, count(*) out_co from ac_transaction where from_account_no=? ${startDate ? ' and date_created>=? ' : ''} ${endDate ? ' and date_created<=? ' : ''}
      group by to_char(date_created,'yyyy-mm-dd')
    ) group by da order by da desc
    """

        def count = sql.firstRow("select count(*) total,nvl(sum(in_am),0) in_am,nvl(sum(in_co),0) in_co,nvl(sum(out_am),0) out_am,nvl(sum(out_co),0) out_co from (${query})", sqlParams)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('account')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < sqlParams.size(); i++) {
                sqlquery.setParameter(i, sqlParams.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        //println result.dump()
        //println count.total
        [result: result, total: count.total, in_am: count.in_am, in_co: count.in_co, out_am: count.out_am, out_co: count.out_co, params: params]
    }
    def queryFeeDownLoad = {
        //params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.max = 5000
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null

        def sql = new Sql(dataSource_account)
        def queryParam = []
        def feeAccount = BoInnerAccount.findByKey('feeAcc')

        queryParam.add(feeAccount.accountNo)

        if (startDate) {
            queryParam.add(new java.sql.Date(startDate.getTime()))
        }
        if (endDate) {
            queryParam.add(new java.sql.Date(endDate.getTime()))
        }
        def sqlParams = []
        sqlParams.addAll(queryParam)
        sqlParams.addAll(queryParam)

//    def query = """select count(*) co, sum(amount) am, to_char(date_created,'yyyy-mm-dd') da from trade_base
//       where payee_account_no=? ${startDate ? ' and date_created>=? ' : ''} ${endDate ? ' and date_created<=? ' : ''}
//       group by to_char(date_created,'yyyy-mm-dd') order by to_char(date_created,'yyyy-mm-dd')"""

        def query = """
    select da,sum(in_am) in_am,sum(in_co) in_co,sum(out_am) out_am,sum(out_co) out_co from (
      select to_char(date_created,'yyyy-mm-dd') da, sum(amount) in_am,count(*) in_co, 0 out_am, 0 out_co from ac_transaction where to_account_no=? ${startDate ? ' and date_created>=? ' : ''} ${endDate ? ' and date_created<=? ' : ''}
      group by to_char(date_created,'yyyy-mm-dd')
      union all
      select to_char(date_created,'yyyy-mm-dd') da, 0 in_am,0 in_co, sum(amount) out_am, count(*) out_co from ac_transaction where from_account_no=? ${startDate ? ' and date_created>=? ' : ''} ${endDate ? ' and date_created<=? ' : ''}
      group by to_char(date_created,'yyyy-mm-dd')
    ) group by da order by da desc
    """

        def count = sql.firstRow("select count(*) total,nvl(sum(in_am),0) in_am,nvl(sum(in_co),0) in_co,nvl(sum(out_am),0) out_am,nvl(sum(out_co),0) out_co from (${query})", sqlParams)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('account')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < sqlParams.size(); i++) {
                sqlquery.setParameter(i, sqlParams.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        //println result.dump()
        //println count.total
        [result: result, total: count.total, in_am: count.in_am, in_co: count.in_co, out_am: count.out_am, out_co: count.out_co, params: params]

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(view: "_queryFeeList", model:  [result: result, total: count.total, in_am: count.in_am, in_co: count.in_co, out_am: count.out_am, out_co: count.out_co, params: params])
    }
    def queryFault = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null

        def sql = new Sql(dataSource_ismp)
        def queryParam = []
        if (startDate) {
            queryParam.add(new java.sql.Date(startDate.getTime()))
        }
        if (endDate) {
            queryParam.add(new java.sql.Date(endDate.getTime()))
        }
        def query = """
      select count(*) co,sum(trxamount) am,to_char(auth_date,'yyyy-mm-dd') da,acquire_code bank_co,decode(change_sts,1,'成功',2,'失败') status
      from acquire_fault_trx where 1=1 ${startDate ? ' and auth_date>=? ' : ''} ${endDate ? ' and auth_date<=? ' : ''}
      group by acquire_code,to_char(auth_date,'yyyy-mm-dd'),decode(change_sts,1,'成功',2,'失败') order by to_char(auth_date,'yyyy-mm-dd') desc,acquire_code,decode(change_sts,1,'成功',2,'失败')
      """

        def count = sql.firstRow("select count(*) total,nvl(sum(am),0) am,nvl(sum(co),0) co from (${query})", queryParam)
        //def result = sql.rows(query.toString() + " ", queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(query.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        //println result.dump()
        //println count.total
        [result: result, total: count.total, co: count.co, am: count.am, params: params]


    }
    //update 差错交易日报表下载 更新 as sunweiguo 2012-06-01
    def queryFaultDownLoad ={
               //params.max = Math.min(params.max ? params.int('max') : 10, 100)
               params.max = 5000
               params.offset = params.offset ? params.int('offset') : 0
               def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
               def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null

               def sql = new Sql(dataSource_ismp)
               def queryParam = []
               if (startDate) {
                   queryParam.add(new java.sql.Date(startDate.getTime()))
               }
               if (endDate) {
                   queryParam.add(new java.sql.Date(endDate.getTime()))
               }
               def query = """
             select count(*) co,sum(trxamount) am,to_char(auth_date,'yyyy-mm-dd') da,acquire_code bank_co,decode(change_sts,1,'成功',2,'失败') status
             from acquire_fault_trx where 1=1 ${startDate ? ' and auth_date>=? ' : ''} ${endDate ? ' and auth_date<=? ' : ''}
             group by acquire_code,to_char(auth_date,'yyyy-mm-dd'),decode(change_sts,1,'成功',2,'失败') order by to_char(auth_date,'yyyy-mm-dd') desc,acquire_code,decode(change_sts,1,'成功',2,'失败')
             """

               def count = sql.firstRow("select count(*) total,nvl(sum(am),0) am,nvl(sum(co),0) co from (${query})", queryParam)
               //def result = sql.rows(query.toString() + " ", queryParam)

               HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
               def result = ht.executeFind({ Session session ->
                   def sqlquery = session.createSQLQuery(query.toString())
                   sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                   for (def i = 0; i < queryParam.size(); i++) {
                       sqlquery.setParameter(i, queryParam.get(i))
                   }
                   return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
               } as HibernateCallback)

               //println result.dump()
               //println count.total
               [result: result, total: count.total, co: count.co, am: count.am, params: params]

                def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
                response.setHeader("Content-disposition", "attachment; filename=" + filename)
                response.contentType = "application/x-rarx-rar-compressed"
                response.setCharacterEncoding("UTF-8")
                render(view: "_queryFaultList", model: [result: result, total: count.total, co: count.co, am: count.am, params: params])
    }

/** *******************************************************************************/
    /**
     * 充值交易明细
     */
    def queryCharge = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        BoOperator op = session.getValue("op")
        validCreatedDated(params)
        def startDateCreated = params.startDateCreated ? Date.parse('yyyy-MM-dd', params.startDateCreated) : null
        def endDateCreated = params.endDateCreated ? Date.parse('yyyy-MM-dd', params.endDateCreated) + 1 : null
        def accountNo = params.accountNo ? params.accountNo.trim() : null
        def realamount = params.realamount ? params.realamount.trim() : null
        def recepit = params.recepit ? params.recepit.trim() : null
        def billref = params.billref ? params.billref.trim() : null
        def branchcode = params.branchcode ? params.branchcode.trim() : null
        println params
        def currentUserBanchcode = op?.branchCompany?.trim()
//        println "**************" + currentUserBanchcode
        def flag
        def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
        if (boBranchCom != null) {
            params.branchcode = String.valueOf(boBranchCom.id)
            flag = true
        } else {
            flag = false
        }
        def queryParam = []
        if (startDateCreated) {
            queryParam.add(new java.sql.Date(startDateCreated.getTime()))
        }
        if (endDateCreated) {
            queryParam.add(new java.sql.Date(endDateCreated.getTime()))
        }
        if (accountNo) {
            queryParam.add(accountNo)
        }
        if (realamount) {
            queryParam.add(Math.round(Double.valueOf(realamount) * 100))
        }
        if (recepit) {
            queryParam.add(recepit)
        }
        if (billref) {
            queryParam.add(billref)
        }
        if (currentUserBanchcode) {
            queryParam.add(currentUserBanchcode)
        }
        if (branchcode) {
            queryParam.add(branchcode);
        }
        def queryResultString = """
          select
          t.account_no,
          t.trxtype,
          t.billmode,
          t.realamount,
          t.amount,
          t.status,
          t.billdate,
          t.CREATEDATE,
          t.AUTHDATE,
          t.creator_name,
          t.author_name,
          t.branchcode,
          t.branchname,
          t.recepit,
          t.billref
          from bo_offline_charge t
          where t.trxtype = 'charge'
          ${startDateCreated ? ' and t.createdate>=? ' : ''}
          ${endDateCreated ? ' and t.createdate<=? ' : ''}
          ${accountNo ? ' and t.account_no=? ' : ''}
          ${realamount ? ' and t.realamount=? ' : ''}
          ${recepit ? ' and t.recepit=? ' : ''}
          ${billref ? ' and t.billref=? ' : ''}
          ${currentUserBanchcode ? ' and t.branchcode=? ' : ''}
          ${branchcode ? ' and t.branchcode=? ' : ''}
          order by t.createdate desc
      """
        println queryResultString
        def queryCountString = """
           select count(*) total from (${queryResultString})
      """
//      println "--------------" + branchcode + "  " + currentUserBanchcode;
        def count = new Sql(dataSource_boss).firstRow(queryCountString, queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(queryResultString.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)
        [result: result, total: count.total, params: params, flag: flag]
    }
    /**
     * 充值交易明细excel下载
     */
    def queryChargeDownload = {
        BoOperator op = session.getValue("op")
        validCreatedDated(params)
        def startDateCreated = params.startDateCreated ? Date.parse('yyyy-MM-dd', params.startDateCreated) : null
        def endDateCreated = params.endDateCreated ? Date.parse('yyyy-MM-dd', params.endDateCreated) + 1 : null
        def accountNo = params.accountNo ? params.accountNo.trim() : null
        def realamount = params.realamount ? params.realamount.trim() : null
        def recepit = params.recepit ? params.recepit.trim() : null
        def billref = params.billref ? params.billref.trim() : null
        def branchcode = params.branchcode ? params.branchcode.trim() : null

        def currentUserBanchcode = op?.branchCompany?.trim()
        def queryParam = []
        if (startDateCreated) {
            queryParam.add(new java.sql.Date(startDateCreated.getTime()))
        }
        if (endDateCreated) {
            queryParam.add(new java.sql.Date(endDateCreated.getTime()))
        }
        if (accountNo) {
            queryParam.add(accountNo)
        }
        if (realamount) {
            queryParam.add(Math.round(Double.valueOf(realamount) * 100))
        }
        if (recepit) {
            queryParam.add(recepit)
        }
        if (billref) {
            queryParam.add(billref)
        }
        if (currentUserBanchcode) {
            queryParam.add(currentUserBanchcode)
        }
        if (branchcode) {
            queryParam.add(branchcode);
        }
        def queryResultString = """
                  select
                  t.account_no,
                  t.trxtype,
                  t.billmode,
                  t.realamount,
                  t.amount,
                  t.status,
                  t.billdate,
                  t.CREATEDATE,
                  t.AUTHDATE,
                  t.creator_name,
                  t.author_name,
                  t.branchcode,
                  t.branchname,
                  t.recepit,
                  t.billref
                  from bo_offline_charge t
                  where t.trxtype = 'charge'
                  ${startDateCreated ? ' and t.createdate>=? ' : ''}
                  ${endDateCreated ? ' and t.createdate<=? ' : ''}
                  ${accountNo ? ' and t.account_no=? ' : ''}
                  ${realamount ? ' and t.realamount=? ' : ''}
                  ${recepit ? ' and t.recepit=? ' : ''}
                  ${billref ? ' and t.billref=? ' : ''}
                  ${currentUserBanchcode ? ' and t.branchcode=? ' : ''}
                  ${branchcode ? ' and t.branchcode=? ' : ''}
                  order by t.createdate desc
              """
        println queryResultString
        def queryCountString = """
                   select count(*) total from (${queryResultString})
              """
        //      println "--------------" + branchcode + "  " + currentUserBanchcode;
        def count = new Sql(dataSource_boss).firstRow(queryCountString, queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(queryResultString.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "queryChargeXls", model: [result: result, total: count.total])
    }

    /**
     * 商旅卡交易明细
     */
    def queryAccountBalance = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        validCreatedDated(params)
        def startDateCreated = params.startDateCreated ? Date.parse('yyyy-MM-dd', params.startDateCreated) : null
        def endDateCreated = params.endDateCreated ? Date.parse('yyyy-MM-dd', params.endDateCreated) + 1 : null
        def accountNo = params.accountNo ? params.accountNo.trim() : null

        def queryParam = []
        for (int i = 0; i < 4; i++) {
            if (startDateCreated) {
                queryParam.add(new java.sql.Date(startDateCreated.getTime()))
            }
            if (endDateCreated) {
                queryParam.add(new java.sql.Date(endDateCreated.getTime()))
            }
            if (accountNo) {
                queryParam.add(accountNo.trim())
            }
        }
        def queryResultString = """
            select
            account_no as ACCOUNT_NO,
            sum(charge) as V_CHARGE,
            sum(payment) as V_PAYMENT,
            sum(refund) as V_REFUND,
            sum(void) as V_VOID
            from
            ((
            select
            c.account_no as account_no,
            t.amount as charge,
            0 as payment,
            0 as refund,
            0 as void
            from ismp.cm_customer c, ismp.trade_base t
            where c.customer_category = 'travel'

            and c.account_no = t.payee_account_no
            and t.trade_type = 'charge'
            and t.status = 'completed'
            ${startDateCreated ? ' and t.last_updated>=? ' : ''}
            ${endDateCreated ? ' and t.last_updated<=? ' : ''}
            ${accountNo ? ' and c.account_no=? ' : ''}
            )
            union all
            (
            select
            c.account_no as account_no,
            0 as charge,
            t.amount as payment,
            0 as refund,
            0 as void
            from ismp.cm_customer c, ismp.trade_base t
            where c.customer_category = 'travel'
            and c.account_no = t.payer_account_no
            and t.trade_type = 'payment'
            and (t.status = 'completed' or t.status = 'closed')
            ${startDateCreated ? ' and t.last_updated>=? ' : ''}
            ${endDateCreated ? ' and t.last_updated<=? ' : ''}
            ${accountNo ? ' and c.account_no=? ' : ''}
            )
            union all
            (
            select
            c.account_no as account_no,
            0 as charge,
            0 as payment,
            t.amount as refund,
            0 as void
            from ismp.cm_customer c, ismp.trade_base t
            where c.customer_category = 'travel'
            and c.account_no = t.payee_account_no
            and t.trade_type = 'refund'
            and t.status = 'completed'
            ${startDateCreated ? ' and t.last_updated>=? ' : ''}
            ${endDateCreated ? ' and t.last_updated<=? ' : ''}
            ${accountNo ? ' and c.account_no=? ' : ''}
            )
            union all
            (
            select
            c.account_no as account_no,
            0 as charge,
            0 as payment,
            0 as refund,
            t.amount as void
            from ismp.cm_customer c, ismp.trade_base t
            where c.customer_category = 'travel'
            and c.account_no = t.payer_account_no
            and t.trade_type = 'void'
            and t.status = 'completed'
            ${startDateCreated ? ' and t.last_updated>=? ' : ''}
            ${endDateCreated ? ' and t.last_updated<=? ' : ''}
            ${accountNo ? ' and c.account_no=? ' : ''}
            )) group by account_no order by account_no
      """
        def queryCountString = """
                select count(*) total from (${queryResultString})
      """

        def count = new Sql(dataSource_boss).firstRow(queryCountString, queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(queryResultString.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)
        [result: result, total: count.total, params: params]
    }
    /**
     * 商旅卡交易明细excel下载
     */
    def queryAccountBalanceDownload = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        validCreatedDated(params)
        def startDateCreated = params.startDateCreated ? Date.parse('yyyy-MM-dd', params.startDateCreated) : null
        def endDateCreated = params.endDateCreated ? Date.parse('yyyy-MM-dd', params.endDateCreated) + 1 : null
        def accountNo = params.accountNo ? params.accountNo.trim() : null

        def queryParam = []
        for (int i = 0; i < 4; i++) {
            if (startDateCreated) {
                queryParam.add(new java.sql.Date(startDateCreated.getTime()))
            }
            if (endDateCreated) {
                queryParam.add(new java.sql.Date(endDateCreated.getTime()))
            }
            if (accountNo) {
                queryParam.add(accountNo)
            }
        }
        def queryResultString = """
                    select
                    account_no as ACCOUNT_NO,
                    sum(charge) as V_CHARGE,
                    sum(payment) as V_PAYMENT,
                    sum(refund) as V_REFUND,
                    sum(void) as V_VOID
                    from
                    ((
                    select
                    c.account_no as account_no,
                    t.amount as charge,
                    0 as payment,
                    0 as refund,
                    0 as void
                    from ismp.cm_customer c, ismp.trade_base t
                    where c.customer_category = 'travel'

                    and c.account_no = t.payee_account_no
                    and t.trade_type = 'charge'
                    and t.status = 'completed'
                    ${startDateCreated ? ' and t.last_updated>=? ' : ''}
                    ${endDateCreated ? ' and t.last_updated<=? ' : ''}
                    ${accountNo ? ' and c.account_no=? ' : ''}
                    )
                    union all
                    (
                    select
                    c.account_no as account_no,
                    0 as charge,
                    t.amount as payment,
                    0 as refund,
                    0 as void
                    from ismp.cm_customer c, ismp.trade_base t
                    where c.customer_category = 'travel'
                    and c.account_no = t.payer_account_no
                    and t.trade_type = 'payment'
                    and (t.status = 'completed' or t.status = 'closed')
                    ${startDateCreated ? ' and t.last_updated>=? ' : ''}
                    ${endDateCreated ? ' and t.last_updated<=? ' : ''}
                    ${accountNo ? ' and c.account_no=? ' : ''}
                    )
                    union all
                    (
                    select
                    c.account_no as account_no,
                    0 as charge,
                    0 as payment,
                    t.amount as refund,
                    0 as void
                    from ismp.cm_customer c, ismp.trade_base t
                    where c.customer_category = 'travel'
                    and c.account_no = t.payee_account_no
                    and t.trade_type = 'refund'
                    and t.status = 'completed'
                    ${startDateCreated ? ' and t.last_updated>=? ' : ''}
                    ${endDateCreated ? ' and t.last_updated<=? ' : ''}
                    ${accountNo ? ' and c.account_no=? ' : ''}
                    )
                    union all
                    (
                    select
                    c.account_no as account_no,
                    0 as charge,
                    0 as payment,
                    0 as refund,
                    t.amount as void
                    from ismp.cm_customer c, ismp.trade_base t
                    where c.customer_category = 'travel'
                    and c.account_no = t.payer_account_no
                    and t.trade_type = 'void'
                    and t.status = 'completed'
                    ${startDateCreated ? ' and t.last_updated>=? ' : ''}
                    ${endDateCreated ? ' and t.last_updated<=? ' : ''}
                    ${accountNo ? ' and c.account_no=? ' : ''}
                    )) group by account_no order by account_no
              """
        def queryCountString = """
                        select count(*) total from (${queryResultString})
              """

        def count = new Sql(dataSource_boss).firstRow(queryCountString, queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(queryResultString.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "queryAccountBalanceXls", model: [result: result, total: count.total, params: params])
    }

    /**
     * 商旅卡总余额明细
     */
    def queryTotalBalance = {

        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        validCreatedDated(params)
        Date startDateCreated = params.startDateCreated ? Date.parse('yyyy-MM-dd', params.startDateCreated) : null
        Date endDateCreated = params.endDateCreated ? Date.parse('yyyy-MM-dd', params.endDateCreated) + 1 : null
        def queryParam = []
        java.text.SimpleDateFormat simpleDateFormat = new java.text.SimpleDateFormat("yyyyMMdd");
        if (startDateCreated) {
            queryParam.add(simpleDateFormat.format(startDateCreated))
        }
        if (endDateCreated) {
            queryParam.add(simpleDateFormat.format(endDateCreated))
        }
        def queryResultString = """
            select distinct dates.dates as SETTLE_DATE,
            charge.ssamount as CHARGE_TOTAL,
            voids.ssamount as VOIDS_TOTAL,
            payment.ssamount as PAYMENT_TOTAL,
            refund.ssamount as REFUND_TOTAL,
            up_adjust.ssamount as UP_TRANSFER_TOTAL,
            down_adjust.ssamount as DOWN_TRANSFER_TOTAL,
            fee.ssamount as FEE_TOTAL,
            balance.ssamount as BALANCE_TOTAL
            from (
                 select distinct stt.dates from account.ac_st_trx stt
                 union
                 select distinct stl.dates from account.ac_st_lastacseq stl
            ) dates
            left join (
                 select ac.dates as dates, sum(ac.samount) as ssamount
                 from ismp.cm_customer c, account.ac_st_trx ac
                 where c.account_no = ac.account_no
                 and c.customer_category = 'travel'
                 and ac.transfer_type = 'charge'
                 and ac.direction = 1
                 group by ac.dates
            ) charge
            on dates.dates = charge.dates
            left join (
                 select ac.dates as dates, sum(ac.samount) as ssamount
                 from ismp.cm_customer c, account.ac_st_trx ac
                 where c.account_no = ac.account_no
                 and c.customer_category = 'travel'
                 and ac.transfer_type = 'void'
                 and ac.direction = -1
                 group by ac.dates
            ) voids
            on dates.dates = voids.dates
            left join (
                 select ac.dates as dates, sum(ac.samount) as ssamount
                 from ismp.cm_customer c, account.ac_st_trx ac
                 where c.account_no = ac.account_no
                 and c.customer_category = 'travel'
                 and ac.transfer_type = 'payment'
                 and ac.direction = -1
                 group by ac.dates
            ) payment
            on dates.dates = payment.dates
            left join (
                 select ac.dates as dates, sum(ac.samount) as ssamount
                 from ismp.cm_customer c, account.ac_st_trx ac
                 where c.account_no = ac.account_no
                 and c.customer_category = 'travel'
                 and ac.transfer_type = 'refund'
                 and ac.direction = 1
                 group by ac.dates
            ) refund
            on dates.dates = refund.dates
            left join (
                 select ac.dates as dates, sum(ac.samount) as ssamount
                 from ismp.cm_customer c, account.ac_st_trx ac
                 where c.account_no = ac.account_no
                 and c.customer_category = 'travel'
                 and ac.transfer_type = 'adjust'
                 and ac.direction = -1
                 group by ac.dates
            ) down_adjust
            on dates.dates = down_adjust.dates
            left join (
                 select ac.dates as dates, sum(ac.samount) as ssamount
                 from ismp.cm_customer c, account.ac_st_trx ac
                 where c.account_no = ac.account_no
                 and c.customer_category = 'travel'
                 and ac.transfer_type = 'adjust'
                 and ac.direction = 1
                 group by ac.dates
            ) up_adjust
            on dates.dates = up_adjust.dates
            left join (
                 select ac.dates as dates, sum(ac.samount*ac.direction) as ssamount
                 from ismp.cm_customer c, account.ac_st_trx ac
                 where c.account_no = ac.account_no
                 and c.customer_category = 'travel'
                 and (ac.transfer_type = 'fee' or ac.transfer_type = 'fee_rfd')
                 group by ac.dates
            ) fee
            on dates.dates = fee.dates
            left join (
                 select stl.dates, sum(stl.balance) as ssamount
                 from ismp.cm_customer c, account.ac_st_lastacseq stl
                 where c.account_no = stl.account_no
                 and c.customer_category = 'travel'
                 group by stl.dates
            ) balance
            on dates.dates = balance.dates
            where
            (
            charge.ssamount is not null
            or payment.ssamount is not null
            or  refund.ssamount  is not null
            or up_adjust.ssamount is not null
            or  down_adjust.ssamount is not null
            or  fee.ssamount is not null
            or  balance.ssamount is not null
            )
            ${startDateCreated ? ' and dates.dates>=? ' : ''}
            ${endDateCreated ? ' and dates.dates<? ' : ''}
            order by dates.dates asc
      """
        def queryCountString = """
                select count(*) total from (${queryResultString})
      """
        def count = new Sql(dataSource_boss).firstRow(queryCountString, queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(queryResultString.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)
        [result: result, total: count.total, params: params]
    }
    /**
     * 商旅卡总余额明细excel下载
     */
    def queryTotalBalanceDownload = {
        validCreatedDated(params)
        Date startDateCreated = params.startDateCreated ? Date.parse('yyyy-MM-dd', params.startDateCreated) : null
        Date endDateCreated = params.endDateCreated ? Date.parse('yyyy-MM-dd', params.endDateCreated) + 1 : null
        def queryParam = []
        java.text.SimpleDateFormat simpleDateFormat = new java.text.SimpleDateFormat("yyyyMMdd");
        if (startDateCreated) {
            queryParam.add(simpleDateFormat.format(startDateCreated))
        }
        if (endDateCreated) {
            queryParam.add(simpleDateFormat.format(endDateCreated))
        }
        def queryResultString = """
                    select distinct dates.dates as SETTLE_DATE,
                    charge.ssamount as CHARGE_TOTAL,
                    voids.ssamount as VOIDS_TOTAL,
                    payment.ssamount as PAYMENT_TOTAL,
                    refund.ssamount as REFUND_TOTAL,
                    up_adjust.ssamount as UP_TRANSFER_TOTAL,
                    down_adjust.ssamount as DOWN_TRANSFER_TOTAL,
                    fee.ssamount as FEE_TOTAL,
                    balance.ssamount as BALANCE_TOTAL
                    from (
                         select distinct stt.dates from account.ac_st_trx stt
                         union
                         select distinct stl.dates from account.ac_st_lastacseq stl
                    ) dates
                    left join (
                         select ac.dates as dates, sum(ac.samount) as ssamount
                         from ismp.cm_customer c, account.ac_st_trx ac
                         where c.account_no = ac.account_no
                         and c.customer_category = 'travel'
                         and ac.transfer_type = 'charge'
                         and ac.direction = 1
                         group by ac.dates
                    ) charge
                    on dates.dates = charge.dates
                    left join (
                         select ac.dates as dates, sum(ac.samount) as ssamount
                         from ismp.cm_customer c, account.ac_st_trx ac
                         where c.account_no = ac.account_no
                         and c.customer_category = 'travel'
                         and ac.transfer_type = 'void'
                         and ac.direction = -1
                         group by ac.dates
                    ) voids
                    on dates.dates = voids.dates
                    left join (
                         select ac.dates as dates, sum(ac.samount) as ssamount
                         from ismp.cm_customer c, account.ac_st_trx ac
                         where c.account_no = ac.account_no
                         and c.customer_category = 'travel'
                         and ac.transfer_type = 'payment'
                         and ac.direction = -1
                         group by ac.dates
                    ) payment
                    on dates.dates = payment.dates
                    left join (
                         select ac.dates as dates, sum(ac.samount) as ssamount
                         from ismp.cm_customer c, account.ac_st_trx ac
                         where c.account_no = ac.account_no
                         and c.customer_category = 'travel'
                         and ac.transfer_type = 'refund'
                         and ac.direction = 1
                         group by ac.dates
                    ) refund
                    on dates.dates = refund.dates
                    left join (
                         select ac.dates as dates, sum(ac.samount) as ssamount
                         from ismp.cm_customer c, account.ac_st_trx ac
                         where c.account_no = ac.account_no
                         and c.customer_category = 'travel'
                         and ac.transfer_type = 'adjust'
                         and ac.direction = -1
                         group by ac.dates
                    ) down_adjust
                    on dates.dates = down_adjust.dates
                    left join (
                         select ac.dates as dates, sum(ac.samount) as ssamount
                         from ismp.cm_customer c, account.ac_st_trx ac
                         where c.account_no = ac.account_no
                         and c.customer_category = 'travel'
                         and ac.transfer_type = 'adjust'
                         and ac.direction = 1
                         group by ac.dates
                    ) up_adjust
                    on dates.dates = up_adjust.dates
                    left join (
                         select ac.dates as dates, sum(ac.samount*ac.direction) as ssamount
                         from ismp.cm_customer c, account.ac_st_trx ac
                         where c.account_no = ac.account_no
                         and c.customer_category = 'travel'
                         and (ac.transfer_type = 'fee' or ac.transfer_type = 'fee_rfd')
                         group by ac.dates
                    ) fee
                    on dates.dates = fee.dates
                    left join (
                         select stl.dates, sum(stl.balance) as ssamount
                         from ismp.cm_customer c, account.ac_st_lastacseq stl
                         where c.account_no = stl.account_no
                         and c.customer_category = 'travel'
                         group by stl.dates
                    ) balance
                    on dates.dates = balance.dates
                    where
                    (
                    charge.ssamount is not null
                    or payment.ssamount is not null
                    or  refund.ssamount  is not null
                    or up_adjust.ssamount is not null
                    or  down_adjust.ssamount is not null
                    or  fee.ssamount is not null
                    or  balance.ssamount is not null
                    )
                    ${startDateCreated ? ' and dates.dates>=? ' : ''}
                    ${endDateCreated ? ' and dates.dates<? ' : ''}
                    order by dates.dates asc
              """
        def queryCountString = """
                        select count(*) total from (${queryResultString})
              """
        def count = new Sql(dataSource_boss).firstRow(queryCountString, queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(queryResultString.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "queryTotalBalanceXls", model: [result: result, total: count.total, params: params])
    }

    /**
     * 商旅客户交易汇总报表
     */
    def queryCustomerReport = {
        BoOperator op = session.getValue("op")
        def branchCode = params.branchCode ? params.branchCode.trim() : null
        def currentUserBanchcode = op?.branchCompany?.trim()
        def customerName = params.customerName ? params.customerName.trim() : null;
        def accountNo = params.accountNo ? params.accountNo.trim() : null;


        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        validCreatedDated(params)

        Date startDateCreated = params.startDateCreated ? Date.parse('yyyy-MM-dd', params.startDateCreated) : null
        Date endDateCreated = params.endDateCreated ? Date.parse('yyyy-MM-dd', params.endDateCreated) + 1 : null

        def queryParam = []

        for (int i = 0; i < 2; i++) {
            if (startDateCreated) {
                queryParam.add(new java.sql.Date(startDateCreated.getTime()))
            }
            if (endDateCreated) {
                queryParam.add(new java.sql.Date(endDateCreated.getTime()))
            }
        }
        if (currentUserBanchcode) {
            queryParam.add(currentUserBanchcode)
        }
        if (branchCode) {
            queryParam.add(branchCode)
        }
        if (accountNo) {
            queryParam.add(accountNo)
        }
        if (customerName) {
            queryParam.add(customerName)
        }

        def flag
        def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
        if (boBranchCom != null) {
            params.branchCode = String.valueOf(boBranchCom.id)
            flag = true
        } else {
            flag = false
        }
        def queryResultString = """
              select bbc.company_name as COMPANY_NAME,
              cc.branch_company AS BRANCH_CODE,
                     cc.registered_place AS REGION,
                     c.name AS CUSTOMER_NAME,
                     c.account_no AS CUSTOMER_NO,
                     nvl(a.chargeonlinecount,0) AS ONLINE_CHARGE_COUNT,
                     nvl(a.chargeonlinesum,0) AS ONLINE_CHARGE_SUM,
                     nvl(a.chargeofflinecount,0) AS OFFLINE_CHARGE_COUNT,
                     nvl(a.chargeofflinesum,0) AS OFFLINE_CHARGE_SUM,
                     nvl(b.voidofflinecount,0) AS VOID_COUNT,
                     nvl(b.voidofflinesum,0) AS VOID_SUM,
                     nvl(b.paymentcount,0) AS PAYMENT_COUNT,
                     nvl(b.paymentsum,0) AS PAYMENT_SUM,
                     nvl(a.refundcount0,0)+nvl(b.refundcount1,0) AS REFUND_COUNT,
                     nvl(a.refundsum0,0)+nvl(b.refundsum1,0) AS REFUND_SUM,
                     nvl(a.chargefee,0) AS FEE_SUM,
                     0 AS BEBATES,
                     0 AS BANKCOSTS,
                     nvl(a.chargeonlinesum,0)
                     +nvl(a.chargeofflinesum,0)
                     -nvl(b.voidofflinesum,0)
                     -nvl(b.paymentsum,0)
                     +nvl(a.refundsum0,0)
                     -nvl(b.refundsum1,0) AS NET_AMOUNT
                     from ismp.cm_customer c
                     inner join  ismp.cm_corporation_info cc
                     on c.id=cc.id

                    left join boss.bo_branch_company bbc
                     on cc.branch_company = bbc.id
              left join
              (
              select payee_id,sum(case when trade_type='charge' and service_type<>'offlinepay' and status='completed' then 1 else 0 end) as chargeonlinecount,
                     sum(case when trade_type='charge' and service_type<>'offlinepay' and status='completed' then amount else 0 end) as chargeonlinesum,
                     sum(case when trade_type='charge' and service_type='offlinepay' and status='completed' then 1 else 0 end     ) as chargeofflinecount,
                     sum(case when trade_type='charge' and service_type='offlinepay' and status='completed' then amount else 0 end) as chargeofflinesum,
                     sum(case when trade_type='refund' and status='completed' then 1 else 0 end) as refundcount0,
                     sum(case when trade_type='refund' and status='completed' then amount else 0 end) as refundsum0,
                     sum(case when trade_type='charge' and status='completed' then fee_amount else 0 end) as chargefee
                     from ismp.trade_base
                     where payee_id is not null
                     ${startDateCreated ? ' and last_updated>=? ' : ''}
                     ${endDateCreated ? ' and last_updated<? ' : ''}
                     group by payee_id

              ) a on c.id=a.payee_id
              left join (
              select payer_id,
                     sum(case when trade_type='void' and status='completed' then 1 else 0 end) as voidofflinecount,
                     sum(case when trade_type='void' and status='completed' then amount else 0 end) as voidofflinesum,
                     sum(case when trade_type='payment' then 1 else 0 end) as paymentcount,
                     sum(case when trade_type='payment' then amount else 0 end) as paymentsum,
                     sum(case when trade_type='refund' and status='completed' then 1 else 0 end) as refundcount1,
                     sum(case when trade_type='refund' and status='completed' then amount else 0 end) as refundsum1
                     from ismp.trade_base
                     where payer_id is not null
                     ${startDateCreated ? ' and last_updated>=? ' : ''}
                     ${endDateCreated ? ' and last_updated<? ' : ''}
                     group by payer_id

              )b on c.id=b.payer_id

              where c.customer_category='travel'
              ${currentUserBanchcode ? ' and cc.branch_company=? ' : ''}
              ${branchCode ? ' and cc.branch_company=? ' : ''}
              ${accountNo ? ' and c.account_no=? ' : ''}
              ${customerName ? ' and c.name=? ' : ''}
               and( (a.chargeonlinecount<>0    and a.chargeonlinecount is not null)
              or (a.chargeofflinecount<>0 and a.chargeofflinecount is not null)
              or (b.voidofflinecount <>0 and b.voidofflinecount is not null)
              or (b.paymentcount <>0   and b.paymentcount is not null)
              or (a.refundcount0 <>0 and a.refundcount0 is not null)
              or (b.refundcount1 <>0 and b.refundcount1 is not null)
              )
                 """

        def queryCountString = """
                    select count(*) total from (${queryResultString})
          """
        def count = new Sql(dataSource_boss).firstRow(queryCountString, queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(queryResultString.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        [result: result, total: count.total, params: params, flag: flag]
    }
    /**
     * 商旅客户交易汇总报表excel下载
     */
    def queryCustomerReportDownload = {
        BoOperator op = session.getValue("op")
        def branchCode = params.branchCode ? params.branchCode.trim() : null
        def currentUserBanchcode = op?.branchCompany?.trim()
        def customerName = params.customerName ? params.customerName.trim() : null;
        def accountNo = params.accountNo ? params.accountNo.trim() : null;

        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        validCreatedDated(params)

        Date startDateCreated = params.startDateCreated ? Date.parse('yyyy-MM-dd', params.startDateCreated) : null
        Date endDateCreated = params.endDateCreated ? Date.parse('yyyy-MM-dd', params.endDateCreated) + 1 : null

        def queryParam = []

        for (int i = 0; i < 2; i++) {
            if (startDateCreated) {
                queryParam.add(new java.sql.Date(startDateCreated.getTime()))
            }
            if (endDateCreated) {
                queryParam.add(new java.sql.Date(endDateCreated.getTime()))
            }
        }
        if (currentUserBanchcode) {
            queryParam.add(currentUserBanchcode)
        }
        if (branchCode) {
            queryParam.add(branchCode)
        }
        if (accountNo) {
            queryParam.add(accountNo)
        }
        if (customerName) {
            queryParam.add(customerName)
        }

        def flag
        def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
        if (boBranchCom != null) {
            params.branchCode = String.valueOf(boBranchCom.id)
            flag = true
        } else {
            flag = false
        }
        def queryResultString = """
                      select bbc.company_name as COMPANY_NAME,
                      cc.branch_company AS BRANCH_CODE,
                             cc.registered_place AS REGION,
                             c.name AS CUSTOMER_NAME,
                             c.account_no AS CUSTOMER_NO,
                             nvl(a.chargeonlinecount,0) AS ONLINE_CHARGE_COUNT,
                             nvl(a.chargeonlinesum,0) AS ONLINE_CHARGE_SUM,
                             nvl(a.chargeofflinecount,0) AS OFFLINE_CHARGE_COUNT,
                             nvl(a.chargeofflinesum,0) AS OFFLINE_CHARGE_SUM,
                             nvl(b.voidofflinecount,0) AS VOID_COUNT,
                             nvl(b.voidofflinesum,0) AS VOID_SUM,
                             nvl(b.paymentcount,0) AS PAYMENT_COUNT,
                             nvl(b.paymentsum,0) AS PAYMENT_SUM,
                             nvl(a.refundcount0,0)+nvl(b.refundcount1,0) AS REFUND_COUNT,
                             nvl(a.refundsum0,0)+nvl(b.refundsum1,0) AS REFUND_SUM,
                             nvl(a.chargefee,0) AS FEE_SUM,
                             0 AS BEBATES,
                             0 AS BANKCOSTS,
                             nvl(a.chargeonlinesum,0)
                             +nvl(a.chargeofflinesum,0)
                             -nvl(b.voidofflinesum,0)
                             -nvl(b.paymentsum,0)
                             +nvl(a.refundsum0,0)
                             -nvl(b.refundsum1,0) AS NET_AMOUNT
                             from ismp.cm_customer c
                             inner join  ismp.cm_corporation_info cc
                             on c.id=cc.id

                            left join boss.bo_branch_company bbc
                             on cc.branch_company = bbc.id
                      left join
                      (
                      select payee_id,sum(case when trade_type='charge' and service_type<>'offlinepay' and status='completed' then 1 else 0 end) as chargeonlinecount,
                             sum(case when trade_type='charge' and service_type<>'offlinepay' and status='completed' then amount else 0 end) as chargeonlinesum,
                             sum(case when trade_type='charge' and service_type='offlinepay' and status='completed' then 1 else 0 end     ) as chargeofflinecount,
                             sum(case when trade_type='charge' and service_type='offlinepay' and status='completed' then amount else 0 end) as chargeofflinesum,
                             sum(case when trade_type='refund' and status='completed' then 1 else 0 end) as refundcount0,
                             sum(case when trade_type='refund' and status='completed' then amount else 0 end) as refundsum0,
                             sum(case when trade_type='charge' and status='completed' then fee_amount else 0 end) as chargefee
                             from ismp.trade_base
                             where payee_id is not null
                             ${startDateCreated ? ' and last_updated>=? ' : ''}
                             ${endDateCreated ? ' and last_updated<? ' : ''}
                             group by payee_id

                      ) a on c.id=a.payee_id
                      left join (
                      select payer_id,
                             sum(case when trade_type='void' and status='completed' then 1 else 0 end) as voidofflinecount,
                             sum(case when trade_type='void' and status='completed' then amount else 0 end) as voidofflinesum,
                             sum(case when trade_type='payment' then 1 else 0 end) as paymentcount,
                             sum(case when trade_type='payment' then amount else 0 end) as paymentsum,
                             sum(case when trade_type='refund' and status='completed' then 1 else 0 end) as refundcount1,
                             sum(case when trade_type='refund' and status='completed' then amount else 0 end) as refundsum1
                             from ismp.trade_base
                             where payer_id is not null
                             ${startDateCreated ? ' and last_updated>=? ' : ''}
                             ${endDateCreated ? ' and last_updated<? ' : ''}
                             group by payer_id

                      )b on c.id=b.payer_id

                      where c.customer_category='travel'
                      ${currentUserBanchcode ? ' and cc.branch_company=? ' : ''}
                      ${branchCode ? ' and cc.branch_company=? ' : ''}
                      ${accountNo ? ' and c.account_no=? ' : ''}
                      ${customerName ? ' and c.name=? ' : ''}
                       and( (a.chargeonlinecount<>0    and a.chargeonlinecount is not null)
                      or (a.chargeofflinecount<>0 and a.chargeofflinecount is not null)
                      or (b.voidofflinecount <>0 and b.voidofflinecount is not null)
                      or (b.paymentcount <>0   and b.paymentcount is not null)
                      or (a.refundcount0 <>0 and a.refundcount0 is not null)
                      or (b.refundcount1 <>0 and b.refundcount1 is not null)
                      )
                         """

        def queryCountString = """
                            select count(*) total from (${queryResultString})
                  """
        def count = new Sql(dataSource_boss).firstRow(queryCountString, queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(queryResultString.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "queryCustomerReportXls", model: [result: result, total: count.total, params: params])
    }
    /**
     * 商旅商户交易汇总报表 （商户）
     */
    def queryMerchantReport = {

        BoOperator op = session.getValue("op")
        def branchCode = params.branchCode ? params.branchCode.trim() : null
        def currentUserBanchcode = op?.branchCompany?.trim()
        def merchantName = params.merchantName ? params.merchantName.trim() : null;
        def accountNo = params.accountNo ? params.accountNo.trim() : null;

        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        validCreatedDated(params)

        Date startDateCreated = params.startDateCreated ? Date.parse('yyyy-MM-dd', params.startDateCreated) : null
        Date endDateCreated = params.endDateCreated ? Date.parse('yyyy-MM-dd', params.endDateCreated) + 1 : null

        def queryParam = []

        if (startDateCreated) {
            queryParam.add(new java.sql.Date(startDateCreated.getTime()))
        }
        if (endDateCreated) {
            queryParam.add(new java.sql.Date(endDateCreated.getTime()))
        }


        for (int i = 0; i < 2; i++) {
            if (startDateCreated) {
                queryParam.add(new java.sql.Date(startDateCreated.getTime()))
            }
            if (endDateCreated) {
                queryParam.add(new java.sql.Date(endDateCreated.getTime()))
            }
        }
        if (branchCode) {
            queryParam.add(branchCode)
        }
        if (currentUserBanchcode) {
            queryParam.add(currentUserBanchcode)
        }
        if (merchantName) {
            queryParam.add(merchantName)
        }
        if (accountNo) {
            queryParam.add(accountNo)
        }

        def flag
        def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
        if (boBranchCom != null) {
            params.branchCode = String.valueOf(boBranchCom.id)
            flag = true
        } else {
            flag = false
        }
        def queryResultString = """
               select bbc.company_name AS COMPANY_NAME,
               cc.branch_company AS BRANCH_CODE,
                      cc.registered_place AS REGION,
                      c.name AS MERCHANT_NAME,
                      c.account_no AS MERCHANT_NO,
                      nvl(x1.paymentcount,0) AS PAYMENT_COUNT,
                      nvl(x1.paymentsum,0) AS PAYMENT_SUM,
                      nvl(x2.refundcount,0) AS REFUND_COUNT,
                      nvl(x2.refundsum,0) AS REFUND_SUM,
                      0 AS FEE_SUM,
                      0 AS REBATES,
                      0 AS BANKCOSTS,
                      nvl(x1.paymentsum,0)-nvl(x2.refundsum,0) AS NET_AMOUNT
                       from (
                          select distinct case when t.trade_type='payment' then payee_id
                          when t.trade_type='refund'  then payer_id end as cid
                          from ismp.trade_base t inner join ismp.cm_customer c on c.id=
                          case when t.trade_type='payment' then t.payer_id
                               when t.trade_type='refund' then t.payee_id end
                          where 1=1 and c.customer_category='travel'
                          ${startDateCreated ? ' and t.last_updated>=? ' : ''}
                          ${endDateCreated ? ' and t.last_updated<? ' : ''}

                        )x0
                        inner join ismp.cm_customer c on x0.cid=c.id
                        inner join ismp.cm_corporation_info cc
                        on x0.cid=cc.id
                        left join boss.bo_branch_company bbc
                        on cc.branch_company = bbc.id
                        left join
                      (
                      select payee_id,
                      nvl(sum(case when trade_type='payment' then 1 else 0 end),0) as paymentcount,
                      sum(case when trade_type='payment' then amount else 0 end) as paymentsum
                      from ismp.trade_base t inner join (select c.id from ismp.cm_customer c where customer_category='travel') a on t.payer_id=a.id
                      where t.payee_id is not null
                      and 1=1 --daterange
                        ${startDateCreated ? ' and last_updated>=? ' : ''}
                        ${endDateCreated ? ' and last_updated<? ' : ''}
                      group by payee_id
                      )x1 on x0.cid=x1.payee_id left join (
                      select payer_id,
                      nvl(sum(case when trade_type='refund' and status='completed' then 1 else 0 end),0) as refundcount,
                      nvl(sum(case when trade_type='refund' and status='completed' then amount else 0 end),0) as refundsum
                      from ismp.trade_base t inner join (select c.id from ismp.cm_customer c where customer_category='travel') a on t.payee_id=a.id
                      where t.payer_id is not null
                      and 1=1 --daterange
                        ${startDateCreated ? ' and last_updated>=? ' : ''}
                        ${endDateCreated ? ' and last_updated<? ' : ''}
                      group by payer_id
                      )x2 on x0.cid=x2.payer_id
                      where 1 = 1
                        ${branchCode ? ' and cc.branch_company=? ' : ''}
                        ${currentUserBanchcode ? ' and cc.branch_company=? ' : ''}
                        ${merchantName ? ' and c.name=? ' : ''}
                        ${accountNo ? ' and c.account_no=? ' : ''}
          """
        def queryCountString = """
                    select count(*) total from (${queryResultString})
          """
        def count = new Sql(dataSource_boss).firstRow(queryCountString, queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(queryResultString.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

//          for(def obj : result){
//                              println "+++++++++++++++++++++++++++++"+ obj
//          }
//        [result: result, total: count.total, params: params]
        [result: result, total: count.total, params: params, flag: flag]
    }

    /**
     * 商旅商户交易汇总报表excel下载   （商户）
     */
    def queryMerchantReportDownload = {

        BoOperator op = session.getValue("op")
        def branchCode = params.branchCode ? params.branchCode.trim() : null
        def currentUserBanchcode = op?.branchCompany?.trim()
        def merchantName = params.merchantName ? params.merchantName.trim() : null;
        def accountNo = params.accountNo ? params.accountNo.trim() : null;

        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        validCreatedDated(params)

        Date startDateCreated = params.startDateCreated ? Date.parse('yyyy-MM-dd', params.startDateCreated) : null
        Date endDateCreated = params.endDateCreated ? Date.parse('yyyy-MM-dd', params.endDateCreated) + 1 : null

        def queryParam = []

        if (startDateCreated) {
            queryParam.add(new java.sql.Date(startDateCreated.getTime()))
        }
        if (endDateCreated) {
            queryParam.add(new java.sql.Date(endDateCreated.getTime()))
        }


        for (int i = 0; i < 2; i++) {
            if (startDateCreated) {
                queryParam.add(new java.sql.Date(startDateCreated.getTime()))
            }
            if (endDateCreated) {
                queryParam.add(new java.sql.Date(endDateCreated.getTime()))
            }
        }
        if (branchCode) {
            queryParam.add(branchCode)
        }
        if (currentUserBanchcode) {
            queryParam.add(currentUserBanchcode)
        }
        if (merchantName) {
            queryParam.add(merchantName)
        }
        if (accountNo) {
            queryParam.add(accountNo)
        }

        def flag
        def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
        if (boBranchCom != null) {
            params.branchCode = String.valueOf(boBranchCom.id)
            flag = true
        } else {
            flag = false
        }
        def queryResultString = """
                       select bbc.company_name AS COMPANY_NAME,
                       cc.branch_company AS BRANCH_CODE,
                              cc.registered_place AS REGION,
                              c.name AS MERCHANT_NAME,
                              c.account_no AS MERCHANT_NO,
                              nvl(x1.paymentcount,0) AS PAYMENT_COUNT,
                              nvl(x1.paymentsum,0) AS PAYMENT_SUM,
                              nvl(x2.refundcount,0) AS REFUND_COUNT,
                              nvl(x2.refundsum,0) AS REFUND_SUM,
                              0 AS FEE_SUM,
                              0 AS REBATES,
                              0 AS BANKCOSTS,
                              nvl(x1.paymentsum,0)-nvl(x2.refundsum,0) AS NET_AMOUNT
                               from (
                                  select distinct case when t.trade_type='payment' then payee_id
                                  when t.trade_type='refund'  then payer_id end as cid
                                  from ismp.trade_base t inner join ismp.cm_customer c on c.id=
                                  case when t.trade_type='payment' then t.payer_id
                                       when t.trade_type='refund' then t.payee_id end
                                  where 1=1 and c.customer_category='travel'
                                  ${startDateCreated ? ' and t.last_updated>=? ' : ''}
                                  ${endDateCreated ? ' and t.last_updated<? ' : ''}

                                )x0
                                inner join ismp.cm_customer c on x0.cid=c.id
                                inner join ismp.cm_corporation_info cc
                                on x0.cid=cc.id
                                left join boss.bo_branch_company bbc
                                on cc.branch_company = bbc.id
                                left join
                              (
                              select payee_id,
                              nvl(sum(case when trade_type='payment' then 1 else 0 end),0) as paymentcount,
                              sum(case when trade_type='payment' then amount else 0 end) as paymentsum
                              from ismp.trade_base t inner join (select c.id from ismp.cm_customer c where customer_category='travel') a on t.payer_id=a.id
                              where t.payee_id is not null
                              and 1=1 --daterange
                                ${startDateCreated ? ' and last_updated>=? ' : ''}
                                ${endDateCreated ? ' and last_updated<? ' : ''}
                              group by payee_id
                              )x1 on x0.cid=x1.payee_id left join (
                              select payer_id,
                              nvl(sum(case when trade_type='refund' and status='completed' then 1 else 0 end),0) as refundcount,
                              nvl(sum(case when trade_type='refund' and status='completed' then amount else 0 end),0) as refundsum
                              from ismp.trade_base t inner join (select c.id from ismp.cm_customer c where customer_category='travel') a on t.payee_id=a.id
                              where t.payer_id is not null
                              and 1=1 --daterange
                                ${startDateCreated ? ' and last_updated>=? ' : ''}
                                ${endDateCreated ? ' and last_updated<? ' : ''}
                              group by payer_id
                              )x2 on x0.cid=x2.payer_id
                              where 1 = 1
                                ${branchCode ? ' and cc.branch_company=? ' : ''}
                                ${currentUserBanchcode ? ' and cc.branch_company=? ' : ''}
                                ${merchantName ? ' and c.name=? ' : ''}
                                ${accountNo ? ' and c.account_no=? ' : ''}
                  """
        def queryCountString = """
                            select count(*) total from (${queryResultString})
                  """
        def count = new Sql(dataSource_boss).firstRow(queryCountString, queryParam)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(queryResultString.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlquery.setParameter(i, queryParam.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "queryMerchantReportXls", model: [result: result, total: count.total, params: params])
    }
    /**
     * 商旅账户交易明细报表
     */
    def queryFundDetailsReport = {

        BoOperator op = session.getValue("op")
        def branchCode = params.branchCode ? params.branchCode.trim() : null
        def currentUserBanchcode = op?.branchCompany?.trim()
        def merchantName = params.merchantName ? params.merchantName.trim() : null;
        def accountNo = params.accountNo ? params.accountNo.trim() : null;
        def paymentType = params.paymentType ? params.paymentType.trim() : null;
        def tradeAmount = params.tradeAmount ? params.tradeAmount.trim() : null;
        def tradeNo = params.tradeNo ? params.tradeNo.trim() : null;
        def outTradeNo = params.outTradeNo ? params.outTradeNo.trim() : null;
        def status = params.status ? params.status.trim() : null;

        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        validCreatedDated(params)
        validCompletedDated(params)

        Date startDateCreated = params.startDateCreated ? Date.parse('yyyy-MM-dd', params.startDateCreated) : null
        Date endDateCreated = params.endDateCreated ? Date.parse('yyyy-MM-dd', params.endDateCreated) + 1 : null
        Date startDateCompleted = params.startDateCompleted ? Date.parse('yyyy-MM-dd', params.startDateCompleted) : null
        Date endDateCompleted = params.endDateCompleted ? Date.parse('yyyy-MM-dd', params.endDateCompleted) + 1 : null



        def flag
        def boBranchCom = BoBranchCompany.get(session.op.branchCompany)
        if (boBranchCom != null) {
            params.branchCode = String.valueOf(boBranchCom.id)
            flag = true
        } else {
            flag = false
        }

        def queryparam_ = []

        if (startDateCreated) {
            queryparam_.add(new java.sql.Date(startDateCreated.getTime()))
        }
        if (endDateCreated) {
            queryparam_.add(new java.sql.Date(endDateCreated.getTime()))
        }

        if (startDateCompleted) {
            queryparam_.add(new java.sql.Date(startDateCompleted.getTime()))
        }
        if (endDateCompleted) {
            queryparam_.add(new java.sql.Date(endDateCompleted.getTime()))
        }

        if (tradeAmount) {
            queryparam_.add(Double.valueOf(tradeAmount) * 100)
        }
        if (tradeNo) {
            queryparam_.add(tradeNo)
        }

        if (outTradeNo) {
            queryparam_.add(outTradeNo)
        }

        if (status) {
            queryparam_.add(status)
        }
        if (paymentType) {
            queryparam_.add(paymentType)
        }

        if (accountNo) {
            queryparam_.add(accountNo)
        }


        if (merchantName) {
            queryparam_.add(merchantName)
        }

        if (branchCode) {
            queryparam_.add(branchCode)
        }
        if (currentUserBanchcode) {
            queryparam_.add(currentUserBanchcode)
        }


        def queryResultString = """
              select
              tb.trade_no AS TRADE_NO,
              tb.amount AS NET_AMOUNT,
              ac_sequential.balance AS CUSTOMER_BALANCE,
              tb.fee_amount AS FEE,
              tb.trade_type AS TRADE_TYPE,
              tb.service_type AS SERVICE_TYPE,
              tb.payment_type AS PAYMENT_TYPE,
              tb.out_trade_no AS OUT_TRADE_NO,
              tb.date_created AS CREATE_DATE,
              tb.last_updated AS LAST_UPDATED,
              tb.status AS TRADE_STATUS,
              tb.note AS TRADE_NOTE,
              bo_offline_charge.creator_id AS OPER_CODE,
              bo_offline_charge.creator_name AS OPER_NAME,
              ccc.name AS CUSTOMER_NAME,
              ccc.customer_no AS CUSTOMER_NO,
              ccc.type AS CUSTOMER_TYPE,
              ccc.account_no AS CUSTOMER_ACCOUNT,
              case when tb.payee_id=ccc.id then tb.PAYER_CODE else tb.PAYEE_CODE end as ACCEPT_ORG_NO,
              case when tb.payee_id=ccc.id then tb.payer_name else tb.payee_name end as ACCEPT_ORG_NAME,
              case when tb.payee_id=ccc.id then tb.PAYER_ACCOUNT_NO else tb.PAYEE_ACCOUNT_NO end as ACCEPT_ORG_ACCOUNT,
              ccc.branch_company as BRANCH_CODE,
              bbc.company_name as BRANCH_NAME

              from ismp.trade_base tb
              inner join
              (select cmc.id,cmc.customer_category,cmc.account_no,cmc.customer_no,cmc.name,cmc.type,cmci.branch_company
               from ismp.cm_customer cmc, ismp.cm_corporation_info cmci
               where cmc.id = cmci.id and customer_category = 'travel'

              ) ccc

              on (tb.payer_id = ccc.id or tb.payee_id = ccc.id)
              left join boss.bo_branch_company bbc on ccc.branch_company=bbc.id

              left join boss.bo_offline_charge bo_offline_charge
              on tb.out_trade_no = bo_offline_charge.trx_seq

              left join account.ac_transaction ac_transaction
              on tb.trade_no = ac_transaction.trade_no and tb.trade_type=ac_transaction.transfer_type

              left join account.ac_sequential ac_sequential
              on ac_sequential.transaction_id = ac_transaction.id and ac_sequential.account_no = ccc.account_no
              where 1 = 1
              ${startDateCreated ? ' and tb.DATE_CREATED>=?' : ''}
              ${endDateCreated ? ' and tb.DATE_CREATED<?' : ''}
              ${startDateCompleted ? ' and tb.LAST_UPDATED>=?' : ''}
              ${endDateCompleted ? ' and tb.LAST_UPDATED<?' : ''}
              ${tradeAmount ? ' and tb.AMOUNT=? ' : ''}
              ${tradeNo ? ' and tb.TRADE_NO=? ' : ''}
              ${outTradeNo ? ' and tb.OUT_TRADE_NO=? ' : ''}
              ${status ? ' and tb.STATUS=? ' : ''}
              ${paymentType ? ' and tb.TRADE_TYPE=? ' : ''}
              ${accountNo ? ' and ccc.account_no=? ' : ''}
              ${merchantName ? ' and ccc.name=? ' : ''}
              ${branchCode ? ' and ccc.branch_company=? ' : ''}
              ${currentUserBanchcode ? ' and ccc.branch_company=? ' : ''}
              order by tb.date_created desc

        """
        def queryCountString = """
                    select count(*) total from (${queryResultString})
          """
        def count = new Sql(dataSource_boss).firstRow(queryCountString, queryparam_)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(queryResultString.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryparam_.size(); i++) {
                sqlquery.setParameter(i, queryparam_.get(i))
            }
            return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)
//        [result: result, total: count.total, params: params]
        [result: result, total: count.total, params: params, flag: flag]

//        def queryCountString = """
//                            select count(*) total from (${queryResultString_})
//                  """
//                def count = new Sql(dataSource_ismp).firstRow(queryCountString, queryparam_)
//
//                HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
//                def result = ht.executeFind({ Session session ->
//                    def sqlquery = session.createSQLQuery(queryResultString_.toString())
//                    sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
//                    for (def i = 0; i < queryparam_.size(); i++) {
//                        sqlquery.setParameter(i, queryparam_.get(i))
//                    }
//                    return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
//                } as HibernateCallback)
//        //        [result: result, total: count.total, params: params]
//                [result: result, total: count.total, params: params, flag: flag]

    }
    /**
     *  商旅账户交易明细报表excel下载
     */
    def queryFundDetailsReportDownload = {

        BoOperator op = session.getValue("op")
        def branchCode = params.branchCode ? params.branchCode.trim() : null
        def currentUserBanchcode = op?.branchCompany?.trim()
        def merchantName = params.merchantName ? params.merchantName.trim() : null;
        def accountNo = params.accountNo ? params.accountNo.trim() : null;
        def paymentType = params.paymentType ? params.paymentType.trim() : null;
        def tradeAmount = params.tradeAmount ? params.tradeAmount.trim() : null;
        def tradeNo = params.tradeNo ? params.tradeNo.trim() : null;
        def outTradeNo = params.outTradeNo ? params.outTradeNo.trim() : null;
        def status = params.status ? params.status.trim() : null;

        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        validCreatedDated(params)
        validCompletedDated(params)

        Date startDateCreated = params.startDateCreated ? Date.parse('yyyy-MM-dd', params.startDateCreated) : null
        Date endDateCreated = params.endDateCreated ? Date.parse('yyyy-MM-dd', params.endDateCreated) + 1 : null
        Date startDateCompleted = params.startDateCompleted ? Date.parse('yyyy-MM-dd', params.startDateCompleted) : null
        Date endDateCompleted = params.endDateCompleted ? Date.parse('yyyy-MM-dd', params.endDateCompleted) + 1 : null

        def queryparam_ = []

        if (startDateCreated) {
            queryparam_.add(new java.sql.Date(startDateCreated.getTime()))
        }
        if (endDateCreated) {
            queryparam_.add(new java.sql.Date(endDateCreated.getTime()))
        }

        if (startDateCompleted) {
            queryparam_.add(new java.sql.Date(startDateCompleted.getTime()))
        }
        if (endDateCompleted) {
            queryparam_.add(new java.sql.Date(endDateCompleted.getTime()))
        }

        if (tradeAmount) {
            queryparam_.add(Double.valueOf(tradeAmount) * 100)
        }
        if (tradeNo) {
            queryparam_.add(tradeNo)
        }

        if (outTradeNo) {
            queryparam_.add(outTradeNo)
        }

        if (status) {
            queryparam_.add(status)
        }
        if (paymentType) {
            queryparam_.add(paymentType)
        }

        if (accountNo) {
            queryparam_.add(accountNo)
        }


        if (merchantName) {
            queryparam_.add(merchantName)
        }

        if (branchCode) {
            queryparam_.add(branchCode)
        }
        if (currentUserBanchcode) {
            queryparam_.add(currentUserBanchcode)
        }


        def queryResultString = """
                      select
                      tb.trade_no AS TRADE_NO,
                      tb.amount AS NET_AMOUNT,
                      ac_sequential.balance AS CUSTOMER_BALANCE,
                      tb.fee_amount AS FEE,
                      tb.trade_type AS TRADE_TYPE,
                      tb.service_type AS SERVICE_TYPE,
                      tb.payment_type AS PAYMENT_TYPE,
                      tb.out_trade_no AS OUT_TRADE_NO,
                      tb.date_created AS CREATE_DATE,
                      tb.last_updated AS LAST_UPDATED,
                      tb.status AS TRADE_STATUS,
                      tb.note AS TRADE_NOTE,
                      bo_offline_charge.creator_id AS OPER_CODE,
                      bo_offline_charge.creator_name AS OPER_NAME,
                      ccc.name AS CUSTOMER_NAME,
                      ccc.customer_no AS CUSTOMER_NO,
                      ccc.type AS CUSTOMER_TYPE,
                      ccc.account_no AS CUSTOMER_ACCOUNT,
                      case when tb.payee_id=ccc.id then tb.PAYER_CODE else tb.PAYEE_CODE end as ACCEPT_ORG_NO,
                      case when tb.payee_id=ccc.id then tb.payer_name else tb.payee_name end as ACCEPT_ORG_NAME,
                      case when tb.payee_id=ccc.id then tb.PAYER_ACCOUNT_NO else tb.PAYEE_ACCOUNT_NO end as ACCEPT_ORG_ACCOUNT,
                      ccc.branch_company as BRANCH_CODE,
                      bbc.company_name as BRANCH_NAME

                      from ismp.trade_base tb
                      inner join
                      (select cmc.id,cmc.customer_category,cmc.account_no,cmc.customer_no,cmc.name,cmc.type,cmci.branch_company
                       from ismp.cm_customer cmc, ismp.cm_corporation_info cmci
                       where cmc.id = cmci.id and customer_category = 'travel'

                      ) ccc

                      on (tb.payer_id = ccc.id or tb.payee_id = ccc.id)
                      left join boss.bo_branch_company bbc on ccc.branch_company=bbc.id

                      left join boss.bo_offline_charge bo_offline_charge
                      on tb.out_trade_no = bo_offline_charge.trx_seq

                      left join account.ac_transaction ac_transaction
                      on tb.trade_no = ac_transaction.trade_no and tb.trade_type=ac_transaction.transfer_type

                      left join account.ac_sequential ac_sequential
                      on ac_sequential.transaction_id = ac_transaction.id and ac_sequential.account_no = ccc.account_no
                      where 1 = 1
                      ${startDateCreated ? ' and tb.DATE_CREATED>=?' : ''}
                      ${endDateCreated ? ' and tb.DATE_CREATED<?' : ''}
                      ${startDateCompleted ? ' and tb.LAST_UPDATED>=?' : ''}
                      ${endDateCompleted ? ' and tb.LAST_UPDATED<?' : ''}
                      ${tradeAmount ? ' and tb.AMOUNT=? ' : ''}
                      ${tradeNo ? ' and tb.TRADE_NO=? ' : ''}
                      ${outTradeNo ? ' and tb.OUT_TRADE_NO=? ' : ''}
                      ${status ? ' and tb.STATUS=? ' : ''}
                      ${paymentType ? ' and tb.TRADE_TYPE=? ' : ''}
                      ${accountNo ? ' and ccc.account_no=? ' : ''}
                      ${merchantName ? ' and ccc.name=? ' : ''}
                      ${branchCode ? ' and ccc.branch_company=? ' : ''}
                      ${currentUserBanchcode ? ' and ccc.branch_company=? ' : ''}
                      order by tb.date_created desc

                """
        def queryCountString = """
                            select count(*) total from (${queryResultString})
                  """
        def count = new Sql(dataSource_boss).firstRow(queryCountString, queryparam_)

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlquery = session.createSQLQuery(queryResultString.toString())
            sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryparam_.size(); i++) {
                sqlquery.setParameter(i, queryparam_.get(i))
            }
            return sqlquery.list();
        } as HibernateCallback)

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "queryFundDetailsReportXls", model: [result: result, total: count.total, params: params])
    }

/**
 * 验证Created截断日期
 * @param params
 * @return
 */
    def validCreatedDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (!params.startDateCreated && !params.endDateCreated) {
            def gCalendar = new GregorianCalendar()
            params.endDateCreated = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startDateCreated = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startDateCreated && !params.endDateCreated) {
            params.endDateCreated = params.startDateCreated
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startDateCreated && params.endDateCreated) {
            params.startDateCreated = params.endDateCreated
        }
        if (params.startDateCreated && params.endDateCreated) {
        }
    }

/**
 * 验证Created截断日期
 * @param params
 * @return
 */
    def validCompletedDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (!params.startDateCompleted && !params.endDateCompleted) {
            def gCalendar = new GregorianCalendar()
            params.endDateCompleted = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startDateCompleted = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startDateCompleted && !params.endDateCompleted) {
            params.endDateCompleted = params.startDateCompleted
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startDateCompleted && params.endDateCompleted) {
            params.startDateCompleted = params.endDateCompleted
        }
        if (params.startDateCompleted && params.endDateCompleted) {
        }
    }

    def queryPersonPortalShow = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null

        if (startDate && endDate) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(startDate);

            calendar.add(Calendar.MONTH, 6)
            def maxDate = calendar.getTime();
            if (startDate.getTime() > endDate.getTime()) {
                flash.message = "起始日期应小于截止日期"
                return
            }
            if (maxDate.getTime() < endDate.getTime()) {
                flash.message = "起始日期与截止日期间隔应小于6个月"
                return
            }



            def former = "yyyyMMdd"
            SimpleDateFormat df = new SimpleDateFormat(former);

            def nowDate = new Date()
            if (nowDate + 1 < endDate) {
                flash.message = "截止日期最大应为今天"
                return
            }


            def queryParam = []
            queryParam.add(new java.sql.Date(startDate.getTime()))
            queryParam.add(new java.sql.Date(endDate.getTime()))

            def sql = new Sql(dataSource_boss)

            def queryIntBalanceSql = """select t.balance from report_portal_daily t where to_char(t.date_created,'yyyyMMdd') = ?"""
            def queryIntBalance = sql.firstRow(queryIntBalanceSql, df.format((startDate - 1).getTime()))
            //期初余额
            long intBalance = 0
            if (queryIntBalance)
                intBalance = queryIntBalance[0].longValue();

            def queryLastBalanceSql = """select t.balance from report_portal_daily t where to_char(t.date_created,'yyyyMMdd') = ?"""
            def queryLastBalance = sql.firstRow(queryLastBalanceSql, df.format((endDate - 1).getTime()))
            //期末余额
            long lastBalance = 0
            if (queryLastBalance)
                lastBalance = queryLastBalance[0].longValue();

            //交易客户、金额、笔数、合计
            def query = """select count(*),
                               sum(t.customer_tradetotal) ctt,
                               sum(t.charge_total_amount) chttm,
                               sum(t.charge_total_count) chttc,
                               sum(t.pay_amount) pm,
                               sum(t.pay_count) pc,
                               sum(t.withdrawn_amount) wdm,
                               sum(t.withdrawn_count) wdc,
                               sum(t.refund_amount) ra,
                               sum(t.refund_count) rc,
                               sum(t.transfer_amount) ta,
                               sum(t.transfer_count) tc
                          from report_portal_daily t
                         where t.date_created>=? and t.date_created<?"""
            def result = sql.firstRow(query, queryParam)
//            def count = sql.firstRow("select count(*) total,nvl(sum(am),0) am,nvl(sum(co),0) co from (${query})", queryParam)
//            //def result = sql.rows(query.toString() + " ", queryParam)
//
//            HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
//            def result = ht.executeFind({ Session session ->
//                def sqlquery = session.createSQLQuery(query.toString())
//                sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
//                for (def i = 0; i < queryParam.size(); i++) {
//                    sqlquery.setParameter(i, queryParam.get(i))
//                }
//                return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
//            } as HibernateCallback)

            //println result.dump()
            //println count.total
            [totalCus: result[1]?.longValue(), intBa: intBalance,
                    chargeM: result[2]?.longValue(), chargeC: result[3]?.longValue(),
                    paymentM: result[4]?.longValue(), paymentC: result[5]?.longValue(),
                    withdrawnM: result[6]?.longValue(), withdrawnC: result[7]?.longValue(),
                    refundM: result[8]?.longValue(), refundC: result[9]?.longValue(),
                    transferM: result[10]?.longValue(), transferC: result[11]?.longValue(),
                    lastBa: lastBalance]

        } else {
            if (startDate) {
                if (!endDate) {
                    flash.message = "截止日期不能为空"
                    return
                }
            }
            if (endDate) {
                if (!startDate) {
                    flash.message = "起始日期不能为空"
                    return
                }
            }
        }


    }

    def queryPersonPortalDownload = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def startDate = params.startDate ? Date.parse('yyyy-MM-dd', params.startDate) : null
        def endDate = params.endDate ? Date.parse('yyyy-MM-dd', params.endDate) + 1 : null
        def former = "yyyyMMdd"
        SimpleDateFormat df = new SimpleDateFormat(former);
        def queryParam = []
        queryParam.add(new java.sql.Date(startDate.getTime()))
        queryParam.add(new java.sql.Date(endDate.getTime()))

        def sql = new Sql(dataSource_boss)

        def queryIntBalanceSql = """select t.balance from report_portal_daily t where to_char(t.date_created,'yyyyMMdd') = ?"""
        def queryIntBalance = sql.firstRow(queryIntBalanceSql, df.format((startDate - 1).getTime()))
        //期初余额
        long intBalance = 0
        if (queryIntBalance)
            intBalance = queryIntBalance[0].longValue();

        def queryLastBalanceSql = """select t.balance from report_portal_daily t where to_char(t.date_created,'yyyyMMdd') = ?"""
        def queryLastBalance = sql.firstRow(queryLastBalanceSql, df.format((endDate - 1).getTime()))
        //期末余额
        long lastBalance = 0
        if (queryLastBalance)
           lastBalance = queryLastBalance[0].longValue();

        //交易客户、金额、笔数、合计
        def query = """select count(*),
                            sum(t.customer_tradetotal) ctt,
                            sum(t.charge_total_amount) chttm,
                            sum(t.charge_total_count) chttc,
                            sum(t.pay_amount) pm,
                            sum(t.pay_count) pc,
                            sum(t.withdrawn_amount) wdm,
                            sum(t.withdrawn_count) wdc,
                            sum(t.refund_amount) ra,
                            sum(t.refund_count) rc,
                            sum(t.transfer_amount) ta,
                            sum(t.transfer_count) tc
                       from report_portal_daily t
                      where t.date_created>=? and t.date_created<?"""
        def result = sql.firstRow(query, queryParam)
//            def count = sql.firstRow("select count(*) total,nvl(sum(am),0) am,nvl(sum(co),0) co from (${query})", queryParam)
//            //def result = sql.rows(query.toString() + " ", queryParam)
//
//            HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
//            def result = ht.executeFind({ Session session ->
//                def sqlquery = session.createSQLQuery(query.toString())
//                sqlquery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
//                for (def i = 0; i < queryParam.size(); i++) {
//                    sqlquery.setParameter(i, queryParam.get(i))
//                }
//                return sqlquery.setFirstResult(params.offset).setMaxResults(params.max).list();
//            } as HibernateCallback)

        //println result.dump()
        //println count.total
        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "personportalxls", model: [totalCus: result[1]?.longValue(), intBa: intBalance,
                chargeM: result[2]?.longValue(), chargeC: result[3]?.longValue(),
                paymentM: result[4]?.longValue(), paymentC: result[5]?.longValue(),
                withdrawnM: result[6]?.longValue(), withdrawnC: result[7]?.longValue(),
                refundM: result[8]?.longValue(), refundC: result[9]?.longValue(),
                transferM: result[10]?.longValue(), transferC: result[11]?.longValue(),
                lastBa: lastBalance])


    }
}
