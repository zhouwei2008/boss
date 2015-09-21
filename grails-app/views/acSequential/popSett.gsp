
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: '手续费结算', default: '手续费结算')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript" src="/js/jquery-1.4.4.min.js"></script>
    <script type="text/javascript" src="/js/json2.js"></script>
    <script type="text/javascript">
        function trim(s)
		{
			return s.replace(/(^\s*)|(\s*$)/g, "");
		}

        function doConfirm()
        {
            var validMoney = parseFloat(document.getElementById("validMoney").outerText.substring(0,document.getElementById("validMoney").outerText.length-1));
            var settFund = document.getElementById("settFund").value;
            var settMoney = parseFloat(document.getElementById("settMoney").value);
            var merchantType = document.getElementById("merchant").style.display;
            var bankValue = document.getElementById("bankList").value;
            var valRemark = document.getElementById("remark").value;

            var merchantAcc;
            if(document.getElementById("merchant").style.display==""){
                merchantAcc="0";
            }else{
                merchantAcc="1";
            }

            if(isNaN(validMoney)){
                validMoney=0;
            }
            if(isNaN(settMoney)){
                settMoney=0;
            }
            if(isNaN(trim(settFund)))
            {
                alert("结算资金必须为数字！");
                return false;
            }
            if(trim(settFund)=="" || parseFloat(trim(settFund))==0)
            {
                alert("请输入结算资金！");
                return false;
            }
            if(parseFloat(trim(settFund))>settMoney)
            {
                alert("结算资金大于要结算的总额");
                return false;
            }
            if(trim(valRemark)=="")
            {
                alert("备注不能为空");
                return false;
            }else if(trim(valRemark)!="" && trim(valRemark).replace(/[^\x00-\xFF]/g,'**').length>1000)
            {
                alert("备注只能输入1000个字符");
                return false;
            }
            if(merchantType=="")
            {
                if(parseFloat(trim(settFund))>validMoney)
                {
                    alert("结算资金不能大于商户可用余额！");
                    return false;
                }else{
                     var url = "<%=request.getContextPath()%>/acSequential/settFee";
                     jQuery.post(url,{
                            settMoney:document.getElementById("settMoney").value,
                            baAccount:document.getElementById("baAccount").value,
                            feeAccount:document.getElementById("feeAccount").value,
                            platAccount:document.getElementById("platAccount").value,
                            merFeeAccount:document.getElementById("merFeeAccount").value,
                            collAccount:bankValue,
                            settFund:trim(document.getElementById("settFund").value),
                            merchantAcc:merchantAcc,
                            remark:trim(document.getElementById("remark").value)
                            } , function (data, textStatus){
                                if(textStatus=="success")
                                {
                                    var obj = eval("("+data+")");
                                    if(obj.msg=="ok")
                                    {
                                        alert(obj.data.resultMsg);
                                        window.parent.document.forms[0].submit();
                                        winClose();
                                    }else if(obj.msg=="bad")
                                    {
                                        alert(obj.data.resultMsg);
                                        return false;
                                    }
                                }else{
                                    alert("手续费手工结算失败");
                                    return false;
                                }
                            }
                     );
                }
            }else
            {
                 if(bankValue=="-1")
                 {
                     alert("请选择收单银行！");
                     return false;
                 }else{
                     var url = "<%=request.getContextPath()%>/acSequential/settFee";
                     jQuery.post(url,{
                            settMoney:document.getElementById("settMoney").value,
                            baAccount:document.getElementById("baAccount").value,
                            feeAccount:document.getElementById("feeAccount").value,
                            platAccount:document.getElementById("platAccount").value,
                            merFeeAccount:document.getElementById("merFeeAccount").value,
                            collAccount:bankValue,
                            settFund:trim(document.getElementById("settFund").value),
                            merchantAcc:merchantAcc,
                            remark:trim(document.getElementById("remark").value)
                            } , function (data, textStatus){
                                if(textStatus=="success")
                                {
                                    var obj = eval("("+data+")");
                                    if(obj.msg=="ok")
                                    {
                                        alert(obj.data.resultMsg);
                                        window.parent.document.forms[0].submit();
                                        winClose();
                                    }else if(obj.msg=="bad")
                                    {
                                        alert(obj.data.resultMsg);
                                        return false;
                                    }
                                }else{
                                    alert("手续费手工结算失败");
                                    return false;
                                }
                            }
                     );
                 }
            }

        }
        function winClose()
        {
            window.parent.win1.close();
        }

        function selMode(nFlag)
        {
             if(nFlag=='0')
             {
                 document.getElementById("merchant").style.display="";
                 document.getElementById("bank").style.display="none";
             }else if(nFlag=='1')
             {
                 document.getElementById("merchant").style.display="none";
                 document.getElementById("bank").style.display="";
             }
        }
    </script>
  </head>
<body style="overflow-x:hidden">
<div class="main">
  <g:form action="settFee">
      <g:hiddenField id="settMoney" name="settMoney" value="${settMoney}"/>
      <g:hiddenField id="baAccount" name="baAccount" value="${baAccount}"/>
      <g:hiddenField id="feeAccount" name="feeAccount" value="${feeAccount}"/>
      <g:hiddenField id="platAccount" name="platAccount" value="${platAccount}"/>
      <g:hiddenField id="merFeeAccount" name="merFeeAccount" value="${merFeeAccount}"/>
    <table align="center" class="rigt_tebl">
      <tr>
        <td class="right label_name">收款账户：</td>
        <td>
            &nbsp;商户现金账户&nbsp;&nbsp;<input type="hidden" id="merchantAcc" name="merchantAcc" value="0"/>
            %{--<input type="radio" name="merchantAcc" value="0" checked="checked" onclick="selMode('0')"/>
            &nbsp;&nbsp;&nbsp;&nbsp;收单银行&nbsp;&nbsp;<input type="radio" name="merchantAcc" value="1" onclick="selMode('1')"/>--}%
        </td>
      </tr>
      <tr id="merchant">
        <td class="right label_name">商户可用金额：</td>
        <td id="validMoney">&nbsp;${balance}元</td>
      </tr>
      <tr id="bank" style="display:none">
        <td class="right label_name">收单银行：</td>
        <td>&nbsp;<g:select from="${bankList}" id="bankList" name="bankList" optionKey="accountNo" optionValue="accountName" noSelection="${['-1':'-请选择-']}" /></td>
      </tr>

      <tr>
        <td class="right label_name">结算资金（元）：</td>
        <td><g:textField id="settFund" name="settFund" value="" /></td>
      </tr>

      <tr>
         <td class="right label_name">备注：</td>
         <td><g:textArea id ="remark" name="remark" rows="5" cols="40"/></td>
      </tr>

      <tr>
        <td colspan="2" align="center">
          <span class="content"><input type="button" onclick="doConfirm()" class="rigt_button" value="确定"></span>
          <span class="content"><input type="button" onclick="winClose()" class="rigt_button" value="关闭"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
</body>
</html>
