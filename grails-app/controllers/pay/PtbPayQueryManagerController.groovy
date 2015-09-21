package pay

import boss.BoMerchant
import grails.converters.JSON

class PtbPayQueryManagerController {
    def pdbService
    def ipayService
    def pexcelService
    def tradesManagerF = {
        try{
            params.max = Math.min(params.max ? params.int('max') : 10, 100)
            params.sort = params.sort ? params.sort : "t.TRADE_ID"
            params.order = params.order ? params.order : "desc"
            initParams(params)
            List bankChanelList = pdbService.bankChanelList('F')
            def bankList = pdbService.bankList('F')
            params.tradeType='F'
            def res = pdbService.queryTradesDetail(params)
            [ptbPayTradeList:res.resList,bankChanelList:bankChanelList,
                    bankList:bankList,ptbPayTradeTypeList:PtbPayTradeType.findAllByPayType("F"),
                    totalCount:res.totalCount,totalMoney:res.totalMoney]
        }catch (Throwable e){
            log.error("付款交易明细查询异常",e)
        }

    }

    def batchsManagerF = {
        try{
            params.max = Math.min(params.max ? params.int('max') : 20, 100)
            params.sort = params.sort ? params.sort : "id"
            params.order = params.order ? params.order : "desc"
            List bankChanelList = pdbService.bankChanelList('F')
            params.batchType = 'F'
            validDated(params)
            def query = batchQuery(params)
            PtbPayBatch ptbPayBatch = new PtbPayBatch()
            def results = PtbPayBatch.createCriteria().list(params, query)
            def total = PtbPayBatch.createCriteria().get {
                and query
                projections {
                    countDistinct("id")
                    sum('batchCount')
                    sum('batchAmount')
                }
            }
        [ptbPayBatchList:results,bankChanelList:bankChanelList,totalBatchCount:total[0],totalTradeCount:total[1],totalMoney:total[2]]
        }catch (Throwable e){
            log.error("付款交易明细查询异常",e)
        }

    }
    def tradesManagerS = {
        try{
            params.max = Math.min(params.max ? params.int('max') : 10, 100)
            params.sort = params.sort ? params.sort : "t.TRADE_ID"
            params.order = params.order ? params.order : "desc"
            initParams(params)
            List bankChanelList = pdbService.bankChanelList('S')
            def bankList = pdbService.bankList('S')
            params.tradeType='S'
            def res = pdbService.queryTradesDetail(params)
            [ptbPayTradeList:res.resList,bankChanelList:bankChanelList,
                    bankList:bankList,ptbPayTradeTypeList:PtbPayTradeType.findAllByPayType("S"),
                    totalCount:res.totalCount,totalMoney:res.totalMoney]
        }catch (Throwable e){
            log.error("付款交易明细查询异常",e)
        }
    }
    def batchsManagerS = {
        try{
            params.max = Math.min(params.max ? params.int('max') : 20, 100)
            params.sort = params.sort ? params.sort : "id"
            params.order = params.order ? params.order : "desc"
            List bankChanelList = pdbService.bankChanelList('S')
            params.batchType = 'S'
            validDated(params)
            def query = batchQuery(params)
            PtbPayBatch ptbPayBatch = new PtbPayBatch()
            def results = PtbPayBatch.createCriteria().list(params, query)
            def total = PtbPayBatch.createCriteria().get {
                and query
                projections {
                    countDistinct("id")
                    sum('batchCount')
                    sum('batchAmount')
                }
            }
        [ptbPayBatchList:results,bankChanelList:bankChanelList,totalBatchCount:total[0],totalTradeCount:total[1],totalMoney:total[2]]
        }catch (Throwable e){
            log.error("付款交易明细查询异常",e)
        }
    }

    /**
     * 交易明细下载
     */
    def downTrades = {
        try{
            params.max = 50000 //最多5万条
            params.offset = 0
            params.sort = params.sort ? params.sort : "t.TRADE_ID"
            params.order = params.order ? params.order : "desc"
            initParams(params)
            def res = pdbService.queryTradesDetail(params)
            def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.contentType = "application/vnd.ms-excel"
            response.setCharacterEncoding("UTF-8")
            def wb = pexcelService.exportTrades(request,res.resList,Integer.parseInt(res.totalCount.toString()),BigDecimal.valueOf(Double.valueOf(res.totalMoney.toString())),params.tradeType)
            wb.write(response.outputStream)
            response.outputStream.close()
        }catch (Throwable e){
            log.error("交易明细下载异常",e)
        }
    }



    /**
     * 交易明细下载 CSV
     */
    def downTradesCSV = {
        try{
            params.max = 50000 //最多5万条
            params.offset = 0
            params.sort = params.sort ? params.sort : "t.TRADE_ID"
            params.order = params.order ? params.order : "desc"
            initParams(params)
            def res = pdbService.queryTradesDetail(params)
            def filename = 'csv-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.csv'
            response.contentType = "text/csv"
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            String tlpt="tradesTemplateF_csv"
            if(params.tradeType=='S'){
                tlpt="tradesTemplateS_csv"
            }
            render(template: tlpt, model: [ptbPayTradeList:res.resList,
                    totalCount:res.totalCount,totalMoney:res.totalMoney])
        }catch (Throwable e){
            log.error("交易明细下载异常",e)
        }
    }

    /**
     * 批次明细下载
     */
    def downBatchsDetails = {
        try{
            //params.max = Math.min(params.max ? params.int('max') : 10, 100)
            params.max = 50000  //最多5万条
            params.offset = 0
            params.sort = params.sort ? params.sort : "t.TRADE_ID"
            params.order = params.order ? params.order : "desc"
            def res = pdbService.queryTradesDetail(params)
            PtbPayBatch p = PtbPayBatch.get(params.batchId)
            def filename = 'Word-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.doc'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.contentType = "application/vnd.ms-word"
            response.setCharacterEncoding("UTF-8")
            render(template: "batchDetailsTemplate", model: [ptbPayTradeList:res.resList,
                    totalCount:res.totalCount,totalMoney:res.totalMoney,
                    bankName:p.batchChanelname.split("-")[0],batchType:p.batchType])
        }catch (Throwable e){
            log.error("批次明细下载异常",e)
        }
    }

    /**
     * 批次明细
     */
    def batchsDetails = {
        try{
            params.max = Math.min(params.max ? params.int('max') : 10, 100)
            params.sort = params.sort ? params.sort : "t.TRADE_ID"
            params.order = params.order ? params.order : "asc"
            //如果截止日期为空，默认为查询起始日期当天
            if (params.startTime && !params.endTime){
                 params.endTime=params.startTime
            }
            //如果起始日期为空，默认为查询截止日期当天
            if (!params.startTime && params.endTime){
                 params.startTime=params.endTime
            }
            def res = pdbService.queryTradesDetail(params)
            [ptbPayTradeList:res.resList,totalCount:res.totalCount,totalMoney:res.totalMoney]
        }catch (Throwable e){
            log.error("付款交易明细查询异常",e)
        }
    }



    /**
     * 手工打款确认
     */
    def confirm = {
        def batchId = params.batchIdHid
        try{
            PtbPayBatch.executeUpdate(" update PtbPayBatch set batchStatus='1' where id='${batchId}'")
            flash.message = "手工打款确认成功"
        }catch (Throwable e){
            flash.message = "手工打款确认失败"
            log.error("手工打款确认异常",e)
        }
        if(params.batchType=="F"){
            redirect(action: "batchsManagerF", params: params)
        }else if(params.batchType=="S"){
            redirect(action: "batchsManagerS", params: params)
        }


    }

    /**
     * 修改打款渠道
     */
    def changeChanelCommit = {
        BoMerchant boMerchant = BoMerchant.get(params.merchantIdHid)
        def chanelName = boMerchant.acquirerAccount.bank.name+"-"+boMerchant.acquirerAccount.aliasName
        try{
            PtbPayBatch.executeUpdate(""" update PtbPayBatch set
                                      batchChanel='${params.merchantIdHid}',
                                      batchChanelsyscode='${boMerchant.serviceCode}',
                                      batchChanelname='${chanelName}',
                                      batchChanelaccountno='${boMerchant.acquirerAccount.bankAccountNo}',
                                      batchStyle='${params.batchStyleHid}'
                                      where id='${params.batchIdHid}'""")
            if(boMerchant.channelType=="S"){
                flash.message = "修改收款渠道成功"
            }else{
                flash.message = "修改打款渠道成功"
            }
        }catch (Throwable e){
            if(boMerchant.channelType=="S"){
                flash.message = "修改收款渠道失败"
            }else{
                flash.message = "修改打款渠道失败"
            }
            log.error("修改打款渠道异常",e)
        }
        if(params.batchType=="F"){
            redirect(action: "batchsManagerF", params: params)
        }else if(params.batchType=="S"){
            redirect(action: "batchsManagerS", params: params)
        }
    }

    /**
     * 撤消批次
     */
    def cancelBatch = {
        def batchId = params.batchIdHid
        try{
            PtbPayBatch.executeUpdate(" delete from PtbPayBatch t where id='${batchId}'")
            PtbPayTrade.executeUpdate(""" update PtbPayTrade set
                                      batchId='',
                                      tradeBatchseqno=null,
                                      tradeStatus='0'
                                      where batchId='${batchId}'""")
            flash.message = "撤消批次成功"
        }catch (Throwable e){
            flash.message = "撤消批次失败"
            log.error("撤消批次异常",e)
        }
        if(params.batchType=="F"){
            redirect(action: "batchsManagerF", params: params)
        }else if(params.batchType=="S"){
            redirect(action: "batchsManagerS", params: params)
        }
    }

    /**
     * 重新发送
     */
    def reSendForAuto = {
        def batchId = params.batchIdHid
        try{
            PtbPayBatch.executeUpdate(" update PtbPayBatch set batchStatus='0' where id='${batchId}'")
            flash.message = "设置成功"
        }catch (Throwable e){
            flash.message = "设置失败"
            log.error("重发（自动打款）异常",e)
        }
        if(params.batchType=="F"){
            redirect(action: "batchsManagerF", params: params)
        }else if(params.batchType=="S"){
            redirect(action: "batchsManagerS", params: params)
        }
    }

    /**
     *  重发对账结果
     * @param tradeId
     * @return
     */
    def reSendCheckMsg = {
        def tradeId = params.tradeId
        def msgMap = new HashMap()
        try{
            ipayService.reSendCheckMsg(tradeId)
            msgMap.put("msg","交易:${tradeId} 重发通知成功")
        }catch (Throwable e){
            msgMap.put("msg","交易:${tradeId} 重发通知失败")
            log.error("交易:${tradeId} 重发通知异常",e)
        }
        render msgMap as JSON
    }
    /**
     *  批量重发对账结果
     * @param batchId
     * @return
     */
    def reSendCheckMsgByBatch = {
        def batchId = params.batchId
        def msgMap = new HashMap()
        try{
            ipayService.reSendCheckMsgByBatch(batchId)
            msgMap.put("msg","批次:${batchId} 重发通知成功")
        }catch (Throwable e){
            msgMap.put("msg","批次:${batchId} 重发通知失败")
            log.error("批次:${batchId} 重发通知异常",e)
        }
        render msgMap as JSON
    }

    /**
     * 手工单笔对账
     */
    def handleCheckTrade = {
        String tradeId = params.tradeId
        String flag = params.flag
        String tradeReason = params.failreason
        String offset = params.offsetOld
        def batchId
        def tradeType
        try{
            PtbPayTrade t =  PtbPayTrade.get(tradeId)
            batchId = t.batchId
            tradeType = t.tradeType
            if(flag=='succ'){
                PtbPayTrade.executeUpdate("""update PtbPayTrade t set
                                             t.tradeStatus = '2',
                                             t.tradeDonedate=sysdate(),
                                             t.checkway='manual'
                                             where t.id = '${tradeId}'""")
            }else if(flag=='fail'){
                PtbPayTrade.executeUpdate("""update PtbPayTrade t set
                                            t.tradeStatus = '3',
                                            t.tradeDonedate=sysdate(),
                                            t.tradeReason ='${tradeReason}',
                                            t.checkway='manual'
                                            where t.id = '${tradeId}'""")
            }
            checkBatch(batchId)
            ipayService.reSendCheckMsg(tradeId,flag,tradeReason)
            flash.message = "操作成功!"
        }catch (Throwable e){
            flash.message = "操作失败!"
            log.error("置失败（成功）异常",e)
            try{
                PtbPayTrade.executeUpdate("""update PtbPayTrade t set
                                            t.tradeStatus = '1',
                                            t.tradeDonedate=null,
                                            t.tradeReason =null,
                                            t.checkway=null
                                            where t.id = '${tradeId}'""")
                PtbPayBatch.executeUpdate("update PtbPayBatch t set t.batchStatus=1 where t.id='"+batchId+"'")
            }catch (Throwable ex){
                log.error("置失败（成功）回滚异常",ex)
            }
        }finally{
            try{
                PtbLog.info("手工单笔对账","handleCheckTrade","${tradeId}","","操作人：${session?.op?.name}(改${flag}[${flash.message}])")
            }catch (Throwable ex){
                log.error("置失败（成功）记录操作人异常",ex)
            }
        }
        redirect(action: "batchsDetails", params: [batchId: batchId,tradeType:tradeType,offset:offset])
    }
    private def checkBatch(def batchId){
        def res = PtbPayTrade.executeQuery("""select t.id from PtbPayTrade t where t.tradeStatus
                                in ('0','1') and t.batchId='${batchId}'""")
        if(res==null||res.size()==0){
            PtbPayBatch.executeUpdate("update PtbPayBatch t set t.batchStatus=2 where t.id='"+batchId+"'")
        }
    }


    private def validDated(def params) {
        //如果起始日期和截止日期均为空 默认为查询当天到前一个月
        if (params.startTime==null && params.endTime==null){
            def gCalendar= new GregorianCalendar()
            params.endTime=gCalendar.time.format('yyyy-MM-dd')
            //params.batchETime=gCalendar.time.format('yyyy-MM-dd')
            gCalendar.add(GregorianCalendar.MONTH,-1)
            params.startTime=gCalendar.time.format('yyyy-MM-dd')
            //params.batchSTime=gCalendar.time.format('yyyy-MM-dd')
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
        }
    }



    private def batchQuery(def params){
        def query = {
            eq('batchType', params.batchType)
            if (params.batchStatus == "" && params.batchStatus == null) {
                eq('batchStatus', '0')
            } else if (params.batchStatus) {
                eq('batchStatus', params.batchStatus)
            }

            if (params.startTime) {
                 ge('batchDate', Date.parse('yyyy-MM-dd', params.startTime))
            }
            if (params.endTime) {
                 lt('batchDate', Date.parse('yyyy-MM-dd', params.endTime) + 1)
            }
            if (params.batchId != null && params.batchId != "") {
                eq("id", params.batchId as Long)
            }

            if (params.merchantId != null && params.merchantId != "") {
                eq("batchChanel", params.merchantId as Integer)
            }
        }
        return  query
    }


}
