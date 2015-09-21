

<%@ page import="dsf.TbPcInfo" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbPcInfo.label', default: 'TbPcInfo')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${tbPcInfoInstance}">
    <div class="errors">
      <g:renderErrors bean="${tbPcInfoInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbPcInfo.tbPcAccamount.label"/>：</td>
        <td class="${hasErrors(bean: tbPcInfoInstance, field: 'tbPcAccamount', 'errors')}"><g:textField name="tbPcAccamount" value="${tbPcInfoInstance?.tbPcAccamount}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbPcInfo.tbPcAmount.label"/>：</td>
        <td class="${hasErrors(bean: tbPcInfoInstance, field: 'tbPcAmount', 'errors')}"><g:textField name="tbPcAmount" value="${tbPcInfoInstance?.tbPcAmount}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbPcInfo.tbPcDate.label"/>：</td>
        <td class="${hasErrors(bean: tbPcInfoInstance, field: 'tbPcDate', 'errors')}"><bo:datePicker name="tbPcDate" precision="day" value="${tbPcInfoInstance?.tbPcDate}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbPcInfo.tbPcDkChanel.label"/>：</td>
        <td class="${hasErrors(bean: tbPcInfoInstance, field: 'tbPcDkChanel', 'errors')}"><g:textField name="tbPcDkChanel" value="${fieldValue(bean: tbPcInfoInstance, field: 'tbPcDkChanel')}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbPcInfo.tbPcDkChanelname.label"/>：</td>
        <td class="${hasErrors(bean: tbPcInfoInstance, field: 'tbPcDkChanelname', 'errors')}"><g:textField name="tbPcDkChanelname" value="${tbPcInfoInstance?.tbPcDkChanelname}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbPcInfo.tbPcDkStatus.label"/>：</td>
        <td class="${hasErrors(bean: tbPcInfoInstance, field: 'tbPcDkStatus', 'errors')}"><g:textField name="tbPcDkStatus" value="${tbPcInfoInstance?.tbPcDkStatus}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbPcInfo.tbPcFee.label"/>：</td>
        <td class="${hasErrors(bean: tbPcInfoInstance, field: 'tbPcFee', 'errors')}"><g:textField name="tbPcFee" value="${tbPcInfoInstance?.tbPcFee}" /></td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="tbPcInfo.tbPcItems.label"/>：</td>
        <td class="${hasErrors(bean: tbPcInfoInstance, field: 'tbPcItems', 'errors')}"><g:textField name="tbPcItems" value="${fieldValue(bean: tbPcInfoInstance, field: 'tbPcItems')}" /></td>
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
