
<%@ page import="boss.BoAgentPayServiceParams" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boAgentPayServiceParams.label', default: '代收代付参数')}"/>
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
      <td class="right label_name">收费方式：</td>
      
      <td><span class="rigt_tebl_font">按笔收费 对公每笔${fieldValue(bean: boAgentPayServiceParamsInstance, field: "procedureFee")}元 对私每笔${fieldValue(bean: boAgentPayServiceParamsInstance, field: "procedureFee")}元</span></td>
      
    </tr>

    
    <tr>
      <td class="right label_name">交易限额：</td>
      
      <td><span class="rigt_tebl_font">
          单笔交易限额&nbsp;${fieldValue(bean: boAgentPayServiceParamsInstance, field: "limitMoney")}
          <br/>日交易限额（笔数） ${fieldValue(bean: boAgentPayServiceParamsInstance, field: "dayLimitTrans")}
          <br/>日交易限额（金额） ${fieldValue(bean: boAgentPayServiceParamsInstance, field: "dayLimitMoney")}
          <br/>月交易限额（笔数） ${fieldValue(bean: boAgentPayServiceParamsInstance, field: "monthLimitTrans")}
          <br/>月交易限额（金额） ${fieldValue(bean: boAgentPayServiceParamsInstance, field: "monthLimitMoney")}
      </span></td>
      
    </tr>
    

    <tr>
      <td class="right label_name">结算方式：</td>
      
      <td>
          <span class="rigt_tebl_font">
            <g:if test="${boAgentPayServiceParamsInstance.settWay=='0'}">即扣</g:if>
            <g:if test="${boAgentPayServiceParamsInstance.settWay=='1'}">后返</g:if>
          </span>
      </td>
      
    </tr>
    
    <tr>
      <td class="right label_name">是否退还手续费：</td>
      
      <td><span class="rigt_tebl_font">
          <g:if test="${boAgentPayServiceParamsInstance.backFee=='0'}">不退</g:if>
          <g:if test="${boAgentPayServiceParamsInstance.backFee=='1'}">退</g:if>
      </td>
      
    </tr>

    <tr>
      <td class="right label_name">备注：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boAgentPayServiceParamsInstance, field: "remark")}</span></td>
      
    </tr>

    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${boAgentPayServiceParamsInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>
          %{--<span class="button"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>--}%
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>