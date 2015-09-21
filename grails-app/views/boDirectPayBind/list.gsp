
<%@ page import="ismp.CmCustomer; boss.BoDirectPayBind" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boDirectPayBind.label', default: 'BoDirectPayBind')}"/>
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
          <g:hiddenField name="customerNo"/>
          <g:hiddenField name="pCustomerNo" value="${customerNo}"/>
          <g:hiddenField name="pAccountNo" value="${accountNo}"/>
        <g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}" />
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'boDirectPayBind.id.label', args:[entityName])}"/>
        <g:sortableColumn params="${params}"  property="accountNo" title="${message(code: 'boDirectPayBind.accountNo.label', args:[entityName])}"/>
        <g:sortableColumn params="${params}"  property="customerNo" title="${message(code: 'boDirectPayBind.customerNo.label', args:[entityName])}"/>
        <th>商户名称</th>
        %{--<g:sortableColumn params="${params}"  property="limiteAmount" title="限额（元）"/>--}%
      </tr>
      <g:each in="${boDirectPayBindInstanceList}" status="i" var="boDirectPayBindInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td>
            <g:link action="show" id="${boDirectPayBindInstance.id}">
                <g:if test="${params?.int('offset')>=0}">${params?.int('offset') + i + 1}</g:if>
                <g:else>${i + 1}</g:else>
            </g:link>
          </td>
          <td>${fieldValue(bean: boDirectPayBindInstance, field: "accountNo")}</td>
          <td>${fieldValue(bean: boDirectPayBindInstance, field: "customerNo")}</td>
          <td>${CmCustomer.findByCustomerNo(boDirectPayBindInstance.customerNo).name}</td>
          %{--<td>${fieldValue(bean: boDirectPayBindInstance, field: "limiteAmount")}</td>--}%
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
      <g:paginate total="${boDirectPayBindInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
