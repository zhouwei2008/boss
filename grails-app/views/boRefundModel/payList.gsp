<%@ page import="boss.BoRefundModel" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boRefundModel.label', default: 'BoRefundModel')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="支付模式" args="[entityName]"/></h1>
        <h2>
            <g:form action="updatePay">
                <table align="center" class="rigt_tebl">
                    <tr>
                        <td class="right label_name"><g:message code="支付模式"/>：</td>
                        <td><g:select name="payModel" value="${payModel}" from="${BoRefundModel.payModelMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
                            <g:hiddenField name="customerId" value="${customerId}"></g:hiddenField>
                        </td>
                        <td >
                            <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                            <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定"></span>
                        </td>
                    </tr>
                </table>
            </g:form>
        </h2>
    </div>
</div>
</body>
</html>
