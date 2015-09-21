
<%@ page import="account.AcAccount" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'acAccount.label', default: 'AcAccount')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>

    <g:form action="update" >
        <g:hiddenField name="id" value="${acAccountInstance?.id}"/>
        <table align="center" class="rigt_tebl">
        <tr>
            <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="acAccount.accountNo.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: acAccountInstance, field: "accountNo")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="acAccount.accountName.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: acAccountInstance, field: "accountName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="acAccount.balanceOfDirection.label"/>：</td>

            <td><span class="rigt_tebl_font">${AcAccount.dirMap[acAccountInstance?.balanceOfDirection]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="acAccount.balance.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatNumber number="${acAccountInstance?.balance/100}" type="currency" currencyCode="CNY"/></span></td>

        </tr>

        <tr>
            <td class="right label_name">冻结金额：</td>

            <td><span class="rigt_tebl_font"><g:formatNumber number="${freezeBalance/100}" type="currency" currencyCode="CNY"/></span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="acAccount.currency.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: acAccountInstance, field: "currency")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="acAccount.status.label"/>：</td>

            <td><g:select name="status" from="${AcAccount.statusMap}" optionKey="key" optionValue="value" value="${acAccountInstance?.status}"/></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="acAccount.dateCreated.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatDate date="${acAccountInstance?.dateCreated}" format="yyyy-MM-dd"/></span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="acAccount.lastUpdated.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatDate date="${acAccountInstance?.lastUpdated}" format="yyyy-MM-dd"/></span></td>

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