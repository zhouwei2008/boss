

<%@ page import="boss.BoAssets" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boAssets.label', default: 'BoAssets')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boAssetsInstance}">
    <div class="errors">
      <g:renderErrors bean="${boAssetsInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAssets.asId.label"/>：</td>
        <td class="${hasErrors(bean: boAssetsInstance, field: 'asId', 'errors')}"><g:textField name="asId" maxlength="64" value="${boAssetsInstance?.asId}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAssets.name.label"/>：</td>
        <td class="${hasErrors(bean: boAssetsInstance, field: 'name', 'errors')}"><g:textField name="name" maxlength="64" value="${boAssetsInstance?.name}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAssets.brand.label"/>：</td>
        <td class="${hasErrors(bean: boAssetsInstance, field: 'brand', 'errors')}"><g:textField name="brand" maxlength="64" value="${boAssetsInstance?.brand}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAssets.model.label"/>：</td>
        <td class="${hasErrors(bean: boAssetsInstance, field: 'model', 'errors')}"><g:textField name="model" maxlength="64" value="${boAssetsInstance?.model}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAssets.num.label"/>：</td>
        <td class="${hasErrors(bean: boAssetsInstance, field: 'num', 'errors')}"><g:textField name="num" value="${fieldValue(bean: boAssetsInstance, field: 'num')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAssets.status.label"/>：</td>
        <td class="${hasErrors(bean: boAssetsInstance, field: 'status', 'errors')}">
            <g:select name="status" from="${boAssetsInstance.statusMap}" value="${boAssetsInstance?.status}" optionKey="key" optionValue="value"/></td>

      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAssets.startDate.label"/>：</td>
        <td class="${hasErrors(bean: boAssetsInstance, field: 'startDate', 'errors')}"><bo:datePicker name="startDate" precision="day" value="${boAssetsInstance?.startDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAssets.remark.label"/>：</td>
        <td class="${hasErrors(bean: boAssetsInstance, field: 'remark', 'errors')}">
            <g:textArea name="remark" rows="11" cols="20" value="${boAssetsInstance?.remark}"></g:textArea></td>
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
