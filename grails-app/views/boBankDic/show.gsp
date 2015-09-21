
<%@ page import="boss.Perm; boss.BoBankDic" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boBankDic.label', default: 'BoBankDic')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>

  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boBankDic.code.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boBankDicInstance, field: "code")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boBankDic.name.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boBankDicInstance, field: "name")}</span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${boBankDicInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="button"><bo:hasPerm perm="${Perm.Bank_Manage_Edit}"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></bo:hasPerm></span>
          <span class="button"><bo:hasPerm perm="${Perm.Bank_Manage_Delete}"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></bo:hasPerm></span>
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>