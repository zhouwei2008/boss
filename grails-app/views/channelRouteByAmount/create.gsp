

<%@ page import="ismp.ChannelRouteByAmountController; ismp.ChannelRouteByAmount" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'channelRouteByAmount.label', default: 'ChannelRouteByAmount')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${channelRouteByAmountInstance}">
    <div class="errors">
      <g:renderErrors bean="${channelRouteByAmountInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" >
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2">新增渠道额度路由</th>
      </tr>

      <tr>
        <td class="right label_name">银行名称：</td>
        <td class="${hasErrors(bean: channelRouteByAmountInstance, field: 'bankCode', 'errors')}">

            <g:select name="bankCode" from="${boss.BoBankDic.list()}" optionKey="code" optionValue="name" value="${channelRouteByAmountInstance?.bankCode}"/>

        </td>
      </tr>
      
      <tr>
        <td class="right label_name">卡类型：</td>
        <td class="${hasErrors(bean: channelRouteByAmountInstance, field: 'cardType', 'errors')}">

             <g:select name="cardType" from="${ChannelRouteByAmount.cardTypeMap}" optionKey="key" optionValue="value" value="${channelRouteByAmountInstance?.cardType}"/>

      </tr>

           <tr>
        <td class="right label_name">额度1：</td>
        <td class="${hasErrors(bean: channelRouteByAmountInstance, field: 'amountStart', 'errors')}"><g:textField name="amountStart" value="${channelRouteByAmountInstance?.amountStart}" /></td>
      </tr>

      <tr>
        <td class="right label_name">渠道1：</td>
        <td class="${hasErrors(bean: channelRouteByAmountInstance, field: 'channel1', 'errors')}">
            <select name="channel1">

               <g:each in="${b2cchannellist}" status="o" var="channel">
                           <option value="${channel?.key}" <g:if test="${channelRouteByAmountInstance?.channel1==channel.key.toString()}">selected="selected" </g:if> >${channel?.value}</option>
               </g:each>

            </select>

      </tr>


             <tr>
        <td class="right label_name">额度2：</td>
        <td class="${hasErrors(bean: channelRouteByAmountInstance, field: 'amountEnd', 'errors')}"><g:textField name="amountEnd" value="${channelRouteByAmountInstance?.amountEnd}" /></td>
      </tr>

      <tr>
        <td class="right label_name">渠道2：</td>
        <td class="${hasErrors(bean: channelRouteByAmountInstance, field: 'channel2', 'errors')}">

                       <select name="channel2">

               <g:each in="${b2cchannellist}" status="o" var="channel">
                           <option value="${channel?.key}" <g:if test="${channelRouteByAmountInstance?.channel2==channel.key.toString()}">selected="selected" </g:if> >${channel?.value}</option>
               </g:each>

            </select></td>
      </tr>
      
      <tr>
        <td class="right label_name">渠道3：</td>
        <td class="${hasErrors(bean: channelRouteByAmountInstance, field: 'channel3', 'errors')}">
                       <select name="channel3">

               <g:each in="${b2cchannellist}" status="o" var="channel">
                           <option value="${channel?.key}" <g:if test="${channelRouteByAmountInstance?.channel3==channel.key.toString()}">selected="selected" </g:if> >${channel?.value}</option>
               </g:each>

            </select>


        </td>
      </tr>
      

      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
</body>
</html>
