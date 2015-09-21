<%@ page import="boss.BoBranchCompany; boss.Perm; boss.BoOfflineCharge" %>
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
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">商旅账户充值明细</h1>
    <h2>
      <g:form>
        开始日期 ：
        <g:textField name="startDateCreated" value="${params.startDateCreated}" size="10" class="right_top_h2_input" style="width:80px"/>
        结束日期 ：
        <g:textField name="endDateCreated" value="${params.endDateCreated}" size="10" class="right_top_h2_input" style="width:80px"/>
        账户号 ：
        <g:textField name="accountNo" value="${params.accountNo}" size="10" class="right_top_h2_input" style="width:120px"/>
        <BR/>
        实收金额 ：
        <g:textField name="realamount" value="${params.realamount}" size="10" class="right_top_h2_input" style="width:80px"/>
        充值凭证号 ：
        <g:textField name="recepit" value="${params.recepit}" size="10" class="right_top_h2_input" style="width:80px"/>
        外部参考号 ：
        <g:textField name="billref" value="${params.billref}" size="10" class="right_top_h2_input" style="width:80px"/>

        分公司名称 ：
      %{--<g:select name="branchCode" from="${BoBranchCompany.list()}"  style="width:170px" value="${params.branchCode}" optionKey="id" optionValue="companyName" noSelection="${['':'-全部-']}"/>--}%
          <g:if test="${flag}">
              <g:select name="branchcode" from="${BoBranchCompany.list()}" value="${params.branchcode}"
                        style="width:170px" optionKey="id" optionValue="companyName" noSelection="${['': '-请选择-']}"
                        disabled="true"/>
          </g:if>
          <g:if test="${flag == false}">
              <g:select name="branchcode" from="${BoBranchCompany.list()}" value="${params.branchcode}"
                        style="width:170px" optionKey="id" optionValue="companyName" noSelection="${['': '-请选择-']}"/>
          </g:if>
        %{--<g:textField name="branchcode" value="${params.branchcode}" size="10" class="right_top_h2_input" style="width:80px"/>--}%
        %{--<g:select name="branchcode" from="${BoBranchCompany.list()}"  style="width:170px" value="${params.branchcode}" optionKey="id" optionValue="companyName" noSelection="${['':'-请选择-']}"/>--}%
        <g:actionSubmit class="right_top_h2_button_serch" action="queryCharge" value="查询"/>
        %{--<input type="submit" class="right_top_h2_button_serch" ac value="查询">--}%
        %{--<g:select name="downloadType" from="${['csv':'下载为csv格式', 'xls':'下载为xls格式']}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" value="params.downloadType"/>--}%
        <g:actionSubmit class="right_top_h2_button_download" action="queryChargeDownload" value="下载"/>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">


      <tr>
        <th>账户号</th>
        <th>操作类型</th>
        <th>支付方式</th>
        <th>币种</th>
        <th>充值金额</th>
        <th>实收金额</th>
        <th>交易状态</th>
        <th>录入时间</th>
        <th>审核时间</th>
        <th>操作员</th>
        <th>审核员</th>
        <th>分公司名称</th>
        <th>充值凭证编号</th>
        <th>外部参考编号</th>
        <th>是否开票</th>
        <th>发票抬头</th>
        <th>发票地址</th>
        <th>发票联系人</th>
        <th>发票邮编</th>
        <th>发票联系电话</th>
        <th>备注</th>
      </tr>

      <g:each in="${result}" status="i" var="item">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td>${item.get('ACCOUNT_NO')}</td>
          <td>${BoOfflineCharge.trxtypeMap[item.get('TRXTYPE')]}</td>
          <td>${BoOfflineCharge.billmodeMap[item.get('BILLMODE')]}</td>
          <td>CNY</td>
          <td><g:formatNumber number="${item.get('AMOUNT')?item.get('AMOUNT')/100:null}" type="currency" currencyCode="CNY"/></td>
          <td><g:formatNumber number="${item.get('REALAMOUNT')?item.get('REALAMOUNT')/100:null}" type="currency" currencyCode="CNY"/></td>
          <td>${BoOfflineCharge.statusMap[item.get('STATUS')]}</td>
          <td><g:formatDate date="${item.get('CREATEDATE')}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td><g:formatDate date="${item.get('AUTHDATE')}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td>${item.get('CREATOR_NAME')}</td>
          <td>${item.get('AUTHOR_NAME')}</td>
          <td>${item.get('BRANCHNAME')}</td>
          <td>${item.get('RECEPIT')}</td>
          <td>${item.get('BILLREF')}</td>
          <td> </td>
          <td> </td>
          <td> </td>
          <td> </td>
          <td> </td>
          <td> </td>
          <td> </td>

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
