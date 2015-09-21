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
    function dosubmit(stu){

        var status = document.getElementById("status").value;
        var datecode = document.getElementById("dateCode").value;
        var  hour =   document.getElementById("hour").value;
        var  mits =   document.getElementById("mits").value;
         var  allowHour =   document.getElementById("allowHour").value;
        var  allowMits =   document.getElementById("allowMits").value;
        var str;
        if(datecode=='startTime'){         //开始时间，hour是结束时间
            if(allowHour>hour||(allowHour==hour&&allowMits>mits)){
               alert("开始时间不能大于结束时间");
               document.getElementById("allowHour").focus();
               return
           }
        }else{                        //开始时间，hour是开始时间
             if(hour>allowHour||(hour==allowHour&&mits>allowMits)){
               alert("结束时间不能小于开始时间");
               document.getElementById("allowHour").focus();
               return
           }
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

  <g:form action="editSave" >
      <g:hiddenField name="branchCode" value="${boRechargeTime.branchCode}"></g:hiddenField>
      <g:hiddenField name="branchName" value="${boRechargeTime.branchName}"></g:hiddenField>
      <g:hiddenField name="dateCode" value="${boRechargeTime.dateCode}"></g:hiddenField>
      <g:hiddenField name="id" value="${boRechargeTime.id}"></g:hiddenField>
      <g:hiddenField name="allowdate" value="${boRechargeTime.allowdate}"></g:hiddenField>

      <g:hiddenField name="hour" value="${boRechargeTimeForEnd.allowHour}"></g:hiddenField>
      <g:hiddenField name="mits" value="${boRechargeTimeForEnd.allowMits}"></g:hiddenField>
      <g:hiddenField name="endID" value="${boRechargeTimeForEnd.id}"></g:hiddenField>
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      <g:if test="${boRechargeTimeForEnd?.dateCode=='endTime'}" >
      <tr>
        <td class="right label_name"><g:if test="${boRechargeTime?.dateCode=='startTime'}" ><g:message code="boRechargeTime.startTime.label"/></g:if><g:if test="${boRechargeTime?.dateCode=='endTime'}" ><g:message code="boRechargeTime.endTime.label"/></g:if>：</td>
        <td class="${hasErrors(bean: boRechargeTime, field: 'time', 'errors')}">
              <p><g:select name="allowHour" from="${BoRechargeTime.hourMap}" value="${boRechargeTime.allowHour}" optionKey="key" optionValue="value" class="left_top_h2_input"/>：
                 <g:select name="allowMits" from="${BoRechargeTime.minsMap}" value="${boRechargeTime.allowMits}" optionKey="key" optionValue="value" class="left_top_h2_input"/></p>
        </td>
      </tr>
         <tr>
        <td class="right label_name"><g:if test="${boRechargeTimeForEnd?.dateCode=='startTime'}" ><g:message code="boRechargeTime.startTime.label"/></g:if><g:if test="${boRechargeTimeForEnd?.dateCode=='endTime'}" ><g:message code="boRechargeTime.endTime.label"/></g:if>：</td>
        <td class="${hasErrors(bean: boRechargeTime, field: 'time', 'errors')}">
            <p><g:select name="seltime" from="${BoRechargeTime.hourMap}" value="${boRechargeTimeForEnd.allowHour}" optionKey="key" optionValue="value" class="left_top_h2_input" disabled="true"/>：
                 <g:select name="selmits" from="${BoRechargeTime.minsMap}" value="${boRechargeTimeForEnd.allowMits}" optionKey="key" optionValue="value" class="left_top_h2_input" disabled="true"/></p>
        </td>
      </tr>
       </g:if>
         <g:if test="${boRechargeTimeForEnd?.dateCode=='startTime'}" >
      <tr>
        <td class="right label_name"><g:if test="${boRechargeTimeForEnd?.dateCode=='startTime'}" ><g:message code="boRechargeTime.startTime.label"/></g:if><g:if test="${boRechargeTimeForEnd?.dateCode=='endTime'}" ><g:message code="boRechargeTime.endTime.label"/></g:if>：</td>
        <td class="${hasErrors(bean: boRechargeTime, field: 'time', 'errors')}">
            <p><g:select name="seltime" from="${BoRechargeTime.hourMap}" value="${boRechargeTimeForEnd.allowHour}" optionKey="key" optionValue="value" class="left_top_h2_input" disabled="true"/>：
                 <g:select name="selmits" from="${BoRechargeTime.minsMap}" value="${boRechargeTimeForEnd.allowMits}" optionKey="key" optionValue="value" class="left_top_h2_input" disabled="true"/></p>
        </td>
      </tr>
      <tr>
        <td class="right label_name"><g:if test="${boRechargeTime?.dateCode=='startTime'}" ><g:message code="boRechargeTime.startTime.label"/></g:if><g:if test="${boRechargeTime?.dateCode=='endTime'}" ><g:message code="boRechargeTime.endTime.label"/></g:if>：</td>
        <td class="${hasErrors(bean: boRechargeTime, field: 'time', 'errors')}">
              <p><g:select name="allowHour" from="${BoRechargeTime.hourMap}" value="${boRechargeTime.allowHour}" optionKey="key" optionValue="value" class="left_top_h2_input"/>：
                 <g:select name="allowMits" from="${BoRechargeTime.minsMap}" value="${boRechargeTime.allowMits}" optionKey="key" optionValue="value" class="left_top_h2_input"/></p>
        </td>
      </tr>
       </g:if>
      <tr>
        <td class="right label_name"><g:message code="boRechargeTime.status.label"/>：</td>
         <td class="${hasErrors(bean: boRechargeTime, field: 'status', 'errors')}"><g:select name="status" from="${BoRechargeTime.statusMap}" value="${boRechargeTime.status}" optionKey="key" optionValue="value"/></td>
      </tr>
      
      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="button" name="button" id="button" class="rigt_button" value="确定" onclick="dosubmit('${boRechargeTime.status}')"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
</body>
</html>
