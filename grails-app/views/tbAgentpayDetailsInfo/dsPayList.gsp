<%@ page import="boss.Perm; dsf.TbAgentpayDetailsInfo" %>
<%@ page import="boss.BoAcquirerAccount" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: '打款信息')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript">

        function selectCheck() {
            var items = document.getElementById("items")
            var bankSelect = document.getElementById("bankNameSearch")
            var bank = document.getElementById("bankName");

            /*for (i = 0; i < bankSelect.length; i++) {
                if (bankSelect[i].selected == true) {
                    bankName = bankSelect[i].innerText;
                    break
                }
            }*/

            /*if (bankName == '中国银联') {
                document.getElementById("chinapay").value = "chinapay";
            }
             if (bankName == '好易联') {
                document.getElementById("chinapay").value = "hchinapay";
            }*/
            if (items.value < 1) {
                alert("无记录,无法处理!");
                return false;
            }
            else if (bankSelect.value == "") {
                alert("请选择银行查询条件！");
                return false;
            }
            else if (bank.value == "") {
                alert("请选择打款渠道！");
                return false;
            }
            else {
                if(window.confirm("请确认您选择的银行渠道与银行匹配！")){
                    return true
                }else{
                    return false;
                }
            }

        }
        function cl() {

            var form = document.forms[0];
            for (var i = 0; i < form.elements.length; i++) {
                if (form.elements[i].type == "text" || form.elements[i].type == "text")
                    form.elements[i].value = "";
            }
            document.getElementById("bankNameSearch").value = "";

            document.getElementById("tradeAccounttype").value = "";
        }
        function filter() {
            var bank = document.getElementById("bankNameSearch");
            for (i = 0; i < bank.length; i++) {
                if (bank[i].selected == true) {
                    bankName = bank[i].innerText;      //关键是通过option对象的innerText属性获取到选项文本
                    break
                }
            }
            if (bankName == '中国银联') {
                 document.getElementById("chinapay").value = "chinapay";
                document.forms['dsPayList'].submit();
            } else if(bankName=='好易联'){
                document.getElementById("chinapay").value = "hchinapay";
                document.forms['dsPayList'].submit();
            } else{
                document.forms['dsPayList'].submit();
            }

        }
    </script>
</head>
<body>
<script type="text/javascript">
    /**
     * 格式化金额
     */
    function fmoney(s, n) {

        var svalue;
        n = n > 0 && n <= 20 ? n : 2;
        svalue = parseFloat((s.value + "").replace(/[^\d\.-]/g, "")).toFixed(n) + "";
        var l = svalue.split(".")[0].split("").reverse(),
                r = svalue.split(".")[1];
        t = "";
        for (i = 0; i < l.length; i++) {
            t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? "," : "");
        }
        s.value = t.split("").reverse().join("") + "." + r;
        return s.value;
    }
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
    <table align="center" class="right_list_table" id="test">
        <g:form name="dsPayList" action="dsPayList">
            <span style="color:red">*</span>&nbsp;付款银行：<g:select name="bankNameSearch" from="${bankNameList}" optionKey="bankCode" optionValue="note" value="${params.bankNameSearch}" noSelection="${['':'--请选择--']}" onchange="filter();"/>
            <g:hiddenField name="chinapay"/>
            <g:message code="日期"/>：
            <g:textField name="startTime" value="${params.startTime}" size="10" class="right_top_h2_input" style="width:80px" onchange="checkDate()" />
            -- <g:textField name="endTime" value="${params.endTime}" size="10" class="right_top_h2_input" style="width:80px" onchange="checkDate()" />
            商户编号：<g:textField name="batchBizid" value="${params.batchBizid}" size="20" class="right_top_h2_input" style="width:150px"/>

            业务类型：<g:select name="tradeType1" noSelection="${['':'代收']}" class="right_top_h2_input"/>

            <br>
            付款人：<g:textField name="tradeCardname" value="${params.tradeCardname}" size="10" class="right_top_h2_input" style="width:150px"/>
            付款账号：<g:textField name="tradeCardnum" value="${params.tradeCardnum}" size="10" class="right_top_h2_input" style="width:150px"/>
            账号类型：<g:select name="tradeAccounttype" from="${TbAgentpayDetailsInfo.accountTypeMap}" optionKey="key" optionValue="value" value="${params.tradeAccounttype}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>

            <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="filter();">
            <input type="button" class="right_top_h2_button_serch" value="清空" onclick="cl();">

            <g:hiddenField name="items" id="items" value="${tbAgentpayDetailsInfoInstanceTotal}"/>
            <g:hiddenField name="ids" id="ids"/>
            <tr>
                <g:sortableColumn params="${params}" property="batchId" title="${message(code: 'tbAgentpayDetailsInfo.batchId.label', default: 'Batch Id')}"/>

                <g:sortableColumn params="${params}" property="id" title="${message(code: 'tbAgentpayDetailsInfo.tradeNum.label', default: 'Trade Num')}"/>


                <td nowrap>业务类型</td>

                %{--<g:sortableColumn params="${params}"  property="tradeRemark2" title="${message(code: 'tbAgentpayDetailsInfo.tradeRemark2.label', default: 'Trade Remark2')}"/>--}%

                <g:sortableColumn params="${params}" property="tradeCardname" title="付款人"/>

                <g:sortableColumn params="${params}" property="tradeCardnum" title="付款账号"/>

                <g:sortableColumn params="${params}" property="tradeAccountname" title="付款银行"/>

                <g:sortableColumn params="${params}" property="tradeSysdate" title="${message(code: 'tbAgentpayDetailsInfo.tradeSysdate.label', default: 'Trade Sysdate')}"/>

                <g:sortableColumn params="${params}" property="tradeAccounttype" title="${message(code: 'tbAgentpayDetailsInfo.tradeAccounttype.label', default: 'Trade Account Type')}"/>

                <g:sortableColumn params="${params}" property="tradeBranchbank" title="${message(code: 'tbAgentpayDetailsInfo.tradeBranchbank.label', default: 'tradeBranchbank')}"/>

                <g:sortableColumn params="${params}" property="tradeSubbranchbank" title="${message(code: 'tbAgentpayDetailsInfo.tradeSubbranchbank.label', default: 'tradeSubbranchbank')}"/>

                <g:sortableColumn params="${params}" property="tradeAmount" title="${message(code: 'tbAgentpayDetailsInfo.tradeAmount.label', default: 'Trade Amount')}"/>

                <g:sortableColumn params="${params}" property="tradeFee" title="${message(code: 'tbAgentpayDetailsInfo.tradeFee.label', default: 'Trade Fee')}"/>

                <g:sortableColumn params="${params}" property="tradeFeetype" title="${message(code: 'tbAgentpayDetailsInfo.tradeFeetype.label', default: '收费方式')}"/>


                <g:sortableColumn params="${params}" property="tradeFeestyle" title="退手续费"/>

                <g:sortableColumn params="${params}" property="tradeAccamount" title="实收金额"/>
                <g:sortableColumn params="${params}" property="tradeRemark" title="省"/>
                <g:sortableColumn params="${params}" property="tradeRemark" title="市"/>


                <g:sortableColumn params="${params}" property="payStatus" title="${message(code: 'tbAgentpayDetailsInfo.payStatus.label', default: 'Pay Status')}"/>
            </tr>

            <g:each in="${tbAgentpayDetailsInfoInstanceList}" status="i" var="tbAgentpayDetailsInfoInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "batchBizid")}</td>

                    <td nowrap>${tbAgentpayDetailsInfoInstance.id}</td>

                    <td nowrap>代收</td>

                    %{--<TD> ${TbAgentpayDetailsInfo.typeMap[tbAgentpayDetailsInfoInstance.tradeType]}</TD>--}%
                    <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeCardname")}</td>

                    <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeCardnum")}</td>
                    <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeAccountname")}</td>

                    <td nowrap><g:formatDate date="${tbAgentpayDetailsInfoInstance.tradeSysdate}" format="yyyy-MM-dd HH:mm:ss"/></td>

                    <td nowrap>
                        ${TbAgentpayDetailsInfo.accountTypeMap[tbAgentpayDetailsInfoInstance.tradeAccounttype]}
                    </td>
                    <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeBranchbank")}</td>

                    <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeSubbranchbank")}</td>

                    <td nowrap>
                        <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.tradeAmount ? tbAgentpayDetailsInfoInstance.tradeAmount : 0}"/>
                        <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                    </td>
                    <td nowrap>
                        <g:if test="${tbAgentpayDetailsInfoInstance.tradeType=='F'}">
                            <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.tradeFee ? tbAgentpayDetailsInfoInstance.tradeFee : 0}"/>
                            <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                        </g:if>
                        <g:if test="${tbAgentpayDetailsInfoInstance.tradeType=='S'}">
                            ${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeFee")}
                        </g:if>
                    </td>

                    <td nowrap>${TbAgentpayDetailsInfo.feeTypeMap[tbAgentpayDetailsInfoInstance.tradeFeetype]}</td>
                    <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeFeestyle")}</td>



                    <td nowrap>
                        <g:if test="${tbAgentpayDetailsInfoInstance.tradeType=='F'}">
                            <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.tradeAmount ? tbAgentpayDetailsInfoInstance.tradeAmount : 0}"/>
                            <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                        </g:if>
                        <g:if test="${tbAgentpayDetailsInfoInstance.tradeType=='S'}">
                            ${TbAgentpayDetailsInfo.dkStatusMap[tbAgentpayDetailsInfoInstance.tradeAccamount]}
                        </g:if>
                    </td>

                    <td nowrap>${tbAgentpayDetailsInfoInstance.tradeRemark.split(';')[0]}</td>
                    <td nowrap>${tbAgentpayDetailsInfoInstance.tradeRemark.split(';')[1]}</td>

                    <td nowrap>${TbAgentpayDetailsInfo.dkStatusMap[tbAgentpayDetailsInfoInstance.payStatus]}</td>
                </tr>
            </g:each>
            </table>
            <table align="center">
                <tr>&nbsp;</tr>
                <tr>
                    <td align="center">
                        请选择打款渠道：
                        <g:select name="bankName" from="${bankChanelList}" optionKey="id" optionValue="${{it.bank.name+'-'+it.aliasName}}" noSelection="${['':'--请选择--']}"/>

                    </td>
                    <td>&nbsp;&nbsp;&nbsp;</td>
                    <td align="center">

                        <bo:hasPerm perm="${Perm.AgCol_ColChannel_Auto}"><g:actionSubmit id="handSubmit" align="center" class="right_top_h2_button_tj" value="自动打款" action="autoPay" onClick="return selectCheck();"/></bo:hasPerm>
                        %{--<g:actionSubmit id="autoSubmit" align="center" class="right_top_h2_button_tj" onclick='javascript:alert("此功能尚未开通")' value="自动打款" />--}%
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;</td>
                    <td align="center">
                        <g:hiddenField name="flag" id="flag" value="S"/>
                        <bo:hasPerm perm="${Perm.AgCol_ColChannel_Manual}"><g:actionSubmit id="handSubmit" align="center" class="right_top_h2_button_tj" action="handlePay" value="手工处理" onClick="return selectCheck();"/></bo:hasPerm>
                    </td>
                </tr>
            </table>
        </g:form>
        <div class="paginateButtons">
            <div style=" float:left;">共${tbAgentpayDetailsInfoInstanceTotal}条记录</div>
            <g:paginat total="${tbAgentpayDetailsInfoInstanceTotal}" params="${params}"/>
        </div>
        <div>
            <g:hiddenField name="m" value="${totalMoney}"/>
            <g:hiddenField name="f" value="${totalFee}"/>
            <g:hiddenField  name="a" value="${totalAccMoney}"/>
            %{--合计笔数:${tbAgentpayDetailsInfoInstanceTotal}&nbsp;  金额：<script>document.write(fmoney(document.getElementById("m"),2));</script>&nbsp;手续费：<script>document.write(fmoney(document.getElementById("f"),2));</script>&nbsp;实收/付金额： <script>document.write(fmoney(document.getElementById("m"),2));</script>--}%
            合计笔数：${tbAgentpayDetailsInfoInstanceTotal}笔&nbsp;&nbsp;&nbsp;&nbsp;金额：<g:formatNumber number="${totalMoney}" format="#.##"/>元&nbsp;&nbsp;&nbsp;&nbsp;手续费：<g:formatNumber number="${totalFee}" format="#.##"/>元&nbsp;&nbsp;&nbsp;&nbsp;实收金额：<g:formatNumber number="${totalAccMoney}" format="#.##"/>元
        </div>
    </div>
</div>
<script type="text/javascript">
    document.onkeydown = function() {
        if (document.activeElement.className != "right_top_h2_input") {
            if ((event.keyCode == 8) || (event.keyCode == 116) || (event.ctrlKey && event.keyCode == 82)) {
                event.keyCode = 0;
                event.returnValue = false;
            }
        }
    };
    document.oncontextmenu = function() {
        if (document.all) {
            event.cancelBubble = true;
            event.returnvalue = false;
            return false;
        }
    };
</script>
</body>
</html>
