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
  <g:hasErrors bean="${boRevocationApplyInstance}">
    <div class="errors">
      <g:renderErrors bean="${boRevocationApplyInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boRevocationApply.account.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'accountNo', 'errors')}">
            ${boRevocationApplyInstance?.accountNo}<g:hiddenField name="accountNo" maxlength="20" value="${boRevocationApplyInstance?.accountNo}"/>
             <g:hiddenField name="id" maxlength="20" value="${boRevocationApplyInstance?.id}"/>

        </td>
      </tr>
        <tr>
        <td class="right label_name"><g:message code="boRevocationApply.billmode.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'billmode', 'errors')}">
                   <g:if test="${boRevocationApplyInstance?.billmode=='cashier'}">现金<g:hiddenField name="billmode" maxlength="20" value="${boRevocationApplyInstance?.billmode}"/></g:if>
                        <g:if test="${boRevocationApplyInstance?.billmode=='check'}">支票<g:hiddenField name="billmode" maxlength="20" value="${boRevocationApplyInstance?.billmode}"/></g:if>
                        <g:if test="${boRevocationApplyInstance?.billmode=='transfer'}">转账<g:hiddenField name="billmode" maxlength="20" value="${boRevocationApplyInstance?.billmode}"/></g:if>
                        <g:if test="${boRevocationApplyInstance?.billmode=='other'}">其他<g:hiddenField name="billmode" maxlength="20" value="${boRevocationApplyInstance?.billmode}"/></g:if>
        </td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boRevocationApply.amount.label"/>：</td>
         <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'amount', 'errors')}">

             <g:formatNumber number="${boRevocationApplyInstance?.amount/100}" type="currency" currencyCode="CNY"/><g:hiddenField name="amount" maxlength="20" value="${boRevocationApplyInstance?.amount}"/>

         </td>
      </tr>

        <tr>
        <td class="right label_name"><g:message code="boRevocationApply.trxsqe.label"/>：</td>
            <td>
                ${boRevocationApplyInstance?.trxSeq}<g:hiddenField name="recepit" maxlength="20" value="${boRevocationApplyInstance?.trxSeq}"/>
            </td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boRevocationApply.realamount.label"/>：</td>
          <td>
               <g:formatNumber number="${boRevocationApplyInstance?.realamount/100}" type="currency" currencyCode="CNY"/><g:hiddenField name="realamount" maxlength="20" value="${boRevocationApplyInstance?.realamount}"/>
          </td>
      </tr>

          <tr>
        <td class="right label_name"><g:message code="boRevocationApply.note.label"/>：</td>
          <td>
                ${boRevocationApplyInstance?.note}<g:hiddenField name="note" maxlength="20" value="${boRevocationApplyInstance?.note}"/>
              <g:hiddenField name="accountName" maxlength="20" value="${boRevocationApplyInstance?.accountName}"/>
          </td>
      </tr>
      
      <tr>
        <td colspan="2" align="center">
            <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="撤销"></span>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>

        </td>
      </tr>
    </table>

  </g:form>
</div>
</body>
</html>
