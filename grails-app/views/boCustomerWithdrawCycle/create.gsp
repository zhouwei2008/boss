

<%@ page import="boss.BoCustomerWithdrawCycle" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boCustomerWithdrawCycle.label', default: 'BoCustomerWithdrawCycle')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boCustomerWithdrawCycleInstance}">
    <div class="errors">
      <g:renderErrors bean="${boCustomerWithdrawCycleInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boCustomerWithdrawCycle.customerNo.label"/>：</td>
        <td class="${hasErrors(bean: boCustomerWithdrawCycleInstance, field: 'customerNo', 'errors')}"><g:textField name="customerNo" maxlength="20" value="${boCustomerWithdrawCycleInstance?.customerNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boCustomerWithdrawCycle.withdrawType.label"/>：</td>
        <td class="${hasErrors(bean: boCustomerWithdrawCycleInstance, field: 'withdrawType', 'errors')}"><g:textField name="withdrawType" value="${fieldValue(bean: boCustomerWithdrawCycleInstance, field: 'withdrawType')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boCustomerWithdrawCycle.withdrawAmount.label"/>：</td>
        <td class="${hasErrors(bean: boCustomerWithdrawCycleInstance, field: 'withdrawAmount', 'errors')}"><g:textField name="withdrawAmount" value="${fieldValue(bean: boCustomerWithdrawCycleInstance, field: 'withdrawAmount')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boCustomerWithdrawCycle.cycleType.label"/>：</td>
        <td class="${hasErrors(bean: boCustomerWithdrawCycleInstance, field: 'cycleType', 'errors')}"><g:textField name="cycleType" value="${fieldValue(bean: boCustomerWithdrawCycleInstance, field: 'cycleType')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boCustomerWithdrawCycle.cycleTimes.label"/>：</td>
        <td class="${hasErrors(bean: boCustomerWithdrawCycleInstance, field: 'cycleTimes', 'errors')}"><g:textField name="cycleTimes" value="${fieldValue(bean: boCustomerWithdrawCycleInstance, field: 'cycleTimes')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boCustomerWithdrawCycle.cycleExpr.label"/>：</td>
        <td class="${hasErrors(bean: boCustomerWithdrawCycleInstance, field: 'cycleExpr', 'errors')}"><g:textField name="cycleExpr" maxlength="100" value="${boCustomerWithdrawCycleInstance?.cycleExpr}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boCustomerWithdrawCycle.holidayWithdraw.label"/>：</td>
        <td class="${hasErrors(bean: boCustomerWithdrawCycleInstance, field: 'holidayWithdraw', 'errors')}"><g:textField name="holidayWithdraw" value="${fieldValue(bean: boCustomerWithdrawCycleInstance, field: 'holidayWithdraw')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boCustomerWithdrawCycle.amountType.label"/>：</td>
        <td class="${hasErrors(bean: boCustomerWithdrawCycleInstance, field: 'amountType', 'errors')}"><g:textField name="amountType" value="${fieldValue(bean: boCustomerWithdrawCycleInstance, field: 'amountType')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boCustomerWithdrawCycle.keepAmount.label"/>：</td>
        <td class="${hasErrors(bean: boCustomerWithdrawCycleInstance, field: 'keepAmount', 'errors')}"><g:textField name="keepAmount" value="${fieldValue(bean: boCustomerWithdrawCycleInstance, field: 'keepAmount')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boCustomerWithdrawCycle.lastFootDate.label"/>：</td>
        <td class="${hasErrors(bean: boCustomerWithdrawCycleInstance, field: 'lastFootDate', 'errors')}"><bo:datePicker name="lastFootDate" precision="day" value="${boCustomerWithdrawCycleInstance?.lastFootDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boCustomerWithdrawCycle.nextFootDate.label"/>：</td>
        <td class="${hasErrors(bean: boCustomerWithdrawCycleInstance, field: 'nextFootDate', 'errors')}"><bo:datePicker name="nextFootDate" precision="day" value="${boCustomerWithdrawCycleInstance?.nextFootDate}" /></td>
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
