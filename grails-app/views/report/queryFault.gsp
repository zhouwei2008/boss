<%@ page import="boss.Perm; ismp.TradeRefund" %>
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
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">差错交易日报</h1>
    <h2>
      <g:form action="queryFault">
        日期 ：
        <g:textField name="startDate" value="${params.startDate}" size="10" class="right_top_h2_input" style="width:80px"/>
        -- <g:textField name="endDate" value="${params.endDate}" size="10" class="right_top_h2_input" style="width:80px"/>

        <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkDate()">
        <g:actionSubmit class="right_top_h2_button_serch" action="" value="清空" onclick="return empty()"/>
         <bo:hasPerm perm="${Perm.Report_FailDaily_DL}">
             <g:actionSubmit class="right_top_h2_button_download" action="queryFaultDownLoad" value="下载" onclick="return checkDate()" />
       </bo:hasPerm>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <th>日期</th>
        <th>银行编号</th>
        <th>状态</th>
        <th>交易笔数</th>
        <th>交易金额</th>
      </tr>

      <g:each in="${result}" status="i" var="item">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td>${item.DA}</td>
          <td>${item.BANK_CO}</td>
          <td>${item.STATUS}</td>
          <td>${item.CO}</td>
          <td><g:formatNumber number="${item?.AM/100}" type="currency" currencyCode="CNY"/></td>
        </tr>
      </g:each>
    </table>
    合计：交易笔数：${co}笔&nbsp;&nbsp;&nbsp;&nbsp;交易金额：${am/100}元
    <div class="paginateButtons">
      <span style=" float:left;">共${total}条记录</span>
      <g:paginat total="${total}" params="${params}"/>
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
