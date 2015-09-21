<%@ page import="ebank.tools.StringUtil; ismp.CmCustomer; ismp.TradeBase; boss.BoBranchCompany; boss.Perm; boss.BoOfflineCharge" %>
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
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">商旅账户交易明细表</h1>
    <h2>
        <g:form>
            开始日期(提交时间) ：
            <g:textField name="startDateCreated" value="${params.startDateCreated}" size="10" class="right_top_h2_input" style="width:80px"/>
            结束日期(提交时间) ：
            <g:textField name="endDateCreated" value="${params.endDateCreated}" size="10" class="right_top_h2_input" style="width:80px"/>
            开始日期(完成时间) ：
            <g:textField name="startDateCompleted" value="${params.startDateCompleted}" size="10" class="right_top_h2_input" style="width:80px"/>
            结束日期(完成时间) ：
            <g:textField name="endDateCompleted" value="${params.endDateCompleted}" size="10" class="right_top_h2_input" style="width:80px"/>
            <BR/>
            客户名称 ：
            <g:textField name="merchantName" value="${params.merchantName}" size="10" class="right_top_h2_input" style="width:120px"/>
            客户账户号 ：
            <g:textField name="accountNo" value="${params.accountNo}" size="10" class="right_top_h2_input" style="width:80px"/>
            分公司名称 ：
            %{--<g:select name="branchCode" from="${BoBranchCompany.list()}"  style="width:170px" value="${params.branchCode}" optionKey="id" optionValue="companyName" noSelection="${['':'-全部-']}"/>--}%
            <g:if test="${flag}">
                <g:select name="branchCode" from="${BoBranchCompany.list()}" value="${params.branchCode}"
                          style="width:170px" optionKey="id" optionValue="companyName" noSelection="${['': '-请选择-']}"
                          disabled="true"/>
            </g:if>
            <g:if test="${flag == false}">
                <g:select name="branchCode" from="${BoBranchCompany.list()}" value="${params.branchCode}"
                          style="width:170px" optionKey="id" optionValue="companyName" noSelection="${['': '-请选择-']}"/>
            </g:if>
            交易类型 :
            <g:select name="paymentType" from="${TradeBase.tradeTypeMap}"  style="width:170px" value="${params.paymentType}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}"/>
            <BR/>
            交易净额 :
            <g:textField name="tradeAmount" value="${params.tradeAmount}" size="10" class="right_top_h2_input" style="width:80px"/>

            交易流水号 :
            <g:textField name="tradeNo" value="${params.tradeNo}" size="10" class="right_top_h2_input" style="width:80px"/>
            %{--外部凭证号 :--}%
            %{--<g:textField name="outTradeNo" value="${params.outTradeNo}" size="10" class="right_top_h2_input" style="width:80px"/>--}%
            交易状态 :
            <g:select name="status" from="${TradeBase.statusMap}"  style="width:170px" value="${params.status}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}"/>
            <BR/>
            <g:actionSubmit class="right_top_h2_button_serch" action="queryFundDetailsReport" value="查询"/>
          <g:actionSubmit class="right_top_h2_button_download" action="queryFundDetailsReportDownload" value="下载"/>
         </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <th>交易流水号</th>
        <th>客户编号</th>
        <th>客户名称</th>
        <th>账户类型</th>
        <th>客户账户</th>
        <th>受理机构编号</th>
        <th>受理机构名称</th>
        <th>受理机构账户</th>
        <th>交易类型</th>
        <th>交易金额</th>
        <th>手续费</th>
        <th>支付方式</th>
        <th>客户账户余额</th>
        <th>交易提交时间</th>
        <th>交易完成时间</th>
        <th>交易状态</th>
        <th>分公司名称</th>
        <th>操作员</th>
        <th>外部交易流水号</th>
        <th>备注</th>
      </tr>

      <g:each in="${result}" status="i" var="item">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td>${item.get('TRADE_NO')}</td>
          <td>${item.get('CUSTOMER_NO')}</td>
          <td>${item.get('CUSTOMER_NAME')}</td>
          %{--<td>${item.get('CUSTOMER_TYPE')}</td>--}%
            <td>${CmCustomer.typeMap[item.get('CUSTOMER_TYPE')]}</td>
          <td>${item.get('CUSTOMER_ACCOUNT')}</td>
          <td>${item.get('ACCEPT_ORG_NO')}</td>
          <td>${item.get('ACCEPT_ORG_NAME')}</td>
          <td>${item.get('ACCEPT_ORG_ACCOUNT')}</td>
          <td>${TradeBase.tradeTypeMap[item.get('TRADE_TYPE')]}</td>
            <g:if test="${item.get('TRADE_TYPE') == 'void'}">
                %{--<td><g:formatNumber number="${item.get('NET_AMOUNT')?item.get('NET_AMOUNT')/-100:null}" type="currency" currencyCode="CNY"/></td>--}%
                <td>￥-${StringUtil.getAmountFromNum(String.valueOf(item.get('NET_AMOUNT')?item.get('NET_AMOUNT'):0))}</td>
            </g:if>
            <g:else>
                %{--<td><g:formatNumber number="${item.get('NET_AMOUNT')?item.get('NET_AMOUNT')/100:null}" type="currency" currencyCode="CNY"/></td>--}%
                <td>￥${StringUtil.getAmountFromNum(String.valueOf(item.get('NET_AMOUNT')?item.get('NET_AMOUNT'):0))}</td>
            </g:else>

          <td><g:formatNumber number="${item.get('FEE')?item.get('FEE')/100:null}" type="currency" currencyCode="CNY"/></td>
          <td>${TradeBase.paymentTypeMap[item.get('PAYMENT_TYPE')]}</td>
            %{--<td><g:formatNumber number="${item.get('CUSTOMER_BALANCE')?item.get('CUSTOMER_BALANCE')/100:null}" type="currency" currencyCode="CNY"/></td>--}%
            <td>￥${StringUtil.getAmountFromNum(String.valueOf(item.get('CUSTOMER_BALANCE')?item.get('CUSTOMER_BALANCE'):0))}</td>
          <td><g:formatDate date="${item.get('CREATE_DATE')}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td><g:formatDate date="${item.get('LAST_UPDATED')}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td>${TradeBase.statusMap[item.get('TRADE_STATUS')]}</td>
          <td>${item.get('BRANCH_NAME')}</td>
          <td>${item.get('OPER_NAME')}</td>
          <td>${item.get('OUT_TRADE_NO')}</td>
          <td>${item.get('TRADE_NOTE')}</td>
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
    $("#startDateCompleted").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#endDateCompleted").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });
</script>
</body>
</html>
