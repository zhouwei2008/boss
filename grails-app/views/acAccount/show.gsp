
<%@ page import="account.AcAccount" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acAccount.label', default: 'AcAccount')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>

  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acAccount.accountNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acAccountInstance, field: "accountNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acAccount.accountName.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acAccountInstance, field: "accountName")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acAccount.balanceOfDirection.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${AcAccount.dirMap[acAccountInstance?.balanceOfDirection]}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acAccount.balance.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatNumber number="${acAccountInstance?.balance/100}" type="currency" currencyCode="CNY"/></span></td>
      
    </tr>

    <tr>
      <td class="right label_name">冻结金额：</td>

      <td><span class="rigt_tebl_font"><g:formatNumber number="${freezeBalance/100}" type="currency" currencyCode="CNY"/></span></td>

    </tr>

    <tr>
      <td class="right label_name"><g:message code="acAccount.currency.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acAccountInstance, field: "currency")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acAccount.status.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${AcAccount.statusMap[acAccountInstance?.status]}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acAccount.dateCreated.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${acAccountInstance?.dateCreated}" format="yyyy-MM-dd"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acAccount.lastUpdated.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${acAccountInstance?.lastUpdated}" format="yyyy-MM-dd"/></span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
          <g:form>
          <g:hiddenField name="id" value="${acAccountInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>
          </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>