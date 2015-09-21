<%@ page import="boss.Perm; dsf.TbPcInfo; dsf.TbAgentpayDetailsInfo" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: '交易')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript">
        var flag
        function cl() {

            var form = document.forms[0];
            for (var i = 0; i < form.elements.length; i++) {
                if (form.elements[i].type == "text" || form.elements[i].type == "text")
                    form.elements[i].value = "";
            }
            document.getElementById("tradeAccounttype").value = "";
            document.getElementById("bankName").value = "";
            document.getElementById("payStatus").value = "";
            document.getElementById("tbPcDkChanel").value = "";
        }
        function dis(obj) {
            if (obj.value == '9') {

                document.getElementById("tkdate").style.display = "block";
            }
            else {
                document.getElementById("tksTime").value = "";
                document.getElementById("tkeTime").value = "";
                document.getElementById("tkdate").style.display = "none";
            }

        }
        function int() {

            if (document.getElementById("payStatus").value == "9") {
                document.getElementById("tkdate").style.display = "block";
            }

        }
    </script>
</head>
<body onload="int()">
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
        int();
        $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#tksTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#tkeTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#dealSTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#dealETime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });


         /*---guonan update 2011-12-30----*/
    function checkDate() {
        var startDateCreated = document.getElementById('startTime').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endTime').value.replace(/-/g,"//");
         var tksTime = document.getElementById('tksTime').value.replace(/-/g,"//");
        var tkeTime = document.getElementById('tkeTime').value.replace(/-/g,"//");
         var dealSTime = document.getElementById('dealSTime').value.replace(/-/g,"//");
        var dealETime = document.getElementById('dealETime').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }
        if (tkeTime.length != 0) {
            if (Number(tksTime > tkeTime)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('tkeTime').focus();
                return false;
            }
        }
        if (dealETime.length != 0) {
            if (Number(dealSTime > dealETime)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('dealETime').focus();
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
    <table align="center" class="right_list_table" id="test">
        <g:form action="skitemselect">

            请求日期：<g:textField name="startTime" value="${params.startTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
            --<g:textField name="endTime" value="${params.endTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />

            处理日期：<g:textField name="dealSTime" value="${params.dealSTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
            --<g:textField name="dealETime" value="${params.dealETime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
            打款状态：<g:select name="payStatus" from="${TbAgentpayDetailsInfo.dkStatusMap}" optionKey="key" optionValue="value" value="${params.payStatus}" noSelection="${['':'-请选择-']}" class="right_top_h2_input" onchange="dis(this);"/>
            付款银行：<g:select name="bankName" from="${bankNameList}" optionKey="id" optionValue="name" noSelection="${['':'--请选择--']}" value="${params.bankName}"/>
            <br/>
            付款人：<g:textField name="tradeCardname" value="${params.tradeCardname}" size="10" class="right_top_h2_input" style="width:150px"/>
            付款账号：<g:textField name="tradeCardnum" value="${params.tradeCardnum}" size="10" class="right_top_h2_input" style="width:150px"/>

            打款通道：<g:select name="tbPcDkChanel" from="${bankChanelList}" optionKey="id" optionValue="${{it.bank.name+'-'+it.aliasName}}" value="${params.tbPcDkChanel}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
            业务类型：<g:select name="tradeType" from="${TbAgentpayDetailsInfo.skYwTypeMap}" optionKey="key" optionValue="value" value="${params.tradeType}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>

            <br/>
            商户编号：<g:textField name="batchBizid" value="${params.batchBizid}" size="20" class="right_top_h2_input" style="width:150px"/>
            批次号：<g:textField name="dkPcNo" value="${params.dkPcNo}" size="10" class="right_top_h2_input" style="width:150px"/>
            交易号：<input name="id" value="${params.id}" onKeyUp="value = value.replace(/[^\d|]/g, '')">
            账号类型：<g:select name="tradeAccounttype" from="${TbAgentpayDetailsInfo.accountTypeMap}" optionKey="key" optionValue="value" value="${params.tradeAccounttype}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>

            <br/>

            <div id="tkdate" style="display:none">
                退款日期：<g:textField name="tksTime" value="${params.tksTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
                --<g:textField name="tkeTime" value="${params.tkeTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
            </div>
            <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkDate()" />
            <input type="button" class="right_top_h2_button_serch" value="清空" onclick="cl();">
            <bo:hasPerm perm="${Perm.AgCol_Trade_Dl}" ><g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()" /></bo:hasPerm>

            <g:hiddenField name="ids" id="ids"/>
            <tr>
            </table>
            </div>
            <div class="right_list_tablebox">
                <table align="center" class="right_list_table" id="test">
                    <g:sortableColumn params="${params}" property="batchId" title="${message(code: 'tbAgentpayDetailsInfo.batchId.label', default: '客户编号')}"/>

                    <g:sortableColumn params="${params}" property="id" title="${message(code: 'tbAgentpayDetailsInfo.tradeNum.label', default: '交易号')}"/>

                    <g:sortableColumn params="${params}" property="dkPcNo" title="${message(code: 'tbAgentpayDetailsInfo.dkPcNo.label', default: '批次号')}"/>


                    <g:sortableColumn params="${params}" property="tradeType" title="${message(code: 'tbAgentpayDetailsInfo.tradeType.label', default: '业务类型')}"/>

                    <g:sortableColumn params="${params}" property="tradeCardname" title="${message(code: 'tbAgentpayDetailsInfo.tradeCardtype.label', default: '付款人')}"/>

                    <g:sortableColumn params="${params}" property="tradeCardnum" title="付款帐号"/>

                    <g:sortableColumn params="${params}" property="tradeAccountname" title="付款银行"/>


                    <g:sortableColumn params="${params}" property="tradeSysdate" title="请求日期"/>
                    <th>处理日期</th>
                    <g:sortableColumn params="${params}" property="tradeDonedate" title="完成日期"/>
                    <g:sortableColumn params="${params}" property="tradeAccounttype" title="账号类型"/>

                    <g:sortableColumn params="${params}" property="tradeBranchbank" title="分行"/>

                    <g:sortableColumn params="${params}" property="tradeSubbranchbank" title="支行"/>

                    <g:sortableColumn params="${params}" property="tradeAmount" title="金额"/>

                    <g:sortableColumn params="${params}" property="tradeFee" title="手续费"/>

                    <g:sortableColumn params="${params}" property="tradeFeestyle" title="退手续费"/>

                    <g:sortableColumn params="${params}" property="tradeFeetype" title="收费方式"/>

                    <g:sortableColumn params="${params}" property="tradeAmount" title="实收金额"/>

                    <g:sortableColumn params="${params}" property="fcheckName" title="收款初审"/>
                    <g:sortableColumn params="${params}" property="tcheckName" title="收款终审"/>

                    <th>打款通道</th>

                    <g:sortableColumn params="${params}" property="payStatus" title="打款状态"/>
                    <g:sortableColumn params="${params}" property="tradeReason" title="退回原因"/>
                    %{--<td nowrap>手工操作</td>--}%
                </tr>

                    <g:each in="${tbAgentpayDetailsInfoInstanceList}" status="i" var="tbAgentpayDetailsInfoInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "batchBizid")}</td>
                            <td nowrap>${tbAgentpayDetailsInfoInstance.id}</td>
                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "dkPcNo")}</td>
                            <td nowrap>${TbAgentpayDetailsInfo.skYwTypeMap[tbAgentpayDetailsInfoInstance.tradeType]}</td>
                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeCardname")}</td>
                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeCardnum")}</td>
                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeAccountname")}</td>
                            <td nowrap><g:formatDate date="${tbAgentpayDetailsInfoInstance.tradeSysdate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                            <td nowrap><g:formatDate date="${TbPcInfo.get((tbAgentpayDetailsInfoInstance?.dkPcNo) as long)?.tbPcDate}" format="yyyy-MM-dd HH:mm:ss"/></td>

                            <td nowrap><g:formatDate date="${tbAgentpayDetailsInfoInstance.tradeDonedate}" format="yyyy-MM-dd HH:mm:ss"/></td>
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
                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeFeestyle")}</td>
                            <td nowrap>
                                ${TbAgentpayDetailsInfo.feeTypeMap[tbAgentpayDetailsInfoInstance.tradeFeetype]}
                            </td>
                            <td nowrap>
                                <g:if test="${tbAgentpayDetailsInfoInstance.tradeType=='F'}">
                                    <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.tradeAmount ? tbAgentpayDetailsInfoInstance.tradeAmount : 0}"/>
                                    <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                                </g:if>
                                <g:if test="${tbAgentpayDetailsInfoInstance.tradeType=='S'}">
                                    ${TbAgentpayDetailsInfo.feeTypeMap[tbAgentpayDetailsInfoInstance.tradeAccamount]}
                                </g:if>
                            </td>
                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "fcheckName")}</td>
                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tcheckName")}</td>

                            <td nowrap>${TbPcInfo.get((tbAgentpayDetailsInfoInstance?.dkPcNo) as long)?.tbPcDkChanelname}</td>
                            <td nowrap>${TbAgentpayDetailsInfo.dkStatusMap[tbAgentpayDetailsInfoInstance.payStatus]}</td>

                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeReason")}</td>
                            %{--<td><g:link action="" >自动核对</g:link> |--}%
                            %{--<g:link action="updateS" id="${tbAgentpayDetailsInfoInstance.id}">改成功</g:link> |--}%
                           %{--<td><g:link action="updateF"  id="${tbAgentpayDetailsInfoInstance.id}">改失败</g:link></td>--}%

                        </tr>
                    </g:each>
                </table>
            </div>

        %{--</g:form>--}%
            <div class="paginateButtons">
                <span class="left">共${tbAgentpayDetailsInfoInstanceTotal}条记录</span>

                <g:hiddenField name="flag" value="S"/>
                <g:paginat total="${tbAgentpayDetailsInfoInstanceTotal}" params="${params}"/>
            </div>
        </g:form>

        <div>
            <g:hiddenField name="m" value="${totalMoney}"/>
            <g:hiddenField name="f" value="${totalFee}"/>
            <g:hiddenField name="a" value="${totalAccMoney}"/>
            %{--合计笔数:${tbAgentpayDetailsInfoInstanceTotal}&nbsp;  金额：<script>document.write(fmoney(document.getElementById("m"),2));</script>&nbsp;手续费：<script>document.write(fmoney(document.getElementById("f"),2));</script>&nbsp;实收/付金额： <script>document.write(fmoney(document.getElementById("m"),2));</script>--}%
            合计笔数：${tbAgentpayDetailsInfoInstanceTotal}笔&nbsp;&nbsp;&nbsp;&nbsp;金额：<g:formatNumber number="${totalMoney}" format="#.##"/>元&nbsp;&nbsp;&nbsp;&nbsp;手续费：<g:formatNumber number="${totalFee}" format="#.##"/>元&nbsp;&nbsp;&nbsp;&nbsp;实收金额：<g:formatNumber number="${totalAccMoney}" format="#.##"/>元

        </div>
    </div>
</div>
</body>
</html>
