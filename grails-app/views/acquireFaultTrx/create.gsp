

<%@ page import="ismp.AcquireFaultTrx" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${acquireFaultTrxInstance}">
    <div class="errors">
      <g:renderErrors bean="${acquireFaultTrxInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.trxid.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'trxid', 'errors')}"><g:textField name="trxid" value="${acquireFaultTrxInstance?.trxid}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.acquireTrxnum.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'acquireTrxnum', 'errors')}"><g:textField name="acquireTrxnum" value="${acquireFaultTrxInstance?.acquireTrxnum}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.trxdate.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'trxdate', 'errors')}"><g:textField name="trxdate" maxlength="14" value="${acquireFaultTrxInstance?.trxdate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.iniSts.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'iniSts', 'errors')}"><g:select name="iniSts" from="${acquireFaultTrxInstance.constraints.iniSts.inList}" value="${fieldValue(bean: acquireFaultTrxInstance, field: 'iniSts')}" valueMessagePrefix="acquireFaultTrx.iniSts"  /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.changeSts.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'changeSts', 'errors')}"><g:select name="changeSts" from="${acquireFaultTrxInstance.constraints.changeSts.inList}" value="${fieldValue(bean: acquireFaultTrxInstance, field: 'changeSts')}" valueMessagePrefix="acquireFaultTrx.changeSts"  /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.authSts.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'authSts', 'errors')}"><g:select name="authSts" from="${acquireFaultTrxInstance.constraints.authSts.inList}" value="${acquireFaultTrxInstance?.authSts}" valueMessagePrefix="acquireFaultTrx.authSts"  /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.datasrc.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'datasrc', 'errors')}"><g:select name="datasrc" from="${acquireFaultTrxInstance.constraints.datasrc.inList}" value="${acquireFaultTrxInstance?.datasrc}" valueMessagePrefix="acquireFaultTrx.datasrc" noSelection="['': '']" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.acquireCode.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'acquireCode', 'errors')}"><g:textField name="acquireCode" value="${acquireFaultTrxInstance?.acquireCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.acquireAuthcode.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'acquireAuthcode', 'errors')}"><g:textField name="acquireAuthcode" value="${acquireFaultTrxInstance?.acquireAuthcode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.acquireCardnum.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'acquireCardnum', 'errors')}"><g:textField name="acquireCardnum" maxlength="19" value="${acquireFaultTrxInstance?.acquireCardnum}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.acquireDate.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'acquireDate', 'errors')}"><g:textField name="acquireDate" value="${acquireFaultTrxInstance?.acquireDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.acquireRefnum.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'acquireRefnum', 'errors')}"><g:textField name="acquireRefnum" value="${acquireFaultTrxInstance?.acquireRefnum}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.acquireSeq.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'acquireSeq', 'errors')}"><g:textField name="acquireSeq" value="${acquireFaultTrxInstance?.acquireSeq}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.payerIp.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'payerIp', 'errors')}"><g:textField name="payerIp" value="${acquireFaultTrxInstance?.payerIp}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.finalSts.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'finalSts', 'errors')}"><g:select name="finalSts" from="${acquireFaultTrxInstance.constraints.finalSts.inList}" value="${acquireFaultTrxInstance?.finalSts}" valueMessagePrefix="acquireFaultTrx.finalSts"  /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.authOper.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'authOper', 'errors')}"><g:textField name="authOper" value="${acquireFaultTrxInstance?.authOper}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.faultAdvice.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'faultAdvice', 'errors')}"><g:textField name="faultAdvice" value="${acquireFaultTrxInstance?.faultAdvice}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.finalResult.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'finalResult', 'errors')}"><g:textField name="finalResult" value="${acquireFaultTrxInstance?.finalResult}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.batchnum.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'batchnum', 'errors')}"><g:textField name="batchnum" value="${acquireFaultTrxInstance?.batchnum}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.acquireMerchant.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'acquireMerchant', 'errors')}"><g:textField name="acquireMerchant" value="${acquireFaultTrxInstance?.acquireMerchant}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.authDate.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'authDate', 'errors')}"><bo:datePicker name="authDate" precision="day" value="${acquireFaultTrxInstance?.authDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.changeApplier.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'changeApplier', 'errors')}"><g:textField name="changeApplier" value="${acquireFaultTrxInstance?.changeApplier}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.createDate.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'createDate', 'errors')}"><bo:datePicker name="createDate" precision="day" value="${acquireFaultTrxInstance?.createDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.trxamount.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'trxamount', 'errors')}"><g:textField name="trxamount" value="${fieldValue(bean: acquireFaultTrxInstance, field: 'trxamount')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="acquireFaultTrx.updateDate.label"/>：</td>
        <td class="${hasErrors(bean: acquireFaultTrxInstance, field: 'updateDate', 'errors')}"><bo:datePicker name="updateDate" precision="day" value="${acquireFaultTrxInstance?.updateDate}" /></td>
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
