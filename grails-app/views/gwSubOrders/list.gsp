
<%@ page import="gateway.GwSubOrders" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'gwSubOrders.label', default: 'GwSubOrders')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>

    <table align="center" class="right_list_table" id="test">
      <tr>
        <th>${message(code: 'gwSubOrders.id.label', default: 'Id')}</th>
        <th>${message(code: 'gwSubOrders.gwordersid.label', default: 'Gwordersid')}</th>
        <th>${message(code: 'gwSubOrders.outtradeno.label', default: 'Outtradeno')}</th>
        <th>${message(code: 'gwSubOrders.seller_name.label', default: 'Sellername')}</th>
        <th>${message(code: 'gwSubOrders.seller_custno.label', default: 'Sellercustno')}</th>
        <th>${message(code: 'gwSubOrders.seller_code.label', default: 'Sellercode')}</th>
      </tr>

      <g:each in="${gwSubOrdersInstanceList}" status="i" var="gwSubOrdersInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          
          <td>${fieldValue(bean: gwSubOrdersInstance, field: "id")}</td>
          
          <td>${fieldValue(bean: gwSubOrdersInstance, field: "gwordersid")}</td>
          
          <td>${fieldValue(bean: gwSubOrdersInstance, field: "outtradeno")}</td>
          
          <td>${fieldValue(bean: gwSubOrdersInstance, field: "seller_name")}</td>
          
          <td>${fieldValue(bean: gwSubOrdersInstance, field: "seller_custno")}</td>
          
          <td>${fieldValue(bean: gwSubOrdersInstance, field: "seller_code")}</td>
          
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
        <span style=" float:left;">共${gwSubOrdersInstanceTotal}条记录</span>
      <g:paginat total="${gwSubOrdersInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
