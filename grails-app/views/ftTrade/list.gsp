
<%@ page import="settle.FtTrade" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'ftTrade.label', default: 'FtTrade')}"/>
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
        
        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'ftTrade.id.label', default: 'Id')}"/>
        
        <g:sortableColumn params="${params}"  property="srvCode" title="${message(code: 'ftTrade.srvCode.label', default: 'Srv Code')}"/>
        
        <g:sortableColumn params="${params}"  property="tradeCode" title="${message(code: 'ftTrade.tradeCode.label', default: 'Trade Code')}"/>
        
        <g:sortableColumn params="${params}"  property="customerNo" title="${message(code: 'ftTrade.customerNo.label', default: 'Customer No')}"/>
        
        <g:sortableColumn params="${params}"  property="seqNo" title="${message(code: 'ftTrade.seqNo.label', default: 'Seq No')}"/>
        
        <g:sortableColumn params="${params}"  property="tradeDate" title="${message(code: 'ftTrade.tradeDate.label', default: 'Trade Date')}"/>
        
      </tr>

      <g:each in="${ftTradeInstanceList}" status="i" var="ftTradeInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          
          <td><g:link action="show" id="${ftTradeInstance.id}">${fieldValue(bean: ftTradeInstance, field: "id")}</g:link></td>
          
          <td>${fieldValue(bean: ftTradeInstance, field: "srvCode")}</td>
          
          <td>${fieldValue(bean: ftTradeInstance, field: "tradeCode")}</td>
          
          <td>${fieldValue(bean: ftTradeInstance, field: "customerNo")}</td>
          
          <td>${fieldValue(bean: ftTradeInstance, field: "seqNo")}</td>
          
          <td><g:formatDate date="${ftTradeInstance.tradeDate}"/></td>
          
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
      <g:paginat total="${ftTradeInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
