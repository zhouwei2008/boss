

<%@ page import="boss.BoRefundModel" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boRefundModel.label', default: 'BoRefundModel')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boRefundModelInstance}">
    <div class="errors">
      <g:renderErrors bean="${boRefundModelInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${boRefundModelInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <td class="right label_name"><g:message code="boRefundModel.refundModel.label"/>：</td>
        <td class="${hasErrors(bean: boRefundModelInstance, field: 'refundModel', 'errors')}"><g:select name="refundModel" from="${boRefundModelInstance.constraints.refundModel.inList}" value="${boRefundModelInstance?.refundModel}" valueMessagePrefix="boRefundModel.refundModel"  /></td>
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
