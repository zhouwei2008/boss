
<%@ page import="dsf.TbAgentpayDetailsInfo" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: '待处理打款信息')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript">
        function checkAllBox() {
            var len = document.getElementsByName("box").length;
            for (i = 0; i < len; i++) {
                if (document.getElementById("allBox").checked) {
                    document.getElementsByName("box")[i].checked = true;
                }
                else {
                    document.getElementsByName("box")[i].checked = false;
                }
            }
        }
         function selectCheck() {
            var len = document.getElementsByName("box").length;
            var ids="";
            var flag = 0;
            for (i = 0; i < len; i++) {
                if (document.getElementsByName("box")[i].checked) {
                    ids=ids+document.getElementsByName("box")[i].value+",";
                    flag = 1;
                }
            }

            document.getElementById("ids").value=ids;

            if (flag == 0) {
                alert("请选择明细！");
                return false;
            }
            else {
               return true;
            }

        }

        </script>
</head>
<body>
<script type="text/javascript">
  $(function() {
    $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });
</script>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
    <h2>

    </h2>
    <table align="center" class="right_list_table" id="test">
         <g:form action="list">

            <g:message code="日期"/>：
             <g:textField name="startTimeCreate" value="${params.startTimeCreate}" size="10" class="right_top_h2_input" style="width:80px"/>
                -- <g:textField name="endTimeCreate" value="${params.endTimeCreate}" size="10" class="right_top_h2_input" style="width:80px"/>

        <g:message code="商户编号"/>：<g:textField name="batchBizid" value="${params.batchBizid}" class="right_top_h2_input" style="width:120px"/>
        <g:message code="打款类型"/>：<g:select name="id" value="${params.id}" from="${TbAgentpayDetailsInfo.dkTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
        <g:message code="收款人"/>：<g:textField name="tradeCardname" value="${params.tradeCardname}" class="right_top_h2_input" style="width:120px"/>

          <input type="submit" class="right_top_h2_button_serch" value="查询">
             <input type="submit" class="right_top_h2_button_serch" value="清空" onclick="clear();">


        <g:hiddenField name="ids" id="ids"/>
      <tr>
        

        
        <g:sortableColumn params="${params}"  property="batchId" title="${message(code: 'tbAgentpayDetailsInfo.batchId.label', default: '批次号')}"/>
        
        <g:sortableColumn params="${params}"  property="tradeNum" title="${message(code: 'tbAgentpayDetailsInfo.tradeNum.label', default: '日期')}"/>
        
        <g:sortableColumn params="${params}"  property="tradeBankcode" title="${message(code: 'tbAgentpayDetailsInfo.tradeBankcode.label', default: '笔数')}"/>
        
        <g:sortableColumn params="${params}"  property="tradeCardtype" title="${message(code: 'tbAgentpayDetailsInfo.tradeCardtype.label', default: '金额')}"/>
        
        <g:sortableColumn params="${params}"  property="tradeCardnum" title="${message(code: 'tbAgentpayDetailsInfo.tradeCardnum.label', default: '手续费')}"/>

        <g:sortableColumn params="${params}"  property="tradeCardnum" title="${message(code: 'tbAgentpayDetailsInfo.tradeCardnum.label', default: '实付金额')}"/>

        <g:sortableColumn params="${params}"  property="tradeCardnum" title="${message(code: 'tbAgentpayDetailsInfo.tradeCardnum.label', default: '打款渠道')}"/>

        <g:sortableColumn params="${params}"  property="tradeCardnum" title="${message(code: 'tbAgentpayDetailsInfo.tradeCardnum.label', default: '打款状态')}"/>

        <g:sortableColumn params="${params}"  property="tradeCardnum" title="${message(code: 'tbAgentpayDetailsInfo.tradeCardnum.label', default: '打款明细')}"/>

        <g:sortableColumn params="${params}"  property="tradeCardnum" title="${message(code: 'tbAgentpayDetailsInfo.tradeCardnum.label', default: '操作')}"/>

      </tr>

      <g:each in="${handlePayList}" status="i" var="tbPcInfoInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

          <td>${fieldValue(bean: tbPcInfoInstance, field: "batchBizid")}</td>
          
          <td>${fieldValue(bean: tbPcInfoInstance, field: "tradeNum")}</td>
          
          <td >${fieldValue(bean: tbPcInfoInstance, field: "tradeRemark2")}</td>
          
          <td>${fieldValue(bean: tbPcInfoInstance, field: "tradeCardname")}</td>
          
          <td>${fieldValue(bean: tbPcInfoInstance, field: "tradeCardnum")}</td>
             <td>${fieldValue(bean: tbPcInfoInstance, field: "tradeAccountname")}</td>

          <td>${fieldValue(bean: tbPcInfoInstance, field: "tradeSysdate")}</td>

            <td>
                ${TbAgentpayDetailsInfo.accountTypeMap[tbPcInfoInstance.tradeAccounttype]}
          </td>
            <td>${fieldValue(bean: tbPcInfoInstance, field: "tradeBranchbank")}</td>

          <td>${fieldValue(bean: tbPcInfoInstance, field: "tradeSubbranchbank")}</td>


           <td><g:checkBox name="box" value="${tbAgentpayDetailsInfoInstance.id}" checked="false"  ></g:checkBox>打款</td>

          
        </tr>
      </g:each>





    </table>

     <table align="center">
                <tr>&nbsp;</tr>
                <tr>
                    <td align="center">
                        <g:actionSubmit id="submit" align="center" class="right_top_h2_button_tj" action="frTrialPass" value="初审通过" onclick="return selectCheck();"/>
                    </td>
                </tr>
            </table>
             </g:form>
    <div class="paginateButtons">
      <div style=" float:left;">共${tbAgentpayDetailsInfoInstanceTotal}条记录</div>
      <g:paginat total="${tbAgentpayDetailsInfoInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
