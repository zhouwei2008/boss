<%@ page import="boss.Perm; boss.BoBankDic; ismp.TradeRefundBatch" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeRefund.checkBatch.label', default: 'TradeRefund')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>

<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <table align="center" class="right_list_table" id="test">

            <tr>
                <g:sortableColumn params="${params}" property="id" title="${message(code: 'tradeRefundBatch.id.label')}"/>
                <g:sortableColumn params="${params}" property="batchCount" title="${message(code: 'tradeRefundBatch.batchCount.label')}"/>
                <g:sortableColumn params="${params}" property="batchAmount" title="${message(code: 'tradeRefundBatch.batchAmount.label')}"/>
                <g:sortableColumn params="${params}" property="refundType" title="${message(code: 'tradeRefundBatch.refundType.label')}"/>
                <g:sortableColumn params="${params}" property="refundBankName" title="${message(code: 'tradeRefundBatch.refundBankName.label')}"/>
                <g:sortableColumn params="${params}" property="appName" title="${message(code: 'tradeRefundBatch.appName.label')}"/>
                <g:sortableColumn params="${params}" property="refundDate" title="${message(code: 'tradeRefundBatch.refundDate.label')}"/>
                <g:sortableColumn params="${params}" property="status" title="${message(code: 'tradeRefundBatch.status.label')}"/>
            </tr>
            <td>${tradeRefundBatch.id.toString().replace(',', '')}</td>
            <td>${fieldValue(bean: tradeRefundBatch, field: "batchCount")}</td>
            <td><g:formatNumber number="${tradeRefundBatch?.batchAmount?tradeRefundBatch?.batchAmount/100:0}" type="currency" currencyCode="CNY"/></td>
            <td>${tradeRefundBatch.refundTypeMap[tradeRefundBatch?.refundType]}</td>
            <td>${fieldValue(bean: tradeRefundBatch, field: "refundBankName")}</td>

            <td>${fieldValue(bean: tradeRefundBatch, field: "appName")}</td>
            <td><g:formatDate date="${tradeRefundBatch?.refundDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
            <td>${tradeRefundBatch.statusMap[tradeRefundBatch?.status]}</td>
        </tr>
            <tr>
                <td colspan="8" align="center">
                    <g:form>
                        <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    </g:form>
                </td>
            </tr>
        </table>
    </div>
</div>
</body>
</html>
