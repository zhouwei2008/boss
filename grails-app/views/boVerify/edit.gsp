

<%@ page import="boss.BoVerify" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boVerify.label', default: 'BoVerify')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boVerifyInstance}">
    <div class="errors">
      <g:renderErrors bean="${boVerifyInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${boVerifyInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="修改明细" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="类型"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'type', 'errors')}"><g:textField name="type" maxlength="2" value="${boVerifyInstance?.type}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="状态"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'status', 'errors')}"><g:textField name="status" maxlength="2" value="${boVerifyInstance?.status}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="银行码"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'outBankCode', 'errors')}"><g:textField name="outBankCode" maxlength="10" value="${boVerifyInstance?.outBankCode}" /></td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="银行名称"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'outBankName', 'errors')}"><g:textField name="outBankName" maxlength="64" value="${boVerifyInstance?.outBankName}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="转出银行帐号"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'outBankAccountNo', 'errors')}"><g:textField name="outBankAccountNo" maxlength="32" value="${boVerifyInstance?.outBankAccountNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="转出银行名称"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'outBankAccountName', 'errors')}"><g:textField name="outBankAccountName" maxlength="40" value="${boVerifyInstance?.outBankAccountName}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="转出银行余额"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'outRemainAmount', 'errors')}"><g:textField name="outRemainAmount" maxlength="16" value="${boVerifyInstance?.outRemainAmount}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="金额"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'outAmount', 'errors')}"><g:textField name="outAmount" maxlength="40" value="${boVerifyInstance?.outAmount}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="转入银行编码"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'inBankCode', 'errors')}"><g:textField name="inBankCode" maxlength="10" value="${boVerifyInstance?.inBankCode}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="转入银行名称"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'inBankName', 'errors')}"><g:textField name="inBankName" maxlength="64" value="${boVerifyInstance?.inBankName}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="转入银行帐号"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'inBankAccountNo', 'errors')}"><g:textField name="inBankAccountNo" maxlength="32" value="${boVerifyInstance?.inBankAccountNo}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="转入银行名称"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'inBankAccountName', 'errors')}"><g:textField name="inBankAccountName" maxlength="64" value="${boVerifyInstance?.inBankAccountName}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="转入银行余额"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'inRemainAmount', 'errors')}"><g:textField name="inRemainAmount" value="${boVerifyInstance?.inRemainAmount}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="操作员"/>：</td>
        <td class="${hasErrors(bean: boVerifyInstance, field: 'operName', 'errors')}"><g:textField name="operName" value="${boVerifyInstance?.operName}" /></td>
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
