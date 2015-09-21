

<%@ page import="ismp.TradeRefundBatch" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tradeRefundBatch.label', default: 'TradeRefundBatch')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${tradeRefundBatchInstance}">
    <div class="errors">
      <g:renderErrors bean="${tradeRefundBatchInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${tradeRefundBatchInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tradeRefundBatch.refundType.label"/>：</td>
        <td class="${hasErrors(bean: tradeRefundBatchInstance, field: 'refundType', 'errors')}"><g:textField name="refundType" value="${tradeRefundBatchInstance?.refundType}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tradeRefundBatch.refundBankName.label"/>：</td>
        <td class="${hasErrors(bean: tradeRefundBatchInstance, field: 'refundBankName', 'errors')}"><g:textField name="refundBankName" value="${tradeRefundBatchInstance?.refundBankName}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tradeRefundBatch.refundBankCode.label"/>：</td>
        <td class="${hasErrors(bean: tradeRefundBatchInstance, field: 'refundBankCode', 'errors')}"><g:textField name="refundBankCode" value="${tradeRefundBatchInstance?.refundBankCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tradeRefundBatch.batchAmount.label"/>：</td>
        <td class="${hasErrors(bean: tradeRefundBatchInstance, field: 'batchAmount', 'errors')}"><g:textField name="batchAmount" value="${fieldValue(bean: tradeRefundBatchInstance, field: 'batchAmount')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tradeRefundBatch.batchCount.label"/>：</td>
        <td class="${hasErrors(bean: tradeRefundBatchInstance, field: 'batchCount', 'errors')}"><g:textField name="batchCount" value="${tradeRefundBatchInstance?.batchCount}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tradeRefundBatch.refundDate.label"/>：</td>
        <td class="${hasErrors(bean: tradeRefundBatchInstance, field: 'refundDate', 'errors')}"><bo:datePicker name="refundDate" precision="day" value="${tradeRefundBatchInstance?.refundDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tradeRefundBatch.status.label"/>：</td>
        <td class="${hasErrors(bean: tradeRefundBatchInstance, field: 'status', 'errors')}"><g:textField name="status" value="${tradeRefundBatchInstance?.status}" /></td>
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
