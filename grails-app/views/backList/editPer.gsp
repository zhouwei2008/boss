<%@ page import="ismp.TbPersonBlackList; boss.Perm;" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbPersonBlackList.label', default: '个人客户黑名单')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <g:hasErrors bean="${tbPersonBlackListInstance}">
        <div class="errors">
            <g:renderErrors bean="${tbPersonBlackListInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="updatePer">
        <g:hiddenField name="id" value="${tbPersonBlackListInstance?.id}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name">姓名：</td>
                <td class="${hasErrors(bean: tbPersonBlackListInstance, field: 'name', 'errors')}"><g:textField name="name" maxlength="32" value="${tbPersonBlackListInstance.name}"/></td>
            </tr>

            <tr>
                <td class="right label_name">国籍：</td>
                <td class="${hasErrors(bean: tbPersonBlackListInstance, field: 'nationality', 'errors')}"><g:select name="nationality" from="${TbPersonBlackList.nationalityMap}" value="${tbPersonBlackListInstance.nationality}" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name">性别：</td>
                <td class="${hasErrors(bean: tbPersonBlackListInstance, field: 'gender', 'errors')}"><g:select name="gender" from="${TbPersonBlackList.genderMap}" value="${tbPersonBlackListInstance.gender}" optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name">职业：</td>
                <td class="${hasErrors(bean: tbPersonBlackListInstance, field: 'occupation', 'errors')}"><g:select name="occupation" from="${TbPersonBlackList.occupationMap}" value="${tbPersonBlackListInstance.occupation}"  optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name">住址：</td>
                <td class="${hasErrors(bean: tbPersonBlackListInstance, field: 'address', 'errors')}"><g:textField name="address" maxlength="200" value="${tbPersonBlackListInstance.address}"/></td>
            </tr>

            <tr>
                <td class="right label_name">联系方式：</td>
                <td class="${hasErrors(bean: tbPersonBlackListInstance, field: 'contactWay', 'errors')}"><g:textField name="contactWay" maxlength="20" value="${tbPersonBlackListInstance.contactWay}"/></td>
            </tr>


            <tr>
                <td class="right label_name">证件类型：</td>
                <td class="${hasErrors(bean: tbPersonBlackListInstance, field: 'identityType', 'errors')}"><g:select name="identityType" from="${TbPersonBlackList.identityTypeMap}" value="${tbPersonBlackListInstance.identityType}" optionKey="key" optionValue="value"/></td>
            </tr>


            <tr>
                <td class="right label_name">证件号码：</td>
                <td class="${hasErrors(bean: tbPersonBlackListInstance, field: 'identityNo', 'errors')}"><g:textField name="identityNo" maxlength="32" value="${tbPersonBlackListInstance.identityNo}"/></td>
            </tr>

            <tr>
                <td class="right label_name">来源：</td>
                <td class="${hasErrors(bean: tbPersonBlackListInstance, field: 'source', 'errors')}"><g:select name="source" from="${tbPersonBlackListInstance.sourceMap}" value="${tbPersonBlackListInstance.source}"  optionKey="key" optionValue="value"></g:select></td>
            </tr>

            <tr>
                <td class="right label_name">创建时间：</td>
                <td><span class="rigt_tebl_font"><g:formatDate date="${tbPersonBlackListInstance.createDate}" format="yyyy-MM-dd"/></span></td>
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
