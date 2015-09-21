

<%@ page import="account.AcAccount" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acAccount.label', default: 'AcAccount')}"/>
  <title><g:message code="acAccount.adjust.label" args="[entityName]"/></title>
    <script type="text/javascript">
        function trim(s)
		{
			return s.replace(/(^\s*)|(\s*$)/g, "");
		}

        function doAdjust()
        {
            var accReg = /^\d{16}$/;
            var fromAccountNo = document.getElementById("fromAccountNo").value;
            var toAccountNo = document.getElementById("toAccountNo").value;
            var adjustMoney = document.getElementById("adjustMoney").value;
            var remark = document.getElementById("remark").value;
            if(!accReg.test(fromAccountNo) || !accReg.test(toAccountNo))
            {
                alert("请输入正确的账户号!");
                return false;
            }else if(fromAccountNo==toAccountNo){
                alert("同一个账户号不能转账!");
                return false;
            }
            if(trim(adjustMoney)=="" || parseFloat(trim(adjustMoney))<=0 || isNaN(trim(adjustMoney)))
            {
                alert("请输入正确的金额");
                return false;
            }
            var idxDot = adjustMoney.indexOf('.');
            if(idxDot > 0){
                var behind = adjustMoney.substring(idxDot+1)
                if(behind.length > 2){
                    alert("金额请保留小数点后两位");
                    return false;
                }
            }
            if(trim(remark)=="")
            {
                alert("请输入备注信息");
                return false;
            }else if(trim(remark)!="" && trim(remark).replace(/[^\x00-\xFF]/g,'**').length>1000)
            {
                alert("备注信息最多输入1000个字符");
                return false;
            }
            document.getElementById("adjustMoney").value=trim(document.getElementById("adjustMoney").value);
            document.forms[0].submit();
        }

        function accountSearch(accountNo,type){
            $.ajax({
                type: "POST",
                url: "${createLink(action:'searchAccount',controller:'acAccount')}",
                data: "accountNo="+accountNo,
                cache: false,
                async: false,
                success: function(json){
                    var name = json.account.name;
                    var balance = json.account.balance;
                    $('#Span'+type+'AccountName').empty().append(name);
                    $('#Span'+type+'AccountBalance').empty().append(balance);
                }
            });
        }
    </script>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <g:form action="doAdjust" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="acAccount.adjust.label" args="[entityName]"/></th>
      </tr>
      
      <tr>
        <td class="right label_name">调出账号：</td>
        <td><g:textField name="fromAccountNo" maxlength="16" value="" onblur="accountSearch(this.value,'From')" /></td>
      </tr>

      <tr>
        <td>&nbsp;</td>
        <td>
            <table>
                <tr>
                    <td width="200px">名称：<span id="SpanFromAccountName"></span></td>
                    <td width="200px">余额：<span id="SpanFromAccountBalance"></span></td>
                </tr>
            </table>
        </td>
      </tr>
      
      <tr>
        <td class="right label_name">调入账号：</td>
        <td><g:textField name="toAccountNo" maxlength="16" value="" onblur="accountSearch(this.value,'To')" /></td>
      </tr>

      <tr>
        <td>&nbsp;</td>
        <td>
            <table>
                <tr>
                    <td width="200px">名称：<span id="SpanToAccountName"></span></td>
                    <td width="200px">余额：<span id="SpanToAccountBalance"></span></td>
                </tr>
            </table>
        </td>
      </tr>

      <tr>
        <td class="right label_name">调账类型：</td>
        <td>
            <g:select name="adjType" from="${adjTypeList}" optionKey="id" optionValue="name"/>
        </td>
      </tr>

      <tr>
        <td class="right label_name">金额（元）：</td>
        <td><g:textField name="adjustMoney" value="" /></td>
      </tr>

      <tr>
        <td class="right label_name">备注：</td>
        <td><g:textArea id="remark" name="remark" rows="5" cols="70"/></td>
      </tr>
      
      <tr>
        <td colspan="2" align="center">
          <span class="content"><input type="button" class="rigt_button" onclick="doAdjust()" value="确定"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
</body>
</html>
