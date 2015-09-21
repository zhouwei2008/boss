
<%@ page import="dsf.TbAgentpayDetailsInfo" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: 'TbAgentpayDetailsInfo')}"/>
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
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.batchId.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "batchId")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeNum.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeNum")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeBankcode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeBankcode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeCardtype.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeCardtype")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeCardnum.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeCardnum")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeCardname.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeCardname")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeBranchbank.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeBranchbank")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeSubbranchbank.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeSubbranchbank")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeAccountname.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeAccountname")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeAccounttype.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeAccounttype")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeAmount.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeAmount")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeAmounttype.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeAmounttype")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.contractCode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "contractCode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.contractUsercode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "contractUsercode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.certificateType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "certificateType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.certificateNum.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "certificateNum")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeMobile.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeMobile")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeRemark.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeRemark")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeFeedbackcode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeFeedbackcode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeReason.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeReason")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeRemark1.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeRemark1")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeRemark2.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeRemark2")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeStatus.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeStatus")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeHandcharge.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeHandcharge")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeSysdate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${tbAgentpayDetailsInfoInstance?.tradeSysdate}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeDonedate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${tbAgentpayDetailsInfoInstance?.tradeDonedate}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.batchBizid.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "batchBizid")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeFeestyle.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeFeestyle")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeFeetype.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeFeetype")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.tradeAccamount.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeAccamount")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="tbAgentpayDetailsInfo.payStatus.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "payStatus")}</span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${tbAgentpayDetailsInfoInstance?.id}"/>
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