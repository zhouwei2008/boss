
<%@ page import="boss.Perm; dsf.TbPcInfo" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbPcInfo.label', default: 'TbPcInfo')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript">
     function cl(){

            var   form   =   document.forms[0];
            for(var   i=0;   i <form.elements.length;   i++)
            {
            if(form.elements[i].type==   "text" || form.elements[i].type==   "text" )
            form.elements[i].value   =   "";
             }
            document.getElementById("dkstatus").value="";
            document.getElementById("tbPcDkChanel").value="";

        }

     </script>
</head>
<body>
<script type="text/javascript">
  $(function() {
    $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });

         /*---guonan update 2011-12-30----*/
    function checkDate() {
        var startDateCreated = document.getElementById('startTime').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endTime').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }

    }
</script>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
      <g:form action="dkPcManage">
  <div class="right_top">


    <table align="center" class="right_list_table" id="test">
             开始时间：<g:textField name="startTime" value="${params.startTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
            结束时间：<g:textField name="endTime" value="${params.endTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
           批次号：<input name="id" value="${params.id}"  onKeyUp="value=value.replace(/[^\d|]/g,'')">
           打款状态：<g:select name="dkstatus" from="${TbPcInfo.dkStatusMap}" optionKey="key" optionValue="value" value="${params.dkstatus}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
             %{--收款银行：<g:select name="bankName" from="${bankNameList}" optionKey="id" optionValue="name" noSelection="${['':'--请选择--']}" />--}%
          打款通道：<g:select name="tbPcDkChanel" from="${bankChanelList}" optionKey="id" optionValue="${{it.bank.name+'-'+it.aliasName}}" value="${params.tbPcDkChanel}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>

             <input type="submit" class="right_top_h2_button_serch"   value="查询"  onclick="return checkDate()" />
             <input type="button" class="right_top_h2_button_serch" value="清空" onClick="cl()" />
      <tr>
        
        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'tbPcInfo.id.label', default: '批次号')}"/>

        <g:sortableColumn params="${params}"  property="tbPcDate" title="${message(code: 'tbPcInfo.tbPcDate.label', default: '日期')}"/>

        <g:sortableColumn params="${params}"  property="tbPcItems" title="${message(code: 'tbPcInfo.tbPcDate.label', default: '笔数')}"/>

        <g:sortableColumn params="${params}"  property="tbPcAmount" title="${message(code: 'tbPcInfo.tbPcAmount.label', default: '金额')}"/>

        <g:sortableColumn params="${params}"  property="tbPcFee" title="${message(code: 'tbPcInfo.tbPcAccamount.label', default: '手续费')}"/>
        
        <g:sortableColumn params="${params}"  property="tbPcDkChanelname" title="${message(code: 'tbPcInfo.tbPcDkChanelname.label', default: '打款通道')}"/>


           <td>操作</td>
          <g:sortableColumn params="${params}"  property="tbPcDkStatus" title="${message(code: 'tbPcInfo.tbPcAccamount.label', default: '批次打款状态')}"/>

          <td>自动</td>

       <td>手动</td>
         <td>打款批次</td>

      </tr>

      <g:each in="${tbPcInfoInstanceList}" status="i" var="tbPcInfoInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          
          <td>
              <g:if test="${bo.hasPerm(perm:Perm.AgPay_Batch_View){true}}" >
                <g:link action="itemShow" id="${tbPcInfoInstance.id}" >
                 ${tbPcInfoInstance.id}
                </g:link>
              </g:if>
              <g:else>${tbPcInfoInstance.id}</g:else>
             </td>

             <td><g:formatDate date="${tbPcInfoInstance.tbPcDate}" format="yyyy-MM-dd HH:mm:ss"/></td>

             <td>${fieldValue(bean: tbPcInfoInstance, field: "tbPcItems")}</td>

          <td>
              <g:set var="amt" value="${tbPcInfoInstance.tbPcAmount ? tbPcInfoInstance.tbPcAmount : 0}"/>
               <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>

          </td>

            <td>
                <g:if test="${tbPcInfoInstance.tbPcFee==null}">
                ${fieldValue(bean: tbPcInfoInstance, field: "tbPcFee")}
                </g:if>
                <g:if test="${tbPcInfoInstance.tbPcFee!=null}">
                <g:set var="amt" value="${tbPcInfoInstance.tbPcFee ? tbPcInfoInstance.tbPcFee : 0}"/>
               <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                    </g:if>
            </td>
          
            <td>${fieldValue(bean: tbPcInfoInstance, field: "tbPcDkChanelname")}</td>

             <td> <bo:hasPerm perm="${Perm.AgPay_Batch_ModChannel}"><g:link action="modify" id="${tbPcInfoInstance.id}" > 修改</g:link></bo:hasPerm></td>

             <td>${TbPcInfo.dkStatusMap[tbPcInfoInstance.tbPcDkStatus]}</td>

            <td><bo:hasPerm perm="${Perm.AgPay_Batch_Auto}"><a onclick='javascript:alert("此功能尚未开通")'>自动打款</a></bo:hasPerm></td>

            <td><bo:hasPerm perm="${Perm.AgPay_Batch_Manual}"><g:link action="handledk" id="${tbPcInfoInstance.id}" >手动打款</g:link></bo:hasPerm></td>

             <td> <bo:hasPerm perm="${Perm.AgPay_Batch_Dl}"><g:link action="downLoad" id="${tbPcInfoInstance.id}" > 下载</g:link></bo:hasPerm></td>


        </tr>
      </g:each>
         <g:hiddenField name="ids" id="ids"/>
    </table>



       </g:form>
    合计：笔数总计：${totalNum?totalNum:0}笔&nbsp;&nbsp;&nbsp;&nbsp;金额总计：<g:formatNumber number="${totalAmount?totalAmount:0}" format="#.##"/>元&nbsp;&nbsp;&nbsp;&nbsp;手续费总计：<g:formatNumber number="${totalFee?totalFee:0}" format="#.##"/>元
    <div class="paginateButtons">
         <span class="left">共${tbPcInfoInstanceTotal}条记录</span>
      <g:paginat total="${tbPcInfoInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
