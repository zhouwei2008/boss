
<%@ page import="settle.FtTradeFeeStep" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'ftTradeFeeStep.label', default: 'FtTradeFeeStep')}"/>
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
      <td class="right label_name"><g:message code="ftTradeFeeStep.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.customerNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "customerNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.tradeWeight.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "tradeWeight")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.fetchType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "fetchType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.feeType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "feeType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.feeValue.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "feeValue")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step1From.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step1From")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step1To.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step1To")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step1FeeType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step1FeeType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step1FeeValue.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step1FeeValue")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step1FeeMin.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step1FeeMin")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step1FeeMax.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step1FeeMax")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step2From.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step2From")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step2To.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step2To")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step2FeeType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step2FeeType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step2FeeValue.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step2FeeValue")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step2FeeMin.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step2FeeMin")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step2FeeMax.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step2FeeMax")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step3From.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step3From")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step3To.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step3To")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step3FeeType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step3FeeType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step3FeeValue.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step3FeeValue")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step3FeeMin.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step3FeeMin")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step3FeeMax.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step3FeeMax")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step4From.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step4From")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step4To.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step4To")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step4FeeType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step4FeeType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step4FeeValue.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step4FeeValue")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step4FeeMin.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step4FeeMin")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step4FeeMax.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step4FeeMax")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step5From.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step5From")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step5To.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step5To")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step5FeeType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step5FeeType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step5FeeValue.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step5FeeValue")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step5FeeMin.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step5FeeMin")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.step5FeeMax.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "step5FeeMax")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.category.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "category")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.channelCode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "channelCode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.dateBegin.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${ftTradeFeeStepInstance?.dateBegin}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.dateEnd.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${ftTradeFeeStepInstance?.dateEnd}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.feeMax.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "feeMax")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.feeMin.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "feeMin")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.firstLiqDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${ftTradeFeeStepInstance?.firstLiqDate}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.packLen.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "packLen")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.packType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeStepInstance, field: "packType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.srv.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${ftTradeFeeStepInstance?.srv?.encodeAsHTML()}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFeeStep.tradeType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${ftTradeFeeStepInstance?.tradeType?.encodeAsHTML()}</span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${ftTradeFeeStepInstance?.id}"/>
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