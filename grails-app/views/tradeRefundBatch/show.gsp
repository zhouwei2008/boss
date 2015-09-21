<%@ page import="boss.Perm; ismp.TradeRefund; boss.BoBankDic; boss.BoAcquirerAccount; boss.BoMerchant; ismp.TradePayment; ismp.TradeBase; ismp.TradeCharge; gateway.GwTransaction; ismp.TradeRefundBatch" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeRefundBatch.label', default: 'TradeRefundBatch')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
    <link rel="stylesheet" type="text/css" href="../../ext/css/ext-all.css"/>
    <link rel="stylesheet" type="text/css" href="../../ext/css/style.css"/>
    <script type="text/javascript" src="../../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../../ext/js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../../ext/js/common.js"></script>
</head>
<body>
<script type="text/javascript">
    function selRefused(id, refundBatchNo) {
        if (confirm("您确认要拒绝该退款请求？")) {
            var url = '../editRea.gsp?id=' + id + '&refundBatchNo=' + refundBatchNo;
            win1 = new Ext.Window({
                id:'win1',
                title:"请输入拒绝原因",
                width:600,
                modal:true,
                height:300,
                html: '<iframe src=' + url + ' height="100%" width="100%" name="userlist" scrolling="auto" frameborder="0" onLoad="Ext.MessageBox.hide();">',
                maximizable:true
            });
            win1.show();
        }
    }

</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>

    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>

        <table align="center" class="right_list_table" id="test">

            <tr>
                <g:sortableColumn params="${params}" property="refundBatchNo" title="${message(code: 'tradeRefund.refundBatchNo.label')}"/>
                <g:sortableColumn params="${params}" property="tradeNo" title="${message(code: 'tradeRefund.tradeNo.label')}"/>
                <g:sortableColumn params="${params}" property="payerName" title="${message(code: 'tradeRefund.payerName.label')}"/>
                <g:sortableColumn params="${params}" property="channel" title="${message(code: 'tradeRefund.channel.label')}"/>
                <th>原银行订单号</th>
                <th>原订单金额</th>
                <th>原交易时间</th>
                <g:sortableColumn params="${params}" property="amount" title="${message(code: 'tradeRefund.amount.label')}"/>
                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'tradeRefund.dateCreated.label')}"/>
                <th>退款银行</th>
                <g:sortableColumn params="${params}" property="firstAppDate" title="${message(code: 'tradeRefund.firstAppDate.label')}"/>
                <g:sortableColumn params="${params}" property="firstAppName" title="${message(code: 'tradeRefund.firstAppName.label')}"/>
                <th>操作</th>
            </tr>

            <g:each in="${tradeRefundBatchInstance}" status="i" var="tradeRefundBatch">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>${fieldValue(bean: tradeRefundBatch, field: "refundBatchNo")}</td>
                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.Trade_RfdBthChk_ViewLs){true}}">
                            <g:link controller="tradeRefund" action="unRefuseShow" id="${tradeRefundBatch.id}" params="['sign':'2']">${fieldValue(bean: tradeRefundBatch, field: "tradeNo")}</g:link>
                        </g:if>
                        <g:else>
                            ${fieldValue(bean: tradeRefundBatch, field: "tradeNo")}
                        </g:else>
                    </td>
                    <td>${fieldValue(bean: tradeRefundBatch, field: "payerName")}</td>
                    <td>${TradeRefund.channelMap[tradeRefundBatch?.channel]}</td>
                    <td>${GwTransaction.get(TradeCharge.findByRootId(tradeRefundBatch.rootId)?.tradeNo)?.bankTransNo}</td>
                    <g:if test="${tradeRefundBatch.partnerId==null}">
                        <g:if test="${TradeBase.findByRootIdAndTradeType(tradeRefundBatch.rootId,'charge')?.amount>0}">
                            <td><g:formatNumber number="${TradeBase.findByRootIdAndTradeType(tradeRefundBatch.rootId,'charge')?.amount/100}" type="currency" currencyCode="CNY"/></td>
                        </g:if>
                    </g:if>
                    <g:elseif test="${tradeRefundBatch.partnerId!=null}">
                        <g:if test="${TradePayment.get(tradeRefundBatch.originalId)?.amount>0}">
                            <td><g:formatNumber number="${TradePayment.get(tradeRefundBatch.originalId)?.amount/100}" type="currency" currencyCode="CNY"/></td>
                        </g:if>
                    </g:elseif>
                    <g:else>
                        <td></td>
                    </g:else>

                    <g:if test="${tradeRefundBatch.partnerId==null}">
                        <td>
                            <g:formatDate date="${TradeBase.findByRootIdAndTradeType(tradeRefundBatch.rootId,'charge')?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                    </g:if>
                    <g:elseif test="${tradeRefundBatch.partnerId!=null}">
                        <td>
                            <g:formatDate date="${TradePayment.findByRootIdAndTradeType(tradeRefundBatch.rootId,'payment')?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                    </g:elseif>
                    <g:else>
                        <td></td>
                    </g:else>
                    <td><g:formatNumber number="${tradeRefundBatch?.amount?tradeRefundBatch?.amount/100:0}" type="currency" currencyCode="CNY"/></td>
                    <td><g:formatDate date="${tradeRefundBatch?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <g:if test="${tradeRefundBatch.acquirerMerchantNo!=null && tradeRefundBatch.acquirerMerchantNo!=''}">
                        <td>${BoBankDic.get(BoAcquirerAccount.get(tradeRefundBatch.acquirer_account_id)?.bank?.id)?.name}</td>
                    </g:if>
                    <g:else>
                        <td></td>
                    </g:else>
                    <td><g:formatDate date="${tradeRefundBatch?.firstAppDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${fieldValue(bean: tradeRefundBatch, field: "firstAppName")}</td>
                    <td><g:if test="${bo.hasPerm(perm:Perm.Trade_RfdBthChk_ProcRef){true}}"><input type="button" value="拒绝" onclick="selRefused(${tradeRefundBatch.id}, ${refundBatchNo})"></g:if></td>
                </tr>
            </g:each>
            <tr>
                <td colspan="13" align="content">
                    <g:form>
                        <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                        <g:hiddenField name="id" value="${refundBatchNo}"></g:hiddenField>
                        <bo:hasPerm perm="${Perm.Trade_RfdBthChk_ProcPas}">
                            <span class="button"><g:actionSubmit class="rigt_button" action="batchCheck" value="通过"/></span>
                        </bo:hasPerm>
                        <bo:hasPerm perm="${Perm.Trade_RfdBthChk_ProcDl}">
                            <span class="rigt_button_down"><g:link controller="tradeRefund" action="listDownload" params="['flag':'2','refundBatchNo':refundBatchNo]">下载</g:link></span>
                        </bo:hasPerm>
                    </g:form>
                </td>
            </tr>
        </table>
        合计：金额总计：${totalAmount ? totalAmount / 100 : 0}元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;笔数总计：${totalCount ? totalCount : 0}笔
        <div class="paginateButtons">
            <span style=" float:left;">共${totalCount}条记录</span>
            <g:paginat total="${totalCount}" params="${params}"/>
        </div>
    </div>

</div>
</body>
</html>