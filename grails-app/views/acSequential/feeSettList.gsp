<%@ page import="boss.Perm; dsf.TbAgentpayDetailsInfo; account.AcAccount; ismp.CmCustomer;" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: '手续费结算', default: '手续费结算')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
  <link rel="stylesheet" type="text/css" href="../ext/css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="../ext/css/style.css" />
    <script type="text/javascript" src="../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../ext/js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ext/js/common.js"></script>
</head>
<body>
<script type="text/javascript">
  $(function() {
    $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });


  function doHandSett(customerId,id,settMoney)
  {
      var url = "popSett?customerId="+customerId+"&id="+id+"&settMoney="+settMoney;
	  win1=new Ext.Window({
			   id:'win1',
	           title:"商户手续费结算",
	           width:400,
	           modal:true,
	           height:300,
	           html: '<iframe src='+url +' height="100%" width="100%" name="popSett" scrolling="auto" frameBorder="0" onLoad="Ext.MessageBox.hide();">',
	           maximizable:true
            });
      win1.show();
  }
        function empty() {
        $(':input') .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');

        return false;
    }

</script>
<div class="main">

  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
    <h2>

      <g:form action="feeSettList">
        商户号：<g:textField name="merchantNo" value="${params.merchantNo}" class="right_top_h2_input" style="width:120px"/>
        商户名称：<g:textField name="merchantName" value="${params.merchantName}" class="right_top_h2_input" style="width:120px"/>
        %{--业务类型：<g:select name="serviceCode" from="${TbAgentpayDetailsInfo.serviceMap}" optionKey="key" optionValue="value" value="${params.serviceCode}" noSelection="${['':'-全部-']}" class="right_top_h2_input"/>--}%
        <input type="submit" class="right_top_h2_button_serch" value="查询"/>
          <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
        <bo:hasPerm perm="${Perm.AgentPay_Fee_Dl}"><g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载"/></bo:hasPerm>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        %{--<g:sortableColumn params="${params}" property="customerNo" title="${message(code: 'cmCustomer.customerNo.label', default: 'Customer No')}"/>
        <g:sortableColumn params="${params}" property="name" title="${message(code: 'cmCustomer.name.label', default: 'Name')}"/>--}%
        <th>客户编号</th>
        <th>客户名称</th>
        <th>业务类型</th>
        <th>结算金额（元）</th>
        <th>结算操作</th>
      </tr>

      <g:each in="${boCustomerServiceInstanceList}" status="i" var="boCustomerServiceInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td>${CmCustomer.get(boCustomerServiceInstance?.customerId).customerNo}</td>
          <td>${CmCustomer.get(boCustomerServiceInstance?.customerId).name}</td>
          <td>
              <g:if test="${boCustomerServiceInstance?.serviceCode=='agentcoll'}">代收</g:if>
              <g:if test="${boCustomerServiceInstance?.serviceCode=='agentpay'}">代付</g:if>
          </td>
          <td>${AcAccount.findByAccountNo(boCustomerServiceInstance.feeAccNo)?.balance==null?0:AcAccount.findByAccountNo(boCustomerServiceInstance.feeAccNo)?.balance/100}</td>
          <td><bo:hasPerm perm="${Perm.AgentPay_Fee_Settle}"><a href="#" onclick="doHandSett(${boCustomerServiceInstance?.customerId},${boCustomerServiceInstance?.id},${AcAccount.findByAccountNo(boCustomerServiceInstance.feeAccNo)?.balance==null?0:AcAccount.findByAccountNo(boCustomerServiceInstance.feeAccNo)?.balance/100})">手工结算</a></bo:hasPerm></td>
        </tr>
      </g:each>
    </table>
    合计：结算金额总计：<g:formatNumber number="${totalAmount==null?0:totalAmount/100}" format="#.##"/>元
    <div class="paginateButtons">
      <span style=" float:left;">共${boCustomerServiceInstanceTotal}条记录</span>
      <g:paginat total="${boCustomerServiceInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
