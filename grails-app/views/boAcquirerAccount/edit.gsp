

<%@ page import="boss.BoAcquirerAccount" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boAcquirerAccount.label', default: 'BoAcquirerAccount')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
    <script type="text/javascript">
        function WidthCheck() {
            var s = document.getElementById("branchName").value;
            var n = 32;
            var w = 0;
            for (var i = 0; i < s.length; i++) {
                var c = s.charCodeAt(i);
                //单字节加1
                if ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xff9f)) {
                    w++;
                }
                else {
                    w += 2;
                }
            }
            if (w > n) {
               alert("该字段最多能输入32个字符！");
            }
            return true;
        }

    </script>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <g:hasErrors bean="${boAcquirerAccountInstance}">
    <div class="errors">
      <g:renderErrors bean="${boAcquirerAccountInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${boAcquirerAccountInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boAcquirerAccount.bank.label"/>：</td>
        <td class="${hasErrors(bean: boAcquirerAccountInstance, field: 'bank', 'errors')}">
          <g:select name="bank.id" from="${boss.BoBankDic.list()}" optionKey="id" optionValue="name" value="${boAcquirerAccountInstance?.bank?.id}"/>
        </td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boAcquirerAccount.branchName.label"/>：</td>
        <td class="${hasErrors(bean: boAcquirerAccountInstance, field: 'branchName', 'errors')}"><g:textField name="branchName" onblur="WidthCheck()" maxlength="32" value="${boAcquirerAccountInstance?.branchName}"/></td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boAcquirerAccount.bankNo.label"/>：</td>
        <td class="${hasErrors(bean: boAcquirerAccountInstance, field: 'bankNo', 'errors')}"><g:textField name="bankNo" maxlength="16" value="${boAcquirerAccountInstance?.bankNo}"/></td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boAcquirerAccount.bankAccountNo.label"/>：</td>
        <td class="${hasErrors(bean: boAcquirerAccountInstance, field: 'bankAccountNo', 'errors')}"><g:textField name="bankAccountNo" onblur="value=value.replace(/[^\\d^]/g, '')" onkeyup="value=value.replace(/[^\\d^]/g, '')"  maxlength="32" value="${boAcquirerAccountInstance?.bankAccountNo}"/></td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boAcquirerAccount.bankAccountName.label"/>：</td>
        <td class="${hasErrors(bean: boAcquirerAccountInstance, field: 'bankAccountName', 'errors')}"><g:textField name="bankAccountName" maxlength="40" value="${boAcquirerAccountInstance?.bankAccountName}"/></td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boAcquirerAccount.bankAccountType.label"/>：</td>
        <td class="${hasErrors(bean: boAcquirerAccountInstance, field: 'bankAccountType', 'errors')}">
          <g:select name="bankAccountType" from="${BoAcquirerAccount.typeMap}" optionKey="key" optionValue="value" value="${boAcquirerAccountInstance?.bankAccountType}"/>
        </td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boAcquirerAccount.aliasName.label"/>：</td>
        <td class="${hasErrors(bean: boAcquirerAccountInstance, field: 'aliasName', 'errors')}"><g:textField name="aliasName" maxlength="40" value="${boAcquirerAccountInstance?.aliasName}"/></td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boAcquirerAccount.status.label"/>：</td>
        <td class="${hasErrors(bean: boAcquirerAccountInstance, field: 'status', 'errors')}">
          <g:select name="status" from="${BoAcquirerAccount.statusMap}" optionKey="key" optionValue="value" value="${boAcquirerAccountInstance?.status}"/>
        </td>
      </tr>
      
      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
</body>
</html>
