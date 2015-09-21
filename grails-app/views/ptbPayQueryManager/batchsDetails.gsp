<%@ page import="pay.PtbPayBatch; boss.Perm; pay.PtbPayTrade" %>
<%@ page import="boss.BoAcquirerAccount" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:if test="${params.tradeType=='F'}">
        <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: '打款批次明细')}"/>
    </g:if>
    <g:if test="${params.tradeType=='S'}">
        <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: '收款批次明细')}"/>
    </g:if>


    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <style type="text/css">
        .showSelect{ border:1px solid #EEE;position:absolute; background:#fff; color:#333;  line-height:24px;}
        .showSelect p{ display:block; margin:0; color:#000; height:24px; line-height:24px; padding:0; text-align:left; cursor:pointer; background:#EEE;}
        .showSelect div{ padding:4px;}
        .showSelect label{ display:inline-block;  }
    </style>
    <script type="text/javascript">
         function filter() {
             document.forms['myForm'].action='${request.contextPath}/ptbPayQueryManager/batchsDetails';
             document.forms['myForm'].submit();
         }
         function cl() {

            var form = document.forms[0];
            for (var i = 0; i < form.elements.length; i++) {
                if (form.elements[i].type == "text" || form.elements[i].type == "text")
                    form.elements[i].value = "";
            }
        }

        function clickHide(htmlObj,id){
            show(htmlObj);
            $("#tradeId").attr("value",id);
            $("#failreason").attr("value",'');
            $("#failreasondiv").show();
            $("#btnCancel").click(function(){
            $("#failreasondiv").hide();
            });
        }

    function show(htmlObj){

	    var divId=document.getElementById("failreasondiv");

	    var rd=getPosition(htmlObj);
	    divId.style.right='10px';
	    divId.style.top=(rd.y+htmlObj.offsetHeight-20)+'px';
	    divId.style.width='300px';
	}

    // 得到对象的绝对坐标

	function getPosition(htmlObj){
	    var  rd = {x:0,y:0};
	    while(htmlObj)
	    {
	        rd.x  +=  htmlObj.offsetLeft;
	        rd.y  +=  htmlObj.offsetTop;
	        htmlObj= htmlObj.offsetParent;
	    }
	    return  rd;

	}
    function handleCheckTrade(flag){
        $("#flag").attr("value",flag);
        if($("#failreason").val().replace(/^\s+/,'').replace(/\s+$/,'')==''){
             alert("请填写失败原因!");
             return false
        }
        if($("#failreason").val().length>200){
             alert("失败原因 长度不能大于200!");
             return false
        }
         if(confirm("确定要置失败么?")){
            document.forms['myForm'].action='${request.contextPath}/ptbPayQueryManager/handleCheckTrade';
            document.forms['myForm'].submit();
         }else{
             return false;
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

    function checkDate() {
        var startDateCreated = document.getElementById('startTime').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endTime').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('请求时间 开始时间不能大于结束时间!');
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
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>

        </h2>

        <div class="table_serch">
            <table align="center" class="right_list_table">
              <g:form name="myForm" action="batchsDetails">
                请求日期：<g:textField name="startTime" value="${params.startTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
                --<g:textField name="endTime" value="${params.endTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
                收款人：<g:textField name="tradeCardname" value="${params.tradeCardname}" size="10" class="right_top_h2_input" style="width:150px"/>
                收款账号：<g:textField name="tradeCardnum" value="${params.tradeCardnum}" size="10" class="right_top_h2_input" style="width:150px"/>
                金额：<input name="tradeAmount" value="${params.tradeAmount}" size="10" class="right_top_h2_input" style="width:150px" onKeyUp="value = value.replace(/[^\d|\.\,]/g, '').replace(',','')"/>
                <br/>
                外部交易号：<input name="outTradeorder" value="${params.outTradeorder}" onKeyUp="value = value.replace(/[^\d|]/g, '')">
                序列号：<g:textField name="tradeBatchseqno" value="${params.tradeBatchseqno}" size="10" class="right_top_h2_input" style="width:150px"/>
                <br/>
                <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="filter();">
                <input type="button" class="right_top_h2_button_serch" value="清空" onClick="cl()">
                <g:actionSubmit class="right_top_h2_button_download" action="downBatchsDetails" value="下载" />
            </table>
         </div>

         <div class="right_list_tablebox" style="height: 380px">
                <table align="center" class="right_list_table">
                    <tr>
                        <g:sortableColumn params="${params}" property="t.TRADE_BATCHSEQNO" title="序列号"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_ID" title="交易号"/>
                        <g:sortableColumn params="${params}" property="t.OUT_TRADEORDER" title="外部交易号"/>
                        <g:sortableColumn params="${params}" property="t.BATCH_ID" title="批次号"/>
                        %{--<g:sortableColumn params="${params}" property="t.TRADE_TYPE" title="打款类型"/>--}%
                        <g:sortableColumn params="${params}" property="t.TRADE_CODE" title="交易类型"/>

                        <g:if test="${params.tradeType=='F'}">
                            <g:sortableColumn params="${params}" property="t.TRADE_CARDNAME" title="收款人"/>
                        </g:if>

                        <g:if test="${params.tradeType=='S'}">
                            <g:sortableColumn params="${params}" property="t.TRADE_CARDNAME" title="付款人"/>
                        </g:if>

                        <g:if test="${params.tradeType=='F'}">
                            <g:sortableColumn params="${params}" property="t.TRADE_CARDNUM" title="收款帐号"/>
                        </g:if>

                        <g:if test="${params.tradeType=='S'}">
                            <g:sortableColumn params="${params}" property="t.TRADE_CARDNUM" title="付款帐号"/>
                        </g:if>

                        <g:if test="${params.tradeType=='F'}">
                            <g:sortableColumn params="${params}" property="t.TRADE_BANK" title="收款银行"/>
                        </g:if>

                        <g:if test="${params.tradeType=='S'}">
                            <g:sortableColumn params="${params}" property="t.TRADE_BANK" title="付款银行"/>
                        </g:if>

                        <g:if test="${params.tradeType=='S'}">
                            <g:sortableColumn params="${params}" property="t.TRADE_USERCODE" title="协议号"/>
                            <g:sortableColumn params="${params}" property="t.TRADE_CERTTYPE" title="证件类型"/>
                            <g:sortableColumn params="${params}" property="t.TRADE_CERTNO" title="证件号码"/>
                        </g:if>

                        <g:sortableColumn params="${params}" property="t.TRADE_SUBDATE" title="请求日期"/>
                        <g:sortableColumn params="${params}" property="b.BATCH_DATE" title="处理日期"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_DONEDATE" title="对账日期"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_ACCTYPE" title="账号类型"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_BRANCHBANK" title="分行"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_SUBBANK" title="支行"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_AMOUNT" title="金额"/>

                        <g:if test="${params.tradeType=='F'}">
                            <g:sortableColumn params="${params}" property="b.BATCH_CHANEL" title="打款通道"/>
                        </g:if>

                        <g:if test="${params.tradeType=='S'}">
                            <g:sortableColumn params="${params}" property="b.BATCH_CHANEL" title="收款通道"/>
                        </g:if>

                        <g:if test="${params.tradeType=='F'}">
                            <g:sortableColumn params="${params}" property="b.BATCH_STYLE" title="打款方式"/>
                        </g:if>

                        <g:if test="${params.tradeType=='S'}">
                            <g:sortableColumn params="${params}" property="b.BATCH_STYLE" title="收款方式"/>
                        </g:if>

                        <g:if test="${params.tradeType=='F'}">
                            <g:sortableColumn params="${params}" property="t.TRADE_STATUS" title="打款状态"/>
                        </g:if>

                        <g:if test="${params.tradeType=='S'}">
                            <g:sortableColumn params="${params}" property="t.TRADE_STATUS" title="收款状态"/>
                        </g:if>

                        <g:sortableColumn params="${params}" property="t.TRADE_REASON" title="失败原因"/>
                        <td nowrap>操作</td>
                    </tr>
                    <g:each in="${ptbPayTradeList}" status="i" var="ptbPayTrade">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td nowrap>${ptbPayTrade.TRADE_BATCHSEQNO}</td>
                            <td nowrap>${ptbPayTrade.TRADE_ID}</td>
                            <td nowrap>${ptbPayTrade.OUT_TRADEORDER}</td>
                            <td nowrap>${ptbPayTrade.BATCH_ID}</td>
                            %{--<td nowrap>${PtbPayTrade.TradeTypeMap[ptbPayTrade.TRADE_TYPE]}</td>--}%
                            <td nowrap>${ptbPayTrade.TRADE_NAME}</td>
                            <td nowrap>${ptbPayTrade.TRADE_CARDNAME}</td>
                            <td nowrap>${ptbPayTrade.TRADE_CARDNUM}</td>
                            <td nowrap>${ptbPayTrade.TRADE_BANK}</td>

                            <g:if test="${params.tradeType=='S'}">
                                <td nowrap>${ptbPayTrade.TRADE_USERCODE}</td>
                                <td nowrap>${PtbPayTrade.TradeCerttypeMap[ptbPayTrade.TRADE_CERTTYPE]}</td>
                                <td nowrap>${ptbPayTrade.TRADE_CERTNO}</td>
                            </g:if>

                            <td nowrap><g:formatDate date="${ptbPayTrade.TRADE_SUBDATE}" format="yyyy-MM-dd HH:mm:ss"/></td>
                            <td nowrap><g:formatDate date="${ptbPayTrade.BATCH_DATE}" format="yyyy-MM-dd HH:mm:ss"/></td>
                            <td nowrap><g:formatDate date="${ptbPayTrade.TRADE_DONEDATE}" format="yyyy-MM-dd HH:mm:ss"/></td>
                            <td nowrap>${PtbPayTrade.TradeAccTypeMap[ptbPayTrade.TRADE_ACCTYPE]}</td>
                            <td nowrap>${ptbPayTrade.TRADE_BRANCHBANK}</td>
                            <td nowrap>${ptbPayTrade.TRADE_SUBBANK}</td>
                            <td nowrap>
                                <g:set var="amt" value="${ptbPayTrade.TRADE_AMOUNT ? ptbPayTrade.TRADE_AMOUNT : 0}"/>
                                <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                            </td>
                            <td nowrap>${ptbPayTrade.BATCH_CHANELNAME}</td>
                            <td nowrap>${PtbPayBatch.BatchStyleMap[ptbPayTrade.BATCH_STYLE]}</td>
                            <td nowrap>${PtbPayTrade.TradeStatusMap[ptbPayTrade.TRADE_STATUS]}</td>
                            <td nowrap>${ptbPayTrade.TRADE_REASON}</td>
                            <td nowrap>
                                <g:if test="${ptbPayTrade.BATCH_STYLE=='handle'&&(ptbPayTrade.TRADE_STATUS=='0'||ptbPayTrade.TRADE_STATUS=='1')}">
                                    <g:if test="${params.tradeType=='F'}">
                                        <bo:hasPerm perm="${Perm.NewAgPay_Batch_View_ChangeFail}">
                                            <a onclick="clickHide(this,'${ptbPayTrade.TRADE_ID}')" >置失败</a>
                                        </bo:hasPerm>
                                    </g:if>
                                    <g:if test="${params.tradeType=='S'}">
                                        <bo:hasPerm perm="${Perm.NewAgCol_Batch_View_ChangeFail}">
                                            <a onclick="clickHide(this,'${ptbPayTrade.TRADE_ID}')" >置失败</a>
                                        </bo:hasPerm>
                                    </g:if>

                                </g:if>
                            </td>
                        </tr>
                    </g:each>
                 </table>
                <g:hiddenField name="tradeId" id="tradeId"/>
                <g:hiddenField name="flag" id="flag"/>

                <div id="failreasondiv" class="showSelect" style="display:none;text-align:center">
				   <p><strong style="padding-left: 30%;width:60%;">填写失败原因</strong></p>

				  <div>
				    <g:textArea id="failreason" name="failreason"  rows="5" cols="20"/>
				 </div>
				  <div><input type="button" value="确定" id="btnEnd" onclick="handleCheckTrade('fail');"/>
                       &nbsp;
                       <input type="button" value="取消" id="btnCancel"/>
                  </div>
				</div>

            </div>
            <g:hiddenField name="batchId" value="${params.batchId}"/>
            <g:hiddenField name="tradeType" value="${params.tradeType}"/>
            <g:hiddenField name="offsetOld" value="${params.offset}"/>
        </g:form>
        <div class="paginateButtons">
            <div style=" float:left;">共${totalCount}条记录</div>
            <g:paginat total="${totalCount}" params="${params}"/>
        </div>
        <div>
            合计笔数：${totalCount}笔&nbsp;&nbsp;&nbsp;&nbsp;金额：<g:formatNumber number="${totalMoney}" format="#.##"/>元
        </div>
        <div style="text-align:center">
            <g:form>
                <g:if test="${params.tradeType=='F'}">
                    <span class="button"><g:actionSubmit  class="rigt_button" action="batchsManagerF" value="返回" onclick="return true"/></span>
                </g:if>
                <g:if test="${params.tradeType=='S'}">
                    <span class="button"><g:actionSubmit  class="rigt_button" action="batchsManagerS" value="返回" onclick="return true"/></span>
                </g:if>
            </g:form>
        </div>
    </div>
</div>

</body>
</html>
