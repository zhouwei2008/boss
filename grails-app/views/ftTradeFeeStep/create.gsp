

<%@ page import="settle.FtTradeFeeStep" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'ftTradeFeeStep.label', default: 'FtTradeFeeStep')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${ftTradeFeeStepInstance}">
    <div class="errors">
      <g:renderErrors bean="${ftTradeFeeStepInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.customerNo.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'customerNo', 'errors')}"><g:textField name="customerNo" maxlength="24" value="${ftTradeFeeStepInstance?.customerNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.tradeWeight.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'tradeWeight', 'errors')}"><g:textField name="tradeWeight" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'tradeWeight')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.fetchType.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'fetchType', 'errors')}"><g:textField name="fetchType" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'fetchType')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.feeType.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'feeType', 'errors')}"><g:textField name="feeType" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'feeType')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.feeValue.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'feeValue', 'errors')}"><g:textField name="feeValue" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'feeValue')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step1From.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step1From', 'errors')}"><g:textField name="step1From" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step1From')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step1To.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step1To', 'errors')}"><g:textField name="step1To" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step1To')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step1FeeType.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step1FeeType', 'errors')}"><g:textField name="step1FeeType" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step1FeeType')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step1FeeValue.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step1FeeValue', 'errors')}"><g:textField name="step1FeeValue" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step1FeeValue')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step1FeeMin.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step1FeeMin', 'errors')}"><g:textField name="step1FeeMin" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step1FeeMin')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step1FeeMax.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step1FeeMax', 'errors')}"><g:textField name="step1FeeMax" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step1FeeMax')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step2From.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step2From', 'errors')}"><g:textField name="step2From" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step2From')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step2To.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step2To', 'errors')}"><g:textField name="step2To" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step2To')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step2FeeType.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step2FeeType', 'errors')}"><g:textField name="step2FeeType" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step2FeeType')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step2FeeValue.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step2FeeValue', 'errors')}"><g:textField name="step2FeeValue" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step2FeeValue')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step2FeeMin.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step2FeeMin', 'errors')}"><g:textField name="step2FeeMin" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step2FeeMin')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step2FeeMax.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step2FeeMax', 'errors')}"><g:textField name="step2FeeMax" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step2FeeMax')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step3From.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step3From', 'errors')}"><g:textField name="step3From" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step3From')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step3To.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step3To', 'errors')}"><g:textField name="step3To" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step3To')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step3FeeType.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step3FeeType', 'errors')}"><g:textField name="step3FeeType" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step3FeeType')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step3FeeValue.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step3FeeValue', 'errors')}"><g:textField name="step3FeeValue" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step3FeeValue')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step3FeeMin.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step3FeeMin', 'errors')}"><g:textField name="step3FeeMin" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step3FeeMin')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step3FeeMax.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step3FeeMax', 'errors')}"><g:textField name="step3FeeMax" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step3FeeMax')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step4From.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step4From', 'errors')}"><g:textField name="step4From" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step4From')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step4To.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step4To', 'errors')}"><g:textField name="step4To" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step4To')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step4FeeType.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step4FeeType', 'errors')}"><g:textField name="step4FeeType" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step4FeeType')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step4FeeValue.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step4FeeValue', 'errors')}"><g:textField name="step4FeeValue" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step4FeeValue')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step4FeeMin.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step4FeeMin', 'errors')}"><g:textField name="step4FeeMin" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step4FeeMin')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step4FeeMax.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step4FeeMax', 'errors')}"><g:textField name="step4FeeMax" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step4FeeMax')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step5From.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step5From', 'errors')}"><g:textField name="step5From" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step5From')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step5To.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step5To', 'errors')}"><g:textField name="step5To" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step5To')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step5FeeType.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step5FeeType', 'errors')}"><g:textField name="step5FeeType" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step5FeeType')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step5FeeValue.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step5FeeValue', 'errors')}"><g:textField name="step5FeeValue" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step5FeeValue')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step5FeeMin.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step5FeeMin', 'errors')}"><g:textField name="step5FeeMin" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step5FeeMin')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.step5FeeMax.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'step5FeeMax', 'errors')}"><g:textField name="step5FeeMax" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'step5FeeMax')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.category.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'category', 'errors')}"><g:textField name="category" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'category')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.channelCode.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'channelCode', 'errors')}"><g:textField name="channelCode" value="${ftTradeFeeStepInstance?.channelCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.dateBegin.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'dateBegin', 'errors')}"><bo:datePicker name="dateBegin" precision="day" value="${ftTradeFeeStepInstance?.dateBegin}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.dateEnd.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'dateEnd', 'errors')}"><bo:datePicker name="dateEnd" precision="day" value="${ftTradeFeeStepInstance?.dateEnd}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.feeMax.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'feeMax', 'errors')}"><g:textField name="feeMax" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'feeMax')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.feeMin.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'feeMin', 'errors')}"><g:textField name="feeMin" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'feeMin')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.firstLiqDate.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'firstLiqDate', 'errors')}"><bo:datePicker name="firstLiqDate" precision="day" value="${ftTradeFeeStepInstance?.firstLiqDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.packLen.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'packLen', 'errors')}"><g:textField name="packLen" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'packLen')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.packType.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'packType', 'errors')}"><g:textField name="packType" value="${fieldValue(bean: ftTradeFeeStepInstance, field: 'packType')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.srv.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'srv', 'errors')}"><g:select name="srv.id" from="${settle.FtSrvType.list()}" optionKey="id" value="${ftTradeFeeStepInstance?.srv?.id}"  /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="ftTradeFeeStep.tradeType.label"/>：</td>
        <td class="${hasErrors(bean: ftTradeFeeStepInstance, field: 'tradeType', 'errors')}"><g:select name="tradeType.id" from="${settle.FtSrvTradeType.list()}" optionKey="id" value="${ftTradeFeeStepInstance?.tradeType?.id}"  /></td>
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
