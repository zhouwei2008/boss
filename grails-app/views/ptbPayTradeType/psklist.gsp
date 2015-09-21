<%@ page import="boss.Perm; pay.PtbPayTradeType" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: '收款交易类型管理', default: '收款交易类型管理')}"/>
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
        <bo:hasPerm perm="${Perm.NewAgCol_PayTradeType_Proc}"><g:actionSubmit class="right_top_h2_button_tj" action="pskcreate" value="${message(code: '创建 交易类型', default: '创建 交易类型')}"/></bo:hasPerm>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        %{--<g:sortableColumn params="${params}"  property="payType" title="打款类型"/>--}%
        <g:sortableColumn params="${params}"  property="payCode" title="${message(code: '交易Code', default: '交易Code')}"/>
        <g:sortableColumn params="${params}"  property="payName" title="${message(code: '交易名称', default: '交易名称')}"/>
        <g:sortableColumn params="${params}"  property="note" title="${message(code: 'tbBindBank.notes.label', default: '备注')}"/>
         <td>操作</td>
      </tr>

      <g:each in="${ptbPayTradeTypeList}" status="i" var="ptbPayTradeType">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          %{--<td>
           ${PtbPayTradeType.PayTypeMap[ptbPayTradeType.payType]}
          </td>--}%
          <td>${fieldValue(bean: ptbPayTradeType, field: "payCode")}</td>
          <td>${fieldValue(bean: ptbPayTradeType, field: "payName")}</td>
          <td>${fieldValue(bean: ptbPayTradeType, field: "note")}</td>
          <td>
              <bo:hasPerm perm="${Perm.NewAgCol_PayTradeType_Edit}">
                  <g:link action="updateItem" params="[payId:ptbPayTradeType.id]">编辑</g:link>
              </bo:hasPerm>
              <bo:hasPerm perm="${Perm.NewAgCol_PayTradeType_Del}">
                  <g:link action="deleteItem" params="[payId:ptbPayTradeType.id]" onClick="if(confirm('确定删除么?')){return true;}else{return false;}">删除</g:link>
              </bo:hasPerm>
          </td>
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
      <div style=" float:left;">共${ptbPayTradeTypeTotal}条记录</div>
      <g:paginat total="${ptbPayTradeTypeTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
