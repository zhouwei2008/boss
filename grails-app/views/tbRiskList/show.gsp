
<%@ page import="ismp.TbRiskList" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbRiskList.label', default: 'TbRiskList')}"/>
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
      <td class="right label_name"><g:message code="tbRiskList.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskListInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbRiskList.tradeType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskListInstance, field: "tradeType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbRiskList.amount.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskListInstance, field: "amount")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbRiskList.merchantNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskListInstance, field: "merchantNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbRiskList.merchantName.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskListInstance, field: "merchantName")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbRiskList.merchantId.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskListInstance, field: "merchantId")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbRiskList.createdDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${tbRiskListInstance?.createdDate}"/></span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${tbRiskListInstance?.id}"/>
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