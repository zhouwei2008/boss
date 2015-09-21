

<%@ page import="boss.BoSecurityEvents" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boSecurityEvents.label', default: 'BoSecurity')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boSecurityEventsInstance}">
    <div class="errors">
      <g:renderErrors bean="${boSecurityEventsInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save">
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boSecurityEvents.boSort.label"/>：</td>
        <td class="${hasErrors(bean: boSecurityEventsInstance, field: 'boSort', 'errors')}">

             <g:select name="boSort" from="${boSecurityEventsInstance.boSortMap}" value="${boSecurityEventsInstance?.boSort}" optionKey="key" optionValue="value"/></td>
            %{--<g:select name="sort" from="${boSecurityEventsInstance.constraints.sort.inList}" value="${boSecurityEventsInstance?.sort}" valueMessagePrefix="boSecurityEvents.sort"  /></td>--}%
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boSecurityEvents.sketch.label"/>：</td>
        <td class="${hasErrors(bean: boSecurityEventsInstance, field: 'sketch', 'errors')}"><g:textArea name="sketch" rows="10" cols="16" maxlength="64" style="width: 303px; height: 48px;" value="${boSecurityEventsInstance?.sketch}" /></td>
      </tr>

      
      <tr>
        <td class="right label_name"><g:message  code="boSecurityEvents.startDateCreated.label"/>：</td>
        <td class="${hasErrors(bean: boSecurityEventsInstance, field: 'startDateCreated', 'errors')}">
            <bo:datePicker id="startDateCreated" name="startDateCreated" precision="day" value="${boSecurityEventsInstance?.startDateCreated}" />

        </td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boSecurityEvents.endDateCreated.label"/>：</td>
        <td class="${hasErrors(bean: boSecurityEventsInstance, field: 'endDateCreated', 'errors')}">
            <bo:datePicker id="endDateCreated" name="endDateCreated" precision="day" value="${boSecurityEventsInstance?.endDateCreated}" />
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boSecurityEvents.boStatus.label"/>：</td>
        <td class="${hasErrors(bean: boSecurityEventsInstance, field: 'boStatus', 'errors')}">
            <g:select name="boStatus" from="${boSecurityEventsInstance.boStatusMap}" value="${boSecurityEventsInstance?.boStatus}" optionKey="key" optionValue="value" />
      </tr>


      <tr>
        <td class="right label_name"><g:message code="boSecurityEvents.expatiate.label"/>：</td>
        <td class="${hasErrors(bean: boSecurityEventsInstance, field: 'expatiate', 'errors')}">
             <g:textArea name="expatiate"  cols="10" rows="15" style="width:550px ;high:15px" value="${boSecurityEventsInstance?.expatiate}"/> </td>

      </tr>

      
      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定" onclick="return checkDate()"></span>
        </td>
      </tr>
    </table>
  </g:form>
</div>
<script type="text/javascript">
    $(function() {
        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
    });
    function checkDate() {
        var startDate = $("#startDateCreated_year").val() + $("#startDateCreated_month").val() + $("#startDateCreated_day").val();
        var endDate = $("#endDateCreated_year").val() + $("#endDateCreated_month").val() + $("#endDateCreated_day").val();

        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            return false;
        }
    }
</script>
</body>
</html>
