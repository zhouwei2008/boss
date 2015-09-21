<%@ page import="boss.Perm; boss.BoAcquirerAccount" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boAcquirerAccount.label', default: 'BoAcquirerAccount')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>

    <table align="center" class="rigt_tebl">
        <tr>
            <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="boAcquirerAccount.bank.label"/>：</td>

            <td><span class="rigt_tebl_font">${boAcquirerAccountInstance?.bank.name}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boAcquirerAccount.branchName.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boAcquirerAccountInstance, field: "branchName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boAcquirerAccount.bankNo.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boAcquirerAccountInstance, field: "bankNo")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boAcquirerAccount.bankAccountNo.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boAcquirerAccountInstance, field: "bankAccountNo")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boAcquirerAccount.bankAccountName.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boAcquirerAccountInstance, field: "bankAccountName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boAcquirerAccount.bankAccountType.label"/>：</td>

            <td><span class="rigt_tebl_font">${BoAcquirerAccount.typeMap[boAcquirerAccountInstance?.bankAccountType]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boAcquirerAccount.aliasName.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boAcquirerAccountInstance, field: "aliasName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boAcquirerAccount.innerAcountNo.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boAcquirerAccountInstance, field: "innerAcountNo")}</span></td>

        </tr>

        <tr>
            <td class="right label_name">账户余额：</td>
            <g:if test="${account?.balance!=null}">
                <td><span class="rigt_tebl_font"><g:formatNumber number="${account?.balance/100}" type="currency" currencyCode="CNY"/></span></td>
            </g:if>
            <g:else>
                <td>￥0.00</td>
            </g:else>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="boAcquirerAccount.status.label"/>：</td>

            <td><span class="rigt_tebl_font">${BoAcquirerAccount.statusMap[boAcquirerAccountInstance?.status]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boAcquirerAccount.dateCreated.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatDate date="${boAcquirerAccountInstance?.dateCreated}" format="yyyy-MM-dd"/></span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boAcquirerAccount.lastUpdated.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatDate date="${boAcquirerAccountInstance?.lastUpdated}" format="yyyy-MM-dd"/></span></td>

        </tr>

        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${boAcquirerAccountInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="button"><bo:hasPerm perm="${Perm.Bank_Issu_Edit}"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></bo:hasPerm></span>
                    %{--<span class="button"><bo:hasPerm perm="${Perm.Bank_Issu_Delete}"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></bo:hasPerm></span>--}%
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>