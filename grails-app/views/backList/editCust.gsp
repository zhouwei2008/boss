<%@ page import="ismp.TbCustomerBlackList; boss.Perm;" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbCustomerBlackList.label', default: '企业客户黑名单')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <g:hasErrors bean="${tbCustomerBlackListInstance}">
        <div class="errors">
            <g:renderErrors bean="${tbCustomerBlackListInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="updateCust" name="updateForm">
        <g:hiddenField name="id" value="${tbCustomerBlackListInstance?.id}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name">别称：</td>
                <td class="${hasErrors(bean: tbCustomerBlackListInstance, field: 'nickname', 'errors')}"><g:textField name="nickname" maxlength="32" value="${tbCustomerBlackListInstance.nickname}"/></td>
            </tr>

            <tr>
                <td class="right label_name">客户名称：</td>
                <td class="${hasErrors(bean: tbCustomerBlackListInstance, field: 'name', 'errors')}"><g:textField name="name" maxlength="32" value="${tbCustomerBlackListInstance.name}"/></td>
            </tr>

            <tr>
                <td class="right label_name">营业执照代码：</td>
                <td class="${hasErrors(bean: tbCustomerBlackListInstance, field: 'businessLicenseCode', 'errors')}"><g:textField name="businessLicenseCode" maxlength="32" value="${tbCustomerBlackListInstance.businessLicenseCode}"/></td>
            </tr>

            <tr>
                <td class="right label_name">营业执照有效期：</td>
                <td class="${hasErrors(bean: tbCustomerBlackListInstance, field: 'businessValidity', 'errors')}"><bo:datePicker name="businessValidity" precision="day" value="${tbCustomerBlackListInstance.businessValidity}"/></td>
            </tr>

            <tr>
                <td class="right label_name">组织机构代码：</td>
                <td class="${hasErrors(bean: tbCustomerBlackListInstance, field: 'organizationCode', 'errors')}"><g:textField name="organizationCode" maxlength="32" value="${tbCustomerBlackListInstance.organizationCode}"/></td>
            </tr>

            <tr>
                <td class="right label_name">客户地址：</td>
                <td class="${hasErrors(bean: tbCustomerBlackListInstance, field: 'address', 'errors')}"><g:textField name="address" maxlength="32" value="${tbCustomerBlackListInstance.address}"/></td>
            </tr>

            <tr>
                <td class="right label_name">经营范围：</td>
                <td class="${hasErrors(bean: tbCustomerBlackListInstance, field: 'businessScope', 'errors')}"><g:textField name="businessScope" maxlength="32" value="${tbCustomerBlackListInstance.businessScope}"/></td>
            </tr>

            <tr>
                <td class="right label_name">法定代表人：</td>
                <td class="${hasErrors(bean: tbCustomerBlackListInstance, field: 'legalPerson', 'errors')}"><g:textField name="legalPerson" maxlength="32" value="${tbCustomerBlackListInstance.legalPerson}"/></td>
            </tr>

            <tr>
                <td class="right label_name">证件类型：</td>
                <td class="${hasErrors(bean: tbCustomerBlackListInstance, field: 'identityType', 'errors')}"><g:select name="identityType" from="${TbCustomerBlackList.identityTypeMap}" value="${tbCustomerBlackListInstance.identityType}" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name">证件号码：</td>
                <td class="${hasErrors(bean: tbCustomerBlackListInstance, field: 'identityNo', 'errors')}"><g:textField name="identityNo" maxlength="32" value="${tbCustomerBlackListInstance.identityNo}"/></td>
            </tr>

            <tr>
                <td class="right label_name">证件有效期：</td>
                <td class="${hasErrors(bean: tbCustomerBlackListInstance, field: 'identityValidity', 'errors')}"><bo:datePicker name="identityValidity" precision="day" value="${tbCustomerBlackListInstance.identityValidity}"/></td>
            </tr>

            <tr>
                <td class="right label_name">来源：</td>
                <td class="${hasErrors(bean: tbCustomerBlackListInstance, field: 'source', 'errors')}"><g:select name="source" from="${TbCustomerBlackList.sourceMap}" value="${tbCustomerBlackListInstance.source}"  optionKey="key" optionValue="value"></g:select></td>
            </tr>

            <tr>
                <td class="right label_name">创建时间：</td>
                <td><span class="rigt_tebl_font"><g:formatDate date="${tbCustomerBlackListInstance.createDate}" format="yyyy-MM-dd"/></span></td>
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
        $("#updateForm").validate({
            rules: {
                nickname: {required: true} ,
                name: {required: true} ,
                businessLicenseCode: {required: true},
                organizationCode:  {required: true},
                legalPerson: {required: true},
                identityNo: {required: true},
                source:  {required: true}
            },
            focusInvalid: false,
            onkeyup: false
        });
    })
</script>
</body>
</html>