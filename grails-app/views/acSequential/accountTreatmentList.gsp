<%@ page import="account.AcTransaction; account.AcAccount; account.AcSequential" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'acSequential.label', default: '账务查询')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startTime,#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });
    function checkDate2() {
        var startDate = document.getElementById("startTime").value;
        var endDate = document.getElementById("endTime").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endTime").focus();
            return false;
        }
    }
    /*---guonan update 2011-12-30----*/
    function checkDate() {
        var startDateCreated = document.getElementById('startTime').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endTime').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endTime').focus();
                return false;
            }
        }
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form action="accountTreatmentList">
                账号：<g:textField name="accountNo" value="${params.accountNo}" class="right_top_h2_input" style="width:120px"/>
                交易流水号：<g:textField name="tradeNo" value="${params.tradeNo}" class="right_top_h2_input" style="width:120px"/>
                外部订单号：<g:textField name="outTradeNo" value="${params.outTradeNo}" class="right_top_h2_input" style="width:120px"/><br>
                开始时间：<g:textField name="startTime" readonly="true" value="${params.startTime}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" size="10" class="right_top_h2_input" style="width:80px"/>
                结束时间：<g:textField name="endTime" readonly="true" value="${params.endTime}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" size="10" class="right_top_h2_input" style="width:80px"/>
                <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkDate()">
            </g:form>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <th>凭证码</th>
                <th>交易类型</th>
                <th>外部交易流水号</th>
                <th>外部订单号</th>
                <g:sortableColumn params="${params}" property="accountNo" title="${message(code: 'acSequential.accountNo.label', default: 'Account No')}"/>
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
