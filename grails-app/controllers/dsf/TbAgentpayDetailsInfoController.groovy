package dsf

import boss.BoAcquirerAccount
import boss.BoBankDic
import ismp.CmCustomer
import boss.BoCustomerService
import boss.BoInnerAccount

import boss.BoMerchant

import Constants.FarmConstants

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams
import java.util.zip.ZipInputStream
import HunionPay.Crypt
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class TbAgentpayDetailsInfoController {
     def icbcPayService
    def dataSource_boss
    static allowedMethods = [select: "POST", save: "POST", update: "POST", delete: "POST"]
    def accountClientService
    def index = {
        redirect(action: "list", params: params)
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
    def dklist = {    //打款   初审
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        def query = {

            eq('tradeStatus', '1')
            eq('payStatus', '0')
            eq('tradeType', 'F')
//            if (params.startTime) {
//                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }
               //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
            ge('tradeSysdate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
            lt('tradeSysdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }

            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid", '%'+params.batchBizid+ '%')
            }
           // if (params.tradeType != "" && params.tradeType != null) {//类型
           //     eq('tradeType', params.tradeType)
          //  }
            if (params.tradeStyle != "" && params.tradeStyle != null) { //业务类型
                eq('tradeType', params.tradeStyle)
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                like("tradeCardnum", "%" + params.tradeCardnum+ "%")
            }

            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }
            if (params.bankName != null && params.bankName != "") {
                def banks = TbAdjustBank.executeQuery("select bankNames from TbAdjustBank where bankCode=? and type='F'",params.bankName)
                println 'banks ' + banks
                'in'("tradeAccountname", banks)
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
        def total = TbAgentpayDetailsInfo.createCriteria().count(query)
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: total, bankNameList: loadOuterBanks(), totalMoney: totalMoney, totalFee: totalFee, totalAccMoney: totalMoney]
    }
    def sklist = {  //收款   初审
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        def query = {

            eq('tradeStatus', '1')
            eq('payStatus', '0')
            eq('tradeType', 'S')
//            if (params.startTime) {
//                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }
                //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
                ge('tradeSysdate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
                lt('tradeSysdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }

            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid",  '%'+params.batchBizid+ "%")
            }
           // if (params.tradeType != "" && params.tradeType != null) {//类型
           //     eq('tradeType', params.tradeType)
           // }
            if (params.tradeStyle != "" && params.tradeStyle != null) { //业务类型
                eq('tradeType', params.tradeStyle)
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                like("tradeCardnum","%" + params.tradeCardnum+ "%")
            }

            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }
            if (params.bankName != null && params.bankName != "") {
               def banks = TbAdjustBank.executeQuery("select bankNames from TbAdjustBank where bankCode=? and type='S'",params.bankName)
                println 'banks ' + banks
                'in'("tradeAccountname", banks)
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
        def total = TbAgentpayDetailsInfo.createCriteria().count(query)
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: total, bankNameList: loadInnerBanks(), totalMoney: totalMoney, totalFee: totalFee, totalAccMoney: totalMoney]
    }
    def dkteminalList = {  //打款   复审
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        def query = {
            eq('tradeStatus', '1')
            eq('payStatus', '1')
            eq('tradeType', 'F')
//            if (params.startTime) {
//                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }
                //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
                ge('tradeSysdate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
                lt('tradeSysdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }

            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid", "%" +params.batchBizid+ "%")
            }
            if (params.tradeType != "" && params.tradeType != null) {
                eq('tradeType', params.tradeType)
            }
            if (params.tradeStyle != "" && params.tradeStyle != null) { //业务类型
                eq('tradeType', params.tradeStyle)
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
            if (params.bankName != null && params.bankName != "") {
               def banks = TbAdjustBank.executeQuery("select bankNames from TbAdjustBank where bankCode=? and type='F'",params.bankName)
                println 'banks ' + banks
                'in'("tradeAccountname", banks)
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

        def total = TbAgentpayDetailsInfo.createCriteria().count(query)
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: total, totalMoney: totalMoney, bankNameList: loadOuterBanks(), totalFee: totalFee, totalAccMoney: totalMoney]

    }
    def skteminalList = {   //收款   复审
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        def query = {
            eq('tradeStatus', '1')
            eq('payStatus', '1')
            eq('tradeType', 'S')
//            if (params.startTime) {
//                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }
                            //guonan update 2011-12-29
            validDated(params)

            if (params.startTime) {
            ge('tradeSysdate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
            lt('tradeSysdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }

            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid", "%" + params.batchBizid+ "%")
            }
            if (params.tradeType != "" && params.tradeType != null) {
                eq('tradeType', params.tradeType)
            }
            if (params.tradeStyle != "" && params.tradeStyle != null) { //业务类型
                eq('tradeType', params.tradeStyle)
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
            if (params.bankName != null && params.bankName != "") {
               def banks = TbAdjustBank.executeQuery("select bankNames from TbAdjustBank where bankCode=? and type='S'",params.bankName)
                println 'banks ' + banks
                'in'("tradeAccountname", banks)
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

        def total = TbAgentpayDetailsInfo.createCriteria().count(query)
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: total, totalMoney: totalMoney, bankNameList: loadInnerBanks(), totalFee: totalFee, totalAccMoney: totalMoney]

    }

    def payList = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        //List bankCList = bankChanelList('F')
        def query = {

            eq("tradeType", 'F')
            eq('tradeStatus', '1')
            eq('payStatus', '3')
            isNull('dkPcNo')
            if (params.cardT != null && params.cardT != "") {
//                eq("tradeCardnum",params.cardT as Integer)
                sqlRestriction "length(trade_Cardnum) = " + params.cardT
            }
//            if (params.startTime) {
//                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }

               //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
            ge('tradeSysdate', Date.parse('yyyy-MM-dd', params.startTime))
            }
             if (params.endTime) {
            lt('tradeSysdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
             }


            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid", "%" + params.batchBizid+ "%")
            }
            if (params.tradeType != "" && params.tradeType != null) {
                eq('tradeType', params.tradeType)
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                like("tradeCardnum", "%" + params.tradeCardnum + "%")
            }
            if (params.tradeAccountname != null && params.tradeAccountname != "") {
                like("tradeAccountname", "%" + params.tradeAccountname+ "%")
            }
            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }
            if (params.bankNameSearch != null && params.bankNameSearch != "") {
                def banks = TbAdjustBank.executeQuery("select bankNames from TbAdjustBank where bankCode=? and type='F'",params.bankNameSearch)
                println 'banks ' + banks
                'in'("tradeAccountname", banks)
                /*if (params.chinapay == 'chinapay' || params.chinapay == 'hchinapay') {
                    def bomerchant
                    if (params.chinapay == 'hchinapay') {
                        bomerchant = BoMerchant.executeQuery("select acquireIndexc from BoMerchant where acquireIndexc like 'DFH%' and channelSts='0'")
                    }
                    else {
                        bomerchant = BoMerchant.executeQuery("select acquireIndexc from BoMerchant where acquireIndexc like 'DF-%' and channelSts='0'")
                    }
                    def banknames
                    //=================
                    String name = "";
                    for (int i = 0; i < bomerchant.size(); i++) {
                        String na = bomerchant[i].split('-')[1]
                        name = name + "'" + na + "'"
                        if (i < bomerchant.size() - 1) {name = name + ","}

                    }
                    banknames = TbAdjustBank.executeQuery(" select bankNames from TbAdjustBank t where t.bankCode in (" + name + ")")
                    //===================
                    'in'("tradeAccountname", banknames)
                    bankCList = bankChanelList('F', params.bankNameSearch)
                } else {
                    def bankCode = BoBankDic.get(params.bankNameSearch).code

                   def  bnames = TbAdjustBank.executeQuery(" select bankNames from TbAdjustBank t where t.bankCode ='"+ (bankCode.toUpperCase())+"'" )
                    'in'("tradeAccountname", bnames)
                    bankCList = bankChanelList('F')
                }*/

            }

        }
        double totalMoney = 0
        double totalFee = 0
        double totalAccMoney = 0
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        def results1 = TbAgentpayDetailsInfo.createCriteria().list(query)
        results1.each {

            totalMoney = totalMoney + it.tradeAmount
            totalFee = totalFee + it.tradeFee
            totalAccMoney = totalAccMoney + it.tradeAccamount
        }
        def total = TbAgentpayDetailsInfo.createCriteria().count(query)
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: total, bankNameList: loadOuterBanks(), bankChanelList: bankChanelList('F'), totalMoney: totalMoney, totalFee: totalFee, totalAccMoney: totalMoney]
    }

    def dsPayList = {  //代收打款列表
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        //List bankCList = new ArrayList()
        def query = {
            eq("tradeType", 'S')
            eq('tradeStatus', '1')
            eq('payStatus', '3')
            isNull('dkPcNo')
//            if (params.startTime) {
//                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }
               //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
            ge('tradeSysdate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
            lt('tradeSysdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
             }

            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid", "%" +params.batchBizid+ "%")
            }
            if (params.tradeType != "" && params.tradeType != null) {
                eq('tradeType', params.tradeType)
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                like("tradeCardnum","%" +  params.tradeCardnum+ "%")
            }
            if (params.tradeAccountname != null && params.tradeAccountname != "") {
                like("tradeAccountname","%" +  params.tradeAccountname+ "%")
            }
            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }

            if (params.bankNameSearch != null && params.bankNameSearch != "") {
                def banks = TbAdjustBank.executeQuery("select bankNames from TbAdjustBank where bankCode=? and type='S'",params.bankNameSearch)
                println 'banks ' + banks
                'in'("tradeAccountname", banks)
                /*if (params.chinapay == 'chinapay' || params.chinapay == 'hchinapay') {
                    def bomerchant
                    if (params.chinapay == 'hchinapay') {
                        bomerchant = BoMerchant.executeQuery("select acquireIndexc from BoMerchant where acquireIndexc like 'DSH%' and channelSts='0'")
                    } else if (params.chinapay == 'chinapay') {
                        bomerchant = BoMerchant.executeQuery("select acquireIndexc from BoMerchant where acquireIndexc like 'DS-%' and channelSts='0'")
                    }

                    String name = "";
                    for (int i = 0; i < bomerchant.size(); i++) {
                        String na = bomerchant[i].split("-")[1]
                        name = name + "'" + na + "'"
                        if (i < bomerchant.size() - 1) {name = name + ","}

                    }
                    def banknames = TbAdjustBank.executeQuery(" select bankNames from TbAdjustBank t where t.bankCode in (" + name + ")")
                    'in'("tradeAccountname", banknames)
                    bankCList = bankChanelList('S', params.bankNameSearch)
                }
                else {
                   // eq("tradeAccountname", BoBankDic.get(params.bankNameSearch).name)
                     def bankCode = BoBankDic.get(params.bankNameSearch).code

                   def  bnames = TbAdjustBank.executeQuery(" select bankNames from TbAdjustBank t where t.bankCode ='"+ (bankCode.toUpperCase())+"'" )
                    'in'("tradeAccountname", bnames)
                    bankCList = bankChanelList('S', params.bankNameSearch)
                }*/
            }
            /*else {
                bankCList = bankChanelList('S')
            }*/
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
        def total = TbAgentpayDetailsInfo.createCriteria().count(query)
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: total, bankNameList: loadInnerBanks(), bankChanelList: bankChanelList('S'), totalMoney: totalMoney, totalFee: totalFee, totalAccMoney: totalMoney]
    }

    /**
     * 获取付款支持的银行查询列表
     * 关键字Outer表示出 即付的意思
     * @return
     */
    def static outerBanks = null
    def loadOuterBanks(){
        if(outerBanks){
            return outerBanks
        }
        def result = TbAdjustBank.executeQuery("select distinct bankCode, note from TbAdjustBank where type='F' order by bankCode")
        outerBanks = new ArrayList();
        TbAdjustBank item = null
        for(int i=0; i <result.size(); i++){
            item = new TbAdjustBank()
            item.bankCode = result.get(i)[0]
            item.note = result.get(i)[1]
            println('outer item ' +  item.bankCode + " value " + item.note)
            outerBanks.add(item)
        }
        return outerBanks
    }

    /**
     * 获取收款支持的银行查询列表
     * 关键字Inner表示入 即收的意思
     * @return
     */
    def static innerBanks = null
    def loadInnerBanks(){
        if(innerBanks){
            return innerBanks
        }
        def result = TbAdjustBank.executeQuery("select distinct bankCode, note from TbAdjustBank where type='S' order by bankCode")
        innerBanks = new ArrayList();
        TbAdjustBank item = null
        for(int i=0; i <result.size(); i++){
            item = new TbAdjustBank()
            item.bankCode = result.get(i)[0]
            item.note = result.get(i)[1]
            println('inner item ' +  item.bankCode + " value " + item.note)
            innerBanks.add(item)
        }
        return innerBanks
    }

    /*def bankList(def flag) {
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
        def bankList1
        if (!no.equals("")) {
            bankList1 = BoAcquirerAccount.executeQuery("select distinct a.id as id ,a.name as name from BoBankDic  a,BoAcquirerAccount t where  t.bankAccountNo in (" + no + ") and t.bank.id=a.id and t.status='normal'")

        }
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
    }*/

    /*def bankList() {
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
        def bankList1
        if (!no.equals("")) {
            bankList1 = BoAcquirerAccount.executeQuery("select distinct a.id as id ,a.name as name from BoBankDic  a,BoAcquirerAccount t where  t.bankAccountNo in (" + no + ") and t.bank.id=a.id and t.status='normal'")
        }

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
    }*/

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


    /*def bankChanelList(def flag, def id) {
        TbBindBank tbBindBank = new TbBindBank()
        tbBindBank.dsfFlag = flag
        List list = TbBindBank.findAll(tbBindBank)
        //BoAcquirerAccount boAcquirerAccount = new BoAcquirerAccount()
        List<BoAcquirerAccount> bankChanelList = new ArrayList<BoAcquirerAccount>()
        for (int i = 0; i < list.size(); i++) {
            String no = list.get(i).bankAccountno
            def boList = BoAcquirerAccount.executeQuery(" from BoAcquirerAccount where bank.id= " + id + " and bankAccountNo='" + no + "' and status='normal'")

            for (int j = 0; j < boList.size(); j++) {
//                BoAcquirerAccount boAcquirerAccount = new BoAcquirerAccount()
//                boAcquirerAccount.id = boList.get(j)[0]
//                boAcquirerAccount.aliasName = boList.get(j)[1]
                bankChanelList.add(boList.get(j))
            }
        }
        return bankChanelList
    }*/

    def create = {
        def tbAgentpayDetailsInfoInstance = new TbAgentpayDetailsInfo()
        tbAgentpayDetailsInfoInstance.properties = params
        return [tbAgentpayDetailsInfoInstance: tbAgentpayDetailsInfoInstance]
    }

    def save = {
        def tbAgentpayDetailsInfoInstance = new TbAgentpayDetailsInfo(params)
        if (tbAgentpayDetailsInfoInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'tbAgentpayDetailsInfo.label', default: 'TbAgentpayDetailsInfo'), tbAgentpayDetailsInfoInstance.id])}"
            redirect(action: "list", id: tbAgentpayDetailsInfoInstance.id)
        }
        else {
            render(view: "create", model: [tbAgentpayDetailsInfoInstance: tbAgentpayDetailsInfoInstance])
        }
    }

    def show = {
        def tbAgentpayDetailsInfoInstance = TbAgentpayDetailsInfo.get(params.id)
        if (!tbAgentpayDetailsInfoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbAgentpayDetailsInfo.label', default: 'TbAgentpayDetailsInfo'), params.id])}"
            redirect(action: "list")
        }
        else {
            [tbAgentpayDetailsInfoInstance: tbAgentpayDetailsInfoInstance]
        }
    }

    def edit = {
        def tbAgentpayDetailsInfoInstance = TbAgentpayDetailsInfo.get(params.id)
        if (!tbAgentpayDetailsInfoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbAgentpayDetailsInfo.label', default: 'TbAgentpayDetailsInfo'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [tbAgentpayDetailsInfoInstance: tbAgentpayDetailsInfoInstance]
        }
    }

    def update = {
        def tbAgentpayDetailsInfoInstance = TbAgentpayDetailsInfo.get(params.id)
        if (tbAgentpayDetailsInfoInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (tbAgentpayDetailsInfoInstance.version > version) {

                    tbAgentpayDetailsInfoInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'tbAgentpayDetailsInfo.label', default: 'TbAgentpayDetailsInfo')] as Object[], "Another user has updated this TbAgentpayDetailsInfo while you were editing")
                    render(view: "edit", model: [tbAgentpayDetailsInfoInstance: tbAgentpayDetailsInfoInstance])
                    return
                }
            }
            tbAgentpayDetailsInfoInstance.properties = params
            if (!tbAgentpayDetailsInfoInstance.hasErrors() && tbAgentpayDetailsInfoInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'tbAgentpayDetailsInfo.label', default: 'TbAgentpayDetailsInfo'), tbAgentpayDetailsInfoInstance.id])}"
                redirect(action: "list")
            }
            else {
                render(view: "edit", model: [tbAgentpayDetailsInfoInstance: tbAgentpayDetailsInfoInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tbAgentpayDetailsInfo.label', default: 'TbAgentpayDetailsInfo'), params.id])}"
            redirect(action: "list")
        }
    }
    //打款平台初审拒绝
    def frTrialRefuse = {
        TbAgentpayDetailsInfo.withTransaction {status ->
            try {
                String name = session.op.name
                def ids
                String[] id;
                if (params.allCheck == "true") {
                    def results = allChecked("0", params.flag)
                    id = new String[results.size()]
                    int i = 0
                    results.each {
                        it.payStatus = "2"; it.tradeStatus = "2"; it.tradeFeedbackcode = "失败"; it.fcheckName = name;
                        if (it.tradeType == "F") {it.tradeReason = "拒绝"} else if (it.tradeType == "S") {it.tradeReason = "吉高拒绝"}

                        id[i] = it.id
                        i++
                        it.save(failOnError: true)
                    }
                }
                else {
                    ids = params.ids.substring(0, params.ids.length() - 1)
                    id = ids.split(",")
                    def list = TbAgentpayDetailsInfo.executeQuery("from TbAgentpayDetailsInfo where id in(" + ids + ")")
                    for (int i = 0; i < list.size(); i++) {
                        if (list.get(i).tradeType == 'F') {
                            TbAgentpayDetailsInfo.executeUpdate("update TbAgentpayDetailsInfo t set t.payStatus='2',t.tradeStatus='2',t.tradeFeedbackcode='失败',t.tradeReason='拒绝',fcheckName='" + name + "'  where t.id = (" + list.get(i).id + ")")
                        }
                        else if (list.get(i).tradeType == 'S') {
                            TbAgentpayDetailsInfo.executeUpdate("update TbAgentpayDetailsInfo t set t.payStatus='2',t.tradeStatus='2',t.tradeFeedbackcode='失败',t.tradeReason='吉高拒绝',fcheckName='" + name + "'  where t.id = (" + list.get(i).id + ")")
                        }
                    }
                }

                //int updateCount = TbAgentpayDetailsInfo.executeUpdate("update TbAgentpayDetailsInfo t set t.payStatus='2',t.tradeStatus='2',t.tradeFeedbackcode='失败',t.tradeReason='拒绝',fcheckName='"+name+"'  where t.id in (" + ids + ")")
                for (int i = 0; i < id.size(); i++) {
                    TbAgentpayDetailsInfo tbAgentpayDetailsInfoInstance = TbAgentpayDetailsInfo.get(String.valueOf(id[i]))
                    fDealAccount(tbAgentpayDetailsInfoInstance)
                }

            } catch (Exception e) {
                //roll back
                status.setRollbackOnly()
                log.warn(e.message, e)
                flash.message = e.message
                if (params.flag == 'F') {
                    redirect(action: "dklist")
                } else {
                    redirect(action: "sklist")
                }
                return
            }
            if (params.flag == 'F') {
                redirect(action: "dklist")
            }
            else {
                redirect(action: "sklist")
            }

        }
    }
    //打款平台终审拒绝
    def terminalRefuse = {
        def name = session.op.name
        TbAgentpayDetailsInfo.withTransaction {status ->
            try {
                def ids;
                String[] id;
                if (params.allCheck == "true") {
                    def results = allChecked("1", params.flag)
                    int i = 0
                    id = new String[results.size()]
                    results.each {
                        it.payStatus = "4"; it.tradeStatus = "2"; it.tradeFeedbackcode = "失败"; it.fcheckName = name;
                        if (it.tradeType == "F") {it.tradeReason = "拒绝"} else if (it.tradeType == "S") {it.tradeReason = "吉高拒绝"}

                        id[i] = it.id
                        i++
                        it.save(failOnError: true)
                    }
                }
                else {
                    ids = params.ids.substring(0, params.ids.length() - 1)
                    id = ids.split(",")
                    def list = TbAgentpayDetailsInfo.executeQuery("from TbAgentpayDetailsInfo where id in(" + ids + ")")
                    for (int i = 0; i < list.size(); i++) {
                        if (list.get(i).tradeType == 'F') {
                            TbAgentpayDetailsInfo.executeUpdate("update TbAgentpayDetailsInfo t set t.payStatus='4',t.tradeStatus='2',t.tradeFeedbackcode='失败',t.tradeReason='拒绝',tcheckName='" + name + "' where t.id = (" + list.get(i).id + ")")

                        } else if (list.get(i).tradeType == 'S') {
                            TbAgentpayDetailsInfo.executeUpdate("update TbAgentpayDetailsInfo t set t.payStatus='4',t.tradeStatus='2',t.tradeFeedbackcode='失败',t.tradeReason='吉高拒绝',tcheckName='" + name + "' where t.id = (" + list.get(i).id + ")")

                        }
                    }
                }

                //int updateCount = TbAgentpayDetailsInfo.executeUpdate("update TbAgentpayDetailsInfo t set t.payStatus='4',t.tradeStatus='2',t.tradeFeedbackcode='失败',t.tradeReason='拒绝',tcheckName='"+name+"' where t.id in (" + ids + ")")

                for (int i = 0; i < id.size(); i++) {
                    TbAgentpayDetailsInfo tbAgentpayDetailsInfoInstance = TbAgentpayDetailsInfo.get(String.valueOf(id[i]))
                    fDealAccount(tbAgentpayDetailsInfoInstance)
                }
            } catch (Exception e) {
                //roll back
                status.setRollbackOnly()
                log.warn(e.message, e)
                flash.message = e.message

                if (params.flag == 'F') {
                    redirect(action: "dkteminalList")
                } else {
                    redirect(action: "skteminalList")
                }

                return
            }
            if (params.flag == 'F') {
                redirect(action: "dkteminalList")
            } else {
                redirect(action: "skteminalList")
            }

        }
    }

    def allChecked(String status, String type) {
        def query = {
            eq('tradeStatus', '1')
            eq('payStatus', status)
            eq('tradeType', type)
            if (params.startTime) {
                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
            }
            if (params.endTime) {
                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
            }
            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid", "%" +params.batchBizid+ "%")
            }
            if (params.tradeType != "" && params.tradeType != null) {//类型
                eq('tradeType', params.tradeType)
            }
            if (params.tradeStyle != "" && params.tradeStyle != null) { //业务类型
                eq('tradeType', params.tradeStyle)
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                like("tradeCardnum", "%" + params.tradeCardnum+ "%")
            }

            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }
            if (params.bankName != null && params.bankName != "") {
                def banks = TbAdjustBank.executeQuery("select bankNames from TbAdjustBank where bankCode=? and type=? ",params.bankName, type)
                println 'bankName ' + params.bankName + ' &type ' + params.flag + ' &banks ' + banks
                'in'("tradeAccountname", banks)
            }
        }
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        return results
    }
    /**
     * 初审通过
     */
    def frTrialPass = {
        String name = session.op.name
        def ids
        if (params.allCheck == "true") {
            def results = allChecked("0", params.flag)
            results.each {
                it.payStatus = "1"
                it.fcheckName = name
                it.save(failOnError: true)
            }
        }
        else {
            ids = params.ids.substring(0, params.ids.length() - 1)
            int updateCount = TbAgentpayDetailsInfo.executeUpdate("update TbAgentpayDetailsInfo t set t.payStatus='1',fcheckName='" + name + "' where t.id in (" + ids + ")")
        }
        if (params.flag == 'F') {
            redirect(action: "dklist")
        } else {
            redirect(action: "sklist")
        }
    }
    def terminalPass = {
        String name = session.op.name
        def ids
        if (params.allCheck == "true") {
            def results = allChecked("1", params.flag)
            results.each {
                it.payStatus = "3"
                it.tcheckName = name
                it.save(failOnError: true)
            }
        }
        else {
            ids = params.ids.substring(0, params.ids.length() - 1)
            int updateCount = TbAgentpayDetailsInfo.executeUpdate("update TbAgentpayDetailsInfo t set t.payStatus='3',tcheckName='" + name + "' where t.id in (" + ids + ")")
        }

        if (params.flag == 'F') {
            redirect(action: "dkteminalList")
        } else {
            redirect(action: "skteminalList")
        }

    }
    //手工处理
    def handlePay = {
        def query = {
            eq('tradeStatus', '1')
            eq('payStatus', '3')
            if (params.flag == 'S') {
                eq('tradeType', 'S')
            }
            if (params.flag == 'F') {
                eq('tradeType', 'F')
            }
            if (params.startTime) {
                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
            }
            if (params.endTime) {
                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
            }
            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid", "%"+ params.batchBizid+ "%")
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                like("tradeCardnum","%" +  params.tradeCardnum+ "%")
            }
            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }

            if (params.bankNameSearch != null && params.bankNameSearch != "") {
                def banks = TbAdjustBank.executeQuery("select bankNames from TbAdjustBank where bankCode=? and type=? ",params.bankNameSearch, params.flag)
                println 'bankName ' + params.bankNameSearch + ' &type ' + params.flag + ' &banks ' + banks
                'in'("tradeAccountname", banks)
                /*def bomerchant;
                def banknames;
                if (params.chinapay == 'chinapay') {
                    if (params.flag == 'F') {
                        bomerchant = BoMerchant.executeQuery("select acquireIndexc from BoMerchant where acquireIndexc like 'DF-%' and channelSts='0'")
                        //====
                        String name = "";
                        for (int i = 0; i < bomerchant.size(); i++) {
                            String na = bomerchant[i].split('-')[1]
                            name = name + "'" + na + "'"
                            if (i < bomerchant.size() - 1) {name = name + ","}

                        }
                        banknames = TbAdjustBank.executeQuery(" select bankNames from TbAdjustBank t where t.bankCode in (" + name + ")")
                        //====
                    }
                    else if (params.flag == 'S') {
                        bomerchant = BoMerchant.executeQuery("select acquireIndexc from BoMerchant where acquireIndexc like 'DS-%' and channelSts='0'")
                        //====
                        String name = "";
                        for (int i = 0; i < bomerchant.size(); i++) {
                            String na = bomerchant[i].split('-')[1]
                            name = name + "'" + na + "'"
                            if (i < bomerchant.size() - 1) {name = name + ","}

                        }
                        banknames = TbAdjustBank.executeQuery(" select bankNames from TbAdjustBank t where t.bankCode in (" + name + ")")
                        //====
                    }

                    'in'("tradeAccountname", banknames)

                }
                else {
                    def bankCode = BoBankDic.get(params.bankNameSearch).code
                   def  bnames = TbAdjustBank.executeQuery(" select bankNames from TbAdjustBank t where t.bankCode = '"+ (bankCode.toUpperCase())+"'" )
                    'in'("tradeAccountname", bnames)
                }*/
            }

        }
        TbPcInfo tbPcInfo = new TbPcInfo()
        def ids
        double amount = 0
        double fee = 0
        double accamount = 0
        boolean flag = true
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        if (results.size() > 0) {
            results.each {
                amount = amount + (it.tradeAmount as double)
                fee = fee + ((it.tradeFee ? it.tradeFee : 0) as double)
                if (it.tradeFeetype == '0') {    //即扣
                    accamount = accamount + (((it.tradeAmount ? it.tradeAmount : 0) as double) - ((it.tradeFee ? it.tradeFee : 0) as double))
                } else {
                    accamount = accamount + ((it.tradeAmount ? it.tradeAmount : 0) as double)
                }
            }
            def obj = BoAcquirerAccount.findById((params.bankName) as long)
            tbPcInfo.tbPcDate = new Date()
            tbPcInfo.tbPcItems = results.size()
            tbPcInfo.tbPcAmount = amount
            if (results.get(0).tradeType == 'F') {
                tbPcInfo.tbPcAccamount = accamount
                tbPcInfo.tbPcFee = fee
            }

            tbPcInfo.tbPcDkChanel = (params.bankName as long)
            tbPcInfo.tbPcDkChanelname = obj.bank.name + '-' + obj.aliasName
            tbPcInfo.tbPcDkStatus = '0'
            tbPcInfo.tbSfFlag = params.flag
            if (obj.bank.code.equalsIgnoreCase("icbc")) {  //工行：李新海，2000笔/批次；
                ids = tbPcSave(tbPcInfo, results, 2000)
            } else if (obj.bank.code.equalsIgnoreCase("abc")) { //农行:同行3000笔/批次，跨行200笔/批次(注:农行批量没有跨行)
                ids = tbPcSave(tbPcInfo, results, 3000)
            } else if (obj.bank.code.equalsIgnoreCase("unionpay")) {//银联：代收，每个文件5000笔，代付1000笔。
                if (params.flag == "S") {
                    ids = tbPcSave(tbPcInfo, results, 5000)
                } else {
                    ids = tbPcSave(tbPcInfo, results, 1000)
                }
            } else if (obj.bank.code.equalsIgnoreCase("ccb")) { //建行1000笔/批次
                ids = tbPcSave(tbPcInfo, results, 1000)
            }


            redirect(controller: "tbPcInfo", action: "list", params: [ids: ids])
        }
        else {
            flash.message = "无明细,无法生成批次!"
            if (params.flag == 'S') {
                redirect(action: "dsPayList")
            } else {
                redirect(action: "payList")
            }

        }
    }

    def Long[] tbPcSave(TbPcInfo tbPcInfo, def results, def items) {

        def size = results.size();
        def times = Math.ceil(size / items)
        Long[] ids = new long[times]
        def tbPcDate = tbPcInfo.tbPcDate
//            def tbPcFee =tbPcInfo.tbPcFee
        def tbPcDkChanel = tbPcInfo.tbPcDkChanel
        def tbPcDkChanelname = tbPcInfo.tbPcDkChanelname
        def tbSfFlag = tbPcInfo.tbSfFlag
        def tbPcDkStatus = tbPcInfo.tbPcDkStatus
        def tbPcCheckStatus = tbPcInfo.tbPcCheckStatus
        def tbDealstyle = tbPcInfo.tbDealstyle
        def accamount = tbPcInfo.tbPcAccamount ? tbPcInfo.tbPcAccamount : 0
        int k = 0
        tbPcInfo.withTransaction {status -> //开启事务
            int i = 0
            for (int m = 0; m < times; m++) {

                tbPcInfo.tbPcItems = 0
                tbPcInfo.tbPcAmount = 0.00
                tbPcInfo.tbPcFee = 0.00
//                    tbPcInfo.tbPcDkStatus ='0'
                try {
                    int l = 0
                    for (int j = i; j < size; j++) {

                        if (l == items) {break;}
                        tbPcInfo.tbPcItems = tbPcInfo.tbPcItems + 1
                        tbPcInfo.tbPcAmount = BigDecimal.valueOf(tbPcInfo.tbPcAmount) + BigDecimal.valueOf(results.get(j).tradeAmount)
                        tbPcInfo.tbPcFee = tbPcInfo.tbPcFee + (results.get(j).tradeFee ? results.get(j).tradeFee : 0)
                        l++
                    }
                    l = 0
                    println "总金额"+tbPcInfo.tbPcAmount
                    StringBuffer sb = new StringBuffer()
                     String idTemp = ""
                    if (tbPcInfo.save(failOnError: true)) {
                        for (int j = i; j < size; j++) {
                            if (l == items) {break;}

                            idTemp = idTemp + String.valueOf(results.get(j).id) + ","

                            if (j!=0&&j % 500 == 0) {
                                sb.append(idTemp)
                                sb.append("|")
                                idTemp = ""
                            }

                            l++

                        }
                        if(idTemp!=""){
                            sb.append(idTemp.substring(0,idTemp.lastIndexOf(",")))
                        }

                    }
                       def idsTemp = sb.toString().replace(",|","|").split("\\|")
                    println idsTemp.length+"leg========"
                        for (int j = 0; j < idsTemp.length; j++) {

                            String sql = ""
                            if (tbDealstyle == "autoPay") { //若是直连银行,则直接置为打款完成}
                                sql = "update TbAgentpayDetailsInfo t set payStatus = '5', dkPcNo=" + tbPcInfo.id + " where t.id in(" + idsTemp[j]+")"
                            }
                            else {
                                sql = "update TbAgentpayDetailsInfo t set payStatus = '10', dkPcNo=" + tbPcInfo.id + " where t.id in(" + idsTemp[j]+")"
                            }
                            TbAgentpayDetailsInfo.executeUpdate(sql)

                            println "${new Date()} ,${l}"
                            //l++
                        }
                    ids[k] = tbPcInfo.id
                    k++;
                    tbPcInfo = new TbPcInfo()
                    tbPcInfo.tbPcDate = tbPcDate
                    tbPcInfo.tbDealstyle = tbDealstyle
                    tbPcInfo.tbPcDkStatus = tbPcDkStatus
                    tbPcInfo.tbPcCheckStatus = tbPcCheckStatus
                    tbPcInfo.tbPcAccamount = accamount
                    tbPcInfo.tbPcDkChanel = tbPcDkChanel
                    tbPcInfo.tbPcDkChanelname = tbPcDkChanelname
                    tbPcInfo.tbSfFlag = tbSfFlag
                    i = i + items
                } catch (Exception e) {
                    status.setRollbackOnly()
                    log.warn(e.message, e)
                    flash.message = e.message
                    redirect(controller: "tbPcInfo", action: "list")
                    return
                }
            }

        }
        return ids
    }
    //自动处理
    def autoPay = {
        def query = {
            eq('tradeStatus', '1')
            eq('payStatus', '3')
            if (params.flag == 'S') {
                eq('tradeType', 'S')
            }
            if (params.flag == 'F') {
                eq('tradeType', 'F')
            }
            if (params.startTime) {
                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
            }
            if (params.endTime) {
                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
            }
            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid", "%" + params.batchBizid+ "%")
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                like("tradeCardnum", "%" +params.tradeCardnum+ "%")
            }
            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }
            if (params.bankNameSearch != null && params.bankNameSearch != "") {
                def banks = TbAdjustBank.executeQuery("select bankNames from TbAdjustBank where bankCode=? and type=? ",params.bankNameSearch, params.flag)
                println 'bankName ' + params.bankNameSearch + ' &type ' + params.flag + ' &banks ' + banks
                'in'("tradeAccountname", banks)
                /*def bomerchant;
                def banknames;
                if (params.chinapay == 'hchinapay') {
                    if (params.flag == 'F') {
                        bomerchant = BoMerchant.executeQuery("select acquireIndexc from BoMerchant where acquireIndexc like 'DFH%' and channelSts='0'")
                        //====
                        String name = "";
                        for (int i = 0; i < bomerchant.size(); i++) {
                            String na = bomerchant[i].split('-')[1]
                            name = name + "'" + na + "'"
                            if (i < bomerchant.size() - 1) {name = name + ","}

                        }
                        banknames = TbAdjustBank.executeQuery(" select bankNames from TbAdjustBank t where t.bankCode in (" + name + ")")
                        //====
                    }
                    else if (params.flag == 'S') {
                        bomerchant = BoMerchant.executeQuery("select acquireIndexc from BoMerchant where acquireIndexc like 'DSH%' and channelSts='0'")
                        //====
                        String name = "";
                        for (int i = 0; i < bomerchant.size(); i++) {
                            String na = bomerchant[i].split('-')[1]
                            name = name + "'" + na + "'"
                            if (i < bomerchant.size() - 1) {name = name + ","}

                        }
                        banknames = TbAdjustBank.executeQuery(" select bankNames from TbAdjustBank t where t.bankCode in (" + name + ")")
                        //====
                    }

                    'in'("tradeAccountname", banknames)

                }
                else {
                   // def bankName = BoBankDic.get(params.bankNameSearch).name
                     def bankCode = BoBankDic.get(params.bankNameSearch).code

                   def  bnames = TbAdjustBank.executeQuery(" select bankNames from TbAdjustBank t where t.bankCode = '"+ (bankCode.toUpperCase())+"'" )
                    'in'("tradeAccountname", bnames)
                }*/
            }

        }
        TbPcInfo tbPcInfo = new TbPcInfo()
        def ids
        double amount = 0
        double fee = 0
        double accamount = 0
        boolean flag = true
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        if (results.size() > 0) {
            results.each {
                amount = amount + (it.tradeAmount as double)
                fee = fee + ((it.tradeFee ? it.tradeFee : 0) as double)
                if (it.tradeFeetype == '0') {    //即扣
                    accamount = accamount + (((it.tradeAmount ? it.tradeAmount : 0) as double) - ((it.tradeFee ? it.tradeFee : 0) as double))
                } else {
                    accamount = accamount + ((it.tradeAmount ? it.tradeAmount : 0) as double)
                }
            }
            def obj = BoAcquirerAccount.findById((params.bankName) as long)
            tbPcInfo.tbPcDate = new Date()
            tbPcInfo.tbPcItems = results.size()
            tbPcInfo.tbPcAmount = amount
            if (results.get(0).tradeType == 'F') {
                tbPcInfo.tbPcAccamount = accamount
                tbPcInfo.tbPcFee = fee
            }

            tbPcInfo.tbPcDkChanel = (params.bankName as long)
            tbPcInfo.tbPcDkChanelname = obj.bank.name + '-' + obj.aliasName
            tbPcInfo.tbPcDkStatus = '1'
            tbPcInfo.tbPcCheckStatus = '1'
            tbPcInfo.tbSfFlag = params.flag
            tbPcInfo.tbDealstyle = 'autoPay'
            String flagTemp = "false"
           // TbAgentpayDetailsInfo.withTransaction {status ->
                try {
                    if (obj.bank.code.equalsIgnoreCase("HCHINAPAY")) {  //广洲好易联，10000笔/批次；
                        ids = tbPcSave(tbPcInfo, results, 10000)
                        flagTemp = sendToBank(ids)
                    }
                    if(obj.bank.code.equalsIgnoreCase("ICBC")){
                        ids = tbPcSave(tbPcInfo,results,2000)
                        def filePath = "grails-app/upload/icbcReqXml/";//设置上传路径
                        flagTemp = icbcPayService.sendToBank(ids,filePath)
                    }
                }
                catch (Exception e) {
                   // status.setRollbackOnly()
                    log.warn(e.message, e)
                    flagTemp = e.message
                    flash.message = flagTemp
                    if (params.flag == 'S') {
                        redirect(action: "dsPayList")
                    } else {
                        redirect(action: "payList")
                    }
                    return
                }
           // }
            if (flagTemp == "true") {
                String str = ""
                for (int i = 0; i < ids.size(); i++) {
                    str = str + (ids[i] as String) +","
                }
                flash.message = "批次" + str + "已发送往银行!"
                if (params.flag == 'S') {
                    redirect(action: "dsPayList")
                } else {
                    redirect(action: "payList")
                }
            } else {
                flash.message = "发送银行失败!" + flagTemp
            }

        }
        else {
            flash.message = "无明细,无法生成批次!"
            if (params.flag == 'S') {
                redirect(action: "dsPayList")
            } else {
                redirect(action: "payList")
            }

        }
    }
    def reFcheckPage = {            //查询待退款的所有明细
        def query = {
            eq("payStatus", "7")
//            if (params.startTime) {
//                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }

                 //guonan update 2011-12-29
            validDated(params)
            if (params.startTime) {
            ge('tradeSysdate', Date.parse('yyyy-MM-dd', params.startTime))
             }
             if (params.endTime) {
            lt('tradeSysdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
             }


            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid", "%" + params.batchBizid+ "%")
            }
            if (params.tradeType != "" && params.tradeType != null) {
                eq('tradeType', params.tradeType)
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

            if (params.id != null && params.id != "") {
                like("dkPcNo", "%" + params.id+ "%")
            }
            if (params.bankNames != null && params.bankNames != "") {
                println 'load banks ........ '
                def banks = TbAdjustBank.executeQuery("select bankNames from TbAdjustBank where bankCode=? and type='F'",params.bankNames)
                println 'banks ' + banks
                'in'("tradeAccountname", banks)
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
                } else {
                    isNull("id")
                }
            }

        }
        def summ = TbAgentpayDetailsInfo.createCriteria().get {
            and query
            projections {
                sum('tradeAmount')
                sum('tradeFee')
            }
        }
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        def total = TbAgentpayDetailsInfo.createCriteria().count(query)
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: total, bankNameList: loadOuterBanks(), bankChanelList: bankChanelList('F'),totalAmount:summ[0],totalFee:summ[1]]
    }
    def reTcheckPage = {
        def query = {
            eq("payStatus", "8")
//            if (params.startTime) {
//                ge("tradeSysdate", Date.parse("yyyy-MM-dd", params.startTime))
//            }
//            if (params.endTime) {
//                le("tradeSysdate", Date.parse("yyyy-MM-dd", params.endTime) + 1)
//            }

               //guonan update 2011-12-29
            validDated(params)
             if (params.startTime) {
            ge('tradeSysdate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
            lt('tradeSysdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }

            if (params.batchBizid != null && params.batchBizid != "") {
                like("batchBizid",  "%" + params.batchBizid+ "%")
            }
            if (params.tradeType != "" && params.tradeType != null) {
                eq('tradeType', params.tradeType)
            }
            if (params.tradeCardname != null && params.tradeCardname != "") {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum != null && params.tradeCardnum != "") {
                like("tradeCardnum","%" +  params.tradeCardnum+ "%")
            }
            if (params.tradeAccountname != null && params.tradeAccountname != "") {
                like("tradeAccountname","%" +  params.tradeAccountname)
            }
            if (params.tradeAccounttype != null && params.tradeAccounttype != "") {
                eq("tradeAccounttype", params.tradeAccounttype)
            }


            if (params.id != null && params.id != "") {
                eq("dkPcNo", params.id)
            }
            if (params.bankNames != null && params.bankNames != "") {
                def banks = TbAdjustBank.executeQuery("select bankNames from TbAdjustBank where bankCode=? and type='F'",params.bankNames)
                println 'banks ' + banks
                'in'("tradeAccountname", banks)
                //eq("tradeAccountname", BoBankDic.get(params.bankNameSearch).name)
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
                } else {
                    isNull("id")
                }
            }
        }
        def summ = TbAgentpayDetailsInfo.createCriteria().get {
            and query
            projections {
                sum('tradeAmount')
                sum('tradeFee')
            }
        }
        def results = TbAgentpayDetailsInfo.createCriteria().list(params, query)
        def total = TbAgentpayDetailsInfo.createCriteria().count(query)
        [tbAgentpayDetailsInfoInstanceList: results, tbAgentpayDetailsInfoInstanceTotal: total, bankNameList: loadOuterBanks(), bankChanelList: bankChanelList('F'),totalAmount:summ[0],totalFee:summ[1]]
    }
    def reFcheck = {
        def ids = params.ids.substring(0, params.ids.length() - 1)
        def name = session.op.name
        int updateCount = TbAgentpayDetailsInfo.executeUpdate("update TbAgentpayDetailsInfo t set t.tradeRefued = '1' , refundFirstname='" + name + "' where t.id in (" + ids + ")")
        redirect(action: "reFcheckPage")
    }
    def reTcheck = {

        def name = session.op.name
        TbAgentpayDetailsInfo.withTransaction {status ->

            try {
                def ids = params.ids.substring(0, params.ids.length() - 1)
                def id = ids.split(",")
                int updateCount = TbAgentpayDetailsInfo.executeUpdate("update TbAgentpayDetailsInfo t set refundLastname='" + name + "',t.tradeRefued='2',t.tradeStatus='7',t.tradeDonedate=sysdate where t.id in (" + ids + ")")

                for (int i = 0; i < id.size(); i++) {
                    TbAgentpayDetailsInfo tbAgentpayDetailsInfoInstance = TbAgentpayDetailsInfo.get(String.valueOf(id[i])) //终审通过后直接进行退款记账
                    refusefDealAccount(tbAgentpayDetailsInfoInstance)
                }

            } catch (Exception e) {
                //roll back
                status.setRollbackOnly()
                log.warn(e.message, e)
                flash.message = e.message
                redirect(action: "reTcheckPage")
                return
            }
            redirect(action: "reTcheckPage")
        }
    }
    /**
     * 拒绝退款记账
     * @param tbAgentpayDetailsInfoTemp
     * @return
     */
    def fDealAccount(TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp) throws Exception {

        def sysFeeAccNo = BoInnerAccount.findByKey('feeAcc').accountNo//平台手续费账户
        def sysFeeInAdvAccNo = BoInnerAccount.findByKey('feeInAdvance').accountNo//系统应收手续费账号
        CmCustomer cmCustomer = CmCustomer.findByCustomerNo(tbAgentpayDetailsInfoTemp.getBatchBizid())
        def billAccountNo = cmCustomer.accountNo//商户现金账户
        BoCustomerService boCustomerService = new BoCustomerService()
        boCustomerService.customerId = cmCustomer.id
        //boCustomerService.serviceCode = "agentpay"
        def type = tbAgentpayDetailsInfoTemp.tradeType
        if (type == 'S') {
            boCustomerService.serviceCode = "agentcoll"
        } else if (type == 'F') {
            boCustomerService.serviceCode = "agentpay"
        }
        boCustomerService = BoCustomerService.find(boCustomerService)
        def serverAccountNo = boCustomerService.srvAccNo //商户服务账户
        def feeInAdvAccNo = boCustomerService.feeAccNo

        if (tbAgentpayDetailsInfoTemp.tradeFeetype == "0") {//即扣的

            if (type == 'F') {
                def cmdList = accountClientService.buildTransfer(null, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeAmount as BigDecimal) * 100) as Integer, 'agentpay', tbAgentpayDetailsInfoTemp.id, '0', " 代付退款记账")
                if ((tbAgentpayDetailsInfoTemp.tradeFee * 100) as Integer != 0) {
                    // if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {
                    cmdList = accountClientService.buildTransfer(cmdList, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代付退手续费记账")
                    /* } else {
                        cmdList = accountClientService.buildTransfer(cmdList, serverAccountNo, sysFeeAccNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代付退手续费记账")
                    }*/
                }

                def transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
                if ((transResult.result == 'true')) {
                    print "成功"
                } else {
                    throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                    print "失败"
                }
            }/*else if(type == 'S'){
                def cmdList = null
                if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {
                    cmdList = accountClientService.buildTransfer(null, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代收退手续费记账")
                } else {
                    cmdList = accountClientService.buildTransfer(null, serverAccountNo, sysFeeAccNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代收退手续费记账")
                }
                def transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
                if ((transResult.result == 'true')) {
                    print "成功"
                } else {
                    throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                    print "失败"
                }
            }*/
        }
        else if (tbAgentpayDetailsInfoTemp.tradeFeetype == "1") {  //后返的

            def cmdList = null
            if (tbAgentpayDetailsInfoTemp.tradeType == 'F') {
                cmdList = accountClientService.buildTransfer(null, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeAmount as BigDecimal) * 100) as Integer, 'agentpay', tbAgentpayDetailsInfoTemp.id, '0', "代付退款记账")
                if ((tbAgentpayDetailsInfoTemp.tradeFee * 100) as Integer != 0) {
                    // if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {  // 若退手续费刚下,若不退,则不动了
                    cmdList = accountClientService.buildTransfer(cmdList, sysFeeInAdvAccNo, feeInAdvAccNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代付退手续费记账")
                    //  }
                }


                def transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
                if (transResult.result == 'true') {
                    print "成功" + "==================="
                } else {
                    throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                }
            }/*else if(tbAgentpayDetailsInfoTemp.tradeType=='S'){
                def transResult
                if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {  // 若退手续费刚下,若不退,则不动了
                    cmdList = accountClientService.buildTransfer(null, sysFeeInAdvAccNo, feeInAdvAccNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代收退手续费记账")
                     transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
                     if (transResult.result == 'true') {
                    print "成功" + "==================="
                } else {
                    throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                }
                }


            }*/

        }

    }
    /**
     * 终审退款记账
     * @param tbAgentpayDetailsInfoTemp
     * @return
     */
    def refusefDealAccount(TbAgentpayDetailsInfo tbAgentpayDetailsInfoTemp) throws Exception {

        def sysFeeAccNo = BoInnerAccount.findByKey('feeAcc').accountNo//平台手续费账户
        def sysFeeInAdvAccNo = BoInnerAccount.findByKey('feeInAdvance').accountNo//系统应收手续费账号
        CmCustomer cmCustomer = CmCustomer.findByCustomerNo(tbAgentpayDetailsInfoTemp.getBatchBizid())
        def billAccountNo = cmCustomer.accountNo//商户现金账户
        BoCustomerService boCustomerService = new BoCustomerService()
        boCustomerService.customerId = cmCustomer.id
        //boCustomerService.serviceCode = "agentpay"
        def type = tbAgentpayDetailsInfoTemp.tradeType
        if (type == 'S') {
            boCustomerService.serviceCode = "agentcoll"
        } else if (type == 'F') {
            boCustomerService.serviceCode = "agentpay"
        }
        boCustomerService = BoCustomerService.find(boCustomerService)
        def serverAccountNo = boCustomerService.srvAccNo //商户服务账户
        def feeInAdvAccNo = boCustomerService.feeAccNo

        if (tbAgentpayDetailsInfoTemp.tradeFeetype == "0") {//即扣的

            if (type == 'F') {
                def cmdList = accountClientService.buildTransfer(null, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeAmount as BigDecimal) * 100) as Integer, 'agentpay', tbAgentpayDetailsInfoTemp.id, '0', " 代付退款记账")
                if ((tbAgentpayDetailsInfoTemp.tradeFee * 100) as Integer != 0) {
                    if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {
                        cmdList = accountClientService.buildTransfer(cmdList, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代付退手续费记账")
                    } else {
                        cmdList = accountClientService.buildTransfer(cmdList, serverAccountNo, sysFeeAccNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代付退手续费记账")
                    }
                }

                def transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
                if ((transResult.result == 'true')) {
                    print "成功"
                } else {
                    throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                    print "失败"
                }
            }
        }
        else if (tbAgentpayDetailsInfoTemp.tradeFeetype == "1") {  //后返的

            def cmdList = null
            if (tbAgentpayDetailsInfoTemp.tradeType == 'F') {
                cmdList = accountClientService.buildTransfer(null, serverAccountNo, billAccountNo, ((tbAgentpayDetailsInfoTemp.tradeAmount as BigDecimal) * 100) as Integer, 'agentpay', tbAgentpayDetailsInfoTemp.id, '0', "代付退款记账")
                if ((tbAgentpayDetailsInfoTemp.tradeFee * 100) as Integer != 0) {
                    if (tbAgentpayDetailsInfoTemp.tradeFeestyle == "T") {  // 若退手续费刚下,若不退,则不动了
                        cmdList = accountClientService.buildTransfer(cmdList, sysFeeInAdvAccNo, feeInAdvAccNo, ((tbAgentpayDetailsInfoTemp.tradeFee as BigDecimal) * 100) as Integer, 'fee', tbAgentpayDetailsInfoTemp.id, '0', "代付退手续费记账")
                    }
                }


                def transResult = accountClientService.batchCommand(UUID.randomUUID().toString().replaceAll('-', ''), cmdList)
                if (transResult.result == 'true') {
                    print "成功" + "==================="
                } else {
                    throw new Exception("账务和清结算账务处理失败!错误原因:" + transResult.errorMsg)
                }
            }
        }

    }

    def sendToBank(def ids) throws Exception {
        String flag = "true"

        String sendString = ""
        String message = ""

        for (int i = 0; i < ids.size(); i++) {
//            def tbAgentpayDetailsInfos = TbAgentpayDetailsInfo.executeQuery("from TbAgentpayDetailsInfo where dkPcNo=" + (ids[i] as String))
//            //flag = singleAmountCheck(tbAgentpayDetailsInfos)//校验单笔金额是否超限
            TbPcInfo tbPcInfo = TbPcInfo.get(ids[i])
            if (tbPcInfo.tbSfFlag == 'S') {
                sendString = combineColl(ids[i])//代收组合
            } else if (tbPcInfo.tbSfFlag == 'F') {
                sendString = combinePay(ids[i])//代付组合
            }
            String strRnt = signMsg(sendString, tbPcInfo.tbSfFlag)
            send(strRnt)
            tbPcInfo.tbPcDkStatus='2'//已发送到银行
            tbPcInfo.save(flush:true)
        }
         return true
    }
    def autoBd(def id) throws Exception {
        String sendString = ""
            TbPcInfo tbPcInfo = TbPcInfo.get(id)
            if (tbPcInfo.tbSfFlag == 'S') {
                sendString = combineColl(id)//代收组合
            } else if (tbPcInfo.tbSfFlag == 'F') {
                sendString = combinePay(id)//代付组合
            }
            String strRnt = signMsg(sendString, tbPcInfo.tbSfFlag)
            try {
                String flag = send(strRnt)
            } catch (Exception e) {
                def mes = e.message
                if (mes.contains("REQ_SN already exists")) {
                    tbPcInfo.tbPcDkStatus = '2'//已发送到银行
                    tbPcInfo.save(flush: true)
                }else{
                    throw new Exception(mes)
                }
                e.printStackTrace()
            }

//        println flag+"自动补单银行返回"
            tbPcInfo.tbPcDkStatus='2'//已发送到银行
            tbPcInfo.save(flush:true)
    }

    def combineColl(def id) {//代收组合XML
        StringBuffer sb = new StringBuffer()
        Properties p = new Properties();
        p.load(this.class.classLoader.getResourceAsStream("bank/busybankcode.properties"))
        TbPcInfo tbPcInfo = TbPcInfo.get(id)
        def results = TbAgentpayDetailsInfo.executeQuery("from TbAgentpayDetailsInfo where dkPcNo=" + (id as String))
        sb.append("<?xml version='1.0' encoding='GBK'?>")
        sb.append("<GZELINK>")
        sb.append("<INFO>")
        sb.append("<TRX_CODE>100001</TRX_CODE>")
        sb.append("<VERSION>04</VERSION>")
        sb.append("<DATA_TYPE>2</DATA_TYPE>")
        sb.append("<LEVEL>5</LEVEL>")
        sb.append("<USER_NAME>").append(FarmConstants.haoEasyUserNos).append("</USER_NAME>")
        sb.append("<USER_PASS>").append(FarmConstants.haoEasyUserPass).append("</USER_PASS>")
        sb.append("<REQ_SN>").append((tbPcInfo.tbPcDate).format("yyyyMMdd") + "0" + (id as String)).append("</REQ_SN>")
        sb.append("<SIGNED_MSG></SIGNED_MSG> ")
        sb.append("</INFO>")
        sb.append("<BODY>")
        sb.append("<TRANS_SUM>")
        sb.append("<BUSINESS_CODE>14900</BUSINESS_CODE>") //固定写其它(好易联建议)
        sb.append("<MERCHANT_ID>").append(FarmConstants.haoEasyChinaPayMerNos).append("</MERCHANT_ID>")
        sb.append("<SUBMIT_TIME>").append(new Date().format("yyyyMMddHHmmss")).append("</SUBMIT_TIME>")
        sb.append("<TOTAL_ITEM>").append(tbPcInfo.tbPcItems).append("</TOTAL_ITEM>")
        sb.append("<TOTAL_SUM>").append(((BigDecimal.valueOf(tbPcInfo.tbPcAmount) * BigDecimal.valueOf(100)) as Long)).append("</TOTAL_SUM>")
        sb.append("</TRANS_SUM>")
        sb.append("<TRANS_DETAILS>")
        def i = 0
        def bn
        results.each {
            i++
            sb.append("<TRANS_DETAIL>")
            sb.append("<SN>").append(i).append("</SN>")
            sb.append("<E_USER_CODE/>")
            bn = it.tradeAccountname
            def list = TbAdjustBank.createCriteria().list {
                eq('bankNames', bn)
                eq('type', 'S')
                not {
                    eq('bankCode','UNIONPAY')
                    eq('bankCode','HCHINAPAY')
                }
            }
            def note
            if(list){
                note = list.get(0).note
            }else{
                note = it.tradeAccountname
            }
            //def note = TbAdjustBank.findByBankNames(it.tradeAccountname).note
            if (note == '平安银行' || note == '广州银行') {
                note = '城市商业银行'
            }
            String bankcodeTemp = p.getProperty(new String(note.getBytes("gbk"), "ISO-8859-1"));
            sb.append("<BANK_CODE>").append(bankcodeTemp).append("</BANK_CODE>")
            sb.append("<ACCOUNT_TYPE></ACCOUNT_TYPE>")
            sb.append("<ACCOUNT_NO>").append(it.tradeCardnum).append("</ACCOUNT_NO>")
            sb.append("<ACCOUNT_NAME>").append(it.tradeCardname).append("</ACCOUNT_NAME>")
            if (note == '广州银行') {
                sb.append("<PROVINCE/>")
                sb.append("<CITY>").append(it.tradeRemark.split(";")[1].replace("市", "")).append("</CITY>")
            } else {
                sb.append("<PROVINCE>").append(it.tradeRemark.split(";")[0].replace("省", "").replace("自治区", "").replace("市", "")).append("</PROVINCE>")
                sb.append("<CITY>").append(it.tradeRemark.split(";")[1].replace("市", "")).append("</CITY>")
            }
            sb.append("<BANK_NAME>").append(it.tradeAccountname).append("</BANK_NAME>")
            sb.append("<ACCOUNT_PROP>").append(it.tradeAccounttype).append("</ACCOUNT_PROP>")
            //println   "明细金额："+BigDecimal.valueOf(it.tradeAmount).multiply(BigDecimal.valueOf(100));
            sb.append("<AMOUNT>").append(BigDecimal.valueOf(it.tradeAmount).multiply(BigDecimal.valueOf(100)) as Long).append("</AMOUNT>")
            sb.append("<CURRENCY></CURRENCY>")
            sb.append("<PROTOCOL/>")
            sb.append("<PROTOCOL_USERID/>")
            sb.append("<ID_TYPE/>")
            sb.append("<ID/>")
            sb.append("<TEL/>")
            sb.append("<RECKON_ACCOUNT/>")
            sb.append("<CUST_USERID/>")
            sb.append("<REMARK>保险理赔</REMARK>")
            sb.append("<RESERVE1/>")
            sb.append("<RESERVE2/>")
            sb.append("</TRANS_DETAIL>")
        }
        sb.append("</TRANS_DETAILS>")
        sb.append("</BODY>")
        sb.append("</GZELINK>")
        return sb.toString()
    }

    def combinePay(def id) {//代付组合XML
        StringBuffer sb = new StringBuffer()
        Properties p = new Properties();
        p.load(this.class.classLoader.getResourceAsStream("bank/busybankcode.properties"))
        TbPcInfo tbPcInfo = TbPcInfo.get(id)
        def results = TbAgentpayDetailsInfo.executeQuery("from TbAgentpayDetailsInfo where dkPcNo=" + (id as String))
        sb.append("<?xml version='1.0' encoding='GBK'?>")
        sb.append("<GZELINK>")
        sb.append("<INFO>")
        sb.append("<TRX_CODE>100002</TRX_CODE>") //代付为100002
        sb.append("<VERSION>04</VERSION>")
        sb.append("<DATA_TYPE>2</DATA_TYPE>")
        sb.append("<LEVEL>5</LEVEL>")
        sb.append("<USER_NAME>").append(FarmConstants.haoEasyUserNof).append("</USER_NAME>")
        sb.append("<USER_PASS>").append(FarmConstants.haoEasyUserPass).append("</USER_PASS>")
        sb.append("<REQ_SN>").append((tbPcInfo.tbPcDate).format("yyyyMMdd") + "0" + (id as String)).append("</REQ_SN>")
        sb.append("<SIGNED_MSG></SIGNED_MSG> ")
        sb.append("</INFO>")
        sb.append("<BODY>")
        sb.append("<TRANS_SUM>")
        sb.append("<BUSINESS_CODE>04900</BUSINESS_CODE>") //固定写其它(好易联建议)
        sb.append("<MERCHANT_ID>").append(FarmConstants.haoEasyChinaPayMerNof).append("</MERCHANT_ID>")
        sb.append("<SUBMIT_TIME>").append(new Date().format("yyyyMMddHHmmss")).append("</SUBMIT_TIME>")
        sb.append("<TOTAL_ITEM>").append(tbPcInfo.tbPcItems).append("</TOTAL_ITEM>")
        sb.append("<TOTAL_SUM>").append(((BigDecimal.valueOf(tbPcInfo.tbPcAmount) * BigDecimal.valueOf(100)) as Long)).append("</TOTAL_SUM>")
        sb.append("</TRANS_SUM>")
        sb.append("<TRANS_DETAILS>")
        def i = 0
        def bn
        results.each {
            i++
            sb.append("<TRANS_DETAIL>")
            sb.append("<SN>").append(i).append("</SN>")
            sb.append("<E_USER_CODE/>")
            bn = it.tradeAccountname
            def list = TbAdjustBank.createCriteria().list {
                eq('bankNames', bn)
                eq('type', 'F')
                not {
                    eq('bankCode','UNIONPAY')
                    eq('bankCode','HCHINAPAY')
                }
            }
            def note
            if(list){
                note = list.get(0).note
            }else{
                note = it.tradeAccountname
            }
            //def note = TbAdjustBank.findByBankNames(it.tradeAccountname).note
            if (note == '平安银行' || note == '广州银行') {
                note = '城市商业银行'
            }
            String bankcodeTemp = p.getProperty(new String(note.getBytes("gbk"), "ISO-8859-1"));
            sb.append("<BANK_CODE>").append(bankcodeTemp).append("</BANK_CODE>")
            sb.append("<ACCOUNT_TYPE></ACCOUNT_TYPE>")
            sb.append("<ACCOUNT_NO>").append(it.tradeCardnum).append("</ACCOUNT_NO>")
            sb.append("<ACCOUNT_NAME>").append(it.tradeCardname).append("</ACCOUNT_NAME>")
            if (note == '广州银行') {
                sb.append("</PROVINCE>")
                sb.append("<CITY>").append(it.tradeRemark.split(";")[1].replace("市", "")).append("</CITY>")
            } else {
                sb.append("<PROVINCE>").append(it.tradeRemark.split(";")[0].replace("省", "").replace("自治区", "").replace("市", "")).append("</PROVINCE>")
                sb.append("<CITY>").append(it.tradeRemark.split(";")[1].replace("市", "")).append("</CITY>")
            }

            sb.append("<BANK_NAME>").append(it.tradeAccountname).append("</BANK_NAME>")
            sb.append("<ACCOUNT_PROP>").append(it.tradeAccounttype).append("</ACCOUNT_PROP>")
            sb.append("<AMOUNT>").append(BigDecimal.valueOf(it.tradeAmount).multiply(BigDecimal.valueOf(100)) as Long).append("</AMOUNT>")
            sb.append("<CURRENCY></CURRENCY>")
            sb.append("<PROTOCOL/>")
            sb.append("<PROTOCOL_USERID/>")
            sb.append("<ID_TYPE/>")
            sb.append("<ID/>")
            sb.append("<TEL/>")
            sb.append("<CUST_USERID/>")
            sb.append("<RECKON_ACCOUNT/>")
            sb.append("<REMARK>保险理赔</REMARK>")
            sb.append("<RESERVE1/>")
            sb.append("<RESERVE2/>")
            sb.append("</TRANS_DETAIL>")
        }
        sb.append("</TRANS_DETAILS>")
        sb.append("</BODY>")
        sb.append("</GZELINK>")
        return sb.toString()
    }
    /**
     * 数据签名
     * comment here
     * @param strData
     * @return
     * @since gnete-ora 0.0.0.1
     */
    private String signMsg(String strData, String flag) {
        String strRnt = "";
        //签名

        Crypt crypt = new Crypt();
        def pathPfx
        if (flag == 'F') {
            pathPfx = ConfigurationHolder.config.dsf.certPath + "hunionPay" + File.separator + "BHYS2.pfx"
        } else {
            pathPfx = ConfigurationHolder.config.dsf.certPath + "hunionPay" + File.separator + "BHYS4.pfx"
        }

        String strMsg = strData.replaceAll("<SIGNED_MSG></SIGNED_MSG>", "");
       // System.out.println("签名原文:" + strMsg);
        if (crypt.SignMsg(strMsg, pathPfx, "123456")) {
            String signedMsg = crypt.getLastSignMsg();
            strRnt = strData.replaceAll("<SIGNED_MSG></SIGNED_MSG>", "<SIGNED_MSG>" + signedMsg + "</SIGNED_MSG>");
           // System.out.println("请求交易报文:" + strRnt);
        }
        else {
            log.error(crypt.getLastErrMsg());
            strRnt = strData;
        }
        return strRnt;
    }
    /**
     * 验证签名信息
     */
    private boolean verifySign(String strXML) {
        //签名
        Crypt crypt = new Crypt();
        def pathCer = ConfigurationHolder.config.dsf.certPath + "hunionPay" + File.separator + "gnete_pds.cer"
        int iStart = strXML.indexOf("<SIGNED_MSG>");
        if (iStart != -1) {
            int end = strXML.indexOf("</SIGNED_MSG>");
            String signedMsg = strXML.substring(iStart + 12, end);
            String strMsg = strXML.substring(0, iStart) + strXML.substring(end + 13);
           // System.out.println("返回来的签名串是" + signedMsg);

            if (crypt.VerifyMsg(signedMsg, strMsg, pathCer)) {
                System.out.println("verify ok");

                return true;
            }
            else {
                System.out.println(crypt.getLastErrMsg());
                System.out.println("verify error");
                return false;
            }
        }
        return true;
    }
    /*
	 * 压缩字符串为 byte[] 储存可以使用new sun.misc.BASE64Encoder().encodeBuffer(byte[] b)方法
	 * 保存为字符串
	 *
	 * @param str 压缩前的文本
	 *
	 * @return
	 */

    private final byte[] compresszip(String str) {
        if (str == null)
            return null;

        byte[] compressed;
        ByteArrayOutputStream out = null;

        java.util.zip.ZipOutputStream zout = null;

        try {
            out = new ByteArrayOutputStream();
            zout = new java.util.zip.ZipOutputStream(out);
            zout.putNextEntry(new java.util.zip.ZipEntry("0"));
            zout.write(str.getBytes("GBK"));
            zout.closeEntry();
            compressed = out.toByteArray();
        } catch (IOException e) {
            compressed = null;
        } finally {
            if (zout != null) {
                try {
                    zout.close();
                } catch (IOException e) {
                }
            }
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e) {
                }
            }
        }

        return compressed;
    }
    /**
     * 压缩数据
     * comment here
     * @param strData
     * @param bCompress
     * @return
     * @since gnete-pds 0.0.0.1
     */
    private String compress(String strData) {
        String strRnt = new sun.misc.BASE64Encoder().encode(this.compresszip(strData));
        return strRnt;
    }
    /**
     *
     * comment here
     * @param bCompress 是否压缩
     * @since gnete-pds 0.0.0.1
     */
    private boolean send(String strSendData) throws Exception {
        String flag = ""
        HttpClient httpClient = new HttpClient();
        httpClient.getHttpConnectionManager().getParams().setConnectionTimeout(300*1000);
        httpClient.getHttpConnectionManager().getParams().setSoTimeout(300*1000);
        PostMethod postMethod = null;
        def gateway = ConfigurationHolder.config.gateway.inner.server
        char a = gateway.charAt(gateway.length()-1);
		if(a=='/'){
			gateway = gateway.substring(0, gateway.length()-1);
		}
        postMethod = new PostMethod(gateway+"/ISMSApp/HUnionPayTransfer/sendData");
        httpClient.getParams().setParameter(HttpMethodParams.HTTP_CONTENT_CHARSET, "GBK");
        strSendData = this.compress(strSendData);
         //println "压缩后"+strSendData+"压缩后END"
        postMethod.setRequestBody(strSendData);
        long start = System.currentTimeMillis();
       // System.out.println("cost:" + (start));
        int statusCode = httpClient.executeMethod(postMethod);
        System.out.println("发送银行耗时cost:" + (System.currentTimeMillis() - start));

        if (statusCode != HttpStatus.SC_OK) {
            byte[] responseBody = postMethod.getResponseBody();
            String strResp = new String(responseBody, "GBK");
            throw new Exception("发送银行失败:" + strResp)
        }
        else {
            byte[] responseBody = postMethod.getResponseBody();
            System.out.println("银行返回时耗时cost:" + (System.currentTimeMillis() - start));
            String strResp = new String(responseBody, "GBK");
            if (strResp == "") {
                flag = "网络超时!请重新发送"
                throw new Exception(flag);
            } else {
                String reStr = this.decompress(strResp, true);
               // System.out.println("还原:" + reStr);
                Document doc = DocumentHelper.parseText(reStr);
                Element root = doc.getRootElement();
                List attrList = root.elements();
                Element bo = (Element) attrList.get(0);
                String RET_CODE = bo.elementText("RET_CODE");
                String errMsg = "";
                errMsg = bo.elementText("ERR_MSG");
                if (RET_CODE != "0000") {
                    flag = "报文内容检查错" + errMsg
                    throw new Exception(flag);
                }
                if (this.verifySign(strResp)) {
                    System.out.println("验签正确，处理服务器返回的报文");
                    flag = "true"
                } else {
                    flag = "银行验签失败"
                    throw new Exception(flag + strResp)
                }
            }

        }
        postMethod.releaseConnection();
        //return flag
    }

    /**
     * 解压数据
     * comment here
     * @param strData
     * @param bCompress
     * @return
     * @since gnete-pds 0.0.0.1
     */
    private String decompress(String strData, boolean bCompress) {
        String strRnt = strData;
        if (bCompress) {
            try {
                strRnt = this.decompresszip(new sun.misc.BASE64Decoder().decodeBuffer(strData));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return strRnt;
    }
    /**
     * 将压缩后的 byte[] 数据解压缩
     *
     * @param compressed
     *            压缩后的 byte[] 数据
     * @return 解压后的字符串
     */
    private final String decompresszip(byte[] compressed) {
        if (compressed == null)
            return null;

        ByteArrayOutputStream out = null;
        ByteArrayInputStream inpu = null;
        ZipInputStream zin = null;
        String decompressed;
        try {
            out = new ByteArrayOutputStream();
            inpu = new ByteArrayInputStream(compressed);
            zin = new ZipInputStream(inpu);
            java.util.zip.ZipEntry entry = zin.getNextEntry();
            byte[] buffer = new byte[1024];
            int offset = -1;
            while ((offset = zin.read(buffer)) != -1) {
                out.write(buffer, 0, offset);
            }
            decompressed = out.toString("GBK");
        } catch (IOException e) {
            decompressed = null;
        } finally {
            if (zin != null) {
                try {
                    zin.close();
                } catch (IOException e) {
                }
            }
            if (inpu != null) {
                try {
                    inpu.close();
                } catch (IOException e) {
                }
            }
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e) {
                }
            }
        }

        return decompressed;
    }

    def singleAmountCheck(def tbAgentpayDetailsInfos) throws  Exception{
        String flag = "true"
        for(int i=0;i<tbAgentpayDetailsInfos.size();i++){
           def amount = tbAgentpayDetailsInfos[i].tradeAmount
           def bankCode =TbAdjustBank.findByBankNames(tbAgentpayDetailsInfos[i].tradeAccountname).bankCode

           def channel = TbPcInfo.get(tbAgentpayDetailsInfos[i].dkPcNo as Long).tbPcDkChanel
           BoAcquirerAccount  boAcquirerAccount=new BoAcquirerAccount()
           def  bomerchant = BoMerchant.executeQuery(" from BoMerchant where acquirerAccount.id="+channel+" and acquireIndexc like'%"+bankCode+"'")
           double limitAmount = bomerchant[0].qutor

            if(amount>limitAmount){
                flag = "交易号"+tbAgentpayDetailsInfos[i].id+"单笔金额超限!"
               throw new Exception(flag)
            }
        }

        return flag

    }
    public static void main(String[] args){
        String s="abc";
        println s.toUpperCase();

    }
}
