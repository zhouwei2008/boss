<%@ page import="ebank.tools.StringUtil; ismp.TradeRefund" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="报表"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">商旅账户交易明细</h1>
    <h2>
      <g:form>
        日期 ：
        <g:textField name="startDateCreated" value="${params.startDateCreated}" size="10" class="right_top_h2_input" style="width:80px"/>
        --
        <g:textField name="endDateCreated" value="${params.endDateCreated}" size="10" class="right_top_h2_input" style="width:80px"/>
        账户号 ：
        <g:textField name="accountNo" value="${params.accountNo}" size="10" class="right_top_h2_input" style="width:120px"/>
        <g:actionSubmit class="right_top_h2_button_serch" action="queryAccountBalance" value="查询"/>
        <g:actionSubmit class="right_top_h2_button_download" action="queryAccountBalanceDownload" value="下载"/>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <th>开始日期</th>
        <th>结束日期</th>
        <th>账户号</th>
        <th>业务类型</th>
        <th>充值金额</th>
        <th>支付金额</th>
        <th>退款金额</th>
        <th>撤销金额</th>
      </tr>

      <g:each in="${result}" status="i" var="item">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

            %{--<td><g:formatDate date="${params?.startDateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>--}%
            %{--<td><g:formatDate date="${params?.endDateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>--}%
            <td>${params?.startDateCreated}</td>
            <td>${params?.endDateCreated}</td>
            <td>${item?.ACCOUNT_NO}</td>
            <td>商旅账户</td>
            <td><g:formatNumber number="${item?.V_CHARGE / 100}" type="currency" currencyCode="CNY"/></td>
            <td><g:formatNumber number="${item?.V_PAYMENT / 100}" type="currency" currencyCode="CNY"/></td>
            %{--<td>￥-${StringUtil.getAmountFromNum(String.valueOf(item.get('V_REFUND') ? item.get('V_REFUND') : 0))}</td>--}%
            <td><g:formatNumber number="${item?.V_REFUND/100}" type="currency" currencyCode="CNY"/></td>
            %{--<td><g:formatNumber number="${item?.V_VOID/-100}" type="currency" currencyCode="CNY"/></td>--}%
            <td>￥-${StringUtil.getAmountFromNum(String.valueOf(item.get('V_VOID') ? item.get('V_VOID') : 0))}</td>


            %{--<td>${item.get('V_CHARGE')}</td>--}%
          %{--<td>${item.get('V_PAYMENT')}</td>--}%
          %{--<td>${item.get('V_REFUND')}</td>--}%
        </tr>
      </g:each>
    </table>
    %{--合计：充值金额：${tv_charge/100}元&nbsp;&nbsp;&nbsp;&nbsp;支付金额：${tv_payment}元&nbsp;&nbsp;&nbsp;&nbsp;退款金额：${tv_refund/100}元--}%
    %{--合计：账户数：${total}笔&nbsp;&nbsp;&nbsp;&nbsp;充值金额：${tv_charge/100}元&nbsp;&nbsp;&nbsp;&nbsp;支付金额：${tv_payment}笔&nbsp;&nbsp;&nbsp;&nbsp;退款金额：${tv_refund/100}元--}%
    <div class="paginateButtons">
      <span style=" float:left;">共${total}条记录</span>
      <g:paginat total="${total}" params="${params}"/>
    </div>
  </div>
</div>
<script type="text/javascript">
  $(function() {
    $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });
</script>
</body>
</html>
