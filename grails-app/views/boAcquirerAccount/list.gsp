<%@ page import="boss.Perm; boss.BoAcquirerAccount" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boAcquirerAccount.label', default: 'BoAcquirerAccount')}"/>
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
      <bo:hasPerm perm="${Perm.Bank_Issu_New}"><g:form><g:actionSubmit class="right_top_h2_button_tj1" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/></g:form></bo:hasPerm>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <g:sortableColumn params="${params}"  property="bank.name" title="${message(code: 'boAcquirerAccount.bank.label')}"/>
        <g:sortableColumn params="${params}"  property="branchName" title="${message(code: 'boAcquirerAccount.branchName.label', default: 'Branch Name')}"/>
        <g:sortableColumn params="${params}"  property="bankNo" title="${message(code: 'boAcquirerAccount.bankNo.label', default: 'Bank No')}"/>
        <g:sortableColumn params="${params}"  property="bankAccountNo" title="${message(code: 'boAcquirerAccount.bankAccountNo.label', default: 'Bank Account No')}"/>
        <g:sortableColumn params="${params}"  property="bankAccountName" title="${message(code: 'boAcquirerAccount.bankAccountName.label', default: 'Bank Account Name')}"/>
        <g:sortableColumn params="${params}"  property="bankAccountType" title="${message(code: 'boAcquirerAccount.bankAccountType.label', default: 'Bank Account Type')}"/>
        <g:sortableColumn params="${params}"  property="status" title="${message(code: 'boAcquirerAccount.status.label')}"/>
        <g:sortableColumn params="${params}"  property="dateCreated" title="${message(code: 'boAcquirerAccount.dateCreated.label')}"/>
        <th>操作</th>
      </tr>

      <g:each in="${boAcquirerAccountInstanceList}" status="i" var="boAcquirerAccountInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td>${boAcquirerAccountInstance?.bank.name}</td>
          <td>${fieldValue(bean: boAcquirerAccountInstance, field: "branchName")}</td>
          <td>${fieldValue(bean: boAcquirerAccountInstance, field: "bankNo")}</td>
          <td>
              <g:if test="${bo.hasPerm(perm:Perm.Bank_Issu_View){true}}"><g:link action="show" id="${boAcquirerAccountInstance.id}">${fieldValue(bean: boAcquirerAccountInstance, field: "bankAccountNo")}</g:link></g:if>
              <g:else>${fieldValue(bean: boAcquirerAccountInstance, field: "bankAccountNo")}</g:else>
          </td>
          <td>${fieldValue(bean: boAcquirerAccountInstance, field: "bankAccountName")}</td>
          <td>${BoAcquirerAccount.typeMap[boAcquirerAccountInstance?.bankAccountType]}</td>
          <td>${BoAcquirerAccount.statusMap[boAcquirerAccountInstance?.status]}</td>
          <td><g:formatDate date="${boAcquirerAccountInstance?.dateCreated}" format="yyyy-MM-dd"/></td>
          <td>
            <bo:hasPerm perm="${Perm.Bank_Issu_Merc}"><input type="button" onclick="window.location.href = '${createLink(controller:'boMerchant', action:'list', params:['acquirerAccount.id':boAcquirerAccountInstance?.id])}'" value="设置收单商户"/></bo:hasPerm>
          </td>

        </tr>
      </g:each>
    </table>

    <div class="paginateButtons">
      <span style=" float:left;">共${boAcquirerAccountInstanceTotal}条记录</span>
      <g:paginat total="${boAcquirerAccountInstanceTotal}" params="${params}"/>
    </div>

  </div>
</div>
</body>
</html>
