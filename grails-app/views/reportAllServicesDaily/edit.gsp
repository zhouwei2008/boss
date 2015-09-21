<%@ page import="boss.ReportAllServicesDaily" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName"
           value="${message(code: 'reportAllServicesDaily.label', default: 'ReportAllServicesDaily')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>

<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${reportAllServicesDailyInstance}">
        <div class="errors">
            <g:renderErrors bean="${reportAllServicesDailyInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="update">
        <g:hiddenField name="id" value="${reportAllServicesDailyInstance?.id}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAllServicesDaily.tradeCount.label"/>：</td>
                <td class="${hasErrors(bean: reportAllServicesDailyInstance, field: 'tradeCount', 'errors')}"><g:textField
                        name="tradeCount"
                        value="${fieldValue(bean: reportAllServicesDailyInstance, field: 'tradeCount')}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAllServicesDaily.tradeNetAmount.label"/>：</td>
                <td class="${hasErrors(bean: reportAllServicesDailyInstance, field: 'tradeNetAmount', 'errors')}"><g:textField
                        name="tradeNetAmount"
                        value="${fieldValue(bean: reportAllServicesDailyInstance, field: 'tradeNetAmount')}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAllServicesDaily.tradeNetFee.label"/>：</td>
                <td class="${hasErrors(bean: reportAllServicesDailyInstance, field: 'tradeNetFee', 'errors')}"><g:textField
                        name="tradeNetFee"
                        value="${fieldValue(bean: reportAllServicesDailyInstance, field: 'tradeNetFee')}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAllServicesDaily.tradeBankFee.label"/>：</td>
                <td class="${hasErrors(bean: reportAllServicesDailyInstance, field: 'tradeBankFee', 'errors')}"><g:textField
                        name="tradeBankFee"
                        value="${fieldValue(bean: reportAllServicesDailyInstance, field: 'tradeBankFee')}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAllServicesDaily.tradeFinishdate.label"/>：</td>
                <td class="${hasErrors(bean: reportAllServicesDailyInstance, field: 'tradeFinishdate', 'errors')}"><bo:datePicker
                        name="tradeFinishdate" precision="day"
                        value="${reportAllServicesDailyInstance?.tradeFinishdate}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAllServicesDaily.customerNo.label"/>：</td>
                <td class="${hasErrors(bean: reportAllServicesDailyInstance, field: 'customerNo', 'errors')}"><g:textField
                        name="customerNo" value="${reportAllServicesDailyInstance?.customerNo}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="reportAllServicesDaily.serviceCode.label"/>：</td>
                <td class="${hasErrors(bean: reportAllServicesDailyInstance, field: 'serviceCode', 'errors')}"><g:textField
                        name="serviceCode" value="${reportAllServicesDailyInstance?.serviceCode}"/></td>
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
