
<%@ page import="ismp.ChannelRouteByAmount" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'channelRouteByAmount.label', default: 'ChannelRouteByAmount')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2">渠道路由设置</th>
    </tr>
    
    <tr>
      <td class="right label_name">ID：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: channelRouteByAmountInstance, field: "id")}</span></td>
      
    </tr>


          <tr>
      <td class="right label_name">银行名称：</td>

      <td><span class="rigt_tebl_font">${boss.BoBankDic.findByCode(channelRouteByAmountInstance.bankCode).name}</span></td>

    </tr>

    <tr>
      <td class="right label_name">卡类型：</td>

      <td><span class="rigt_tebl_font">${ChannelRouteByAmount.cardTypeMap[channelRouteByAmountInstance.cardType]}</span></td>

    </tr>


    
    <tr>
      <td class="right label_name">额度1：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: channelRouteByAmountInstance, field: "amountStart")}</span></td>
      
    </tr>
    

    
    <tr>
      <td class="right label_name">渠道1：</td>
      
      <td><span class="rigt_tebl_font"><%= b2cchannellist.find{eleme-> eleme.key.toString()==channelRouteByAmountInstance.channel1}.value %></span></td>
      
    </tr>




    <tr>
      <td class="right label_name">额度2：</td>

      <td><span class="rigt_tebl_font">${fieldValue(bean: channelRouteByAmountInstance, field: "amountEnd")}</span></td>

    </tr>

    <tr>
      <td class="right label_name">渠道2：</td>
      
      <td><span class="rigt_tebl_font"><%= b2cchannellist.find{eleme-> eleme.key.toString()==channelRouteByAmountInstance.channel2}.value %></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name">渠道3：</td>
      
      <td><span class="rigt_tebl_font"><%= b2cchannellist.find{eleme-> eleme.key.toString()==channelRouteByAmountInstance.channel3}.value %></span></td>
      
    </tr>
    


    <tr>
      <td class="right label_name">操作员：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: channelRouteByAmountInstance, field: "opName")}</span></td>
      
    </tr>

          <tr>
      <td class="right label_name">创建时间：</td>

      <td><span class="rigt_tebl_font"><g:formatDate date="${channelRouteByAmountInstance?.createTime}"/></span></td>

    </tr>

    <tr>
      <td class="right label_name">修改时间：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${channelRouteByAmountInstance?.updateTime}"/></span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${channelRouteByAmountInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>
          <span class="button"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>