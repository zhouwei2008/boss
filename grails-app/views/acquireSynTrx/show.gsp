
<%@ page import="ismp.AcquireSynTrx" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acquireSynTrx.label', default: 'AcquireSynTrx')}"/>
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
      <td class="right label_name"><g:message code="acquireSynTrx.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireSynTrx.acquireAuthcode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "acquireAuthcode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireSynTrx.acquireCardnum.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "acquireCardnum")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireSynTrx.acquireDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "acquireDate")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireSynTrx.acquireRefnum.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "acquireRefnum")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireSynTrx.acquireSeq.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "acquireSeq")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireSynTrx.batchnum.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "batchnum")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireSynTrx.payerIp.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "payerIp")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireSynTrx.acquireCode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "acquireCode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireSynTrx.acquireMerchant.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "acquireMerchant")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireSynTrx.amount.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "amount")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireSynTrx.createDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${acquireSynTrxInstance?.createDate}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireSynTrx.trxid.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "trxid")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireSynTrx.trxsts.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "trxsts")}</span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${acquireSynTrxInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>