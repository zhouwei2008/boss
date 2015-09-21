<%@ page import="settle.FtLiquidate" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftTrade.label', default: 'FtTrade')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <th><g:message code="ftTrade.customerNo.label"/></th>

                <th><g:message code="ftTrade.seqNo.label"/></th>

                <th><g:message code="ftTrade.tradeDate.label"/></th>

                <th><g:message code="ftTrade.srvCode.label"/></th>

                <th><g:message code="ftTrade.tradeCode.label"/></th>

                <th><g:message code="ftTrade.amount.label"/></th>

                <th><g:message code="ftTrade.preFee.label"/></th>

                <th><g:message code="ftTrade.postFee.label"/></th>

            </tr>

            <g:each in="${result}" status="i" var="item">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td>${item.CUSTOMERNO}</td>

                    <td>${item.SEQNO}</td>

                    <td><g:formatDate format="yyyy.MM.dd HH:mm:ss" date="${item.TRADEDATE}" /></td>

                    <td>${item.SRVNAME}</td>

                    <td>${item.TRADENAME}</td>

                    <td>${item.AMOUNT/100}</td>

                    <td><g:if test="${item.PREFEE}">${item.PREFEE/100}</g:if></td>

                    <td><g:if test="${item.POSTFEE}">${item.POSTFEE/100}</g:if></td>

                </tr>
            </g:each>

            <tr>
                <td colspan="9" align="center">
                    <input type="button" onclick="window.location.href='${createLink(controller:'ftLiquidate',action:'list')}'" value="返回"/>
                </td>
            </tr>
        </table>

        <div class="paginateButtons">
            <div align="left">    <div style="position:absolute;">共${total}条记录</div></div>
            <g:paginat total="${total}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
