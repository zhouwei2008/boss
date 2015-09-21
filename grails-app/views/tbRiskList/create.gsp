

<%@ page import="ismp.TbRiskList" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbRiskList.label', default: 'TbRiskList')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${tbRiskListInstance}">
    <div class="errors">
      <g:renderErrors bean="${tbRiskListInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbRiskList.tradeType.label"/>：</td>
        <td class="${hasErrors(bean: tbRiskListInstance, field: 'tradeType', 'errors')}"><g:textField name="tradeType" maxlength="15" value="${tbRiskListInstance?.tradeType}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbRiskList.amount.label"/>：</td>
        <td class="${hasErrors(bean: tbRiskListInstance, field: 'amount', 'errors')}"><g:textField name="amount" value="${fieldValue(bean: tbRiskListInstance, field: 'amount')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbRiskList.merchantNo.label"/>：</td>
        <td class="${hasErrors(bean: tbRiskListInstance, field: 'merchantNo', 'errors')}"><g:textField name="merchantNo" maxlength="20" value="${tbRiskListInstance?.merchantNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbRiskList.merchantName.label"/>：</td>
        <td class="${hasErrors(bean: tbRiskListInstance, field: 'merchantName', 'errors')}"><g:textField name="merchantName" maxlength="100" value="${tbRiskListInstance?.merchantName}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbRiskList.merchantId.label"/>：</td>
        <td class="${hasErrors(bean: tbRiskListInstance, field: 'merchantId', 'errors')}"><g:textField name="merchantId" maxlength="30" value="${tbRiskListInstance?.merchantId}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbRiskList.createdDate.label"/>：</td>
        <td class="${hasErrors(bean: tbRiskListInstance, field: 'createdDate', 'errors')}"><bo:datePicker name="createdDate" precision="day" value="${tbRiskListInstance?.createdDate}" /></td>
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
