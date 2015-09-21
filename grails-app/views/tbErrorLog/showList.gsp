<%@ page import="ismp.CmCustomer; boss.Perm;dsf.TbAgentpayDetailsInfo" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbErrorLog.label', default: '异常订单查询')}"/>
    <title><g:message code="default.search.label" args="[entityName]"/></title>
</head>
<body>
<style>
/*字符串截取*/
.aa {
    width: 150px;
    height: 24px;
    line-height: 24px;
    overflow: hidden;
    margin: 0px;
    color: #666;
    display: block;
    padding-left: 100px
}

span {
    display: -moz-inline-box;
    display: inline-block;
}
* {
 margin:0;
 padding:0
}
html, body {
 height: 100%;
 width: 100%;
 font-size:12px
}
.white_content {
 display: none;
 position: absolute;
 top: 25%;
 left: 25%;
 width: 50%;
 padding: 6px 16px;
 border: 12px solid #D6E9F1;
 background-color: white;
 z-index:1002;
 overflow: auto;
}
.black_overlay {
 display: none;
 position: absolute;
 top: 0%;
 left: 0%;
 width: 100%;
 height: 100%;
 background-color:#f5f5f5;
 z-index:1001;
 -moz-opacity: 0.8;
 opacity:.80;
 filter: alpha(opacity=80);
}
.close {
 float:right;
 clear:both;
 width:100%;
 text-align:right;
 margin:0 0 6px 0
}
.close a {
 color:#333;
 text-decoration:none;
 font-size:14px;
 font-weight:700
}
.con {
 text-indent:1.5pc;
 line-height:21px
}
</style>
<script type="text/javascript">
    $(function() {
        $("#tradeSubdateS").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#tradeSubdateE").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });


    /**
     *校验授权日期的开始日期和结束日期
     */
    function checkDate() {

        var tradeSubdateS = document.forms['showList'].tradeSubdateS.value;
        var tradeSubdateE = document.forms['showList'].tradeSubdateE.value;

        if (tradeSubdateS&&tradeSubdateE&&tradeSubdateS > tradeSubdateE) {
            alert('开始时间不能大于结束时间!');
            document.forms['showList'].tradeSubdateS.focus();
            return false;
        }
    }



  function empty() {
        $(':input') .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
        return false;
    }
  function show(tag,tradeOrder,errorMsg,errorMsgDetail){
 var light=document.getElementById(tag);
 var fade=document.getElementById('fade');
  var content = document.getElementById('errorMsg');
  var errorMsgDetailContent = document.getElementById('errorMsgDetail');
  var errorMsgDetailLabel =  document.getElementById('errorMsgDetailLabel');
  var tradeOrderDIV = document.getElementById('tradeOrder');
 light.style.display='block';
 fade.style.display='block';
 content.innerHTML = errorMsg;
 tradeOrderDIV.innerHTML = tradeOrder;
      if(errorMsgDetail){
         errorMsgDetailLabel.innerHTML = "详细异常：";
         errorMsgDetailContent.innerHTML = errorMsgDetail;
      }else{
         errorMsgDetailLabel.innerHTML = "";
         errorMsgDetailContent.innerHTML = "";
      }
 }
function hide(tag){
 var light=document.getElementById(tag);
 var fade=document.getElementById('fade');
 light.style.display='none';
 fade.style.display='none';
}
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form name="showList" action="showList">
                <span>
                    商户申请时间：<g:textField name="tradeSubdateS" value="${params.tradeSubdateS}" size="10" class="right_top_h2_input" style="width:100px"/>
                    到：<g:textField name="tradeSubdateE" value="${params.tradeSubdateE}" size="10" class="right_top_h2_input" style="width:100px"/>
                </span>

                <span>
                    商户编号：<g:textField name="customerNo" value="${params.customerNo}" size="20" class="right_top_h2_input" style="width:150px" />
                </span>
                <span>
                    商户名称：<g:textField name="customerName" value="${params.customerName}" size="20" class="right_top_h2_input" style="width:150px" />
                </span>
                <span>
                    交易号：<g:textField name="detailID" value="${params.detailID}" size="20" class="right_top_h2_input" style="width:150px" />
                </span>
                <span>
                    批次号：<g:textField name="batchID" value="${params.batchID}" size="20" class="right_top_h2_input" style="width:150px" />
                </span>
                <span>
                    <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkQuery();">
                    <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
                    <bo:hasPerm perm="${Perm.Agent_TbErrorLogAdmin_Download}"><g:actionSubmit class="right_top_h2_button_download" action="downloadTbErrorLog" onclick="return checkDate()" value="下载"/></bo:hasPerm>
                    <bo:hasPerm perm="${Perm.Agent_TbErrorLogAdmin_Download}"><g:actionSubmit class="right_top_h2_button_tj" action="downTbErrorLogCSV" onclick="return checkDate()" value="下载CSV"/></bo:hasPerm>
                </span>
                <g:hiddenField name="delID" value=""/>
                <g:hiddenField name="delOffset" value="${params.offset}"/>
            </g:form>
        </h2>
        <div class="right_list_tablebox" style="height: 380px">
            <table align="center" class="right_list_table" id="test">
                <tr>
                    <g:sortableColumn params="${params}" property="BATCH_BIZID" title="${message(code: 'tbAgentpayDetailsInfo.batchBizid.label', default: 'tbAgentpayDetailsInfo batchBizid')}"/>
                    <g:sortableColumn params="${params}" property="DETAIL_ID" title="${message(code: 'tbAgentpayDetailsInfo.detailId_.label', default: 'Detail Id')}"/>
                    <g:sortableColumn params="${params}" property="BATCH_ID" title="${message(code: 'tbAgentpayDetailsInfo.detailId.label', default: 'Detail Id')}"/>
                    <g:sortableColumn params="${params}" property="customerName" title="${message(code: 'ftLiquidate.customerName.label', default: 'Trade customerName')}"/>
                    <g:sortableColumn params="${params}"  property="TRADE_TYPE" title="${message(code: 'tbAgentpayDetailsInfo.tradeType.label', default: 'Trade tradeType')}"/>

                    <g:sortableColumn params="${params}"  property="TRADE_CARDNAME" title="${message(code: 'tbAgentpayDetailsInfo.tradeCardnameall.label', default: 'Trade Card Name')}"/>
                    <g:sortableColumn params="${params}"  property="TRADE_CARDNUM" title="${message(code: 'tbAgentpayDetailsInfo.tradeCustomerAccount.label', default: 'Trade Account Customer Account')}"/>

                    <g:sortableColumn params="${params}"  property="TRADE_SUBDATE" title="${message(code: 'tbAgentpayDetailsInfo.tradeSubdate.label', default: 'Trade tradeSubdate')}"/>
                    <g:sortableColumn params="${params}"  property="CERTIFICATE_TYPE" title="${message(code: 'tbAgentpayDetailsInfo.certificateType.label', default: 'Certificate Type')}"/>
                    <g:sortableColumn params="${params}"  property="CERTIFICATE_NUM" title="${message(code: 'tbAgentpayDetailsInfo.certificateNum.label', default: 'Certificate Num')}"/>


                    <g:sortableColumn params="${params}"  property="TRADE_ACCOUNTTYPE" title="${message(code: 'tbAgentpayDetailsInfo.tradeAccounttype.label', default: 'Trade Account Type')}"/>
                    <g:sortableColumn params="${params}"  property="TRADE_AMOUNT" title="${message(code: 'tbAgentpayDetailsInfo.tradeAmount.label', default: 'Trade Amount')}"/>
                    <g:sortableColumn params="${params}"  property="summary" title="${message(code: 'tbErrorLog.summary.label', default: 'tbErrorLog summary')}"/>
                    <td nowrap="nowrap">操作</td>
                </tr>

                <g:each in="${tbErrorLogList}" status="i" var="item">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td nowrap="nowrap">${item?.BATCH_BIZID}</td>
                        <td nowrap="nowrap">${item?.DETAIL_ID}</td>
                        <td nowrap="nowrap">${item?.BATCH_ID}</td>
                        <td nowrap="nowrap">${item?.customerName}</td>
                        <td nowrap="nowrap">${item?TbAgentpayDetailsInfo.tradeTypeMap[item.TRADE_TYPE]:""}</td>
                        <td nowrap="nowrap">${item?.TRADE_CARDNAME}</td>
                        <td nowrap="nowrap">${item?.TRADE_CARDNUM}</td>
                        <td nowrap="nowrap"><g:formatDate date="${item?.TRADE_SUBDATE}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        <td nowrap="nowrap">${item?TbAgentpayDetailsInfo.certificateTypeMap[item.CERTIFICATE_TYPE]:""}</td>
                        <td nowrap="nowrap">${item?.CERTIFICATE_NUM}</td>
                        <td nowrap="nowrap">${item?TbAgentpayDetailsInfo.accountTypeMap[item.TRADE_ACCOUNTTYPE]:""}</td>
                        <td nowrap="nowrap">${item?.TRADE_AMOUNT}</td>

                        <td nowrap="nowrap"><bo:hasPerm perm="${Perm.Agent_TbErrorLogAdmin_DetailInfo}"><a href="#" onclick="showDetail('${item?.id}','${item?.DETAIL_ID}')" >查看明细</a></bo:hasPerm></td>
                        <td nowrap="nowrap"><bo:hasPerm perm="${Perm.Agent_TbErrorLogAdmin_Checked}"><a href="#" onclick="checkErrorLog('${item?.id}')" >处理</a></bo:hasPerm></td>

                    </tr>
                </g:each>
            </table>
        </div>
        <div class="paginateButtons">
            <span class="left">共${tbErrorLogTotal}条记录</span>
            <g:paginat total="${tbErrorLogTotal}" params="${params}"/>
        </div>


    </div>
</div>
<div id="light" class="white_content" >

    %{--<div class="close"><a href="javascript:void(0)" onclick="hide('light')"> 关闭</a></div>--}%
     <B>异常原因显示</B>
    <br/>
    <hr size="3">
    <br/>
    <table width="90%">

        <tr>
            <td nowrap="nowrap">
                  交易号：
            </td>
            <td id = 'tradeOrder' align="left">

            </td>
        </tr>
           <tr>
            <td nowrap="nowrap" >
                  异常信息：
            </td>


            <td id = "errorMsg"  align="left">

            </td>
        </tr>
        <tr>
            <td id="errorMsgDetailLabel">
                  &nbsp;
            </td>
            <td id="errorMsgDetail" align = "left">
            </td>
        </tr>
        <tr>
            <td >

            </td>
            <td align="right">
                  <input type="button" style="width:50px;height:20px" value="关闭" onclick="hide('light')"/>
            </td>
        </tr>
    </table>

</div>

<div id="fade" class="black_overlay"></div>

 <script type="text/javascript">

function checkQuery() {
       var showList = document.forms['showList'];
           if(showList.entrustIsEffectRadio[1].checked){
            showList.entrustIsEffectRadio[1].checked = true;
            showList.entrustIsEffect.value = '1';
         }else{

            showList.entrustIsEffectRadio[0].checked = true;
            showList.entrustIsEffect.value = '0';
         }
        return checkDate();
    }


    function checkErrorLog(delID){
            if(!confirm('确认处理？')){
              return false;
            }
            var frm = document.forms['showList'];
            frm.delID.value = delID;
            frm.action="checkErrorLog";
            frm.method="post";
            frm.submit();
        }
     function showDetail(errorLogId,detailId){
          if (errorLogId) {
            $.getJSON('${createLink(action:'showDetail')}', {errorLogId: errorLogId}, function(data) {
                show('light',detailId,data.errorMsg,data.errorMsgDetail);
                //document.forms['saveForm'].customerName.value = data.errorMsg;
            })
        }
     }
 </script>
</body>

</html>


