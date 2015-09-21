package ismp

import groovyx.net.http.HTTPBuilder
import groovyx.net.http.EncoderRegistry
import groovyx.net.http.ContentType
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import ebank.tools.StringUtil
import groovyx.net.http.Method

class AcquireFaultTrxController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
//         AcquireFaultTrx.executeQuery()
        redirect(action: "list", params: params)
    }

    def list = {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.trxid != null && params.trxid != '') {
                like('trxid', '%' + params.trxid + '%')
            }
            if (params.finalSts != null && params.finalSts != '') {
                eq('finalSts', params.finalSts)
            }
            if (params.acquireCode != null && params.acquireCode != '') {
                like('acquireCode','%' +  params.acquireCode + '%')
            }
            if (params.startTrxamount != null && params.startTrxamount != '') {
                ge('trxamount', Integer.parseInt(StringUtil.parseAmountFromStr(params.startTrxamount).toString()))
            }
            if (params.endTrxamount != null && params.endTrxamount != '') {
                le('trxamount', Integer.parseInt(StringUtil.parseAmountFromStr(params.endTrxamount).toString()))
            }
            if (params.acquireMerchant != null && params.acquireMerchant != '') {
                like('acquireMerchant', '%' + params.acquireMerchant + '%')
            }
//            if (params.startTrxdate) {
//                ge('trxdate', params.startTrxdate)
//            }
//            if (params.endTrxdate) {
//                le('trxdate', params.endTrxdate+1)
//            }
            if (params.acquireSeq != null && params.acquireSeq != '') {
                like('acquireSeq', '%' + params.acquireSeq + '%')
            }
            if (params.acquireCardnum != null && params.acquireCardnum != '') {
                like('acquireCardnum', '%' + params.acquireCardnum + '%')
            }
//            if (params.startAcquireDate) {
//                ge('acquireDate',params.startAcquireDate)
//            }
//            if (params.endAcquireDate) {
//                le('acquireDate', params.endAcquireDate+1)
//            }
            if (params.changeApplier != null && params.changeApplier != '') {
                like('changeApplier', '%' + params.changeApplier + '%')
            }
            if (params.authOper != null && params.authOper != '') {
                like('authOper', '%' + params.authOper + '%')
            }
//            if (params.startCreateDate) {
//                ge('createDate', Date.parse("yyyy-MM-dd", params.startCreateDate))
//            }
//            if (params.endCreateDate) {
//                le('createDate', Date.parse("yyyy-MM-dd", params.endCreateDate)+1)
//            }

               //guonan update 2011-12-29
//            validTrxDated(params)
            if (params.startTrxdate) {
                ge('trxdate', params.startTrxdate?.replace('-',''))
            }
             if (params.endTrxdate) {
                 le('trxdate', params.endTrxdate?.replace('-',''))
             }

            //guonan update 2011-12-29
//            validAcquireDated(params)
            if (params.startAcquireDate) {
                ge('acquireDate', params.startAcquireDate?.replace('-',''))
            }
            if (params.endAcquireDate) {
                le('acquireDate', params.endAcquireDate?.replace('-',''))
            }
             //guonan update 2011-12-29
            validDated(params)
            if (params.startCreateDate) {
                ge('createDate', Date.parse('yyyy-MM-dd', params.startCreateDate))
            }
            if (params.endCreateDate) {
                lt('createDate', Date.parse('yyyy-MM-dd', params.endCreateDate) + 1)
            }

//            eq('authSts', 'N')
        }
        def total = AcquireFaultTrx.createCriteria().count(query)
        def results = AcquireFaultTrx.createCriteria().list(params, query)
        def summ = AcquireFaultTrx.createCriteria().get {
            and query
            projections {
                sum('trxamount')
            }
        }
        [acquireFaultTrxInstanceList: results, acquireFaultTrxInstanceTotal: total,totalTrx:summ]
    }

    def listDownload = {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max = 50000
        params.offset = 0
        def flag= params.flag
        def query = {
            if (params.trxid != null && params.trxid != '') {
                  like('trxid', '%' + params.trxid + '%')
            }
            if (params.finalSts != null && params.finalSts != '') {
                eq('finalSts', params.finalSts)
            }
            if (params.acquireCode != null && params.acquireCode != '') {
                like('acquireCode', '%' + params.acquireCode + '%')
            }
            if (params.startTrxamount != null && params.startTrxamount != '') {
                ge('trxamount', Integer.parseInt(StringUtil.parseAmountFromStr(params.startTrxamount).toString()))
            }
            if (params.endTrxamount != null && params.endTrxamount != '') {
                le('trxamount', Integer.parseInt(StringUtil.parseAmountFromStr(params.endTrxamount).toString()))
            }
//            if (params.startTrxdate) {
//                ge('trxdate',params.startTrxdate)
//            }
//            if (params.endTrxdate) {
//                le('trxdate',params.endTrxdate+1)
//            }
            if (params.acquireSeq != null && params.acquireSeq != '') {
                like('acquireSeq', '%' + params.acquireSeq + '%')
            }
            if (params.acquireCardnum != null && params.acquireCardnum != '') {
                 like('acquireCardnum', '%' + params.acquireCardnum + '%')
            }
//            if (params.startAcquireDate) {
//                ge('acquireDate',params.startAcquireDate)
//            }
//            if (params.endAcquireDate) {
//                le('acquireDate', params.endAcquireDate+1)
//            }
            if (params.changeApplier != null && params.changeApplier != '') {
                like('changeApplier', '%' + params.changeApplier + '%')
            }
            if (params.authOper != null && params.authOper != '') {
                like('authOper', '%' + params.authOper + '%')
            }
//            if (params.startCreateDate) {
//                ge('createDate', Date.parse("yyyy-MM-dd", params.startCreateDate))
//            }
//            if (params.endCreateDate) {
//                le('createDate', Date.parse("yyyy-MM-dd", params.endCreateDate)+1)
//            }



            //guonan update 2011-12-29
//            validTrxDated(params)
            if (params.startTrxdate) {
                ge('trxdate', params.startTrxdate?.replace('-',''))
            }
            if (params.endTrxdate) {
                le('trxdate', params.endTrxdate?.replace('-',''))
            }

            //guonan update 2011-12-29
//            validAcquireDated(params)
            if (params.startAcquireDate) {
                ge('acquireDate', params.startAcquireDate?.replace('-',''))
            }
             if (params.endAcquireDate) {
                le('acquireDate', params.endAcquireDate?.replace('-',''))
             }

             //guonan update 2011-12-29
            validDated(params)
            if (params.startCreateDate) {
                ge('createDate', Date.parse('yyyy-MM-dd', params.startCreateDate))
            }
            if (params.endCreateDate) {
                lt('createDate', Date.parse('yyyy-MM-dd', params.endCreateDate) + 1)
            }

            if("1".equals(flag)){
                eq('authSts', 'N')
            }
//            eq('authSts', 'N')
        }
        def total = AcquireFaultTrx.createCriteria().count(query)
        def results = AcquireFaultTrx.createCriteria().list(params, query)

        def summary = AcquireFaultTrx.createCriteria().get {
            and query
//            eq('tradeType', 'payment')
            projections {
                sum('trxamount')
                rowCount()
            }
        }

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [acquireFaultTrxInstanceList: results,flag:flag,totalAmount:summary[0],total:summary[1]])
    }

    def appList = {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.trxid != null && params.trxid != '') {
                like('trxid', '%' + params.trxid + '%')
            }
            if (params.finalSts != null && params.finalSts != '') {
                eq('finalSts', params.finalSts)
            }
            if (params.acquireCode != null && params.acquireCode != '') {
                like('acquireCode','%' +  params.acquireCode + '%')
            }
            if (params.startTrxamount != null && params.startTrxamount != '') {
                ge('trxamount', Integer.parseInt(StringUtil.parseAmountFromStr(params.startTrxamount).toString()))
            }
            if (params.endTrxamount != null && params.endTrxamount != '') {
                le('trxamount', Integer.parseInt(StringUtil.parseAmountFromStr(params.endTrxamount).toString()))
            }
            if (params.acquireMerchant != null && params.acquireMerchant != '') {
                like('acquireMerchant','%' +  params.acquireMerchant + '%')
            }
//            if (params.startTrxdate) {
//                ge('trxdate', params.startTrxdate)
//            }
//            if (params.endTrxdate) {
//                le('trxdate', params.endTrxdate)
//            }
            if (params.acquireSeq != null && params.acquireSeq != '') {
                like('acquireSeq','%' +  params.acquireSeq + '%')
            }
            if (params.acquireCardnum != null && params.acquireCardnum != '') {
                like('acquireCardnum','%' +  params.acquireCardnum + '%')
            }
//            if (params.startAcquireDate) {
//                ge('acquireDate', params.startAcquireDate)
//            }
//            if (params.endAcquireDate) {
//                le('acquireDate', params.endAcquireDate)
//            }
            if (params.changeApplier != null && params.changeApplier != '') {
                like('changeApplier','%' +  params.changeApplier + '%')
            }
            if (params.authOper != null && params.authOper != '') {
                 like('authOper','%' +  params.authOper + '%')
            }
//            if (params.startCreateDate) {
//                ge('createDate', Date.parse("yyyy-MM-dd", params.startCreateDate))
//            }
//            if (params.endCreateDate) {
//                le('createDate', Date.parse("yyyy-MM-dd", params.endCreateDate))
//            }

            //guonan update 2011-12-29
//            validTrxDated(params)
            if (params.startTrxdate) {
            ge('trxdate', params.startTrxdate?.replace('-',''))
            }
            if (params.endTrxdate) {
            le('trxdate', params.endTrxdate?.replace('-',''))
            }

            //guonan update 2011-12-29
//            validAcquireDated(params)
             if (params.startAcquireDate) {
            ge('acquireDate', params.startAcquireDate?.replace('-',''))
             }
            if (params.endAcquireDate) {
            le('acquireDate', params.endAcquireDate?.replace('-',''))
            }
             //guonan update 2011-12-29
            validDated(params)
       if (params.startCreateDate) {
            ge('createDate', Date.parse('yyyy-MM-dd', params.startCreateDate))
       }
       if (params.endCreateDate) {
            lt('createDate', Date.parse('yyyy-MM-dd', params.endCreateDate) + 1)
       }

            eq('authSts', 'N')
        }

        def summ = AcquireFaultTrx.createCriteria().get {
            and query
            projections {
                sum('trxamount')
            }
        }
        def total = AcquireFaultTrx.createCriteria().count(query)
        def results = AcquireFaultTrx.createCriteria().list(params, query)
        [acquireFaultTrxInstanceList: results, acquireFaultTrxInstanceTotal: total,totalTrx:summ]
    }

            /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan
     *
     */
    def validTrxDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startTrxdate==null && params.endTrxdate==null){
            def gCalendar= new GregorianCalendar()
            params.endTrxdate=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startTrxdate=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startTrxdate && !params.endTrxdate){
             params.endTrxdate=params.startTrxdate
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startTrxdate && params.endTrxdate){
             params.startTrxdate=params.endTrxdate
        }
        if (params.startTrxdate && params.endTrxdate) {


        }
    }
        /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan
     *
     */
    def validAcquireDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startAcquireDate==null && params.endAcquireDate==null){
            def gCalendar= new GregorianCalendar()
            params.endAcquireDate=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startAcquireDate=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startAcquireDate && !params.endAcquireDate){
             params.endAcquireDate=params.startAcquireDate
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startAcquireDate && params.endAcquireDate){
             params.startAcquireDate=params.endAcquireDate
        }
        if (params.startAcquireDate && params.endAcquireDate) {


        }
    }
     /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan
     *
     */
    def validDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startCreateDate==null && params.endCreateDate==null){
            def gCalendar= new GregorianCalendar()
            params.endCreateDate=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startCreateDate=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startCreateDate && !params.endCreateDate){
             params.endCreateDate=params.startCreateDate
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startCreateDate && params.endCreateDate){
             params.startCreateDate=params.endCreateDate
        }
        if (params.startCreateDate && params.endCreateDate) {


        }
    }

    //异常订单审核下载
    def appListDownload = {
        params.sort = params.sort ? params.sort : "createDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.trxid != null && params.trxid != '') {
                 like('trxid','%' +  params.trxid + '%')
            }
            if (params.finalSts != null && params.finalSts != '') {
                eq('finalSts', params.finalSts)
            }
            if (params.acquireCode != null && params.acquireCode != '') {
                 like('acquireCode','%' +  params.acquireCode + '%')
            }
            if (params.startTrxamount != null && params.startTrxamount != '') {
                ge('trxamount', Integer.parseInt(StringUtil.parseAmountFromStr(params.startTrxamount).toString()))
            }
            if (params.endTrxamount != null && params.endTrxamount != '') {
                le('trxamount', Integer.parseInt(StringUtil.parseAmountFromStr(params.endTrxamount).toString()))
            }
            if (params.acquireMerchant != null && params.acquireMerchant != '') {
                like('acquireMerchant','%' +  params.acquireMerchant + '%')
            }
//            if (params.startTrxdate) {
//                ge('trxdate', params.startTrxdate)
//            }
//            if (params.endTrxdate) {
//                le('trxdate', params.endTrxdate)
//            }
            if (params.acquireSeq != null && params.acquireSeq != '') {
                like('acquireSeq','%' +  params.acquireSeq + '%')
            }
            if (params.acquireCardnum != null && params.acquireCardnum != '') {
                like('acquireCardnum','%' +  params.acquireCardnum + '%')
            }
//            if (params.startAcquireDate) {
//                ge('acquireDate', params.startAcquireDate)
//            }
//            if (params.endAcquireDate) {
//                le('acquireDate', params.endAcquireDate)
//            }
            if (params.changeApplier != null && params.changeApplier != '') {
                like('changeApplier','%' +  params.changeApplier + '%')
            }
            if (params.authOper != null && params.authOper != '') {
                like('authOper','%' +  params.authOper + '%')
            }
//            if (params.startCreateDate) {
//                ge('createDate', Date.parse("yyyy-MM-dd", params.startCreateDate))
//            }
//            if (params.endCreateDate) {
//                le('createDate', Date.parse("yyyy-MM-dd", params.endCreateDate))
//            }

                        //guonan update 2011-12-29
//            validTrxDated(params)
            if (params.startTrxdate) {
                ge('trxdate', params.startTrxdate?.replace('-',''))
            }
            if (params.endTrxdate) {
                le('trxdate', params.endTrxdate?.replace('-',''))
            }

            //guonan update 2011-12-29
//            validAcquireDated(params)
            if (params.startAcquireDate) {
                ge('acquireDate', params.startAcquireDate?.replace('-',''))
            }
             if (params.endAcquireDate) {
                le('acquireDate', params.endAcquireDate?.replace('-',''))
             }

             //guonan update 2011-12-29
            validDated(params)
            if (params.startCreateDate) {
                ge('createDate', Date.parse('yyyy-MM-dd', params.startCreateDate))
            }
            if (params.endCreateDate) {
                lt('createDate', Date.parse('yyyy-MM-dd', params.endCreateDate) + 1)
            }

            eq('authSts', 'N')
        }
        def total = AcquireFaultTrx.createCriteria().count(query)
        def results = AcquireFaultTrx.createCriteria().list(params, query)
        [acquireFaultTrxInstanceList: results, acquireFaultTrxInstanceTotal: total]
    }
    //审批通过
    def appPass = {
        def acquireFaultTrxInstance = AcquireFaultTrx.get(params.id)
        if (!acquireFaultTrxInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx'), params.id])}"
        } else if (acquireFaultTrxInstance.authSts == 'Y') {
            flash.message = "异常订单(${acquireFaultTrxInstance.id})状态已经是审核通过！"
        } else {
            def args = [id: acquireFaultTrxInstance.id, authSts: 'Y',
                    faultAdvice: '同意', authOper: session.op?.name]
            def result = invokeGwInnerApi('/ISMSApp/postFaultTrx/authorize', args)
            if (result instanceof Map) {
                flash.message = "异常订单(${acquireFaultTrxInstance.id})更改审核状态. ${result.resmg}"
            } else {
                flash.message = "异常订单(${acquireFaultTrxInstance.id})更改审核状态. ${result}"
            }
        }
        redirect(action: "appList")
    }

    //审批通过
    def appUnpass = {
        def acquireFaultTrxInstance = AcquireFaultTrx.get(params.id)
        if (!acquireFaultTrxInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx'), params.id])}"
        } else if (acquireFaultTrxInstance.authSts == 'F') {
            flash.message = "异常订单(${acquireFaultTrxInstance.id})状态已经是审核未通过！"
        } else {
            def args = [id: acquireFaultTrxInstance.id, authSts: 'F',
                    faultAdvice: '拒绝', authOper: session.op?.name]
            def result = invokeGwInnerApi('/ISMSApp/postFaultTrx/authorize', args)
            if (result instanceof Map) {
                flash.message = "异常订单(${acquireFaultTrxInstance.id})更改审核状态. ${result.resmg}"
            } else {
                flash.message = "异常订单(${acquireFaultTrxInstance.id})更改审核状态. ${result}"
            }
        }
        redirect(action: "appList")
    }


    def create = {
        def acquireFaultTrxInstance = new AcquireFaultTrx()
        acquireFaultTrxInstance.properties = params
        return [acquireFaultTrxInstance: acquireFaultTrxInstance]
    }

    def save = {
        def acquireFaultTrxInstance = new AcquireFaultTrx(params)
        if (acquireFaultTrxInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx'), acquireFaultTrxInstance.id])}"
            redirect(action: "list", id: acquireFaultTrxInstance.id)
        }
        else {
            render(view: "create", model: [acquireFaultTrxInstance: acquireFaultTrxInstance])
        }
    }

    def show = {
        def acquireFaultTrxInstance = AcquireFaultTrx.get(params.id)
        if (!acquireFaultTrxInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx'), params.id])}"
            redirect(action: "list")
        }
        else {
            [acquireFaultTrxInstance: acquireFaultTrxInstance]
        }
    }

    def edit = {
        def acquireFaultTrxInstance = AcquireFaultTrx.get(params.id)
        if (!acquireFaultTrxInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [acquireFaultTrxInstance: acquireFaultTrxInstance]
        }
    }

    def update = {
        def acquireFaultTrxInstance = AcquireFaultTrx.get(params.id)
        if (acquireFaultTrxInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (acquireFaultTrxInstance.version > version) {

                    acquireFaultTrxInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx')] as Object[], "Another user has updated this AcquireFaultTrx while you were editing")
                    render(view: "edit", model: [acquireFaultTrxInstance: acquireFaultTrxInstance])
                    return
                }
            }
            acquireFaultTrxInstance.properties = params
            if (!acquireFaultTrxInstance.hasErrors() && acquireFaultTrxInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx'), acquireFaultTrxInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [acquireFaultTrxInstance: acquireFaultTrxInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def acquireFaultTrxInstance = AcquireFaultTrx.get(params.id)
        if (acquireFaultTrxInstance) {
            try {
                acquireFaultTrxInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx'), params.id])}"
            redirect(action: "list")
        }
    }

    private invokeGwInnerApi(String _uri, Map _args) {
        log.info "invoke Gateway inner api: $_uri \n args: $_args"
        def result = ''
        try {
            def http = new HTTPBuilder(ConfigurationHolder.config.gateway.inner.server)
            http.request(Method.POST, ContentType.JSON) { req ->
                uri.path = _uri
                send ContentType.URLENC, _args

                response.success = { resp, json ->
                    log.debug "response status: ${resp.statusLine}"
                    result = json
                }
            }
        } catch (e) {
            log.error e, e
            result = e.getMessage()
        }
        log.info "resp: $result"
        result
    }
}
