
<%@ page import="ismp.CmCustomerOperator" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'cmCustomerOperator.label', default: 'CmCustomerOperator')}"/>
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
      <td class="right label_name"><g:message code="cmCustomerOperator.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerOperatorInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomerOperator.customer.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${cmCustomerOperatorInstance?.customer?.encodeAsHTML()}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomerOperator.name.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerOperatorInstance, field: "name")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomerOperator.defaultEmail.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerOperatorInstance, field: "defaultEmail")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomerOperator.defaultMobile.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerOperatorInstance, field: "defaultMobile")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomerOperator.status.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerOperatorInstance, field: "status")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomerOperator.roleSet.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerOperatorInstance, field: "roleSet")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomerOperator.loginPassword.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerOperatorInstance, field: "loginPassword")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomerOperator.payPassword.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerOperatorInstance, field: "payPassword")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomerOperator.lastLoginTime.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${cmCustomerOperatorInstance?.lastLoginTime}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomerOperator.dateCreated.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${cmCustomerOperatorInstance?.dateCreated}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomerOperator.lastUpdated.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${cmCustomerOperatorInstance?.lastUpdated}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomerOperator.loginErrorTime.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerOperatorInstance, field: "loginErrorTime")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomerOperator.loginFlag.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerOperatorInstance, field: "loginFlag")}</span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${cmCustomerOperatorInstance?.id}"/>
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