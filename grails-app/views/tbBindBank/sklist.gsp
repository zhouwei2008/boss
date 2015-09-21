
<%@ page import="boss.Perm; dsf.TbBindBank" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbBindBank.label', default: '绑定银行')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
    <h2>
      <g:form>
        <bo:hasPerm perm="${Perm.AgCol_BankChannel_New}" ><g:actionSubmit class="right_top_h2_button_tj" action="skbind" value="${message(code: 'default.new.label', args:[entityName])}"/></bo:hasPerm>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <g:sortableColumn params="${params}"  property="dsfFlag" title="${message(code: 'tbBindBank.dsfFlag.label', default: '服务标识')}"/>
        
        <g:sortableColumn params="${params}"  property="bankAccountno" title="${message(code: 'tbBindBank.bankAccountno.label', default: '账号')}"/>
        
        <g:sortableColumn params="${params}"  property="notes" title="${message(code: 'tbBindBank.notes.label', default: '备注')}"/>
        
      </tr>

      <g:each in="${tbBindBankInstanceList}" status="i" var="tbBindBankInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
   <td>
           ${TbBindBank.ServerTypeMap[tbBindBankInstance.dsfFlag]}
          </td>
          
          <td>${fieldValue(bean: tbBindBankInstance, field: "bankAccountno")}</td>
          
          <td>${fieldValue(bean: tbBindBankInstance, field: "notes")}</td>
          
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
      <div style=" float:left;">共${tbBindBankInstanceTotal}条记录</div>
      <g:paginat total="${tbBindBankInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
