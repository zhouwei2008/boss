
<%@ page import="dsf.TbBindBank" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbBindBank.label', default: 'TbBindBank')}"/>
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
        <th colspan="2">银行渠道绑定</th>
      </tr>

      <tr>
        <td class="right label_name">银行账号：</td>
        <td>
         <g:textField name="bankAccountno" maxlength="30"/>
        </td>
      </tr>

      %{--<tr>--}%
        %{--<td class="right label_name">服务：</td>--}%
        %{--<td><g:select name="dsfFlag" value="${params.id}" from="${TbBindBank.ServerTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>--}%
        %{--</td>--}%
      %{--</tr>--}%

      <tr>
        <td class="right label_name">备注：</td>
        <td><g:textArea name="notes" cols="60" rows="4" maxlength="200"/></td>
      </tr>
      <g:hiddenField name="dsfFlag" value="F"/>
      <tr>
        <td colspan="2" align="center">
          <span class="button"><g:actionSubmit class="rigt_button" action="save" value="绑定"/></span>
        </td>
      </tr>
    </table>
  </g:form>

  </div>
</div>
</body>
</html>
