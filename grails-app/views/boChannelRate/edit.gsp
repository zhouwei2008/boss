

<%@ page import="boss.BoChannelRate" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boChannelRate.label', default: 'BoChannelRate')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>

</head>
<body style="overflow-x:hidden">
<script type="text/javascript">
          function changeFee()
          {
              var feeTypeVal = document.getElementById("feeType").value;
              if(feeTypeVal=='0'){
                  document.getElementById("ffee").style.display="none";
                  document.getElementById("bfee").style.display="";
              }else if(feeTypeVal=='1'){
                  document.getElementById("bfee").style.display="none";
                  document.getElementById("ffee").style.display="";
              }
          }
</script>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boChannelRateInstance}">
    <div class="errors">
      <g:renderErrors bean="${boChannelRateInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${boChannelRateInstance?.id}"/>
      <g:hiddenField name="merchantId" value="${boChannelRateInstance?.merchantId}"/>
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boChannelRate.feeType.label"/>：</td>
        <td class="${hasErrors(bean: boChannelRateInstance, field: 'feeType', 'errors')}">
           <g:select name='feeType' from="${BoChannelRate.feeTypeMap}" optionKey="key" optionValue="value" onchange="javascript:changeFee();" value="${boChannelRateInstance?.feeType}"/>
        </td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boChannelRate.feeRate.label"/>：</td>
        <td class="${hasErrors(bean: boChannelRateInstance, field: 'feeRate', 'errors')}">
            <g:if test="${boChannelRateInstance?.feeType=='0'}">
                <g:textField name="feeRate"  maxlength="10" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${strVal}" />
            </g:if>
            <g:else>
                <g:textField name="feeRate"  maxlength="10" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${boChannelRateInstance?.feeRate}" />
            </g:else>
        </td>
      </tr>

      <tr id="bfee">
        <td class="right label_name"><g:message code="boChannelRate.isRefundFee.label"/>：</td>
        <td class="${hasErrors(bean: boChannelRateInstance, field: 'isRefundFee', 'errors')}">
           <g:select name='isRefundFee' from="${BoChannelRate.isRefundFeeMap}" optionKey="key" optionValue="value" value="${boChannelRateInstance?.isRefundFee}"/>
        </td>
      </tr>

      <tr id="ffee" style="display:none">
        <td class="right label_name"><g:message code="boChannelRate.isRefundFee.label"/>：</td>
        <td class="${hasErrors(bean: boChannelRateInstance, field: 'isRefundFee', 'errors')}">
           <g:select name='isRefundFee' from="${BoChannelRate.isRefundFeeMap2}" optionKey="key" optionValue="value" value="${boChannelRateInstance?.isRefundFee}"/>
        </td>
      </tr>

       <tr>
            <td class="right label_name"><g:message code="boChannelRate.isCurrent.label"/>：</td>
            <td class="${hasErrors(bean: boChannelRateInstance, field: 'isCurrent', 'errors')}"><g:checkBox name="isCurrent" value="${boChannelRateInstance?.isCurrent}"/></td>
        </tr>
      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="button" name="button" id="button" onclick="checkField()" class="rigt_button" value="确定"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
      <script type="text/javascript">
          window.onload=function init()
          {
              var feeTypeVal = '${boChannelRateInstance?.feeType}';
              if(feeTypeVal=='0'){
                  document.getElementById("ffee").style.display="none";
                  document.getElementById("bfee").style.display="";
              }else if(feeTypeVal=='1'){
                  document.getElementById("bfee").style.display="none";
                  document.getElementById("ffee").style.display="";
              }
          }
           function trim(s)
         {
            return s.replace(/(^\s*)|(\s*$)/g, "");
         }
          function checkField()
          {
              var merchantId = ${merchantId};
              var feeRate = document.getElementById("feeRate").value;
              if(trim(feeRate)<=0 || !trim(feeRate)){
                  alert("费率必须大于0且为数字");
                  return false;
              }
              if(!merchantId){
                  alert("商户不存在");
                  return false;
              }
              document.forms[0].submit();
          }
 </script>
</body>
</html>

