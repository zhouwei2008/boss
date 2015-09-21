
<%@ page import="boss.BoAgentPayServiceParams" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boAgentPayServiceParams.label', default: '代收代付服务参数')}"/>
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
          <g:hiddenField name="id" value="${id}"/>
          <g:hiddenField name="total" value="${boAgentPayServiceParamsInstanceTotal}"/>
        <g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'boAgentPayServiceParams.id.label', default: 'Id')}"/>
        <g:sortableColumn params="${params}"  property="gatherWay" title="${message(code: 'boAgentPayServiceParams.gatherWay.label', default: '收费方式')}"/>
        <g:sortableColumn params="${params}"  property="settWay" title="${message(code: 'boAgentPayServiceParams.settWay.label', default: '结算方式')}"/>
      </tr>

      <g:each in="${boAgentPayServiceParamsInstanceList}" status="i" var="boAgentPayServiceParamsInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td><g:link action="show" id="${boAgentPayServiceParamsInstance.id}">${fieldValue(bean: boAgentPayServiceParamsInstance, field: "id")}</g:link></td>
          <td>按笔收费</td>
          <td>后返</td>
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
      <g:paginat total="${boAgentPayServiceParamsInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
