<%@ page import="boss.BoBalanceAccountDateRule" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boBalanceAccountDateRule.label', default: 'BoBalanceAccountDateRule')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
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

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boBalanceAccountDateRule.bank.label"/>：</td>
        <td class="${hasErrors(bean: boBalanceAccountDateRuleInstance, field: 'bank', 'errors')}">
            <g:select name="bank.id" from="${banks}" optionKey="id" optionValue="name" value="${boBalanceAccountDateRuleInstance?.bank?.id}" noSelection="${['':'-请选择-']}" />
        </td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boBalanceAccountDateRule.settleDayTime.label"/>：</td>
        <td>
           <input id="settleDayTime" name="settleDayTime"  class='Wdate' type="text" onClick="WdatePicker({dateFmt:'HH:mm:ss'})" />
        </td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boBalanceAccountDateRule.acquireSynDayBeginTime.label"/>：</td>
        <td>
         <input id="acquireSynDayBeginTime" name="acquireSynDayBeginTime"  class='Wdate' type="text" onClick="WdatePicker({dateFmt:'HH:mm:ss',maxDate:'#F{$dp.$D(\'acquireSynDayEndTime\')}'})" />
        </td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boBalanceAccountDateRule.acquireSynDayEndTime.label"/>：</td>
        <td>
            <input id="acquireSynDayEndTime"  name="acquireSynDayEndTime" class='Wdate' type="text" onClick="WdatePicker({dateFmt:'HH:mm:ss',minDate:'#F{$dp.$D(\'acquireSynDayBeginTime\')}'})"/>
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
