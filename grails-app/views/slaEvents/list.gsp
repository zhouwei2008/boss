
<%@ page import="ismp.SlaEvents" %>
%{--<%@ page import="ismp.TradeBase; ismp.TradeBase4Query; boss.BoOperator" %>--}%
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'slaEvents.label', default: 'slaEvents')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>

</head>

<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
    <h2>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        
        <g:sortableColumn params="${params}" property="createdate" title="${message(code: 'slaEvents.createdate.label')}"/>
        <g:sortableColumn params="${params}" property="createor" title="${message(code: 'slaEvents.createor.label')}"/>
        <g:sortableColumn params="${params}" property="meslever" title="${message(code: 'slaEvents.meslever.label')}"/>
        <g:sortableColumn params="${params}" property="eventtype" title="${message(code: 'slaEvents.eventtype.label')}"/>
        <g:sortableColumn params="${params}" property="mescontent" title="${message(code: 'slaEvents.mescontent.label')}"/>
        <g:sortableColumn params="${params}" property="status" title="${message(code: 'slaEvents.status.label')}"/>
        <g:sortableColumn params="${params}" property="updated" title="${message(code: 'slaEvents.updated.label')}"/>
        <g:sortableColumn params="${params}" property="descs" title="${message(code: 'slaEvents.descs.label')}"/>
        <g:sortableColumn params="${params}" property="prdsrc" title="${message(code: 'slaEvents.prdsrc.label')}"/>
        <g:sortableColumn params="${params}" property="features" title="${message(code: 'slaEvents.features.label')}"/>
      </tr>

      <g:each in="${result}" status="i" var="event">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td><g:formatDate date="${event.createdate}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td>${fieldValue(bean: event, field: "createor")}</td>
          <td>${fieldValue(bean: event, field: "meslever")}</td>
          <td>${event?.eventtype?.name}</td>
          <td>${fieldValue(bean: event, field: "mescontent")}</td>
          <td>${SlaEvents.statusMap[event?.status]}</td>
          <td><g:formatDate date="${event.updated}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td>${fieldValue(bean: event, field: "descs")}</td>
          <td>${fieldValue(bean: event, field: "prdsrc")}</td>
          <td>${fieldValue(bean: event, field: "features")}</td>
        </tr>
      </g:each>
    </table>
    <div class="paginateButtons">
      <span style=" float:left;">共${total}条记录</span>
      <g:paginat total="${total}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
