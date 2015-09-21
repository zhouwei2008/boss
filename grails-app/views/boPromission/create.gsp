

<%@ page import="boss.BoPromission" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boPromission.label', default: 'BoPromission')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boPromissionInstance}">
    <div class="errors">
      <g:renderErrors bean="${boPromissionInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boPromission.promissionCode.label"/>：</td>
        <td class="${hasErrors(bean: boPromissionInstance, field: 'promissionCode', 'errors')}"><g:textField name="promissionCode" value="${boPromissionInstance?.promissionCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boPromission.promissionName.label"/>：</td>
        <td class="${hasErrors(bean: boPromissionInstance, field: 'promissionName', 'errors')}"><g:textField name="promissionName" value="${boPromissionInstance?.promissionName}" /></td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boPromission.status.label"/>：</td>
        <td class="${hasErrors(bean: boPromissionInstance, field: 'status', 'errors')}">
            <g:select from="${BoPromission.statusMap}" name="status" optionKey="key" optionValue="value" value="${boPromissionInstance?.status}"></g:select>
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
