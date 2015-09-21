
<%@ page import="boss.Perm; boss.BoChannelRate" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boChannelRate.label', default: 'BoChannelRate')}"/>
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
        <g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/>
          <g:hiddenField name="merchantId" value="${merchantId}"/>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        
        <g:sortableColumn params="${params}"  property="feeType" title="${message(code: 'boChannelRate.feeType.label', default: 'Fee Type')}"/>
        <g:sortableColumn params="${params}"  property="feeRate" title="${message(code: 'boChannelRate.feeRate.label', default: 'Fee Rate')}"/>
        <g:sortableColumn params="${params}"  property="isRefundFee" title="${message(code: 'boChannelRate.isRefundFee.label', default: 'Is Refund Fee')}"/>
        <g:sortableColumn params="${params}"  property="isCurrent" title="${message(code: 'boChannelRate.isCurrent.label', default: 'Is Current')}"/>
        
      </tr>

      <g:each in="${boChannelRateInstanceList}" status="i" var="boChannelRateInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          
          <td>
              <g:if test="${bo.hasPerm(perm:Perm.Bank_Issu_Merc_Channel_View){true}}">
                <g:link action="show" id="${boChannelRateInstance.id}">${BoChannelRate.feeTypeMap[boChannelRateInstance?.feeType]}</g:link>
              </g:if>
              <g:else>${BoChannelRate.feeTypeMap[boChannelRateInstance?.feeType]}</g:else>
          </td>
          
          <td>${fieldValue(bean: boChannelRateInstance, field: "feeRate")}</td>
          
          <td>${BoChannelRate.isRefundFeeMap2[boChannelRateInstance?.isRefundFee]}</td>
           <td><g:formatBoolean boolean="${boChannelRateInstance?.isCurrent}"/></td>
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
      <g:paginate total="${boChannelRateInstanceTotal}" params="${params}"/>
    </div>
    <div class="paginateButtons">
          <span class="button"><input type="button" class="rigt_button" onclick="javascript:history.go(-1)" value="返回"/></span>
    </div>
  </div>
</div>
</body>
</html>
