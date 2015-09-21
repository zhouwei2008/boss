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
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">商旅商户交易汇总报表</h1>
    <h2>
        <g:form>
        开始日期 ：
        <g:textField name="startDateCreated" value="${params.startDateCreated}" size="10" class="right_top_h2_input" style="width:80px"/>
        结束日期 ：
        <g:textField name="endDateCreated" value="${params.endDateCreated}" size="10" class="right_top_h2_input" style="width:80px"/>
        商户名称 ：
        <g:textField name="merchantName" value="${params.merchantName}" size="10" class="right_top_h2_input" style="width:120px"/>
        %{--商户账户号 ：--}%
        %{--<g:textField name="accountNo" value="${params.accountNo}" size="10" class="right_top_h2_input" style="width:80px"/>--}%
        分公司名称 ：
        %{--<g:select name="branchCode" from="${BoBranchCompany.list()}"  style="width:170px" value="${params.branchCode}" optionKey="id" optionValue="companyName" noSelection="${['':'-请选择-']}"/>--}%
            <g:if test="${flag}">
                <g:select name="branchCode" from="${BoBranchCompany.list()}" value="${params.branchCode}"
                          style="width:170px" optionKey="id" optionValue="companyName" noSelection="${['': '-请选择-']}"
                          disabled="true"/>
            </g:if>
            <g:if test="${flag == false}">
                <g:select name="branchCode" from="${BoBranchCompany.list()}" value="${params.branchCode}"
                          style="width:170px" optionKey="id" optionValue="companyName" noSelection="${['': '-请选择-']}"/>
            </g:if>
        <BR/>
        <g:actionSubmit class="right_top_h2_button_serch" action="queryMerchantReport" value="查询"/>
        <g:actionSubmit class="right_top_h2_button_download" action="queryMerchantReportDownload" value="下载"/>
        </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">


      <tr>
        <th>&nbsp;&nbsp;区&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;域&nbsp;&nbsp;</th>
        <th>商户名称</th>
        <th>支付笔数</th>
        <th>支付金额</th>
        <th>支付退款笔数</th>
        <th>支付退款金额(-)</th>
        <th>手续费收入</th>
        <th>应收返点</th>
        <th>银行手续费成本</th>
        <th>交易净额</th>
      </tr>

      <g:each in="${result}" status="i" var="item">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
            <td>${item.get('COMPANY_NAME')}</td>
            <td>${item.get('MERCHANT_NAME')}</td>
            <td>${item.get('PAYMENT_COUNT')}</td>
            <td><g:formatNumber number="${item.get('PAYMENT_SUM')?item.get('PAYMENT_SUM')/100:0}" type="currency" currencyCode="CNY"/></td>
            <td>${item.get('REFUND_COUNT')}</td>
            <td><g:formatNumber number="${item.get('REFUND_SUM')?item.get('REFUND_SUM')/100:0}" type="currency" currencyCode="CNY"/></td>
            %{--<td>￥-${StringUtil.getAmountFromNum(String.valueOf(item.get('REFUND_SUM')?item.get('REFUND_SUM'):0))}</td>--}%
            <td><g:formatNumber number="${item.get('FEE')?item.get('FEE')/100:0}" type="currency" currencyCode="CNY"/></td>
            <td><g:formatNumber number="${item.get('REBATES')?item.get('REBATES')/100:0}" type="currency" currencyCode="CNY"/></td>
            <td><g:formatNumber number="${item.get('BANKCOSTS')?item.get('BANKCOSTS')/100:0}" type="currency" currencyCode="CNY"/></td>
            %{--<td>${item.get('NET_AMOUNT')}</td>--}%
            <td><g:formatNumber number="${item.get('NET_AMOUNT')?item.get('NET_AMOUNT')/100:0}" type="currency" currencyCode="CNY"/></td>
        </tr>
      </g:each>
    </table>
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
