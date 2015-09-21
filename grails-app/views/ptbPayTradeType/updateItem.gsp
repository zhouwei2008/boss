<%@ page import="pay.PtbPayTradeType" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: '交易类型修改', default: '交易类型修改')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
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
        <th colspan="2">交易类型修改</th>
      </tr>
       %{--<tr>
        <td class="right label_name">打款类型：</td>
        <td>
           &nbsp;&nbsp;${PtbPayTradeType.PayTypeMap[ptbPayTradeType.payType]}
            <g:hiddenField name="payType" value="${ptbPayTradeType.payType}"/>
        </td>
      </tr>--}%
      <tr>
        <td class="right label_name" style="width: 30%">交易Code：</td>
        <td>
            &nbsp;&nbsp;${ptbPayTradeType.payCode}
        </td>
      </tr>
      <tr>
        <td class="right label_name">交易名称：</td>
        <td>
            <input type="text" name="payName" maxlength="50" id="payName" value="${ptbPayTradeType.payName}" onKeyUp="value=value.replace(/^\s+/,'').replace(/\s+$/,'')"/>
        </td>
      </tr>

      <tr>
        <td class="right label_name">备注：</td>
        <td><g:textArea name="note" cols="60" rows="4" maxlength="95" value="${ptbPayTradeType.note}"/></td>
      </tr>
      <tr>
        <td colspan="2" align="center">
          <span class="button"><g:actionSubmit class="rigt_button" action="update" value="修改"/></span>
          <g:hiddenField name="payId" value="${ptbPayTradeType.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
        </td>
      </tr>
    </table>
  </g:form>

  </div>
</div>
</body>
</html>
