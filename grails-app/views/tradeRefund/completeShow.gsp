<%@ page import="boss.AppNote; boss.BoAcquirerAccount; ismp.TradeRefund" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeRefund.label', default: 'TradeRefund')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>

    <g:form>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.tradeNo.label"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeRefundInstance, field: "tradeNo")}</span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.payerName.label"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeRefundInstance, field: "payerName")}</span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.payerAccountNo.label"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeRefundInstance, field: "payerAccountNo")}</span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.amount.label"/>：</td>

                <td><span class="rigt_tebl_font" id="amount" val="${tradeRefundInstance?.amount / 100}"><g:formatNumber number="${tradeRefundInstance?.amount/100}" type="currency" currencyCode="CNY"/></span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.feeAmount.label"/>：</td>

                <td><span class="rigt_tebl_font"><g:formatNumber number="${tradeRefundInstance?.feeAmount/100}" type="currency" currencyCode="CNY"/></span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.backFee.label"/>：</td>
                <td><span class="rigt_tebl_font"><g:formatNumber number="${tradeRefundInstance?.backFee/100}" type="currency" currencyCode="CNY"/></span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.acquirer_account_id.label"/>：</td>
                <td>
%{--//                    ${tradeRefundInstance?.acquirer_account_id}--}%
                    ${BoAcquirerAccount.get(tradeRefundInstance.acquirer_account_id)?.comboName}
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.handleStatus.label"/>：</td>

                <td><span class="rigt_tebl_font">${TradeRefund.handleStatusMap[tradeRefundInstance?.handleStatus]}</span></td>

            </tr>

            <g:if test="${tradeRefundInstance?.handleStatus=='fRefuse'} || ${tradeRefundInstance?.handleStatus=='sRefuse'}">

                <tr>
                    <td class="right label_name"><g:message code="拒绝原因"/>：</td>

                    <td><span class="rigt_tebl_font">${AppNote.findByAppIdAndAppName(tradeRefundInstance?.id,'tradeRefund')?.appNote}</span></td>

                </tr>

            </g:if>
            <tr>
                <td class="right label_name"><g:message code="tradeRefund.dateCreated.label"/>：</td>

                <td><span class="rigt_tebl_font"><g:formatDate date="${tradeRefundInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.note.label"/>：</td>

                <td>${tradeRefundInstance?.note}</td>

            </tr>

            <tr>
                <td colspan="2" align="center">
                    <g:form>
                        <g:hiddenField name="id" value="${tradeRefundInstance?.id}"/>
                        <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    %{--<span class="button"><g:actionSubmit class="rigt_button" action="fCheck" value="通过"/></span>--}%
                    %{--<span class="button"><g:actionSubmit class="rigt_button" action="unCheck" flag='1' value="拒绝"/></span>--}%
                    </g:form>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>