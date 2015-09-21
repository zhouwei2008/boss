<%@ page import="ismp.CmCustomer; ismp.CmPersonalInfo" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cmPersonalInfo.label', default: 'CmPersonalInfo')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
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

    <g:form action="save" name="saveForm">
        <g:hiddenField name="appId" value="${params.appId}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmPersonalInfo.name.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'name', 'errors')}"><g:textField name="name" maxlength="32" value="${params.name}"/></td>
            </tr>

            <tr>
                <td class="right label_name">国籍：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'nationality', 'errors')}"><g:select name="nationality" from="${CmPersonalInfo.nationalityMap}" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name">性别：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'gender', 'errors')}"><g:select name="gender" from="${CmPersonalInfo.genderMap}" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name">职业：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'occupation', 'errors')}"><g:select name="occupation" from="${CmPersonalInfo.occupationMap}" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name">住址：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'address', 'errors')}"><g:textField name="address" maxlength="200" value="${params.address}"/></td>
            </tr>

            <tr>
                <td class="right label_name">联系方式：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'contactWay', 'errors')}"><g:textField name="contactWay" maxlength="20" value="${params.contactWay}"/></td>
            </tr>


            <tr>
                <td class="right label_name"><g:message code="cmPersonalInfo.status.label"/>：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'status', 'errors')}"><g:select name="status" from="['init': '受限']" value="init" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmPersonalInfo.identityType.label"/>：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'identityType', 'errors')}"><g:select name="identityType" from="${CmPersonalInfo.identityTypeMap}" optionKey="key" optionValue="value"/></td>
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
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'grade', 'errors')}"><g:select name="grade" from="${CmPersonalInfo.gradeMap}" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="cmPersonalInfo.needInvoice.label"/>：</td>
                <td class="${hasErrors(bean: cmPersonalInfoInstance, field: 'needInvoice', 'errors')}"><g:checkBox name="needInvoice" value="${cmPersonalInfoInstance?.needInvoice}"/></td>
            </tr>

            <tr>
                <td class="right label_name">登录邮箱<font color="red">*</font>：</td>
                <td><g:textField name="defaultEmail" maxlength="50" value="${params.defaultEmail}"/></td>
            </tr>


            <tr>
                <td class="right label_name">单笔限额<font color="red">*</font>：</td>
                <td><g:textField name="qutor" maxlength="50" value="${params.limitPerTrx}"/></td>
            </tr>


            <tr>
                <td class="right label_name">单日累计限额<font color="red">*</font>：</td>
                <td><g:textField name="dayTrxsSumAmount" maxlength="50" value="${params.totalAmountlimitPerDay}"/></td>
            </tr>


            <tr>
                <td class="right label_name">单日累计笔数<font color="red">*</font>：</td>
                <td><g:textField name="dayTrxsSumNum" maxlength="50" value="${params.trxsCountNumPerDay}"/></td>
            </tr>


            <tr>
                <td class="right label_name">单月累计限额<font color="red">*</font>：</td>
                <td><g:textField name="monthTrxsSumAmount" maxlength="50" value="${params.totalAmountLimitPermonth}"/></td>
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

<script type="text/javascript">
  $(function() {
    $("#saveForm").validate({
      rules: {
        defaultEmail: {required: true, email: true}
      },
      focusInvalid: false,
      onkeyup: false
    });
  })
</script>
</body>
</html>
