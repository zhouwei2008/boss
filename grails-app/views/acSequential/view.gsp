<%@ page import="account.AcTransaction" %>

<%--
  Created by IntelliJ IDEA.
  User: SunWeiGuo
  Date: 12-8-10
  Time: 下午4:31
  To change this template use File | Settings | File Templates.
--%>

<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'acSequential.label', default: 'acSequential')}"/>
    <title><g:message code="default.view.label" args="[entityName]"/></title>
</head>
    <body style="overflow-x:hidden">
        <div class="center">
             <table align="center" class="rigt_tebl">
                 <tr>
                    <th colspan="2">详细信息</th>
                 </tr>

                 <tr>
                    <td class="right label_name">凭证码：</td>
                    <td><span class="rigt_tebl_font">${acSeq?.transaction?.transactionCode}</span></td>
                 </tr>

                 <tr>
                     <td class="right label_name">交易时间：</td>
                     <td><span class="right_tebl_font"><g:formatDate date="${acSeq.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span> </td>
                 </tr>

                 <tr>
                     <td class="right label_name">交易类型：</td>
                     <td>${AcTransaction.transTypeMap[acSeq.transaction?.transferType]}</td>
                 </tr>

                 <tr>
                     <td class="right label_name">服务类型：</td>
                     <td>${AcTransaction.srvTypeMap[acSeq?.transaction?.srvType]}</td>
                 </tr>

                 <tr>
                     <td class="right label_name">交易流水号：</td>
                     <td>${acSeq?.transaction?.tradeNo}</td>
                 </tr>

                  <tr>
                     <td class="right label_name">外部订单号：</td>
                     <td>${acSeq?.transaction?.outTradeNo}</td>
                 </tr>

                  <tr>
                     <td class="right label_name">账户号：</td>
                     <td>${fieldValue(bean: acSeq, field: "accountNo")}</td>
                 </tr>

                 <tr>
                     <td class="right label_name">账户名称：</td>
                     <td>${acSeq?.account?.accountName}</td>
                 </tr>

                  <tr>
                     <td class="right label_name">借记金额：</td>
                     <td><g:formatNumber number="${acSeq.debitAmount/100}" type="currency" currencyCode="CNY"/></td>
                 </tr>

                  <tr>
                     <td class="right label_name">贷记金额：</td>
                     <td><g:formatNumber number="${acSeq.creditAmount/100}" type="currency" currencyCode="CNY"/></td>
                 </tr>

                  <tr>
                     <td class="right label_name">本期余额：</td>
                     <td><g:formatNumber number="${acSeq.balance/100}" type="currency" currencyCode="CNY"/></td>
                 </tr>

                 <tr>
                    <td colspan="2" align="center">
                        <g:form>
                            <g:hiddenField name="id" value="${acSeq?.id}"/>
                            <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                        </g:form>
                    </td>
                 </tr>
             </table>
         </div>
    </body>
</html>