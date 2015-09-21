<%@ page import="boss.BoAcquirerAccount" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <title>银行账户转账</title>
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
    <g:hiddenField name="bal"/>
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2">银行账户转账</th>
      </tr>

      <tr>
        <td class="right label_name">转出银行账户：</td>
        <td>
          <g:select name="fromAcqId" from="${BoAcquirerAccount.findAllByStatus('normal')}" optionKey="id" optionValue="comboName" noSelection="${['':'--请选择--']}" onchange="getAcqInfo(this, '#fromAcqInfo')"/>
          <span id='fromAcqInfo'></span>
        </td>
      </tr>

      <tr>
        <td class="right label_name">转入银行账户：</td>
        <td>
          <g:select name="toAcqId" from="${BoAcquirerAccount.findAllByStatus('normal')}" optionKey="id" optionValue="comboName" noSelection="${['':'--请选择--']}" onchange="getAcqInfo(this, '#toAcqInfo')"/>
          <span id='toAcqInfo'></span>
        </td>
      </tr>

      <tr>
        <td class="right label_name">转账金额：</td>
        <td><g:textField name="amount" maxlength="30"/></td>
      </tr>

      <tr>
        <td class="right label_name">备注：</td>
        <td><g:textArea name="notes" cols="60" rows="4" maxlength="50"/></td>
      </tr>

      <tr>
        <td colspan="2" align="center">
          <span class="button"><g:actionSubmit class="rigt_button" action="transfer" value="转账"/></span>
        </td>
      </tr>
    </table>
  </g:form>
</div>
<script type="text/javascript">
  function getAcqInfo(inp, msgElem) {
    var acqId = $(inp).val()
    if (acqId == '') {
      $(msgElem).html('')
    } else {
      $.getJSON('${createLink(action:'getAcqInfo')}', {acqId: acqId, t: new Date().getTime()}, function(data) {
        $(msgElem).html('银行账户:' + data.bankAccountNo + ', 账户名称:' + data.bankAccountName + ', 账户余额:' + data.balance)
        if (msgElem == '#fromAcqInfo') {
          $('#bal').val(data.balanceNum)
        }
      })
    }
  }

  $(function() {
    $("#updateForm").validate({
      rules: {
        fromAcqId: {required: true},
        toAcqId: {required: true, neFd: '#fromAcqId'},
        amount: {required: true, number: true, gt: 0, maxFd: '#bal'}
      },
      messages: {
        amount:{maxFd : "转账金额不能超过转出账户余额"},
        toAcqId:{neFd : "转入账户不能和转出账户相同"}
      },
      focusInvalid: false,
      onkeyup: false
    });
  })
</script>
</body>
</html>
