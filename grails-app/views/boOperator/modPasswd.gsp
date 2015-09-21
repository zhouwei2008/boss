<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <title>修改密码</title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <g:hasErrors bean="${userInstance}">
    <div class="errors">
      <g:renderErrors bean="${userInstance}" as="list"/>
    </div>
  </g:hasErrors>
  <g:form>
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2">修改密码</th>
      </tr>

      <tr>
        <td class="right label_name">旧密码：</td>
        <td><g:passwordField name="oldPass" maxlength="30"/></td>
      </tr>

      <tr>
        <td class="right label_name">新密码：</td>
        <td><g:passwordField name="newPass" maxlength="30"/>
            <label>密码长度必须大于8位，且必须是数字、字母和特殊字符组合而成</label>
        </td>
      </tr>

      <tr>
        <td class="right label_name">确认密码：</td>
        <td><g:passwordField name="newPass2" maxlength="30"/>
            <label>密码长度必须大于8位，且必须是数字、字母和特殊字符组合而成</label>
        </td>
      </tr>

      <tr>
        <td colspan="2" align="center">
          <span class="button"><g:actionSubmit class="rigt_button" action="updatePasswd" value="修改"/></span>
        </td>
      </tr>
    </table>
  </g:form>
</div>
</body>
</html>
