<%@ page import="boss.BoOfflineCharge; boss.BoRechargeTime" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boRevocationApply.label', default: 'boRevocationApply')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>

</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <g:hasErrors bean="${boOfflineChargeInstance}">
    <div class="errors">
      <g:renderErrors bean="${boOfflineChargeInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boRevocationApply.account.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'accountNo', 'errors')}">
            <g:textField name="accountNo" maxlength="20" value="${boOfflineChargeInstance?.accountNo}"/>
        </td>
      </tr>
        <tr>
        <td class="right label_name"><g:message code="boRevocationApply.billmode.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'billmode', 'errors')}">
             <g:select name="billmode" from="${BoOfflineCharge.billmodeMap}" value="${boOfflineChargeInstance.billmode}" optionKey="key" optionValue="value"/>
        </td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boRevocationApply.amount.label"/>：</td>
         <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'amount', 'errors')}">
             <g:textField name="amount" maxlength="20" value="${boOfflineChargeInstance?.amount}"/>
         </td>
      </tr>

        <tr>
        <td class="right label_name"><g:message code="boRevocationApply.trxsqe.label"/>：</td>
            <td>
                ${boOfflineChargeInstance?.trxSeq}<g:hiddenField name="trxSeq" maxlength="20" value="${boOfflineChargeInstance?.trxSeq}"/>
            </td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boRevocationApply.realamount.label"/>：</td>
          <td>
             <g:textField name="realamount" maxlength="20" value="${boOfflineChargeInstance?.realamount}"/>
          </td>
      </tr>

          <tr>
        <td class="right label_name"><g:message code="boRevocationApply.note.label"/>：</td>
          <td>
             <g:textArea name="note" maxlength="100" rows="5" cols="6" value="${boOfflineChargeInstance?.note}"/>
          </td>
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
