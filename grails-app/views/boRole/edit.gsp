

<%@ page import="boss.BoRole" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boRole.label', default: 'BoRole')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boRoleInstance}">
    <div class="errors">
      <g:renderErrors bean="${boRoleInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${boRoleInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>
      %{----}%
      %{--<tr>--}%
        %{--<td class="right label_name"><g:message code="boRole.permission_id.label"/>：</td>--}%
        %{--<td class="${hasErrors(bean: boRoleInstance, field: 'permission_id', 'errors')}"><g:textField name="permission_id" value="${fieldValue(bean: boRoleInstance, field: 'permission_id')}" /></td>--}%
      %{--</tr>--}%
      
      <tr>
        <td class="right label_name"><g:message code="boRole.roleCode.label"/>：</td>
        <td class="${hasErrors(bean: boRoleInstance, field: 'roleCode', 'errors')}"><g:textField name="roleCode" maxlength="10" value="${boRoleInstance?.roleCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRole.roleName.label"/>：</td>
        <td class="${hasErrors(bean: boRoleInstance, field: 'roleName', 'errors')}"><g:textField name="roleName" maxlength="30" value="${boRoleInstance?.roleName}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRole.status.label"/>：</td>
        <td class="${hasErrors(bean: boRoleInstance, field: 'status', 'errors')}">
          <g:select name="status" from="${BoRole.statusMap}" optionKey="key" optionValue="value" value="${boRoleInstance?.status}"/>
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
