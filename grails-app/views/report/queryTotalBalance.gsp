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
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">商旅账户余额明细</h1>
    <h2>
      <g:form>
        日期 ：
        <g:textField name="startDateCreated" value="${params.startDateCreated}" size="10" class="right_top_h2_input" style="width:80px"/>
        --
        <g:textField name="endDateCreated" value="${params.endDateCreated}" size="10" class="right_top_h2_input" style="width:80px"/>
        %{--账户类型 ：--}%
        %{--<g:select name="downloadType" from="${['xls':'商旅账户']}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" value="params.downloadType"/>--}%
        <g:actionSubmit class="right_top_h2_button_serch" action="queryTotalBalance" value="查询"/>
        <g:actionSubmit class="right_top_h2_button_download" action="queryTotalBalanceDownload" value="下载"/>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <th>日期</th>
        <th>账户类型(商旅账户)</th>
        <th>累计充值</th>
        <th>累计撤销</th>
        <th>累计消费</th>
        <th>累计退款</th>
        <th>累计转账(上调)</th>
        <th>累计转账(下调)</th>
        <th>手续费</th>
        <th>余额</th>
      </tr>

      <g:each in="${result}" status="i" var="item">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td>${item.get('SETTLE_DATE')}</td>
          <td>商旅商户</td>

          <td><g:formatNumber number="${item.get('CHARGE_TOTAL')?item.get('CHARGE_TOTAL')/100:0}" type="currency" currencyCode="CNY"/></td>
          %{--<td><g:formatNumber number="${item.get('VOIDS_TOTAL')?item.get('VOIDS_TOTAL')/-100:null}" type="currency" currencyCode="CNY"/></td>--}%
            <td>￥-${StringUtil.getAmountFromNum(String.valueOf(item.get('VOIDS_TOTAL')?item.get('VOIDS_TOTAL'):0))}</td>
          <td><g:formatNumber number="${item.get('PAYMENT_TOTAL')?item.get('PAYMENT_TOTAL')/100:0}" type="currency" currencyCode="CNY"/></td>
          <td><g:formatNumber number="${item.get('REFUND_TOTAL')?item.get('REFUND_TOTAL')/100:0}" type="currency" currencyCode="CNY"/></td>
            %{--<td>￥-${StringUtil.getAmountFromNum(String.valueOf(item.get('REFUND_TOTAL')?item.get('REFUND_TOTAL'):0))}</td>--}%
          <td><g:formatNumber number="${item.get('UP_TRANSFER_TOTAL')?item.get('UP_TRANSFER_TOTAL')/100:0}" type="currency" currencyCode="CNY"/></td>
          <td><g:formatNumber number="${item.get('DOWN_TRANSFER_TOTAL')?item.get('DOWN_TRANSFER_TOTAL')/100:0}" type="currency" currencyCode="CNY"/></td>
            %{--<td>￥-${StringUtil.getAmountFromNum(String.valueOf(item.get('DOWN_TRANSFER_TOTAL')?item.get('DOWN_TRANSFER_TOTAL'):0))}</td>--}%
          <td><g:formatNumber number="${item.get('FEE_TOTAL')?item.get('FEE_TOTAL')/100:0}" type="currency" currencyCode="CNY"/></td>
          <td><g:formatNumber number="${item.get('BALANCE_TOTAL')?item.get('BALANCE_TOTAL')/100:0}" type="currency" currencyCode="CNY"/></td>
        </tr>
      </g:each>
    </table>
    %{--合计：收入手续费笔数：${in_co}笔&nbsp;&nbsp;&nbsp;&nbsp;收入手续费金额：${in_am/100}元&nbsp;&nbsp;&nbsp;&nbsp;返回手续费笔数：${out_co}笔&nbsp;&nbsp;&nbsp;&nbsp;返回手续费金额：${out_am/100}元--}%
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
