<%@ page import="boss.Perm; account.AcAccount" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acAccount.label', default: 'AcAccount')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
  <g:javascript>
    function empty_input(){
        document.getElementById('inputAccountNo').value = '';
        document.getElementById('inputAccountName').value = '';
        document.getElementById('selectBalanceOfDirection').value = '';
        document.getElementById('selectStatus').value = '';
        document.getElementById('inputAccountNo').focus();
    }
  </g:javascript>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
    <div class="table_serch">
      <table>
      <g:form>
          <tr>
            <td>账户号：</td><td><g:textField id="inputAccountNo" name="accountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.accountNo}" class="right_top_h2_input" style="width:120px"/></td>
            <td>账户名称：<g:textField id="inputAccountName" name="accountName" value="${params.accountName}" class="right_top_h2_input" style="width:120px"/></td>
            <td>借贷类型：<g:select id="selectBalanceOfDirection" name="balanceOfDirection" from="${AcAccount.dirMap}" optionKey="key" optionValue="value" value="${params.balanceOfDirection}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/></td>
            <td>账户状态：<g:select id="selectStatus" name="status" from="${AcAccount.statusMap}" optionKey="key" optionValue="value" value="${params.status}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/></td>
            %{--<input type="submit" class="right_top_h2_button_serch" value="查询">--}%
          </tr>
          <tr>
              <td>&nbsp;</td>
              <td><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询"/></td>
              <td><input type="button" class="right_top_h2_button_serch" onclick="javascript:empty_input();" value="清空" /></td>
              <td>
                  <g:actionSubmit class="right_top_h2_button_download" action="downloadList" value="下载"/>
              </td>
          </tr>
      </g:form>
      </table>
    </div>
    <div class="table_serch">
      <table>
        <tr>
            <td>汇总信息：</td>
            <td>&nbsp;</td>
            <td>可用余额：<g:formatNumber number="${sum.BAL/100}" type="currency" currencyCode="CNY"/></td>
            <td>冻结金额：<g:formatNumber number="${sum.FRBAL/100}" type="currency" currencyCode="CNY"/></td>
        </tr>
      </table>
    </div>
    <table align="center" class="right_list_table" id="test">
      <tr>

        <g:sortableColumn params="${params}"  property="accountNo" title="${message(code: 'acAccount.accountNo.label', default: 'Account No')}"/>

        <g:sortableColumn params="${params}"  property="accountName" title="${message(code: 'acAccount.accountName.label', default: 'Account Name')}"/>

        <g:sortableColumn params="${params}"  property="balanceOfDirection" title="${message(code: 'acAccount.balanceOfDirection.label', default: 'Balance Of Direction')}"/>

        <g:sortableColumn params="${params}"  property="balance" title="${message(code: 'acAccount.balance.label', default: 'Balance')}"/>

        <th>冻结金额</th>

        <th>冻结账户号</th>

        <g:sortableColumn params="${params}"  property="status" title="${message(code: 'acAccount.status.label', default: 'status')}"/>

        <th>操作</th>
      </tr>

      <g:each in="${mapList}" status="i" var="map">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

          <td>
              <g:if test="${bo.hasPerm(perm:Perm.Account_Acc_View){true}}">
                  <g:link action="show" id="${map.account.id}">${fieldValue(bean:map.account, field: "accountNo")}</g:link>
              </g:if>
              <g:else>${fieldValue(bean:map.account,field: "accountNo")}</g:else>
          </td>

          <td>${fieldValue(bean:map.account, field: "accountName")}</td>

          <td>${AcAccount.dirMap[map.account?.balanceOfDirection]}</td>

          <td><g:formatNumber number="${map.account?.balance/100}" type="currency" currencyCode="CNY"/></td>

          <td><g:formatNumber number="${map.frBalance/100}" type="currency" currencyCode="CNY"/></td>

          <td>${map.frAccountNo}</td>

          <td>${AcAccount.statusMap[map.account?.status]}</td>

          <td><g:link controller="acSequential" action="list" params="[sort:'dateCreated',order:'desc',accountNo:map.account.accountNo]">账户流水快捷查询</g:link></td>
        </tr>
      </g:each>
    </table>

    <div class="paginateButtons">
      <span style=" float:left;">共${acAccountInstanceTotal}条记录</span>
      <g:paginat total="${acAccountInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
