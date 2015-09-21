<%@ page import="boss.BoAcquirerAccount" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <title>提现</title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <g:form name="updateForm" action="createWithdraw">
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2">客户提现</th>
      </tr>

      <tr>
        <td class="right label_name">客户号：</td>
        <td>
          <g:textField name="customerNo" maxlength="30" onchange="getCusInfo()"/>
          <span id='cusInfo'></span>
        </td>
      </tr>

      <tr>
        <td class="right label_name">提现金额：</td>
        <td><g:textField name="amount" maxlength="13" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/></td>
      </tr>

      <tr>
        <td class="right label_name">备注：</td>
        <td><g:textArea name="notes" cols="60" rows="4" maxlength="50"/></td>
      </tr>

      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="submit" class="rigt_button" value="提现"/></span>
        </td>
      </tr>
    </table>
  </g:form>
</div>
<script type="text/javascript">
  function getCusInfo() {
    var customerNo = $('#customerNo').val()
    if (customerNo == '') {
      $('#cusInfo').html('')
    } else {
      $.get('${createLink(action:'getCusInfo')}', {customerNo: customerNo, t: new Date().getTime()}, function(data) {
        $('#cusInfo').html(data)
      })
    }
  }

  $(function() {
    $.validator.addMethod("money", function(value, element) {
      return this.optional(element) || /^[0-9]+(.[0-9]{2})?$/.test(value);
    }, '请输入正确的金额!');

    $("#updateForm").validate({
      rules: {
        customerNo: {required: true},
        amount: {required: true, number: true, gt: 0, money:true}
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
