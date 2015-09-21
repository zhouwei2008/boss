<%@ page import="boss.BoRechargeTime" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boRechargeTime.label', default: 'boRechargeTime')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>

</head>
<body style="overflow-x:hidden">
 <script type="text/javascript">
      function dosubmit(){

          var  startHour=   document.getElementById("startHour").value;
          var startMin =    document.getElementById("startMin").value;
          var endHour =    document.getElementById("endHour").value;
          var endMin=   document.getElementById("endMin").value;

          if(startHour>endHour||(startHour==endHour&&startMin>endMin)){
               alert("开始时间不能大于结束时间");
               document.getElementById("endHour").focus();
               return
          }

        if(confirm("确定提交?")){
           document.forms[0].submit();
        }
      }
    </script>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <g:hasErrors bean="${boRechargeTime}">
    <div class="errors">
      <g:renderErrors bean="${boRechargeTime}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boRechargeTime.startTime.label"/>：</td>
        <td class="${hasErrors(bean: boRechargeTime, field: 'startTime', 'errors')}">
                <p><g:select name="startHour" from="${BoRechargeTime.hourMap}" value="${params.startHour}" optionKey="key" optionValue="value" class="left_top_h2_input"/>
                   <g:select name="startMin" from="${BoRechargeTime.minsMap}" value="${params.startMin}" optionKey="key" optionValue="value" class="left_top_h2_input"/></p>
        </td>
      </tr>
        <tr>
        <td class="right label_name"><g:message code="boRechargeTime.endTime.label"/>：</td>
        <td class="${hasErrors(bean: boRechargeTime, field: 'endTime', 'errors')}">
            <p><g:select name="endHour" from="${BoRechargeTime.hourMap}" value="${params.endHour}" optionKey="key" optionValue="value" class="left_top_h2_input"/>
               <g:select name="endMin" from="${BoRechargeTime.minsMap}" value="${params.endMin}" optionKey="key" optionValue="value" class="left_top_h2_input"/></p>
        </td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boRechargeTime.status.label"/>：</td>
         <td class="${hasErrors(bean: boRechargeTime, field: 'status', 'errors')}"><g:select name="status" from="${BoRechargeTime.statusMap}" value="${params.status}" optionKey="key" optionValue="value"/></td>
      </tr>
      
      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="button" name="button" id="button" class="rigt_button" value="确定" onclick="dosubmit()"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
</body>
</html>
