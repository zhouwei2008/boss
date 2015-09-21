
<%@ page import="boss.Perm; settle.FtSrvTradeType" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'ftSrvTradeType.label', default: 'FtSrvTradeType')}"/>
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
        <bo:hasPerm perm="${Perm.Settle_TradeType_New}" ><g:actionSubmit class="right_top_h2_button_tj1" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/></bo:hasPerm>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        
        <g:sortableColumn params="${params}"  property="tradeCode" title="${message(code: 'ftSrvTradeType.tradeCode.label', default: 'Trade Code')}"/>
        
        <g:sortableColumn params="${params}"  property="tradeName" title="${message(code: 'ftSrvTradeType.tradeName.label', default: 'Trade Name')}"/>
        
        <g:sortableColumn params="${params}"  property="netWeight" title="${message(code: 'ftSrvTradeType.netWeight.label', default: 'Net Weight')}"/>
        
        <th><g:message code="ftSrvTradeType.srv.label" default="Srv"/></th>
        
      </tr>

      <g:each in="${ftSrvTradeTypeInstanceList}" status="i" var="ftSrvTradeTypeInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          
          <td><g:if test="${bo.hasPerm(perm:Perm.Settle_TradeType_View){true}}" ><g:link action="show" id="${ftSrvTradeTypeInstance.id}">${fieldValue(bean: ftSrvTradeTypeInstance, field: "tradeCode")}</g:link></g:if><g:else>${fieldValue(bean: ftSrvTradeTypeInstance, field: "tradeCode")}</g:else></td>
          
          <td>${fieldValue(bean: ftSrvTradeTypeInstance, field: "tradeName")}</td>
          
          <td>${FtSrvTradeType.netWeightMap[ftSrvTradeTypeInstance?.netWeight.toString()]}</td>
          
          <td>${ftSrvTradeTypeInstance?.srv.srvName}</td>
          
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
       <div align="left">  <div style="position:absolute;">共${ftSrvTradeTypeInstanceTotal}条记录</div></div>
      <g:paginat total="${ftSrvTradeTypeInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
