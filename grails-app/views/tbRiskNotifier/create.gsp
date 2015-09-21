

<%@ page import="ismp.TbRiskNotifier" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbRiskNotifier.label', default: '通知人')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${tbRiskNotifierInstance}">
    <div class="errors">
      <g:renderErrors bean="${tbRiskNotifierInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name">通知人：</td>
        <td class="${hasErrors(bean: tbRiskNotifierInstance, field: 'name', 'errors')}"><g:textField name="name" maxlength="20" value="${tbRiskNotifierInstance?.name}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name">通知手机：</td>
        <td class="${hasErrors(bean: tbRiskNotifierInstance, field: 'subId', 'errors')}"><g:textField name="subId" maxlength="20" value="${tbRiskNotifierInstance?.subId}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name">通知邮箱：</td>
        <td class="${hasErrors(bean: tbRiskNotifierInstance, field: 'email', 'errors')}"><g:textField name="email" maxlength="20" value="${tbRiskNotifierInstance?.email}" /></td>
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
