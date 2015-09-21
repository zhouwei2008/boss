<%@ page import="dsf.TbAgentpayDetailsInfo; ismp.CmCustomer" %>汇总信息：,,记录条数汇总：,${totalCount==null?0:totalCount}

客户编号,交易号,批次号,商户名称,交易类型,收/付款人,客户账户,商户申请日期,证件类型,证件号码,账号类型,金额
<g:each in="${tbErrorLogList}" status="i" var="tbErrorLog">${tbErrorLog?.BATCH_BIZID}		,${tbErrorLog?.DETAIL_ID}		,${tbErrorLog?.BATCH_ID}		,${tbErrorLog?.customerName},${TbAgentpayDetailsInfo.tradeTypeMap[tbErrorLog.TRADE_TYPE]},${tbErrorLog?.TRADE_CARDNAME},${tbErrorLog?.TRADE_CARDNUM}		,${!tbErrorLog.TRADE_SUBDATE?null:tbErrorLog.TRADE_SUBDATE.format("yyyy-MM-dd HH:mm:ss")}		,${TbAgentpayDetailsInfo.certificateTypeMap[tbErrorLog.CERTIFICATE_TYPE]},${tbErrorLog?.CERTIFICATE_NUM}		,${TbAgentpayDetailsInfo.accountTypeMap[tbErrorLog.TRADE_ACCOUNTTYPE]},${tbErrorLog?.TRADE_AMOUNT}
</g:each>