<%@ page import="settle.FtSrvTradeType" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftSrvTradeType.label', default: 'FtSrvTradeType')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${ftSrvTradeTypeInstance}">
        <div class="errors">
            <g:renderErrors bean="${ftSrvTradeTypeInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="update">
        <g:hiddenField name="id" value="${ftSrvTradeTypeInstance?.id}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftSrvTradeType.tradeCode.label"/>：</td>
                <td class="${hasErrors(bean: ftSrvTradeTypeInstance, field: 'tradeCode', 'errors')}"><g:textField name="tradeCode" maxlength="20" value="${ftSrvTradeTypeInstance?.tradeCode}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftSrvTradeType.tradeName.label"/>：</td>
                <td class="${hasErrors(bean: ftSrvTradeTypeInstance, field: 'tradeName', 'errors')}"><g:textField name="tradeName" maxlength="50" value="${ftSrvTradeTypeInstance?.tradeName}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftSrvTradeType.netWeight.label"/>：</td>
                <td class="${hasErrors(bean: ftSrvTradeTypeInstance, field: 'netWeight', 'errors')}">
                    <g:select name='netWeight' from="${FtSrvTradeType.netWeightMap}" optionKey="key" optionValue="value" class="right_top_h2_input"  value="${ftSrvTradeTypeInstance?.netWeight}"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftSrvTradeType.srv.label"/>：</td>
                <td class="${hasErrors(bean: ftSrvTradeTypeInstance, field: 'srv', 'errors')}">
                    <g:select name="srv.id" from="${settle.FtSrvType.list()}" optionKey="id" optionValue="srvName" class="right_top_h2_input"  value="${ftSrvTradeTypeInstance?.srv?.id}"/>
                </td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定"></span>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>
