<%@ page import="ismp.CmOpRelation" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'cmOpRelation.label', default: 'CmOpRelation')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<script type="text/javascript">
    function checkTest() {
//        var reg = ~/^[-_A-Za-z0-9]+@([_A-Za-z0-9]+.)+[A-Za-z0-9]{2,3}$/
        if (document.getElementById("controllers").value.replace(/[ ]/g, "").length == 0) {
            alert("模块号不能为空，请填写！");
            document.getElementById("controllers").focus();
            return false;
        }
        if (document.getElementById("actions").value.replace(/[ ]/g, "").length == 0) {
            alert("操作号不能为空，请填写！");
            document.getElementById("actions").focus();
            return false;
        }
         if (document.getElementById("names").value.replace(/[ ]/g, "").length == 0) {
            alert("操作描述不能为空，请填写！");
            document.getElementById("names").focus();
            return false;
        }

    }
</script>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${cmOpRelationInstance}">
    <div class="errors">
      <g:renderErrors bean="${cmOpRelationInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${cmOpRelationInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="cmOpRelation.controllers.label"/>：</td>
        <td class="${hasErrors(bean: cmOpRelationInstance, field: 'controllers', 'errors')}"><g:textField name="controllers" value="${cmOpRelationInstance?.controllers}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="cmOpRelation.actions.label"/>：</td>
        <td class="${hasErrors(bean: cmOpRelationInstance, field: 'actions', 'errors')}"><g:textField name="actions" value="${cmOpRelationInstance?.actions}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="cmOpRelation.names.label"/>：</td>
        <td class="${hasErrors(bean: cmOpRelationInstance, field: 'names', 'errors')}"><g:textField name="names" value="${cmOpRelationInstance?.names}" /></td>
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
