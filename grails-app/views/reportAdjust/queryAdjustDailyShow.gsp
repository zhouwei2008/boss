<%@ page import="ismp.TradeRefund" %>
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
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">调账类统计报表</h1>
    <h2>
      <g:form action="queryAdjustDailyShow">
        日期 ：
        <g:textField name="startDate" value="${params.startDate}" size="10" class="right_top_h2_input" style="width:80px"/>
        -- <g:textField name="endDate" value="${params.endDate}" size="10" class="right_top_h2_input" style="width:80px"/>
        <input type="submit" class="right_top_h2_button_serch" value="查询">
        <g:if test="${list?list.size():null}"><g:actionSubmit class="right_top_h2_button_download" action="queryAdjustDailyDownload" value="下载"/></g:if>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
        <th>借记账户调账金额合计</th>
        <th>贷记账户调账金额</th>
        <th>平台手续费已收</th>
        <th>银行手续费</th>
        <th>银行调账充值账户</th>
        <th>银行调账提款账户</th>
        <th>借记账户其他合计</th>
        <th>贷记账户其他合计</th>
      </tr>
      <g:each in="${list}" status="i" var="item">
          <tr>
              %{--t.debit_adjust_amount,--}%
                           %{--t.credit_adjust_amount,--}%
                           %{--t.plat_fee,--}%
                           %{--t.bank_fee,--}%
                           %{--t.bank_adjust_charge,--}%
                           %{--t.bank_ajust_withdrawn,--}%
                           %{--t.debit_sum,--}%
                           %{--t.credit_sum,--}%
            <td>${item.get('DC')}</td>
            <td><g:formatNumber number="${item.get('DEBIT_ADJUST_AMOUNT')?item.get('DEBIT_ADJUST_AMOUNT')/100:0}" type="currency" currencyCode="CNY"/></td>
            <td><g:formatNumber number="${item.get('CREDIT_ADJUST_AMOUNT')?item.get('CREDIT_ADJUST_AMOUNT')/100:0}" type="currency" currencyCode="CNY"/></td>
            <td><g:formatNumber number="${item.get('PLAT_FEE')?item.get('PLAT_FEE')/100:0}" type="currency" currencyCode="CNY"/></td>
            <td>${item.get('BANK_FEE')}</td>
            <td><g:formatNumber number="${item.get('BANK_ADJUST_CHARGE')?item.get('BANK_ADJUST_CHARGE')/100:0}" type="currency" currencyCode="CNY"/></td>
            <td><g:formatNumber number="${item.get('BANK_ADJUST_WITHDRAWN')?item.get('BANK_ADJUST_WITHDRAWN')/100:0}" type="currency" currencyCode="CNY"/></td>
            <td>${item.get('DEBIT_SUM')}</td>
            <td>${item.get('CREDIT_SUM')}</td>
          </tr>

      </g:each>
%{--[totalCus:result[1].longValue(),intBa:intBalance,
                    chargeM:result[2].longValue(),chargeC:result[3].longValue(),
                    paymentM:result[4].longValue(),paymentC:result[5].longValue(),
                    withdrawnM:result[6].longValue(),withdrawnC:result[7].longValue(),
                    refundM:result[8].longValue(),refundC:result[9].longValue(),
                    transferM:result[10].longValue(),transferC:result[11].longValue(),
                    lastBa:lastBalance]--}%



          <tr>
            <td>合计</td>
            <td><g:formatNumber number="${dA}" type="currency" currencyCode="CNY"/></td>
            <td><g:formatNumber number="${cA}" type="currency" currencyCode="CNY"/></td>
            <td><g:formatNumber number="${pF}" type="currency" currencyCode="CNY"/></td>
            <td>${bF}</td>
            <td><g:formatNumber number="${bAC}" type="currency" currencyCode="CNY"/></td>
            <td><g:formatNumber number="${bAW}" type="currency" currencyCode="CNY"/></td>
            <td>${dS}</td>
            <td>${cS}</td>
          </tr>



      %{--<g:each in="${result}" status="i" var="item">--}%
        %{--<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">--}%
          %{--<td>${item.DA}</td>--}%
          %{--<td>${item.IN_CO}</td>--}%
          %{--<td><g:formatNumber number="${item?.IN_AM/100}" type="currency" currencyCode="CNY"/></td>--}%
          %{--<td>${item.OUT_CO}</td>--}%
          %{--<td><g:formatNumber number="${item?.OUT_AM/100}" type="currency" currencyCode="CNY"/></td>--}%
        %{--</tr>--}%
      %{--</g:each>--}%
    </table>
    %{--合计：收入手续费笔数：${in_co}笔&nbsp;&nbsp;&nbsp;&nbsp;收入手续费金额：${in_am/100}元&nbsp;&nbsp;&nbsp;&nbsp;返回手续费笔数：${out_co}笔&nbsp;&nbsp;&nbsp;&nbsp;返回手续费金额：${out_am/100}元--}%
    <div class="paginateButtons">
      <span style=" float:left;">共${total?total:0}条记录</span>
      <g:paginat total="${total?total:0}" params="${params}"/>
    </div>
  </div>
</div>
<script type="text/javascript">
  $(function() {
    $("#startDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#endDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });
</script>
</body>
</html>
