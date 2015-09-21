<%@ page contentType="text/html" %>
<%@ page import="ismp.CmDynamicKey" %>
<html>
<body>

<h3>风险交易报告（<g:formatDate date="${new Date()}" format="yyyy-MM-dd HH:mm"/>）</h3>
<br><br>
<table align="left" border="1">
    <tr>
        <th>交易时间</th>
        <th>交易流水号</th>
        <th>交易类型</th>
        <th>商户号</th>
        <th>商户名称</th>
        <th>交易金额</th>

    </tr>

    <g:each in="${riskBean}" status="i" var="event">
        <tr>
            <td><g:formatDate date="${event.tradeDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
            <td>${fieldValue(bean: event, field: "serialNo")}</td>
            <td>${ismp.TradeBase.tradeTypeMap[event.tradeType]}</td>
            <td>${fieldValue(bean: event, field: "merchantId")}</td>
            <td>${fieldValue(bean: event, field: "merchantName")}</td>
            <td><g:formatNumber number="${event.amount/100}" type="currency" currencyCode="CNY"/>
            </td>

        </tr>
    </g:each>
</table>

</body>
</html>