
<%@ page import="boss.Perm; boss.BoChannelRate" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boChannelRate.label', default: 'BoChannelRate')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hiddenField name="id" value="${boChannelRateInstance?.id}"/>
  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boChannelRate.feeType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${BoChannelRate.feeTypeMap[boChannelRateInstance?.feeType]}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boChannelRate.feeRate.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boChannelRateInstance, field: "feeRate")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boChannelRate.isRefundFee.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${BoChannelRate.isRefundFeeMap2[boChannelRateInstance?.isRefundFee]}</span></td>
      
    </tr>
    <tr>
            <td class="right label_name"><g:message code="boChannelRate.isCurrent.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${boChannelRateInstance?.isCurrent}"/></span></td>
        </tr>
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${boChannelRateInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <bo:hasPerm perm="${Perm.Bank_Issu_Merc_Channel_Edit}" >
              <span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>
          </bo:hasPerm>
          %{--<span class="button"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>--}%
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>