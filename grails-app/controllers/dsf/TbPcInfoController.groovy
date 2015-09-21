package dsf

import boss.BoAcquirerAccount
import boss.BoBankDic
import ismp.CmCustomer
import boss.BoCustomerService
import boss.BoInnerAccount
import javax.servlet.http.HttpServletRequest
import java.text.SimpleDateFormat
import Constants.FarmConstants

import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.multipart.commons.CommonsMultipartFile
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import org.apache.poi.xssf.usermodel.XSSFSheet
import org.apache.poi.xssf.usermodel.XSSFRow
import org.apache.poi.xssf.usermodel.XSSFCell
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.hssf.usermodel.HSSFSheet
import org.apache.poi.hssf.usermodel.HSSFRow
import org.apache.poi.hssf.usermodel.HSSFCell

class TbPcInfoController {
    def dataSource_boss
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def accountClientService
    def jmsService

    def static map = new HashMap()

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {

        def s = (params.ids as String).replace("[", "").replace("]", "")
        def l = s.split(",")
        Long[] ids = new Long[l.length]
        if (s != "") {
            for (int i = 0; i < l.length; i++) {
                ids[i] = (l[i]) as Long
            }
        } else {
            flash.message = "无明细,没有生成批次!"
        }

        def query = {
            eq('tbPcDkStatus', '0')
            'in'('id', ids)
        }
        def results = TbPcInfo.createCriteria().list(params, query)
        def Total = TbPcInfo.createCriteria().count(query)
        [tbPcInfoInstanceList: results, tbPcInfoInstanceTotal: Total]
    }
    def itemShow = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = params.sort ? params.sort : "id"
        params.order = params.order ? params.order : "desc"
        def query = {
            eq('dkPcNo', params.id)
            if (params.tradeCardname != null && params.tradeCardname != "") {
                eq("tradeCardname", params.tradeCardname)
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                eq("tradeCardnum", params.tradeCardnum)
            }
             if (params.startMoney != null && params.startMoney != "") {
                ge("tradeAmount", Double.parseDouble(params.startMoney))
            }
             if (params.endMoney != null && params.endMoney != "") {
                le("tradeAmount", Double.parseDouble(params.endMoney));
            }
        }
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        def total = TbAgentpayDetailsInfo.createCriteria().count(query)
        double totalMoney = 0
        double totalFee = 0
        double totalAccMoney = 0
        results.each {
            totalMoney = totalMoney + it.tradeAmount
            totalFee = totalFee + (it.tradeFee ? it.tradeFee : 0)
            totalAccMoney = totalAccMoney + (it.tradeAccamount ? it.tradeAccamount : 0)
        }
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: total, totalMoney: totalMoney, totalFee: totalFee, totalAccMoney: totalMoney , id :params.id]
    }

    def skitemShow = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = params.sort ? params.sort : "id"
        params.order = params.order ? params.order : "desc"
        def query = {
            eq('dkPcNo', params.id)
             if (params.tradeCardname != null && params.tradeCardname != "") {
                eq("tradeCardname", params.tradeCardname)
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                eq("tradeCardnum", params.tradeCardnum)
            }
             if (params.startMoney != null && params.startMoney != "") {
                ge("tradeAmount", Double.parseDouble(params.startMoney))
            }
             if (params.endMoney != null && params.endMoney != "") {
                le("tradeAmount", Double.parseDouble(params.endMoney));
            }
        }
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        def total = TbAgentpayDetailsInfo.createCriteria().count(query)
        double totalMoney = 0
        double totalFee = 0
        double totalAccMoney = 0
        results.each {
            totalMoney = totalMoney + it.tradeAmount
            totalFee = totalFee + (it.tradeFee ? it.tradeFee : 0)
            totalAccMoney = totalAccMoney + (it.tradeAccamount ? it.tradeAccamount : 0)
        }
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: total, totalMoney: totalMoney, totalFee: totalFee, totalAccMoney: totalAccMoney, id :params.id]
    }

    /**
     * 批次打款管理
     */
    def dkPcManage = {
        params.max = Math.min(params.max ? params.int('max') : 20, 100)
        params.sort = params.sort ? params.sort : "id"
        params.order = params.order ? params.order : "desc"

        /* def dkPcNo=TbAgentpayDetailsInfo.executeQuery("select dkPcNo from TbAgentpayDetailsInfo where tradeType='F' and dkPcNo is not null")
       def ids
        if(dkPcNo.size()>0){
                     ids=new Long[dkPcNo.size()]
                 for(int i=0;i<dkPcNo.size();i++){
                    ids[i]=(dkPcNo.get(i) as Long)

                 }
                }*/
        def query = {
            eq('tbSfFlag', 'F')

            if (params.dkstatus == "" && params.dkstatus == null) {
                eq('tbPcDkStatus', '0')
            } else if (params.dkstatus) {
                eq('tbPcDkStatus', params.dkstatus)
            }
//            if (params.startTime) {
//                ge("tbPcDate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tbPcDate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }
             //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
            ge('tbPcDate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
            lt('tbPcDate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }
            if (params.id != null && params.id != "") {
//                eq("id", params.id as Long)
                sqlRestriction "to_char(tb_pc_id)  like '%"+params.id+"%'"
            }
            if (params.dkstatus != null && params.dkstatus != "") {
                eq("tbPcDkStatus", params.dkstatus)
            }
            if (params.bankName != null && params.bankName != "") {
                eq("tbPcDkChanel", params.bankName as Integer)
            }
            if (params.tbPcDkChanel != null && params.tbPcDkChanel != "") {
                eq("tbPcDkChanel", (params.tbPcDkChanel) as Integer)
            }
        }
        TbAgentpayDetailsInfoController tbAgentpayDetailsInfoController = new TbAgentpayDetailsInfoController()
        def results = TbPcInfo.createCriteria().list(params, query)
        def total = TbPcInfo.createCriteria().count(query)
        def summ = TbPcInfo.createCriteria().get {
            and query
            projections {
                sum('tbPcItems')
                sum('tbPcAmount')
                sum('tbPcFee')
            }
        }
        [tbPcInfoInstanceList: results, tbPcInfoInstanceTotal: total, bankChanelList: bankChanelList(),totalNum:summ[0],totalAmount:summ[1],totalFee:summ[2]]
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
        if (params.startTime==null && params.endTime==null){
            def gCalendar= new GregorianCalendar()
            params.endTime=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startTime=gCalendar.time.format('yyyy-MM-dd')
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


    /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan  2011-12-29
     *
     */
    def validDateDeald(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.dealSTime==null && params.dealETime==null){
            def gCalendar= new GregorianCalendar()
            params.dealETime=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.dealSTime=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.dealSTime && !params.dealETime){
             params.dealETime=params.dealSTime
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.dealSTime && params.dealETime){
             params.dealSTime=params.dealETime
        }
        if (params.dealSTime && params.dealETime) {


        }
    }

        /**
     * 验证日期间隔有效性
     *
     * @param params 表单参数
     * @return
     * @author guonan  2011-12-29
     *
     */
    def validDateTkd(params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.tksTime==null && params.tkeTime==null){
            def gCalendar= new GregorianCalendar()
            params.tkeTime=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.tksTime=gCalendar.time.format('yyyy-MM-dd')
        }
        //如果截止日期为空，默认为查询起始日期当天
        if (params.tksTime && !params.tkeTime){
             params.tkeTime=params.tksTime
        }
        //如果起始日期为空，默认为查询截止日期当天
        if (!params.tksTime && params.tkeTime){
             params.tksTime=params.tkeTime
        }
        if (params.tksTime && params.tkeTime) {


        }
    }


    def skPcManage = {
        params.max = Math.min(params.max ? params.int('max') : 20, 100)
        params.sort = params.sort ? params.sort : "id"
        params.order = params.order ? params.order : "desc"

        /*def dkPcNo=TbAgentpayDetailsInfo.executeQuery("select dkPcNo from TbAgentpayDetailsInfo where tradeType='S' and dkPcNo is not null")
       def ids
        if(dkPcNo.size()>0){
                     ids=new Long[dkPcNo.size()]
                 for(int i=0;i<dkPcNo.size();i++){
                    ids[i]=(dkPcNo.get(i) as Long)

                 }
                }*/
        def query = {
            eq('tbSfFlag', 'S')
            if (params.dkstatus == "" && params.dkstatus == null) {
                eq('tbPcDkStatus', '0')
            } else if (params.dkstatus) {
                eq('tbPcDkStatus', params.dkstatus)
            }



//            if (params.startTime) {
//                ge("tbPcDate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tbPcDate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }

              //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
            ge('tbPcDate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
            lt('tbPcDate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }

            if (params.id != null && params.id != "") {
//                eq("id", params.id as Long)
                sqlRestriction "to_char(tb_pc_id)  like '%"+params.id+"%'"
            }
            if (params.dkstatus != null && params.dkstatus != "") {
                eq("tbPcDkStatus", params.dkstatus)
            }
            if (params.bankName != null && params.bankName != "") {
                eq("tbPcDkChanel", params.bankName as Integer)
            }
            if (params.tbPcDkChanel != null && params.tbPcDkChanel != "") {
                eq("tbPcDkChanel", (params.tbPcDkChanel) as Integer)
            }
        }
        TbAgentpayDetailsInfoController tbAgentpayDetailsInfoController = new TbAgentpayDetailsInfoController()
        def results = TbPcInfo.createCriteria().list(params, query)
        def total = TbPcInfo.createCriteria().count(query)
        def summ = TbPcInfo.createCriteria().get {
            and query
            projections {
                sum('tbPcItems')
                sum('tbPcAmount')
                sum('tbPcFee')
            }
        }
        [tbPcInfoInstanceList: results, tbPcInfoInstanceTotal: total, bankChanelList: bankChanelList(),totalNum:summ[0],totalAmount:summ[1],totalFee:summ[2]]
    }
    def modify = {
        TbAgentpayDetailsInfoController tbAgentpayDetailsInfoController = new TbAgentpayDetailsInfoController()
        List item = TbAgentpayDetailsInfo.findAllByDkPcNo((params.id) as String)
        def flag = ""
        if (item != null) {
            for (int i = 0; i < item.size(); i++) {
                flag = item.get(0).tradeType
                if (flag != "") {break}
            }
        }
        [tbPcInfoInstance: TbPcInfo.get(params.id), bankNameList: tbAgentpayDetailsInfoController.bankChanelList(flag)]
    }
    def skmodify = {
        TbAgentpayDetailsInfoController tbAgentpayDetailsInfoController = new TbAgentpayDetailsInfoController()
        List item = TbAgentpayDetailsInfo.findAllByDkPcNo((params.id) as String)
        def flag = ""
        if (item != null) {
            for (int i = 0; i < item.size(); i++) {
                flag = item.get(0).tradeType
                if (flag != "") {break}
            }
        }
        [tbPcInfoInstance: TbPcInfo.get(params.id), bankNameList: tbAgentpayDetailsInfoController.bankChanelList(flag)]
    }
    def updateDkChanel = {

        def boAcquirerAccount = BoAcquirerAccount.get(params.bankName)

        TbPcInfo.executeUpdate(" update TbPcInfo set tbPcDkChanel=" + params.bankName + ",tbPcDkChanelname='" + boAcquirerAccount.bank.name + "-" + boAcquirerAccount.aliasName + "' where id=" + params.id)
        redirect(action: dkPcManage)
    }
    def skupdateDkChanel = {

        def boAcquirerAccount = BoAcquirerAccount.get(params.bankName)

        TbPcInfo.executeUpdate(" update TbPcInfo set tbPcDkChanel=" + params.bankName + ",tbPcDkChanelname='" + boAcquirerAccount.bank.name + "-" + boAcquirerAccount.aliasName + "' where id=" + params.id)
        redirect(action: skPcManage)
    }
    def dkitemselect = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = params.sort ? params.sort : "tradeSysdate"
        params.order = params.order ? params.order : "desc"
        def query = {
            eq("tradeType", "F")
            ne("tradeStatus", "0")
//            if (params.startTime) {
//                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }
//            if (params.tksTime) {
//                ge("tradeDonedate", Date.parse("yyyy-MM-dd", params.tksTime))
//            }
//            if (params.tkeTime) {
//                le("tradeDonedate", Date.parse("yyyy-MM-dd", params.tkeTime) + 1)
//            }

             //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
            ge('tradeSysdate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
            lt('tradeSysdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }
            //guonan update 2011-12-29
//            validDateTkd(params)
            if (params.tksTime) {
            ge('tradeDonedate', Date.parse('yyyy-MM-dd', params.tksTime))
            }
            if (params.tkeTime) {
            lt('tradeDonedate', Date.parse('yyyy-MM-dd', params.tkeTime) + 1)
              }

            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid", '%'+params.batchBizid+ '%')
            }
            if (params.dkPcNo != null && params.dkPcNo != "") {
                like("dkPcNo", '%'+params.dkPcNo+ '%')
            }

            if (params.tradeStyle != null && params.tradeStyle != "") {
                eq("tradeType", params.tradeStyle)
            }

            if (params.tradeType != null && params.tradeType != "") {
                eq("tradeType", params.tradeType)
            }
            if (params.id != null && params.id != "") {
//                eq("id", params.id as long)
                sqlRestriction "to_char(detail_id)  like '%"+params.id+"%'"
            }

            //guonan update 2011-12-29
//            validDateDeald(params)

            if (params.dealSTime != null && params.dealSTime != "") {
                def ids
                def list = TbPcInfo.executeQuery("select  id from TbPcInfo t where t.tbPcDate>=to_date('" + params.dealSTime + "','yyyy/MM/dd')")
                if (list.size() > 0) {
                    ids = new String[list.size()]
                    for (int i = 0; i < list.size(); i++) {
                        ids[i] = list.get(i)

                    }
                }
                'in'("dkPcNo", ids)
            }
            if (params.dealETime != null && params.dealETime != "") {
                def ids

                def list = TbPcInfo.executeQuery("select  id from TbPcInfo t where substr(t.tbPcDate,0,9)<=to_date('" + params.dealETime + "','yyyy/MM/dd')")
                if (list.size() > 0) {
                    ids = new String[list.size()]
                    for (int i = 0; i < list.size(); i++) {
                        ids[i] = list.get(i)

                    }
                }
                'in'("dkPcNo", ids)
            }
            if (params.tbPcDkChanel != null && params.tbPcDkChanel != "") {
                def list = TbPcInfo.findAllByTbPcDkChanel(params.tbPcDkChanel)
                if (list != null) {
                    def ids = new String[list.size()]
                    def i = 0
                    list.each {
                        ids[i] = it.id
                        i++
                    }

                    'in'("dkPcNo", ids)
                }
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                like("tradeCardnum","%" +  params.tradeCardnum+ "%")
            }
            if (params.tradeAccountname != null && params.tradeAccountname != "") {
                like("tradeAccountname", "%" + params.tradeAccountname+ "%")
            }
            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }
            if (params.payStatus != null && params.payStatus != "") {
                eq("payStatus", params.payStatus)
            }
            if (params.bankName != null && params.bankName != "") {
                def bank = BoBankDic.get((params.bankName) as long)
                like("tradeAccountname","%" +  bank.name+ "%")
            }
        }
        double totalMoney = 0
        double totalFee = 0
        double totalAccMoney = 0
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        def results1 = TbAgentpayDetailsInfo.createCriteria().list(query)
        results1.each {
            totalMoney = totalMoney + it.tradeAmount
            totalFee = totalFee + (it.tradeFee ? it.tradeFee : 0)
            totalAccMoney = totalAccMoney + (it.tradeAccamount ? it.tradeAccamount : 0)
        }
        def Total = TbAgentpayDetailsInfo.createCriteria().count(query)
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: Total, bankNameList: bankList('F'), bankChanelList: bankChanelList(), totalMoney: totalMoney, totalFee: totalFee, totalAccMoney: totalAccMoney]


    }
    def skitemselect = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = params.sort ? params.sort : "tradeSysdate"
        params.order = params.order ? params.order : "desc"
        def query = {
            eq("tradeType", "S")
            ne("tradeStatus", "0")
//            if (params.startTime) {
//                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }
//            if (params.tksTime) {
//                ge("tradeDonedate", Date.parse("yyyy-MM-dd", params.tksTime))
//            }
//            if (params.tkeTime) {
//                le("tradeDonedate", Date.parse("yyyy-MM-dd", params.tkeTime) + 1)
//            }
             //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
            ge('tradeSysdate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
            lt('tradeSysdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }
            //guonan update 2011-12-29
//            validDateTkd(params)
            if (params.tksTime) {
            ge('tradeDonedate', Date.parse('yyyy-MM-dd', params.tksTime))
            }
            if (params.tkeTime) {
            lt('tradeDonedate', Date.parse('yyyy-MM-dd', params.tkeTime) + 1)
            }

            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid","%" +   params.batchBizid+ "%")
            }
            if (params.dkPcNo != null && params.dkPcNo != "") {
                like("dkPcNo", "%" + params.dkPcNo+ "%")
            }

            if (params.tradeStyle != null && params.tradeStyle != "") {
                eq("tradeType", params.tradeStyle)
            }

            if (params.tradeType != null && params.tradeType != "") {
                eq("tradeType", params.tradeType)
            }
            if (params.id != null && params.id != "") {
//                eq("id", params.id as long)
                sqlRestriction "to_char(detail_id)  like '%"+params.id+"%'"
            }
            //guonan update 2011-12-29
//            validDateDeald(params)
            if (params.dealSTime != null && params.dealSTime != "") {
                def ids
                def list = TbPcInfo.executeQuery("select  id from TbPcInfo t where t.tbPcDate>=to_date('" + params.dealSTime + "','yyyy/MM/dd')")
                if (list.size() > 0) {
                    ids = new String[list.size()]
                    for (int i = 0; i < list.size(); i++) {
                        ids[i] = list.get(i)

                    }
                }
                'in'("dkPcNo", ids)
            }
            if (params.dealETime != null && params.dealETime != "") {
                def ids
                def list = TbPcInfo.executeQuery("select  id from TbPcInfo t where substr(t.tbPcDate,0,9)<=to_date('" + params.dealETime + "','yyyy/MM/dd')")
                if (list.size() > 0) {
                    ids = new String[list.size()]
                    for (int i = 0; i < list.size(); i++) {
                        ids[i] = list.get(i)

                    }
                }
                'in'("dkPcNo", ids)
            }
            if (params.tbPcDkChanel != null && params.tbPcDkChanel != "") {
                def list = TbPcInfo.findAllByTbPcDkChanel(params.tbPcDkChanel)
                if (list != null) {
                    def ids = new String[list.size()]
                    def i = 0
                    list.each {
                        ids[i] = it.id
                        i++
                    }

                    'in'("dkPcNo", ids)
                }
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                like("tradeCardnum","%" +  params.tradeCardnum + "%")
            }
            if (params.tradeAccountname != null && params.tradeAccountname != "") {
                like("tradeAccountname","%" +   params.tradeAccountname+ "%")
            }
            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }
            if (params.payStatus != null && params.payStatus != "") {
                eq("payStatus", params.payStatus)
            }
            if (params.bankName != null && params.bankName != "") {
                def bank = BoBankDic.get((params.bankName) as long)
                like("tradeAccountname", "%" + bank.name+ "%")
            }
        }
        double totalMoney = 0
        double totalFee = 0
        double totalAccMoney = 0
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        def results1 = TbAgentpayDetailsInfo.createCriteria().list(query)
        results1.each {
            totalMoney = totalMoney + it.tradeAmount
            totalFee = totalFee + (it.tradeFee ? it.tradeFee : 0)
            totalAccMoney = totalAccMoney + (it.tradeAccamount ? it.tradeAccamount : 0)
        }
        def Total = TbAgentpayDetailsInfo.createCriteria().count(query)
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: Total, bankNameList: bankList('S'), bankChanelList: bankChanelList(), totalMoney: totalMoney, totalFee: totalFee, totalAccMoney: totalAccMoney]


    }
    def listDownload = {
        params.max = 50000
        params.offset = 0

        def query = {
            eq("tradeType", params.flag)
            ne("tradeStatus", "0")
//            if (params.startTime) {
//                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }
//            if (params.tksTime) {
//                ge("tradeDonedate", Date.parse("yyyy-MM-dd", params.tksTime))
//            }
//            if (params.tkeTime) {
//                le("tradeDonedate", Date.parse("yyyy-MM-dd", params.tkeTime) + 1)
//            }
             //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
            ge('tradeSysdate', Date.parse('yyyy-MM-dd', params.startTime))
            }
             if (params.endTime) {
            lt('tradeSysdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
             }
            //guonan update 2011-12-29
//            validDateTkd(params)
            if (params.tksTime) {
            ge('tradeDonedate', Date.parse('yyyy-MM-dd', params.tksTime))
            }
             if (params.tkeTime) {
            lt('tradeDonedate', Date.parse('yyyy-MM-dd', params.tkeTime) + 1)
              }

            //guonan update 2011-12-29
//            validDateDeald(params)
            if (params.dealSTime != null && params.dealSTime != "") {
                def ids
                def list = TbPcInfo.executeQuery("select  id from TbPcInfo t where t.tbPcDate>=to_date('" + params.dealSTime + "','yyyy/MM/dd')")
                if (list.size() > 0) {
                    ids = new String[list.size()]
                    for (int i = 0; i < list.size(); i++) {
                        ids[i] = list.get(i)

                    }
                }
                'in'("dkPcNo", ids)
            }
            if (params.dealETime != null && params.dealETime != "") {
                def ids
                def list = TbPcInfo.executeQuery("select  id from TbPcInfo t where t.tbPcDate<=to_date('" + params.dealETime + "','yyyy/MM/dd')")
                if (list.size() > 0) {
                    ids = new String[list.size()]
                    for (int i = 0; i < list.size(); i++) {
                        ids[i] = list.get(i)

                    }
                }
                'in'("dkPcNo", ids)
            }

            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid", "%" +  params.batchBizid+ "%")
            }
            if (params.dkPcNo != null && params.dkPcNo != "") {
                like("dkPcNo", "%" +  params.dkPcNo+ "%")
            }

            if (params.tradeStyle != null && params.tradeStyle != "") {
                eq("tradeType", params.tradeStyle)
            }

            if (params.tradeType != null && params.tradeType != "") {
                eq("tradeType", params.tradeType)
            }
            if (params.id != null && params.id != "") {
//                eq("id", params.id as long)
                sqlRestriction "to_char(detail_id)  like '%"+params.id+"%'"
            }

            if (params.tbPcDkChanel != null && params.tbPcDkChanel != "") {
                def list = TbPcInfo.findAllByTbPcDkChanel(params.tbPcDkChanel)
                if (list != null && list.size() > 0) {
                    def ids = new String[list.size()]
                    def i = 0
                    list.each {
                        ids[i] = it.id
                        i++
                    }

                    'in'("dkPcNo", ids)
                }
                else {
                    isNull("id")
                }
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                like("tradeCardnum", "%" + params.tradeCardnum+ "%")
            }
            if (params.tradeAccountname != null && params.tradeAccountname != "") {
                like("tradeAccountname", "%" + params.tradeAccountname+ "%")
            }
            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }
            if (params.payStatus != null && params.payStatus != "") {
                eq("payStatus", params.payStatus)
            }
            if (params.bankName != null && params.bankName != "") {
                def bank = BoBankDic.get((params.bankName) as long)
                like("tradeAccountname", "%" + bank.name+ "%")

            }
        }
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)

        def total = TbAgentpayDetailsInfo.createCriteria().count(query)

        def summary = TbAgentpayDetailsInfo.createCriteria().get {
            and query
//            eq('tradeType', 'payment')
            projections {
                sum('tradeAmount')
                rowCount()
                sum('tradeFee')

            }
        }

        def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("UTF-8")
        if (params.flag == 'F') {
            render(template: "checkAmount", model: [tbAgentpayDetailsInfoInstanceList: results,totalAmount:summary[0],total:summary[1],totalFee:summary[2]])
        } else {
            render(template: "skcheckAmount", model: [tbAgentpayDetailsInfoInstanceList: results,totalAmount:summary[0],total:summary[1],totalFee:summary[2]])
        }

    }

    def itemCheckMoney = {
        def query = {
            eq("", "")

        }
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        def Total = TbAgentpayDetailsInfo.createCriteria().count(query)
    }

    def create = {
        def tbPcInfoInstance = new TbPcInfo()
        tbPcInfoInstance.properties = params
        return [tbPcInfoInstance: tbPcInfoInstance]
    }

    def save = {
        def tbPcInfoInstance = new TbPcInfo(params)
        if (tbPcInfoInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'tbPcInfo.label', default: 'TbPcInfo'), tbPcInfoInstance.id])}"
            redirect(action: "list", id: tbPcInfoInstance.id)
        }
        else {
            render(view: "create", model: [tbPcInfoInstance: tbPcInfoInstance])
        }
    }

    def show = {
        def tbPcInfoInstance = TbPcInfo.get(params.id)
        if (!tbPcInfoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbPcInfo.label', default: 'TbPcInfo'), params.id])}"
            redirect(action: "list")
        }
        else {
            [tbPcInfoInstance: tbPcInfoInstance]
        }
    }

    def edit = {
        def tbPcInfoInstance = TbPcInfo.get(params.id)
        if (!tbPcInfoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbPcInfo.label', default: 'TbPcInfo'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [tbPcInfoInstance: tbPcInfoInstance]
        }
    }

    def update = {
        def tbPcInfoInstance = TbPcInfo.get(params.id)

        if (tbPcInfoInstance) {

            if (params.version) {
                def version = params.version.toLong()
                if (tbPcInfoInstance.version > version) {

                    tbPcInfoInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'tbPcInfo.label', default: 'TbPcInfo')] as Object[], "Another user has updated this TbPcInfo while you were editing")
                    render(view: "edit", model: [tbPcInfoInstance: tbPcInfoInstance])
                    return
                }
            }
            tbPcInfoInstance.properties = params
            if (!tbPcInfoInstance.hasErrors() && tbPcInfoInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'tbPcInfo.label', default: 'TbPcInfo'), tbPcInfoInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [tbPcInfoInstance: tbPcInfoInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbPcInfo.label', default: 'TbPcInfo'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def tbPcInfoInstance = TbPcInfo.get(params.id)
        if (tbPcInfoInstance) {
            try {
                tbPcInfoInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'tbPcInfo.label', default: 'TbPcInfo'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'tbPcInfo.label', default: 'TbPcInfo'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbPcInfo.label', default: 'TbPcInfo'), params.id])}"
            redirect(action: "list")
        }
    }
    def confirm = {
        def ids = params.ids.substring(0, params.ids.length() - 1)
        TbAgentpayDetailsInfo.executeUpdate(" update TbAgentpayDetailsInfo set payStatus='5' where dkPcNo in(" + ids + ")")
        def id = ids.split(",")
        for (int i = 0; i < id.size(); i++) {
            def results = TbPcInfo.get(id[i])
            def tbPcInfoInstance = TbPcInfo.get(results.id)
            tbPcInfoInstance.tbPcDkStatus = "1"   //打款完成
            tbPcInfoInstance.tbPcCheckStatus = "1"//打款完成,可以对账,即未对账
            if (tbPcInfoInstance) {
                tbPcInfoInstance.properties = params
                if (!tbPcInfoInstance.hasErrors() && tbPcInfoInstance.save(flush: true)) {
                    flash.message = "打款完成"

                }
            }
            else {
                flash.message = "打款失败"

            }
        }
        redirect(action: "list", params: [ids: ids])
    }

    def downLoad = {

        List dlist = TbAgentpayDetailsInfo.findAllByDkPcNo(params.id)
        def flag = ""
        if (dlist.size() > 0) {
            flag = dlist.get(0).tradeType
        }
        if (flag == 'S') {
            downLoadAgentCollList()

        } else if (flag == 'F') {
            downLoadList()

        } else {
            redirect(action: "dkPcManage")
        }
    }

    def downLoadList = {  //df下载
        List analist = analyzeFile()//解析区域文件

        // def list = TbAgentpayDetailsInfo.findAllByDkPcNoAndPayStatus(params.id as int, '5')
        def query = {
            eq('dkPcNo', String.valueOf(params.id))
            not {'in'('payStatus', ['7', '9'])}
            order("id", "desc")
        }
        def list = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        TbPcInfo tbPcInfo = TbPcInfo.findById((params.id as int))

        BoAcquirerAccount boAcquirerAccount = BoAcquirerAccount.findById(tbPcInfo.tbPcDkChanel)
        def sb = new StringBuffer()
        if (boAcquirerAccount != null) {
            if (boAcquirerAccount.bank.code == 'ccb') { //中国建设银行
                if (list != null && list.size() > 0) {
                    if (list.get(0).tradeAccounttype == '0') {  //建行对私的
                        sb = ccbDfPriCheckAmount(list)
                    } else if (list.get(0).tradeAccounttype == '1') {//建行对公的
                        sb = ccbDfPubCheckAmount(list, boAcquirerAccount)
                    }

                }

            } else if (boAcquirerAccount.bank.code == 'icbc') {//工商银行
                response.setHeader("Content-disposition", "attachment; filename=" + new Date().format("yyyyMMddHHmm") + ".bpt")
                response.contentType = "application/x-rarx-rar-compressed"
                response.setCharacterEncoding("GBK")
                long totalAmount = 0
                list.each {
                    totalAmount = totalAmount + (BigDecimal.valueOf(it.tradeAmount) * BigDecimal.valueOf(100)) as long
                }
                sb.append("#总计信息\n")
                sb.append("#注意：本文件中的金额均以分为单位！\n")
                sb.append("#币种|日期|总计标志|总金额|总笔数|\n")
                sb.append("RMB|" + new Date().format("yyyyMMdd") + "|1|" + totalAmount + "|" + list.size() + "|\n")
                sb.append("#明细指令信息\n")
                sb.append("#币种|日期|明细标志|顺序号|付款账号开户行|付款账号|付款账号名称|收款账号开户行|收款账号省份|收款账号地市|收款账号地区码|收款账号|收款账号名称|金额|汇款用途|备注信息|汇款方式|收款账户短信通知手机号码|自定义序号|")
                def i = 0;
                list.each {
                    i++
                    sb.append("\n")
                    if (it.tradeAmounttype == 'CNY') {
                        sb.append("RMB" + "|")
                    }
                    sb.append(((it.tradeSysdate.format("yyyyMMdd")) as String) + "|")
                    sb.append("2|")
                    sb.append(i.toString() + "|")
                    sb.append(boAcquirerAccount.bank.name + boAcquirerAccount.branchName + "|")  //付款账号名称
                    sb.append(boAcquirerAccount.bankAccountNo + "|")    //付款方账号
                    sb.append(boAcquirerAccount.bankAccountName + "|")  //付款方名称
                    sb.append(it.tradeAccountname + (it.tradeBranchbank ? it.tradeBranchbank : "") + (it.tradeSubbranchbank ? it.tradeSubbranchbank : "") + "|")//收款开户行名称
                    sb.append(it.tradeRemark.split(';')[0] + "|")  //收款账号省市名(非工行为空)
                    sb.append(it.tradeRemark.split(';')[1] + "|") //收款账号市
                    if (it.tradeAccountname == boAcquirerAccount.bank.name) {
                        String codeName = ""
                        for (int k = 0; k < analist.size(); k++) {
                            String city = analist.get(k).split('        ')[0]
                            String province = analist.get(k).split('        ')[1]
                            String code = analist.get(k).split('        ')[2]
                            String p = it.tradeRemark.split(';')[0]
                            String c = it.tradeRemark.split(';')[1]
                            c = c.replace("市", "")
                            if ((p == province) && (c == city)) {
                                codeName = code
                                break
                            }
                        }
                        sb.append(codeName + "|")

                    }
                    else {
                        sb.append("0000|")//若非工行,则为此 地区码
                    }
                    sb.append(it.tradeCardnum + "|")  //收款人账号
                    sb.append(it.tradeCardname + "|")//收款人名称
                    sb.append(((BigDecimal.valueOf(it.tradeAmount) * BigDecimal.valueOf(100)) as Long) + "|")//金额
                    sb.append(it.tradeRemark2 + "|")       //用途
                    sb.append("|")      //备注
                    sb.append("1|")    //汇款方式
                    sb.append("|")    //收款账户短信通知手机号码
                    sb.append("|")    //自定义序号

                }
                sb.append("\n*")
            } else if (boAcquirerAccount.bank.code.equalsIgnoreCase("abc")) {
                sb = ABCdfFile(list)
            }
            else if (boAcquirerAccount.bank.code.equalsIgnoreCase("boc")) {
                sb = BOCdfFile(list, boAcquirerAccount, tbPcInfo)
            } else if (boAcquirerAccount.bank.code.equalsIgnoreCase("unionpay")) { //银联
                sb = unionPayDfPay(list, tbPcInfo)
            }
        }
        render sb.toString()
    }

    /**
     * 打款批次管理 代收 下载
     */
    def downLoadAgentCollList = {

        def i = 0
        //def list = TbAgentpayDetailsInfo.findAllByDkPcNoAndPayStatus(params.id as int, '5')
        def query = {
            eq('dkPcNo', String.valueOf(params.id))
            not {'in'('payStatus', ['7', '9'])}
            order("id", "desc")
        }
        def list = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        TbPcInfo tbPcInfo = TbPcInfo.findById((params.id as int))
        String accNo = tbPcInfo.tbPcDkChanel//银行ID
        // def bank = BoBankDic.findById(accNo)
        BoAcquirerAccount boAcquirerAccount = BoAcquirerAccount.findById(accNo)
        def sb = new StringBuffer()
        if (boAcquirerAccount != null) {

            if (boAcquirerAccount.bank.code.equalsIgnoreCase("icbc")) { //工商银行
                response.setHeader("Content-disposition", "attachment; filename=" + new Date().format("yyyyMMddHHmm") + ".bit")
                response.contentType = "application/x-rarx-rar-compressed"
                response.setCharacterEncoding("GBK")
                String currency = ""
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd")
                String date = dateFormat.format(new Date())
                String allFlag = "1"
                String allAmount = (((BigDecimal.valueOf(tbPcInfo.tbPcAmount) * BigDecimal.valueOf(100)) as long)).toString()
                String allItems = (tbPcInfo.tbPcItems).toString()
                list.each {
                    if (currency == "") {
                        currency = ((TbAgentpayDetailsInfo) list.get(0)).tradeAmounttype.toString()
                    }
                }
                if (currency == "CNY") {
                    currency = "RMB"
                }
                sb.append("#总计信息：\n")
                sb.append("#金额精确到分\n")
                sb.append("#币种|日期|总计标志|总金额|总笔数|\n")
                sb.append(currency + "|" + date + "|" + allFlag + "|" + allAmount + "|" + allItems + "|\n")
                sb.append("#明细指令信息\n")
                sb.append("#币种|提交日期|明细标志|顺序号|付方开户行名|付方卡号|缴费编号|付方户名|收款单位开户行名|省份|收款方地区名|收款方地区代码|收款账号|协议编号|收款单位名称|付款金额|用途|备注|付款账户短信通知手机号码|自定义序号|是否工行账号|付方账号开户行行号|")

                list.each {
                    i++
                    sb.append("\n")
                    if (it.tradeAmounttype == 'CNY') {
                        sb.append("RMB" + "|")
                    }
                    //sb.append(it.tradeAmounttype.toString() + "|")
                    sb.append(((it.tradeSysdate.format("yyyyMMdd")) as String) + "|")
                    sb.append("2|")
                    sb.append(i.toString() + "|")   //顺序号
                    sb.append(it.tradeAccountname + it.tradeBranchbank + it.tradeSubbranchbank + "|")   //付方开户行名
                    sb.append(it.tradeCardnum + "|")   //付方卡号
                    sb.append(it.contractUsercode + "|")   //缴费编号
                    sb.append(it.tradeCardname + "|")   //付方户名

                    sb.append(boAcquirerAccount.bank.name + boAcquirerAccount.branchName + "|")   //收款帐号开户行名称
                    if (it.tradeAccountname == boAcquirerAccount.bank.name) {

                        sb.append("天津|")   //收款帐号省份名
                    } else {
                        sb.append("|")//非工商银行则空着
                    }
                    sb.append("天津市|")   //收款帐号地市名    (本公司)
                    if (it.tradeAccountname == boAcquirerAccount.bank.name) {
                        sb.append("0302|")   //收款帐号地区码 若是天津,则为0302
                    } else {
                        sb.append("0000|")
                    }
                    sb.append(boAcquirerAccount.bankAccountNo + "|")   //收款人帐号
                    sb.append(FarmConstants.ICBCcompactNo + "|")   //协议编号
                    sb.append(boAcquirerAccount.bankAccountName + "|")   //收款人名称
                    sb.append(((BigDecimal.valueOf(it.tradeAmount) * BigDecimal.valueOf(100)) as Long) + "|")   //金额
                    sb.append(it.tradeRemark2 + "|")   //汇款用途
                    sb.append("|")   //备注
                    sb.append("|")  //付款账户
                    sb.append("|")   //自定义序号
                    sb.append("1|")    //是否工行账号 (暂时写为1,必为工行账号)
                    sb.append("|")    //付方账号开户行行号

                }
                sb.append("\n*")
            } else if (boAcquirerAccount.bank.code.equalsIgnoreCase("unionpay")) { //银联
                sb = unionPayAgentPay(tbPcInfo, list)
            }
            else if (boAcquirerAccount.bank.code.equalsIgnoreCase("abc")) {
                sb = ABCdsFile(list)
            }
        }
        render sb.toString()
    }
    /**
     * 中国银联代付批量模板生成
     * @return
     */
    def unionPayDfPay(def list, def tbPcInfo) {
        def merId = FarmConstants.merchartNo //测试商户号((TbAgentpayDetailsInfo) list.get(0)).batchBizid.toString()
        def merDate = new Date().format("yyyyMMdd")
        def pcno = String.valueOf(tbPcInfo.id).substring(1)
        response.setHeader("Content-disposition", "attachment; filename=" + merId + "_" + merDate + "_" + pcno + ".txt")
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("GBK")
        StringBuffer sb = new StringBuffer()
        sb.append(merId + "|")
        sb.append(pcno + "|")
        sb.append(tbPcInfo.tbPcItems + "|")
        sb.append(((tbPcInfo.tbPcAmount.toBigDecimal() * 100) as Integer).toString())

        def i = 0
        list.each {
            if (i > 1000) {
                flash.message = "批次记录超过1000条,请重新生成批次!"
                throw new Exception("批次记录超过1000条,请重新生成批次!")
                return
            }
            sb.append("\n")
            sb.append(merDate + "|")//商户日期
            sb.append(String.valueOf(it.id).substring(1) + "|")//流水号
            sb.append(it.tradeCardnum + "|")//收款账号
            sb.append(it.tradeCardname + "|")
            if (it.tradeAccountname != "中国银行") {
                sb.append(it.tradeAccountname.replace("中国", "") + "|")
            } else {
                sb.append(it.tradeAccountname + "|")//开户行
            }

            sb.append(it.tradeRemark.split(";")[1] + "|")//省
            sb.append(it.tradeRemark.split(";")[0] + "|")//市
            sb.append(it.tradeSubbranchbank + "|")//支行名
            sb.append(((it.tradeAmount.toBigDecimal() * 100) as Integer).toString() + "|")
            sb.append(it.tradeRemark2 + "|")//用途
            if (it.tradeAccounttype == "0") {//私人
                sb.append("00")

            } else if (it.tradeAccounttype == "1") {
                sb.append("01")
            }


        }
        return sb
    }
    /**
     * 中国银联代收批量模板生成
     */
    def unionPayAgentPay = {tbPcInfo, list ->
        def unibankcodeList = analyzeUnibankcodeFile()  //解析地方代码-机构号
        def sb = new StringBuffer()
        boolean flag = true
        Date mapDate = new Date()
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd")
        String key = sdf.format(mapDate)
        if (map.get(key)) {
            int keyValue = Integer.parseInt(map.get(key).toString()) + 1
            if (keyValue <= 99) {
                if (keyValue <= 9) {
                    map.put(key, "0".concat(keyValue.toString()))
                } else {
                    map.put(key, keyValue.toString())
                }
            } else {
                flag = false
                flash.message = "当天下载次数超过上限不能再次下载，每天最多下载99次"
            }
        } else {
            map.put(key, "01")
        }
        if (flag) {
            def merId = FarmConstants.dsMerchartNo
            response.setHeader("Content-disposition", "attachment; filename=" + merId + "_" + new Date().format("yyyyMMdd") + "_" + String.valueOf(tbPcInfo.id).substring(1) + "_Q.txt")
            response.contentType = "application/x-rarx-rar-compressed"
            response.setCharacterEncoding("GBK")
            //头文件
            sb.append(merId + "|") //商户号
            sb.append(String.valueOf(tbPcInfo.id).substring(1) + "|") //批次号 当天唯一,01-99  具体业务逻辑有待处理
            sb.append(tbPcInfo.tbPcItems + "|")  // 总笔数
            sb.append(String.valueOf((tbPcInfo.tbPcAmount.toBigDecimal() * 100) as Integer)) //总金额
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd")
            String date = dateFormat.format(new Date())
            //明细
            list.each {
                sb.append("\n")
                sb.append(new Date().format("yyyyMMdd") + "|")
                sb.append(String.valueOf(it.id).substring(1) + "|")  //交易流水号
                for (int i = 0; i < unibankcodeList.size(); i++) {
                    if (it.tradeAccountname == unibankcodeList.get(i).split(" ")[0]) {
                        sb.append(unibankcodeList.get(i).split(" ")[1] + "|")//币种                     //开户号代号
                    }
                }
                if (it.tradeCardtype == null || it.tradeCardtype == "" || it.tradeCardtype == "00") {
                    sb.append("0|")       //卡折标志
                } else if (it.tradeCardtype == "01") {
                    sb.append("1|")
                }
                sb.append(it.tradeCardnum + "|")    //客户卡号
                sb.append(it.tradeCardname + "|")   //客户名称
                sb.append("01|") //身份类型非必须
                sb.append("130721198511221119|")  //证件号码      非必须
                sb.append(String.valueOf((it.tradeAmount.toBigDecimal() * 100) as Integer) + "|") //金额以分为单位
                sb.append(it.tradeRemark2 + "|")                        //备注
                sb.append("")                       //私有域   非必须
            }
        }
        return sb
    }

    /**
     * 手工对账
     */
    def handleCheck = {

        TbAgentpayDetailsInfoController tbAgentpayDetailsInfoController = new TbAgentpayDetailsInfoController()
        List bankList = tbAgentpayDetailsInfoController.bankChanelList('F')
        return [bankNameList: bankList]

    }
/**
 * 上传对账文件,开始后台对账 (代付)
 */
    def upload = {
        try {
            def url;
            def fileName;
            fileName = request.getFile("upload").getOriginalFilename();
            def extension = fileName.substring(fileName.indexOf(".") + 1)
            if (extension.equalsIgnoreCase("txt")) {
                url = uploadFile(request, "upload")//上传文件
            }
//            def url = uploadFile(request, "upload")//上传文件
//            def fileName = url.split('/')[2]//得到file
            def batchId = params.batchNo
            def batch = TbPcInfo.findById(batchId as long)
            if(!batch){
                flash.message = "不存在该批次，请确认"
                redirect(action: handleCheck)
                return
            }
            if(batch.tbPcDkStatus != '1' || batch.tbPcCheckStatus != '1' || batch.tbDealstyle == 'autoPay'){
                flash.message = "该批次不符合对账条件，请确认"
                redirect(action: handleCheck)
                return

            }
            if(batch.tbSfFlag != 'F'){
                flash.message = "该批次不符合付款类型，请确认"
                redirect(action: handleCheck)
                return
            }
            def resultList = TbAgentpayDetailsInfo.findAllByDkPcNoAndPayStatus(batchId, '5')
            if(!resultList){
                flash.message = "无相关条目进行对账!请确认是否已手动打款"
                redirect(action: handleCheck)
                return
            }
            /*
            def query = {
                eq("tbPcDkChanel", (params.tbPcDkChanel) as Integer)
                eq("tbPcCheckStatus", "1")//对未对账的进行对账
                eq("tbPcDkStatus", "1")//只对打款完成的进行对账
                order("id")
            }

            def tbPcInfoList = TbPcInfo.createCriteria().list(params, query)

            TbAgentpayDetailsInfo tbAgentpayDetailsInfo = new TbAgentpayDetailsInfo()
            List resultList = new ArrayList()
            tbPcInfoList.each {
                tbAgentpayDetailsInfo.dkPcNo = it.id
                tbAgentpayDetailsInfo.payStatus = '5'//打款完成即已处理的
                tbAgentpayDetailsInfo.tradeType = 'F'
                def list = TbAgentpayDetailsInfo.findAll(tbAgentpayDetailsInfo)
                // def list=TbAgentpayDetailsInfo.executeQuery(" from TbAgentpayDetailsInfo where  dkPcNo="+it.id+"and payStatus='5' and tradeType='F' order by dkPcNo")
                if (list != null) {
                    for (int k = 0; k < list.size(); k++) {
                        resultList.add(list.get(k))
                    }
                }
            }
             */
            //if (resultList.size() > 0) {
                //==读取文件，并且拆分===========

                def acc = BoAcquirerAccount.findById(params.tbPcDkChanel as Long)
                def bankCode = acc.bank.code
                def f
                def fileList

                if (fileName.startsWith("CCBG") && bankCode.equalsIgnoreCase("CCB")) {
                    fileList = new File(url).readLines("gbk")
                    f = CBBcheckMoneyG(fileList, resultList, 'F')//对公对账
                }
                else if (fileName.startsWith("CCBS")  && bankCode.equalsIgnoreCase("CCB")) {
                    fileList = new File(url).readLines("gbk")
                    f = CBBcheckMoneyS(fileList, resultList, 'F')//对私对账
                }
                else if (fileName.startsWith("batpaydetaildl")  && bankCode.equalsIgnoreCase("ICBC")) { //batpaydetaildl5    //工行代付
                    fileList = new File(url).readLines("gbk")
                    f = ICBCcheckMoney(fileList, resultList, 'F')
                }
                else if (fileName.startsWith("TransDetail")  && bankCode.equalsIgnoreCase("UNIONPAY")) {//中国银联回盘文件
                    fileList = new File(url).readLines("gbk")
                    f = unionPAYcheckMoney(fileList, resultList, 'F')
                }
                else if (fileName.substring(0, 4).equalsIgnoreCase("abcf")  && bankCode.equalsIgnoreCase("ABC")) { //直连农行代付
                    fileList = uploadFileUncheck();
                    f = dfABCCheckMoney(fileList, resultList, 'F')
                }
                else {
                    flash.message = "所选文件与对账渠道不符!"
                }
                if (f == "true") {
                    flash.message = "${message(code: 'default.updated.message', args: [message(code: 'tbPcInfo.label', default: '手工对账'), "对账完成!"])}"
                } else if (f == "false") {
                    flash.message = "手工对账失败!"
                }
            /*
            } else {
                flash.message = "无相关条目进行对账!请确认是否已手动打款"
            }
            */
            def items = TbAgentpayDetailsInfo.executeQuery("select count(*) as items from TbAgentpayDetailsInfo where dkPcNo='" + batchId + "' and tradeFeedbackcode is not null")
            if (batch.tbPcItems == items.get(0)) {
                batch.tbPcCheckStatus = '2'
                batch.save(flush: true, failOnError: true)
            }

            /*tbPcInfoList.each {//如果对账后明细数据和批次数一致,更新批次对账状态为已对账
                def items = TbAgentpayDetailsInfo.executeQuery("select count(*) as items from TbAgentpayDetailsInfo where dkPcNo='" + it.id + "' and payStatus in('6','7')")
                if (it.tbPcItems == items.get(0)) {
                    it.tbPcCheckStatus = '2'
                    it.save(flush: true, failOnError: true)
                }
            }*/
            redirect(action: handleCheck)
        }
        catch (Exception e) {
            e.printStackTrace()
            flash.message = "请确认对应文件格式正确性!"
            redirect(action: handleCheck)
        }

    }

    /**
     * 代付成功记账
     * @param tbAgentpayDetailsInfoTemp
     * @return
     */
    def sDealAccount(TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp) {

        if (tbAgentpayDetailsInfoTemp.tradeFeetype == "0") {//即扣的
            TbPcInfo tbPcInfo = TbPcInfo.get(tbAgentpayDetailsInfoTemp.getDkPcNo())

            BoAcquirerAccount boAcquirerAccount = BoAcquirerAccount.findById(tbPcInfo.getTbPcDkChanel())
            def toAccountNo = boAcquirerAccount.innerAcountNo//
            def tofeeAccNo = BoInnerAccount.findByKey('feeAcc').accountNo//平台手续费账户
            CmCustomer cmCustomer = CmCustomer.findByCustomerNo(tbAgentpayDetailsInfoTemp.getBatchBizid())
            BoCustomerService boCustomerService = new boss.BoCustomerService()
            boCustomerService.customerId = cmCustomer.id
            boCustomerService.serviceCode = "agentpay"
            boCustomerService = boss.BoCustomerService.find(boCustomerService)
            def fromAccountNo = boCustomerService.srvAccNo
            def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
            def commandNo1 = UUID.randomUUID().toString().replaceAll('-', '')
            def cmdList = accountClientService.buildTransfer(null, fromAccountNo, toAccountNo, tbAgentpayDetailsInfoTemp.tradeAmount.toBigDecimal() * 100, 'agentpay', tbAgentpayDetailsInfoTemp.id, '0', "代付对账成功即扣金额")
            //def transResult = accountClientService.batchCommand(commandNo, cmdList)
            if ((tbAgentpayDetailsInfoTemp.tradeFee * 100) as Integer != 0) {
                cmdList = accountClientService.buildTransfer(cmdList, fromAccountNo, tofeeAccNo, tbAgentpayDetailsInfoTemp.tradeFee.toBigDecimal() * 100, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代付对账成功即扣手续费")
            }

            def transResult = accountClientService.batchCommand(commandNo, cmdList)
            if (transResult.result == 'true') {
                print "成功"
            } else {
                throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                print "失败"
            }
        }
        else if (tbAgentpayDetailsInfoTemp.tradeFeetype == "1") {  //后返的
            CmCustomer cmCustomer = CmCustomer.findByCustomerNo(tbAgentpayDetailsInfoTemp.getBatchBizid())
            BoCustomerService boCustomerService = new BoCustomerService()
            boCustomerService.customerId = cmCustomer.id
            boCustomerService.serviceCode = "agentpay"
            boCustomerService = BoCustomerService.find(boCustomerService)
            def fromAccountNo = boCustomerService.srvAccNo //服务账户
            TbPcInfo tbPcInfo = TbPcInfo.get(tbAgentpayDetailsInfoTemp.getDkPcNo())
            BoAcquirerAccount boAcquirerAccount = BoAcquirerAccount.findById(tbPcInfo.getTbPcDkChanel())
            def toAccountNo = boAcquirerAccount.innerAcountNo//收单银行账户
            def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
            def cmdList = accountClientService.buildTransfer(null, fromAccountNo, toAccountNo, tbAgentpayDetailsInfoTemp.tradeAmount.toBigDecimal() * 100, 'agentpay', tbAgentpayDetailsInfoTemp.id, '0', "代付对账成功后返金额")
            def transResult = accountClientService.batchCommand(commandNo, cmdList)//金额记账

            if (transResult.result == 'true') {
                print "成功"
            } else {
                throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                print "失败"
            }
        }
    }

    def updateS = {   //改成功
        TbAgentpayDetailsInfo.executeUpdate(" update TbAgentpayDetailsInfo set payStatus='6' where id=" + params.id)
        redirect(action: "checkAmount", params: params)
    }
    def updateF = {  //改失败
        TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp = TbAgentpayDetailsInfo.get(params.id)
        TbAgentpayDetailsInfo.withTransaction {status ->
            try {
                if (tbAgentpayDetailsInfoTemp.tradeType == 'F') {
                    tbAgentpayDetailsInfoTemp.payStatus = '7'//对账失败,待退款
                    tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '失败'
                    tbAgentpayDetailsInfoTemp.tradeReason = "收款方账号异常"
                    tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                }
                else {
                    tbAgentpayDetailsInfoTemp.payStatus = '9'//对账失败,待退款   待收应为已退款
                    tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                    tbAgentpayDetailsInfoTemp.tradeDonedate = new Date()
                    tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '失败'
                    tbAgentpayDetailsInfoTemp.tradeReason = "收款方账号异常"
                    tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                    sendToSettle(tbAgentpayDetailsInfoTemp, false)
                }

            } catch (Exception e) {
                status.setRollbackOnly()
                log.warn(e.message, e)
                flash.message = e.message
                return
            }
        }
        if (tbAgentpayDetailsInfoTemp.tradeType == 'S') {
            flash.message = "批次号为" + tbAgentpayDetailsInfoTemp.dkPcNo + "明细交易号为" + tbAgentpayDetailsInfoTemp.id + "的记录 手工改失败成功!"
            //redirect(action: "skPcManage")
            redirect(action: "skitemShow",  id: tbAgentpayDetailsInfoTemp.dkPcNo)
        } else {
            flash.message = "批次号为" + tbAgentpayDetailsInfoTemp.dkPcNo + "明细交易号为" + tbAgentpayDetailsInfoTemp.id + "的记录 手工改失败成功!"
            //redirect(action: "dkPcManage")
            redirect(action: "itemShow", id: tbAgentpayDetailsInfoTemp.dkPcNo)
        }

    }
    //代收对账页
    def dsCheck = {
        TbAgentpayDetailsInfoController tbAgentpayDetailsInfoController = new TbAgentpayDetailsInfoController()
        List bankList = tbAgentpayDetailsInfoController.bankChanelList('S')
        return [bankNameList: bankList]
    }

    // 代收对账
    def dsUpload = {
        def url;
        def fileName;
        fileName = request.getFile("upload").getOriginalFilename();
        def extension = fileName.substring(fileName.indexOf(".") + 1)
        if (extension.equalsIgnoreCase("txt")) {
            url = uploadFile(request, "upload")//上传文件
        }
        def batchId = params.batchNo
            def batch = TbPcInfo.findById(batchId as long)
            if(!batch){
                flash.message = "不存在该批次，请确认"
                redirect(action: handleCheck)
                return
            }
            if(batch.tbPcDkStatus != '1' || batch.tbPcCheckStatus != '1' || batch.tbDealstyle == 'autoPay'){
                flash.message = "该批次不符合对账条件，请确认"
                redirect(action: handleCheck)
                return

            }
            if(batch.tbSfFlag != 'S'){
                flash.message = "该批次不符合收款类型，请确认"
                redirect(action: handleCheck)
                return
            }
            def resultList = TbAgentpayDetailsInfo.findAllByDkPcNoAndPayStatus(batchId, '5')
            if(!resultList){
                flash.message = "无相关条目进行对账!请确认是否已手动打款"
                redirect(action: handleCheck)
                return
            }

        /*def query = {
            eq("tbPcDkChanel", (params.tbPcDkChanel) as Integer)
            eq("tbPcCheckStatus", "1")//对未对账的进行对账
            eq("tbPcDkStatus", "1")//只对打款完成的进行对账
            order("id")
        }
        def tbPcInfoList = TbPcInfo.createCriteria().list(params, query)
        TbAgentpayDetailsInfo tbAgentpayDetailsInfo = new TbAgentpayDetailsInfo()
        List resultList = new ArrayList()
        tbPcInfoList.each {
            tbAgentpayDetailsInfo.dkPcNo = it.id
            tbAgentpayDetailsInfo.payStatus = '5'//打款完成即已处理的
            tbAgentpayDetailsInfo.tradeType = 'S'//代收的
            List list = TbAgentpayDetailsInfo.findAll(tbAgentpayDetailsInfo)
            if (list != null) {
                for (int k = 0; k < list.size(); k++) {
                    resultList.add(list.get(k))
                }
            }
        }*/
        try {
            //if (resultList.size > 0) {
                def acc = BoAcquirerAccount.findById(params.tbPcDkChanel as Long)
                def bankCode = acc.bank.code

                def f
                def fileList
                if (fileName.startsWith("batchintrdetails") && bankCode.equalsIgnoreCase("ICBC")) {//batchintrdetails4    工行代收
                    fileList = new File(url).readLines("gbk")
                    f = dsICBCCheckMoney(fileList, resultList, 'S')
                } else if (fileName.startsWith("withhold") && bankCode.equalsIgnoreCase("UNIONPAY")) {//银联代收 excel对账
                    fileList = uploadFileUncheck();
                    f = dsUNIONCheckMoney(fileList, resultList, 'S')
                } else if (fileName.substring(0, 4).equalsIgnoreCase("abcs") && bankCode.equalsIgnoreCase("ABC")) {
                    fileList = uploadFileUncheck();
                    f = dsABCCheckMoney(fileList, resultList, 'S')
                } else {
                    flash.message = "所选文件与打款渠道不符!"
                }
                if (f == "true") {
                    flash.message = "${message(code: 'default.updated.message', args: [message(code: 'tbPcInfo.label', default: '手工对账'), "对账完成!"])}"
                } else if (f == "false") {
                    flash.message = "手工对账失败!"
                }

            def items = TbAgentpayDetailsInfo.executeQuery("select count(*) as items from TbAgentpayDetailsInfo where dkPcNo='" + batchId + "' and tradeFeedbackcode is not null")
            if (batch.tbPcItems == items.get(0)) {
                batch.tbPcCheckStatus = '2'
                batch.save(flush: true, failOnError: true)
            }
            /*
            } else {
                flash.message = "无相应对账条目!请确认是否已手动打款"
            }
            */
            redirect(action: dsCheck)
        } catch (Exception e) {
            e.printStackTrace()
            flash.message = "请确认对应文件格式正确性!"
            redirect(action: dsCheck)
        }

        /*
        tbPcInfoList.each {//如果对账后明细数据和批次数一致,更新批次对账状态为已对账
            def items = TbAgentpayDetailsInfo.executeQuery("select count(*) as items from TbAgentpayDetailsInfo where dkPcNo='" + it.id + "' and payStatus in('6','9')")
            if (it.tbPcItems == items.get(0)) {
                it.tbPcCheckStatus = '2'
                it.save(flush: true, failOnError: true)
            }
        }
        */
    }
    //代收成功记账

    def dsSRemMoney(TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp) {
        // if (tbAgentpayDetailsInfoTemp.tradeFeetype == "0") {//即扣的
        TbPcInfo tbPcInfo = TbPcInfo.get(tbAgentpayDetailsInfoTemp.getDkPcNo())
        BoAcquirerAccount boAcquirerAccount = BoAcquirerAccount.findById(tbPcInfo.getTbPcDkChanel())
        def fromAccountNo = boAcquirerAccount.innerAcountNo//  收单银行账户
        // def tofeeAccNo = BoInnerAccount.findByKey('feeAcc').accountNo//平台手续费账户
        CmCustomer cmCustomer = CmCustomer.findByCustomerNo(tbAgentpayDetailsInfoTemp.getBatchBizid())
        BoCustomerService boCustomerService = new boss.BoCustomerService()
        boCustomerService.customerId = cmCustomer.id
        boCustomerService.serviceCode = "agentcoll"
        boCustomerService = boss.BoCustomerService.find(boCustomerService)
        def toAccountNo = boCustomerService.srvAccNo//商户服务账户
        def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
        // def commandNo1 = UUID.randomUUID().toString().replaceAll('-', '')
        print((tbAgentpayDetailsInfoTemp.tradeAmount as BigDecimal) * 100) as Integer
        def cmdList = accountClientService.buildTransfer(null, fromAccountNo, toAccountNo, (tbAgentpayDetailsInfoTemp.tradeAmount.toBigDecimal() * 100) as Integer, 'agentcoll', tbAgentpayDetailsInfoTemp.id, '0', "代收对账成功即扣金额")
        //  cmdList = accountClientService.buildTransfer(null, toAccountNo, tofeeAccNo, tbAgentpayDetailsInfoTemp.tradeFee.toBigDecimal() * 100, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代收对账成功即扣手续费")
        def transResult = accountClientService.batchCommand(commandNo, cmdList)
        if (transResult.result == 'true') {
            print "成功"
        } else {
            throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
            print "失败"
        }
        // }
//        else if (tbAgentpayDetailsInfoTemp.tradeFeetype == "1") {  //后返的
//            CmCustomer cmCustomer = CmCustomer.findByCustomerNo(tbAgentpayDetailsInfoTemp.getBatchBizid())
//            BoCustomerService boCustomerService = new BoCustomerService()
//            boCustomerService.customerId = cmCustomer.id
//            boCustomerService.serviceCode = "agentcoll"
//            boCustomerService = BoCustomerService.find(boCustomerService)
//            def toAccountNo = boCustomerService.srvAccNo //服务账户
//            TbPcInfo tbPcInfo = TbPcInfo.get(tbAgentpayDetailsInfoTemp.getDkPcNo())
//            BoAcquirerAccount boAcquirerAccount = BoAcquirerAccount.findById(tbPcInfo.getTbPcDkChanel())
//            def fromAccountNo = boAcquirerAccount.innerAcountNo//收单银行账户
//            def commandNo = UUID.randomUUID().toString().replaceAll('-', '')
//            def cmdList = accountClientService.buildTransfer(null, fromAccountNo, toAccountNo, (tbAgentpayDetailsInfoTemp.tradeAmount.toBigDecimal() * 100) as Integer, 'agentcoll', tbAgentpayDetailsInfoTemp.id, '0', "代收对账成功后返金额")
//            def transResult = accountClientService.batchCommand(commandNo, cmdList)//金额记账
//
//            if (transResult.result == 'true') {
//                print "成功"
//            } else {
//                throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
//                print "失败"
//            }
//        }
    }
    /**
     * wa 代收失败记账
     * @param tbAgentpayDetailsInfoTemp
     * @return
     */
    /*def dsFDealAccount(TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp) {
        if (tbAgentpayDetailsInfoTemp.tradeFeetype == "0") {//即扣的
            def tofeeAccNo = BoInnerAccount.findByKey('feeAcc').accountNo//平台手续费账户
            CmCustomer cmCustomer = CmCustomer.findByCustomerNo(tbAgentpayDetailsInfoTemp.getBatchBizid())
            def toAccountNo = cmCustomer.accountNo//商户现金账户
            BoCustomerService boCustomerService = new BoCustomerService()
            boCustomerService.customerId = cmCustomer.id
            boCustomerService.serviceCode = "agentcoll"
            boCustomerService = BoCustomerService.find(boCustomerService)
            def fromAccountNo = boCustomerService.srvAccNo //商户服务账户
            def commandNo1 = UUID.randomUUID().toString().replaceAll('-', '')
            def cmdfeeList
            if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {
                cmdfeeList = accountClientService.buildTransfer(null, fromAccountNo, toAccountNo, tbAgentpayDetailsInfoTemp.tradeFee.toBigDecimal() * 100, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代收对账失败退手续费")
            } else {
                cmdfeeList = accountClientService.buildTransfer(null, fromAccountNo, tofeeAccNo, tbAgentpayDetailsInfoTemp.tradeFee.toBigDecimal() * 100, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代收对账失败退手续费")
            }
            def transfeeResult = accountClientService.batchCommand(commandNo1, cmdfeeList)
            if (transfeeResult.result == "true") {
                print "成功"
            } else {
                throw new Exception("账务和清结算账务处理失败!错误原因:" + transfeeResult.errorMsg)
                print "失败"
            }
        }
        else if (tbAgentpayDetailsInfoTemp.tradeFeetype == "1") {  //后返的
            def commandNo1 = UUID.randomUUID().toString().replaceAll('-', '')
            CmCustomer cmCustomer = CmCustomer.findByCustomerNo(tbAgentpayDetailsInfoTemp.getBatchBizid())
            BoCustomerService boCustomerService = new BoCustomerService()
            boCustomerService.customerId = cmCustomer.id
            boCustomerService.serviceCode = "agentcoll"
            boCustomerService = BoCustomerService.find(boCustomerService)
            def fromSysAccNo = BoInnerAccount.findByKey('feeInAdvance').accountNo//系统应收手续费账号
            def toQkAccNo = boCustomerService.feeAccNo//商户欠款账户
            def cmdfeeList
            def transfeeResult
            if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {  // 若退手续费刚下,若不退,则不动了
                cmdfeeList = accountClientService.buildTransfer(null, fromSysAccNo, toQkAccNo, tbAgentpayDetailsInfoTemp.tradeFee.toBigDecimal() * 100, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代收对账失败即扣手续费")
                transfeeResult = accountClientService.batchCommand(commandNo1, cmdfeeList)
                if (transfeeResult.result == "true") {
                print "成功" + "==================="
                } else {
                    throw new Exception("账务和清结算账务处理失败!错误原因:" + transfeeResult.errorMsg)
                    print "失败"
                }
            }


        }
    }*/

    def autodk = {
        handledk()
        //连接银行接口
        redirect(action: dkPcManage)
    }
    def handledk = {
        TbPcInfo.executeUpdate(" update TbPcInfo set tbPcDkStatus ='1',tbPcCheckStatus='1' where id=" + params.id)
        TbAgentpayDetailsInfo.executeUpdate(" update TbAgentpayDetailsInfo set payStatus='5' where dkPcNo=" + params.id)

        if (params.sk == "sk") {
            redirect(action: skPcManage)
        } else {
            redirect(action: dkPcManage)
        }

    }

    String uploadFile(HttpServletRequest request, String name) {
        def f = request.getFile(name)//得到file
        def url
        if (!f.empty) {

            def fileName = f.getOriginalFilename();//得到文件名称

            if (fileName.endsWith(".txt")) {
                def filePath = "grails-app/upload/";//设置上传路径
                url = filePath + fileName//文件上传的路径+文件名
                def file = new File(filePath + fileName);
                file.mkdirs()//如果file不存在自动创建
                f.transferTo(file) //上传
            }

        }
        return url
    }

    def CBBcheckMoneyG(def fileList, List resultList, def dsfFlag) {   //建行对公对账  (代付)
        def f = "false"
        for (int i = 0; i < fileList.size(); i++) {
            def s = fileList.get(i)//.replace(' ', '')
            if (s.trim() == "") {break}
            def ss = s.split('\\|')
            def cardNo = ss[13].trim()
            def name = ss[12].trim()
            def amount = ss[4].trim()
            amount = Double.parseDouble(amount)
            def status1 = ss[16].trim()//成功或失败
            def reson = ""
            if (status1 != "成功") {
                reson = "收款方账号异常!"//暂无失败原因
            }

            for (int j = 0; j < resultList.size(); j++) {
                def object = resultList.get(j)
                def card = object.tradeCardnum
                boolean fl = (card == cardNo)
                boolean fll = (name == object.tradeCardname)
                boolean flll = (amount == object.tradeAmount)
                boolean flag = (fl && fll && flll)
                if (flag) {
                    TbAgentpayDetailsInfo.withTransaction {status ->
                        try {
                            f = "true"
                            log.info 'CCB F G SUCCESS [CN:' + cardNo + ',TID:' + object.id + ']'
                            TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp = TbAgentpayDetailsInfo.get(object.id)
                            if (status1 == "成功") {
                                tbAgentpayDetailsInfoTemp.payStatus = '6'
                                tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                                tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '成功'
                                tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                                sDealAccount(tbAgentpayDetailsInfoTemp)
                            } else {
                                tbAgentpayDetailsInfoTemp.payStatus = '7'//对账失败,待退款
                                tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '失败'
                                tbAgentpayDetailsInfoTemp.tradeReason = reson
                                tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                            }

                        } catch (Exception e) {
                            status.setRollbackOnly()
                            log.warn(e.message, e)
                            flash.message = e.message
                            f = e.message
                            return
                        }
                    }
                    resultList.remove(j)
                    break
                }
            }
        }
        return f
    }

    def CBBcheckMoneyS(def fileList, List resultList, def dsfFlag) {   //建行对私对账  (代付)
        def f = "false"
        for (int i = 0; i < fileList.size(); i++) {
            def s = fileList.get(i)//.replace(' ', '')
            if (s.trim() == "") {break}
            def ss = s.split('\\|')
            def cardNo = ss[0].trim()
            def name = ss[1].trim()
            def amount = ss[2].trim()
            amount = Double.parseDouble(amount)
            def status1 = ss[3].trim()//成功或失败
            def reson = ""
            if (status1 != "成功") {
                reson = ss[4]
            }

            for (int j = 0; j < resultList.size(); j++) {
                def object = resultList.get(j)
                def card = object.tradeCardnum
                boolean fl = (card == cardNo)
                boolean fll = (name == object.tradeCardname)
                boolean flll = (amount == object.tradeAmount)
                boolean flag = (fl && fll && flll)
                if (flag) {
                    TbAgentpayDetailsInfo.withTransaction {status ->
                        try {
                            f = "true"
                            log.info 'CCB F S SUCCESS [CN:' + cardNo + ',TID:' + object.id + ']'
                            TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp = TbAgentpayDetailsInfo.get(object.id)
                            if (status1 == "成功") {
                                tbAgentpayDetailsInfoTemp.payStatus = '6'
                                tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                                tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '成功'
                                tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                                sDealAccount(tbAgentpayDetailsInfoTemp)
                            } else {
                                tbAgentpayDetailsInfoTemp.payStatus = '7'//对账失败,待退款
                                tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '失败'
                                tbAgentpayDetailsInfoTemp.tradeReason = reson
                                tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                            }

                        } catch (Exception e) {
                            status.setRollbackOnly()
                            log.warn(e.message, e)
                            flash.message = e.message
                            f = e.message
                            return
                        }
                    }
                    resultList.remove(j)
                    break
                }
            }
        }
        return f
    }

    def ICBCcheckMoney(def fileList, List resultList, def dsfFlag) {   //DF工行对账
        def f = "false"

        for (int i = 0; i < fileList.size(); i++) {
            if (i == 0) {
                def date = fileList.get(i)
            }
            if (i >= 4) {
                def s = fileList.get(i)//.replace(' ', '')
                if (s.trim() == "") {break}
                def ss = s.split('\\|')
                def cardNo = ss[2].trim()
                def name = ss[3].trim()
                def amount = String.valueOf(ss[6]).replace('元', '').replace(",", "")
                amount = Double.parseDouble(amount)
                def status1 = ss[8].trim()//成功或失败
                def reson = ""
                if (status1 != "处理成功") {
                    if (ss[9].contains(":")) {
                        reson = ss[9].split(":")[1]
                    } else {
                        reson = ss[9]
                    }
                }

                for (int j = 0; j < resultList.size(); j++) {
                    def object = resultList.get(j)
                    def card = object.tradeCardnum.replace(" ", "")
                    boolean fl = (card == cardNo)
                    boolean fll = (name == object.tradeCardname.replace(" ", ""))
                    boolean flll = (amount == object.tradeAmount)
                    boolean flag = (fl && fll && flll)
                    if (flag) {
                        TbAgentpayDetailsInfo.withTransaction {status ->
                            try {
                                f = "true"
                                log.info 'ICBC F SUCCESS [CN:' + cardNo + ',TID:' + object.id + ']'
                                TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp = TbAgentpayDetailsInfo.get(object.id)
                                if (status1 == "处理成功") {
                                    tbAgentpayDetailsInfoTemp.payStatus = '6'
                                    tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                                    tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '成功'
                                    tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                                    sDealAccount(tbAgentpayDetailsInfoTemp)
                                } else {
                                    tbAgentpayDetailsInfoTemp.payStatus = '7'//对账失败,待退款
                                    tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '失败'
                                    tbAgentpayDetailsInfoTemp.tradeReason = reson
                                    tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                                }

                            }
                            catch (Exception e) {
                                //roll back
                                status.setRollbackOnly()
                                log.warn(e.message, e)
                                flash.message = e.message
                                f = e.message


                                return
                            }

                        }
                        resultList.remove(j)
                        break
                    }

                }

            }
        }


        return f
    }


    def dsICBCCheckMoney(def fileList, List resultList, def dsfFlag) {   //代收工行对账
        def f = "false"
        /* TbPcInfo.withTransaction {status ->
       try {*/

        for (int i = 0; i < fileList.size(); i++) {
            if (i == 1) {
                def date = fileList.get(i).split(':')[1]
            }
            if (i >= 5) {
                def s = fileList.get(i)//.replace(' ', '')
                if (s.trim() == "") {break}
                def ss = s.split('\\|')
                def cardNo = ss[7].trim()
                def name = ss[8].trim()
                def amount = String.valueOf(ss[9]).replace('元', '').replace(",", "")
                amount = Double.parseDouble(amount)
                def status1 = ss[11].trim()//处理成功或处理失败
                def reson = ""
                if (status1 != "处理成功") {
                    // reson ="付款方账号异常!"// ss[12]
                    if (ss[11].contains(":")) {
                        reson = ss[11].split(":")[1]
                    } else {
                        reson = ss[11]
                    }
                }
                for (int j = 0; j < resultList.size(); j++) {
                    def object = resultList.get(j)
                    def card = object.tradeCardnum
                    boolean fl = (card == cardNo)
                    boolean fll = (name == object.tradeCardname)
                    boolean flll = (amount == object.tradeAmount)
                    boolean flag = (fl && fll && flll)

                    if (flag) {
                        TbAgentpayDetailsInfo.withTransaction {status ->
                            try {
                                javax.jms.MapMessage message = jmsService.createMapMessage()
                                jmsService.send(message)
                                log.info 'ICBC S SUCCESS [CN:' + cardNo + ',TID:' + object.id + ']'
                                TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp = TbAgentpayDetailsInfo.get(object.id)
                                if (status1 == "处理成功") {
                                    tbAgentpayDetailsInfoTemp.payStatus = '6'
                                    tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                                    tbAgentpayDetailsInfoTemp.tradeDonedate = new Date()
                                    tbAgentpayDetailsInfoTemp.sendStatus = '1'
                                    tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '成功'
                                    tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                                    dsSRemMoney(tbAgentpayDetailsInfoTemp)
                                    sendToSettle(tbAgentpayDetailsInfoTemp, true)
                                    f = "true"
                                } else {
                                    tbAgentpayDetailsInfoTemp.payStatus = '9'//对账失败,待退款   待收应为已退款
                                    tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                                    tbAgentpayDetailsInfoTemp.tradeDonedate = new Date()
                                    tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '失败'
                                    tbAgentpayDetailsInfoTemp.tradeReason = reson
                                    tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                                    //dsFDealAccount(tbAgentpayDetailsInfoTemp)//开始记账
                                    sendToSettle(tbAgentpayDetailsInfoTemp, false)
                                    f = "true"
                                }
                            } catch (Exception e) {
                                status.setRollbackOnly()
                                log.warn(e.message, e)
                                flash.message = e.message
                                f = e.message
                                return
                            }
                        }
                        resultList.remove(j)
                        break
                    }

                }
            }
        }
        return f
    }

    def dsUNIONCheckMoney(def fileList, List resultList, def dsfFlag) {   //代收银联对账
        //==========
        def filepath = request.getRealPath("/") + "Uploadfile" + File.separator + "chinapayReCode.properties"
        Properties p = new Properties();
        FileInputStream inputFile
        inputFile = new FileInputStream(filepath);

        try {
            p.load(inputFile);
        } catch (IOException e1) {
            e1.printStackTrace();
        }
        //==========
        def f = "false"
        for (int i = 0; i < fileList.size(); i++) {
            def ss = fileList.get(i)
            if (ss.size() < 13) {break;}
            def bcardNo = ss[12].replace("****", ",").split(",")[0]
            def ecardNo = ss[12].replace("****", ",").split(",")[1]
            def name = ss[13]
            def amount = ss[5]
            def status1 = ss[8]//处理成功或处理失败
            def reason = "无对应返回码！"
            String con = p.getProperty(status1);
            if (con) {
                String resultName = new String(con.getBytes("ISO-8859-1"), "gbk");
                reason = resultName
            }
            for (int j = 0; j < resultList.size(); j++) {
                def object = resultList.get(j)
                def card = object.tradeCardnum.trim()
                boolean fl = (card.startsWith(bcardNo) && card.endsWith(ecardNo))
                boolean fll = (name == object.tradeCardname.trim())
                boolean flll = (amount == (object.tradeAmount.toBigDecimal()))
                boolean flag = (fl && fll && flll)

                if (flag) {
                    TbAgentpayDetailsInfo.withTransaction {status ->
                        try {
                            javax.jms.MapMessage message = jmsService.createMapMessage()
                            jmsService.send(message)
                            log.info 'UNION S SUCCESS [CN:' + cardNo + ',TID:' + object.id + ']'
                            TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp = TbAgentpayDetailsInfo.get(object.id)
                            if (status1 == "00") {
                                tbAgentpayDetailsInfoTemp.payStatus = '6'
                                tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                                tbAgentpayDetailsInfoTemp.tradeDonedate = new Date()
                                tbAgentpayDetailsInfoTemp.sendStatus = '1'
                                tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '成功'
                                tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                                dsSRemMoney(tbAgentpayDetailsInfoTemp)
                                sendToSettle(tbAgentpayDetailsInfoTemp, true)
                                f = "true"


                            } else {
                                tbAgentpayDetailsInfoTemp.payStatus = '9'//对账失败,待退款   待收应为已退款
                                tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                                tbAgentpayDetailsInfoTemp.tradeDonedate = new Date()
                                tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '失败'
                                tbAgentpayDetailsInfoTemp.tradeReason = reason
                                tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                                sendToSettle(tbAgentpayDetailsInfoTemp, false)
                                f = "true"
                            }
                        }
                        catch (Exception e) {
                            status.setRollbackOnly()
                            log.warn(e.message, e)
                            flash.message = e.message
                            f = e.message
                            return
                        }
                    }   //
                    resultList.remove(j)
                    break
                }

            }

        }
        return f
    }
    //农行代收对账（EXCEL）

    def dsABCCheckMoney(def fileList, List resultList, def dsfFlag) {   //代收银联对账

        def f = "false"
        for (int i = 0; i < fileList.size(); i++) {
            def ss = fileList.get(i)
            def cardNo = ss[4]
            def name = ss[5]
            def amount = ss[7].replace(",", "")
            def status1 = ss[9]//处理成功或处理失败
            def reason = ss[10]
            for (int j = 0; j < resultList.size(); j++) {
                def object = resultList.get(j)
                def card = object.tradeCardnum.trim()
                boolean fl = (card == cardNo)
                boolean fll = (name == object.tradeCardname.trim())
                boolean flll = (Double.valueOf(amount) == (object.tradeAmount))//农行文件金额是字符串型的
                boolean flag = (fl && fll && flll)

                if (flag) {
                    TbAgentpayDetailsInfo.withTransaction {status ->
                        try {
                            javax.jms.MapMessage message = jmsService.createMapMessage()
                            jmsService.send(message)
                            log.info 'ABC S SUCCESS [CN:' + cardNo + ',TID:' + object.id + ']'
                            TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp = TbAgentpayDetailsInfo.get(object.id)
                            if (status1.contains("成功")) {
                                tbAgentpayDetailsInfoTemp.payStatus = '6'
                                tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                                tbAgentpayDetailsInfoTemp.tradeDonedate = new Date()
                                tbAgentpayDetailsInfoTemp.sendStatus = '1'
                                tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '成功'
                                tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                                dsSRemMoney(tbAgentpayDetailsInfoTemp)
                                sendToSettle(tbAgentpayDetailsInfoTemp, true)
                                f = "true"


                            } else {
                                tbAgentpayDetailsInfoTemp.payStatus = '9'//对账失败,待退款   待收应为已退款
                                tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                                tbAgentpayDetailsInfoTemp.tradeDonedate = new Date()
                                tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '失败'
                                tbAgentpayDetailsInfoTemp.tradeReason = reason
                                tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                                sendToSettle(tbAgentpayDetailsInfoTemp, false)
                                f = "true"
                            }
                        }
                        catch (Exception e) {
                            status.setRollbackOnly()
                            log.warn(e.message, e)
                            flash.message = e.message
                            f = e.message
                            return
                        }
                    }   //
                    resultList.remove(j)
                    break
                }

            }

        }
        return f
    }
    //农行代付对账（EXCEL）

    def dfABCCheckMoney(def fileList, List resultList, def dsfFlag) {

        def f = "false"
        for (int i = 0; i < fileList.size(); i++) {
            def ss = fileList.get(i)
            def cardNo = ss[4]
            def name = ss[5]
            def amount = ss[7].replace(",", "")
            def status1 = ss[9]//处理成功或处理失败
            def reason = ss[10]
            for (int j = 0; j < resultList.size(); j++) {
                def object = resultList.get(j)
                def card = object.tradeCardnum.trim()
                boolean fl = (card == cardNo)
                boolean fll = (name == object.tradeCardname.trim())
                boolean flll = (Double.valueOf(amount) == (object.tradeAmount))
                boolean flag = (fl && fll && flll)
                if (flag) {
                    TbAgentpayDetailsInfo.withTransaction {status ->
                        try {
                            log.info 'ABC F SUCCESS [CN:' + cardNo + ',TID:' + object.id + ']'
                            TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp = TbAgentpayDetailsInfo.get(object.id)
                            if (status1.contains("成功")) {
                                tbAgentpayDetailsInfoTemp.payStatus = '6'
                                tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                                tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '成功'
                                tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                                sDealAccount(tbAgentpayDetailsInfoTemp)
                                f = "true"
                            } else {
                                tbAgentpayDetailsInfoTemp.payStatus = '7'//对账失败,待退款
                                tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '失败'
                                tbAgentpayDetailsInfoTemp.tradeReason = reason
                                tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                                f = "true"
                            }
                        }
                        catch (Exception e) {
                            status.setRollbackOnly()
                            log.warn(e.message, e)
                            flash.message = e.message
                            f = e.message
                            return
                        }
                    }   //
                    resultList.remove(j)
                    break
                }

            }

        }
        return f
    }

    def analyzeFile = {

        List list = new ArrayList()
        def path = request.getRealPath("/") + File.separator + "Uploadfile" + File.separator

        def fileList = new File(path + "bankAreaCode").readLines("utf-8")
        if (fileList != null) {
            for (int i = 3; i < fileList.size(); i++) {
                list.add(fileList.get(i))
            }
        }
        return list
    }

    def analyzeDfcodeFile = {

        List list = new ArrayList()
        def path = request.getRealPath("/") + File.separator + "Uploadfile" + File.separator

        def fileList = new File(path + "dfcode").readLines("utf-8")
        if (fileList != null) {
            for (int i = 0; i < fileList.size(); i++) {
                list.add(fileList.get(i))
            }
        }
        return list
    }


    def analyzeBusybankcodeFile = {

        List list = new ArrayList()
        def path = request.getRealPath("/") + File.separator + "Uploadfile" + File.separator

        def fileList = new File(path + "busybankcode").readLines("utf-8")
        if (fileList != null) {
            for (int i = 0; i < fileList.size(); i++) {
                list.add(fileList.get(i))
            }
        }
        return list
    }
    def analyzeUnibankcodeFile = {

        List list = new ArrayList()
        def path = request.getRealPath("/") + File.separator + "Uploadfile" + File.separator

        def fileList = new File(path + "unibankcode").readLines("utf-8")
        if (fileList != null) {
            for (int i = 0; i < fileList.size(); i++) {
                list.add(fileList.get(i))
            }
        }
        return list
    }

    def bankList(def flag) {
        def con = dataSource_boss.getConnection()
        def db = new groovy.sql.Sql(con)
        TbBindBank tbBindBank = new TbBindBank()
        tbBindBank.dsfFlag = flag
        List list = TbBindBank.findAll(tbBindBank)
        BoAcquirerAccount boAcquirerAccount = new BoAcquirerAccount()
        List bankList = new ArrayList()
        String no = ""
        for (int i = 0; i < list.size(); i++) {
            no = no + "'"

            no = no + list.get(i).bankAccountno + "'"
            if (i < list.size() - 1) {
                no = no + ','
            }
        }
        def bankList1 = BoAcquirerAccount.executeQuery("select distinct a.id as id ,a.name as name from BoBankDic  a,BoAcquirerAccount t where  t.bankAccountNo in (" + no + ") and t.bank.id=a.id and t.status='normal'")
        db.close()
        if (bankList1 != null) {
            for (int j = 0; j < bankList1.size(); j++) {
                BoBankDic bankDic = new BoBankDic()
                bankDic.id = bankList1.get(j)[0]
                bankDic.name = bankList1.get(j)[1]
                bankList.add(bankDic)
            }
        }

        return bankList
    }

    def bankList() {
        def con = dataSource_boss.getConnection()
        def db = new groovy.sql.Sql(con)
        TbBindBank tbBindBank = new TbBindBank()
        def list = TbBindBank.executeQuery("select distinct t.bankAccountno from TbBindBank t ")
        BoAcquirerAccount boAcquirerAccount = new BoAcquirerAccount()
        List bankList = new ArrayList()
        String no = ""
        for (int i = 0; i < list.size(); i++) {
            no = no + "'"
            no = no + list.get(i) + "'"
            if (i < list.size() - 1) {
                no = no + ','
            }
            boAcquirerAccount = BoAcquirerAccount.find("from BoAcquirerAccount where bankAccountNo='" + list.get(i) + "' and status='normal'")
        }
        db.close()

        def bankList1 = BoAcquirerAccount.executeQuery("select distinct a.id as id ,a.name as name from BoBankDic  a,BoAcquirerAccount t where  t.bankAccountNo in (" + no + ") and t.bank.id=a.id and t.status='normal'")
        db.close()
        if (bankList1 != null) {
            for (int j = 0; j < bankList1.size(); j++) {
                BoBankDic bankDic = new BoBankDic()
                bankDic.id = bankList1.get(j)[0]
                bankDic.name = bankList1.get(j)[1]
                bankList.add(bankDic)
            }
        }
        return bankList
    }

    def bankChanelList(def flag) {
        TbBindBank tbBindBank = new TbBindBank()
        tbBindBank.dsfFlag = flag
        List list = TbBindBank.findAll(tbBindBank)
        List bankChanelList = new ArrayList()

        for (int i = 0; i < list.size(); i++) {

            String no = list.get(i).bankAccountno
            def boList = BoAcquirerAccount.findAll("from BoAcquirerAccount where bankAccountNo='" + no + "' and status='normal'")
            for (int j = 0; j < boList.size(); j++) {
                //boList.get(j).aliasName=boList.get(j).bank.name+"-"+boList.get(j).aliasName
                bankChanelList.add(boList.get(j))
            }
        }
        return bankChanelList
    }

    def bankChanelList() {

        List list = TbBindBank.executeQuery("select distinct t.bankAccountno as bankAccountno from TbBindBank t")
        List bankChanelList = new ArrayList()
        for (int i = 0; i < list.size(); i++) {
            String no = list.get(i)
            def boList = BoAcquirerAccount.findAll("from BoAcquirerAccount where bankAccountNo='" + no + "' and status='normal'")
            for (int j = 0; j < boList.size(); j++) {
                bankChanelList.add(boList.get(j))
            }
        }
        return bankChanelList
    }

    def unionPAYcheckMoney(def fileList, List resultList, def dsfFlag) {   //DF银联对账
        def f = "false"

        for (int i = 1; i < fileList.size(); i++) {
            def s = fileList.get(i)
            if (s == "") {break}
            def ss = s.split('\\|')
            def cardNo = ss[9].trim()
            def name = ss[10].trim()
            def amount = ss[12]
            amount = Double.parseDouble(amount)
            def status1 = ss[8].trim()//成功或失败  //银联无确切的成功状态
            def reson = ""
            if (status1 != "s") {  //5已发送到银行 6银行已退单 s交易成功
                reson = "收款方账号异常!"// ss[10]
            }
            for (int j = 0; j < resultList.size(); j++) {
                def object = resultList.get(j)
                def card = object.tradeCardnum.replace(" ", "")
                boolean fl = (card == cardNo)
                boolean fll = (name == object.tradeCardname.replace(" ", ""))

                boolean flll = (amount == (object.tradeAmount.toBigDecimal() * 100))
                boolean flag = (fl && fll && flll)
                if (flag) {
                    TbAgentpayDetailsInfo.withTransaction {status ->
                        try {
                            f = "true"
                            log.info 'UNION F SUCCESS [CN:' + cardNo + ',TID:' + object.id + ']'
                            TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp = TbAgentpayDetailsInfo.get(object.id)
                            if (status1 == "s") {
                                tbAgentpayDetailsInfoTemp.payStatus = '6'
                                tbAgentpayDetailsInfoTemp.tradeStatus = '2'
                                tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '成功'
                                tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                                sDealAccount(tbAgentpayDetailsInfoTemp)
                            } else if (status1 == '6') {
                                tbAgentpayDetailsInfoTemp.payStatus = '7'//对账失败,待退款
                                tbAgentpayDetailsInfoTemp.tradeFeedbackcode = '失败'
                                tbAgentpayDetailsInfoTemp.tradeReason = reson
                                tbAgentpayDetailsInfoTemp.save(flush: true, failOnError: true)
                            }

                        }
                        catch (Exception e) {
                            status.setRollbackOnly()
                            log.warn(e.message, e)
                            flash.message = e.message
                            f = e.message
                            return
                        }
                    }
                    resultList.remove(j)
                    break
                }
            }
        }


        return f
    }

    def ABCdfFile(def list) {
        response.setHeader("Content-disposition", "attachment; filename=" + new Date().format("yyyyMMddHHmm") + ".txt")
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("GBK")
        StringBuffer sb = new StringBuffer()
        def i = 1
        list.each {
            sb.append((i++) + ",")
            sb.append(it.tradeCardnum + ",")
            sb.append(it.tradeCardname + ",")
            sb.append(it.tradeAmount + ",")
            sb.append(it.tradeRemark2)
            sb.append("\n")
        }
        return sb
    }

    def ABCdsFile(def list) {
        response.setHeader("Content-disposition", "attachment; filename=" + new Date().format("yyyyMMddHHmm") + ".txt")
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("GBK")
        StringBuffer sb = new StringBuffer()
        def i = 1
        list.each {

            sb.append((i++) + ",")
            sb.append(it.tradeCardnum + ",")
            sb.append(it.tradeCardname + ",")
            sb.append(it.tradeAmount + ",")
            sb.append(it.tradeRemark2)
            sb.append("\n")
        }
        return sb
    }

    def BOCdfFile(def list, def boAcquirerAccount, def tbPcInfo) {       //中行暂且没有代收
        response.setHeader("Content-disposition", "attachment; filename=" + new Date().format("yyyyMMddHHmm") + ".txt")
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("GBK")

        StringBuffer sb = new StringBuffer()
        sb.append("PAYOFFSTART\n")
        sb.append(tbPcInfo.id + "|")//客户业务编号
        sb.append(FarmConstants.ICBCUnionBankNo + "|")//付款方联行号
        sb.append(boAcquirerAccount.bankAccountNo + "|")//付款人账号
        sb.append("CNY|")//货币名称
        sb.append(tbPcInfo.tbPcAmount + "|")//批总金额
        sb.append(tbPcInfo.tbPcItems + "|")//批总笔数
        if (list != null && list.size() > 0) {

            if (list.get(0).tradeCardnum.length() == 16) {
                sb.append("4|")//代发卡类型 贷记卡16位
            } else {
                sb.append("1|")//代发卡类型 借记卡19位
            }
        }

        sb.append("1|")//用途
        sb.append("|")//手续费账号
        sb.append(new Date().format("yyyyMMdd") + "|")//付款日期
        sb.append("|")//附言
        sb.append("\n")
        list.each {
            sb.append(FarmConstants.ICBCUnionBankNo + "|")//收款行编号
            sb.append(it.tradeAccountname + "|")//收款行行名
            sb.append(it.tradeAmounttype + "|")//货币名称
            sb.append(((it.tradeAmount.toBigDecimal() * 100) as Long).toString() + "|")//金额
            sb.append(it.tradeCardnum + "|")//收款人账号
            sb.append(it.tradeCardname + "|") //收款人姓名
            sb.append("|")//收款证件类型
            sb.append("|")//收款人证件号
            sb.append("10|")//用途
            sb.append("\n")
        }
        sb.append("PAYOFFEND")
        return sb
    }

    def ccbDfPriCheckAmount(def list) {
        response.setHeader("Content-disposition", "attachment; filename=" + "CCBPRI" + new Date().format("yyyyMMddHHmm") + "F.txt")
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("GBK")
        StringBuffer sb = new StringBuffer()
        list.each {
            sb.append(it.tradeCardnum + "|")  //收款人账号
            sb.append(it.tradeCardname + "|") //收款人姓名
            sb.append(it.tradeAmount + "|") //建行金额以元为单位
            sb.append("\n")
        }
        return sb
    }

    def ccbDfPubCheckAmount(def list, def boAcquirerAccount) {
        response.setHeader("Content-disposition", "attachment; filename=" + "CCBPUB" + new Date().format("yyyyMMddHHmm") + "F.txt")
        response.contentType = "application/x-rarx-rar-compressed"
        response.setCharacterEncoding("GBK")
        def dfcodeList = analyzeDfcodeFile()  //解析地方代码-机构号
        def busybankcodeList = analyzeBusybankcodeFile()//解析商业银行代码-行别
        StringBuffer sb = new StringBuffer()
        def i = 0
        list.each {
            if (i > 800) {
                flash.message = "批次记录超过800条,请重新生成批次!"
                throw new Exception("批次记录超过800条,请重新生成批次!")
                return
            }

            i++
            sb.append(i + "|")//序号

            sb.append(boAcquirerAccount.bankAccountName + "|") //付款账号名称
            sb.append(boAcquirerAccount.bankAccountNo + "|")//付款账号
            sb.append(FarmConstants.CBBbatchCode + "|")  //付款账号一级分行号
            sb.append(it.tradeCardnum + "|") //收款人账号
            sb.append(it.tradeCardname + "|") //收款人姓名
            if (it.tradeAccountname == boAcquirerAccount.bank.name) {
                sb.append(FarmConstants.CBBbatchCode + "|") //收款账号一级分行号   跨行则为空
                sb.append(it.tradeBranchbank + "|")//收款行开户行名称
                sb.append(" |")  //收款联行号(长度10)建行账户则为联行号，他行则为他行机构号
            }
            else {
                sb.append("|")//跨行则为空
                sb.append(it.tradeBranchbank + "|")//收款行开户行名称
                sb.append(" |")//就是联行号 须为空格,而不是空
            }
            sb.append("|")//柜台号可为空
            if (it.tradeAccountname == boAcquirerAccount.bank.name) {  //是否行内转1为行内 0为跨行(长度1)
                sb.append("1|")
            } else {
                sb.append("0|")
            }
            sb.append(it.tradeAmount + "|") //金额
            if (it.tradeAmounttype == 'CNY') {
                sb.append("01|")//币种(长度2)
            }
            sb.append(it.tradeRemark2 + "|")//用途
            if (it.tradeAccountname == boAcquirerAccount.bank.name) {
                sb.append("|")//跨行交易为行别，建行账户则为空|
                sb.append("|")// 跨行交易为收款账户开户行机构号，建行账户则为空
            } else {
                String bankcode = ""
                for (int k = 0; k < busybankcodeList.size(); k++) {
                    String fileBankName = busybankcodeList.get(k).split(' ')[0]
                    String code = busybankcodeList.get(k).split(' ')[1]
                    String dataBankName = it.tradeAccountname
                    if (fileBankName == dataBankName) {
                        bankcode = code
                        break
                    }
                }

                sb.append(bankcode + "|")//行别
                String codeName = ""
                for (int k = 0; k < dfcodeList.size(); k++) {
                    String province = dfcodeList.get(k).split(' ')[0]
                    String city = dfcodeList.get(k).split(' ')[1]
                    String code = dfcodeList.get(k).split(' ')[2]
                    String c = it.tradeRemark.split(';')[0]
                    String p = it.tradeRemark.split(';')[1]
                    c = c.replace("市", "")
                    if ((p == province) && (c == city)) {
                        codeName = code
                        break
                    }
                }
                sb.append(codeName + "|")//开户行机构号
            }
            sb.append("\n")
        }
        return sb
    }

    def sendToSettle(TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp, boolean flag) throws Exception {

        javax.jms.MapMessage message = jmsService.createMapMessage()
        message.setString('srvCode', 'agentcoll')
        if (flag) {                       //成功
            if (tbAgentpayDetailsInfoTemp.tradeAccounttype == '0') {   //对私
                message.setString('tradeCode', 'coll_c_succ')
            }
            else {
                message.setString('tradeCode', 'coll_b_succ')
            }
        } else if (!flag) {             //失败
            if (tbAgentpayDetailsInfoTemp.tradeAccounttype == '0') {
                message.setString('tradeCode', 'coll_c_fail')
            }
            else {
                message.setString('tradeCode', 'coll_b_fail')
            }
        }
        TbAgentpayInfo tbAgentpayInfo =  tbAgentpayDetailsInfoTemp.batch
        message.setString('customerNo', tbAgentpayDetailsInfoTemp.batchBizid)

        message.setLong('amount', BigDecimal.valueOf(tbAgentpayDetailsInfoTemp.tradeAmount).multiply(100).toLong())
        message.setString('seqNo', tbAgentpayDetailsInfoTemp.id as String)
        message.setString('tradeDate', tbAgentpayDetailsInfoTemp.tradeSysdate.format("yyyy-MM-dd HH:mm:ss.SSS"))
        message.setString('billDate', tbAgentpayDetailsInfoTemp.tradeDonedate.format("yyyy-MM-dd HH:mm:ss.SSS"))
         message.setString('batchSrc',tbAgentpayInfo.batchSrc)    //增加渠道
        jmsService.send(message)
    }

    def uploadFileUncheck() {
        if (request instanceof MultipartHttpServletRequest) {

            InputStream is = null
            def maxFileSize = 10485760
            def resultmsg
            List list = new ArrayList()
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request
            CommonsMultipartFile orginalFile = (CommonsMultipartFile) multiRequest.getFile("upload")
            // 判断是否上传文件
            if (!orginalFile.isEmpty()) {
                if (orginalFile.getSize() < maxFileSize) {
                    is = orginalFile.getInputStream()
                    String originalFilename = orginalFile.getOriginalFilename()
                    def extension = originalFilename.substring(originalFilename.indexOf(".") + 1)
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMddHHmmssssss")
                    def name = sdf.format(new Date()) + "." + extension
                    def filepath = request.getRealPath("/") + "upload" + File.separator
                    def filename = filepath + name
                    if (!new File(filepath).exists()) {
                        new File(filepath).mkdir()
                    }
                    orginalFile.transferTo(new File(filename))
                    if (extension.toUpperCase().equals("XLS")) {
                        list = this.getUncheckXls(is)
                    } else {
                        list = this.getUncheckXlxs(is)
                    }
                    return list
                } else {
                    flash.message = "上传失败，上传文件不能大于10M"
                    redirect(action: "batchRefund")
                }
            } else {
                flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
                redirect(action: "batchRefund")
            }
        }
    }

    def List getUncheckXls(InputStream is) {
        List list = new ArrayList()
        try {
            HSSFWorkbook workbook = new HSSFWorkbook(is)
            HSSFSheet xSheet = workbook.getSheetAt(0)
            if (xSheet == null) {
                flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
                redirect(action: "batchRefund")
            }
            //循环行Row
            List li = null
            for (int rowNum = 2; rowNum <= xSheet.getLastRowNum(); rowNum++) {
                HSSFRow xRow = xSheet.getRow(rowNum)
                if (!xRow) {
                    continue
                }
                if (!xRow.getCell(0)) {
                    continue
                }
                li = new ArrayList()
                int cellNum = 0
//                 循环列Cell
                for (cellNum = 0; cellNum <= xRow.getLastCellNum(); cellNum++) {
                    HSSFCell xCell = xRow.getCell(cellNum)
                    if (xCell == null) {
                        break
                    }
                    if (xCell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
                        li.add(xCell.getNumericCellValue())
                    } else {
                        li.add(xCell.getStringCellValue().trim())
                    }
                }
                if (li && li.size() > 1) {
                    list.add(li)
                }
            }
            return list
        } catch (Exception e) {
            e.printStackTrace()
            flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
            redirect(action: "dsCheck")
        }
    }

    def List getUncheckXlxs(InputStream is) {
        List list = new ArrayList()
        try {
            XSSFWorkbook xwb = new XSSFWorkbook(is)
            XSSFSheet xSheet = xwb.getSheetAt(0)
            if (xSheet != null) {
                for (int rowNum = 2; rowNum <= xSheet.getLastRowNum(); rowNum++) {
                    if (xSheet.getRow(rowNum) != null) {
                        XSSFRow xRow = xSheet.getRow(rowNum)
                        List li = new ArrayList()
                        if (!xRow) {
                            break
                        }
                        if (!xRow.getCell(0)) {
                            break
                        }
//                        if (!xRow.getCell(0).getStringCellValue()) {
//                            break
//                        }
                        for (int cellNum = 0; cellNum <= xRow.getLastCellNum(); cellNum++) {
                            if (xRow.getCell(cellNum) != null) {
                                XSSFCell xCell = xRow.getCell(cellNum)
                                if (xCell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
                                    li.add(xCell.getNumericCellValue())
                                } else {
                                    li.add(xCell.getStringCellValue().trim())
                                }
                            }
                        }
                        list.add(li)
                    }
                }
                return list
            } else {
                flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
                redirect(action: "dsCheck")
            }
        } catch (Exception e) {
            e.printStackTrace()
            flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
            redirect(action: "dsCheck")
        }
    }

}
