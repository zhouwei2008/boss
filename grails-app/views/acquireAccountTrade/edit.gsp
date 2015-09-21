

<%@ page import="ismp.AcquireAccountTrade" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${acquireAccountTradeInstance}">
    <div class="errors">
      <g:renderErrors bean="${acquireAccountTradeInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${acquireAccountTradeInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireAccountTrade.acquirerAccountId.label"/>：</td>
        <td class="${hasErrors(bean: acquireAccountTradeInstance, field: 'acquirerAccountId', 'errors')}"><g:textField name="acquirerAccountId" value="${acquireAccountTradeInstance?.acquirerAccountId}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireAccountTrade.amount.label"/>：</td>
        <td class="${hasErrors(bean: acquireAccountTradeInstance, field: 'amount', 'errors')}"><g:textField name="amount" value="${fieldValue(bean: acquireAccountTradeInstance, field: 'amount')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireAccountTrade.currency.label"/>：</td>
        <td class="${hasErrors(bean: acquireAccountTradeInstance, field: 'currency', 'errors')}"><g:textField name="currency" value="${acquireAccountTradeInstance?.currency}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireAccountTrade.outTradeNo.label"/>：</td>
        <td class="${hasErrors(bean: acquireAccountTradeInstance, field: 'outTradeNo', 'errors')}"><g:textField name="outTradeNo" value="${acquireAccountTradeInstance?.outTradeNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireAccountTrade.outTradeOrderNo.label"/>：</td>
        <td class="${hasErrors(bean: acquireAccountTradeInstance, field: 'outTradeOrderNo', 'errors')}"><g:textField name="outTradeOrderNo" value="${acquireAccountTradeInstance?.outTradeOrderNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireAccountTrade.refundAmount.label"/>：</td>
        <td class="${hasErrors(bean: acquireAccountTradeInstance, field: 'refundAmount', 'errors')}"><g:textField name="refundAmount" value="${fieldValue(bean: acquireAccountTradeInstance, field: 'refundAmount')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireAccountTrade.status.label"/>：</td>
        <td class="${hasErrors(bean: acquireAccountTradeInstance, field: 'status', 'errors')}"><g:textField name="status" value="${acquireAccountTradeInstance?.status}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireAccountTrade.tradeDate.label"/>：</td>
        <td class="${hasErrors(bean: acquireAccountTradeInstance, field: 'tradeDate', 'errors')}"><g:textField name="tradeDate" value="${fieldValue(bean: acquireAccountTradeInstance, field: 'tradeDate')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireAccountTrade.tradePayTime.label"/>：</td>
        <td class="${hasErrors(bean: acquireAccountTradeInstance, field: 'tradePayTime', 'errors')}"><bo:datePicker name="tradePayTime" precision="day" value="${acquireAccountTradeInstance?.tradePayTime}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireAccountTrade.withdrawStatus.label"/>：</td>
        <td class="${hasErrors(bean: acquireAccountTradeInstance, field: 'withdrawStatus', 'errors')}"><g:textField name="withdrawStatus" value="${acquireAccountTradeInstance?.withdrawStatus}" /></td>
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
