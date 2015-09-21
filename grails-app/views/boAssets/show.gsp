
<%@ page import="boss.BoAssets" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boAssets.label', default: 'BoAssets')}"/>
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
      <td class="right label_name"><g:message code="boAssets.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${boAssetsInstance.id}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAssets.asId.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boAssetsInstance, field: "asId")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAssets.name.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boAssetsInstance, field: "name")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAssets.brand.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boAssetsInstance, field: "brand")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAssets.model.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boAssetsInstance, field: "model")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAssets.num.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boAssetsInstance, field: "num")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAssets.status.label"/>：</td>

         <td><span class="rigt_tebl_font">${boAssetsInstance.statusMap[boAssetsInstance?.status]}</span></td>
      
      %{--<td><span class="rigt_tebl_font">${fieldValue(bean: boAssetsInstance, field: "status")}</span></td>--}%
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAssets.startDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate  date="${boAssetsInstance.startDate}" format="yyyy-MM-dd"/></span></td>
        %{--<g:formatDate  date="${boAssetsInstance.startDate}" format="yyyy-MM-dd"/>--}%
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAssets.remark.label"/>：</td>
      
      <td>
    <g:textArea name="remark" rows="11" cols="20" value="${boAssetsInstance?.remark}"></g:textArea></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${boAssetsInstance?.id}"/>
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