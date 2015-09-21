<%@ page import="boss.ReportAgentpayDaily" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'reportAgentpayDaily.label', default: 'ReportAgentpayDaily')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>

<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${reportAgentpayDailyInstance}">
        <div class="errors">
            <g:renderErrors bean="${reportAgentpayDailyInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="save">
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAgentpayDaily.customerNo.label"/>：</td>
                <td class="${hasErrors(bean: reportAgentpayDailyInstance, field: 'customerNo', 'errors')}"><g:textField
                        name="customerNo" value="${reportAgentpayDailyInstance?.customerNo}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAgentpayDaily.tradeAmountFail.label"/>：</td>
                <td class="${hasErrors(bean: reportAgentpayDailyInstance, field: 'tradeAmountFail', 'errors')}"><g:textField
                        name="tradeAmountFail"
                        value="${fieldValue(bean: reportAgentpayDailyInstance, field: 'tradeAmountFail')}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAgentpayDaily.tradeAmountSuccess.label"/>：</td>
                <td class="${hasErrors(bean: reportAgentpayDailyInstance, field: 'tradeAmountSuccess', 'errors')}"><g:textField
                        name="tradeAmountSuccess"
                        value="${fieldValue(bean: reportAgentpayDailyInstance, field: 'tradeAmountSuccess')}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAgentpayDaily.tradeCountFail.label"/>：</td>
                <td class="${hasErrors(bean: reportAgentpayDailyInstance, field: 'tradeCountFail', 'errors')}"><g:textField
                        name="tradeCountFail"
                        value="${fieldValue(bean: reportAgentpayDailyInstance, field: 'tradeCountFail')}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAgentpayDaily.tradeCountSuccess.label"/>：</td>
                <td class="${hasErrors(bean: reportAgentpayDailyInstance, field: 'tradeCountSuccess', 'errors')}"><g:textField
                        name="tradeCountSuccess"
                        value="${fieldValue(bean: reportAgentpayDailyInstance, field: 'tradeCountSuccess')}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAgentpayDaily.tradeFinishdate.label"/>：</td>
                <td class="${hasErrors(bean: reportAgentpayDailyInstance, field: 'tradeFinishdate', 'errors')}"><bo:datePicker
                        name="tradeFinishdate" precision="day"
                        value="${reportAgentpayDailyInstance?.tradeFinishdate}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAgentpayDaily.tradeSettleAmount.label"/>：</td>
                <td class="${hasErrors(bean: reportAgentpayDailyInstance, field: 'tradeSettleAmount', 'errors')}"><g:textField
                        name="tradeSettleAmount"
                        value="${fieldValue(bean: reportAgentpayDailyInstance, field: 'tradeSettleAmount')}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAgentpayDaily.tradeSettleFee.label"/>：</td>
                <td class="${hasErrors(bean: reportAgentpayDailyInstance, field: 'tradeSettleFee', 'errors')}"><g:textField
                        name="tradeSettleFee"
                        value="${fieldValue(bean: reportAgentpayDailyInstance, field: 'tradeSettleFee')}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAgentpayDaily.tradeType.label"/>：</td>
                <td class="${hasErrors(bean: reportAgentpayDailyInstance, field: 'tradeType', 'errors')}"><g:textField
                        name="tradeType" value="${reportAgentpayDailyInstance?.tradeType}"/></td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定">
                    </span>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>
