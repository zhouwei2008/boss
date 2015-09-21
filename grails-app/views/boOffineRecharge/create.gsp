<%@ page import="boss.BoOfflineCharge; boss.BoRechargeTime" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boOffineCharge.label', default: 'boOffineCharge')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
     <link rel="stylesheet" type="text/css" href="../ext/css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="../ext/css/style.css" />
     <script type="text/javascript" src="../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../ext/js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ext/js/common.js"></script>

</head>
<body style="overflow-x:hidden">
<script type="text/javascript">
    function dosubmit(){
        var  accountNo= document.getElementById("accountNo").value
        var  amount= document.getElementById("amount").value
        var  realamount= document.getElementById("realamount").value
        var  note= document.getElementById("note").value
         if (accountNo.length == 0) {
            alert("账号不能为空，请选择！");
            document.getElementById("accountNo").focus();
            return false;
        }
        if (amount.length == 0||amount==0) {
                   alert("实收金额不能为为0或者为空，请填写！");
                   document.getElementById("amount").focus();
                   return false;
               }
        var patrn=/^\d+(\.\d{0,2})?$/;
        if (!patrn.exec(amount)) {
              alert("实收金额为无效金额，请重新填写！");
               document.getElementById("amount").focus();
               return false;
        }
        if (realamount.length == 0||realamount==0) {
                   alert("入账金额不能为0或者为空，请填写！");
                   document.getElementById("realamount").focus();
                   return false;
               }
        if (!patrn.exec(realamount)) {
              alert("入账金额无效金额，请重新填写！");
               document.getElementById("realamount").focus();
               return false;
        }
         if(!WidthCheck(note,250))
         {
          alert("输入的备注框长度不能超过125个汉字或者250个字符!");
          return false;
         }

        if(confirm("确定提交?")){
           document.forms[0].submit();
        }
    }

     function doChooseCustomer()
          {
              var url = "accountList?";
              win1=new Ext.Window({
                       id:'win1',
                       title:"商旅账户充值",
                       width:680,
                       modal:true,
                       height:530,
                       html: '<iframe src='+url +' height="100%" width="100%" name="popCustomer" scrolling="auto" frameBorder="0" onLoad="Ext.MessageBox.hide();">',
                       maximizable:true
                    });
              win1.show();
          }

    function WidthCheck(s, n){
        var w = 0;
        for (var i=0; i<s.length; i++) {
          var c = s.charCodeAt(i);
           //单字节加1
          if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {
          w++;
           }
          else {
           w+=2;
          }
        }
    if (w > n) {
      return false;
    }
    return true;
}
</script>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <g:hasErrors bean="${boOfflineChargeInstance}">
    <div class="errors">
      <g:renderErrors bean="${boOfflineChargeInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" name="actionForm">
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boOffineCharge.account.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'accountNo', 'errors')}">
             <g:textField id="accountNo" name="accountNo" value="${boOfflineChargeInstance?.accountNo}" readonly="readonly"/>
            <g:hiddenField id="accountName" name="accountName" value="${boOfflineChargeInstance?.accountName}" readonly="readonly"/>
            <img src="../images/serch_button.gif" align="middle" width="60" onclick="javascript:doChooseCustomer()"/>
        </td>
      </tr>
        <tr>
        <td class="right label_name"><g:message code="boOffineCharge.billmode.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'billmode', 'errors')}">
             <g:select name="billmode" from="${BoOfflineCharge.billmodeMap}" value="${boOfflineChargeInstance.billmode}" optionKey="key" optionValue="value"/>
        </td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boOffineCharge.amount.label"/>：</td>
         <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'amount', 'errors')}">
             <g:textField name="amount" maxlength="11" value="${boOfflineChargeInstance?.amount}"/><font color="red">*</font>
         </td>
      </tr>

        <tr>
        <td class="right label_name"><g:message code="boOffineCharge.trxsqe.label"/>：</td>
            <td>
                ${boOfflineChargeInstance?.trxSeq}<g:hiddenField name="trxSeq" maxlength="20" value="${boOfflineChargeInstance?.trxSeq}"/>
            </td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boOffineCharge.realamount.label"/>：</td>
          <td>
             <g:textField name="realamount" maxlength="11" value="${boOfflineChargeInstance?.realamount}"/><font color="red">*</font>
          </td>
      </tr>

          <tr>
        <td class="right label_name"><g:message code="boOffineCharge.note.label"/>：</td>
          <td>
             <g:textArea name="note"  rows="5" cols="6" value="${boOfflineChargeInstance?.note}" />
          </td>
      </tr>
      
      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="button" name="button" id="button" class="rigt_button" value="确定" onclick="dosubmit()"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
</body>
</html>
