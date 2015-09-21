package gateway

import ebank.tools.StringUtil
import ismp.CmCustomer
import groovy.sql.Sql
import org.springframework.orm.hibernate3.HibernateTemplate
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import org.hibernate.transform.AliasToEntityMapResultTransformer
import javax.jms.Session
import org.springframework.orm.hibernate3.HibernateCallback
import org.bouncycastle.crypto.macs.CMac
import ismp.TradeBase

class GwOrderController {

    def index = {
        redirect(action: "list", params: params)
    }

    def dataSource_ismp

    def list = {

        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def now = new Date()
        def beginningOfDay = Date.parse('yyyyMMdd', now.format('yyyyMMdd'))
        def query = {

            if (params.id) like('id', '%' + params.id + '%')
            if (params.sellerCustomerNo) like('sellerCustomerNo', '%' + params.sellerCustomerNo + '%')
            if (params.outTradeNo) like('outTradeNo', '%' + params.outTradeNo + '%')
            if (params.sellerCode) like('sellerCode', '%' + params.sellerCode + '%')
            if (params.buyerCode) like('buyerCode', '%' + params.buyerCode + '%')

            if (params.startAmount) ge 'amount', StringUtil.parseAmountFromStr(params.startAmount)
            if (params.endAmount) le 'amount', StringUtil.parseAmountFromStr(params.endAmount)

            //update 2012-06-05 sunweiguo 增加卖家名称查询字段

            if (params.sellerName){
                def cmCustomer=CmCustomer.findByName(params.sellerName)
                if(cmCustomer) {
                    eq('sellerCustomerNo',cmCustomer.customerNo)
                }
            }

//            if (params.startTime || params.endTime) {
//                def startTime = params.startTime ?
//                    Date.parse("yyyyMMdd", params.startTime) : Date.parse("yyyyMMdd", params.endTime) - 30
//                def endTime = params.endTime ?
//                    Date.parse("yyyyMMdd", params.endTime) : startTime + 30
//                between 'dateCreated', startTime, endTime + 1
//            } else {
//                between 'dateCreated', beginningOfDay - 30, beginningOfDay + 1
//            }


             //update 2012-06-06 sunweiguo

            if (params.startLastUpdated)
            {
                   ge('closeDate', Date.parse('yyyy-MM-dd', params.startLastUpdated))
            }
            if (params.endLastUpdated)
            {
                  lt('closeDate', Date.parse('yyyy-MM-dd', params.endLastUpdated) + 1)
            }
            else
            {
                //guonan update 2012-1-10
                //validDated(params)
                def startTime,endTime
                if (params.startTime || params.endTime) {
                     startTime = params.startTime ? Date.parse("yyyy-MM-dd", params.startTime) : Date.parse("yyyy-MM-dd", params.startTime=params.endTime)
                     endTime = params.endTime ? Date.parse("yyyy-MM-dd", params.endTime) : Date.parse("yyyy-MM-dd", params.endTime=params.startTime)
                     between 'dateCreated', startTime, endTime + 1

                } else {
                    //默认显示时间范围30天的数据
                    if (params.startTime ==null && params.endTime ==null)
                    {
                        def gCalendar= new GregorianCalendar()
                        endTime=Date.parse('yyyy-MM-dd', params.endTime = gCalendar.time.format('yyyy-MM-dd'))
                        gCalendar.add(GregorianCalendar.MONTH,-1)
                        startTime=Date.parse('yyyy-MM-dd', params.startTime= gCalendar.time.format('yyyy-MM-dd'))
                        between 'dateCreated', startTime, endTime + 1

                    }
                }
            }
            //validLastDated(params)


            //update 2012-06-05 sunweiguo 增加卖家名称查询字段
            if (params.sellerName){
                def cmCustomer=CmCustomer.findByName(params.sellerName)
                if(cmCustomer) {
                    eq('sellerCustomerNo',cmCustomer.customerNo)
                }
            }

            if (params.status) eq 'status', params.status
            if (params.transactionId || params.acquirerCode || params.bankTransNo || params.authNo) {
                transactions {

                    if (params.transactionId) like ('id', '%' + params.transactionId + '%')
                    if (params.acquirerCode) like ('acquirerCode', '%' + params.acquirerCode + '%')
                    if (params.bankTransNo) like ('bankTransNo', '%' + params.bankTransNo + '%')
                    if (params.authNo) like  ('authNo', '%' + params.authNo + '%')
                }
            }
        }



        def summ = GwOrder.createCriteria().get {
            and query
            projections {
                sum('amount')
            }
        }

        def total = GwOrder.createCriteria().count(query)
        def gwOrderList = GwOrder.createCriteria().list(params, query)
        [gwOrderList: gwOrderList, gwOrderTotal: total, params: params,totalAmount:summ]
    }

    def validDated(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startTime==null && params.endTime==null){
            def gCalendar= new GregorianCalendar()
            params.endTime=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startTime=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.startTime && !params.endTime){
             params.endDateCreated=params.startDateCreated
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.startTime && params.endTime){
             params.startTime=params.endTime
        }
        if (params.startTime && params.endTime) {


        }
    }

    def listDownload = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = 50000
        params.offset = 0

        def now = new Date()
        def beginningOfDay = Date.parse('yyyyMMdd', now.format('yyyyMMdd'))
        def query = {
            if (params.id) like('id', '%' + params.id + '%')
            if (params.sellerCustomerNo) like('sellerCustomerNo', '%' + params.sellerCustomerNo + '%')
            if (params.outTradeNo) like('outTradeNo', '%' + params.outTradeNo + '%')
            if (params.sellerCode) like('sellerCode', '%' + params.sellerCode + '%')
            if (params.buyerCode) like('buyerCode', '%' + params.buyerCode + '%')

            if (params.startAmount) ge 'amount', StringUtil.parseAmountFromStr(params.startAmount)
            if (params.endAmount) le 'amount', StringUtil.parseAmountFromStr(params.endAmount)

             //update 2012-06-05 sunweiguo 增加卖家名称查询字段

            if (params.sellerName){
                def cmCustomer=CmCustomer.findByName(params.sellerName)
                if(cmCustomer) {
                    eq('sellerCustomerNo',cmCustomer.customerNo)
                }
            }
//            if (params.startTime || params.endTime) {
//                def startTime = params.startTime ?
//                    Date.parse("yyyyMMdd", params.startTime) : Date.parse("yyyyMMdd", params.endTime) - 30
//                def endTime = params.endTime ?
//                    Date.parse("yyyyMMdd", params.endTime) : startTime + 30
//                between 'dateCreated', startTime, endTime + 1
//            } else {
//                between 'dateCreated', beginningOfDay - 30, beginningOfDay + 1
//            }
             //guonan update 2012-1-10
            if (params.startLastUpdated)
            {
                   ge('closeDate', Date.parse('yyyy-MM-dd', params.startLastUpdated))
            }
            if (params.endLastUpdated)
            {
                  lt('closeDate', Date.parse('yyyy-MM-dd', params.endLastUpdated) + 1)
            }
            else
            {
                //guonan update 2012-1-10
                //validDated(params)
                def startTime,endTime
                if (params.startTime || params.endTime) {
                     startTime = params.startTime ? Date.parse("yyyy-MM-dd", params.startTime) : Date.parse("yyyy-MM-dd", params.startTime=params.endTime)
                     endTime = params.endTime ? Date.parse("yyyy-MM-dd", params.endTime) : Date.parse("yyyy-MM-dd", params.endTime=params.startTime)
                     between 'dateCreated', startTime, endTime + 1

                } else {
                    //默认显示时间范围30天的数据
                    if (params.startTime ==null && params.endTime ==null)
                    {
                        def gCalendar= new GregorianCalendar()
                        endTime=Date.parse('yyyy-MM-dd', params.endTime = gCalendar.time.format('yyyy-MM-dd'))
                        gCalendar.add(GregorianCalendar.MONTH,-1)
                        startTime=Date.parse('yyyy-MM-dd', params.startTime= gCalendar.time.format('yyyy-MM-dd'))
                        between 'dateCreated', startTime, endTime + 1

                    }
                }
            }

            //guoan update end


              //guonan update 2012-1-10
            def startTime,endTime
            if (params.startTime || params.endTime) {
                startTime = params.startTime ?
                    Date.parse("yyyy-MM-dd", params.startTime) : Date.parse("yyyy-MM-dd", params.startTime=params.endTime)
                 endTime = params.endTime ?
                    Date.parse("yyyy-MM-dd", params.endTime) : Date.parse("yyyy-MM-dd", params.endTime=params.startTime)
                between 'dateCreated', startTime, endTime + 1
            } else {
                if (params.startTime==null &&params.endTime==null) {
                def gCalendar= new GregorianCalendar()
                endTime=Date.parse('yyyy-MM-dd',  params.endTime = gCalendar.time.format('yyyy-MM-dd'))
                gCalendar.add(GregorianCalendar.MONTH,-1)
                startTime=Date.parse('yyyy-MM-dd', params.startTime= gCalendar.time.format('yyyy-MM-dd'))
                 between 'dateCreated', startTime, endTime + 1
                }
            }

            if (params.status) eq 'status', params.status
            if (params.transactionId || params.acquirerCode || params.bankTransNo || params.authNo) {
                transactions {
                    if (params.transactionId) like ('id', '%' + params.transactionId + '%')
                    if (params.acquirerCode) like ('acquirerCode', '%' + params.acquirerCode + '%')
                    if (params.bankTransNo) like ('bankTransNo', '%' + params.bankTransNo + '%')
                    if (params.authNo) like  ('authNo', '%' + params.authNo + '%')
                }
            }
        }

        def total = GwOrder.createCriteria().count(query)
        def gwOrderList = GwOrder.createCriteria().list(params, query)

        def summary = GwOrder.createCriteria().get {
            and query
//            eq('tradeType', 'payment')
            projections {
                sum('amount')
                rowCount()
            }
        }
        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        render(template: "tradeList", model: [gwOrderList: gwOrderList,totalAmount:summary[0],total:summary[1]])
    }

    def show = {
        def gwOrderInstance = GwOrder.get(params.id)
        if (!gwOrderInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'gwOrder.label', default: 'GwOrder'), params.id])}"
            redirect(action: "list")
        } else {
            [gwOrderInstance: gwOrderInstance]
        }
    }

    def close ={
        def gwOrderInstance = GwOrder.get(params.orderId)
        def msg = 'default.not.found.message'
        if (gwOrderInstance) {
            gwOrderInstance.status = "4"
            try {
                if (gwOrderInstance.executeUpdate("update GwOrder gw set gw.status=4  where gw.id= "+params.orderId)) {
                    msg = "订单关闭成功"
                } else {
                    msg = "订单关闭失败"
                }
            } catch (Exception e) {
                e.printStackTrace()
            }
        }
        flash.message = "${message(code: msg, args: [message(code: 'gwOrder.label', default: 'GwOrder'), params.id])}"
        redirect(action: "list")
    }
}
