

<%@ page import="boss.BoDirectPayBind" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boDirectPayBind.label', default: 'boDirectPayBind')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
          <link rel="stylesheet" type="text/css" href="../ext/css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="../ext/css/style.css" />
    <script type="text/javascript" src="../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../ext/js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ext/js/common.js"></script>
    <script type="text/javascript">
          function doChooseCustomer(pCustomerNo)
          {
              var url = "popCustomer?pCustomerNo="+pCustomerNo;
              win1=new Ext.Window({
                       id:'win1',
                       title:"定向支付绑定",
                       width:680,
                       modal:true,
                       height:530,
                       html: '<iframe src='+url +' height="100%" width="100%" name="popCustomer" scrolling="auto" frameBorder="0" onLoad="Ext.MessageBox.hide();">',
                       maximizable:true
                    });
              win1.show();
          }
          function trim(s)
		  {
			return s.replace(/(^\s*)|(\s*$)/g, "");
		  }
          function checkField()
          {
               var customerNo = document.getElementById("customerNo");
               //var limiteAmount = document.getElementById("limiteAmount");
              if(trim(customerNo.value)==''){
                  alert("请选择收款客户号");
                  return false;
              }
              /*if(trim(limiteAmount.value)==''){
                  alert("请输入限额");
                  return false;
              }else{
                  if(parseFloat(trim(limiteAmount.value))<0){
                      alert("限额不能小于零");
                      return false;
                  }
              }*/
              return true;
          }

    </script>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boDirectPayBindInstance}">
    <div class="errors">
      <g:renderErrors bean="${boDirectPayBindInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" >
    <g:hiddenField name="id" value="${boDirectPayBindInstance?.id}"/>
      <g:hiddenField name="pCustomerNo" value="${boDirectPayBindInstance?.payCustomerNo}"/>
      <g:hiddenField name="pAccountNo" value="${boDirectPayBindInstance?.accountNo}"/>
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2">${message(code: 'boDirectPayBind.label', default: 'boDirectPayBind')}</th>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boDirectPayBind.accountNo.label" args="[entityName]"/>：</td>
        <td class="${hasErrors(bean: boDirectPayBindInstance, field: 'accountNo', 'errors')}">&nbsp;${boDirectPayBindInstance?.accountNo}</td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boDirectPayBind.customerNo.label" args="[entityName]"/>：</td>
        <td class="${hasErrors(bean: boDirectPayBindInstance, field: 'customerNo', 'errors')}">
            <g:textField name="customerNo" value="${boDirectPayBindInstance?.customerNo}" readonly="readonly"/>
            <img src="../images/serch_button.gif" align="middle" width="60" onclick="javascript:doChooseCustomer('${boDirectPayBindInstance?.payCustomerNo}')"/>
        </td>
      </tr>
      
     %{-- <tr>
        <td class="right label_name">限额：</td>
        <td class="${hasErrors(bean: boDirectPayBindInstance, field: 'limiteAmount', 'errors')}"><g:textField name="limiteAmount" value="${fieldValue(bean: boDirectPayBindInstance, field: 'limiteAmount')}" maxlength="16"/></td>
      </tr>--}%
      
      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定" onclick="return checkField()"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
</body>
</html>
