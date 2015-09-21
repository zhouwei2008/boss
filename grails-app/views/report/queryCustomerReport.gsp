<%@ page import="ebank.tools.StringUtil; boss.BoBranchCompany; boss.Perm; boss.BoOfflineCharge" %>
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
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">商旅客户交易汇总报表</h1>
    <h2>
      <g:form>
        开始日期 ：
        <g:textField name="startDateCreated" value="${params.startDateCreated}" size="10" class="right_top_h2_input" style="width:80px"/>
        结束日期 ：
        <g:textField name="endDateCreated" value="${params.endDateCreated}" size="10" class="right_top_h2_input" style="width:80px"/>
        客户名称 ：
        <g:textField name="customerName" value="${params.customerName}" size="10" class="right_top_h2_input" style="width:120px"/>
        %{--客户账户号 ：--}%
        %{--<g:textField name="accountNo" value="${params.accountNo}" size="10" class="right_top_h2_input" style="width:120px"/>--}%
        分公司名称 ：
        %{--<g:select name="branchCode" from="${BoBranchCompany.list()}"  style="width:120px" value="${params.branchCode}" optionKey="id" optionValue="companyName" noSelection="${['':'-请选择-']}"/>--}%
          <g:if test="${flag}">
              <g:select name="branchCode" from="${BoBranchCompany.list()}" value="${params.branchCode}"
                        style="width:170px" optionKey="id" optionValue="companyName" noSelection="${['': '-请选择-']}"
                        disabled="true"/>
          </g:if>
          <g:if test="${flag == false}">
              <g:select name="branchCode" from="${BoBranchCompany.list()}" value="${params.branchCode}"
                        style="width:170px" optionKey="id" optionValue="companyName" noSelection="${['': '-请选择-']}"/>
          </g:if>
       <br/>
        <g:actionSubmit class="right_top_h2_button_serch" action="queryCustomerReport" value="查询"/>
        <g:actionSubmit class="right_top_h2_button_download" action="queryCustomerReportDownload" value="下载"/>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <th>&nbsp;&nbsp;区&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;域&nbsp;&nbsp;</th>
        <th>客户名称</th>
        <th>银行卡成功充值笔数</th>
        <th>银行卡成功充值金额</th>
        <th>吉高线下成功充值笔数</th>
        <th>吉高线下成功充值金额</th>
        <th>吉高线下撤销笔数</th>
        <th>吉高线下撤销金额</th>
        <th>支付笔数</th>
        <th>支付金额(-)</th>
        <th>支付退款笔数</th>
        <th>支付退款金额</th>
        <th>手续费收入</th>
        <th>应收返点</th>
        <th>银行手续费成本</th>
        <th>交易净额</th>
      </tr>

      <g:each in="${result}" status="i" var="item">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
            %{--<td>${item.get('REGION')}</td>--}%
            <td>${item.get('COMPANY_NAME')}</td>
            <td>${item.get('CUSTOMER_NAME')}</td>
            %{--<td>${item.get('CUSTOMER_NO')}</td>--}%
            <td>${item.get('ONLINE_CHARGE_COUNT')}</td>
            <td><g:formatNumber number="${item.get('ONLINE_CHARGE_SUM')?item.get('ONLINE_CHARGE_SUM')/100:0}" type="currency" currencyCode="CNY"/></td>
            <td>${item.get('OFFLINE_CHARGE_COUNT')}</td>
            <td><g:formatNumber number="${item.get('OFFLINE_CHARGE_SUM')?item.get('OFFLINE_CHARGE_SUM')/100:0}" type="currency" currencyCode="CNY"/></td>

            <td>${item.get('VOID_COUNT')}</td>
            %{--<td><g:formatNumber number="${item.get('VOID_SUM')?item.get('VOID_SUM')/-100:null}" type="currency" currencyCode="CNY"/></td>--}%
            <td>￥-${StringUtil.getAmountFromNum(String.valueOf(item.get('VOID_SUM')?item.get('VOID_SUM'):0))}</td>

            <td>${item.get('PAYMENT_COUNT')}</td>
            <td><g:formatNumber number="${item.get('PAYMENT_SUM')?item.get('PAYMENT_SUM')/100:0}" type="currency" currencyCode="CNY"/></td>

            <td>${item.get('REFUND_COUNT')}</td>
            <td><g:formatNumber number="${item.get('REFUND_SUM')?item.get('REFUND_SUM')/100:0}" type="currency" currencyCode="CNY"/></td>
            %{--<td>￥-${StringUtil.getAmountFromNum(String.valueOf(item.get('REFUND_SUM')?item.get('REFUND_SUM'):0))}</td>--}%
            <td><g:formatNumber number="${item.get('FEE_SUM')?item.get('FEE_SUM')/100:0}" type="currency" currencyCode="CNY"/></td>

            <td><g:formatNumber number="${item.get('BEBATES')?item.get('BEBATES')/100:0}" type="currency" currencyCode="CNY"/></td>

            <td><g:formatNumber number="${item.get('BANKCOSTS')?item.get('BANKCOSTS')/100:0}" type="currency" currencyCode="CNY"/></td>

            <td><g:formatNumber number="${item.get('NET_AMOUNT')?item.get('NET_AMOUNT')/100:0}" type="currency" currencyCode="CNY"/></td>

        </tr>
      </g:each>
    </table>
      %{--合计：金额总计：<g:formatNumber number="${totalAmount?totalAmount:0}" format="#.##"/>元--}%
      %{--合计：金额总计：<g:formatNumber number="${totalAmount?totalAmount/100:0}" format="#.##"/>元--}%
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
