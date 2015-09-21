<%@ page import="boss.BoBalanceAccountDateRule" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boBalanceAccountDateRule.label', default: 'BoBalanceAccountDateRule')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
    <g:javascript library="My97DatePicker/WdatePicker"/>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boBalanceAccountDateRuleInstance}">
    <div class="errors">
      <g:renderErrors bean="${boBalanceAccountDateRuleInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${boBalanceAccountDateRuleInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boBalanceAccountDateRule.bank.label"/>：</td>
        <td class="${hasErrors(bean: boBalanceAccountDateRuleInstance, field: 'bank', 'errors')}">
            ${boBalanceAccountDateRuleInstance?.bank?.name}
        </td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boBalanceAccountDateRule.settleDayTime.label"/>：</td>
        <td class="${hasErrors(bean: boBalanceAccountDateRuleInstance, field: 'settleDayTime', 'errors')}">
            <input id="settleDayTime" name="settleDayTime"  class='Wdate' type="text" onClick="WdatePicker({dateFmt:'HH:mm:ss'})" value="<g:formatDate date="${boBalanceAccountDateRuleInstance?.settleDayTime}" format="HH:mm:ss"/>"/>
        </td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boBalanceAccountDateRule.acquireSynDayBeginTime.label"/>：</td>
        <td class="${hasErrors(bean: boBalanceAccountDateRuleInstance, field: 'acquireSynDayBeginTime', 'errors')}">
             <input name="acquireSynDayBeginTime" id="acquireSynDayBeginTime" class='Wdate' type="text" onClick="WdatePicker({dateFmt:'HH:mm:ss',maxDate:'#F{$dp.$D(\'acquireSynDayEndTime\')}'})" value="<g:formatDate date="${boBalanceAccountDateRuleInstance?.acquireSynDayBeginTime}" format="HH:mm:ss"/>" />
        </td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boBalanceAccountDateRule.acquireSynDayEndTime.label"/>：</td>
        <td class="${hasErrors(bean: boBalanceAccountDateRuleInstance, field: 'acquireSynDayEndTime', 'errors')}">
            <input name="acquireSynDayEndTime" id="acquireSynDayEndTime" class='Wdate' type="text" onClick="WdatePicker({dateFmt:'HH:mm:ss',minDate:'#F{$dp.$D(\'acquireSynDayBeginTime\')}'})" value="<g:formatDate date="${boBalanceAccountDateRuleInstance?.acquireSynDayEndTime}" format="HH:mm:ss"/>" />
        </td>
      </tr>
      

      
      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
</body>
</html>
