<%@ page import="boss.BoBankDic; ismp.CmCustomerBankAccount" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cmCustomerBankAccount.label', default: 'CmCustomerBankAccount')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <g:hasErrors bean="${cmCustomerBankAccountInstance}">
        <div class="errors">
            <g:renderErrors bean="${cmCustomerBankAccountInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="save">
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmCustomerBankAccount.customer.label"/>：</td>
                <td><span class="rigt_tebl_font">${cmCustomerBankAccountInstance?.customer?.name}</span>
                    <g:hiddenField name="customer.id" value="${cmCustomerBankAccountInstance?.customer?.id}"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmCustomerBankAccount.bankName.label"/>：</td>
                <td class="${hasErrors(bean: cmCustomerBankAccountInstance, field: 'bankName', 'errors')}">
                    <g:select name="bankCode" value="${cmCustomerBankAccountInstance?.bankCode}" from="${BoBankDic.findAll()}" optionKey="code" optionValue="name"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmCustomerBankAccount.branch.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: cmCustomerBankAccountInstance, field: 'branch', 'errors')}"><g:textField name="branch" maxlength="64" value="${cmCustomerBankAccountInstance?.branch}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmCustomerBankAccount.subbranch.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: cmCustomerBankAccountInstance, field: 'subbranch', 'errors')}"><g:textField name="subbranch" maxlength="64" value="${cmCustomerBankAccountInstance?.subbranch}"/></td>
            </tr>

            <%--tr>
              <td class="right label_name">地区：</td>
              <td class="${hasErrors(bean: cmCustomerBankAccountInstance, field: 'region', 'errors')} ${hasErrors(bean: cmCustomerBankAccountInstance, field: 'city', 'errors')}">
                <bo:regionSelect rname="region" cname="city" rvalue="${cmCustomerBankAccountInstance?.region}" cvalue="${cmCustomerBankAccountInstance?.city}"/>
              </td>
            </tr--%>
            <tr>
                <td class="right label_name">所在省份：</td>
                <td class="${hasErrors(bean: cmCustomerBankAccountInstance, field: 'accountProvince', 'errors')}"><g:textField name="accountProvince" maxlength="64" value="${cmCustomerBankAccountInstance?.accountProvince}"/></td>
            </tr>
            <tr>
                <td class="right label_name">所在地区：</td>
                <td class="${hasErrors(bean: cmCustomerBankAccountInstance, field: 'accountCity', 'errors')}"><g:textField name="accountCity" maxlength="64" value="${cmCustomerBankAccountInstance?.accountCity}"/></td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="cmCustomerBankAccount.bankNo.label"/>：</td>
                <td class="${hasErrors(bean: cmCustomerBankAccountInstance, field: 'bankNo', 'errors')}"><g:textField name="bankNo" maxlength="16" value="${cmCustomerBankAccountInstance?.bankNo}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmCustomerBankAccount.bankAccountNo.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: cmCustomerBankAccountInstance, field: 'bankAccountNo', 'errors')}"><g:textField name="bankAccountNo" maxlength="32" value="${cmCustomerBankAccountInstance?.bankAccountNo}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmCustomerBankAccount.bankAccountName.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: cmCustomerBankAccountInstance, field: 'bankAccountName', 'errors')}"><g:textField name="bankAccountName" maxlength="40" value="${cmCustomerBankAccountInstance?.bankAccountName}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmCustomerBankAccount.note.label"/>：</td>
                <td class="${hasErrors(bean: cmCustomerBankAccountInstance, field: 'note', 'errors')}"><g:textField name="note" maxlength="128" value="${cmCustomerBankAccountInstance?.note}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmCustomerBankAccount.isCorporate.label"/>：</td>
                <td class="${hasErrors(bean: cmCustomerBankAccountInstance, field: 'isCorporate', 'errors')}">
                    %{--<g:checkBox name="isCorporate" value="${cmCustomerBankAccountInstance?.isCorporate}"/>--}%
                    <g:select name="isCorporate" value="${cmCustomerBankAccountInstance?.isCorporate}" from="${CmCustomerBankAccount.isCorporateMap}" optionKey="key" optionValue="value"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmCustomerBankAccount.isVerify.label"/>：</td>
                <td class="${hasErrors(bean: cmCustomerBankAccountInstance, field: 'isVerify', 'errors')}"><g:checkBox name="isVerify" value="${cmCustomerBankAccountInstance?.isVerify}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmCustomerBankAccount.status.label"/>：</td>
                <td class="${hasErrors(bean: cmCustomerBankAccountInstance, field: 'status', 'errors')}">
                    <g:select name="status" value="${cmCustomerBankAccountInstance?.status}" from="${CmCustomerBankAccount.statusMap}" optionKey="key" optionValue="value"/>
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
