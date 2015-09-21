
<%@ page import="boss.BoRefundModel" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boRefundModel.label', default: 'BoRefundModel')}"/>
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
      <td class="right label_name"><g:message code="boRefundModel.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boRefundModelInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.customerId.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boRefundModelInstance, field: "customerId")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.contractNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boRefundModelInstance, field: "contractNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.serviceCode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boRefundModelInstance, field: "serviceCode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.startTime.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${boRefundModelInstance?.startTime}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.endTime.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${boRefundModelInstance?.endTime}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.feeParams.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boRefundModelInstance, field: "feeParams")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.serviceParams.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boRefundModelInstance, field: "serviceParams")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.isCurrent.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${boRefundModelInstance?.isCurrent}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.enable.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${boRefundModelInstance?.enable}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.customerManagerOperatorId.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boRefundModelInstance, field: "customerManagerOperatorId")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.checkStatus.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boRefundModelInstance, field: "checkStatus")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.checkDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${boRefundModelInstance?.checkDate}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.checkOperatorId.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boRefundModelInstance, field: "checkOperatorId")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.srvAccNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boRefundModelInstance, field: "srvAccNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.feeAccNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boRefundModelInstance, field: "feeAccNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.paySrvBanks.label"/>：</td>
      
      <td><span class="rigt_tebl_font">
        <ul>
          <g:each in="${boRefundModelInstance.paySrvBanks}" var="p">
            <li>${p?.encodeAsHTML()}</li>
          </g:each>
        </ul>
      </span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.belongToSale.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boRefundModelInstance, field: "belongToSale")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.refundModel.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boRefundModelInstance, field: "refundModel")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.dateCreated.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${boRefundModelInstance?.dateCreated}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boRefundModel.lastUpdated.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${boRefundModelInstance?.lastUpdated}"/></span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${boRefundModelInstance?.id}"/>
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