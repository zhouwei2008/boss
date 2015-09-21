package boss

import account.AccountClientService
import groovy.sql.Sql
import org.apache.commons.lang3.StringUtils
import org.springframework.orm.hibernate3.HibernateTemplate
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback

class BoAccountAdjustInfoController {

    AccountClientService accountClientService
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def dataSource_boss

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "SPONSOR_TIME"
        //params.order = params.order ? params.order : "asc"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        params.boAdjustType = params.boAdjustType?params.long('boAdjustType'):0
        params.boAdjustType = params.boAdjustType !=-1?params.boAdjustType:0
        //guonan update 2011-12-29
        validDated(params)

        def startDate = params.startSponsorTime
        def endDate = params.endSponsorTime
        def startAmount = params.startAdjustAmount ? (params.startAdjustAmount as int) * 100 : null
        def endAmount = params.endAdjustAmount ? (params.endAdjustAmount as int) * 100 : null
        def fromNo = params.fromAccountNo
        def toNo = params.toAccountNo
        def fromName = params.fromAccountName
        def toName = params.toAccountName
        def sponsor = params.sponsor
        def status = params.status

        //log.info("=======${startDate}=======${endDate}=========")

        def sql = new Sql(dataSource_boss)
        def queryParam = []

        def fromNameList = null
        def toNameList = null
        if(StringUtils.isNotEmpty(fromName)){
            def nameQuery = {
                like("accountName", "%" + fromName.trim() + "%")
            }

            def accountList = account.AcAccount.createCriteria().list([:], nameQuery)

            if (accountList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def acc in accountList) {
                    sb.append("'").append(acc.accountNo).append("',")
                }
                fromNameList = sb.deleteCharAt(sb.length() - 1).toString()
            }
        }
        if(StringUtils.isNotEmpty(toName)){
            def nameQuery = {
                like("accountName", "%" + toName.trim() + "%")
            }

            def accountList = account.AcAccount.createCriteria().list([:], nameQuery)

            if (accountList.size() > 0) {
                def StringBuffer sb = new StringBuffer()
                for (def acc in accountList) {
                    sb.append("'").append(acc.accountNo).append("',")
                }
                toNameList = sb.deleteCharAt(sb.length() - 1).toString()
            }
        }

        def query = """
                    select t.ID,t.SPONSOR_TIME,t.TO_ACCOUNT_NO,t.FROM_ACCOUNT_NO,t.ADJUST_AMOUNT,
                           t.SPONSOR,t.SIP,t.STATUS,t.APPROVE_PERSON,t.APPROVE_TIME,t.REMARK,t.ADJ_TYPE
                    from BO_ACCOUNT_ADJUST_INFO t
                    where 1=1
                          ${startDate ? " and t.SPONSOR_TIME >= to_date('" + startDate + " 00:00:00','yyyy-mm-dd hh24:mi:ss')" : ""}
                          ${endDate ? " and t.SPONSOR_TIME <= to_date('" + endDate + " 23:59:59','yyyy-mm-dd hh24:mi:ss')" : ""}
                          ${startAmount ? " and t.ADJUST_AMOUNT >= '" + startAmount + "'" : ""}
                          ${endAmount ? " and t.ADJUST_AMOUNT <= '" + endAmount + "'" : ""}
                          ${fromNo ? " and t.FROM_ACCOUNT_NO like '%" + fromNo.trim() + "%'" : ""}
                          ${toNo ? " and t.TO_ACCOUNT_NO like '%" + toNo.trim() + "%'" : ""}
                          ${sponsor ? " and t.SPONSOR like '%" + sponsor.trim() + "%'" : ""}
                          ${status ? " and t.STATUS = '" + status + "'" : ""}
                          ${fromNameList ? " and t.FROM_ACCOUNT_NO in (" + fromNameList + ")" : ""}
                          ${toNameList ? " and t.TO_ACCOUNT_NO in (" + toNameList + ")" : ""}
                          ${params.boAdjustType ? " and t.ADJ_TYPE = '" + params.boAdjustType + "'" : ""}
                    order by t.${params.sort} ${params.order}
                  """

        log.info("=======query========${query}")

        def count = sql.firstRow("select count(*) total,nvl(sum(ADJUST_AMOUNT),0) adjustAmount from (${query})", queryParam)
        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('boss')
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(query.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            for (def i = 0; i < queryParam.size(); i++) {
                sqlQuery.setParameter(i, queryParam.get(i))
            }

            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list();
        } as HibernateCallback)


        def adjTypeList = BoAdjustType.list()

        [boAccountAdjustInfoInstanceList: result,adjTypeList:adjTypeList, boAccountAdjustInfoInstanceTotal: count.total, params: params, totalAdjust:count.adjustAmount]
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
        if (params.startSponsorTime==null && params.endSponsorTime==null){
            def gCalendar= new GregorianCalendar()
            params.endSponsorTime=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startSponsorTime=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startSponsorTime && !params.endSponsorTime){
             params.endSponsorTime=params.startSponsorTime
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startSponsorTime && params.endSponsorTime){
             params.startSponsorTime=params.endSponsorTime
        }
        if (params.startSponsorTime && params.endSponsorTime) {


        }
    }


    def listDownload = {
        params.sort = params.sort ? params.sort : "id"
        params.order = params.order ? params.order : "desc"
        params.max = 50000
        params.offset = 0
        def query = {

//            if(params.startSponsorTime){
//                gt("sponsorTime", Date.parse("yyyy-MM-dd",params.startSponsorTime))
//            }
//            if(params.endSponsorTime){
//                lt("sponsorTime", Date.parse("yyyy-MM-dd",params.endSponsorTime)+1)
//            }

             //guonan update 2011-12-29
            validDated(params)
            if(params.startSponsorTime){
                ge("sponsorTime", Date.parse("yyyy-MM-dd",params.startSponsorTime))
            }
            if(params.endSponsorTime){
                lt("sponsorTime", Date.parse("yyyy-MM-dd",params.endSponsorTime)+1)
            }

            if(params.status!="" && params.status!=null){
                eq("status",params.status)
            }else{
                'in'("status",BoAccountAdjustInfo.statusMap.keySet())
            }
            if(params.fromAccountNo){
                like("fromAccountNo","%"+params.fromAccountNo.toString().trim()+"%")
            }
            if(params.toAccountNo){
                like("toAccountNo","%"+params.toAccountNo.toString().trim()+"%")
            }
            if(params.sponsor){
                like("sponsor","%"+params.sponsor.toString().trim()+"%")
            }
        }
        //def total = BoAccountAdjustInfo.createCriteria().count(query)
        def results = BoAccountAdjustInfo.createCriteria().list(params, query)

        def summary = BoAccountAdjustInfo.createCriteria().get {
            and query
//            eq('tradeType', 'payment')
            projections {
                sum('adjustAmount')
                rowCount()
            }
        }

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "accountAdjustInfolist", model: [boAccountAdjustInfoInstanceList: results,totalAmount:summary[0],total:summary[1]])
    }

    def create = {
        def boAccountAdjustInfoInstance = new BoAccountAdjustInfo()
        boAccountAdjustInfoInstance.properties = params
        return [boAccountAdjustInfoInstance: boAccountAdjustInfoInstance]
    }

    def save = {
        def appFlag = params.appFlag
        BoAccountAdjustInfo boAccountAdjustInfoInstance = BoAccountAdjustInfo.get(params.int('id'))
        if (boAccountAdjustInfoInstance.status == 'waitApp') {
            if (boAccountAdjustInfoInstance != null) {
                //0：通过、1：拒绝
                if (appFlag == "0") {
                    //解冻
                    def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
                    def cmdList = []
                    cmdList = accountClientService.buildUnfreeze(null, boAccountAdjustInfoInstance.fromAccountNo, boAccountAdjustInfoInstance.adjustAmount, 'unfrozen', '0', '0', "银行账户解冻，" + params.remark)
                    cmdList = accountClientService.buildTransfer(cmdList, boAccountAdjustInfoInstance.fromAccountNo, boAccountAdjustInfoInstance.toAccountNo, boAccountAdjustInfoInstance.adjustAmount, 'adjust', '0', '0', "银行账户调账")
                    def transResult = accountClientService.batchCommand(commandNo, cmdList)
                    if (transResult.result == 'true') {
                        boAccountAdjustInfoInstance.status = "pass";
                        boAccountAdjustInfoInstance.approveTime = new Date()
                        boAccountAdjustInfoInstance.approvePerson = session.op.name
                        boAccountAdjustInfoInstance.approveView = params.approveView
                        boAccountAdjustInfoInstance.save(flush: true)
                        flash.message = "账户申请调账审核成功"
                    } else {
                        flash.message = "账户申请调账审核失败，错误号：${transResult.errorCode}，错误信息：${transResult.errorMsg}"
                    }
                } else if (appFlag == "1") {
                    //解冻
                    def commandNoFr = UUID.randomUUID().toString().replaceAll('-', '')
                    def cmdListFr = []
                    cmdListFr = accountClientService.buildUnfreeze(null, boAccountAdjustInfoInstance.fromAccountNo, boAccountAdjustInfoInstance.adjustAmount, 'unfrozen', '0', '0', "银行账户解冻，" + params.remark)
                    def transResultFr = accountClientService.batchCommand(commandNoFr, cmdListFr)
                    if (transResultFr.result == 'true') {
                        boAccountAdjustInfoInstance.status = "refuse"
                        boAccountAdjustInfoInstance.approveTime = new Date()
                        boAccountAdjustInfoInstance.approvePerson = session.op.name
                        boAccountAdjustInfoInstance.approveView = params.approveView
                        boAccountAdjustInfoInstance.save(flush: true)
                        flash.message = "账户申请调账审核成功"
                    } else {
                        flash.message = "账户申请调账审核失败，错误号：${transResultFr.errorCode}，错误信息：${transResultFr.errorMsg}"
                    }
                }
            }
        }

        redirect(action: 'list')
    }

    def show = {
        def boAccountAdjustInfoInstance = BoAccountAdjustInfo.get(params.id)
        if (!boAccountAdjustInfoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAccountAdjustInfo.label', default: 'BoAccountAdjustInfo'), params.id])}"
            redirect(action: "list")
        }
        else {
            [boAccountAdjustInfoInstance: boAccountAdjustInfoInstance]
        }
    }

    def edit = {
        def boAccountAdjustInfoInstance = BoAccountAdjustInfo.get(params.id)
        if (!boAccountAdjustInfoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAccountAdjustInfo.label', default: 'BoAccountAdjustInfo'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [boAccountAdjustInfoInstance: boAccountAdjustInfoInstance]
        }
    }

    def update = {
        def boAccountAdjustInfoInstance = BoAccountAdjustInfo.get(params.id)
        if (boAccountAdjustInfoInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (boAccountAdjustInfoInstance.version > version) {
                    
                    boAccountAdjustInfoInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'boAccountAdjustInfo.label', default: 'BoAccountAdjustInfo')] as Object[], "Another user has updated this BoAccountAdjustInfo while you were editing")
                    render(view: "edit", model: [boAccountAdjustInfoInstance: boAccountAdjustInfoInstance])
                    return
                }
            }
            boAccountAdjustInfoInstance.properties = params
            if (!boAccountAdjustInfoInstance.hasErrors() && boAccountAdjustInfoInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'boAccountAdjustInfo.label', default: 'BoAccountAdjustInfo'), boAccountAdjustInfoInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [boAccountAdjustInfoInstance: boAccountAdjustInfoInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAccountAdjustInfo.label', default: 'BoAccountAdjustInfo'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def boAccountAdjustInfoInstance = BoAccountAdjustInfo.get(params.id)
        if (boAccountAdjustInfoInstance) {
            try {
                boAccountAdjustInfoInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'boAccountAdjustInfo.label', default: 'BoAccountAdjustInfo'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'boAccountAdjustInfo.label', default: 'BoAccountAdjustInfo'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'boAccountAdjustInfo.label', default: 'BoAccountAdjustInfo'), params.id])}"
            redirect(action: "list")
        }
    }
}
