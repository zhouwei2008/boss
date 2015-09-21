
<%@ page import="account.AcTransaction; account.AcSequential" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acSequential.label', default: 'AcSequential')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>

  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
    </tr>

    <tr>
      <td class="right label_name">凭证码：</td>
      <td><span class="rigt_tebl_font">${acSequentialInstance?.transaction?.transactionCode}</span></td>
    </tr>

    <tr>
      <td class="right label_name">交易类型：</td>
      <td><span class="rigt_tebl_font">${AcTransaction.transTypeMap[acSequentialInstance?.transaction?.transferType]}</span></td>
    </tr>

    <tr>
      <td class="right label_name">外部交易流水号：</td>
      <td><span class="rigt_tebl_font">${acSequentialInstance?.transaction?.tradeNo}</span></td>
    </tr>

    <tr>
      <td class="right label_name">外部订单号：</td>
      <td><span class="rigt_tebl_font">${acSequentialInstance?.transaction?.outTradeNo}</span></td>
    </tr>

    <tr>
      <td class="right label_name"><g:message code="acSequential.accountNo.label"/>：</td>
      <td><span class="rigt_tebl_font">${fieldValue(bean: acSequentialInstance, field: "accountNo")}</span></td>
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="acSequential.debitAmount.label"/>：</td>
      <td><span class="rigt_tebl_font"><g:formatNumber number="${acSequentialInstance.debitAmount/100}" type="currency" currencyCode="CNY"/></span></td>
    </tr>

    <tr>
      <td class="right label_name"><g:message code="acSequential.creditAmount.label"/>：</td>
      <td><span class="rigt_tebl_font"><g:formatNumber number="${acSequentialInstance.creditAmount/100}" type="currency" currencyCode="CNY"/></span></td>
    </tr>

    <tr>
      <td class="right label_name"><g:message code="acSequential.balance.label"/>：</td>
      <td><span class="rigt_tebl_font"><g:formatNumber number="${acSequentialInstance.balance/100}" type="currency" currencyCode="CNY"/></span></td>
    </tr>

    <tr>
      <td class="right label_name"><g:message code="acSequential.preBalance.label"/>：</td>
      <td><span class="rigt_tebl_font"><g:formatNumber number="${acSequentialInstance.preBalance/100}" type="currency" currencyCode="CNY"/></span></td>
    </tr>

    <tr>
      <td class="right label_name"><g:message code="acSequential.dateCreated.label"/>：</td>
      <td><span class="rigt_tebl_font"><g:formatDate date="${acSequentialInstance.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
    </tr>

    <tr>
      <td class="right label_name">事务摘要：</td>
      <td><span class="rigt_tebl_font">${acSequentialInstance?.transaction?.subjict?.encodeAsHTML()}</span></td>
    </tr>

    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${acSequentialInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>