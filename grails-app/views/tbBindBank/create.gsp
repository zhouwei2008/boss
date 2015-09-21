

<%@ page import="dsf.TbBindBank" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbBindBank.label', default: 'TbBindBank')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${tbBindBankInstance}">
    <div class="errors">
      <g:renderErrors bean="${tbBindBankInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbBindBank.dsfFlag.label"/>：</td>
        <td class="${hasErrors(bean: tbBindBankInstance, field: 'dsfFlag', 'errors')}"><g:textField name="dsfFlag" maxlength="2" value="${tbBindBankInstance?.dsfFlag}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbBindBank.bankAccountno.label"/>：</td>
        <td class="${hasErrors(bean: tbBindBankInstance, field: 'bankAccountno', 'errors')}"><g:textField name="bankAccountno" maxlength="30" value="${tbBindBankInstance?.bankAccountno}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbBindBank.notes.label"/>：</td>
        <td class="${hasErrors(bean: tbBindBankInstance, field: 'notes', 'errors')}"><g:textField name="notes" maxlength="100" value="${tbBindBankInstance?.notes}" /></td>
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
