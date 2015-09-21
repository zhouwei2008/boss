<%@ page import="account.AcAccount; boss.AppNote; boss.BoAcquirerAccount; ismp.TradeWithdrawn" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeWithdrawn.label', default: 'TradeWithdrawn')}"/>
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
            <td class="right label_name"><g:message code="tradeWithdrawn.tradeNo.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "tradeNo")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.payerName.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "payerName")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.payerAccountNo.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "payerAccountNo")}</span></td>
        </tr>

        <tr>
            <td class="right label_name">账户余额：</td>
            <td><span class="rigt_tebl_font"><g:formatNumber number="${AcAccount.findByAccountNo(tradeWithdrawnInstance?.payerAccountNo)?.balance/100}" type="currency" currencyCode="CNY"/></span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.amount.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatNumber number="${tradeWithdrawnInstance?.amount/100}" type="currency" currencyCode="CNY"/></span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.feeAmount.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatNumber number="${tradeWithdrawnInstance?.feeAmount/100}" type="currency" currencyCode="CNY"/></span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.transferFee.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatNumber number="${tradeWithdrawnInstance?.transferFee/100}" type="currency" currencyCode="CNY"/></span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.realTransferAmount.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatNumber number="${tradeWithdrawnInstance?.realTransferAmount/100}" type="currency" currencyCode="CNY"/></span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.acquirerAccountId.label"/>：</td>
            <td>
                <span class="rigt_tebl_font">${BoAcquirerAccount.get(tradeWithdrawnInstance.acquirerAccountId)?.comboName}</span>
            </td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.customerBankCode.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankCode")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.customerBankNo.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankNo")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.customerBankAccountNo.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankAccountNo")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.customerBankAccountName.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankAccountName")}</span></td>
        </tr>


        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.isCorporate.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${tradeWithdrawnInstance?.isCorporate}"/></span></td>
        </tr>

        <tr>
            <td class="right label_name">收款账号省份：</td>
            <td><span class="rigt_tebl_font">${tradeWithdrawnInstance?.accountProvince}</span></td>
        </tr>

        <tr>
            <td class="right label_name">收款账号地市：</td>
            <td><span class="rigt_tebl_font">${tradeWithdrawnInstance?.accountCity}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.handleStatus.label"/>：</td>
            <td><span class="rigt_tebl_font">${TradeWithdrawn.handleStatusMap[tradeWithdrawnInstance?.handleStatus]}</span></td>
        </tr>

        <g:if test="${tradeWithdrawnInstance?.handleStatus=='fRefuse'} || ${tradeWithdrawnInstance?.handleStatus=='sRefuse'}">
            <tr>
                <td class="right label_name"><g:message code="拒绝原因"/>：</td>
                <td><span class="rigt_tebl_font">${AppNote.findByAppIdAndAppName(tradeWithdrawnInstance?.id, 'tradeWithdrawn')?.appNote}</span></td>
            </tr>
        </g:if>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.dateCreated.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatDate date="${tradeWithdrawnInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeWithdrawn.note.label"/>：</td>
            <td><span class="rigt_tebl_font">${tradeWithdrawnInstance?.note}</span></td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <g:hiddenField name="id" value="${tradeWithdrawnInstance?.id}"/>
                <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
            </td>
        </tr>
    </table>

</div>

</body>
</html>