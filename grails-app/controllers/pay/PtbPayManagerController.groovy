package pay

import boss.BoMerchant
import boss.BoAcquirerAccount
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import grails.converters.JSON
import java.text.SimpleDateFormat

class PtbPayManagerController {
    def pdbService
    def ipayService

    final static String httpPayUrl = ConfigurationHolder.config.pay.serverUrl
    /**
     * 付款
     */
    def pdkList = {
        try{
            params.max = Math.min(params.max ? params.int('max') : 10, 100)
            params.sort = params.sort ? params.sort : "id"
            params.order = params.order ? params.order : "asc"
            initParams(params)
            List bankChanelList = pdbService.bankChanelList('F')
            def bankList = pdbService.bankList('F')
            params.tradeType='F'
            def res = pdbService.ptbPayTradeList(query (params,false),query (params,true),true,params)
            [ptbPayTradeList:res.res,bankChanelList:bankChanelList,
                    bankList:bankList,ptbPayTradeTypeList:PtbPayTradeType.findAllByPayType("F"),
                    totalCount:res.totalCount,totalMoney:res.totalMoney]
        }catch (Throwable e){
            redirect(action: "pdkList")
        }
    }

    /**
     * 收款
     */
    def pskList = {
        try{
            params.max = Math.min(params.max ? params.int('max') : 10, 100)
            params.sort = params.sort ? params.sort : "id"
            params.order = params.order ? params.order : "asc"
            initParams(params)
            List bankChanelList = pdbService.bankChanelList('S')
            def bankList = pdbService.bankList('S')
            params.tradeType='S'
            def res = pdbService.ptbPayTradeList(query (params,false),query (params,true),true,params)
            [ptbPayTradeList:res.res,bankChanelList:bankChanelList,
                    bankList:bankList,ptbPayTradeTypeList:PtbPayTradeType.findAllByPayType("S"),
                    totalCount:res.totalCount,totalMoney:res.totalMoney]
        }catch (Throwable e){
            redirect(action: "pskList")
        }
    }

    /**
     * 渠道验证(ajax)
     */
    def onChanelChange = {
        def autoOrHandleMap = new HashMap()
        try{
            def chanelParams = ipayService.getChanelParams(params.merchantId,params.tradeType)
            if(chanelParams.autoOrHandle!="null"){
                autoOrHandleMap.put("autoOrHandle",chanelParams.autoOrHandle)
            }else{
                autoOrHandleMap.put("autoOrHandle",null)
            }
        }catch(Throwable e){
            log.error("验证渠道异常",e)
            autoOrHandleMap.put("error", '可能网络故障，请稍后再试!')
            autoOrHandleMap.put("autoOrHandle",null)
        }
        render autoOrHandleMap as JSON
    }

    /**
     * 生成批次
     */
    def makeBatch = {
        def ids
        try{
            initParams(params)
            BoMerchant boMerchant = BoMerchant.get(params.merchantId)
            BoAcquirerAccount boAcquirerAccount = boMerchant.getAcquirerAccount()
            params.bankAccountno  = boAcquirerAccount.getBankAccountNo()
            ids = pdbService.makeBatch(query (params,false),query (params,true),params)
            flash.message="生成批次成功"
        }catch (Throwable e){
            log.error("生成批次失败!",e)
            flash.message = "生成批次失败!"
        }finally{
            if(flash.message=="生成批次成功"&&params.batchStyle=="handle"){
                redirect(action: "tempList", params: [allIds: ids])
            }else{
                if("F".equals(params.tradeType)){
                    redirect(action: "pdkList",params: [bankId: params.bankId,startTime:params.startTime,
                        endTime:params.endTime,tradeType:params.tradeType,tradeAcctype:params.tradeAcctype,tradeCardtype:params.tradeCardtype,
                        tradeCardname:params.tradeCardname,tradeCardnum:params.tradeCardnum])
                }else{
                    redirect(action: "pskList",params: [bankId: params.bankId,startTime:params.startTime,
                        endTime:params.endTime,tradeType:params.tradeType,tradeAcctype:params.tradeAcctype,tradeCardtype:params.tradeCardtype,
                        tradeCardname:params.tradeCardname,tradeCardnum:params.tradeCardnum])
                }
            }
        }
    }

    /**
     * 手动打款中转页面
     */
    def tempList = {
        def s = (params.allIds as String).replace("[", "").replace("]", "")
        def l = s.split(",")
        Long[] allIds = new Long[l.length]
        if (s != "") {
            for (int i = 0; i < l.length; i++) {
                allIds[i] = (l[i]) as Long
            }
        } else {
            flash.message = "无明细,没有生成批次!"
        }

        def query = {
            eq('batchStatus', '0')
            'in'('id', allIds)
        }
        def results = PtbPayBatch.createCriteria().list(params, query)
        def Total = PtbPayBatch.createCriteria().count(query)
        if(!results){
            if(params.batchType=='F'){
                redirect(action: "pdkList")
            }else{
                redirect(action: "pskList")
            }
        }else{
            [ptbPayBatchList: results, ptbPayBatchTotal: Total,allIds:s]
        }
    }

    /**
     * 打款确认
     */
    def confirm = {
        def ids = params.ids.substring(0, params.ids.length() - 1)
        try{
            PtbPayBatch.executeUpdate(" update PtbPayBatch set batchStatus='1' where id in(" + ids + ")")
            flash.message = "打款完成"
        }catch (Throwable e){
            flash.message = "打款失败"
            log.error("打款确认异常",e)
        }
        redirect(action: "tempList", params: [allIds:params.allIds,
                batchType:PtbPayBatch.get(Integer.valueOf(ids.split(",")[0]) as Long).batchType])
    }

    /**
     * 下载
     */
    def downLoad = {
        try{
            def downInfo = ipayService.getDownLoadInfo(params.id)
            PtbPayBatch ptbPayBatch = PtbPayBatch.get(params.id as Long)
            int count = PtbPayTrade.countByBatchId(params.id)

            if(count==ptbPayBatch.batchCount){
                response.setHeader("Content-disposition", "attachment; filename=" + downInfo.filename)
                response.contentType = "application/x-rarx-rar-compressed"
                response.setCharacterEncoding("GBK")
                render downInfo.fileStr
            }else{
                render "批次笔数与交易明细笔数不一致!可能是交易明细还没有更新完成，请稍后再试!"
            }
        }catch (Throwable e){
            log.error("下载异常",e)
            render "下载异常,可能网络故障，请稍后再试!"
        }
    }

    /**
     * 付款对账页
     */
    def pdkCheckPage = {
        List bankChanelList = pdbService.bankChanelList('F')
        [bankChanelList:bankChanelList]
    }
    /**
     * 收款对账页
     */
    def pskCheckPage = {
        List bankChanelList = pdbService.bankChanelList('S')
        [bankChanelList:bankChanelList]
    }

    /**
     * 手工对账
     */
    def uploadAndCheck = {
        try{
            def res = ipayService.uploadAndCheck(params.merchantId,params.tradeType,params.batchId,request)
            flash.message = res.resMsg
        }catch (Throwable e){
            flash.message = "对账失败!可能是网络问题,再试一下~("+e.getCause()+")"
            log.error("对账异常",e)
        }finally{
            if("F".equals(params.tradeType)){
                    redirect(action: "pdkCheckPage")
                }else{
                    redirect(action: "pskCheckPage")
            }
        }
    }

    private def validDated(def params) {
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
    private def initParams(def params){
        validDated(params)
        if(params.bankId){
            PtbAdjustBank ptbAdjustBank = PtbAdjustBank.get(params.bankId)
            params.bankCode = ptbAdjustBank.bankCode
            params.bankName = ptbAdjustBank.bankAuthorityname
             //新版  银联打款限定渠道
            /*BoBankDic boBankDic = BoBankDic.findByCode(params.bankCode.toString().toLowerCase())
            if(boBankDic==null){
                 boBankDic = BoBankDic.findByCode(params.bankCode.toString().toUpperCase())
            }
            def bankType = PtbAdjustBank.executeQuery(" select distinct t.bankType from PtbAdjustBank t where t.bankCode ='"+ params.bankCode.toUpperCase()+"'" )
            if ("TH".equals(bankType?.get(0)?.toString())) {  //第三方，如 UNIONPAY,HCHINAPAY
                 bankChanelList = pdbService.bankChanelList('F',boBankDic?.id)
            }*/
        }
    }

    private def query (def params,def isProjections) {
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
        def query={
            if(isProjections){
                 projections{
                 countDistinct("id")
                 sum("tradeAmount")
                 }
            }
            eq("tradeType", params.tradeType)
            eq("tradeStatus", "0")
            if (params.tradeCode) {
                eq("tradeCode", params.tradeCode)
            }
            if(params.startTime){
                ge('tradeSubdate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if(params.endTime){
                lt('tradeSubdate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }
            /*祝哥说这个没用
             if (params.tradeCardtype) {
                 like("tradeCardtype", "%" + params.tradeCardtype + "%")
             }*/

            if (params.tradeCardname) {
                like("tradeCardname", "%" + params.tradeCardname + "%")
            }
            if (params.tradeCardnum) {
                eq("tradeCardnum", params.tradeCardnum)
            }
            if (params.tradeAcctype) {
                eq("tradeAcctype", params.tradeAcctype)
            }
            if (params.outTradeorder) {
                eq("outTradeorder", params.outTradeorder)
            }

            if(params.bankCode){
                def  bankNames = null;
                /* 旧版 模糊匹配
                 if ("UNIONPAY".equalsIgnoreCase(params.unionPay) || "HCHINAPAY".equalsIgnoreCase(params.unionPay)) {

                        def acquireIndexcs
                        if (params.unionPay == 'HCHINAPAY') {
                            acquireIndexcs = BoMerchant.executeQuery("select acquireIndexc from BoMerchant where acquireIndexc like 'DFH-%' and channelSts='0' and channelType='${params.tradeType}'")
                        }
                        else {
                            acquireIndexcs = BoMerchant.executeQuery("select acquireIndexc from BoMerchant where acquireIndexc like 'DF-%' and channelSts='0' and channelType='${params.tradeType}'")
                        }
                        String codes = "";
                        for (int i = 0; i < acquireIndexcs.size(); i++) {
                            String na = acquireIndexcs[i].split('-')[1]
                            codes = codes + "'" + na + "'"
                            if (i < acquireIndexcs.size() - 1) {
                                codes = codes + ","
                            }
                        }
                        if(codes){
                            bankNames = PtbAdjustBank.executeQuery(" select Trim(t.bankNames) from PtbAdjustBank t where t.bankCode in (" + codes + ")")
                        }
                        if(codes&&bankNames){
                            'in'("tradeBank", bankNames)
                        }else{
                            'in'("tradeBank", ['-1'])
                        }

                 }else{
                        bankNames = PtbAdjustBank.executeQuery(" select Trim(t.bankNames) from PtbAdjustBank t where t.bankCode ='"+ (params.bankCode.toUpperCase())+"'" )
                        if(bankNames){
                            'in'("tradeBank", bankNames)
                        }else{
                            'in'("tradeBank", [params.bankName])
                        }
                 }
                 */

                //新版
                def bankType = PtbAdjustBank.executeQuery(" select distinct t.bankType from PtbAdjustBank t where t.bankCode ='"+ params.bankCode.toUpperCase()+"'" )
                if ("TH".equals(bankType?.get(0)?.toString())) {  //第三方，如 UNIONPAY,HCHINAPAY
                        bankNames = PtbAdjustBank.executeQuery(""" select Trim(t0.bankNames) from PtbAdjustBank t0
                        where t0.bankCode in
                        (
                        select t.bankNames from PtbAdjustBank t where t.tradeType='${params.tradeType}'
                        and t.bankCode ='${params.bankCode.toUpperCase()}'
                        ) """ )

                    if(bankNames){
                        'in'("tradeBank", bankNames)

                        String bankNamesStr = ""
                        for(int i=0;i<bankNames.size();i++){
                            bankNamesStr = bankNamesStr+ "'${bankNames[i]}'"
                            if(i<bankNames.size()-1){
                                bankNamesStr = bankNamesStr+","
                            }
                        }
                    }else{
                        'in'("tradeBank", ['-1'])
                    }

                }else{
                    bankNames = PtbAdjustBank.executeQuery(" select Trim(t.bankNames) from PtbAdjustBank t where t.bankCode ='"+ params.bankCode.toUpperCase()+"'" )
                    if(bankNames){
                        'in'("tradeBank", bankNames)

                        String bankNamesStr = ""
                        for(int i=0;i<bankNames.size();i++){
                            bankNamesStr = bankNamesStr+ "'${bankNames[i]}'"
                            if(i<bankNames.size()-1){
                                bankNamesStr = bankNamesStr+","
                            }
                        }
                    }else{
                        'in'("tradeBank", [params.bankName])
                    }
                }
            }
        }

        def sqlWhere = new StringBuilder()
        sqlWhere.append(" where 1=1 and TRADE_TYPE='${params.tradeType}'")
        sqlWhere.append(" and TRADE_STATUS='0'")
        if (params.tradeCode) {
            sqlWhere.append(" and TRADE_CODE='${params.tradeCode}'")
        }

        if(params.startTime){
            sqlWhere.append(" and TRADE_SUBDATE>=to_date('${params.startTime}','yyyy-MM-dd')")
        }
        if(params.endTime){
            sqlWhere.append(" and TRADE_SUBDATE<to_date('${sf.format(Date.parse('yyyy-MM-dd', params.endTime) + 1)}','yyyy-MM-dd')")
        }
        /*祝哥说这个没用
         if (params.tradeCardtype) {
             like("tradeCardtype", "%" + params.tradeCardtype + "%")
             sqlWhere.append(" and TRADE_CARDTYPE like '%${params.tradeCardtype}%'")
         }*/
        if (params.tradeCardname) {
            sqlWhere.append(" and TRADE_CARDNAME like '%${params.tradeCardname}%'")
        }
        if (params.tradeCardnum) {
            sqlWhere.append(" and TRADE_CARDNUM='${params.tradeCardnum}'")
        }
        if (params.tradeAcctype) {
            sqlWhere.append(" and TRADE_ACCTYPE='${params.tradeAcctype}'")
        }
        if (params.outTradeorder) {
            sqlWhere.append(" and OUT_TRADEORDER='${params.outTradeorder}'")
        }
        if(params.bankCode){
            def  bankNames = null;
            def bankType = PtbAdjustBank.executeQuery(" select distinct t.bankType from PtbAdjustBank t where t.bankCode ='"+ params.bankCode.toUpperCase()+"'" )
            if ("TH".equals(bankType?.get(0)?.toString())) {  //第三方，如 UNIONPAY,HCHINAPAY
                bankNames = PtbAdjustBank.executeQuery(""" select Trim(t0.bankNames) from PtbAdjustBank t0
                    where t0.bankCode in
                    (
                    select t.bankNames from PtbAdjustBank t where t.tradeType='${params.tradeType}'
                    and t.bankCode ='${params.bankCode.toUpperCase()}'
                    ) """ )


                if(bankNames){
                    String bankNamesStr = ""
                    for(int i=0;i<bankNames.size();i++){
                        bankNamesStr = bankNamesStr+ "'${bankNames[i]}'"
                        if(i<bankNames.size()-1){
                            bankNamesStr = bankNamesStr+","
                        }
                    }
                    sqlWhere.append(" and TRADE_BANK in (${bankNamesStr})")
                }
            }else{
                bankNames = PtbAdjustBank.executeQuery(" select Trim(t.bankNames) from PtbAdjustBank t where t.bankCode ='"+ params.bankCode.toUpperCase()+"'" )
                if(bankNames){
                    String bankNamesStr = ""
                    for(int i=0;i<bankNames.size();i++){
                        bankNamesStr = bankNamesStr+ "'${bankNames[i]}'"
                        if(i<bankNames.size()-1){
                            bankNamesStr = bankNamesStr+","
                        }
                    }
                    sqlWhere.append(" and TRADE_BANK in (${bankNamesStr})")
                }else{
                    sqlWhere.append(" and TRADE_BANK in ('${params.bankName}')")
                }
            }
        }
        [query:query,sqlWhere:sqlWhere.toString()]
    }

}
