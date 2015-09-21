

<%@ page import="ismp.AcquireSynTrx" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acquireSynTrx.label', default: 'AcquireSynTrx')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${acquireSynTrxInstance}">
    <div class="errors">
      <g:renderErrors bean="${acquireSynTrxInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireSynTrx.acquireAuthcode.label"/>：</td>
        <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'acquireAuthcode', 'errors')}"><g:textField name="acquireAuthcode" value="${acquireSynTrxInstance?.acquireAuthcode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireSynTrx.acquireCardnum.label"/>：</td>
        <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'acquireCardnum', 'errors')}"><g:textField name="acquireCardnum" value="${acquireSynTrxInstance?.acquireCardnum}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireSynTrx.acquireDate.label"/>：</td>
        <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'acquireDate', 'errors')}"><g:textField name="acquireDate" value="${acquireSynTrxInstance?.acquireDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireSynTrx.acquireRefnum.label"/>：</td>
        <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'acquireRefnum', 'errors')}"><g:textField name="acquireRefnum" value="${acquireSynTrxInstance?.acquireRefnum}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireSynTrx.acquireSeq.label"/>：</td>
        <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'acquireSeq', 'errors')}"><g:textField name="acquireSeq" value="${acquireSynTrxInstance?.acquireSeq}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireSynTrx.batchnum.label"/>：</td>
        <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'batchnum', 'errors')}"><g:textField name="batchnum" value="${acquireSynTrxInstance?.batchnum}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireSynTrx.payerIp.label"/>：</td>
        <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'payerIp', 'errors')}"><g:textField name="payerIp" value="${acquireSynTrxInstance?.payerIp}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireSynTrx.acquireCode.label"/>：</td>
        <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'acquireCode', 'errors')}"><g:textField name="acquireCode" value="${acquireSynTrxInstance?.acquireCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireSynTrx.acquireMerchant.label"/>：</td>
        <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'acquireMerchant', 'errors')}"><g:textField name="acquireMerchant" value="${acquireSynTrxInstance?.acquireMerchant}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireSynTrx.amount.label"/>：</td>
        <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'amount', 'errors')}"><g:textField name="amount" value="${fieldValue(bean: acquireSynTrxInstance, field: 'amount')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireSynTrx.createDate.label"/>：</td>
        <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'createDate', 'errors')}"><bo:datePicker name="createDate" precision="day" value="${acquireSynTrxInstance?.createDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireSynTrx.trxid.label"/>：</td>
        <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'trxid', 'errors')}"><g:textField name="trxid" value="${acquireSynTrxInstance?.trxid}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireSynTrx.trxsts.label"/>：</td>
        <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'trxsts', 'errors')}"><g:textField name="trxsts" value="${fieldValue(bean: acquireSynTrxInstance, field: 'trxsts')}" /></td>
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
