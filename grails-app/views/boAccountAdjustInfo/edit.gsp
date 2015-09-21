

<%@ page import="boss.BoAccountAdjustInfo" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boAccountAdjustInfo.label', default: 'BoAccountAdjustInfo')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boAccountAdjustInfoInstance}">
    <div class="errors">
      <g:renderErrors bean="${boAccountAdjustInfoInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${boAccountAdjustInfoInstance?.id}"/>
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAccountAdjustInfo.fromAccountNo.label"/>：</td>
        <td class="${hasErrors(bean: boAccountAdjustInfoInstance, field: 'fromAccountNo', 'errors')}"><g:textField name="fromAccountNo" value="${boAccountAdjustInfoInstance?.fromAccountNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAccountAdjustInfo.toAccountNo.label"/>：</td>
        <td class="${hasErrors(bean: boAccountAdjustInfoInstance, field: 'toAccountNo', 'errors')}"><g:textField name="toAccountNo" value="${boAccountAdjustInfoInstance?.toAccountNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAccountAdjustInfo.adjustAmount.label"/>：</td>
        <td class="${hasErrors(bean: boAccountAdjustInfoInstance, field: 'adjustAmount', 'errors')}"><g:textField name="adjustAmount" value="${fieldValue(bean: boAccountAdjustInfoInstance, field: 'adjustAmount')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAccountAdjustInfo.remark.label"/>：</td>
        <td class="${hasErrors(bean: boAccountAdjustInfoInstance, field: 'remark', 'errors')}"><g:textField name="remark" value="${boAccountAdjustInfoInstance?.remark}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAccountAdjustInfo.status.label"/>：</td>
        <td class="${hasErrors(bean: boAccountAdjustInfoInstance, field: 'status', 'errors')}"><g:textField name="status" value="${boAccountAdjustInfoInstance?.status}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAccountAdjustInfo.approveTime.label"/>：</td>
        <td class="${hasErrors(bean: boAccountAdjustInfoInstance, field: 'approveTime', 'errors')}"><bo:datePicker name="approveTime" precision="day" value="${boAccountAdjustInfoInstance?.approveTime}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAccountAdjustInfo.approvePerson.label"/>：</td>
        <td class="${hasErrors(bean: boAccountAdjustInfoInstance, field: 'approvePerson', 'errors')}"><g:textField name="approvePerson" value="${boAccountAdjustInfoInstance?.approvePerson}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAccountAdjustInfo.approveView.label"/>：</td>
        <td class="${hasErrors(bean: boAccountAdjustInfoInstance, field: 'approveView', 'errors')}"><g:textField name="approveView" value="${boAccountAdjustInfoInstance?.approveView}" /></td>
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
