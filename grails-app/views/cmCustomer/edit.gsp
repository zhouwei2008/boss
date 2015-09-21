

<%@ page import="ismp.CmCustomer" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'cmCustomer.label', default: 'CmCustomer')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${cmCustomerInstance}">
    <div class="errors">
      <g:renderErrors bean="${cmCustomerInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${cmCustomerInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="cmCustomer.name.label"/>：</td>
        <td class="${hasErrors(bean: cmCustomerInstance, field: 'name', 'errors')}"><g:textField name="name" maxlength="32" value="${cmCustomerInstance?.name}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="cmCustomer.customerNo.label"/>：</td>
        <td class="${hasErrors(bean: cmCustomerInstance, field: 'customerNo', 'errors')}"><g:textField name="customerNo" maxlength="24" value="${cmCustomerInstance?.customerNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="cmCustomer.type.label"/>：</td>
        <td class="${hasErrors(bean: cmCustomerInstance, field: 'type', 'errors')}"><g:select name="type" from="${cmCustomerInstance.constraints.type.inList}" value="${cmCustomerInstance?.type}" valueMessagePrefix="cmCustomer.type"  /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="cmCustomer.status.label"/>：</td>
        <td class="${hasErrors(bean: cmCustomerInstance, field: 'status', 'errors')}"><g:select name="status" from="${cmCustomerInstance.constraints.status.inList}" value="${cmCustomerInstance?.status}" valueMessagePrefix="cmCustomer.status"  /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="cmCustomer.apiKey.label"/>：</td>
        <td class="${hasErrors(bean: cmCustomerInstance, field: 'apiKey', 'errors')}"><g:textField name="apiKey" maxlength="64" value="${cmCustomerInstance?.apiKey}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="cmCustomer.accountNo.label"/>：</td>
        <td class="${hasErrors(bean: cmCustomerInstance, field: 'accountNo', 'errors')}"><g:textField name="accountNo" maxlength="24" value="${cmCustomerInstance?.accountNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="cmCustomer.needInvoice.label"/>：</td>
        <td class="${hasErrors(bean: cmCustomerInstance, field: 'needInvoice', 'errors')}"><g:checkBox name="needInvoice" value="${cmCustomerInstance?.needInvoice}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="cmCustomer.customerCategory.label"/>：</td>
        <td class="${hasErrors(bean: cmCustomerInstance, field: 'customerCategory', 'errors')}"><g:textField name="customerCategory" value="${cmCustomerInstance?.customerCategory}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="cmCustomer.postFee.label"/>：</td>
        <td class="${hasErrors(bean: cmCustomerInstance, field: 'postFee', 'errors')}"><g:textField name="postFee" value="${fieldValue(bean: cmCustomerInstance, field: 'postFee')}" /></td>
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
