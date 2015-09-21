
<%@ page import="settle.FtTradeFeeStep" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'ftTradeFeeStep.label', default: 'FtTradeFeeStep')}"/>
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
        
        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'ftTradeFeeStep.id.label', default: 'Id')}"/>
        
        <g:sortableColumn params="${params}"  property="customerNo" title="${message(code: 'ftTradeFeeStep.customerNo.label', default: 'Customer No')}"/>
        
        <g:sortableColumn params="${params}"  property="tradeWeight" title="${message(code: 'ftTradeFeeStep.tradeWeight.label', default: 'Trade Weight')}"/>
        
        <g:sortableColumn params="${params}"  property="fetchType" title="${message(code: 'ftTradeFeeStep.fetchType.label', default: 'Fetch Type')}"/>
        
        <g:sortableColumn params="${params}"  property="feeType" title="${message(code: 'ftTradeFeeStep.feeType.label', default: 'Fee Type')}"/>
        
        <g:sortableColumn params="${params}"  property="feeValue" title="${message(code: 'ftTradeFeeStep.feeValue.label', default: 'Fee Value')}"/>
        
      </tr>

      <g:each in="${ftTradeFeeStepInstanceList}" status="i" var="ftTradeFeeStepInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          
          <td><g:link action="show" id="${ftTradeFeeStepInstance.id}">${fieldValue(bean: ftTradeFeeStepInstance, field: "id")}</g:link></td>
          
          <td>${fieldValue(bean: ftTradeFeeStepInstance, field: "customerNo")}</td>
          
          <td>${fieldValue(bean: ftTradeFeeStepInstance, field: "tradeWeight")}</td>
          
          <td>${fieldValue(bean: ftTradeFeeStepInstance, field: "fetchType")}</td>
          
          <td>${fieldValue(bean: ftTradeFeeStepInstance, field: "feeType")}</td>
          
          <td>${fieldValue(bean: ftTradeFeeStepInstance, field: "feeValue")}</td>
          
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
      <g:paginate total="${ftTradeFeeStepInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
