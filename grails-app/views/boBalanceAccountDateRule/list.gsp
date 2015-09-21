
<%@ page import="boss.BoBankDic; boss.Perm;boss.BoBalanceAccountDateRule" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boBalanceAccountDateRule.label', default: 'BoBalanceAccountDateRule')}"/>
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

    </h2>
     <div class="table_serch">
            <table>
                <g:form>
                    <tr>
                    <td width=100><g:message code="boBalanceAccountDateRule.bank.label" default="Bank"/></td>
                    <td>
                        <g:select name="bankid" from="${BoBankDic.findAll()}" value="${params.bankid}" optionKey="id" optionValue="name" noSelection="${['':'全部']}"/>
                    </td>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询"/></td>
                       <td> <g:form>
        <g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/>
      </g:form>  </td>
                    </tr>
                %{--<g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载"/>--}%
                </g:form>
            </table>
      </div>
    <table align="center" class="right_list_table" id="test">
      <tr>
        
        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'boBalanceAccountDateRule.id.label', default: 'Id')}"/>
        
        <th><g:message code="boBalanceAccountDateRule.bank.label" default="Bank"/></th>
        <g:sortableColumn params="${params}"  property="settleDayTime" title="${message(code: 'boBalanceAccountDateRule.settleDayTime.label', default: 'Settle Day Time')}"/>

        <g:sortableColumn params="${params}"  property="acquireSynDayBeginTime" title="${message(code: 'boBalanceAccountDateRule.acquireSynDayBeginTime.label', default: 'Acquire Syn Day Begin Time')}"/>
        
        <g:sortableColumn params="${params}"  property="acquireSynDayEndTime" title="${message(code: 'boBalanceAccountDateRule.acquireSynDayEndTime.label', default: 'Acquire Syn Day End Time')}"/>

        <th>操作</th>
      </tr>

      <g:each in="${boBalanceAccountDateRuleInstanceList}" status="i" var="boBalanceAccountDateRuleInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          
          <td><g:link action="show" id="${boBalanceAccountDateRuleInstance.id}">${fieldValue(bean: boBalanceAccountDateRuleInstance, field: "id")}</g:link></td>
          
          <td>${boBalanceAccountDateRuleInstance?.bank?.name}</td>

          <td><g:formatDate date="${boBalanceAccountDateRuleInstance.settleDayTime}" format="HH:mm:ss"/></td>

          <td><g:formatDate date="${boBalanceAccountDateRuleInstance.acquireSynDayBeginTime}" format="HH:mm:ss"/></td>
          
          <td><g:formatDate date="${boBalanceAccountDateRuleInstance.acquireSynDayEndTime}" format="HH:mm:ss"/></td>
          
          <td><g:link action="edit" id="${boBalanceAccountDateRuleInstance.id}">修改</g:link></td>
          
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
       <span style=" float:left;">共${boBalanceAccountDateRuleInstanceTotal}条记录</span>
      <g:paginat total="${boBalanceAccountDateRuleInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
