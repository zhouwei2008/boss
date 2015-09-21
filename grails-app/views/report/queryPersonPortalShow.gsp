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
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">个人门户报表</h1>
    <h2>
      <g:form action="queryPersonPortalShow">
        日期 ：
        <g:textField name="startDate" value="${params.startDate}" size="10" class="right_top_h2_input" style="width:80px"/>
        -- <g:textField name="endDate" value="${params.endDate}" size="10" class="right_top_h2_input" style="width:80px"/>
        <input type="submit" class="right_top_h2_button_serch" value="查询">
        <g:if test="${totalCus}"><g:actionSubmit class="right_top_h2_button_download" action="queryPersonPortalDownload" value="下载"/></g:if>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <th rowspan="2">客户数量</th>
        <th rowspan="2">初期余额</th>
        <th colspan="2">充值</th>
        <th colspan="2">支付</th>
        <th colspan="2">提现</th>
        <th colspan="2">退款</th>
        <th colspan="2">转账</th>
        <th rowspan="2">手续费收入</th>
        <th rowspan="2">银行成本</th>
        <th rowspan="2">期末余额</th>
      </tr>
      <tr>
        <th>笔数</th>
        <th>金额</th>
        <th>笔数</th>
        <th>金额</th>
        <th>笔数</th>
        <th>金额</th>
        <th>笔数</th>
        <th>金额</th>
        <th>笔数</th>
        <th>金额</th>
      </tr>
%{--[totalCus:result[1].longValue(),intBa:intBalance,
                    chargeM:result[2].longValue(),chargeC:result[3].longValue(),
                    paymentM:result[4].longValue(),paymentC:result[5].longValue(),
                    withdrawnM:result[6].longValue(),withdrawnC:result[7].longValue(),
                    refundM:result[8].longValue(),refundC:result[9].longValue(),
                    transferM:result[10].longValue(),transferC:result[11].longValue(),
                    lastBa:lastBalance]--}%
      <tr>
        <td>${totalCus !=null?totalCus>= 0 ?totalCus:"":""}</td>
        <td><g:formatNumber number="${intBa?intBa/100:0}" type="currency" currencyCode="CNY"/></td>
        <td>${chargeC}</td>
        <td><g:formatNumber number="${chargeM?chargeM/100:0}" type="currency" currencyCode="CNY"/></td>
        <td>${paymentC}</td>
        <td><g:formatNumber number="${paymentM?paymentM/100:0}" type="currency" currencyCode="CNY"/></td>
        <td>${withdrawnC}</td>
        <td><g:formatNumber number="${withdrawnM?withdrawnM/100:0}" type="currency" currencyCode="CNY"/></td>
        <td>${refundC}</td>
        <td><g:formatNumber number="${refundM?refundM/100:0}" type="currency" currencyCode="CNY"/></td>
        <td>${transferC}</td>
        <td><g:formatNumber number="${transferM?transferM/100:0}" type="currency" currencyCode="CNY"/></td>
        <td></td>
        <td></td>
        <td><g:formatNumber number="${lastBa?lastBa/100:0}" type="currency" currencyCode="CNY"/></td>
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
    %{--<div class="paginateButtons">--}%
      %{--<span style=" float:left;">共${total}条记录</span>--}%
      %{--<g:paginat total="${total}" params="${params}"/>--}%
    %{--</div>--}%
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
