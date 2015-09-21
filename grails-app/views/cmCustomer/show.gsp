
<%@ page import="ismp.CmCustomer" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'cmCustomer.label', default: 'CmCustomer')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label">与最新黑名单相符的客户</g:message></th>
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomer.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomer.name.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerInstance, field: "name")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomer.customerNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerInstance, field: "customerNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomer.type.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerInstance, field: "type")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomer.status.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerInstance, field: "status")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomer.apiKey.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerInstance, field: "apiKey")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomer.accountNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerInstance, field: "accountNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomer.needInvoice.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${cmCustomerInstance?.needInvoice}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomer.customerCategory.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerInstance, field: "customerCategory")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomer.dateCreated.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${cmCustomerInstance?.dateCreated}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomer.lastUpdated.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${cmCustomerInstance?.lastUpdated}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmCustomer.postFee.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerInstance, field: "postFee")}</span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${cmCustomerInstance?.id}"/>
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