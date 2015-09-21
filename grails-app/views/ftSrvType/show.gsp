
<%@ page import="boss.Perm; settle.FtSrvType" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'ftSrvType.label', default: 'FtSrvType')}"/>
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
      <td class="right label_name"><g:message code="ftSrvType.srvCode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftSrvTypeInstance, field: "srvCode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftSrvType.srvName.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftSrvTypeInstance, field: "srvName")}</span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${ftSrvTypeInstance?.id}"/>
<!--          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>-->
           <span class="button"><g:actionSubmit class="rigt_button" action="list" value="返回"/></span>
          <bo:hasPerm perm="${Perm.Settle_SrvType_Edit}" ><span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span></bo:hasPerm>
          <span class="button"><g:actionSubmit class="rigt_button" action="delete" onclick="if(confirm('确定删除么?')){return true;}else{return false;}"  value="${message(code: 'default.button.delete.label', default: 'Del')}"/></span>
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>