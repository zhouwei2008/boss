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
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">其他业务统计报表</h1>
    <h2>
      <g:form action="queryOtherBizDailyShow">
        日期 ：
        <g:textField name="startDate" value="${params.startDate}" size="10" class="right_top_h2_input" style="width:80px"/>
        -- <g:textField name="endDate" value="${params.endDate}" size="10" class="right_top_h2_input" style="width:80px"/>
        区域 ：
        <g:textField name = "area" value="${params.area}" size="10" class="right_top_h2_input" style="width:80px"/>
        商户 ：
        <g:textField name = "bizName" value="${params.bizName}" size="10" class="right_top_h2_input" style="width:80px"/>
        <input type="submit" class="right_top_h2_button_serch" value="查询">
        <g:if test="${list?list.size():null}">
            <g:actionSubmit class="right_top_h2_button_download" action="queryOtherBizDailyDownload" value="下载"/>
        </g:if>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <th rowspan="2">区域</th>
        <th rowspan="2">商户名称</th>
        <th colspan="4">充值</th>
        <th colspan="4">提现</th>
        <th colspan="4">转账</th>
      </tr>
      <tr>
        <th>交易笔数</th>
        <th>交易净额</th>
        <th>手续费收入</th>
        <th>银行手续费成本</th>
        <th>交易笔数</th>
        <th>交易净额</th>
        <th>手续费收入</th>
        <th>银行手续费成本</th>
        <th>交易笔数</th>
        <th>交易净额</th>
        <th>手续费收入</th>
        <th>银行手续费成本</th>
      </tr>
%{--[                      t.area,
                           t.cus_accountid,
                           t.cus_name,
                           t.charge_total_count,
                           t.charge_total_amount,
                           t.charge_fee,
                           t.charge_bank_cost,
                           t.withdrawn_count,
                           t.withdrawn_amount,
                           t.withdrawn_fee,
                           t.withdrawn_bank_cost,
                           t.transfer_count,
                           t.transfer_amount,
                           t.transfer_fee,
                           t.transfer_bank_cost]--}%
       <g:each in="${list}" status="i" var="item">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>${item.get('AREA')}</td>
                    <td>${item.get('CUS_NAME')}</td>
                    <td>${item.get('CC')}</td>
                    <td><g:formatNumber number="${item.get('CS')?item.get('CS')/100:0}" type="currency" currencyCode="CNY"/></td>
                    <td>${item.get('CF')}</td>
                    <td>${item.get('CBC')}</td>
                    <td>${item.get('WC')}</td>
                    <td><g:formatNumber number="${item.get('WS')?item.get('WS')/100:0}" type="currency" currencyCode="CNY"/></td>
                    <td>${item.get('WF')}</td>
                    <td>${item.get('WBC')}</td>
                    <td>${item.get('TC')}</td>
                    <td><g:formatNumber number="${item.get('TS')?item.get('TS')/100:0}" type="currency" currencyCode="CNY"/></td>
                    <td>${item.get('TF')}</td>
                    <td>${item.get('TBC')}</td>
                </tr>
      </g:each>
      <tr>
        <td>合计</td>
        <td></td>
        <td>${cC}</td>
        <td><g:formatNumber number="${cA}" type="currency" currencyCode="CNY"/></td>
        <td>${cF}</td>
        <td>${cB}</td>
        <td>${wC}</td>
        <td><g:formatNumber number="${wA}" type="currency" currencyCode="CNY"/></td>
        <td>${wF}</td>
        <td>${wB}</td>
        <td>${tC}</td>
        <td><g:formatNumber number="${tA}" type="currency" currencyCode="CNY"/></td>
        <td>${tF}</td>
        <td>${tB}</td>
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
