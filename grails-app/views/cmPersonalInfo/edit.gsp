<%@ page import="ismp.CmPersonalInfo;ismp.CmCustomer" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cmPersonalInfo.label', default: 'CmPersonalInfo')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <g:hasErrors bean="${cmPersonalInfoInstance}">
        <div class="errors">
            <g:renderErrors bean="${cmPersonalInfoInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="update">
        <g:hiddenField name="id" value="${cmPersonalInfoInstance?.id}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmPersonalInfo.customerNo.label"/>：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'customerNo', 'errors')}"><span class="rigt_tebl_font">${cmPersonalInfoInstance?.customerNo}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmPersonalInfo.name.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'name', 'errors')}"><g:textField name="name" maxlength="32" value="${cmPersonalInfoInstance?.name}"/></td>
            </tr>

            <tr>
                <td class="right label_name">国籍：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'nationality', 'errors')}"><g:select name="nationality" from="${CmPersonalInfo.nationalityMap}" value="${cmPersonalInfoInstance.nationality}" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name">性别：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'gender', 'errors')}"><g:select name="gender" from="${CmPersonalInfo.genderMap}" value="${cmPersonalInfoInstance.gender}" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name">职业：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'occupation', 'errors')}"><g:select name="occupation" from="${CmPersonalInfo.occupationMap}" value="${cmPersonalInfoInstance.occupation}" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name">住址：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'address', 'errors')}"><g:textField name="address" maxlength="200" value="${cmPersonalInfoInstance.address}"/></td>
            </tr>

            <tr>
                <td class="right label_name">联系方式：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'contactWay', 'errors')}"><g:textField name="contactWay" maxlength="20" value="${cmPersonalInfoInstance.contactWay}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmPersonalInfo.status.label"/>：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'status', 'errors')}"><g:select name="status" from="${CmCustomer.statusMap}" value="${cmPersonalInfoInstance?.status}" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmPersonalInfo.accountNo.label"/>：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'accountNo', 'errors')}"><span class="rigt_tebl_font">${cmPersonalInfoInstance?.accountNo}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmPersonalInfo.identityType.label"/>：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'identityType', 'errors')}"><g:select name="identityType" from="${CmPersonalInfo.identityTypeMap}" value="${cmPersonalInfoInstance.identityType}" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmPersonalInfo.identityNo.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'identityNo', 'errors')}"><g:textField name="identityNo" maxlength="32" onkeyup="this.value=this.value.replace(/[^\\w]/g,'')" onpaste="this.value=this.value.replace(/[^\\w]/g,'')" value="${cmPersonalInfoInstance?.identityNo}"/></td>
            </tr>

            <tr>
                <td class="right label_name">有效期限：</td>
                <td  class="${hasErrors(bean: cmPersonalInfoInstance, field: 'validTime', 'errors')}">
                    <bo:datePicker name="validTime" precision="day" value="${cmPersonalInfoInstance?.validTime}"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name">客户等级：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'grade', 'errors')}"><g:select name="grade" from="${CmPersonalInfo.gradeMap}" value="${cmPersonalInfoInstance.grade}" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmPersonalInfo.needInvoice.label"/>：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'needInvoice', 'errors')}"><g:checkBox name="needInvoice" value="${cmPersonalInfoInstance?.needInvoice}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmPersonalInfo.dateCreated.label"/>：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'registrationDate', 'errors')}"><g:formatDate date="${cmPersonalInfoInstance?.dateCreated}" format="yyyy-MM-dd"/></td>
            </tr>

            <tr>
                <td class="right label_name">单笔限额：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'limitPerTrx', 'errors')}"><g:textField name="limitPerTrx" maxlength="20" value="${cmPersonalInfoInstance.limitPerTrx}"/></td>
            </tr>

            <tr>
                <td class="right label_name">单日累计限额：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'totalAmountlimitPerDay', 'errors')}"><g:textField name="totalAmountlimitPerDay" maxlength="20" value="${cmPersonalInfoInstance.totalAmountlimitPerDay}"/></td>
            </tr>

            <tr>
                <td class="right label_name">单日累计笔数：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'trxsCountNumPerDay', 'errors')}"><g:textField name="trxsCountNumPerDay" maxlength="20" value="${cmPersonalInfoInstance.trxsCountNumPerDay}"/></td>
            </tr>

            <tr>
                <td class="right label_name">单月累计限额：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'totalAmountLimitPermonth', 'errors')}"><g:textField name="totalAmountLimitPermonth" maxlength="20" value="${cmPersonalInfoInstance.totalAmountLimitPermonth}"/></td>
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
