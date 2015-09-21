

<%@ page import="boss.BoRefundModel" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boRefundModel.label', default: 'BoRefundModel')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boRefundModelInstance}">
    <div class="errors">
      <g:renderErrors bean="${boRefundModelInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.customerId.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'customerId', 'errors')}"><g:textField name="customerId" value="${fieldValue(bean: boRefundModelInstance, field: 'customerId')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.contractNo.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'contractNo', 'errors')}"><g:textField name="contractNo" maxlength="20" value="${boRefundModelInstance?.contractNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.serviceCode.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'serviceCode', 'errors')}"><g:textField name="serviceCode" maxlength="20" value="${boRefundModelInstance?.serviceCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.startTime.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'startTime', 'errors')}"><bo:datePicker name="startTime" precision="day" value="${boRefundModelInstance?.startTime}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.endTime.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'endTime', 'errors')}"><bo:datePicker name="endTime" precision="day" value="${boRefundModelInstance?.endTime}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.feeParams.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'feeParams', 'errors')}"><g:textField name="feeParams" maxlength="64" value="${boRefundModelInstance?.feeParams}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.serviceParams.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'serviceParams', 'errors')}"><g:textArea name="serviceParams" cols="40" rows="5" value="${boRefundModelInstance?.serviceParams}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.isCurrent.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'isCurrent', 'errors')}"><g:checkBox name="isCurrent" value="${boRefundModelInstance?.isCurrent}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.enable.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'enable', 'errors')}"><g:checkBox name="enable" value="${boRefundModelInstance?.enable}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.customerManagerOperatorId.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'customerManagerOperatorId', 'errors')}"><g:textField name="customerManagerOperatorId" value="${fieldValue(bean: boRefundModelInstance, field: 'customerManagerOperatorId')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.checkStatus.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'checkStatus', 'errors')}"><g:textField name="checkStatus" value="${boRefundModelInstance?.checkStatus}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.checkDate.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'checkDate', 'errors')}"><bo:datePicker name="checkDate" precision="day" value="${boRefundModelInstance?.checkDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.checkOperatorId.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'checkOperatorId', 'errors')}"><g:textField name="checkOperatorId" value="${fieldValue(bean: boRefundModelInstance, field: 'checkOperatorId')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.srvAccNo.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'srvAccNo', 'errors')}"><g:textField name="srvAccNo" value="${boRefundModelInstance?.srvAccNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.feeAccNo.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'feeAccNo', 'errors')}"><g:textField name="feeAccNo" value="${boRefundModelInstance?.feeAccNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.belongToSale.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'belongToSale', 'errors')}"><g:textField name="belongToSale" maxlength="20" value="${boRefundModelInstance?.belongToSale}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.refundModel.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'refundModel', 'errors')}"><g:select name="refundModel" from="${boRefundModelInstance.constraints.refundModel.inList}" value="${boRefundModelInstance?.refundModel}" valueMessagePrefix="boRefundModel.refundModel"  /></td>
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
