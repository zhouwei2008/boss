

<%@ page import="ismp.MapiAsyncNotify" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'mapiAsyncNotify.label', default: 'MapiAsyncNotify')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${mapiAsyncNotifyInstance}">
    <div class="errors">
      <g:renderErrors bean="${mapiAsyncNotifyInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${mapiAsyncNotifyInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.recordTable.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'recordTable', 'errors')}"><g:textField name="recordTable" value="${mapiAsyncNotifyInstance?.recordTable}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.recordId.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'recordId', 'errors')}"><g:textField name="recordId" value="${fieldValue(bean: mapiAsyncNotifyInstance, field: 'recordId')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.signType.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'signType', 'errors')}"><g:textField name="signType" value="${mapiAsyncNotifyInstance?.signType}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.notifyTime.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'notifyTime', 'errors')}"><bo:datePicker name="notifyTime" precision="day" value="${mapiAsyncNotifyInstance?.notifyTime}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.notifyId.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'notifyId', 'errors')}"><g:textField name="notifyId" value="${mapiAsyncNotifyInstance?.notifyId}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.nextAttemptTime.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'nextAttemptTime', 'errors')}"><bo:datePicker name="nextAttemptTime" precision="day" value="${mapiAsyncNotifyInstance?.nextAttemptTime}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.status.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'status', 'errors')}"><g:select name="status" from="${mapiAsyncNotifyInstance.constraints.status.inList}" value="${mapiAsyncNotifyInstance?.status}" valueMessagePrefix="mapiAsyncNotify.status"  /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.attemptsCount.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'attemptsCount', 'errors')}"><g:textField name="attemptsCount" value="${fieldValue(bean: mapiAsyncNotifyInstance, field: 'attemptsCount')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.timeExpired.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'timeExpired', 'errors')}"><bo:datePicker name="timeExpired" precision="day" value="${mapiAsyncNotifyInstance?.timeExpired}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.isVerify.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'isVerify', 'errors')}"><g:checkBox name="isVerify" value="${mapiAsyncNotifyInstance?.isVerify}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.outputCharset.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'outputCharset', 'errors')}"><g:textField name="outputCharset" value="${mapiAsyncNotifyInstance?.outputCharset}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.customerId.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'customerId', 'errors')}"><g:textField name="customerId" value="${fieldValue(bean: mapiAsyncNotifyInstance, field: 'customerId')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.notifyAddress.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'notifyAddress', 'errors')}"><g:textField name="notifyAddress" value="${mapiAsyncNotifyInstance?.notifyAddress}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.notifyContents.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'notifyContents', 'errors')}"><g:textField name="notifyContents" value="${mapiAsyncNotifyInstance?.notifyContents}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.notifyMethod.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'notifyMethod', 'errors')}"><g:textField name="notifyMethod" value="${mapiAsyncNotifyInstance?.notifyMethod}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="mapiAsyncNotify.record.label"/>：</td>
        <td class="${hasErrors(bean: mapiAsyncNotifyInstance, field: 'record', 'errors')}"><g:select name="record.id" from="${gateway.GwOrder.list()}" optionKey="id" value="${mapiAsyncNotifyInstance?.record?.id}"  /></td>
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
