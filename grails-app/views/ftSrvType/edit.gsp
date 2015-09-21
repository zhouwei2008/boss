

<%@ page import="settle.FtSrvType" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'ftSrvType.label', default: 'FtSrvType')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${ftSrvTypeInstance}">
    <div class="errors">
      <g:renderErrors bean="${ftSrvTypeInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${ftSrvTypeInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftSrvType.srvCode.label"/>：</td>
        <td class="${hasErrors(bean: ftSrvTypeInstance, field: 'srvCode', 'errors')}"><g:textField name="srvCode" maxlength="20" value="${ftSrvTypeInstance?.srvCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftSrvType.srvName.label"/>：</td>
        <td class="${hasErrors(bean: ftSrvTypeInstance, field: 'srvName', 'errors')}"><g:textField name="srvName" maxlength="30" value="${ftSrvTypeInstance?.srvName}" /></td>
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
