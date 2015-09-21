
<%@ page import="ismp.AcquireAccountTrade" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
    <h2>
      <g:form>
        <g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        
        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'acquireAccountTrade.id.label', default: 'Id')}"/>
        
        <g:sortableColumn params="${params}"  property="acquirerAccountId" title="${message(code: 'acquireAccountTrade.acquirerAccountId.label', default: 'Acquirer Account Id')}"/>
        
        <g:sortableColumn params="${params}"  property="amount" title="${message(code: 'acquireAccountTrade.amount.label', default: 'Amount')}"/>
        
        <g:sortableColumn params="${params}"  property="currency" title="${message(code: 'acquireAccountTrade.currency.label', default: 'Currency')}"/>
        
        <g:sortableColumn params="${params}"  property="dateCreated" title="${message(code: 'acquireAccountTrade.dateCreated.label', default: 'Date Created')}"/>
        
        <g:sortableColumn params="${params}"  property="outTradeNo" title="${message(code: 'acquireAccountTrade.outTradeNo.label', default: 'Out Trade No')}"/>
        
      </tr>

      <g:each in="${acquireAccountTradeInstanceList}" status="i" var="acquireAccountTradeInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          
          <td><g:link action="show" id="${acquireAccountTradeInstance.id}">${fieldValue(bean: acquireAccountTradeInstance, field: "id")}</g:link></td>
          
          <td>${fieldValue(bean: acquireAccountTradeInstance, field: "acquirerAccountId")}</td>
          
          <td>${fieldValue(bean: acquireAccountTradeInstance, field: "amount")}</td>
          
          <td>${fieldValue(bean: acquireAccountTradeInstance, field: "currency")}</td>
          
          <td><g:formatDate date="${acquireAccountTradeInstance.dateCreated}"/></td>
          
          <td>${fieldValue(bean: acquireAccountTradeInstance, field: "outTradeNo")}</td>
          
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
      <g:paginat total="${acquireAccountTradeInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
