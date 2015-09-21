
<%@ page import="ismp.AcquireFaultTrx" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx')}"/>
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
      <td class="right label_name"><g:message code="acquireFaultTrx.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.trxid.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "trxid")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.acquireTrxnum.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "acquireTrxnum")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.trxdate.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "trxdate")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.iniSts.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${AcquireFaultTrx.iniStsMap[acquireFaultTrxInstance?.iniSts]}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.changeSts.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${AcquireFaultTrx.changeStsMap[acquireFaultTrxInstance.changeSts]}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.authSts.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${AcquireFaultTrx.authStsMap[acquireFaultTrxInstance?.authSts]}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.datasrc.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${AcquireFaultTrx.datasrcMap[acquireFaultTrxInstance?.datasrc]}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.acquireCode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "acquireCode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.acquireAuthcode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "acquireAuthcode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.acquireCardnum.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "acquireCardnum")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.acquireDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "acquireDate")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.acquireRefnum.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "acquireRefnum")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.acquireSeq.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "acquireSeq")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.payerIp.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "payerIp")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.finalSts.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${AcquireFaultTrx.finalStsMap[acquireFaultTrxInstance?.finalSts]}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.authOper.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "authOper")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.faultAdvice.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "faultAdvice")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.finalResult.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "finalResult")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.batchnum.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "batchnum")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.acquireMerchant.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "acquireMerchant")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.authDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${acquireFaultTrxInstance?.authDate}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.changeApplier.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: acquireFaultTrxInstance, field: "changeApplier")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.createDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${acquireFaultTrxInstance?.createDate}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.trxamount.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatNumber number="${acquireFaultTrxInstance?.trxamount/100}" type="currency" currencyCode="CNY"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acquireFaultTrx.updateDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${acquireFaultTrxInstance?.updateDate}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${acquireFaultTrxInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          %{--<span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>--}%
          %{--<span class="button"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>--}%
        </g:form>
      </td>
    </tr>
  </table>
                                                `
</div>
</body>
</html>