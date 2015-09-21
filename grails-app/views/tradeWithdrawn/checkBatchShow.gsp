<%@ page import="boss.Perm; boss.BoBankDic; ismp.WithdrawnBatch" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeWithdrawn.checkBatch.label', default: 'TradeWithdrawn')}"/>
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
                <g:sortableColumn params="${params}" property="id" title="${message(code: 'withdrawnBatch.id.label')}"/>
                <g:sortableColumn params="${params}" property="batchCount" title="${message(code: 'withdrawnBatch.batchCount.label')}"/>
                <g:sortableColumn params="${params}" property="batchAmount" title="${message(code: 'withdrawnBatch.batchAmount.label')}"/>
                <g:sortableColumn params="${params}" property="withdrawnBankName" title="${message(code: 'withdrawnBatch.withdrawnBankName.label')}"/>
                <g:sortableColumn params="${params}" property="appName" title="${message(code: 'withdrawnBatch.appName.label')}"/>
                <g:sortableColumn params="${params}" property="withdrawnDate" title="${message(code: 'withdrawnBatch.withdrawnDate.label')}"/>
                <g:sortableColumn params="${params}" property="status" title="${message(code: 'withdrawnBatch.status.label')}"/>
            </tr>
            <td>${withdrawnBatch.id.toString().replace(',', '')}</td>
            <td>${fieldValue(bean: withdrawnBatch, field: "batchCount")}</td>
            <td><g:formatNumber number="${withdrawnBatch?.batchAmount?withdrawnBatch?.batchAmount/100:0}" type="currency" currencyCode="CNY"/></td>
            <td>${fieldValue(bean: withdrawnBatch, field: "withdrawnBankName")}</td>

            <td>${fieldValue(bean: withdrawnBatch, field: "appName")}</td>
            <td><g:formatDate date="${withdrawnBatch?.withdrawnDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
            <td>${WithdrawnBatch.statusMap[withdrawnBatch?.status]}</td>
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
