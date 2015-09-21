<%@ page import="boss.BoRole" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boRole.label', default: 'BoRole')}"/>
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
            <td class="right label_name"><g:message code="boRole.id.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boRoleInstance, field: "id")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boRole.roleCode.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boRoleInstance, field: "roleCode")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boRole.roleName.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boRoleInstance, field: "roleName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boRole.status.label"/>：</td>

            <td><span class="rigt_tebl_font">${BoRole.statusMap[boRoleInstance?.status]}</span></td>

        </tr>

        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${boRoleInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <g:if test="${boRoleInstance.roleCode!='admin'}">
                        <span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>
                        <span class="button"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
                    </g:if>
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>