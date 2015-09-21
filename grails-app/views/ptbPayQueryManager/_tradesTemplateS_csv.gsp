<%@ page import="pay.PtbPayBatch; pay.PtbPayTrade" %># 收款汇总信息

导出时间: ${new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date())}
金额汇总：<g:formatNumber number="${totalMoney==null?0:totalMoney}" format="#0.00#"/>
记录条数汇总：${totalCount==null?0:totalCount}

交易号,外部交易号,批次号,打款类型,交易类型,付款人,付款帐号,付款银行,请求日期,处理日期,账号类型,分行,支行,金额,打款通道,打款方式,打款状态,失败原因
<g:each in="${ptbPayTradeList}" status="i" var="ptbPayTrade">${ptbPayTrade.TRADE_ID}		,${ptbPayTrade.OUT_TRADEORDER}		,${ptbPayTrade.BATCH_ID}		,收款,${ptbPayTrade.TRADE_NAME},${ptbPayTrade.TRADE_CARDNAME},${ptbPayTrade.TRADE_CARDNUM}		,${ptbPayTrade.TRADE_BANK},${ptbPayTrade.TRADE_SUBDATE.format("yyyy-MM-dd HH:mm:ss")}		,${!ptbPayTrade.BATCH_DATE?null:ptbPayTrade.BATCH_DATE.format("yyyy-MM-dd HH:mm:ss")}		,${PtbPayTrade.TradeAccTypeMap[ptbPayTrade.TRADE_ACCTYPE]},${ptbPayTrade.TRADE_BRANCHBANK},${ptbPayTrade.TRADE_SUBBANK},<g:formatNumber number="${ptbPayTrade.TRADE_AMOUNT==null?0:ptbPayTrade.TRADE_AMOUNT}" format="#0.00#"/>		,${ptbPayTrade.BATCH_CHANELNAME},${PtbPayBatch.BatchStyleMap[ptbPayTrade.BATCH_STYLE]},${PtbPayTrade.TradeStatusMap[ptbPayTrade.TRADE_STATUS]},${ptbPayTrade.TRADE_REASON}
</g:each>