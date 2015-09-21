
<%@ page import="settle.FtFoot" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'ftFoot.label', default: 'FtFoot')}"/>
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
      <td class="right label_name"><g:message code="ftFoot.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.srvCode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "srvCode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.tradeCode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "tradeCode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.customerNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "customerNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.type.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "type")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.footNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "footNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.checkStatus.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "checkStatus")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.checkOpId.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "checkOpId")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.checkDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${ftFootInstance?.checkDate}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.createOpId.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "createOpId")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.amount.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "amount")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.feeType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "feeType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.footDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${ftFootInstance?.footDate}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.postFee.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "postFee")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.preFee.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "preFee")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftFoot.transNum.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftFootInstance, field: "transNum")}</span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${ftFootInstance?.id}"/>
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