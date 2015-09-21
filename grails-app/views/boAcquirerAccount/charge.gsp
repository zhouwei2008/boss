<%@ page import="boss.BoAcquirerAccount" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <title>银行账户充值</title>
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
  <g:form name="updateForm">
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2">银行账户充值</th>
      </tr>

      <tr>
        <td class="right label_name">银行账户：</td>
        <td>
          <g:select name="acqId" from="${BoAcquirerAccount.findAllByStatus('normal')}" optionKey="id" optionValue="comboName" noSelection="${['':'--请选择--']}" onchange="getAcqInfo()"/>
          <span id='acqInfo'></span>
        </td>
      </tr>

      <tr>
        <td class="right label_name">充值金额：</td>
        <td><g:textField name="amount" maxlength="13" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" /></td>
      </tr>

      <tr>
        <td class="right label_name">备注：</td>
        <td><g:textArea name="notes" cols="60" rows="4" maxlength="50"/></td>
      </tr>

      <tr>
        <td colspan="2" align="center">
          <span class="button"><g:actionSubmit class="rigt_button" action="charge" value="充值"/></span>
        </td>
      </tr>
    </table>
  </g:form>
</div>
<script type="text/javascript">
  function getAcqInfo() {
    var acqId = $('#acqId').val()
    if (acqId == '') {
      $('#acqInfo').html('')
    } else {
      $.getJSON('${createLink(action:'getAcqInfo')}', {acqId: acqId, t: new Date().getTime()}, function(data) {
        $('#acqInfo').html('银行账户:' + data.bankAccountNo + ', 账户名称:' + data.bankAccountName + ', 账户余额:' + data.balance)
      })
    }
  }

  $(function() {
    $("#updateForm").validate({
      rules: {
        acqId: {required: true},
        amount: {required: true, number: true, gt: 0}
      },
      messages: {
      },
      focusInvalid: false,
      onkeyup: false
    });
  })
</script>
</body>
</html>
