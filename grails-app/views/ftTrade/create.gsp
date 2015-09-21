

<%@ page import="settle.FtTrade" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'ftTrade.label', default: 'FtTrade')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${ftTradeInstance}">
    <div class="errors">
      <g:renderErrors bean="${ftTradeInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTrade.srvCode.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeInstance, field: 'srvCode', 'errors')}"><g:textField name="srvCode" maxlength="20" value="${ftTradeInstance?.srvCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTrade.tradeCode.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeInstance, field: 'tradeCode', 'errors')}"><g:textField name="tradeCode" maxlength="20" value="${ftTradeInstance?.tradeCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTrade.customerNo.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeInstance, field: 'customerNo', 'errors')}"><g:textField name="customerNo" maxlength="24" value="${ftTradeInstance?.customerNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTrade.seqNo.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeInstance, field: 'seqNo', 'errors')}"><g:textField name="seqNo" maxlength="24" value="${ftTradeInstance?.seqNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTrade.tradeDate.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeInstance, field: 'tradeDate', 'errors')}"><bo:datePicker name="tradeDate" precision="day" value="${ftTradeInstance?.tradeDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTrade.liquidateNo.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeInstance, field: 'liquidateNo', 'errors')}"><g:textField name="liquidateNo" value="${ftTradeInstance?.liquidateNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTrade.amount.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeInstance, field: 'amount', 'errors')}"><g:textField name="amount" value="${fieldValue(bean: ftTradeInstance, field: 'amount')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTrade.billDate.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeInstance, field: 'billDate', 'errors')}"><bo:datePicker name="billDate" precision="day" value="${ftTradeInstance?.billDate}" /></td>
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
