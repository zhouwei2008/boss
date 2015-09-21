package account

import boss.BoAccountAdjustInfo
import groovy.sql.Sql
import boss.BoAdjustType
import org.springframework.orm.hibernate3.HibernateTemplate
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback

class AcAccountController {

  def dataSource_account
  AccountClientService  accountClientService
  static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

  def index = {
    redirect(action: "list", params: params)
  }

  def list = {
    params.sort = params.sort ? params.sort : "dateCreated"
    params.order = params.order ? params.order : "desc"
//  params.sort = params.sort ? params.sort : "accountNo"
//  params.order = params.order ? params.order : "asc"
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    params.offset = params.offset ? params.int('offset') : 0
    def query = {
      if (params.accountNo != null && params.accountNo != '') {
          like('accountNo', "%"+params.accountNo.trim()+"%")
      }
      if(params.accountName!=null && params.accountName!=''){
          like("accountName","%"+params.accountName+"%")
      }
      if (params.status != null && params.status != '') {
        eq('status', params.status)
      }
      if (params.balanceOfDirection != null && params.balanceOfDirection != '') {
        eq('balanceOfDirection', params.balanceOfDirection)
      }
      eq('accountType', 'main')
    }
    def total = AcAccount.createCriteria().count(query)
    //AcAccount.createCriteria().list(query)

    def list = AcAccount.createCriteria().list(params, query)
    def results = new ArrayList<HashMap<String,Object>>(list.size())
    for(AcAccount aca : list){
        def map = [account:aca]
        def freeze = AcAccount.findByParentId(aca.id)
        if(!freeze){
            continue
        }
        map.put('frAccountNo',freeze.accountNo)
        map.put('frBalance',freeze.balance)
        results.add(map)
    }

    def sql = new Sql(dataSource_account)
    def queryParam = []

    def query2 = """
                    select sum(bal) bal,sum(frbal) frbal
                    from (
                            select ac.BALANCE bal, frac.BALANCE frbal
                            from AC_ACCOUNT ac
                            left join AC_ACCOUNT frac
                            on ac.ID = frac.PARENT_ID
                            where ac.ACCOUNT_TYPE='main'
                                  ${(params.accountNo != null && params.accountNo != '') ? " and ac.ACCOUNT_NO like '%"+params.accountNo.trim()+"%'":""}
                                  ${(params.accountName!=null && params.accountName!='') ? " and ac.ACCOUNT_NAME like '%"+params.accountName+"%'":""}
                                  ${(params.status != null && params.status != '') ? " and ac.STATUS='"+params.status+"'":""}
                                  ${(params.balanceOfDirection != null && params.balanceOfDirection != '') ? " and ac.BALANCE_OF_DIRECTION='"+params.balanceOfDirection+"'":""}
                         )
               """

    //log.info "=======================query2=${query2}"
    def sum = sql.firstRow(query2, queryParam)
    //log.info "=======================sum=${sum}"
    if(sum.BAL == null){
        sum.BAL = 0
    }
    if(sum.FRBAL == null){
        sum.FRBAL = 0
    }
    //log.info "=======================sum=${sum}"

    [mapList: results, sum:sum,acAccountInstanceTotal: total, params: params]
  }

  def downloadList = {
        params.sort = params.sort ? params.sort : "accountNo"
        params.order = params.order ? params.order : "asc"
//        params.max = Math.min(params.max ? params.int('max') : 10, 100)
//        params.offset = params.offset ? params.int('offset') : 0
        params.max = 50000
        params.offset = 0

        def sql = new Sql(dataSource_account)
        def queryParam = []

        def query1 =  """
                        select ac.ID id,ac.ACCOUNT_NO accountNo,ac.ACCOUNT_NAME accountName,ac.BALANCE_OF_DIRECTION balanceOfDirection,
                                       ac.BALANCE bal, frac.BALANCE frbal, ac.CURRENCY currency, ac.STATUS status,
                                       ac.DATE_CREATED dateCreated, ac.LAST_UPDATED lastUpdated
                        from AC_ACCOUNT ac
                        left join AC_ACCOUNT frac
                        on ac.ID = frac.PARENT_ID
                        where ac.ACCOUNT_TYPE='main'
                              ${(params.accountNo != null && params.accountNo != '') ? " and ac.ACCOUNT_NO like '%"+params.accountNo.trim()+"%'":""}
                              ${(params.accountName!=null && params.accountName!='') ? " and ac.ACCOUNT_NAME like '%"+params.accountName+"%'":""}
                              ${(params.status != null && params.status != '') ? " and ac.STATUS='"+params.status+"'":""}
                              ${(params.balanceOfDirection != null && params.balanceOfDirection != '') ? " and ac.BALANCE_OF_DIRECTION='"+params.balanceOfDirection+"'":""}
                   """

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('account')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query1.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)

        def query2 =  """
                        select sum(bal) bal,sum(frbal) frbal
                        from (
                                select ac.BALANCE bal, frac.BALANCE frbal
                                from AC_ACCOUNT ac
                                left join AC_ACCOUNT frac
                                on ac.ID = frac.PARENT_ID
                                where ac.ACCOUNT_TYPE='main'
                                      ${(params.accountNo != null && params.accountNo != '') ? " and ac.ACCOUNT_NO like '%"+params.accountNo.trim()+"%'":""}
                                      ${(params.accountName!=null && params.accountName!='') ? " and ac.ACCOUNT_NAME like '%"+params.accountName+"%'":""}
                                      ${(params.status != null && params.status != '') ? " and ac.STATUS='"+params.status+"'":""}
                                      ${(params.balanceOfDirection != null && params.balanceOfDirection != '') ? " and ac.BALANCE_OF_DIRECTION='"+params.balanceOfDirection+"'":""}
                             )
                   """

        def sum = sql.firstRow(query2, queryParam)
        if(sum.BAL == null){
            sum.BAL = 0
        }
        if(sum.FRBAL == null){
            sum.FRBAL = 0
        }

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "acAccountInfolist", model: [acAccountInfolist: result,summary:sum])
  }


  def show = {
    def acAccountInstance = AcAccount.get(params.id)
    def freezeAcc = AcAccount.findByParentIdAndAccountType(params.id, 'freeze')
    if (!acAccountInstance) {
      flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acAccount.label', default: 'AcAccount'), params.id])}"
      redirect(action: "list")
    }
    else {
      [acAccountInstance: acAccountInstance, freezeBalance: (freezeAcc ? freezeAcc.balance : 0)]
    }
  }

    def edit = {
        def acAccountInstance = AcAccount.get(params.id)
        def freezeAcc = AcAccount.findByParentIdAndAccountType(params.id, 'freeze')
        if (!acAccountInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acAccount.label', default: 'AcAccount'), params.id])}"
            redirect(action: "show")
        }
        else {
            [acAccountInstance: acAccountInstance, freezeBalance: (freezeAcc ? freezeAcc.balance : 0)]
        }
    }

    def update = {
        def acAccountInstance = AcAccount.get(params.id)
        def freezeAcc = AcAccount.findByParentIdAndAccountType(params.id, 'freeze')
        if (!acAccountInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acAccount.label', default: 'AcAccount'), params.id])}"
            redirect(action: "list")
        } else {
            acAccountInstance.properties = params
            if (!acAccountInstance.hasErrors() && acAccountInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'acAccount.label', default: 'AcAccount'), acAccountInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model:  [acAccountInstance: acAccountInstance, freezeBalance: (freezeAcc ? freezeAcc.balance : 0)])
            }
        }
    }


    /**
     * 账户调账
     */
  def accountAdjust={
      def adjTypeList = BoAdjustType.list()
      [adjTypeList:adjTypeList]
  }

  def searchAccount = {
      def accountNo = params.accountNo
      def n = ""
      def b = 0
      if(accountNo){
          def acc = AcAccount.findByAccountNo(accountNo)
          if(acc && acc instanceof AcAccount){
              n = acc.accountName
              b = acc.balance
          }else{
              n = "该账号信息不存在"
          }
      }else{
          n  = "未输入账号信息"
      }
      render (contentType: "text/json", encoding: "utf-8") {
          account {
              name =  n
              balance =  formatNumber(number:b/100,type:"currency",currencyCode:"CNY")
          }
      }
  }

  def doAdjust = {
        def fromAccountNo = params.fromAccountNo
        def toAccountNo = params.toAccountNo
        java.math.BigDecimal adjustMoney = new java.math.BigDecimal(params.adjustMoney).setScale(2, 0)
        def remark = params.remark
        def adjType = params.adjType

        //冻结账户的调账金额
        def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
        def cmdList = []
        cmdList = accountClientService.buildFreeze(null,fromAccountNo,adjustMoney*100,'frozen','0','0',"银行账户冻结,"+remark)
        def transResult = accountClientService.batchCommand(commandNo, cmdList)
        if (transResult.result == 'true') {
            //调账数据中间表加至
            BoAccountAdjustInfo accountAdjustInfo = new BoAccountAdjustInfo()
            accountAdjustInfo.fromAccountNo=fromAccountNo
            accountAdjustInfo.toAccountNo=toAccountNo
            accountAdjustInfo.adjustAmount=adjustMoney*100
            accountAdjustInfo.remark=remark
            accountAdjustInfo.status="waitApp"
            accountAdjustInfo.sIP=request.getHeader("X-Real-IP")==null?request.getRemoteAddr():request.getHeader("X-Real-IP")
            accountAdjustInfo.sponsor=session.op.name
            accountAdjustInfo.sponsorTime=new Date()
            accountAdjustInfo.adjType = adjType
            accountAdjustInfo.save(flush:true)

            flash.message = "账户调账申请提交成功"
            redirect(action: "accountAdjust")
            return
        } else {
            flash.message = "账户调账申请提交失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}"
            redirect(action: "accountAdjust")
            return
        }
  }
}