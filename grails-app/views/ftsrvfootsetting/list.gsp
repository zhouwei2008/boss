<%@ page import="boss.Perm; settle.FtSrvFootSetting" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8;pageEncoding=GBK"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'ftsrvfootsetting.label', default: 'FtTradeFee')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
    <h2>
      <g:form>
        商户编码：${customerNo}
        商户名称：${customerName}
      </g:form>
      <g:form>
        <g:hiddenField name="customerNo" value="${customerNo}"/>
        <g:hiddenField name="customerName" value="${customerName}"/>
        业务类型：<g:select name="srvcode" value="${params.srvcode}" from="${bTypeList}" optionKey="srvCode" optionValue="srvName" noSelection="${['':'-全部-']}" class="right_top_h2_input"/>
        <g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询"/>
      %{--<input type="button" class="right_top_h2_button_serch" onclick="window.location.href = '${createLink(controller:'ftTradeFee', action:'list', params:['customer.id':ff?.id,'customerNo':customerNo,'customerName':customerName])}'" value="查询"/>--}%
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>

        <th>业务类型</th>
        <th>交易类型</th>
        <th>结算周期</th>
        <th>周期内频率</th>
        <th>结算日期</th>
        <th>风险预存期</th>
        <th>最低结算金额</th>
        <th>结算单审核</th>
        <th>提现方式</th>
        <th>操作</th>
      </tr>

      <g:each in="${ftTradeFeeList}" status="i" var="item">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td>${item.SRV_NAME}</td>
          <td>${item.TRADE_NAME}</td>
          <td>
            <% if (item.FOOT_TYPE != null) { %>
            ${FtSrvFootSetting.tradeTypeMap[item.FOOT_TYPE.intValue().toString()]}
            <% } %>
          </td>
          <td>
            <% if (item.FOOT_TIMES != null && item.FOOT_TYPE.intValue().toString() == '0') { %>
            ${FtSrvFootSetting.tradeTypeMap[item.FOOT_TIMES.intValue().toString()]}
            <% } else { %>
            ${item.FOOT_TIMES}
            <% } %>

          </td>
          <td>${item.FOOT_EXPR}</td>
          <td>${item.MORT_DAY}</td>
          <td>${item.FOOT_AMOUNT}</td>
          <td>
            <% if (item.TYPE != null) { %>
            ${FtSrvFootSetting.typeMap[item.TYPE.toString()]}
            <% } %>

          </td>
          <td>
            <% if (item.WITHDRAW != null) { %>
            ${FtSrvFootSetting.withdrawMap[item.WITHDRAW.toString()]}
            <% } %>

          </td>
          <td><bo:hasPerm perm="${Perm.Settle_Cycle_Edit}" ><input type="button" onclick="window.location.href = '${createLink(controller:'ftsrvfootsettingUpdate', action:'list', params:['customer.id':ff?.id,'customerNo':customerNo,'customerName':customerName,'srvcode':item.SRVID,'tradeid':item.TRADEID,'srv':item.SRV_CODE])}'" value="修改"/></bo:hasPerm></td>
        </tr>
      </g:each>
    </table>

  </div>
</div>
<div class="paginateButtons">
  <div align="left"><div style="position:absolute;">共${ftTradeFeeTotal}条记录</div></div>
  <g:paginat total="${ftTradeFeeTotal}" params="${params}"/>

</div>
<div align="center">
  <input type="button" class="rigt_button" onclick="window.location.href = '${createLink(controller:'stCustomer', action:'list')}'" value="返回"/>
</div>

</body>
</html>
