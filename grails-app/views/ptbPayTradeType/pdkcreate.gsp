<%@ page import="pay.PtbPayTradeType" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: '打款交易类型创建', default: '打款交易类型创建')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>

    <script type="text/javascript">
        function check(){
            var payCode = document.getElementById("payCode")
            var payName = document.getElementById('payName')
            if(payCode.value==""||payCode.value==null){
                alert("交易Code不能为空!")
                return false;
            }
            if(payName.value==""||payName.value==null){
                alert("交易名称不能为空!")
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div class="right_top">

    <g:form name="updateForm">
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2">交易类型创建</th>
      </tr>
       %{--<tr>
        <td class="right label_name">打款类型：</td>
        <td>
           &nbsp;&nbsp;付款
        </td>
      </tr>--}%
      <tr>
        <td class="right label_name" style="width: 30%">交易Code：</td>
        <td>
            <input type="text" name="payCode" maxlength="10" id="payCode" value="${params.payCode}" onKeyUp="value=value.replace(/^\s+/,'').replace(/\s+$/,'')"/>
        </td>
      </tr>
      <tr>
        <td class="right label_name">交易名称：</td>
        <td>
            <input type="text" name="payName" maxlength="50" id="payName" value="${params.payName}" onKeyUp="value=value.replace(/^\s+/,'').replace(/\s+$/,'')"/>
        </td>
      </tr>

      <tr>
        <td class="right label_name">备注：</td>
        <td><g:textArea name="note" cols="60" rows="4" maxlength="95"/></td>
      </tr>
      <g:hiddenField name="payType" value="F"/>
      <tr>
        <td colspan="2" align="center">
          <span class="button"><g:actionSubmit class="rigt_button" action="save" value="创建" onclick="return check()"/></span>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
        </td>
      </tr>
    </table>
  </g:form>

  </div>
</div>
</body>
</html>
