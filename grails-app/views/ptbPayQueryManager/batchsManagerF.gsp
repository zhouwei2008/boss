<%@ page import="boss.Perm; pay.PtbPayBatch" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbPcInfo.label', default: 'TbPcInfo')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript">
     function query(){
        if(checkDate()){
           document.forms['myForm'].action='${request.contextPath}/ptbPayQueryManager/batchsManagerF'
           document.forms['myForm'].submit();
        }else{
            return false;
        }
     }
     function confirmHandle(batchId,chanelId){
         if(document.getElementById(chanelId+'div').style.display=='block'){
             alert("请先保存打款渠道");
             return false
         }
         if(confirm("要继续么?")){
            document.getElementById('batchIdHid').value=batchId;
            document.forms['myForm'].action='${request.contextPath}/ptbPayQueryManager/confirm';
            document.forms['myForm'].submit();
         }else{
             return false;
         }

     }

     function  changeChanel(chanelId){
         document.getElementById(chanelId+'div').style.display = 'block';
         document.getElementById(chanelId+'divshow').style.display = 'none';
         document.getElementById(chanelId+'divchange').style.display = 'none' ;
     }

     function changeChanelCommit(batchId,chanelId,batchStyle){
        if(batchStyle=='auto'){
            if(!confirm("你选择了“自动打款”，此操作不可逆转，请确认是否要继续？")){
                return false;
            }
        }else{
            if(!confirm("请确认是否要继续？")){
                return false;
            }
        }
        document.getElementById('merchantIdHid').value = document.getElementById(chanelId).value;
        document.getElementById('batchIdHid').value=batchId;
        document.getElementById('batchStyleHid').value=batchStyle;
        document.forms['myForm'].action='${request.contextPath}/ptbPayQueryManager/changeChanelCommit';
        document.forms['myForm'].submit();
     }


     function cancelBatch(batchId){
        if(confirm("批次将被删除，交易恢复为等待打款，确定要撤消么?\n\n"+
                "注意：此操作不可逆转，如果该批次已发送到银行，请不要做此操作")){
           document.getElementById('batchIdHid').value=batchId;
           document.forms['myForm'].action='${request.contextPath}/ptbPayQueryManager/cancelBatch';
           document.forms['myForm'].submit();
        }else{
           return false
        }

     }


     function reSendForAuto(batchId){
        if(confirm("确定要设置该批次自动重新发送银行么?")){
           document.getElementById('batchIdHid').value=batchId;
           document.forms['myForm'].action='${request.contextPath}/ptbPayQueryManager/reSendForAuto';
           document.forms['myForm'].submit();
        }else{
           return false
        }

     }








     function cl(){

            var   form   =   document.forms[0];
            for(var   i=0;   i <form.elements.length;   i++)
            {
            if(form.elements[i].type==   "text" || form.elements[i].type==   "text" )
            form.elements[i].value   =   "";
             }
            document.getElementById("batchStatus").value="";
            document.getElementById("merchantId").value="";

        }


        var overChanelId
        function onChanelChange(chanelId)
        {
            overChanelId = chanelId
            var merchantId = $("#"+chanelId).val()
            if(merchantId==''){
                document.getElementById("auto"+chanelId).style.display = 'none'
                document.getElementById("handle"+chanelId).style.display = 'none'
                return false;
            }
            var batchType = $("#batchType").val()
            $.ajax({
               url:'${request.contextPath}/ptbPayManager/onChanelChange', //后台处理程序
               type:'post',         //数据发送方式
               dataType:'json',     //接受数据格式
               data:{
                   merchantId:merchantId,
                   tradeType:batchType
               },                    //要传递的数据
               success:callBackChanelChange //回传函数(这里是函数名)
            });
        }
        function callBackChanelChange(data){
            var msg = null
            if(data!=null){
                if(data.autoOrHandle!=null){
                    if(data.autoOrHandle=='auto'){
                        document.getElementById("auto"+overChanelId).style.display = 'inline'
                        document.getElementById("handle"+overChanelId).style.display = 'none'
                    }else if(data.autoOrHandle=='handle'){
                        document.getElementById("auto"+overChanelId).style.display = 'none'
                        document.getElementById("handle"+overChanelId).style.display = 'inline'
                    }else if(data.autoOrHandle=='all'){
                        document.getElementById("auto"+overChanelId).style.display = 'inline'
                        document.getElementById("handle"+overChanelId).style.display = 'block'
                    }else{
                        msg = '暂不支持此渠道'
                    }
                }else if(data.error!='undefined'&&data.error!=null){
                    msg = data.error
                }else{
                    msg = '暂不支持此渠道'
                }
            }else{
                msg = '暂不支持此渠道'
            }
            if(msg!=null){
                document.getElementById("auto"+overChanelId).style.display = 'none'
                document.getElementById("handle"+overChanelId).style.display = 'none'
                alert(msg)
            }
        }




        function reSendCheckMsgByBatch(batchId)
        {
            parent.showWait();
            $.ajax({
               url:'reSendCheckMsgByBatch', //后台处理程序
               type:'post',         //数据发送方式
               dataType:'json',     //接受数据格式
               data:{
                   batchId:batchId
               },                    //要传递的数据
               success:callBackReSendCheckMsgByBatch //回传函数(这里是函数名)
            });
        }
        function callBackReSendCheckMsgByBatch(data){
            var msg = null
            if(data!=null){
                msg = data.msg
            }else{
                msg = '重发通知失败'
            }
            parent.hideWait();
            setTimeout("alert('"+msg+"')",1);
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
        return true;
    }
</script>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
      <g:form name="myForm" action="batchsManagerF">
           <g:hiddenField name="batchType" value="F"/>
  <div class="right_top">
     <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">打款批次管理</h1>
    <h2>

    </h2>

    <table align="center" class="right_list_table" id="test">
             开始时间：<g:textField name="startTime" value="${params.startTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
            结束时间：<g:textField name="endTime" value="${params.endTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
           批次号：<input name="batchId" value="${params.batchId}"  style="width:100px" class="right_top_h2_input" onKeyUp="value=value.replace(/[^\d|]/g,'')">
           打款状态：<g:select  onchange="return query()" name="batchStatus" from="${PtbPayBatch.BatchStatusMap}" optionKey="key" optionValue="value" value="${params.batchStatus}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
          打款渠道： <g:select  onchange="return query()" name="merchantId" from="${bankChanelList}" optionKey="${{it.MERCHANTID}}" optionValue="${{it.BANKNAME+'-'+it.ALIAS_NAME+'-'+it.SERVICECODE}}" value="${params.merchantId}" noSelection="${['':'--请选择--']}" />
          <br/>
          <br/>
             <input type="button" class="right_top_h2_button_serch"   value="查询"  onclick="return query()" />
             <input type="button" class="right_top_h2_button_serch" value="清空" onClick="cl()" />
          <br/>
          <br/>
      <tr>
        
        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'tbPcInfo.id.label', default: '批次号')}"/>

        <g:sortableColumn params="${params}"  property="batchDate" title="${message(code: 'tbPcInfo.tbPcDate.label', default: '日期')}"/>

        <g:sortableColumn params="${params}"  property="batchCount" title="${message(code: 'tbPcInfo.tbPcDate.label', default: '笔数')}"/>

        <g:sortableColumn params="${params}"  property="batchAmount" title="${message(code: 'tbPcInfo.tbPcAmount.label', default: '金额')}"/>
        <g:sortableColumn params="${params}"  property="batchChanelname" title="${message(code: 'tbPcInfo.tbPcDkChanelname.label', default: '打款通道')}"/>
          <g:sortableColumn params="${params}"  property="batchStatus" title="${message(code: 'tbPcInfo.tbPcAccamount.label', default: '批次打款状态')}"/>
          <g:sortableColumn params="${params}"  property="batchStyle" title="打款方式"/>

          <td>操作</td>


      </tr>

      <g:each in="${ptbPayBatchList}" status="i" var="ptbPayBatch">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          
          <td>
              <g:if test="${bo.hasPerm(perm:Perm.NewAgPay_Batch_View){true}}" >
                <g:link action="batchsDetails" params="[batchId:ptbPayBatch.id,tradeType:'F']" >
                 ${ptbPayBatch.id}
                </g:link>
              </g:if>
              <g:else>${ptbPayBatch.id}</g:else>
             </td>

             <td><g:formatDate date="${ptbPayBatch.batchDate}" format="yyyy-MM-dd HH:mm:ss"/></td>

             <td>${fieldValue(bean: ptbPayBatch, field: "batchCount")}</td>

          <td>
              <g:set var="amt" value="${ptbPayBatch.batchAmount ? ptbPayBatch.batchAmount : 0}"/>
               <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>

          </td>

            <td >
                <div id="chanelId${i}div" style="width:100%;display:none;">
                    <g:select onChange="return onChanelChange('chanelId${i}')" name="chanelId${i}" from="${bankChanelList}" optionKey="${{it.MERCHANTID}}" optionValue="${{it.BANKNAME+'-'+it.ALIAS_NAME+'-'+it.SERVICECODE}}"  noSelection="${['':'--请选择--']}" />
                    <br/>
                    <a id="autochanelId${i}" style="display:none" onclick="return changeChanelCommit('${ptbPayBatch.id}','chanelId${i}','auto')">保存(自动打款)</a>
                    &nbsp;&nbsp;
                    <a id="handlechanelId${i}" style="display:none" onclick="return changeChanelCommit('${ptbPayBatch.id}','chanelId${i}','handle')">保存(手动打款)</a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a id="cancelchanelId${i}" style="align:right_top" onclick="return query()">取消</a>
                </div>
                <span id="chanelId${i}divshow">
                    ${fieldValue(bean: ptbPayBatch, field: "batchChanelname")}
                </span>
                <span id="chanelId${i}divchange">
                     <g:if test="${ptbPayBatch.batchStyle=='handle'&&ptbPayBatch.batchStatus=='0'}">
                         <bo:hasPerm perm="${Perm.NewAgPay_Batch_ModChannel}">(<a  onclick="javascript:changeChanel('chanelId${i}')">修改</a>)</bo:hasPerm>
                     </g:if>
                 </span>
            </td>
             <td>${PtbPayBatch.BatchStatusMap[ptbPayBatch.batchStatus]}</td>
            <td>${PtbPayBatch.BatchStyleMap[ptbPayBatch.batchStyle]}</td>

            <td>
                <g:if test="${ptbPayBatch.batchStyle=='auto'&& ptbPayBatch.batchStatus=='1'}">
                    %{--<bo:hasPerm perm="${Perm.NewAgPay_Batch_Auto_ReSend}"><a onclick='reSendForAuto(${ptbPayBatch.id})'>重发(自动打款)</a></bo:hasPerm>--}%
                </g:if>
                <g:if test="${ptbPayBatch.batchStyle=='handle'}">
                    <g:if test="${ptbPayBatch.batchStyle=='handle'&&ptbPayBatch.batchStatus=='0'}">
                        %{--<bo:hasPerm perm="${Perm.NewAgPay_Batch_CANCEL}"><a onclick="cancelBatch(${ptbPayBatch.id})" >撤消</a></bo:hasPerm>--}%
                        <bo:hasPerm perm="${Perm.NewAgPay_Batch_CONFIRM}"><a onclick="confirmHandle(${ptbPayBatch.id},'chanelId${i}')" >确认</a></bo:hasPerm>
                    </g:if>
                    <g:if test="${ptbPayBatch.batchStatus=='0'||ptbPayBatch.batchStatus=='1'}">
                         <bo:hasPerm perm="${Perm.NewAgPay_Batch_Dl}"><g:link controller="ptbPayManager" action="downLoad" id="${ptbPayBatch.id}" > 下载</g:link></bo:hasPerm>
                    </g:if>
                </g:if>
                <g:if test="${ptbPayBatch.batchStatus=='2'}">
                    <bo:hasPerm perm="${Perm.NewAgPay_Trade_ReSendByBatch}"><a onclick="reSendCheckMsgByBatch('${ptbPayBatch.id}');">重发通知(批量)</a></bo:hasPerm>
                </g:if>
            </td>
        </tr>
      </g:each>
          <g:hiddenField  name="batchStyleHid"/>
          <g:hiddenField  name="batchIdHid"/>
          <g:hiddenField  name="merchantIdHid"/>
    </table>

         <div class="paginateButtons">
             <span class="left">共${totalBatchCount}条记录</span>
          <g:paginat total="${totalBatchCount}" params="${params}"/>
        </div>

       </g:form>
    合计：笔数总计：${totalTradeCount?totalTradeCount:0}笔&nbsp;&nbsp;&nbsp;&nbsp;金额总计：<g:formatNumber number="${totalMoney?totalMoney:0}" format="#.##"/>元

  </div>
</div>
</body>
</html>
