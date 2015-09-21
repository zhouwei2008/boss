<%@ page import="ismp.CmCustomer; boss.Perm; dsf.TbAgentpayDetailsInfo; dsf.TbAgentpayDetailsInfo;boss.BoAcquirerAccount" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: '交易查询')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<style>
    /*字符串截取*/
.aa{width:150px;height:24px;line-height:24px;overflow:hidden;margin:0px;color:#666;display:block;padding-left:100px}
 span {display:-moz-inline-box; display:inline-block;}

</style>
<script type="text/javascript">
     $(function() {
    $("#tradeSubdateStart").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#tradeSubdateEnd").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });
  $(function() {
    $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });

  $(function() {
    $("#tradeSyschkdateStart").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#tradeSyschkdateEnd").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });
  $(function() {
    $("#tradeDonedateStart").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#tradeDonedateEnd").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });

   $(function() {
    $("#tkStartTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#tkEndTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });


  function checkTime()
  {
      var numReg = /^\d*$/;
      var sTime = document.getElementById("startTime").value;
      var eTime = document.getElementById("endTime").value;
      var objValue = document.getElementById("id").value;
      if(sTime!="" && eTime!="")
      {
          var vsTime = Date.parse(sTime.toString().substring(0,4)+"/"+sTime.toString().substring(5,7)+"/"+sTime.toString().substring(8,10));
          var veTime = Date.parse(eTime.toString().substring(0,4)+"/"+eTime.toString().substring(5,7)+"/"+eTime.toString().substring(8,10));
          if(vsTime>veTime)
          {
              alert("请求开始时间不能大于请求结束时间");
              return false;
          }else{
              return true;
          }
      }
      if(objValue!="" && !numReg.test(objValue)){
          alert("只能输入数字");
          return false;
      }
  }
  function checkNum(objValue){
      var numReg = /^\d*$/;
     if(objValue!="" && !numReg.test(objValue)){
          alert("只能输入数字");
          return false;
      }
  }
     /*---guonan update 2011-12-30----*/
    function checkDate() {
        var startDateCreated = document.getElementById('startTime').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endTime').value.replace(/-/g,"//");

        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('请求开始时间不能大于请求结束时间!');
                document.getElementById('startTime').focus();
                return false;
            }
        }
        var tradeSyschkdateStart = document.getElementById('tradeSyschkdateStart').value;
        var tradeSyschkdateEnd = document.getElementById('tradeSyschkdateEnd').value;
        if(tradeSyschkdateStart>tradeSyschkdateEnd){
               alert('审核开始时间不能大于请求结束时间!');
            document.getElementById('tradeSyschkdateStart').focus();
              return false;
        }

        var tradeDonedateStart = document.getElementById('tradeDonedateStart').value;
        var tradeDonedateEnd = document.getElementById('tradeDonedateEnd').value;
        if(tradeDonedateStart>tradeDonedateEnd){
               alert('对账开始时间不能大于请求结束时间!');
            document.getElementById('tradeDonedateStart').focus();
              return false;
        }

    }


  function checkQuery(){
      return checkDate();
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
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
   <g:if test="${flag==-2}">
        <script type="text/javascript">
            alert("您的账号没有关联任何销售");
         </script>
    </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
    <h2>
      <g:form action="transactionList">

          <span >
            商户申请时间：<g:textField name="tradeSubdateStart" value="${params.tradeSubdateStart}" size="10" class="right_top_h2_input" style="width:100px"/>
            --<g:textField name="tradeSubdateEnd" value="${params.tradeSubdateEnd}" size="10" class="right_top_h2_input" style="width:100px"/>
         </span>
          <span >
            商户审核时间：<g:textField name="startTime" value="${params.startTime}" size="10" class="right_top_h2_input" style="width:100px"/>
            --<g:textField name="endTime" value="${params.endTime}" size="10" class="right_top_h2_input" style="width:100px"/>
         </span>
          <span >
          吉高审核时间：<g:textField name="tradeSyschkdateStart" value="${params.tradeSyschkdateStart}" size="10" class="right_top_h2_input" style="width:100px"/>
            --<g:textField name="tradeSyschkdateEnd" value="${params.tradeSyschkdateEnd}" size="10" class="right_top_h2_input" style="width:100px"/>
         </span>
          <span >
          对账时间：<g:textField name="tradeDonedateStart" value="${params.tradeDonedateStart}" size="10" class="right_top_h2_input" style="width:100px"/>
            --<g:textField name="tradeDonedateEnd" value="${params.tradeDonedateEnd}" size="10" class="right_top_h2_input" style="width:100px"/>
          </span>


          <span >
          商户编号：<g:textField name="batchBizid" value="${params.batchBizid}" size="20" class="right_top_h2_input" style="width:150px"/>
          </span>
          <span >
            商户名称：<g:textField name="batchBizname" value="${params.batchBizname}" size="20" class="right_top_h2_input" style="width:150px"/>
          </span>
          <span >
            交易状态：<g:select name="tradeFeedbackcode" from="${TbAgentpayDetailsInfo.tradeFeedbackcodeMap}" optionKey="key" optionValue="value" value="${params.tradeFeedbackcode}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
            </span>
          <span >
            收款人：<g:textField name="tradeCardname" value="${params.tradeCardname}" size="10" class="right_top_h2_input" style="width:150px"/>
          </span>
          <span >
          收款账号：<g:textField name="tradeCardnum" value="${params.tradeCardnum}" size="10" class="right_top_h2_input" style="width:150px"/>
          </span>
          <span >
          收款银行：<g:select name="tradeAccountname" from="${bankNameList}" optionKey="${1}" optionValue="${2}" value="${params.tradeAccountname}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
          </span>
          <span >
          账号类型：<g:select name="tradeAccounttype" from="${TbAgentpayDetailsInfo.accountTypeMap}" optionKey="key" optionValue="value" value="${params.tradeAccounttype}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
          </span>
          <span >
          证件号码: <g:textField name="certificateNum" value="${params.certificateNum}" size="20" class="right_top_h2_input" style="width:150px"/>
         </span>
          <span >
            批次号：<g:textField name="batchId" value="${params.batchId}" size="10" class="right_top_h2_input" style="width:150px"/>
         </span>
          <span >
            交易号：<g:textField name="id" value="${params.id}" size="10" class="right_top_h2_input" onBlur="checkNum(this.value)" style="width:150px"/>
           </span>
          <span >
            %{--用途：<g:textField name="tradeRemark2" value="${params.tradeRemark2}" size="10" class="right_top_h2_input" style="width:150px"/>--}%
            %{--是否退款：<g:select name="tradeFeestyle" from="${TbAgentpayDetailsInfo.tradeFeeMap}" optionKey="key" optionValue="value" value="${params.tradeFeestyle}" noSelection="${['-1':'-请选择-']}" class="right_top_h2_input"/> --}%
            代扣编码: <g:textField name="contractUsercode" value="${params.contractUsercode}" size="20" class="right_top_h2_input" style="width:150px"/>
           </span>
          <span >
            交易类型：<g:select name="tradeType" from="${TbAgentpayDetailsInfo.tradeTypeMap}" optionKey="key" optionValue="value" value="${params.tradeType}" noSelection="${['-1':'-请选择-']}" class="right_top_h2_input"/>
          </span>
           <span >
          退款状态：<g:select name="tradeRefued" from="${TbAgentpayDetailsInfo.tradeRefuedMap}" optionKey="key" optionValue="value" value="${params.tradeRefued}" noSelection="${['-1':'-请选择-']}" class="right_top_h2_input"/>
          </span>
          <span >
          明细状态：<input type="checkbox" id = "batchStatus" name="batchStatus"  value="-1"  <g:if test="${params.batchStatus=='-1'||params.batchStatus==null}">checked</g:if> title="全选" onclick="checkBatchStatus();"/>全选&nbsp;
                      <input type="checkbox" id = "batchStatus0" name="batchStatus" value="0" title="待确认" <g:if test="${'0' in params.batchStatus}">checked</g:if>  onclick="unCheckedBatchStatus();"/>待确认&nbsp;
                      <input type="checkbox" id = "batchStatus1" name="batchStatus" value="1" title="待审核" <g:if test="${'1' in params.batchStatus}">checked</g:if>  onclick="unCheckedBatchStatus();"/>待审核&nbsp;
                      <input type="checkbox" id = "batchStatus3"name="batchStatus"  value="3" title="商户拒绝" <g:if test="${'3' in params.batchStatus}">checked</g:if> onclick="unCheckedBatchStatus();"/>商户拒绝&nbsp;
                      <input type="checkbox" id = "batchStatus2" name="batchStatus" value="2" title="待处理" <g:if test="${'2' in params.batchStatus}">checked</g:if> onclick="unCheckedBatchStatus();"/>待处理&nbsp;
                      <input type="checkbox" id = "batchStatus4" name="batchStatus"  value="4" title="吉高拒绝" <g:if test="${'4' in params.batchStatus}">checked</g:if> onclick="unCheckedBatchStatus();"/>吉高拒绝&nbsp;
                      <input type="checkbox" id = "batchStatus5" name="batchStatus" value="5" title="吉高审核通过" <g:if test="${'5' in params.batchStatus}">checked</g:if> onclick="unCheckedBatchStatus();"/>吉高审核通过&nbsp;
                      <input type="checkbox" id = "batchStatus6" name="batchStatus" value="6" title="处理中" <g:if test="${'6' in params.batchStatus}">checked</g:if> onclick="unCheckedBatchStatus();"/>处理中&nbsp;
                      <input type="checkbox" id = "batchStatus7" name="batchStatus"  value="7" title="处理完毕" <g:if test="${'7' in params.batchStatus}">checked</g:if> onclick="unCheckedBatchStatus();"/>处理完毕
          </span>

          <span >
          <g:hiddenField name="saleType" value="${params.saleType}"/>
              <g:if test="${flag!=-1&&flag!=-2}">
          <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkQuery()">
          <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>

          <g:if test="${params.saleType == 'sale'}">
                 <bo:hasPerm perm="${Perm.Agent_Trade_SaleQry_DownLoad}">
              <g:actionSubmit class="right_top_h2_button_download" action="listDownload"  onclick="return checkDate()" value="下载"/>
                     </bo:hasPerm>
          </g:if>
          <g:else>
            <bo:hasPerm perm="${Perm.Agent_TradeQuery_DownLoad}">
                <g:actionSubmit class="right_top_h2_button_download" action="downTrades"  onclick="return checkDate()" value="下载"/>
                <g:actionSubmit class="right_top_h2_button_tj" action="downTradesCSV"  onclick="return checkDate()" value=" 下载CSV" />
            </bo:hasPerm>
           </g:else>
                  </g:if>

      </span>

      </g:form>
    </h2>
      <div class="right_list_tablebox" style="height: 380px">
    <table align="center" class="right_list_table" id="test">
      <tr>
        <g:sortableColumn params="${params}"  property="batchBizid" title="${message(code: 'tbAgentpayDetailsInfo.batchBizid.label', default: 'Batch Id')}"/>
        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'tbAgentpayDetailsInfo.detailId_.label', default: 'Detail Id')}"/>
        <g:sortableColumn params="${params}"  property="batch.id" title="${message(code: 'tbAgentpayDetailsInfo.detailId.label', default: 'Detail Id')}"/>
        <g:sortableColumn params="${params}"  property="batchBizid" title="${message(code: 'ftLiquidate.customerName.label', default: 'Trade customerName')}"/>
        <g:sortableColumn params="${params}"  property="tradeType" title="${message(code: 'tbAgentpayDetailsInfo.tradeType.label', default: 'Trade tradeType')}"/>

        <g:sortableColumn params="${params}"  property="tradeCardname" title="${message(code: 'tbAgentpayDetailsInfo.tradeCardnameall.label', default: 'Trade Card Name')}"/>
        <g:sortableColumn params="${params}"  property="tradeAccountname" title="${message(code: 'tbAgentpayDetailsInfo.tradeCustomerAccount.label', default: 'Trade Account Customer Account')}"/>

        <g:sortableColumn params="${params}"  property="tradeSubdate" title="${message(code: 'tbAgentpayDetailsInfo.tradeSubdate.label', default: 'Trade tradeSubdate')}"/>
        <g:sortableColumn params="${params}"  property="tradeCommdate" title="${message(code: 'tbAgentpayDetailsInfo.tradeCommdate.label', default: 'Trade Commdate')}"/>
        <g:sortableColumn params="${params}"  property="tradeSyschkdate" title="${message(code: 'tbAgentpayDetailsInfo.tradeSyschkdate.label', default: 'Trade tradeSyschkdate')}"/>
        <g:sortableColumn params="${params}"  property="tradeDonedate" title="${message(code: 'tbAgentpayDetailsInfo.tradeDonedate.label', default: 'Trade Donedate')}"/>

        <g:sortableColumn params="${params}"  property="certificateType" title="${message(code: 'tbAgentpayDetailsInfo.certificateType.label', default: 'Certificate Type')}"/>
        <g:sortableColumn params="${params}"  property="certificateNum" title="${message(code: 'tbAgentpayDetailsInfo.certificateNum.label', default: 'Certificate Num')}"/>
        <g:sortableColumn params="${params}"  property="contractUsercode" title="${message(code: 'tbAgentpayDetailsInfo.contractUsercode.label', default: 'contract Usercode')}"/>


        <g:sortableColumn params="${params}"  property="tradeAccounttype" title="${message(code: 'tbAgentpayDetailsInfo.tradeAccounttype.label', default: 'Trade Account Type')}"/>
        <g:sortableColumn params="${params}"  property="tradeAmount" title="${message(code: 'tbAgentpayDetailsInfo.tradeAmount.label', default: 'Trade Amount')}"/>
        <g:sortableColumn params="${params}"  property="tradeFee" title="${message(code: 'tbAgentpayDetailsInfo.tradeFee.label', default: 'Trade Fee')}"/>
        %{-- <g:sortableColumn params="${params}"  property="tradeFeestyle" title="${message(code: 'tbAgentpayDetailsInfo.tradeFeestyle.label', default: 'Trade Fee Style')}"/>--}%
        %{--<g:sortableColumn params="${params}"  property="tradeFeetype" title="${message(code: 'tbAgentpayDetailsInfo.tradeFeetype.label', default: 'Trade Fee Type')}"/>--}%
        %{--<g:sortableColumn params="${params}"  property="tradeAccamount" title="${message(code: 'tbAgentpayDetailsInfo.tradeAccamount.label', default: 'Trade Acc amount')}"/>--}%
        <g:sortableColumn params="${params}"  property="payStatus" title="${message(code: 'tbAgentpayDetailsInfo.payStatus.label', default: 'Pay Status')}"/>
        <g:sortableColumn params="${params}"  property="chanelName" title="${message(code: 'tbAgentpayDetailsInfo.chanelName.label', default: 'chanelName')}"/>
        <g:sortableColumn params="${params}"  property="tradeFeedbackcode" title="${message(code: 'tbAgentpayDetailsInfo.tradeFeedbackcode.label', default: 'Trade Feedback Code')}"/>
        <g:sortableColumn params="${params}"  property="tradeReason" title="${message(code: 'tbAgentpayDetailsInfo.tradeReason.label', default: 'Trade Reason')}"/>
         <g:sortableColumn params="${params}"  property="tradeRefuse" title="${message(code: 'tbAgentpayDetailsInfo.tradeRefued.label', default: 'Trade tradeRefuse')}"/>
          <g:sortableColumn params="${params}"  property="tradeRefusedate" title="${message(code: 'tbAgentpayDetailsInfo.tradeRefusedate.label', default: 'Trade Reason')}"/>
      </tr>

      <g:each in="${tbAgentpayDetailsInfoInstanceList}" status="i" var="tbAgentpayDetailsInfoInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance?.batchBizid}</td>
          <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance?.id}</td>
          <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance?.batch.id}</td>
          <td nowrap="nowrap">${CmCustomer.findByCustomerNo(tbAgentpayDetailsInfoInstance?.batchBizid).name}</td>
          <td nowrap="nowrap"> ${TbAgentpayDetailsInfo.typeMap[tbAgentpayDetailsInfoInstance.tradeType]}</td>
          <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance?.tradeCardname}</td>
          <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance?.tradeAccountname}&nbsp;${tbAgentpayDetailsInfoInstance?.tradeBranchbank}&nbsp;${tbAgentpayDetailsInfoInstance?.tradeSubbranchbank}&nbsp;${tbAgentpayDetailsInfoInstance?.tradeCardnum}&nbsp;${tbAgentpayDetailsInfoInstance?.tradeProvince}${tbAgentpayDetailsInfoInstance?.tradeCity}</td>

            <td nowrap="nowrap"><g:formatDate date="${tbAgentpayDetailsInfoInstance.tradeSubdate}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td nowrap="nowrap"><g:formatDate date="${tbAgentpayDetailsInfoInstance.tradeCommdate}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td nowrap="nowrap"><g:formatDate date="${tbAgentpayDetailsInfoInstance.tradeSyschkdate}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td nowrap="nowrap"><g:formatDate date="${tbAgentpayDetailsInfoInstance.tradeDonedate}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td nowrap="nowrap">${TbAgentpayDetailsInfo.certificateTypeMap[tbAgentpayDetailsInfoInstance.certificateType]}</td>
          <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance?.certificateNum}</td>
          <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance?.contractUsercode}</td>

          <td nowrap="nowrap">${TbAgentpayDetailsInfo.accountTypeMap[tbAgentpayDetailsInfoInstance.tradeAccounttype]}</td>
          <g:if test="${tbAgentpayDetailsInfoInstance?.batchBizid=='100000000001524'}">
            <td nowrap="nowrap">***</td>
          </g:if>
          <g:else>
              <td nowrap="nowrap">
                  %{--${tbAgentpayDetailsInfoInstance?.tradeAmount}--}%
                  <g:formatNumber number="${tbAgentpayDetailsInfoInstance?.tradeAmount}" type="currency" currencyCode="CNY"/>
              </td>
          </g:else>
          <td nowrap="nowrap">
              <g:if test="${tbAgentpayDetailsInfoInstance?.tradeType=='F'}">
                  %{--${tbAgentpayDetailsInfoInstance?.tradeFee}--}%
                <g:formatNumber number="${tbAgentpayDetailsInfoInstance?.tradeFee}" type="currency" currencyCode="CNY"/>
              </g:if>
              <g:if test="${tbAgentpayDetailsInfoInstance?.tradeType=='S'}">0</g:if>
          </td>
          %{--<td nowrap="nowrap">${tbAgentpayDetailsInfoInstance?.tradeFeestyle}</td>--}%
          %{--<td nowrap="nowrap">${TbAgentpayDetailsInfo.feeTypeMap[tbAgentpayDetailsInfoInstance?.tradeFeetype]}</td>--}%
          %{--<td nowrap="nowrap"><g:formatNumber number="${tbAgentpayDetailsInfoInstance?.tradeAmount}" type="currency" currencyCode="CNY"/></td>--}%
          <td nowrap="nowrap">${TbAgentpayDetailsInfo.tradeStatusMap[tbAgentpayDetailsInfoInstance.tradeStatus]}</td>
            <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance?.channelName}</td>
          <td nowrap="nowrap">${TbAgentpayDetailsInfo.tradeFeedbackcodeMap[tbAgentpayDetailsInfoInstance.tradeFeedbackcode]}</td>
          <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance?.tradeReason}</td>
            <td nowrap="nowrap">${TbAgentpayDetailsInfo.tradeRefuedMap[tbAgentpayDetailsInfoInstance.tradeRefued]}</td>
            <td nowrap="nowrap"><g:formatDate date="${tbAgentpayDetailsInfoInstance?.tradeRefusedate}" format="yyyy-MM-dd HH:mm:ss"/></td>
        </tr>
      </g:each>
    </table>
      </div>
    合计：金额总计：<g:formatNumber number="${totalAmount?totalAmount:0}" format="#.##"/>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;手续费总计：<g:formatNumber number="${totalFee?totalFee:0}" format="#.##"/>元
    <div class="paginateButtons">
      <span class="left">共${tbAgentpayDetailsInfoInstanceTotal}条记录</span>
      <g:paginat total="${tbAgentpayDetailsInfoInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
<%
   batchObjValue = request.getAttribute("batchStatus");
 %>
<script type="text/javascript" >
    function checkBatchStatus(){

        var batchStatus = document.getElementById('batchStatus');
        var subForm = document.forms[0];
        var statusLength = subForm.batchStatus.length;
        if(batchStatus.checked){
            //alert(subForm.batchStatus.length);
         for(var i=1;i<statusLength;i++){
            subForm.batchStatus[i].checked = false;
             //subForm.batchStatus[i].disabled = true;
         }
         // subForm.batchStatus[1].checked = true;
        }else{
            /*for(var i=1;i<statusLength;i++){
             subForm.batchStatus[i].disabled = false;
         }*/

        }
  }

  function unCheckedBatchStatus(){
    document.getElementById('batchStatus').checked = false;
  }

     checkBatchStatus();
</script>

</body>

</html>
