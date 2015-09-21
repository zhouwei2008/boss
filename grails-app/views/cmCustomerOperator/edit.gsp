<%@ page import="ismp.CmCustomer; ismp.CmCustomerOperator" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cmCustomerOperator.label', default: 'CmCustomerOperator')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${cmCustomerOperatorInstance}">
        <div class="errors">
            <g:renderErrors bean="${cmCustomerOperatorInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="update">
        <g:hiddenField name="id" value="${cmCustomerOperatorInstance?.id}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="商户名称"/>：</td>
                <td class="${hasErrors(bean: cmCustomerOperatorInstance, field: 'customer', 'errors')}"/>
                    ${CmCustomer.get(cmCustomerOperatorInstance.customer.id)?.name}
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="商户号"/>：</td>
                <td class="${hasErrors(bean: cmCustomerOperatorInstance, field: 'customer', 'errors')}"/>
                    ${CmCustomer.get(cmCustomerOperatorInstance.customer.id)?.customerNo}
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmCustomerOperator.name.label"/>：</td>
                <td class="${hasErrors(bean: cmCustomerOperatorInstance, field: 'name', 'errors')}"><g:textField name="name" maxlength="32" value="${cmCustomerOperatorInstance?.name}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmCustomerOperator.defaultEmail.label"/>：</td>
                <td class="${hasErrors(bean: cmCustomerOperatorInstance, field: 'defaultEmail', 'errors')}"><g:textField name="defaultEmail" maxlength="64" value="${cmCustomerOperatorInstance?.defaultEmail}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmCustomerOperator.defaultMobile.label"/>：</td>
                <td class="${hasErrors(bean: cmCustomerOperatorInstance, field: 'defaultMobile', 'errors')}"><g:textField name="defaultMobile" maxlength="16" value="${cmCustomerOperatorInstance?.defaultMobile}"/></td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="cmCustomerOperator.dateCreated.label"/>：</td>
                <td class="${hasErrors(bean: cmCustomerOperatorInstance, field: 'dateCreated', 'errors')}"><g:formatDate date="${cmCustomerOperatorInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
            </tr>

            %{--<tr>--}%
            %{--<td class="right label_name"><g:message code="cmCustomerOperator.loginErrorTime.label"/>：</td>--}%
            %{--<td class="${hasErrors(bean: cmCustomerOperatorInstance, field: 'loginErrorTime', 'errors')}"><g:textField name="loginErrorTime" value="${fieldValue(bean: cmCustomerOperatorInstance, field: 'loginErrorTime')}" /></td>--}%
            %{--</tr>--}%

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
