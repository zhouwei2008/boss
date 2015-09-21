

<%@ page import="dsf.TbAgentpayDetailsInfo" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: 'TbAgentpayDetailsInfo')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${tbAgentpayDetailsInfoInstance}">
    <div class="errors">
      <g:renderErrors bean="${tbAgentpayDetailsInfoInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.batchId.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'batchId', 'errors')}"><g:textField name="batchId" maxlength="15" value="${tbAgentpayDetailsInfoInstance?.batchId}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeNum.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeNum', 'errors')}"><g:textField name="tradeNum" maxlength="6" value="${tbAgentpayDetailsInfoInstance?.tradeNum}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeBankcode.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeBankcode', 'errors')}"><g:textField name="tradeBankcode" maxlength="3" value="${tbAgentpayDetailsInfoInstance?.tradeBankcode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeCardtype.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeCardtype', 'errors')}"><g:textField name="tradeCardtype" maxlength="2" value="${tbAgentpayDetailsInfoInstance?.tradeCardtype}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeCardnum.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeCardnum', 'errors')}"><g:textField name="tradeCardnum" maxlength="32" value="${tbAgentpayDetailsInfoInstance?.tradeCardnum}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeCardname.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeCardname', 'errors')}"><g:textField name="tradeCardname" maxlength="50" value="${tbAgentpayDetailsInfoInstance?.tradeCardname}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeBranchbank.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeBranchbank', 'errors')}"><g:textField name="tradeBranchbank" maxlength="20" value="${tbAgentpayDetailsInfoInstance?.tradeBranchbank}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeSubbranchbank.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeSubbranchbank', 'errors')}"><g:textField name="tradeSubbranchbank" maxlength="20" value="${tbAgentpayDetailsInfoInstance?.tradeSubbranchbank}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeAccountname.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeAccountname', 'errors')}"><g:textField name="tradeAccountname" maxlength="50" value="${tbAgentpayDetailsInfoInstance?.tradeAccountname}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeAccounttype.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeAccounttype', 'errors')}"><g:textField name="tradeAccounttype" maxlength="1" value="${tbAgentpayDetailsInfoInstance?.tradeAccounttype}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeAmount.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeAmount', 'errors')}"><g:textField name="tradeAmount" maxlength="12" value="${tbAgentpayDetailsInfoInstance?.tradeAmount}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeAmounttype.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeAmounttype', 'errors')}"><g:textField name="tradeAmounttype" maxlength="3" value="${tbAgentpayDetailsInfoInstance?.tradeAmounttype}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.contractCode.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'contractCode', 'errors')}"><g:textField name="contractCode" maxlength="60" value="${tbAgentpayDetailsInfoInstance?.contractCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.contractUsercode.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'contractUsercode', 'errors')}"><g:textField name="contractUsercode" maxlength="30" value="${tbAgentpayDetailsInfoInstance?.contractUsercode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.certificateType.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'certificateType', 'errors')}"><g:textField name="certificateType" maxlength="1" value="${tbAgentpayDetailsInfoInstance?.certificateType}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.certificateNum.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'certificateNum', 'errors')}"><g:textField name="certificateNum" maxlength="22" value="${tbAgentpayDetailsInfoInstance?.certificateNum}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeMobile.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeMobile', 'errors')}"><g:textField name="tradeMobile" maxlength="13" value="${tbAgentpayDetailsInfoInstance?.tradeMobile}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeRemark.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeRemark', 'errors')}"><g:textField name="tradeRemark" maxlength="30" value="${tbAgentpayDetailsInfoInstance?.tradeRemark}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeFeedbackcode.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeFeedbackcode', 'errors')}"><g:textField name="tradeFeedbackcode" maxlength="4" value="${tbAgentpayDetailsInfoInstance?.tradeFeedbackcode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeReason.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeReason', 'errors')}"><g:textField name="tradeReason" maxlength="30" value="${tbAgentpayDetailsInfoInstance?.tradeReason}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeRemark1.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeRemark1', 'errors')}"><g:textField name="tradeRemark1" maxlength="30" value="${tbAgentpayDetailsInfoInstance?.tradeRemark1}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeRemark2.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeRemark2', 'errors')}"><g:textField name="tradeRemark2" maxlength="30" value="${tbAgentpayDetailsInfoInstance?.tradeRemark2}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeStatus.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeStatus', 'errors')}"><g:textField name="tradeStatus" maxlength="1" value="${tbAgentpayDetailsInfoInstance?.tradeStatus}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeHandcharge.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeHandcharge', 'errors')}"><g:textField name="tradeHandcharge" maxlength="9" value="${tbAgentpayDetailsInfoInstance?.tradeHandcharge}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeSysdate.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeSysdate', 'errors')}"><bo:datePicker name="tradeSysdate" precision="day" value="${tbAgentpayDetailsInfoInstance?.tradeSysdate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeDonedate.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeDonedate', 'errors')}"><bo:datePicker name="tradeDonedate" precision="day" value="${tbAgentpayDetailsInfoInstance?.tradeDonedate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.batchBizid.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'batchBizid', 'errors')}"><g:textField name="batchBizid" maxlength="12" value="${tbAgentpayDetailsInfoInstance?.batchBizid}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeFeestyle.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeFeestyle', 'errors')}"><g:textField name="tradeFeestyle" maxlength="1" value="${tbAgentpayDetailsInfoInstance?.tradeFeestyle}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeFeetype.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeFeetype', 'errors')}"><g:textField name="tradeFeetype" maxlength="1" value="${tbAgentpayDetailsInfoInstance?.tradeFeetype}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeAccamount.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'tradeAccamount', 'errors')}"><g:textField name="tradeAccamount" maxlength="12" value="${tbAgentpayDetailsInfoInstance?.tradeAccamount}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.payStatus.label"/>：</td>
        <td class="${hasErrors(bean: tbAgentpayDetailsInfoInstance, field: 'payStatus', 'errors')}"><g:textField name="payStatus" maxlength="1" value="${tbAgentpayDetailsInfoInstance?.payStatus}" /></td>
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
