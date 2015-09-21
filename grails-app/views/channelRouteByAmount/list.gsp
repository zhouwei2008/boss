
<%@ page import="ismp.ChannelRouteByAmount" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'channelRouteByAmount.label', default: 'ChannelRouteByAmount')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">渠道额度路由管理</h1>
    <h2>
      <g:form>
        <g:actionSubmit class="right_top_h2_button_tj" action="create" value="创建路由"/>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        
        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'channelRouteByAmount.id.label', default: '序号')}"/>

        <g:sortableColumn params="${params}"  property="bankCode" title="${message(code: 'channelRouteByAmount.bankCode.label', default: '银行名称')}"/>

        <g:sortableColumn params="${params}"  property="cardType" title="${message(code: 'channelRouteByAmount.cardType.label', default: '卡类型')}"/>

        <g:sortableColumn params="${params}"  property="amountStart" title="${message(code: 'channelRouteByAmount.amountStart.label', default: '额度1')}"/>

        <g:sortableColumn params="${params}"  property="channel1" title="${message(code: 'channelRouteByAmount.channel1.label', default: '渠道1')}"/>

        <g:sortableColumn params="${params}"  property="amountEnd" title="${message(code: 'channelRouteByAmount.amountEnd.label', default: '额度2')}"/>

        <g:sortableColumn params="${params}"  property="channel2" title="${message(code: 'channelRouteByAmount.channel1.label', default: '渠道2')}"/>

        <g:sortableColumn params="${params}"  property="channel3" title="${message(code: 'channelRouteByAmount.channel1.label', default: '渠道3')}"/>

          <g:sortableColumn params="${params}"  property="opName" title="${message(code: 'channelRouteByAmount.channel1.label', default: '操作人员')}"/>

          <g:sortableColumn params="${params}"  property="createTime" title="${message(code: 'channelRouteByAmount.channel1.label', default: '创建时间')}"/>
        <g:sortableColumn params="${params}"  property="updateTime" title="${message(code: 'channelRouteByAmount.channel1.label', default: '修改时间')}"/>

      </tr>

      <g:each in="${channelRouteByAmountInstanceList}" status="i" var="channelRouteByAmountInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          
          <td><g:link action="show" id="${channelRouteByAmountInstance.id}">${count++}</g:link></td>

          <td>${boss.BoBankDic.findByCode(channelRouteByAmountInstance.bankCode).name}</td>

          <td>${ChannelRouteByAmount.cardTypeMap[channelRouteByAmountInstance.cardType]}</td>

          <td>${fieldValue(bean: channelRouteByAmountInstance, field: "amountStart")}</td>

          <td><%= b2cchannellist.find{eleme-> eleme.key.toString()==channelRouteByAmountInstance.channel1}.value %></td>

        <td>${fieldValue(bean: channelRouteByAmountInstance, field: "amountEnd")}</td>

          <td><%= b2cchannellist.find{eleme-> eleme.key.toString()==channelRouteByAmountInstance.channel2}.value %></td>
          
          <td><%= b2cchannellist.find{eleme-> eleme.key.toString()==channelRouteByAmountInstance.channel3}.value %></td>

           <td>${fieldValue(bean: channelRouteByAmountInstance, field: "opName")}</td>

            <td>${fieldValue(bean: channelRouteByAmountInstance, field: "createTime")}</td>

            <td>${fieldValue(bean: channelRouteByAmountInstance, field: "updateTime")}</td>
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
      <g:paginate total="${channelRouteByAmountInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
