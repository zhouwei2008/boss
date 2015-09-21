package ismp

import ebank.tools.StringUtil
import boss.AppNote

import boss.BoInnerAccount
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import groovyx.net.http.HTTPBuilder
import groovyx.net.http.Method
import groovyx.net.http.ContentType
import boss.BoBankDic
import boss.BoAcquirerAccount
import grails.converters.JSON
import boss.BoMerchant
import boss.BoChannelRate
import groovy.sql.Sql

import jxl.write.*
import jxl.*
import jxl.format.UnderlineStyle

import java.text.SimpleDateFormat
import gateway.GwTransaction



class TradeRefundController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def tradeService
    def jmsService
    def settleClientService
    def accountClientService
    def dataSource_ismp
    def alipayService

    def index = {
        redirect(action: "list", params: params)
    }

    def unCheckList = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', '%' + params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', '%' + params.payerAccountNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
//            if (params.startDateCreated != null && params.startDateCreated != '') {
//                ge('dateCreated', Date.parse("yyyy-MM-dd", params.startDateCreated))
//            }
//            if (params.endDateCreated != null && params.endDateCreated != '') {
//                le('dateCreated', Date.parse("yyyy-MM-dd", params.endDateCreated) + 1)
//            }
            //guonan update 2011-12-29
            validDated(params)
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
            if (params.bankNo != null && params.bankNo != '') {
                def tradeBase = TradeBase.findByOutTradeNoAndTradeType(params.bankNo, 'charge')
                eq('rootId', tradeBase?.rootId)
            }
            if (params.outTradeNo != null && params.outTradeNo != '') {
                like('outTradeNo', '%' + params.outTradeNo + '%')
            }
            if (params.bankName != null && params.bankName != '') {
                def bo = BoAcquirerAccount.findAllByBank(BoBankDic.findByName(params.bankName))
                def boAcquirerAccount = BoMerchant.findAllByAcquirerAccountInList(bo).acquireMerchant
                'in'('acquirerMerchantNo', boAcquirerAccount)
            }
            if (params.channel != null && params.channel != '') {
                like('channel', '%' + params.channel + '%')
            }
            //B2B线下退款
            if (params.refundBankType != null && params.refundBankType != '') {
                eq('refundBankType', params.refundBankType)
            }
            eq('handleStatus', 'waiting')
            //非账户余额支付用到。
            eq('status', 'processing')
        }
        def total = TradeRefund.createCriteria().count(query)
        def results = TradeRefund.createCriteria().list(params, query)
        def refundAmount = TradeRefund.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def results2 = TradeRefund.createCriteria().list {
            and query
        }
        def totalAmount = 0
        for (def r in results2) {
            if (r.partnerId == null) {
                def tradeBase = TradeBase.findByRootIdAndTradeType(r.rootId, 'charge')
                if (tradeBase != null) {
                    if (tradeBase.amount > 0) {
                        totalAmount = totalAmount + tradeBase.amount
                    }
                }
            }
            if (r.partnerId != null) {
                def tp = TradePayment.get(r.originalId)
                if (tp != null) {
                    if (tp.amount > 0) {
                        totalAmount = totalAmount + tp.amount
                    }
                }
            }
        }
        [tradeRefundInstanceList: results, tradeRefundInstanceTotal: total, refundAmount: refundAmount, totalAmount: totalAmount]
    }

    def unRefuseList = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', '%' + params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', '%' + params.payerAccountNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
//            if (params.startDateCreated != null && params.startDateCreated != '') {
//                ge('dateCreated', Date.parse("yyyy-MM-dd", params.startDateCreated))
//            }
//            if (params.endDateCreated != null && params.endDateCreated != '') {
//                le('dateCreated', Date.parse("yyyy-MM-dd", params.endDateCreated) + 1)
//            }
            //guonan update 2011-12-29
            validDated(params)
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }

            if (params.bankNo != null && params.bankNo != '') {
                def tradeBase = TradeBase.findByOutTradeNoAndTradeType(params.bankNo, 'charge')
                eq('rootId', tradeBase?.rootId)
            }
            if (params.outTradeNo != null && params.outTradeNo != '') {
                like('outTradeNo', '%' + params.outTradeNo + '%')
            }
            if (params.bankName != null && params.bankName != '') {
                def boAcquirerAccount = boss.BoAcquirerAccount.findByBank(BoBankDic.findByName(params.bankName)).id
                eq('acquirer_account_id', boAcquirerAccount)
            }
            if (params.channel != null && params.channel != '') {
                like('channel', '%' + params.channel + '%')
            }
            isNull('refundBatchNo')
            'in'('handleStatus', ['fChecked'])
        }
        def total = TradeRefund.createCriteria().count(query)
        def results = TradeRefund.createCriteria().list(params, query)
        def refundAmount = TradeRefund.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def results2 = TradeRefund.createCriteria().list {
            and query
        }
        def totalAmount = 0
        for (def r in results2) {
            if (r.partnerId == null) {
                def tradeBase = TradeBase.findByRootIdAndTradeType(r.rootId, 'charge')
                if (tradeBase != null) {
                    if (tradeBase.amount > 0) {
                        totalAmount = totalAmount + tradeBase.amount
                    }
                }
            }
            if (r.partnerId != null) {
                def tp = TradePayment.get(r.originalId)
                if (tp != null) {
                    if (tp.amount > 0) {
                        totalAmount = totalAmount + tp.amount
                    }
                }
            }
        }
        [tradeRefundInstanceList: results, tradeRefundInstanceTotal: total, refundAmount: refundAmount, totalAmount: totalAmount]
    }

    def checkList = {
        params.sort = params.sort ? params.sort : "lastAppDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.refundBatchNo != null && params.refundBatchNo != '') {
                like('refundBatchNo', params.refundBatchNo + '%')
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', '%' + params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', params.payerAccountNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
//            if (params.startDateCreated != null && params.startDateCreated != '') {
//                ge('dateCreated', Date.parse("yyyy-MM-dd", params.startDateCreated))
//            }
//            if (params.endDateCreated != null && params.endDateCreated != '') {
//                le('dateCreated', Date.parse("yyyy-MM-dd", params.endDateCreated) + 1)
//            }
            //guonan update 2011-12-29
            validDated(params)
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }

            if (params.bankNo != null && params.bankNo != '') {
                def tradeBase = TradeBase.findByOutTradeNoAndTradeType(params.bankNo, 'charge')
                eq('rootId', tradeBase?.rootId)
            }
            if (params.outTradeNo != null && params.outTradeNo != '') {
                like('outTradeNo', '%' + params.outTradeNo + '%')
            }
            if (params.bankName != null && params.bankName != '') {
                def boAcquirerAccount = boss.BoAcquirerAccount.findByBank(BoBankDic.findByName(params.bankName)).id
                eq('acquirer_account_id', boAcquirerAccount)
            }
            if (params.channel != null && params.channel != '') {
                eq('channel', params.channel)
            }
            if (params.refundBatchNo != null && params.refundBatchNo != '') {
                like('refundBatchNo', params.refundBatchNo + '%')
            }
            eq('handleStatus', 'checked')
        }
        def total = TradeRefund.createCriteria().count(query)
        def results = TradeRefund.createCriteria().list(params, query)
        def refundAmount = TradeRefund.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def results2 = TradeRefund.createCriteria().list {
            and query
        }
        def totalAmount = 0
        for (def r in results2) {
            if (r.partnerId == null) {
                def tradeBase = TradeBase.findByRootIdAndTradeType(r.rootId, 'charge')
                if (tradeBase != null) {
                    if (tradeBase.amount > 0) {
                        totalAmount = totalAmount + tradeBase.amount
                    }
                }
            }
            if (r.partnerId != null) {
                def tp = TradePayment.get(r.originalId)
                if (tp != null) {
                    if (tp.amount > 0) {
                        totalAmount = totalAmount + tp.amount
                    }
                }
            }
        }
        [tradeRefundInstanceList: results, tradeRefundInstanceTotal: total, refundAmount: refundAmount, totalAmount: totalAmount]
    }

    def reCheckList = {
        params.sort = params.sort ? params.sort : "refundHandleDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', params.tradeNo + '%')
            }
            if (params.refundBatchNo != null && params.refundBatchNo != '') {
                like('refundBatchNo', params.refundBatchNo + '%')
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', params.payerAccountNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
            //guonan update 2011-12-29
            validDated(params)
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }

            if (params.bankNo != null && params.bankNo != '') {
                def tradeBase = TradeBase.findByOutTradeNoAndTradeType(params.bankNo, 'charge')
                eq('rootId', tradeBase?.rootId)
            }
            if (params.outTradeNo != null && params.outTradeNo != '') {
                eq('outTradeNo', params.outTradeNo)
            }
            if (params.bankName != null && params.bankName != '') {
                def boAcquirerAccount = boss.BoAcquirerAccount.findByBank(BoBankDic.findByName(params.bankName)).id
                eq('acquirer_account_id', boAcquirerAccount)
            }
            if (params.channel != null && params.channel != '') {
                like('channel', '%' + params.channel + '%')
            }
            if (params.refundBatchNo != null && params.refundBatchNo != '') {
                like('refundBatchNo', params.refundBatchNo + '%')
            }
            'in'('handleStatus', ['success', 'fail'])
        }
        def total = TradeRefund.createCriteria().count(query)
        def results = TradeRefund.createCriteria().list(params, query)
        def refundAmount = TradeRefund.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def results2 = TradeRefund.createCriteria().list {
            and query
        }
        def totalAmount = 0
        for (def r in results2) {
            if (r.partnerId == null) {
                def tradeBase = TradeBase.findByRootIdAndTradeType(r.rootId, 'charge')
                if (tradeBase != null) {
                    if (tradeBase.amount > 0) {
                        totalAmount = totalAmount + tradeBase.amount
                    }
                }
            }
            if (r.partnerId != null) {
                def tp = TradePayment.get(r.originalId)
                if (tp != null) {
                    if (tp.amount > 0) {
                        totalAmount = totalAmount + tp.amount
                    }
                }
            }
        }
        [tradeRefundInstanceList: results, tradeRefundInstanceTotal: total, refundAmount: refundAmount, totalAmount: totalAmount]
    }

    def checkShow = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def sign = params.sign ? params.sign : '0'
        def query = {
            eq('refundBatchNo', params.id)
        }
        def total = TradeRefund.createCriteria().count(query)
        def results = TradeRefund.createCriteria().list(params, query)
        def refundAmount = TradeRefund.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        [tradeRefundInstanceList: results, tradeRefundInstanceTotal: total, refundAmount: refundAmount, sign: sign]
    }
    def checkBatchShow = {
        def tradeRefundBatch = TradeRefundBatch.get(params.id)
        [tradeRefundBatch: tradeRefundBatch]
    }

    def completeList = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', '%' + params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', '%' + params.payerAccountNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
//            if (params.startDateCreated != null && params.startDateCreated != '') {
//                ge('dateCreated', Date.parse("yyyy-MM-dd", params.startDateCreated))
//            }
//            if (params.endDateCreated != null && params.endDateCreated != '') {
//                le('dateCreated', Date.parse("yyyy-MM-dd", params.endDateCreated) + 1)
//            }

            //guonan update 2011-12-29
            validDated(params)
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }

            if (params.handleStatus != null && params.handleStatus != '') {
                eq('handleStatus', params.handleStatus)
            }
            or {
                eq('handleStatus', 'fRefuse')
                eq('handleStatus', 'sRefuse')
                eq('handleStatus', 'completed')
            }
        }
        def total = TradeRefund.createCriteria().count(query)
        def results = TradeRefund.createCriteria().list(params, query)
        def refundAmount = TradeRefund.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def results2 = TradeRefund.createCriteria().list {
            and query
        }
        def totalAmount = 0
        for (def r in results2) {
            if (r.partnerId == null) {
                def tradeBase = TradeBase.findByRootIdAndTradeType(r.rootId, 'charge')
                if (tradeBase != null) {
                    if (tradeBase.amount > 0) {
                        totalAmount = totalAmount + tradeBase.amount
                    }
                }
            }
            if (r.partnerId != null) {
                def tp = TradePayment.get(r.originalId)
                if (tp != null) {
                    if (tp.amount > 0) {
                        totalAmount = totalAmount + tp.amount
                    }
                }
            }
        }
        [tradeRefundInstanceList: results, tradeRefundInstanceTotal: total, totalAmount: totalAmount, refundAmount: refundAmount]
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
        if (params.startDateCreated == null && params.endDateCreated == null) {
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

    def validCheckDate(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startDateCheck == null && params.endDateCheck == null) {
            def gCalendar = new GregorianCalendar()
            params.endDateCheck = gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH, -1)
            params.startDateCheck = gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startDateCheck && !params.endDateCheck) {
            params.endDateCheck = params.startDateCheck
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startDateCheck && params.endDateCheck) {
            params.startDateCheck = params.endDateCheck
        }
    }

    def historyList = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            if (params.refundBatchNo != null && params.refundBatchNo != '') {
                like('refundBatchNo', '%' + params.refundBatchNo + '%')
            }
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', '%' + params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', '%' + params.payerAccountNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
            if (params.channel != null && params.channel != '') {
                like('channel', '%' + params.channel + '%')
            }
            if (params.handleStatus != null && params.handleStatus != '') {
                eq('handleStatus', params.handleStatus)
            }
            //终审时间
            if (params.handleStatus == null || params.handleStatus == "" || params.handleStatus == 'fChecked') {
                if (params.startDateCheck != null && params.startDateCheck != '') {
                    ge('dateCreated', Date.parse("yyyy-MM-dd", params.startDateCheck))
                }
                if (params.endDateCheck != null && params.endDateCheck != '') {
                    le('lastAppDate', Date.parse("yyyy-MM-dd", params.endDateCheck) + 1)
                }
            } else {
                validCheckDate(params)
                if (params.startDateCheck != null && params.startDateCheck != '') {
                    ge('lastAppDate', Date.parse('yyyy-MM-dd', params.startDateCheck))
                }
                if (params.startDateCheck != null && params.startDateCheck != '') {
                    lt('lastAppDate', Date.parse('yyyy-MM-dd', params.endDateCheck) + 1)
                }
            }

            //guonan update 2011-12-29
            validDated(params)
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
            if (params.bankNo != null && params.bankNo != '') {
                def tradeBase = TradeBase.findByOutTradeNoAndTradeType(params.bankNo, 'charge')
                eq('rootId', tradeBase?.rootId)
            }
            if (params.bankName != null && params.bankName != '') {
                def boAcquirerAccount = boss.BoAcquirerAccount.findByBank(BoBankDic.findById(params.bankName.trim()))
                if (boAcquirerAccount) {
                    def acquirerAccount = boAcquirerAccount.id
                    eq('acquirer_account_id', acquirerAccount)
                } else {
                    isNull('acquirer_account_id')
                }
            }
            ne('handleStatus', 'waiting')
            ne('handleStatus', 'submited')
        }
        def total = TradeRefund.createCriteria().count(query)
        def results = TradeRefund.createCriteria().list(params, query)
        def refundAmount = TradeRefund.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def results2 = TradeRefund.createCriteria().list {
            and query
        }
        def totalAmount = 0
        for (def r in results2) {
            if (r.partnerId == null) {
                def tradeBase = TradeBase.findByRootIdAndTradeType(r.rootId, 'charge')
                if (tradeBase != null) {
                    if (tradeBase.amount > 0) {
                        totalAmount = totalAmount + tradeBase.amount
                    }
                }
            }
            if (r.partnerId != null) {
                def tp = TradePayment.get(r.originalId)
                if (tp != null) {
                    if (tp.amount > 0) {
                        totalAmount = totalAmount + tp.amount
                    }
                }
            }
        }
        [tradeRefundInstanceList: results, tradeRefundInstanceTotal: total, totalAmount: totalAmount, refundAmount: refundAmount]
    }

    def historyDownload = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = 50000
        params.offset = 0
        def query = {
            if (params.refundBatchNo != null && params.refundBatchNo != '') {
                like('refundBatchNo', params.refundBatchNo + '%')
            }
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', '%' + params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', params.payerAccountNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
            if (params.channel != null && params.channel != '') {
                like('channel', '%' + params.channel + '%')
            }
            if (params.handleStatus != null && params.handleStatus != '') {
                eq('handleStatus', params.handleStatus)
            }
            //终审时间
            if (params.handleStatus == null || params.handleStatus == "" || params.handleStatus == 'fChecked') {
                if (params.startDateCheck != null && params.startDateCheck != '') {
                    ge('dateCreated', Date.parse("yyyy-MM-dd", params.startDateCheck))
                }
                if (params.endDateCheck != null && params.endDateCheck != '') {
                    le('lastAppDate', Date.parse("yyyy-MM-dd", params.endDateCheck) + 1)
                }
            } else {
                validCheckDate(params)
                ge('lastAppDate', Date.parse('yyyy-MM-dd', params.startDateCheck))
                lt('lastAppDate', Date.parse('yyyy-MM-dd', params.endDateCheck) + 1)
            }

            //guonan update 2011-12-29
            validDated(params)
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }
            if (params.bankNo != null && params.bankNo != '') {
                def tradeBase = TradeBase.findByOutTradeNoAndTradeType(params.bankNo, 'charge')
                eq('rootId', tradeBase?.rootId)
            }
            if (params.bankName != null && params.bankName != '') {
                def boAcquirerAccount = boss.BoAcquirerAccount.findByBank(BoBankDic.findById(params.bankName.trim()))
                if (boAcquirerAccount) {
                    def acquirerAccount = boAcquirerAccount.id
                    println acquirerAccount
                    println "111111"
                    eq('acquirer_account_id', acquirerAccount)
                } else {
                    isNull('acquirer_account_id')
                }
            }


            ne('handleStatus', 'waiting')
            ne('handleStatus', 'submited')
//            or {
//                eq('handleStatus', 'fRefuse')
//                eq('handleStatus', 'sRefuse')
//                eq('handleStatus', 'completed')
//            }
        }
        def results = TradeRefund.createCriteria().list(params, query)
        def total = TradeRefund.createCriteria().count(query)
        def refundAmount = TradeRefund.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "refundHisList", model: [tradeRefundInstanceList: results, refundAmount: refundAmount, total: total])
    }

    def historyShow = {
        def tradeRefundInstance = TradeRefund.get(params.id)
        if (!tradeRefundInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeRefund.label', default: 'TradeRefund'), params.id])}"
            redirect(action: "list")
        }
        else {
            [tradeRefundInstance: tradeRefundInstance]
        }
    }
    def listDownload = {
        def flag = params.flag
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = 50000
        params.offset = 0
        def query = {
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', '%' + params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', '%' + params.payerAccountNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
//            if (params.startDateCreated != null && params.startDateCreated != '') {
//                ge('dateCreated', Date.parse("yyyy-MM-dd", params.startDateCreated))
//            }
//            if (params.endDateCreated != null && params.endDateCreated != '') {
//                le('dateCreated', Date.parse("yyyy-MM-dd", params.endDateCreated) + 1)
//            }
            //guonan update 2011-12-29
            validDated(params)
            if (flag != '2') {
                if (params.startDateCreated) {
                    ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
                }
                if (params.endDateCreated) {
                    lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
                }
            }

            if (params.bankNo != null && params.bankNo != '') {
                def tradeBase = TradeBase.findByOutTradeNoAndTradeType(params.bankNo, 'charge')
                eq('rootId', tradeBase?.rootId)
            }
            if (params.outTradeNo != null && params.outTradeNo != '') {
                like('outTradeNo', '%' + params.outTradeNo + '%')
            }
            //B2B线下退款
            if (params.refundBankType != null && params.refundBankType != '') {
                eq('refundBankType', params.refundBankType)
            }
            if (params.bankName != null && params.bankName != '') {
                if ('0'.equals(flag)) {
                    def bo = BoAcquirerAccount.findAllByBank(BoBankDic.findByName(params.bankName))
                    def boAcquirerAccount = BoMerchant.findAllByAcquirerAccountInList(bo).acquireMerchant
                    'in'('acquirerMerchantNo', boAcquirerAccount)
                } else {
                    def boAcquirerAccount = boss.BoAcquirerAccount.findByBank(BoBankDic.findByName(params.bankName)).id
                    eq('acquirer_account_id', boAcquirerAccount)
                }
            }
            if (params.channel != null && params.channel != '') {
                like('channel', '%' + params.channel + '%')
            }
            //单笔退款审批
            if ("1".equals(flag)) {
                isNull('refundBatchNo')
                eq('handleStatus', 'fChecked')
            }
            //批量退款审批
            if ("2".equals(flag)) {
                eq('refundBatchNo', params.refundBatchNo)
                eq('handleStatus', 'fChecked')
            }
            //退款处理
            if ("3".equals(flag)) {
                eq('handleStatus', 'checked')
            }
            //退款复核
            if ("4".equals(flag)) {
                'in'('handleStatus', ['success', 'fail'])
            }
            if ("5".equals(flag)) {
                if (params.handleStatus != null && params.handleStatus != '') {
                    eq('handleStatus', params.handleStatus)
                } else {
                    or {
                        eq('handleStatus', 'fRefuse')
                        eq('handleStatus', 'sRefuse')
                        eq('handleStatus', 'completed')
                    }
                }
            } else if ("0".equals(flag)) {
                'in'('handleStatus', ['waiting'])
                eq('status', 'processing')
            }
        }
        def results = TradeRefund.createCriteria().list(params, query)
        def total = TradeRefund.createCriteria().count(query)
        def refundAmount = TradeRefund.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }
        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [tradeRefundInstanceList: results, refundAmount: refundAmount, total: total, flag: flag])
    }

    def show = {
        def tradeRefundInstance = TradeRefund.get(params.id)
        if (!tradeRefundInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeRefund.label', default: 'TradeRefund'), params.id])}"
            redirect(action: "list")
        }
       else{
                  //退款手续费
                  if(tradeRefundInstance?.realityRefundAmount==null&&tradeRefundInstance?.channel=="3"){
                        if(tradeRefundInstance?.acquirerMerchantNo!=null){
                         //订单金额
                           def  originalAmount
                           if(tradeRefundInstance.tradeType=='refund'){
                               originalAmount= TradeBase.get(tradeRefundInstance.originalId)?.amount
                          }
                           if(tradeRefundInstance.tradeType=='royalty_ref'){
                             originalAmount= TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment')?.amount
                           }

                           def sql="select * from gwtrxs t where t.trxnum='${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId, 'charge')?.outTradeNo}'";
                           def sqly = new Sql(dataSource_ismp)
                           Map map = sqly.firstRow(sql)
                            //实际手续费
                           def sxAmount=map.get("AMOUNT")-originalAmount
                            //实际收款金额
                           def sjAmount=map.get("AMOUNT")
                        //实际退款金额
                         def realityRefundAmount=0;
                        def boMerchantInstance=BoMerchant.findByAcquireMerchant(tradeRefundInstance.acquirerMerchantNo);
                         //获取费率对象
                         List boChannelRateInstanceList= BoChannelRate.findAllByMerchantId(boMerchantInstance.id);
                          BoChannelRate boChannelRateInstance
                          if(boChannelRateInstanceList.size()==0){
                              boChannelRateInstance==null
                          } else{
                               boChannelRateInstance=boChannelRateInstanceList?.get(0);
                          }
                            if(boChannelRateInstanceList.size()==2){
                                 if(boChannelRateInstance.getIsCurrent()==false){
                                 boChannelRateInstance= boChannelRateInstanceList.get(1);
                            }
                            }

                         if(boChannelRateInstance==null){
                                realityRefundAmount=tradeRefundInstance.amount
                          }else{
                         //退款按笔收费
                         if(boChannelRateInstance?.feeType.equals("0")&&boChannelRateInstance?.isCurrent==true){
                            if(boChannelRateInstance?.isRefundFee.equals("0")){
                            realityRefundAmount=tradeRefundInstance.amount
                          }
                           if(boChannelRateInstance?.isRefundFee.equals("1")){
                             def list= TradeRefund.findAllByRootId(tradeRefundInstance.rootId)
                              Long refundedAmount=0
                               tradeRefundInstance.refundedAmount =tradeRefundInstance.amount
                               for(int i=0;i<list.size();i++){
                                   TradeRefund tradeRefund =list.get(i);
                                    if(tradeRefund.getRefundedAmount()!=null){
                                         refundedAmount+=tradeRefund.getRefundedAmount()
                                   }
                               }
                                if(refundedAmount.equals(originalAmount)){
                                  realityRefundAmount=tradeRefundInstance.amount+sxAmount
                                }else{
                                     realityRefundAmount=tradeRefundInstance.amount
                               }
                          }
                         }
                             if(boChannelRateInstance?.feeType.equals("0")&&boChannelRateInstance?.isCurrent==false){
                                        realityRefundAmount=tradeRefundInstance.amount
                                        tradeRefundInstance.refundedAmount=tradeRefundInstance.amount
                             }
                              if(boChannelRateInstance?.feeType.equals("1")&&boChannelRateInstance?.isCurrent==false){
                                       realityRefundAmount=tradeRefundInstance.amount
                                   tradeRefundInstance.refundedAmount=tradeRefundInstance.amount
                              }
                         //退款按比率收费
                         if(boChannelRateInstance?.feeType.equals("1")&&boChannelRateInstance?.isCurrent==true){
                          if(boChannelRateInstance?.isRefundFee.equals("0")){
                            realityRefundAmount=tradeRefundInstance.amount
                          }
                           if(boChannelRateInstance?.isRefundFee.equals("1")){
                                 def list= TradeRefund.findAllByRootId(tradeRefundInstance.rootId)
                               Long refundedAmount=0
                             tradeRefundInstance.refundedAmount =tradeRefundInstance.amount
                               for(int i=0;i<list.size();i++){
                                   TradeRefund tradeRefund =list.get(i);
                                   if(tradeRefund.getRefundedAmount()!=null){
                                         refundedAmount+=tradeRefund.getRefundedAmount()
                                   }
                               }
                             if(refundedAmount.equals(originalAmount)){
                                  realityRefundAmount=tradeRefundInstance.amount+sxAmount
                             }else{
                                    realityRefundAmount=tradeRefundInstance.amount
                                }
                         }
                          if(boChannelRateInstance?.isRefundFee.equals("2")){
                              realityRefundAmount=tradeRefundInstance.amount+ tradeRefundInstance.amount*sxAmount/originalAmount
                          }
                        }
                          }
                            if(boChannelRateInstance?.isCurrent==true){
                               tradeRefundInstance.realityRefundAmount=realityRefundAmount
                            }else{
                                tradeRefundInstance.realityRefundAmount=tradeRefundInstance.amount
                            }

                            } else{
                                  tradeRefundInstance.realityRefundAmount=0
                            }
                              }
                     if(tradeRefundInstance?.realityRefundAmount==null&&tradeRefundInstance?.channel!="3"){
                               tradeRefundInstance.realityRefundAmount=tradeRefundInstance.amount
                       }
             tradeRefundInstance.refundedAmount =tradeRefundInstance.amount
            [tradeRefundInstance: tradeRefundInstance]
        }
    }

    def unRefuseShow = {
        def tradeRefundInstance = TradeRefund.get(params.id)
        def sign = params.sign ? params.sign : '0'
        if (!tradeRefundInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeRefund.label', default: 'TradeRefund'), params.id])}"
            redirect(action: "list")
        }
        else {
            [tradeRefundInstance: tradeRefundInstance, sign: sign]
        }
    }

    def completeShow = {
        def tradeRefundInstance = TradeRefund.get(params.id)
        if (!tradeRefundInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeRefund.label', default: 'TradeRefund'), params.id])}"
            redirect(action: "list")
        }
        else {
            [tradeRefundInstance: tradeRefundInstance]
        }
    }

    //审核通过
    def check = {
        def flag
        def sign
        def label
        def royalty = ''
        def tradeRefundInstance = TradeRefund.get(params.id)
        def tradeRefund = new TradeRefund()

        if (tradeRefundInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (tradeRefundInstance.version > version) {

                    tradeRefundInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'tradeRefund.label', default: 'tradeRefund')] as Object[], "Another user has updated this TradeWithdrawn while you were editing")
                    render(view: "show", model: [tradeRefundInstance: tradeRefundInstance])
                    return
                }
            }
            tradeRefundInstance.properties = params
            def errorMsg
            if (tradeRefundInstance.acquirer_account_id == null) {
                errorMsg = "收单银行账户不能为空"
            }
            if (errorMsg != null) {
                flash.message = errorMsg
                render(view: "show", model: [tradeRefundInstance: tradeRefundInstance])
                return
            }
            if (!tradeRefundInstance.hasErrors()) {
                if (tradeRefundInstance.acquirerCode == 'FXPPAYCARD') {
                    def args = [id: tradeRefundInstance.id]
                    def result = invokeGwInnerApi('/ISMSApp/refund/aotoApp', args)

                    if (!result) {
                        flash.message = 'SYSTEM_BUSY'
                    } else if (((Reference) result).getProperty("resmsg") != '00') {
                        def resp = StringUtil.getMsg(((Reference) result).getProperty("resmsg"))
                        flash.message = resp
//                        render(view: "show", model: [tradeRefundInstance: tradeRefundInstance])
                        redirect(action: "unRefuseList")
                        return
                    }
                }
//                 def code = trx.acquirerCode.split("-")[0];
//                 if (code == 'YEP') {
//                    def args = [id: tradeRefundInstance.id]
//                    def result = invokeGwInnerApi('/ISMSApp/refund/aotoApp', args)
//
//                    if (!result) {
//                        flash.message = 'SYSTEM_BUSY'
//                    } else if (((Reference) result).getProperty("resmsg") != '00') {
//                        def resp = ((Reference) result).getProperty("resmsg")
//                        flash.message = resp
////                        render(view: "show", model: [tradeRefundInstance: tradeRefundInstance])
//                        redirect(action: "unRefuseList")
//                        return
//                    }
//                }
                try {
                    def op = session.getValue("op")
                    def userName = op.account
                    def userId = op.id
                    tradeRefundInstance.refundRecheckId = userId
                    tradeRefundInstance.refundRecheckName = userName

                    //如果是退分润的退款不走清结算
//                    def tradeBase = TradeBase.findAllWhere(originalId: tradeRefundInstance.id, status: 'completed', tradeType: 'royalty_rfd')
                    //查找异步退分润
                    def refundDetail = RefundDetail.findAllWhere(refundNo: tradeRefundInstance.outTradeNo, status: 'completed', refundType: '1')
//                    if ((!tradeBase || tradeBase.size() == 0) && refundDetail.size() == 0 && tradeRefundInstance.partnerId!='') {
//                        def resp = settleClientService.trade('online', 'refund', CmCustomer.get(tradeRefundInstance.partnerId)?.customerNo, tradeRefundInstance.amount as Long,
//                                tradeRefundInstance.tradeNo, tradeRefundInstance.dateCreated.format('yyyy-MM-dd HH:mm:ss.SSS'),
//                                tradeRefundInstance.lastUpdated ? tradeRefundInstance.lastUpdated.format('yyyy-MM-dd HH:mm:ss.SSS') : new Date().format('yyyy-MM-dd HH:mm:ss.SSS'))
//                        if (!resp) {
//                            flash.message =  'SYSTEM_BUSY'
//                        } else if (resp.result == 'true') {
//                            tradeService.checkRefund(tradeRefundInstance, tradeRefund, flag, sign, label)
//                        } else {
//                            flash.message =resp.errorMsg
//                        }
//                    } else{
                    tradeService.checkRefund(tradeRefundInstance, tradeRefund, flag, sign, label, royalty)
//                    }
                    //查找异步退分润
//                    def refundDetail = RefundDetail.findAllWhere(refundNo: tradeRefundInstance.outTradeNo, status: 'completed', refundType: '1')
                    if (refundDetail.size() > 0) {
                        //查询退分润金额
                        def refundAmount = 0
                        def refundRoyalty = TradeBase.findAllWhere(outTradeNo: tradeRefundInstance.outTradeNo, rootId: tradeRefundInstance.rootId, tradeType: 'royalty_rfd', status: 'completed')
                        if (refundRoyalty.size() > 0) {
                            refundRoyalty.each {
                                refundAmount = it.amount + refundAmount
                            }
                        }
                        def money = refundAmount - tradeRefundInstance.amount
                        //如果是部分退款，剩余金额要从服务账户转到现金账户
                        if (money > 0) {
                            //formAccountNo   服务账户
                            tradeRefund.payeeAccountNo = tradeRefundInstance.payerAccountNo
                            //toAccountNo  现金账户
                            tradeRefund.payerAccountNo = CmCustomer.get(tradeRefundInstance.partnerId).accountNo
                            tradeRefund.amount = money
                            label = 0
                            tradeService.checkRefund(tradeRefundInstance, tradeRefund, flag, sign, label, royalty)
                        }
                    }

//                    //如果是退分润的退款不走清结算
//                    def tradeBase = TradeBase.findAllWhere(originalId: tradeRefundInstance.id, status: 'completed', tradeType: 'royalty_rfd')
//                    if ((!tradeBase || tradeBase.size() == 0) && refundDetail.size() == 0) {
//                        flash.message = "退款处理成功"
//                        javax.jms.MapMessage message = jmsService.createMapMessage()
//                        message.setString('srvCode', 'online')
//                        message.setString('tradeCode', 'refund')
//                        message.setString('customerNo', CmCustomer.get(tradeRefundInstance.partnerId).customerNo)
//                        message.setLong('amount', tradeRefundInstance.amount as Long)
//                        message.setString('seqNo', tradeRefundInstance.tradeNo)
//                        message.setString('tradeDate', tradeRefundInstance.dateCreated.format('yyyy-MM-dd HH:mm:ss.SSS'))
//                        message.setString('billDate', tradeRefundInstance.checkDate ? tradeRefundInstance.checkDate.format('yyyy-MM-dd HH:mm:ss.SSS') : new Date().format('yyyy-MM-dd HH:mm:ss.SSS'))
//                        jmsService.send(message)
//                    }
                } catch (Exception e) {
                    flash.message = "退款失败，${e.getMessage()}，可能需要重新提交"
                    log.warn("check Refund error", e)
                }
                redirect(action: "reCheckList")
                return
            } else {
                render(view: "unRefuseShow", model: [tradeRefundInstance: tradeRefundInstance])
                return
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeRefund.label', default: 'tradeRefund'), params.id])}"
            redirect(action: "reCheckList")
            return
        }
    }

    //单笔审核通过
    def singleCheck = {
        def tradeRefundInstance = TradeRefund.get(params.id)
        def errorMsg

        if (tradeRefundInstance.acquirer_account_id == null) {
            errorMsg = "收单银行账户不能为空"
        }
        if (errorMsg != null) {
            flash.message = errorMsg
            render(view: "show", model: [tradeRefundInstance: tradeRefundInstance])
            return
        }
        if (!tradeRefundInstance) {
            flash.message = "该笔退款不存在！"
            render(view: "show", model: [tradeRefundInstance: tradeRefundInstance])
            return
        } else {
            try {
                def op = session.getValue("op")
                def userName = op.account
                def userId = op.id
                tradeRefundInstance.handleStatus = 'checked'
                tradeRefundInstance.lastAppDate = new Date()
                tradeRefundInstance.lastAppId = userId
                tradeRefundInstance.lastAppName = userName
                tradeRefundInstance.save(flush: true, failOnError: true)
                flash.message = "单笔审核审批通过成功！"
            } catch (Exception e) {
                flash.message = "退款失败，${e.getMessage()}，可能需要重新提交"
                log.warn("check Refund error", e)
            }

            redirect(action: "unRefuseList")
        }
    }

    //单笔待处理 批量审批通过
    def singlePcPass = {
        def id = params.id
        def op = session.getValue("op")
        def boBankDic = BoBankDic.findByCode(params.bankName)
        def boAcquirerAccountId = params.acquirerAccountId
        def userName = op.account
        def userId = op.id
        def idList = new ArrayList()
        idList = id.split(',')
        TradeRefund.withTransaction {

            if (idList.size() > 0) {
                idList.each {
                    def tradeRefundInstance = TradeRefund.get(it)
                   //退款手续费
                   if(tradeRefundInstance?.realityRefundAmount==null&&tradeRefundInstance?.channel=="3"){
                        if(tradeRefundInstance?.acquirerMerchantNo!=null){
                         //订单金额
                           def  originalAmount
                           if(tradeRefundInstance.tradeType=='refund'){
                               originalAmount= TradeBase.get(tradeRefundInstance.originalId)?.amount
                          }
                           if(tradeRefundInstance.tradeType=='royalty_ref'){
                             originalAmount= TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment')?.amount
                           }

                           def sql="select * from gwtrxs t where t.trxnum='${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId, 'charge')?.outTradeNo}'";
                           def sqly = new Sql(dataSource_ismp)
                           Map map = sqly.firstRow(sql)
                            //实际手续费
                           def sxAmount=map.get("AMOUNT")-originalAmount
                            //实际收款金额
                           def sjAmount=map.get("AMOUNT")
                        //实际退款金额
                         def realityRefundAmount=0;
                        def boMerchantInstance=BoMerchant.findByAcquireMerchant(tradeRefundInstance.acquirerMerchantNo);
                         //获取费率对象
                         List boChannelRateInstanceList= BoChannelRate.findAllByMerchantId(boMerchantInstance.id);
                         BoChannelRate boChannelRateInstance=boChannelRateInstanceList.get(0);
                            if(boChannelRateInstanceList.size()==2){
                                 if(boChannelRateInstance.getIsCurrent()==false){
                                 boChannelRateInstance= boChannelRateInstanceList.get(1);
                            }
                            }

                         if(boChannelRateInstance==null){
                                realityRefundAmount=tradeRefundInstance.amount
                          }else{
                         //退款按笔收费
                         if(boChannelRateInstance?.feeType.equals("0")&&boChannelRateInstance?.isCurrent==true){
                            if(boChannelRateInstance?.isRefundFee.equals("0")){
                            realityRefundAmount=tradeRefundInstance.amount
                          }
                           if(boChannelRateInstance?.isRefundFee.equals("1")){
                              def list= TradeRefund.findAllByRootId(tradeRefundInstance.rootId)
                              Long refundedAmount=0
                               tradeRefundInstance.refundedAmount =tradeRefundInstance.amount
                               for(int i=0;i<list.size();i++){
                                   TradeRefund tradeRefund =list.get(i);
                                    if(tradeRefund.getRefundedAmount()!=null){
                                         refundedAmount+=tradeRefund.getRefundedAmount()
                                   }
                               }
                                if(refundedAmount.equals(originalAmount)){
                                  realityRefundAmount=tradeRefundInstance.amount+sxAmount
                                }else{
                                     realityRefundAmount=tradeRefundInstance.amount
                               }
                          }
                         }
                                 if(boChannelRateInstance?.feeType.equals("0")&&boChannelRateInstance?.isCurrent==false){
                                        realityRefundAmount=tradeRefundInstance.amount
                                        tradeRefundInstance.refundedAmount=tradeRefundInstance.amount
                             }
                              if(boChannelRateInstance?.feeType.equals("1")&&boChannelRateInstance?.isCurrent==false){
                                       realityRefundAmount=tradeRefundInstance.amount
                                   tradeRefundInstance.refundedAmount=tradeRefundInstance.amount
                              }
                         //退款按比率收费
                         if(boChannelRateInstance?.feeType.equals("1")&&boChannelRateInstance?.isCurrent==true){
                          if(boChannelRateInstance?.isRefundFee.equals("0")){
                            realityRefundAmount=tradeRefundInstance.amount
                          }
                           if(boChannelRateInstance?.isRefundFee.equals("1")){
                                 def list= TradeRefund.findAllByRootId(tradeRefundInstance.rootId)
                               Long refundedAmount=0
                             tradeRefundInstance.refundedAmount =tradeRefundInstance.amount
                               for(int i=0;i<list.size();i++){
                                   TradeRefund tradeRefund =list.get(i);
                                   if(tradeRefund.getRefundedAmount()!=null){
                                         refundedAmount+=tradeRefund.getRefundedAmount()
                                   }
                               }
                             if(refundedAmount.equals(originalAmount)){
                                  realityRefundAmount=tradeRefundInstance.amount+sxAmount
                             }else{
                                    realityRefundAmount=tradeRefundInstance.amount
                                }
                         }
                          if(boChannelRateInstance?.isRefundFee.equals("2")){
                              realityRefundAmount=tradeRefundInstance.amount+ tradeRefundInstance.amount*sxAmount/originalAmount
                          }
                        }
                          }
                            if(boChannelRateInstance?.isCurrent==true){
                               tradeRefundInstance.realityRefundAmount=realityRefundAmount
                            }else{
                                tradeRefundInstance.realityRefundAmount=tradeRefundInstance.amount
                            }

                            } else{
                                  tradeRefundInstance.realityRefundAmount=0
                            }
                              }
                    if(tradeRefundInstance?.realityRefundAmount==null&&tradeRefundInstance?.channel!="3"){
                               tradeRefundInstance.realityRefundAmount=tradeRefundInstance.amount
                       }
                      tradeRefundInstance.refundedAmount =tradeRefundInstance.amount
                    //初审通过，只改变单据状态
                    tradeRefundInstance.handleStatus = 'fChecked'
                    tradeRefundInstance.firstAppId = userId
                    tradeRefundInstance.firstAppName = userName
                    tradeRefundInstance.firstAppDate = new Date()
                    tradeRefundInstance.acquirer_account_id = boAcquirerAccountId as Long
                    if (tradeRefundInstance.acquirer_account_id == null) {
                        flash.message = "收单银行账户不能为空"
                        return
                    }
                    if (!tradeRefundInstance.hasErrors() && tradeRefundInstance.save(flush: true)) {
                        flash.message = "退款审批通过成功！"
                    }
                    else {
                        flash.message = "退款审批通过失败！"
                        return
                    }
                }
            }
        }
        redirect(action: "unCheckList")
    }

    //单笔批量审批通过
    def selectSingleCheck = {
        def id = params.id
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        def idList = new ArrayList()
        idList = id.split(',')
        TradeRefund.withTransaction {

            if (idList.size() > 0) {
                idList.each {
                    def tradeRefundInstance = TradeRefund.get(it)
                    //初审通过，只改变单据状态
                    tradeRefundInstance.handleStatus = 'checked'
                    tradeRefundInstance.lastAppId = userId
                    tradeRefundInstance.lastAppName = userName
                    tradeRefundInstance.lastAppDate = new Date()
                    if (tradeRefundInstance.acquirer_account_id == null) {
                        flash.message = "收单银行账户不能为空"
                        return
                    }
                    if (!tradeRefundInstance.hasErrors() && tradeRefundInstance.save(flush: true)) {
                        flash.message = "退款审批通过成功！"
                    }
                    else {
                        flash.message = "退款审批通过失败！"
                        return
                    }
                }
            }
        }
        redirect(action: "unRefuseList")
    }

    //退款复核批量审核通过
    def selectCheckPass = {
        def id = params.id
        def royalty = ''
        def idList = new ArrayList()
        idList = id.split(',')
        TradeRefund.withTransaction {
            if (idList.size() > 0) {
                idList.each {
                    def flag
                    def sign
                    def label
                    def tradeRefundInstance = TradeRefund.get(it)
                     tradeRefundInstance.refundedAmount = tradeRefundInstance.amount
                    def tradeRefund = new TradeRefund()
                    tradeRefund.refundedAmount=tradeRefund.amount
                    def errorMsg
                    if (tradeRefundInstance.acquirer_account_id == null) {
                        flash.message = "收单银行账户不能为空"
                        return
                    }

                    if (!tradeRefundInstance.hasErrors()) {
                        if (tradeRefundInstance.acquirerCode == 'FXPPAYCARD') {
                            def args = [id: tradeRefundInstance.id]
                            def result = invokeGwInnerApi('/ISMSApp/refund/aotoApp', args)

                            if (!result) {
                                flash.message = 'SYSTEM_BUSY'
                            } else if (((Reference) result).getProperty("resmsg") != '00') {
                                def resp = StringUtil.getMsg(((Reference) result).getProperty("resmsg"))
                                flash.message = resp
                                return
                            }
                        }
//                          def code = tradeRefundInstance.acquirerCode.split("-")[0];
//                             if (code == 'YEP') {
//                                def args = [id: tradeRefundInstance.id]
//                                def result = invokeGwInnerApi('/ISMSApp/refund/aotoApp', args)
//
//                                if (!result) {
//                                    flash.message = 'SYSTEM_BUSY'
//                                } else if (((Reference) result).getProperty("resmsg") != '00') {
//                                    def resp = ((Reference) result).getProperty("resmsg")
//                                    flash.message = resp
//                                    redirect(action: "unRefuseList")
//                                    return
//                                }
//                            }
                        try {
                            def op = session.getValue("op")
                            def userName = op.account
                            def userId = op.id
                            tradeRefundInstance.refundRecheckId = userId
                            tradeRefundInstance.refundRecheckName = userName

                            //查找异步退分润
                            def refundDetail = RefundDetail.findAllWhere(refundNo: tradeRefundInstance.outTradeNo, status: 'completed', refundType: '1')
                            tradeService.checkRefund(tradeRefundInstance, tradeRefund, flag, sign, label, royalty)
                                  //获得个人手续费账户
                                def grFeeAccount = BoInnerAccount.findByKey('chargefeeAcc').accountNo
                                  def ba = BoAcquirerAccount.get(tradeRefundInstance.acquirer_account_id)
                                    if (ba == null) {
                                        throw new Exception("银行账户不存在")
                                    }
                                 def cmdList = null
                                 def feeAmount=tradeRefundInstance.realityRefundAmount-tradeRefundInstance.amount
                                 if (tradeRefundInstance.amount != 0 && tradeRefundInstance.amount != null) {
                                     cmdList = accountClientService.buildTransfer(null, grFeeAccount, ba.innerAcountNo,feeAmount, 'fee_rfd', tradeRefundInstance.tradeNo ? tradeRefundInstance.tradeNo : '0', tradeRefundInstance.outTradeNo ? tradeRefundInstance.outTradeNo : '0', '退款手续费转账')
                                 }
                             tradeRefundInstance.handleCommandNo = UUID.randomUUID().toString().replaceAll('-', '')
                            accountClientService.batchCommand(tradeRefundInstance.handleCommandNo, cmdList)
                            if (refundDetail.size() > 0) {
                                //查询退分润金额
                                def refundAmount = 0
                                def refundRoyalty = TradeBase.findAllWhere(outTradeNo: tradeRefundInstance.outTradeNo, rootId: tradeRefundInstance.rootId, tradeType: 'royalty_rfd', status: 'completed')
                                if (refundRoyalty.size() > 0) {
                                    refundRoyalty.each {
                                        refundAmount = it.amount + refundAmount
                                    }
                                }
                                def money = refundAmount - tradeRefundInstance.amount
                                //如果是部分退款，剩余金额要从服务账户转到现金账户
                                if (money > 0) {
                                    //formAccountNo   服务账户
                                    tradeRefund.payeeAccountNo = tradeRefundInstance.payerAccountNo
                                    //toAccountNo  现金账户
                                    tradeRefund.payerAccountNo = CmCustomer.get(tradeRefundInstance.partnerId).accountNo
                                    tradeRefund.amount = money
                                    label = 0
                                    tradeRefund.refundedAmount = tradeRefund.amount
                                    tradeService.checkRefund(tradeRefundInstance, tradeRefund, flag, sign, label, royalty)
                                    flash.message = "退款复核成功！"
                                }
                            }
                        } catch (Exception e) {
                            flash.message = "退款失败，${e.getMessage()}，可能需要重新提交"
                            log.warn("check Refund error", e)
                            return
                        }
                    } else {
                        flash.message = "退款失败，可能需要重新提交"
                        render(view: "unRefuseShow", model: [tradeRefundInstance: tradeRefundInstance])
                        return
                    }
                }
            } else {
                flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeRefund.label', default: 'tradeRefund'), params.id])}"
                return
            }
        }
        redirect(action: "reCheckList")
    }

//初审通过
    def fCheck = {
        def note = params.note
        println note
        def tradeRefundInstance = TradeRefund.get(params.id)
        if (tradeRefundInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (tradeRefundInstance.version > version) {

                    tradeRefundInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'tradeRefund.label', default: 'tradeRefund')] as Object[], "Another user has updated this TradeWithdrawn while you were editing")
                    render(view: "show", model: [tradeRefundInstance: tradeRefundInstance])
                    return
                }
            }
            tradeRefundInstance.properties = params
            //初审通过，只改变单据状态
            tradeRefundInstance.handleStatus = 'fChecked'
            def op = session.getValue("op")
            def userName = op.account
            def userId = op.id
            tradeRefundInstance.firstAppId = userId
            tradeRefundInstance.firstAppName = userName
            tradeRefundInstance.firstAppDate = new Date()
            tradeRefundInstance.note = note
            def errorMsg
            if (tradeRefundInstance.acquirer_account_id == null) {
                errorMsg = "收单银行账户不能为空"
            }
            if (errorMsg != null) {
                flash.message = errorMsg
                render(view: "show", model: [tradeRefundInstance: tradeRefundInstance])
                return
            }
            if (!tradeRefundInstance.hasErrors() && tradeRefundInstance.save(flush: true, fieldError: true)) {
                flash.message = "退款处理成功"
                redirect(action: "unCheckList")
            }
            else {
                render(view: "show", model: [tradeRefundInstance: tradeRefundInstance])
                return
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeRefund.label', default: 'tradeRefund'), params.id])}"
            redirect(action: "unCheckList")
            return
        }
    }
//批量初审通过
    def chCheck = {
        def id = params.id
        def bankName = params.bankName
        def boBankDic = BoBankDic.findByCode(bankName)
        def boAcquirerAccountId = params.acquirerAccountId
        def ids = id.toString().substring(0, id.toString().length() - 1)
        def query = "from TradeRefund where id in (${ids})"
        def trade = TradeRefund.findAll(query)
        def count
        def amount = 0
        def type
        if (trade.size() > 0) {
            count = trade.size()
            trade.each {
                amount = amount + (it.amount ? it.amount : 0)
                type = it?.channel
            }
        }
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        def idList = new ArrayList()
        idList = id.split(',')
        TradeRefund.withTransaction {
            def tradeRefundBatch = new TradeRefundBatch()
            tradeRefundBatch.batchCount = count
            tradeRefundBatch.batchAmount = amount
            tradeRefundBatch.refundDate = new Date()
            tradeRefundBatch.refundType = type
            tradeRefundBatch.refundBankName = boBankDic?.name
            tradeRefundBatch.refundBankCode = boBankDic?.code
            tradeRefundBatch.status = 'waiting' //待处理状态
            tradeRefundBatch.appId = userId
            tradeRefundBatch.appName = userName
            tradeRefundBatch.save(flush: true)
            if (idList.size() > 0) {
                idList.each {
                    def tradeRefundInstance = TradeRefund.get(it)
                    //初审通过，只改变单据状态
                    tradeRefundInstance.handleStatus = 'fChecked'
                    tradeRefundInstance.firstAppId = userId
                    tradeRefundInstance.firstAppName = userName
                    tradeRefundInstance.acquirer_account_id = boAcquirerAccountId as Long
                    tradeRefundInstance.refundBatchNo = tradeRefundBatch.id
                    tradeRefundInstance.firstAppDate = new Date()
                    if (tradeRefundInstance.acquirer_account_id == null) {
                        flash.message = "收单银行账户不能为空"
                        return
                    }
                    else{
                  //退款手续费
                   //退款手续费
                   if(tradeRefundInstance?.realityRefundAmount==null&&tradeRefundInstance?.channel=="3"){
                        if(tradeRefundInstance?.acquirerMerchantNo!=null){
                         //订单金额
                           def  originalAmount
                           if(tradeRefundInstance.tradeType=='refund'){
                               originalAmount= TradeBase.get(tradeRefundInstance.originalId)?.amount
                          }
                           if(tradeRefundInstance.tradeType=='royalty_ref'){
                             originalAmount= TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment')?.amount
                           }
                           tradeRefundInstance?.realityRefundAmount=0
                            tradeRefundInstance?.refundedAmount=0
                           def sql="select * from gwtrxs t where t.trxnum='${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId, 'charge')?.outTradeNo}'";
                           def sqly = new Sql(dataSource_ismp)
                           Map map = sqly.firstRow(sql)
                            //实际手续费
                           def sxAmount=map.get("AMOUNT")-originalAmount
                            //实际收款金额
                           def sjAmount=map.get("AMOUNT")
                        //实际退款金额
                         def realityRefundAmount=0;
                        def boMerchantInstance=BoMerchant.findByAcquireMerchant(tradeRefundInstance.acquirerMerchantNo);
                         //获取费率对象
                         List boChannelRateInstanceList= BoChannelRate.findAllByMerchantId(boMerchantInstance.id);
                         BoChannelRate boChannelRateInstance=boChannelRateInstanceList.get(0);
                            if(boChannelRateInstanceList.size()==2){
                                 if(boChannelRateInstance.getIsCurrent()==false){
                                 boChannelRateInstance= boChannelRateInstanceList.get(1);
                            }
                            }

                         if(boChannelRateInstance==null){
                                realityRefundAmount=tradeRefundInstance.amount
                          }else{
                         //退款按笔收费
                         if(boChannelRateInstance?.feeType.equals("0")&&boChannelRateInstance?.isCurrent==true){
                            if(boChannelRateInstance?.isRefundFee.equals("0")){
                            realityRefundAmount=tradeRefundInstance.amount
                          }
                           if(boChannelRateInstance?.isRefundFee.equals("1")){
                              def list= TradeRefund.findAllByRootId(tradeRefundInstance.rootId)
                              Long refundedAmount=0
                               tradeRefundInstance.refundedAmount =tradeRefundInstance.amount
                               for(int i=0;i<list.size();i++){
                                   TradeRefund tradeRefund =list.get(i);
                                    if(tradeRefund.getRefundedAmount()!=null){
                                         refundedAmount+=tradeRefund.getRefundedAmount()
                                   }
                               }
                                if(refundedAmount.equals(originalAmount)){
                                  realityRefundAmount=tradeRefundInstance.amount+sxAmount
                                }else{
                                     realityRefundAmount=tradeRefundInstance.amount
                               }
                          }
                         }
                                 if(boChannelRateInstance?.feeType.equals("0")&&boChannelRateInstance?.isCurrent==false){
                                        realityRefundAmount=tradeRefundInstance.amount
                                        tradeRefundInstance.refundedAmount=tradeRefundInstance.amount
                             }
                              if(boChannelRateInstance?.feeType.equals("1")&&boChannelRateInstance?.isCurrent==false){
                                       realityRefundAmount=tradeRefundInstance.amount
                                   tradeRefundInstance.refundedAmount=tradeRefundInstance.amount
                              }
                         //退款按比率收费
                         if(boChannelRateInstance?.feeType.equals("1")&&boChannelRateInstance?.isCurrent==true){
                          if(boChannelRateInstance?.isRefundFee.equals("0")){
                            realityRefundAmount=tradeRefundInstance.amount
                          }
                           if(boChannelRateInstance?.isRefundFee.equals("1")){
                                 def list= TradeRefund.findAllByRootId(tradeRefundInstance.rootId)
                               Long refundedAmount=0
                             tradeRefundInstance.refundedAmount =tradeRefundInstance.amount
                               for(int i=0;i<list.size();i++){
                                   TradeRefund tradeRefund =list.get(i);
                                   if(tradeRefund.getRefundedAmount()!=null){
                                         refundedAmount+=tradeRefund.getRefundedAmount()
                                   }
                               }
                             if(refundedAmount.equals(originalAmount)){
                                  realityRefundAmount=tradeRefundInstance.amount+sxAmount
                             }else{
                                    realityRefundAmount=tradeRefundInstance.amount
                                }
                         }
                          if(boChannelRateInstance?.isRefundFee.equals("2")){
                              realityRefundAmount=tradeRefundInstance.amount+ tradeRefundInstance.amount*sxAmount/originalAmount
                          }
                        }
                          }
                            if(boChannelRateInstance?.isCurrent==true){
                               tradeRefundInstance.realityRefundAmount=realityRefundAmount
                            }else{
                                tradeRefundInstance.realityRefundAmount=tradeRefundInstance.amount
                            }

                            } else{
                                  tradeRefundInstance.realityRefundAmount=0
                            }
                              }
                        if(tradeRefundInstance?.realityRefundAmount==null&&tradeRefundInstance?.channel!="3"){
                               tradeRefundInstance.realityRefundAmount=tradeRefundInstance.amount
                       }
                          tradeRefundInstance.refundedAmount =tradeRefundInstance.amount
                    }
                    if (!tradeRefundInstance.hasErrors() && tradeRefundInstance.save(flush: true)) {
                        flash.message = "退款处理成功！"
                    }
                    else {
                        flash.message = "退款处理失败！"
                        return
                    }
                }
            }
        }
        redirect(action: "unCheckList")
    }

    def getAcquireAccountsJson = {
        def bank, allAcquireAccounts
        bank = BoBankDic.findByCode(params.bankCode)
        allAcquireAccounts = BoAcquirerAccount.findAllByBankAndStatus(bank,'normal')
        render allAcquireAccounts as JSON
    }

    def selectDl = {
        def id = params.id
        def bankName = params.bankName
         def sdbList = new ArrayList()
        def boBankDic = BoBankDic.findByCode(bankName)
        id = id.toString().substring(0, id.toString().length() - 1)
        def query = "from TradeRefund where id in (${id})"
        def result = TradeRefund.findAll(query)
        def amount = 0
         def channel
        def count = result.size() ? result.size() : 0
        if (result.size() > 0) {
            result.each {
                amount += it.amount
                channel = it.channel
            }
        }
        def filename
        def sb = new StringBuffer()
         boBankDic.code = boBankDic.code.split("-")[0];
        if (boBankDic.code.equalsIgnoreCase('icbc')) {
            filename = 'csv-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.csv'
            response.contentType = "text/csv"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            render(template: "ICBCList", model: [tradeRefundInstanceList: result, totalAmount: amount, totalCount: count])
        } else if (boBankDic.code.equalsIgnoreCase('ceb')) {
            filename = 'ceb-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.txt'
            response.contentType = "text/plain"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            render(template: "cebList", model: [tradeRefundInstanceList: result, totalAmount: amount, totalCount: count])
        } else if (boBankDic.code.equalsIgnoreCase('boc')) {
            filename = 'boc-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.txt'
            response.contentType = "text/plain"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            render(template: "bocList", model: [tradeRefundInstanceList: result, totalAmount: amount, totalCount: count])
        } else if (boBankDic.code.equalsIgnoreCase('ccb')) {
            filename = 'ccb-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.txt'
            response.contentType = "text/plain"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            render(template: "ccbList", model: [tradeRefundInstanceList: result, totalAmount: amount, totalCount: count])
        } else if (boBankDic.code.equalsIgnoreCase('hsbc')) {
            filename = 'hsbc-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.txt'
            response.contentType = "text/plain"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            render(template: "hsbcList", model: [tradeRefundInstanceList: result, totalAmount: amount, totalCount: count])
        } else if (boBankDic.code.equalsIgnoreCase('abc')) {
            filename = 'abc-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.txt'
            response.contentType = "text/plain"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            render(template: "abcList", model: [tradeRefundInstanceList: result, totalAmount: amount, totalCount: count])
         } else if (boBankDic.code.equalsIgnoreCase('cmbc')) {
            filename = 'cmbc-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.txt'
            response.contentType = "text/plain"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            render(template: "cmbcList", model: [tradeRefundInstanceList: result, totalAmount: amount, totalCount: count])
        }  else if (boBankDic.code.equalsIgnoreCase('sdb')) {
             if (result.size() > 0) {
                result.each {
                   def outNo = TradeBase.findByRootIdAndTradeType(it.rootId, 'charge')?.outTradeNo;
                   def noLength = outNo.length()
                    if(noLength<29){
                          for(def i=0;i<30-noLength;i++){
                               outNo=outNo+"0";
                          }
                    }
                    def money = it.amount/100
                    def moneyStr = money.toString().replace(".","")
                    def moneyLength=moneyStr.length();
                      if(moneyLength<13){
                          for(def j=0;j<13-moneyLength;j++){
                               moneyStr="0"+moneyStr;
                          }
                    }
                    it.setOutTradeNo(outNo);
                    it.setRefundHandleName(moneyStr);
                    sdbList.add(it);
                }
            }
            filename = 'sdb-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.txt'
            response.contentType = "text/plain"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            render(template: "sdbList", model: [tradeRefundInstanceList: sdbList, totalAmount: amount, totalCount: count,channel:channel])
        }else if (boBankDic.code.equalsIgnoreCase('citic')) {
            try {
                def os = response.getOutputStream();// 取得输出流
                 response.reset();// 清空输出流
                filename = 'citic-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
                response.contentType = "application/x-rarx-rar-compressed"
                response.setCharacterEncoding("GBK")
                response.setHeader("Content-disposition", "attachment; filename=" + filename)// 设定输出文件头
//            render(template: "cncbList", model: [tradeRefundInstanceList: result, totalAmount: amount, totalCount: count])
                WritableWorkbook book = Workbook.createWorkbook(os);
                WritableFont wfont = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD,
                        false, UnderlineStyle.NO_UNDERLINE, Colour.BLACK);
                WritableCellFormat wcfFC = new WritableCellFormat(wfont);
                wcfFC.setBackground(Colour.AQUA);
                //  生成名为“第一页”的工作表，参数0表示这是第一页
                WritableSheet sheet = book.createSheet("中信银行报盘文件", 0);
                //  在Label对象的构造子中指名单元格位置是第一列第一行(0,0)
                //  以及单元格内容为test
                sheet.setColumnView(0, 30)
                sheet.setColumnView(1, 30)
                sheet.setColumnView(2, 30)
                def dateFromat=new SimpleDateFormat("yyyyMMdd")
// 开始生成主体内容
                sheet.addCell(new Label(0, 0, "文件类型:"));
                sheet.addCell(new Label(1, 0, "FTThirdBatchPayback"));
                sheet.addCell(new Label(0, 1, "标题:"));
                sheet.addCell(new Label(1, 1, "充值退回"));
                sheet.addCell(new Label(0, 2, "(标注颜色的列为必填项）"));
                sheet.addCell(new Label(0, 4, "原充值订单号", wcfFC));
                sheet.addCell(new Label(1, 4, "原充值订单日期", wcfFC));
                sheet.addCell(new Label(2, 4, "充值退回金额", wcfFC));
                sheet.addCell(new Label(3, 4, "摘要"));
                for (int i = 0; i < result.size(); i++) {
                    sheet.addCell(new Label(0, i + 5, TradeBase.get(result.get(i).rootId)?.outTradeNo));   //数据库的城市代码字段
                    sheet.addCell(new Label(1, i + 5, dateFromat.format(TradeBase.get(result.get(i).rootId)?.dateCreated)));  //数据库的城市名字段
                    sheet.addCell(new Label(2, i + 5, result.get(i).amount ? result.get(i).amount / 100 as String : '0'));  //数据库的城市名字段
                    sheet.addCell(new Label(3, i + 5, result.get(i)?.note));  //数据库的城市名字段
                }
// 主体内容生成结束
                book.write(); // 写入文件
                book.close();
//               redirect(action: "unCheckList")
            }
            catch (Exception ex) {
                ex.printStackTrace();
                return false;
            }


        } else if (boBankDic.code.equalsIgnoreCase('unionpay')) {
            filename = 'unionpay-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.txt'
            response.contentType = "text/plain"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            render(template: "unList", model: [tradeRefundInstanceList: result, totalAmount: amount, totalCount: count])
        }else if (boBankDic.code.equalsIgnoreCase('yep')) {
            try {
                    def os = response.getOutputStream();// 取得输出流
                     response.reset();// 清空输出流
                    filename = 'yep-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
                    response.contentType = "application/x-rarx-rar-compressed"
                    response.setCharacterEncoding("GBK")
                    response.setHeader("Content-disposition", "attachment; filename=" + filename)// 设定输出文件头
                    WritableWorkbook book = Workbook.createWorkbook(os);
                    WritableFont wfont = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD,false, UnderlineStyle.NO_UNDERLINE, Colour.BLACK);
                    WritableCellFormat wcfFC = new WritableCellFormat(wfont);
                    wcfFC.setBackground(Colour.AQUA);
                    //  生成名为“第一页”的工作表，参数0表示这是第一页
                    WritableSheet sheet = book.createSheet("易宝报盘文件", 0);
                    //  在Label对象的构造子中指名单元格位置是第一列第一行(0,0)
                    //  以及单元格内容为test
                    sheet.setColumnView(0, 30)
                    sheet.setColumnView(1, 30)
                    sheet.setColumnView(2, 30)
                    sheet.setColumnView(3, 30)
                    sheet.setColumnView(4, 30)
                    sheet.setColumnView(5, 30)
                    def dateFromat=new SimpleDateFormat("yyyy-MM-dd")
                     // 开始生成主体内容
                    sheet.addCell(new Label(0, 0, "订单号:"));
                    sheet.addCell(new Label(1, 0, "支付日期"));
                    sheet.addCell(new Label(2, 0, "退货金额"));
                    sheet.addCell(new Label(3, 0, "退款号"));
                    sheet.addCell(new Label(4, 0, "扩展信息"));
                    sheet.addCell(new Label(5, 0, "扩展信息"));

                    for (int i = 0; i < result.size(); i++) {
                        sheet.addCell(new Label(0, i + 1, GwTransaction.get(TradeCharge.findByRootId(result.get(i).rootId)?.tradeNo)?.bankTransNo));   //订单号
                        sheet.addCell(new Label(1, i + 1, dateFromat.format(TradeBase.get(result.get(i).rootId)?.dateCreated)));  //支付日期
                        sheet.addCell(new Label(2, i + 1, result.get(i).amount ? result.get(i).amount as String : '0'));  //退货金额
                        sheet.addCell(new Label(3, i + 1, result.get(i)?.outTradeNo));  //退款号
//                        sheet.addCell(new Label(4, i + 5, ''));  //扩展信息
//                        sheet.addCell(new Label(5, i + 5, ''));  //扩展信息
                    }
                    book.write(); // 写入文件
                    book.close();
                }
                catch (Exception ex) {
                    ex.printStackTrace();
                    return false;
                }


        } else {
            filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.contentType = "application/x-rarx-rar-compressed"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            render(template: "ICBCList", model: [tradeRefundInstanceList: result])
        }
    }
//  全部初审通过
    def allCheckPass = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.offset = params.offset ? params.int('offset') : 0
        println params.startDateCreated
        def seBankName = params.seBankName
        def boBankDic = BoBankDic.findByName(seBankName)
        def boAcquirerAccount = BoAcquirerAccount.findByBank(boBankDic)
        def query = {
            if (params.tradeNo != null && params.tradeNo != '') {
                like('tradeNo', '%' + params.tradeNo + '%')
            }
            if (params.payerName != null && params.payerName != '') {
                like('payerName', '%' + params.payerName + '%')
            }
            if (params.payerAccountNo != null && params.payerAccountNo != '') {
                like('payerAccountNo', '%' + params.payerAccountNo + '%')
            }
            if (params.startAmount != null && params.startAmount != '') {
                ge('amount', StringUtil.parseAmountFromStr(params.startAmount))
            }
            if (params.endAmount != null && params.endAmount != '') {
                le('amount', StringUtil.parseAmountFromStr(params.endAmount))
            }
            //guonan update 2011-12-29
            validDated(params)
            if (params.startDateCreated) {
                ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDateCreated))
            }
            if (params.endDateCreated) {
                lt('dateCreated', Date.parse('yyyy-MM-dd', params.endDateCreated) + 1)
            }

            if (params.handleStatus != null && params.handleStatus != '') {
                eq('handleStatus', params.handleStatus)
            }
            'in'('handleStatus', ['waiting'])
            eq('status', 'processing')
        }
        def chann
        def results = TradeRefund.createCriteria().list(params, query)
        TradeRefund.withTransaction {
            if (results.size() > 0) {
                results.each {
                    it.handleStatus = 'fChecked'
                    def op = session.getValue("op")
                    def userName = op.account
                    def userId = op.id
                    it.firstAppId = userId
                    it.firstAppName = userName
                    it.firstAppDate = new Date()
                    it.acquirer_account_id = boAcquirerAccount?.id
                    def errorMsg
                    def channel = it.channel
                    if (it.acquirer_account_id == null) {
                        flash.message = "收单银行账户不能为空"
                        redirect(action: "unCheckList")
                        return
                    }
                    if (params.channel == null || params.channel == '') {
                        if (channel != chann && chann == '' && chann == null) {
                            flash.message = "您选择的数据不是同一支付类型,请重新选择！"
                        }
                        chann = channel
                    }
                    if (!it.hasErrors() && it.save(flush: true)) {
                        flash.message = "退款处理成功！"
                    }
                    else {
                        flash.message = "退款处理失败！"
                        redirect(action: "unCheckList")
                        return
                    }
                }
            }
            redirect(action: "unCheckList")
        }
    }
//退款复核失败通过
    def refused = {
        //flag=1表示初审拒绝
        def flag = 1
        //是否是分润初审拒绝
        def royalty = params.flag ? params.flag : ''
        def sign
        def label
        def tradeRefundInstance = TradeRefund.get(params.id)
        def tradeRefund = new TradeRefund()
        if (tradeRefundInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (tradeRefundInstance.version > version) {
                    tradeRefundInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'tradeRefund.label', default: 'tradeRefund')] as Object[], "Another user has updated this TradeWithdrawn while you were editing")
                    render(view: "show", model: [tradeRefundInstance: tradeRefundInstance])
                    return
                }
            }
            tradeRefundInstance.properties = params
            def appNote = AppNote.findByAppId(params.id)
            if (appNote) {
                appNote.appNote = params.appNote
                if (royalty != '') {
                    appNote.appName = 'tradeRefund'
                } else {
                    appNote.appName = 'tradeRefund_last'
                }

            } else {
                appNote = new AppNote()
                appNote.appId = params.id
                if (royalty != '') {
                    appNote.appName = 'tradeRefund'
                } else {
                    appNote.appName = 'tradeRefund_last'
                }
                appNote.appNote = params.appNote
                appNote.status = '2'
            }
            appNote.save flash: true, flush: true, fieldError: true

            def errorMsg
            if (tradeRefundInstance.acquirer_account_id == null) {
                errorMsg = "收单银行账户不能为空"
            }
            if (errorMsg != null) {
                flash.message = errorMsg
                render(view: "show", model: [tradeRefundInstance: tradeRefundInstance])
                return
            }
            if (!tradeRefundInstance.hasErrors()) {
                try {
                    def op = session.getValue("op")
                    def userName = op.account
                    def userId = op.id
                    if (royalty != '') {
                        tradeRefundInstance.firstAppId = userId
                        tradeRefundInstance.firstAppName = userName
                        tradeRefundInstance.firstAppDate = new Date()
                    } else {
                        tradeRefundInstance.refundRecheckId = userId
                        tradeRefundInstance.refundRecheckName = userName
                        tradeRefundInstance.refundRecheckDate = new Date()
                    }
                    //查询产生该笔退款的退分润
                    def royaltyRefund = TradeBase.findAllByOriginalIdAndStatus(tradeRefundInstance.id, 'completed')
                    if (royaltyRefund.size() > 0) {
                        //审批拒绝时，先从支出中间账户退款给实时分润账户，然后由分润账户退款给分润账户，再由手续费账户退手续费给rongPay。
                        sign = 1 //用于判断是否是分润退款
                        label = 1  //用于支出中间账户退款给实时分润账户
                        tradeService.checkRefund(tradeRefundInstance, tradeRefund, flag, sign, label, royalty)
                        royaltyRefund.each {
                            //fromAccountNo
                            tradeRefund.payeeAccountNo = it.payeeAccountNo
                            //toAccountNo
                            tradeRefund.payerAccountNo = it.payerAccountNo
                            tradeRefund.amount = it.amount
                            tradeRefund.tradeNo = it.tradeNo
                            tradeRefund.outTradeNo = it.outTradeNo
                            tradeRefund.payerId = it.payerId
                            tradeRefundInstance.amount = 0
                            label = 0
                            tradeService.checkRefund(tradeRefundInstance, tradeRefund, flag, sign, label, royalty)
                        }
                    } else {
                        tradeService.checkRefund(tradeRefundInstance, tradeRefund, flag, sign, label, royalty)
                    }
                    flash.message = "退款处理成功"
                } catch (Exception e) {
                    flash.message = "退款失败，${e.getMessage()}，可能需要重新提交"
                    log.warn("check Refund error", e)
                }
                if (royalty != '') {
                    redirect(action: "unCheckList")
                } else {
                    redirect(action: "reCheckList")
                }
                return
            }
            else {
                render(view: "show", model: [tradeRefundInstance: tradeRefundInstance])
                return
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeRefund.label', default: 'tradeRefund'), params.id])}"
            if (royalty != '') {
                redirect(action: "unCheckList")
            } else {
                redirect(action: "reCheckList")
            }
            return
        }
    }

//批次退款复核失败通过
    def refundBatchRefused = {
        //flag=1表示初审拒绝
        def flag = 1
        def sign
        def label
        def royalty = ''
        def id = params.id
        def idList = new ArrayList()
        idList = id.split(',')
        TradeRefund.withTransaction {
            if (idList.size() > 0) {
                idList.each {
                    def tradeRefundInstance = TradeRefund.get(it)
                    def tradeRefund = new TradeRefund()

                    if (tradeRefundInstance) {
                        try {
                            def op = session.getValue("op")
                            def userName = op.account
                            def userId = op.id
                            tradeRefundInstance.refundRecheckId = userId
                            tradeRefundInstance.refundRecheckName = userName
                            //查询产生该笔退款的退分润
                            def royaltyRefund = TradeBase.findAllByOriginalIdAndStatus(tradeRefundInstance.id, 'completed')
                            if (royaltyRefund.size() > 0) {
                                //审批拒绝时，先从支出中间账户退款给实时分润账户，然后由分润账户退款给分润账户，再由手续费账户退手续费给rongPay。
                                sign = 1 //用于判断是否是分润退款
                                label = 1  //用于支出中间账户退款给实时分润账户
                                tradeService.checkRefund(tradeRefundInstance, tradeRefund, flag, sign, label, royalty)
                                royaltyRefund.each {
                                    //fromAccountNo
                                    tradeRefund.payeeAccountNo = it.payeeAccountNo
                                    //toAccountNo
                                    tradeRefund.payerAccountNo = it.payerAccountNo
                                    tradeRefund.amount = it.amount
                                    tradeRefund.tradeNo = it.tradeNo
                                    tradeRefund.outTradeNo = it.outTradeNo
                                    tradeRefund.payerId = it.payerId
                                    tradeRefundInstance.amount = 0
                                    label = 0
                                    tradeService.checkRefund(tradeRefundInstance, tradeRefund, flag, sign, label, royalty)
                                }
                            } else {
                                tradeService.checkRefund(tradeRefundInstance, tradeRefund, flag, sign, label, royalty)
                            }
                            flash.message = "拒绝退款复核成功"
                        } catch (Exception e) {
                            flash.message = "退款失败，${e.getMessage()}，可能需要重新提交"
                            log.warn("check Refund error", e)
                        }
                    } else {
                        flash.message = "退款订单不存在！"
                    }
                }
                redirect(action: "reCheckList")
                return
            }
            else {
                flash.message = "拒绝退款复核失败"
                redirect(action: "reCheckList")
                return
            }
        }
    }

//单笔，单笔终审拒绝
    def endRefused = {
        def tradeRefundInstance = TradeRefund.get(params.id)
        try {
            TradeRefund.withTransaction {
                if (tradeRefundInstance) {
                    def appNote = AppNote.findByAppId(params.id)
                    if (appNote) {
                        appNote.appNote = params.appNote
                        appNote.appName = 'tradeRefund_first'
                    } else {
                        appNote = new AppNote()
                        appNote.appId = params.id
                        appNote.appName = 'tradeRefund_first'
                        appNote.appNote = params.appNote
                        appNote.status = '2'
                    }
                    appNote.save flash: true, flush: true, fieldError: true

                    if (!tradeRefundInstance.hasErrors()) {
                        try {
                            def op = session.getValue("op")
                            def userName = op.account
                            def userId = op.id
                            tradeRefundInstance.lastAppId = userId
                            tradeRefundInstance.lastAppName = userName
                            tradeRefundInstance.lastAppDate = new Date()
                            tradeRefundInstance.handleStatus = 'waiting'
                            if (!tradeRefundInstance.hasErrors() && tradeRefundInstance.save(flush: true)) {
                                flash.message = "终审拒绝成功"
                                redirect(action: "unRefuseList")
                            }
                            else {
                                render(view: "unRefuseShow", model: [tradeRefundInstance: tradeRefundInstance])
                                return
                            }
                        } catch (Exception e) {
                            flash.message = "退款失败，${e.getMessage()}，可能需要重新提交"
                            log.warn("check Refund error", e)
                        }
                    }
                    else {
                        render(view: "unRefuseShow", model: [tradeRefundInstance: tradeRefundInstance])
                        return
                    }
                } else {
                    flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tradeRefund.label', default: 'tradeRefund'), params.id])}"
                    redirect(action: "unRefuseList")
                    return
                }
            }
        } catch (Exception e) {
            flash.message = "退款失败，${e.getMessage()}，可能需要重新提交"
            redirect(action: "unRefuseList")
        }
    }

//退款处理审批通过
    def checkPass = {
        def id = params.id
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        def idList = new ArrayList()
        idList = id.split(',')
        TradeRefund.withTransaction {
            if (idList.size() > 0) {
                idList.each {
                    def tradeRefundInstance = TradeRefund.get(it)
                    //初审通过，只改变单据状态
                    tradeRefundInstance.handleStatus = 'success'  //成功状态
                    tradeRefundInstance.refundHandleId = userId
                    tradeRefundInstance.refundHandleName = userName
                    tradeRefundInstance.refundHandleDate = new Date()
                    if (tradeRefundInstance.acquirer_account_id == null) {
                        flash.message = "收单银行账户不能为空"
                        return
                    }
                    if (!tradeRefundInstance.hasErrors() && tradeRefundInstance.save(flush: true, failOnError: true)) {
                        flash.message = "退款处理审批通过成功！"
                    }
                    else {
                        flash.message = "退款处理审批通过失败！"
                        return
                    }
                }
            }
        }
        redirect(action: "checkList")
    }

//退款处理审批拒绝
    def checkRefused = {
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        TradeRefund.withTransaction {
            def appNote = AppNote.findByAppId(params.id)
            if (appNote) {
                appNote.appNote = params.appNote
                appNote.appName = 'tradeRefund_second'
            } else {
                appNote = new AppNote()
                appNote.appId = params.id
                appNote.appName = 'tradeRefund_second'
                appNote.appNote = params.appNote
                appNote.status = '2'
            }
            appNote.save flash: true, flush: true, fieldError: true
            def tradeRefundInstance = TradeRefund.get(params.id)
            //初审通过，只改变单据状态
            tradeRefundInstance.handleStatus = 'fail'  //成功状态
            tradeRefundInstance.refundHandleId = userId
            tradeRefundInstance.refundHandleName = userName
            tradeRefundInstance.refundHandleDate = new Date()
            if (tradeRefundInstance.acquirer_account_id == null) {
                flash.message = "收单银行账户不能为空"
                return
            }
            if (!tradeRefundInstance.hasErrors() && tradeRefundInstance.save(flush: true, failOnError: true)) {
                flash.message = "退款处理拒绝成功！"
            }
            else {
                flash.message = "退款处理拒绝失败！"
                return
            }
        }
        redirect(action: "checkList")
    }
//批量退款成功的复核拒绝及批量退款失败的复核拒绝
    def reCheckRefused = {
        def id = params.id
        def note = params.appNote
        def idList = new ArrayList()
        idList = id.split(',')
        def op = session.getValue("op")
        def userName = op.account
        def userId = op.id
        try {
            TradeRefund.withTransaction {
                if (idList.size() > 0) {
                    idList.each {
                        def appNote = AppNote.findByAppId(it)
                        if (appNote) {
                            appNote.appNote = note
                            appNote.appName = 'tradeRefund_last'
                        } else {
                            appNote = new AppNote()
                            appNote.appId = it
                            appNote.appName = 'tradeRefund_last'
                            appNote.appNote = note
                            appNote.status = '2'
                        }
                        appNote.save(flush: true, failOnError: true)
                        //批量复核拒绝，只改变单据状态
                        def refund = TradeRefund.get(it)
                        refund.handleStatus = 'checked'  //退款失败，返回上一层审批状态
                        refund.refundRecheckId = userId
                        refund.refundRecheckName = userName
                        refund.refundRecheckDate = new Date()
                        refund.save flush: true, failOnError: true
                    }
                }
                flash.message = "退款复核拒绝成功！"
            }
        } catch (Exception e) {
            flash.message = "退款复核失败，${e.getMessage()}，可能需要重新提交"
//            flash.message = "退款复核拒绝失败！"
        }
        redirect(action: "reCheckList")
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
                    return result = json
                }
            }
        } catch (e) {
            log.error e, e
            result = e.getMessage()
        }
        log.info "resp: $result"
        result
    }

    def forbank = {

    }

    def subBank = { def id->
        String sHtmlText = alipayService.alipayRefund(id);
        return sHtmlText;
    }

}

