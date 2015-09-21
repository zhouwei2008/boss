

<%@ page import="settle.FtFoot" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'ftFoot.label', default: 'FtFoot')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${ftFootInstance}">
    <div class="errors">
      <g:renderErrors bean="${ftFootInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${ftFootInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.srvCode.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'srvCode', 'errors')}"><g:textField name="srvCode" maxlength="20" value="${ftFootInstance?.srvCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.tradeCode.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'tradeCode', 'errors')}"><g:textField name="tradeCode" maxlength="20" value="${ftFootInstance?.tradeCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.customerNo.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'customerNo', 'errors')}"><g:textField name="customerNo" maxlength="24" value="${ftFootInstance?.customerNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.type.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'type', 'errors')}"><g:textField name="type" value="${fieldValue(bean: ftFootInstance, field: 'type')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.footNo.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'footNo', 'errors')}"><g:textField name="footNo" maxlength="30" value="${ftFootInstance?.footNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.checkStatus.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'checkStatus', 'errors')}"><g:textField name="checkStatus" value="${fieldValue(bean: ftFootInstance, field: 'checkStatus')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.checkOpId.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'checkOpId', 'errors')}"><g:textField name="checkOpId" value="${fieldValue(bean: ftFootInstance, field: 'checkOpId')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.checkDate.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'checkDate', 'errors')}"><bo:datePicker name="checkDate" precision="day" value="${ftFootInstance?.checkDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.createOpId.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'createOpId', 'errors')}"><g:textField name="createOpId" value="${fieldValue(bean: ftFootInstance, field: 'createOpId')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.amount.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'amount', 'errors')}"><g:textField name="amount" value="${fieldValue(bean: ftFootInstance, field: 'amount')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.feeType.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'feeType', 'errors')}"><g:textField name="feeType" value="${fieldValue(bean: ftFootInstance, field: 'feeType')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.footDate.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'footDate', 'errors')}"><bo:datePicker name="footDate" precision="day" value="${ftFootInstance?.footDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.postFee.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'postFee', 'errors')}"><g:textField name="postFee" value="${fieldValue(bean: ftFootInstance, field: 'postFee')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.preFee.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'preFee', 'errors')}"><g:textField name="preFee" value="${fieldValue(bean: ftFootInstance, field: 'preFee')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftFoot.transNum.label"/>：</td>
        <td class="${hasErrors(bean: ftFootInstance, field: 'transNum', 'errors')}"><g:textField name="transNum" value="${fieldValue(bean: ftFootInstance, field: 'transNum')}" /></td>
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
