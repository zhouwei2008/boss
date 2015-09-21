
<%@ page import="ismp.MapiAsyncNotify" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'mapiAsyncNotify.label', default: 'MapiAsyncNotify')}"/>
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
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: mapiAsyncNotifyInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.dateCreated.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${mapiAsyncNotifyInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.lastUpdated.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${mapiAsyncNotifyInstance?.lastUpdated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.recordTable.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: mapiAsyncNotifyInstance, field: "recordTable")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.recordId.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: mapiAsyncNotifyInstance, field: "recordId")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.signType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: mapiAsyncNotifyInstance, field: "signType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.notifyTime.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${mapiAsyncNotifyInstance?.notifyTime}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.notifyId.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: mapiAsyncNotifyInstance, field: "notifyId")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.nextAttemptTime.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${mapiAsyncNotifyInstance?.nextAttemptTime}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.status.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${MapiAsyncNotify.statusMap[mapiAsyncNotifyInstance.status]}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.attemptsCount.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: mapiAsyncNotifyInstance, field: "attemptsCount")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.timeExpired.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${mapiAsyncNotifyInstance?.timeExpired}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.isVerify.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${mapiAsyncNotifyInstance?.isVerify}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.outputCharset.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: mapiAsyncNotifyInstance, field: "outputCharset")}</span></td>
      
    </tr>
    
    %{--<tr>--}%
      %{--<td class="right label_name" nowrap><g:message code="mapiAsyncNotify.customerId.label"/>：</td>--}%
      %{----}%
      %{--<td><span class="rigt_tebl_font">${fieldValue(bean: mapiAsyncNotifyInstance, field: "customerId")}</span></td>--}%
      %{----}%
    %{--</tr>--}%
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.notifyAddress.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: mapiAsyncNotifyInstance, field: "notifyAddress")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.notifyContents.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: mapiAsyncNotifyInstance, field: "notifyContents")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name" nowrap><g:message code="mapiAsyncNotify.notifyMethod.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${MapiAsyncNotify.notifyMethodMap[mapiAsyncNotifyInstance.notifyMethod]}</span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${mapiAsyncNotifyInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          %{--<span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>--}%
          %{--<span class="button"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>--}%
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>