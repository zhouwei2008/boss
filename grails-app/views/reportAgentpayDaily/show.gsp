<%@ page import="boss.ReportAgentpayDaily" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'reportAgentpayDaily.label', default: 'ReportAgentpayDaily')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>

<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>

    <table align="center" class="rigt_tebl">
        <tr>
            <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="reportAgentpayDaily.id.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: reportAgentpayDailyInstance, field: "id")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="reportAgentpayDaily.customerNo.label"/>：</td>

            <td><span
                    class="rigt_tebl_font">${fieldValue(bean: reportAgentpayDailyInstance, field: "customerNo")}</span>
            </td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="reportAgentpayDaily.tradeAmountFail.label"/>：</td>

            <td><span
                    class="rigt_tebl_font">${fieldValue(bean: reportAgentpayDailyInstance, field: "tradeAmountFail")}</span>
            </td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="reportAgentpayDaily.tradeAmountSuccess.label"/>：</td>

            <td><span
                    class="rigt_tebl_font">${fieldValue(bean: reportAgentpayDailyInstance, field: "tradeAmountSuccess")}</span>
            </td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="reportAgentpayDaily.tradeCountFail.label"/>：</td>

            <td><span
                    class="rigt_tebl_font">${fieldValue(bean: reportAgentpayDailyInstance, field: "tradeCountFail")}</span>
            </td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="reportAgentpayDaily.tradeCountSuccess.label"/>：</td>

            <td><span
                    class="rigt_tebl_font">${fieldValue(bean: reportAgentpayDailyInstance, field: "tradeCountSuccess")}</span>
            </td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="reportAgentpayDaily.tradeFinishdate.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatDate
                    date="${reportAgentpayDailyInstance?.tradeFinishdate}"/></span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="reportAgentpayDaily.tradeSettleAmount.label"/>：</td>

            <td><span
                    class="rigt_tebl_font">${fieldValue(bean: reportAgentpayDailyInstance, field: "tradeSettleAmount")}</span>
            </td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="reportAgentpayDaily.tradeSettleFee.label"/>：</td>

            <td><span
                    class="rigt_tebl_font">${fieldValue(bean: reportAgentpayDailyInstance, field: "tradeSettleFee")}</span>
            </td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="reportAgentpayDaily.tradeType.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: reportAgentpayDailyInstance, field: "tradeType")}</span>
            </td>

        </tr>

        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${reportAgentpayDailyInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="button"><g:actionSubmit class="rigt_button" action="edit"
                                                         value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>
                    <span class="button"><g:actionSubmit class="rigt_button" action="delete"
                                                         value="${message(code: 'default.button.delete.label', default: 'Delete')}"
                                                         onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>