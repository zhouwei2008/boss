<%@ page import="boss.Perm; pay.PtbPayTrade" %>
<%@ page import="boss.BoAcquirerAccount" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: '打款信息')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript">
        parent.hideWait();
        function filter() {
            /* 旧版 模糊匹配
            var bankName="";

            var bank = document.getElementById("bankId");
            for (i = 0; i < bank.length; i++) {
                if (bank[i].selected == true) {
                    bankName = bank[i].innerHTML;      //关键是通过option对象的innerHTML属性获取到选项文本
                    break
                }
            }
            if(bankName.indexOf('好易联')!=-1){
                document.getElementById("unionPay").value = "HCHINAPAY";
            } else if(bankName.indexOf('中国银联')!=-1){
                document.getElementById("unionPay").value = "UNIONPAY";
            }*/
            var len = document.getElementsByName("boxBankId").length;
            var boxBankIds = "";
            var flag = 0;
            for (i = 0; i < len; i++) {
                if (document.getElementsByName("boxBankId")[i].checked) {
                    boxBankIds = boxBankIds + document.getElementsByName("boxBankId")[i].value + ",";
                    flag = 1;
                }
            }
            document.getElementById("boxBankIds").value = boxBankIds;
            document.forms['pdkList'].submit();
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


        function selectCheck(batchStyle) {
            if(batchStyle=='auto'){
                if(!confirm("你选择了“自动打款”，此操作不可逆转，请确认是否要继续？")){
                    return false;
                }
            }else{
                if(!confirm("确认要继续么？")){
                    return false;
                }
            }

            document.getElementById("batchStyle").value = batchStyle;
            var totalCount = document.getElementById("totalCount");
            var chanels = document.getElementById("merchantId");

            var tradeAcctype = document.getElementById("tradeAcctype");
            var tradeCardtype = document.getElementById("tradeCardtype");
            var bankId = document.getElementById("bankId");
            var bankChanelName = "";
            for (i = 0; i < chanels.length; i++) {
                if (chanels[i].selected == true) {
                    bankChanelName = chanels[i].innerHTML.split('-')[0];      //关键是通过option对象的innerText属性获取到选项文本
                    break;
                }
            }
            if (totalCount.value < 1) {
                alert("无记录,无法处理");
                return false;
            }
            else if (chanels.value == "") {
                alert("请选择打款渠道！");
                return false;
            }
            else if (bankChanelName.indexOf('建设银行')!=-1 && tradeAcctype.value == "") {
                alert("请选择账号类型!")
                return false;
            }
            else if (bankChanelName.indexOf('中国银行')!=-1 && tradeCardtype.value == "") {
                alert("请选择卡类型!")
                return false;
            }
            else if (bankChanelName.indexOf('华夏银行')!=-1 && tradeAcctype.value == "") {
                alert("请选择账号类型!");
                return false;
            }else if(bankChanelName.indexOf('汇付')!=-1 || bankChanelName.indexOf('汇付宝')!=-1 || bankChanelName.indexOf('8009')!=-1) {
                if(tradeAcctype.value == ""){
                    alert("请选择账号类型!");
                    return false;
                }
            }else {
                parent.showWait();
                return true;
            }
        }




        function onChanelChange()
        {
            var merchantId = $("#merchantId").val()
            if(merchantId==''){
                document.getElementById("autoSubmit").style.display = 'none'
                document.getElementById("handSubmit").style.display = 'none'
                return false;
            }
            var tradeType = $("#tradeType").val()
            $.ajax({
               url:'onChanelChange', //后台处理程序
               type:'post',         //数据发送方式
               dataType:'json',     //接受数据格式
               data:{
                   merchantId:merchantId,
                   tradeType:tradeType
               },                    //要传递的数据
               success:callBackChanelChange //回传函数(这里是函数名)
            });
        }
        function callBackChanelChange(data){
            var msg = null
            if(data!=null){
                if(data.autoOrHandle!=null){
                    if(data.autoOrHandle=='auto'){
                        document.getElementById("autoSubmit").style.display = 'block'
                        document.getElementById("handSubmit").style.display = 'none'
                    }else if(data.autoOrHandle=='handle'){
                        document.getElementById("autoSubmit").style.display = 'none'
                        document.getElementById("handSubmit").style.display = 'block'
                    }else if(data.autoOrHandle=='all'){
                        document.getElementById("autoSubmit").style.display = 'block'
                        document.getElementById("handSubmit").style.display = 'block'
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
                document.getElementById("autoSubmit").style.display = 'none'
                document.getElementById("handSubmit").style.display = 'none'
                alert(msg)
            }

        }
    </script>
</head>
<body>
<script type="text/javascript">
    $(function(){
        onChanelChange();
    });
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
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>

        </h2>
    <div class="table_serch">
       <g:form name="pdkList" action="pdkList">
           <g:hiddenField name="tradeType" value="F"/>
          <table align="center" class="right_list_table" id="test">
            开始时间：<g:textField name="startTime" value="${params.startTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
            结束时间：<g:textField name="endTime" value="${params.endTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
            交易类型：<g:select name="tradeCode" from="${ptbPayTradeTypeList}" onChange="filter()" optionKey="${{it.payCode}}" optionValue="${{it.payName}}" value="${params.tradeCode}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
            账号类型：<g:select id="tradeAcctype" name="tradeAcctype" from="${PtbPayTrade.TradeAccTypeMap}" optionKey="key" optionValue="value" value="${params.tradeAcctype}" noSelection="${['':'-请选择-']}" class="right_top_h2_input" onChange="filter()"/>
            %{--卡类型：<g:select id="tradeCardtype" name="tradeCardtype" from="${PtbPayTrade.TradeCardTypeMap}" optionKey="key" optionValue="value" value="${params.tradeCardtype}" noSelection="${['':'-请选择-']}" class="right_top_h2_input" onChange="filter()"/>--}%
            收款银行：<g:select id="bankId" name="bankId" from="${bankList}" onChange="filter()" optionKey="${{it.BANKID}}" optionValue="${{it.BANKNAME}}" value="${params.bankId}" noSelection="${['':'--请选择--']}"  />
            <br>
            <span >
            <g:each in="${boxBankList}" status="i" var="bank">
                <g:if test="${boxBankArr != null && boxBankArr.size() > 0}">
                    <g:each in="${boxBankArr}" status="j" var="arr">
                        <g:if test="${arr == bank.BANKCODE}">
                            <g:checkBox name="boxBankId" value="${bank.BANKCODE}"  checked="true"></g:checkBox> ${bank.BANKNAME}
                            <g:set var="mark" value="${i}"/>
                        </g:if>
                    </g:each>
                    <g:if test="${mark != i}">
                        <g:checkBox name="boxBankId" value="${bank.BANKCODE}"  checked="false"></g:checkBox> ${bank.BANKNAME}
                    </g:if>
                </g:if>
                <g:else>
                    <g:checkBox name="boxBankId" value="${bank.BANKCODE}"  checked="false"></g:checkBox> ${bank.BANKNAME}
                </g:else>
           </g:each>
            </span>
            <br>
            收款人：<g:textField name="tradeCardname" value="${params.tradeCardname}" size="10" class="right_top_h2_input" style="width:150px"/>
            收款账号：<g:textField name="tradeCardnum" value="${params.tradeCardnum}" size="10" class="right_top_h2_input" style="width:150px"/>
            外部交易号：<g:textField name="outTradeorder" value="${params.outTradeorder}" size="10" class="right_top_h2_input" style="width:150px"/>

            <g:hiddenField name="unionPay"/>
            <g:hiddenField name="boxBankIds" id="boxBankIds"/>
            <br/>
            <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="filter();">
            <input type="button" class="right_top_h2_button_serch" value="清空" onClick="cl()">
        </table>
 </div>
 <div class="right_list_tablebox" style="height: 380px">
        <table align="center" class="right_list_table">
            <tr>

                <g:sortableColumn params="${params}" property="id" title="${message(code: 'tbAgentpayDetailsInfo.tradeNum.label', default: 'Trade Num')}"/>
                <g:sortableColumn params="${params}" property="outTradeorder" title="外部交易号"/>
                %{--<td nowrap>打款类型</td>--}%
                <g:sortableColumn params="${params}" property="tradeCode" title="交易类型"/>
                <g:sortableColumn params="${params}" property="tradeCardname" title="收款人"/>

                <g:sortableColumn params="${params}" property="tradeCardnum" title="收款账号"/>

                <g:sortableColumn params="${params}" property="tradeBank" title="收款银行"/>

                <g:sortableColumn params="${params}" property="tradeSubdate" title="${message(code: 'tbAgentpayDetailsInfo.tradeSysdate.label', default: 'Trade Sysdate')}"/>

                <g:sortableColumn params="${params}" property="tradeAcctype" title="${message(code: 'tbAgentpayDetailsInfo.tradeAccounttype.label', default: 'Trade Account Type')}"/>

                <g:sortableColumn params="${params}" property="tradeBranchbank" title="${message(code: 'tbAgentpayDetailsInfo.tradeBranchbank.label', default: 'tradeBranchbank')}"/>

                <g:sortableColumn params="${params}" property="tradeSubbank" title="${message(code: 'tbAgentpayDetailsInfo.tradeSubbranchbank.label', default: 'tradeSubbranchbank')}"/>

                <g:sortableColumn params="${params}" property="tradeAmount" title="${message(code: 'tbAgentpayDetailsInfo.tradeAmount.label', default: 'Trade Amount')}"/>

                <g:sortableColumn params="${params}" property="tradeProvince" title="省"/>
                <g:sortableColumn params="${params}" property="tradeCity" title="市"/>

            </tr>

            <g:each in="${ptbPayTradeList}" status="i" var="ptbPayTrade">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td nowrap>${ptbPayTrade.id}</td>
                    <td nowrap>${ptbPayTrade.outTradeorder}</td>
                    %{--<td nowrap>付款</td>--}%
                    <td nowrap>${fieldValue(bean: ptbPayTrade, field: "tradeName")}</td>
                    <td nowrap>${fieldValue(bean: ptbPayTrade, field: "tradeCardname")}</td>

                    <td nowrap>${fieldValue(bean: ptbPayTrade, field: "tradeCardnum")}</td>
                    <td nowrap>${fieldValue(bean: ptbPayTrade, field: "tradeBank")}</td>

                    <td nowrap><g:formatDate date="${ptbPayTrade.tradeSubdate}" format="yyyy-MM-dd HH:mm:ss"/></td>

                    <td nowrap>
                        ${PtbPayTrade.TradeAccTypeMap[ptbPayTrade.tradeAcctype]}
                    </td>
                    <td nowrap>${fieldValue(bean: ptbPayTrade, field: "tradeBranchbank")}</td>

                    <td nowrap>${fieldValue(bean: ptbPayTrade, field: "tradeSubbank")}</td>

                    <td nowrap>
                        <g:set var="amt" value="${ptbPayTrade.tradeAmount ? ptbPayTrade.tradeAmount : 0}"/>
                        <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                    </td>
                    <td nowrap>${ptbPayTrade.tradeProvince}</td>
                    <td nowrap>${ptbPayTrade.tradeCity}</td>
                </tr>
            </g:each>
            </table>
        </div>
            <table align="center">
                <tr>&nbsp;</tr>
                <tr>
                    <td align="center">
                        请选择打款渠道：
                        <g:select onChange="onChanelChange()" name="merchantId" from="${bankChanelList}" optionKey="${{it.MERCHANTID}}" optionValue="${{it.BANKNAME+'-'+it.ALIAS_NAME+'-'+it.SERVICECODE}}" value="${params.merchantId}" noSelection="${['':'--请选择--']}" />

                    </td>
                    <td>&nbsp;&nbsp;&nbsp;</td>
                    <td align="center">
                        <span id="autoSubmit">
                            <bo:hasPerm perm="${Perm.NewAgPay_PayChannel_Auto}"><g:actionSubmit align="center" class="right_top_h2_button_tj" action = "makeBatch" value="自动打款" onClick="return selectCheck('auto');"/></bo:hasPerm>
                        </span>
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;</td>
                    <td align="center">
                        <span id="handSubmit">
                              <bo:hasPerm perm="${Perm.NewAgPay_PayChannel_Manual}"><g:actionSubmit align="center" class="right_top_h2_button_tj" action="makeBatch" value="手工处理" onclick="return selectCheck('handle');"/></bo:hasPerm>
                        </span>
                    </td>
                </tr>
            </table>
            <g:hiddenField name="batchStyle"/>
            <g:hiddenField name="totalCount" value="${totalCount}"/>
            <g:hiddenField name="totalMoney" value="${totalMoney}"/>
        </g:form>
        <div class="paginateButtons">
            <div style=" float:left;">共${totalCount}条记录</div>
            <g:paginat total="${totalCount}" params="${params}"/>
        </div>
        <div>


            合计笔数：${totalCount}笔&nbsp;&nbsp;&nbsp;&nbsp;金额：<g:formatNumber number="${totalMoney}" format="#.##"/>元

        </div>
    </div>
</div>

</body>
</html>
