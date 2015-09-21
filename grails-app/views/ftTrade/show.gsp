
<%@ page import="settle.FtTrade" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'ftTrade.label', default: 'FtTrade')}"/>
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
      <td class="right label_name"><g:message code="ftTrade.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTrade.srvCode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeInstance, field: "srvCode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTrade.tradeCode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeInstance, field: "tradeCode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTrade.customerNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeInstance, field: "customerNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTrade.seqNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeInstance, field: "seqNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTrade.tradeDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${ftTradeInstance?.tradeDate}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTrade.liquidateNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeInstance, field: "liquidateNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTrade.amount.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeInstance, field: "amount")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTrade.billDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${ftTradeInstance?.billDate}"/></span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${ftTradeInstance?.id}"/>
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