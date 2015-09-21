package settle

import groovy.sql.Sql
import org.springframework.orm.hibernate3.HibernateTemplate
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import account.AccountClientService
import ismp.TradeWithdrawn
import boss.BoInnerAccount
import ismp.CmCustomerBankAccount
import ismp.CmCustomer

class FtFootController {

    def dataSource_settle
    def AccountClientService accountClientService

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
            if(cus.size() > 0){
                def StringBuffer sb = new StringBuffer()
                for(def cu in cus){
                    sb.append("'").append(cu.customerNo).append("',")
                }
                merNameList = sb.deleteCharAt(sb.length()-1).toString()
            }
        }

        println "#merNameList#${merNameList}"

        // 合计
        def total_amount_sql="select nvl(sum(t.amount),0) amount,nvl(sum(t.pre_fee),0) preFee from ft_foot t where t.fee_type=0 and t.check_status=0 "

        def query =  """
                      select fo.ID id,fo.CUSTOMER_NO customerNo,fo.FOOT_NO footNo,
                             fo.FOOT_DATE footDate,fo.SRV_CODE srvCode,fo.TRADE_CODE tradeCode,
                             fo.TRANS_NUM transNum,fo.AMOUNT amount,fo.PRE_FEE preFee,
                             fo.POST_FEE postFee,fo.CREATE_OP_ID createOpId,fo.CHECK_STATUS checkStatus,
                             li.minTime minTime,li.maxTime maxTime,na.SRV_NAME srvName,na.TRADE_NAME tradeName
                      from FT_FOOT fo
                      left join (select FOOT_NO,min(LIQ_DATE) minTime,max(LIQ_DATE) maxTime
                                 from FT_LIQUIDATE
                                 where STATUS=1 ${params.mid ? " and CUSTOMER_NO like '%"+params.mid+"%'" : ""} ${params.bType ? " and SRV_CODE='"+params.bType+"'" : ""} ${params.tType ? " and TRADE_CODE='"+params.tType+"'" : ""}
                                 group by CUSTOMER_NO,FOOT_NO,SRV_CODE,TRADE_CODE
                                ) li
                      on fo.FOOT_NO = li.FOOT_NO
                      left join (select st.SRV_NAME SRV_NAME,tt.TRADE_NAME TRADE_NAME,st.SRV_CODE SRV_CODE,tt.TRADE_CODE TRADE_CODE
                                 from FT_SRV_TRADE_TYPE tt
                                 left join FT_SRV_TYPE st
                                 on st.ID=tt.SRV_ID
                                ) na
                      on fo.SRV_CODE = na.SRV_CODE and fo.TRADE_CODE = na.TRADE_CODE
                      where fo.CHECK_STATUS=0  ${params.mid ? " and CUSTOMER_NO like '%"+params.mid+"%'" : ""} ${params.bType ? " and fo.SRV_CODE='"+params.bType+"'" : ""} ${params.tType ? " and fo.TRADE_CODE='"+params.tType+"'" : ""}  ${merNameList ? " and fo.CUSTOMER_NO in ("+merNameList+")":""}
                      order by fo.ID desc
                  """ //and FEE_TYPE=0

        total_amount_sql += " ${params.mid ? " and CUSTOMER_NO like '%"+params.mid+"%'" : ""} ${params.bType ? " and t.SRV_CODE=" + "'${params.bType}'" : ""} ${params.tType ? " and t.TRADE_CODE=" + "'${params.tType}'" : ""} ${merNameList ? " and CUSTOMER_NO in ("+merNameList+")":""}"

        println("query:"+"select count(*) total from (${query})")

        def count = sql.firstRow("select count(*) total from (${query})",queryParam)

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

        // 业务类型,交易类型
        def bTypeList = FtSrvType.list()
        def tTypeList = null
        if(params.bType != null && params.bType != ""){
            tTypeList = FtSrvTradeType.findAllBySrv(FtSrvType.findBySrvCode(params.bType))
        }

        // 合计
        println "###${total_amount_sql}"
        def total_amount_fee=sql.firstRow(total_amount_sql)
        def totalAmount=total_amount_fee.amount
        def totalPreFee=total_amount_fee.preFee

        [result: result, total: count.total, bTypeList: bTypeList,tTypeList:tTypeList,params:params,totalAmount:totalAmount,totalPreFee:totalPreFee]
    }

    def pass = {
        if(params.id){
            def ff = FtFoot.get(Long.valueOf(params.id))
            ff.rejectReason = '-'
            if(ff && ff.checkStatus == 0){
                //find accountNo
                def customer = ismp.CmCustomer.findByCustomerNo(ff.customerNo)
                if(!customer){
                    flash.message = "${message(code: 'ftFoot.invalid.pass.customerNo.label',args:[message(code: 'ftFoot.label', default: 'FtFoot'), ff.customerNo])}"
                    redirect(action: "list")
                }
                def cid = customer.id
                def customService = boss.BoCustomerService.findByCustomerIdAndServiceCode(cid,ff.srvCode)
                if(!customService){
                    flash.message = "${message(code: 'ftFoot.invalid.pass.customService.label',args:[message(code: 'ftFoot.label', default: 'FtFoot'), cid, ff.srvCode])}"
                    redirect(action: "list")
                }
                def oughtAcc = boss.BoInnerAccount.findByKey("feeInAdvance").accountNo
                def alreadyAcc = boss.BoInnerAccount.findByKey("feeAcc").accountNo

                println "cid=${cid},customService.srvAccNo=${customService.srvAccNo},oughtAcc=${oughtAcc},alreadyAcc=${alreadyAcc}"

                def cmdList = []

                //解冻资金账户冻结金额
                if (ff.freezeAmount && ff.freezeAmount > 0) {
                  cmdList = accountClientService.buildUnfreeze(cmdList, customer.accountNo, ff.freezeAmount, 'unfrozen', ff.footNo, '0', '结算解冻金额')
                }
                cmdList = accountClientService.buildTransfer(cmdList,customService.srvAccNo,customer.accountNo, ff.amount-ff.preFee, "settle", "0", "0", "净额结算完成")
                if(ff.preFee != 0){
                    cmdList = accountClientService.buildTransfer(cmdList,oughtAcc,alreadyAcc, ff.preFee, "fee", "0", "0", "手续费结算完成")
                }

                def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
                def transResult = accountClientService.batchCommand(commandNo, cmdList)

                println "commandNo=${commandNo},cmdList=${cmdList},transResult.result=${transResult.result}"

                if (transResult.result == 'true') {
                    ff.checkStatus=1
                    ff.checkOpId=session.op.id
                    ff.checkDate = new Date()
                    ff.save(failOnError:true)

//                    //自动提现处理
//                    def footSetting = FtSrvFootSetting.withCriteria(uniqueResult:true){
//                      eq('customerNo', customer.customerNo)
//                      srv {
//                        eq('srvCode', ff.srvCode)
//                      }
//                      tradeType {
//                        eq('tradeCode', ff.tradeCode)
//                      }
//                    }
//                    if(footSetting && footSetting.withdraw == 1) {
//                      autoWithdraw(ff, customer)
//                    }

                    flash.message = "${message(code: 'ftFoot.pass.args.label',args:[message(code: 'ftFoot.label', default: 'FtFoot'), params.id])}"
                    redirect(action: "list")
                }else{
                    flash.message = "${message(code: 'ftFoot.invalid.pass.transfer.label',args:[message(code: 'ftFoot.label', default: 'FtFoot'), params.id])}"
                    redirect(action: "list")
                }
            }else{
                flash.message = "${message(code: 'ftFoot.invalid.noFootFund.label')}"
                redirect(action: "list")
            }
        }else{
            flash.message = "error foot id"
            redirect(action: "list")
        }
    }

    def reject = {
        if(params.id && params.msg){
            def ff = FtFoot.get(Long.valueOf(params.id))
            if(ff && ff.checkStatus == 0){
                ff.rejectReason = params.msg
                ff.checkStatus=2
                ff.checkOpId=session.op.id
                ff.checkDate=new Date()

                def lines = 0;
                FtFoot.withTransaction {tx ->
                    ff.save()

                    def update = "update FtLiquidate set status=0,footNo='' where footNo='${ff.footNo}'"
                    lines = FtLiquidate.executeUpdate(update);
                }

                if(lines > 0){
                    flash.message = "${message(code: 'ftFoot.reject.args.label',args:[message(code: 'ftFoot.label', default: 'FtFoot'), params.id])}"
                    redirect(action: "list")
                }else{
                    flash.message = "${message(code: 'ftFoot.invalid.noLiquidate.label')}"
                    redirect(action: "list")
                }
            }else{
                flash.message = "${message(code: 'ftFoot.invalid.noFootFund.label')}"
                redirect(action: "list")
            }
        }else{
            flash.message = "${message(code: 'ftFoot.invalid.noRejectReason.label')}"
            redirect(action: "list")
        }
    }

//
//  //自动提现
//  def autoWithdraw(FtFoot foot, CmCustomer customer) {
//    log.info('auto withdraw')
//    try {
//      if (foot.amount - foot.preFee <= 0) {
//        log.warn('提现金额小于等于0，不进行提现')
//        return
//      }
//      def cmCustomerBankAccount = CmCustomerBankAccount.findByCustomerAndIsDefault(customer, true)
//      if (!cmCustomerBankAccount) {
//        log.warn("客户没有设置提现银行，无法生成提现申请。客户号：" + customer.customerNo)
//        return
//      }
//      def boInnerAccount = BoInnerAccount.findByKey("middleAcc")
//      def cmdList = []
//      cmdList = accountClientService.buildTransfer(null, customer.accountNo, boInnerAccount.accountNo, foot.amount - foot.preFee, "withdrawn", "0", "0", "结算自动提现")
//
//      def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
//      def transResult = accountClientService.batchCommand(commandNo, cmdList)
//
//      println "commandNo=${commandNo},cmdList=${cmdList},transResult.result=${transResult.result}"
//
//      if (transResult.result == 'true') {
//        //写提现交易表
//        def trade = new TradeWithdrawn()
//        trade.rootId = null
//        trade.originalId = null
//        trade.tradeNo = foot.footNo
//        trade.tradeType = 'withdrawn'
//        trade.partnerId = null
//        trade.payerId = customer.id
//        trade.payerName = customer.name
//        trade.payerCode = customer.customerNo
//        trade.payerAccountNo = customer.accountNo
//        //trade.payeeId=0
//        trade.payeeName = boInnerAccount.note
//        trade.payeeCode = boInnerAccount.key
//        trade.payeeAccountNo = boInnerAccount.accountNo
//        trade.outTradeNo = null
//        trade.amount = foot.amount - foot.preFee
//        trade.currency = 'CNY'
//        trade.subject = null
//        trade.status = 'completed'
//        trade.tradeDate = new java.text.SimpleDateFormat('yyyyMMdd').format(new Date()) as Integer
//        trade.note = '结算自动提现'
//        //提现表属性
//        trade.submitType = 'automatic'
//        trade.customerOperId = 0
//        trade.submitter = '结算系统'
//        trade.transferFee = 0
//        trade.realTransferAmount = 0
//        trade.customerBankAccountId = cmCustomerBankAccount.id
//        trade.customerBankCode = cmCustomerBankAccount.bankCode
//        trade.customerBankNo = cmCustomerBankAccount.bankNo
//        trade.customerBankAccountName = cmCustomerBankAccount.bankAccountName
//        trade.customerBankAccountNo = cmCustomerBankAccount.bankAccountNo
//        trade.isCorporate = cmCustomerBankAccount.isCorporate
//        trade.handleStatus = 'waiting'
//        trade.save flush: true, failOnError: true
//        log.info("auto withdraw success, ${foot.dump()}")
//      }
//    } catch (Exception e) {
//      log.warn('自动提现失败', e)
//    }
//  }
}