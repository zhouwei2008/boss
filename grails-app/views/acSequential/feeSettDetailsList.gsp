<%@ page import="account.AcTransaction; account.AcAccount; account.AcSequential" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'acSequential.label', default: 'AcSequential')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>

<script type="text/javascript">
    $(function() {
        $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });
</script>

<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form action="feeSettDetailsList">
                账号：<g:textField name="accountNo" value="${params.accountNo}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input" style="width:120px"/>
                交易类型：<g:select name="transferType" from="${AcTransaction.transTypeMap}" optionKey="key" optionValue="value" value="${params.transferType}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
                交易流水号：<g:textField name="tradeNo" value="${params.tradeNo}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input" style="width:120px"/>
                外部订单号：<g:textField name="outTradeNo" value="${params.outTradeNo}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input" style="width:120px"/><br>
                开始时间：<g:textField name="startTime" value="${params.startTime}" size="10" class="right_top_h2_input" style="width:80px"/>
                结束时间：<g:textField name="endTime" value="${params.endTime}" size="10" class="right_top_h2_input" style="width:80px"/>
                <input type="submit" class="right_top_h2_button_serch" value="查询">
            </g:form>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <th>凭证码</th>
                <th>交易类型</th>
                <th>外部交易流水号</th>
                <th>外部订单号</th>
                <g:sortableColumn params="${params}" property="accountNo" title="${message(code: 'acSequential.accountNo.label', default: 'Account No')}"/>
                <th>账户名称</th>
                <g:sortableColumn params="${params}" property="debitAmount" title="${message(code: 'acSequential.debitAmount.label', default: 'debitAmount')}"/>
                <g:sortableColumn params="${params}" property="creditAmount" title="${message(code: 'acSequential.creditAmount.label', default: 'creditAmount')}"/>
                <g:sortableColumn params="${params}" property="balance" title="${message(code: 'acSequential.balance.label', default: 'Balance')}"/>
                <g:sortableColumn params="${params}" property="preBalance" title="${message(code: 'acSequential.preBalance.label', default: 'preBalance')}"/>
                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'acSequential.dateCreated.label', default: 'Date Created')}"/>

            </tr>

            <g:each in="${acSequentialInstanceList}" status="i" var="acSequentialInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td><g:link action="show" id="${acSequentialInstance.id}">${acSequentialInstance?.transaction?.transactionCode}</g:link></td>
                    <td>${AcTransaction.transTypeMap[acSequentialInstance?.transaction?.transferType]}</td>
                    <td>${acSequentialInstance?.transaction?.tradeNo}</td>
                    <td>${acSequentialInstance?.transaction?.outTradeNo}</td>
                    <td>${fieldValue(bean: acSequentialInstance, field: "accountNo")}</td>
                    <td>${acSequentialInstance?.account?.accountName}</td>
                    <td><g:formatNumber number="${acSequentialInstance.debitAmount/100}" type="currency" currencyCode="CNY"/></td>
                    <td><g:formatNumber number="${acSequentialInstance.creditAmount/100}" type="currency" currencyCode="CNY"/></td>
                    <td><g:formatNumber number="${acSequentialInstance.balance/100}" type="currency" currencyCode="CNY"/></td>
                    <td><g:formatNumber number="${acSequentialInstance.preBalance/100}" type="currency" currencyCode="CNY"/></td>
                    <td><g:formatDate date="${acSequentialInstance.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>

                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${acSequentialInstanceTotal}条记录</span>
            <g:paginat total="${acSequentialInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
