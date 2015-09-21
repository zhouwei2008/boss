<%@ page import="pay.PtbPayBatch; boss.Perm; pay.PtbPayTrade" %>
<%@ page import="boss.BoAcquirerAccount" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: '打款明细')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript">
        function filter() {
            document.forms['tradesManagerF'].submit();
        }

        function cl() {

            var form = document.forms[0];
            for (var i = 0; i < form.elements.length; i++) {
                if (form.elements[i].type == "text" || form.elements[i].type == "text")
                    form.elements[i].value = "";
            }
            document.getElementById("bankId").value = "";
            document.getElementById("tradeAcctype").value = "";
        }

        function reSendCheckMsg(tradeId)
        {
            parent.showWait();
            $.ajax({
               url:'reSendCheckMsg', //后台处理程序
               type:'post',         //数据发送方式
               dataType:'json',     //接受数据格式
               data:{
                   tradeId:tradeId
               },                    //要传递的数据
               success:callBackReSendCheckMsg //回传函数(这里是函数名)
            });
        }
        function callBackReSendCheckMsg(data){
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
        $("#batchSTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#batchETime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#donedateSTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#donedateETime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });

   /*---guonan update 2011-12-30----*/
    function checkDate() {
        var startDateCreated = document.getElementById('startTime').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endTime').value.replace(/-/g,"//");
        var batchSTimeCreated = document.getElementById('batchSTime').value.replace(/-/g,"//");
        var batchETimeCreated = document.getElementById('batchETime').value.replace(/-/g,"//");
        var donedateSTime = document.getElementById('donedateSTime').value.replace(/-/g,"//");
        var donedateETime = document.getElementById('donedateETime').value.replace(/-/g,"//");

        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('请求时间 开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }

        if (batchETimeCreated.length != 0) {
            if (Number(batchSTimeCreated > batchETimeCreated)) {
                alert('处理时间  开始时间不能大于结束时间!');
                document.getElementById('batchETimeCreated').focus();
                return false;
            }
        }
        if (donedateETime.length != 0) {
            if (Number(donedateSTime > donedateETime)) {
                alert('对账时间  开始时间不能大于结束时间!');
                document.getElementById('donedateETime').focus();
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

         %{--<g:form name="tradesManagerF" action="tradesManagerF">--}%
        <div class="table_serch">
            <table align="center" class="right_list_table">
              <g:form name="tradesManagerF" action="tradesManagerF">
                <g:hiddenField name="tradeType" value="F"/>
                请求日期：<g:textField name="startTime" value="${params.startTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
                --<g:textField name="endTime" value="${params.endTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />

                处理日期：<g:textField name="batchSTime" value="${params.batchSTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
                --<g:textField name="batchETime" value="${params.batchETime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />

                对账日期：<g:textField name="donedateSTime" value="${params.donedateSTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
                --<g:textField name="donedateETime" value="${params.donedateETime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />

                <br>
                打款状态：<g:select id="tradeStatus" name="tradeStatus" from="${PtbPayTrade.TradeStatusMap}" optionKey="key" optionValue="value" value="${params.tradeStatus}" noSelection="${['':'-请选择-']}" class="right_top_h2_input" onChange="filter()"/>
                收款人：<g:textField name="tradeCardname" value="${params.tradeCardname}" size="10" class="right_top_h2_input" style="width:150px"/>
                收款账号：<g:textField name="tradeCardnum" value="${params.tradeCardnum}" size="10" class="right_top_h2_input" style="width:150px"/>
                收款银行：<g:select id="bankId" name="bankId" from="${bankList}" onChange="filter()" optionKey="${{it.BANKID}}" optionValue="${{it.BANKNAME}}" value="${params.bankId}" noSelection="${['':'--请选择--']}"  />
                <br>
                交易类型：<g:select name="tradeCode" from="${ptbPayTradeTypeList}" onChange="filter()" optionKey="${{it.payCode}}" optionValue="${{it.payName}}" value="${params.tradeCode}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
                账号类型：<g:select id="tradeAcctype" name="tradeAcctype" from="${PtbPayTrade.TradeAccTypeMap}" optionKey="key" optionValue="value" value="${params.tradeAcctype}" noSelection="${['':'-请选择-']}" class="right_top_h2_input" onChange="filter()"/>
                %{--卡类型：<g:select id="tradeCardtype" name="tradeCardtype" from="${PtbPayTrade.TradeCardTypeMap}" optionKey="key" optionValue="value" value="${params.tradeCardtype}" noSelection="${['':'-请选择-']}" class="right_top_h2_input" onChange="filter()"/>--}%
                打款渠道：<g:select  name="merchantId" from="${bankChanelList}" onChange="filter()" optionKey="${{it.MERCHANTID}}" optionValue="${{it.BANKNAME+'-'+it.ALIAS_NAME+'-'+it.SERVICECODE}}" value="${params.merchantId}" noSelection="${['':'--请选择--']}" />
                <br>
                交易号：<input name="tradeId" value="${params.tradeId}" onKeyUp="value = value.replace(/[^\d|]/g, '')">
                外部交易号：<input name="outTradeorder" value="${params.outTradeorder}" onKeyUp="value = value.replace(/[^\d|]/g, '')">
                批次号：<g:textField name="batchIdStart" value="${params.batchIdStart}" size="10" class="right_top_h2_input" style="width:100px"/>
                --  <g:textField name="batchIdEnd" value="${params.batchIdEnd}" size="10" class="right_top_h2_input" style="width:100px"/>
                所属商户：<g:textField name="name" value="${params.name}" size="10" class="right_top_h2_input" style="width:150px"/>
                <br>
                <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="filter();">
                <input type="button" class="right_top_h2_button_clear" value="清空" onClick="cl()">
                <bo:hasPerm perm="${Perm.NewAgPay_Trade_Dl}"><g:actionSubmit class="right_top_h2_button_tj" action="downTrades" value="下载Excel"  onclick="return checkDate()" /></bo:hasPerm>
                &nbsp; &nbsp;
                <bo:hasPerm perm="${Perm.NewAgPay_Trade_Dl_CSV}"><g:actionSubmit class="right_top_h2_button_tj" action="downTradesCSV" value="下载CSV"  onclick="return checkDate()" /></bo:hasPerm>
            </table>
         </div>
         <div class="right_list_tablebox" style="height: 380px">
                <table align="center" class="right_list_table">
                    <tr>
                        <g:sortableColumn params="${params}" property="t.TRADE_ID" title="交易号"/>
                        <g:sortableColumn params="${params}" property="t.OUT_TRADEORDER" title="外部交易号"/>
                        <g:sortableColumn params="${params}" property="t.BATCH_ID" title="批次号"/>
                        %{--<g:sortableColumn params="${params}" property="t.TRADE_BATCHSEQNO" title="交易序号"/>--}%
                        %{--<g:sortableColumn params="${params}" property="t.TRADE_TYPE" title="打款类型"/>--}%
                        <g:sortableColumn params="${params}" property="t.TRADE_CODE" title="交易类型"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_CARDNAME" title="收款人"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_CARDNUM" title="收款帐号"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_BANK" title="收款银行"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_SUBDATE" title="请求日期"/>
                        <g:sortableColumn params="${params}" property="b.BATCH_DATE" title="处理日期"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_DONEDATE" title="对账日期"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_ACCTYPE" title="账号类型"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_BRANCHBANK" title="分行"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_SUBBANK" title="支行"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_AMOUNT" title="金额"/>
                        <g:sortableColumn params="${params}" property="b.BATCH_CHANEL" title="打款通道"/>
                        <g:sortableColumn params="${params}" property="b.BATCH_STYLE" title="打款方式"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_STATUS" title="打款状态"/>
                        <g:sortableColumn params="${params}" property="t.TRADE_REASON" title="失败原因"/>
                        <td nowrap>操作</td>
                    </tr>
                    <g:each in="${ptbPayTradeList}" status="i" var="ptbPayTrade">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td nowrap>${ptbPayTrade.TRADE_ID}</td>
                            <td nowrap>${ptbPayTrade.OUT_TRADEORDER}</td>
                            <td nowrap>${ptbPayTrade.BATCH_ID}</td>
                            %{--<td nowrap>${ptbPayTrade.TRADE_BATCHSEQNO}</td>--}%
                            %{--<td nowrap>付款</td>--}%
                            <td nowrap>${ptbPayTrade.TRADE_NAME}</td>
                            <td nowrap>${ptbPayTrade.TRADE_CARDNAME}</td>
                            <td nowrap>${ptbPayTrade.TRADE_CARDNUM}</td>
                            <td nowrap>${ptbPayTrade.TRADE_BANK}</td>
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
                                <g:if test="${ptbPayTrade.TRADE_STATUS=='2'||ptbPayTrade.TRADE_STATUS=='3'}">
                                      <bo:hasPerm perm="${Perm.NewAgPay_Trade_ReSend}"><a onclick="reSendCheckMsg('${ptbPayTrade.TRADE_ID}');">重发通知</a></bo:hasPerm>
                                </g:if>
                            </td>
                        </tr>
                    </g:each>
                 </table>
            </div>
            <g:hiddenField name="batchStyle"/>
            <g:hiddenField name="totalCount" value="${totalCount}"/>
            <g:hiddenField name="totalMoney" value="${totalMoney}"/>

            <div class="paginateButtons">
                <div style=" float:left;">共${totalCount}条记录</div>
                <g:paginat total="${totalCount}" params="${params}"/>
            </div>
        </g:form>

        <div>
            合计笔数：${totalCount}笔&nbsp;&nbsp;&nbsp;&nbsp;金额：<g:formatNumber number="${totalMoney}" format="#.##"/>元
        </div>
    </div>
</div>

</body>
</html>
