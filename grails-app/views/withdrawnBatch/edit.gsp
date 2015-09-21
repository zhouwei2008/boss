

<%@ page import="ismp.WithdrawnBatch" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'withdrawnBatch.label', default: 'WithdrawnBatch')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${withdrawnBatchInstance}">
    <div class="errors">
      <g:renderErrors bean="${withdrawnBatchInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${withdrawnBatchInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="withdrawnBatch.withdrawnBankCode.label"/>：</td>
        <td class="${hasErrors(bean: withdrawnBatchInstance, field: 'withdrawnBankCode', 'errors')}"><g:textField name="withdrawnBankCode" value="${withdrawnBatchInstance?.withdrawnBankCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="withdrawnBatch.withdrawnBankName.label"/>：</td>
        <td class="${hasErrors(bean: withdrawnBatchInstance, field: 'withdrawnBankName', 'errors')}"><g:textField name="withdrawnBankName" value="${withdrawnBatchInstance?.withdrawnBankName}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="withdrawnBatch.appId.label"/>：</td>
        <td class="${hasErrors(bean: withdrawnBatchInstance, field: 'appId', 'errors')}"><g:textField name="appId" value="${withdrawnBatchInstance?.appId}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="withdrawnBatch.appName.label"/>：</td>
        <td class="${hasErrors(bean: withdrawnBatchInstance, field: 'appName', 'errors')}"><g:textField name="appName" value="${withdrawnBatchInstance?.appName}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="withdrawnBatch.batchAmount.label"/>：</td>
        <td class="${hasErrors(bean: withdrawnBatchInstance, field: 'batchAmount', 'errors')}"><g:textField name="batchAmount" value="${fieldValue(bean: withdrawnBatchInstance, field: 'batchAmount')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="withdrawnBatch.batchCount.label"/>：</td>
        <td class="${hasErrors(bean: withdrawnBatchInstance, field: 'batchCount', 'errors')}"><g:textField name="batchCount" value="${withdrawnBatchInstance?.batchCount}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="withdrawnBatch.status.label"/>：</td>
        <td class="${hasErrors(bean: withdrawnBatchInstance, field: 'status', 'errors')}"><g:textField name="status" value="${withdrawnBatchInstance?.status}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="withdrawnBatch.withdrawnDate.label"/>：</td>
        <td class="${hasErrors(bean: withdrawnBatchInstance, field: 'withdrawnDate', 'errors')}"><bo:datePicker name="withdrawnDate" precision="day" value="${withdrawnBatchInstance?.withdrawnDate}" /></td>
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
