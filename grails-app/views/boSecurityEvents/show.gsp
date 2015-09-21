
<%@ page import="boss.BoSecurityEvents" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boSecurityEvents.label', default: 'BoSecurity')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boSecurityEvents.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${boSecurityEventsInstance.id}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boSecurityEvents.boSort.label"/>：</td>


         <td><span class="rigt_tebl_font">${boSecurityEventsInstance.boSortMap[boSecurityEventsInstance?.boSort]}</span></td>
      %{--<td><span class="rigt_tebl_font">${fieldValue(bean: boSecurityEventsInstance, field: "sort")}</span></td>--}%
    </tr>
    
              <tr>
      <td class="right label_name"><g:message code="boSecurityEvents.sketch.label"/>：</td>

      <td><span class="rigt_tebl_font">${fieldValue(bean: boSecurityEventsInstance, field: "sketch")}</span></td>

    </tr>
    

    
    <tr>
      <td class="right label_name"><g:message code="boSecurityEvents.startDateCreated.label"/>：</td>

        <td><span class="rigt_tebl_font"><g:formatDate  date="${boSecurityEventsInstance.startDateCreated}" format="yyyy-MM-dd"/></span></td>
      
      %{--<td><span class="rigt_tebl_font"><g:formatDate date="${boSecurityEventsInstance?.startDateCreated}"/></span></td>--}%
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boSecurityEvents.endDateCreated.label"/>：</td>

         <td><span class="rigt_tebl_font"><g:formatDate  date="${boSecurityEventsInstance.endDateCreated}" format="yyyy-MM-dd"/></span></td>
      
      %{--<td><span class="rigt_tebl_font"><g:formatDate date="${boSecurityEventsInstance?.endDateCreated}"/></span></td>--}%
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boSecurityEvents.boStatus.label"/>：</td>

        <td><span class="rigt_tebl_font">${boSecurityEventsInstance.boStatusMap[boSecurityEventsInstance?.boStatus]}</span></td>

        %{--<td><span class="rigt_tebl_font">${fieldValue(bean: boSecurityEventsInstance, field: "status")}</span></td>--}%
      
      %{--<td><span class="rigt_tebl_font">${fieldValue(bean: boSecurityEventsInstance, field: "status")}</span></td>--}%
      
    </tr>


     <tr>
      <td class="right label_name"><g:message code="boSecurityEvents.expatiate.label"/>：</td>

        <td>  <g:textArea name="expatiate" rows="11" cols="20" value="${boSecurityEventsInstance?.expatiate}"></g:textArea></td>

      %{--<td><span class="rigt_tebl_font">${fieldValue(bean: boSecurityEventsInstance, field: "expatiate")}</span></td>--}%

    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${boSecurityEventsInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>
          <span class="button"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>