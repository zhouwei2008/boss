<%@ page import="ismp.AcquireAccountTrade" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireAccountTrade.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireAccountTradeInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireAccountTrade.acquirerAccountId.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireAccountTradeInstance, field: "acquirerAccountId")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireAccountTrade.amount.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireAccountTradeInstance, field: "amount")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireAccountTrade.currency.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireAccountTradeInstance, field: "currency")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireAccountTrade.dateCreated.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${acquireAccountTradeInstance?.dateCreated}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireAccountTrade.outTradeNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireAccountTradeInstance, field: "outTradeNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireAccountTrade.outTradeOrderNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireAccountTradeInstance, field: "outTradeOrderNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireAccountTrade.refundAmount.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireAccountTradeInstance, field: "refundAmount")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireAccountTrade.status.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireAccountTradeInstance, field: "status")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireAccountTrade.tradeDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireAccountTradeInstance, field: "tradeDate")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireAccountTrade.tradePayTime.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${acquireAccountTradeInstance?.tradePayTime}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireAccountTrade.withdrawStatus.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireAccountTradeInstance, field: "withdrawStatus")}</span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${acquireAccountTradeInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>
          <span class="button"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>