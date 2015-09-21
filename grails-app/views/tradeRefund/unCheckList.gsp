<%@ page import="boss.BoMerchant; boss.BoAcquirerAccount; boss.BoBankDic; boss.Perm; boss.AppNote; gateway.GwTransaction; ismp.TradeCharge; ismp.TradePayment; ismp.TradeBase; ismp.TradeRefund" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeRefund.unCheckList.label', default: 'TradeRefund')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <link rel="stylesheet" type="text/css" href="../ext/css/ext-all.css"/>
    <link rel="stylesheet" type="text/css" href="../ext/css/style.css"/>
    <script type="text/javascript" src="../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../ext/js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ext/js/common.js"></script>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });
    function checkDate() {
        var startDate = document.getElementById("startDateCreated").value;
        var endDate = document.getElementById("endDateCreated").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endDateCreated").focus();
            return false;
        }
    }
    /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startDateCreated = document.getElementById('startDateCreated').value.replace(/-/g, "//");
        var endDateCreated = document.getElementById('endDateCreated').value.replace(/-/g, "//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间！');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }
        // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectF = new Date(startDateCreated);
        var dSelectT = new Date(endDateCreated);
        var theFromM = dSelectF.getMonth();
        var theFromD = dSelectF.getDate();
        // 设置起始日期加一个月
        theFromM += 1;
        dSelectF.setMonth(theFromM, theFromD);
        if (dSelectF < dSelectT) {
            alert('每次只能查询1个月范围内的数据！');
            return false;
        }
    }
    function cl() {
        var form = document.forms[0];
        for (var i = 0; i < form.elements.length; i++) {
            if (form.elements[i].type == "text" || form.elements[i].type == "text")
                form.elements[i].value = "";
        }
        document.getElementById("bankName").value = "-1";
        document.getElementById("channel").value = "-1";
        document.getElementById("startDateCreated").focus();
    }
    function checkAll() {
        var len = document.getElementsByName("chbox").length;
        var ck = document.getElementById("ckb")
        if (document.getElementById("ckb").checked) {
            for (i = 0; i < len; i++) {
                document.getElementsByName("chbox")[i].checked = true;
            }
        } else {
            for (i = 0; i < len; i++) {
                document.getElementsByName("chbox")[i].checked = false;
            }
        }
    }
    function ckAll() {
        var name = document.getElementById("all").value;
        var len = document.getElementsByName("chbox").length;
        if (name == "全选") {
            for (i = 0; i < len; i++) {
                document.getElementsByName("chbox")[i].checked = true;
                document.getElementById("all").value = "反选";
            }
        } else {
            for (i = 0; i < len; i++) {
                document.getElementsByName("chbox")[i].checked = false;
                document.getElementById("all").value = "全选";
            }
        }
    }
    function checkPass() {

        var len = document.getElementsByName("chbox").length;
        var flag = 0;
        var id = "";
        var channel = "";
        var bank = "";

        for (i = 0; i < len; i++) {
            var cha = "";
            var ba = "";
            if (document.getElementsByName("chbox")[i].checked) {
                cha = document.getElementsByName("chann")[i].value
                ba = document.getElementsByName("bank")[i].value
                if (channel != cha && channel != "" && channel != null) {
                    alert("您选择的数据不是同一支付类型,请重新选择！");
                    return false;
                }
                channel = cha;
                if (bank != ba && bank != "" && bank != null) {
                    alert("您选择的数据不是同一支付银行,请重新选择！");
                    return false;
                }
                bank = ba;
                id = id + document.getElementsByName("id")[i].value + ",";
                flag = 1
            }
        }
        if (flag == 0) {
            alert("请选择至少一条待处理的退款请求！");
        }
        if (flag == 1) {
            if (confirm("您确认要批量处理退款请求？")) {
                var url = 'editRea.gsp?id=' + id + '&flag=0';
                win1 = new Ext.Window({
                    id:'win1',
                    title:"请选择退款银行",
                    width:600,
                    modal:true,
                    height:300,
                    html: '<iframe src=' + url + ' height="100%" width="100%" name="userlist" scrolling="auto" frameborder="0" onLoad="Ext.MessageBox.hide();">',
                    maximizable:true
                });
                win1.show();
            }
        }
    }
     function singlePcPass() {

        var len = document.getElementsByName("chbox").length;
        var flag = 0;
        var id = "";
        var bank = "";
        for (i = 0; i < len; i++) {
            if (document.getElementsByName("chbox")[i].checked) {
                var ba = document.getElementsByName("bank")[i].value
                if (bank != ba && bank != "" && bank != null) {
                    alert("您选择的数据不是同一支付银行,请重新选择！");
                    return false;
                }
                bank = ba;
                id = id + document.getElementsByName("id")[i].value + ",";
                flag = 1
            }
        }
        if (flag == 0) {
            alert("请选择至少一条待处理的退款请求！");
        }
        if (flag == 1) {
            if (confirm("您确认要单笔处理退款请求？")) {
                var url = 'editRea.gsp?id=' + id + '&flag=2';
                win1 = new Ext.Window({
                    id:'win1',
                    title:"请选择退款银行",
                    width:600,
                    modal:true,
                    height:300,
                    html: '<iframe src=' + url + ' height="100%" width="100%" name="userlist" scrolling="auto" frameborder="0" onLoad="Ext.MessageBox.hide();">',
                    maximizable:true
                });
                win1.show();
            }
        }
    }
    function allPass() {
//        var url = 'unCheckList';
//        var params = {
//            flag:1,
//            tradeNo:$('#tradeNo').val(),
//            startDateCreated:$('#endDateCreated').val(),
//            endDateCreated:$('#endDateCreated').val()
//        };
//        jQuery.post(url, params, callbackFun);


        var startDateCreated = document.getElementById('startDateCreated').value;
        var endDateCreated = document.getElementById('endDateCreated').value;
//        var bankNo = document.getElementById('bankNo').value;
        var tradeNo = document.getElementById('tradeNo').value;
//        var outTradeNo = document.getElementById('outTradeNo').value;
        var payerName = document.getElementById('payerName').value;
        var payerAccountNo = document.getElementById('payerAccountNo').value;
        var bankName = document.getElementById('bankName').value;
        var paymentType = document.getElementById('channel').value;
        var startAmount = document.getElementById('startAmount').value;
        var endAmount = document.getElementById('endAmount').value;

        if (confirm("您确认要批量处理退款请求！")) {
            var url = 'allPass.gsp?startDateCreated=' + startDateCreated + '&endDateCreated=' + endDateCreated + '&payerName' + payerName + '&tradeNo=' + tradeNo + '&payerAccountNo' + payerAccountNo
                    + '&bankName=' + bankName + '&paymentType' + paymentType + '&startAmount=' + startAmount + '&endAmount=' + endAmount + '&flag=0';
            win1 = new Ext.Window({
                id:'win1',
                title:"请选择退款银行",
                width:600,
                modal:true,
                height:300,
                html: '<iframe src=' + url + ' height="100%" width="100%" name="userlist" scrolling="auto" frameborder="0" onLoad="Ext.MessageBox.hide();">',
                maximizable:true
            });
            win1.show();
        }
    }
    function callbackFun(data, textStatus) {
        alert(textStatus + data);
        if (textStatus == "success") {
            var url = 'editRea.gsp?id=' + data
            win1 = new Ext.Window({
                id:'win1',
                title:"请选择退款银行",
                width:600,
                modal:true,
                height:300,
                html: '<iframe src=' + url + ' height="100%" width="100%" name="userlist" scrolling="auto" frameborder="0" onLoad="Ext.MessageBox.hide();">',
                maximizable:true
            });
            win1.show();
        }

    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <g:form name="chPass">
            <div class="table_serch">
                <table>
                    <tr>
                        <td>申请时间：</td><td><g:textField name="startDateCreated" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.startDateCreated}" class="right_top_h2_input"/>--<g:textField name="endDateCreated" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.endDateCreated}" class="right_top_h2_input"/></td>
                        %{--<td>银行订单号：</td><td><g:textField name="bankNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.bankNo}" class="right_top_h2_input"/></td>--}%
                        <td>退款客户名称</td><td><g:textField name="payerName" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerName}" class="right_top_h2_input"/></td>
                        <td>退款客户账户</td><td><g:textField name="payerAccountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerAccountNo}" class="right_top_h2_input"/></td>
                        %{--<td>商户订单号：</td><td><g:textField name="outTradeNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.outTradeNo}" class="right_top_h2_input"/></td>--}%
                        <td>支付银行：</td><td><p><g:select from="${BoBankDic.findAll().name}" value="${params.bankName}" name="bankName" id="bankName" optionKey="value" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"></g:select></p></td>
                    </tr>
                    <tr>
                        <td>交易流水号：</td><td align="left"><g:textField name="tradeNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.tradeNo}" class="right_top_h2_input"/></td>

                        <td>支付方式：</td><td><p><g:select name="channel" value="${params.channel}" from="${TradeRefund.channelMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                        %{--<td>退款客户名称：</td><td><p><g:textField name="payerName" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerName}" class="right_top_h2_input"/></p></td>--}%
                        %{--<td>退款人账户：</td><td><g:textField name="payerAccountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerAccountNo}" class="right_top_h2_input"/></td>--}%
                        <td>退款金额：</td><td><p><g:textField name="startAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${params.startAmount}" class="right_top_h2_input"/>--<g:textField name="endAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endAmount}" style="width:60px;" class="right_top_h2_input"/></p></td>
                        %{--处理状态：<g:select name="handleStatus" value="${params.handleStatus}" from="${TradeRefund.handleStatusMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/>--}%
                        %{--原交易时间 <g:textField name="startDateCreated" style="width:80px" value="${params.startDateCreated}" class="right_top_h2_input"/>--<g:textField name="endDateCreated" style="width:80px" value="${params.endDateCreated}" class="right_top_h2_input"/>--}%
                        %{--银行订单号 <g:textField name="payerAccountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerAccountNo}" class="right_top_h2_input"/>--}%
                        %{--申请人IP<g:textField name="payerAccountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerAccountNo}" class="right_top_h2_input"/>--}%
                        %{--<BR>--}%
                        <td>退款类型：</td><td><p><g:select name="refundBankType" value="${params.refundBankType}" from="${TradeRefund.refundBankTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <g:hiddenField name="flag" value="0"></g:hiddenField>
                        <td>银行订单号：</td><td><g:textField name="bankNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.bankNo}" class="right_top_h2_input"/></td>
                        <td colspan="6" class="left"><g:actionSubmit class="right_top_h2_button_serch" action="unCheckList" value="查询" onclick="return checkDate()"/>
                        <bo:hasPerm perm="${Perm.Trade_RfdWait_Dl}">
                            <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()"/>
                        </bo:hasPerm>
                            <input type="button" class="right_top_h2_button_clear" value="清空" onClick="cl()">
                            <input type="button" class="right_top_h2_button_check" value="全选" id="all" onClick="ckAll()"/>
                            <bo:hasPerm perm="${Perm.Trade_RfdWait_ProcBatPas}">
                                <input type="button" class="right_top_h2_button_check" value="批量通过" onClick="checkPass()"/>
                            </bo:hasPerm>
                            <bo:hasPerm perm="${Perm.Trade_RfdWait_ProcSigPas}">
                                <input type="button" class="right_top_h2_button_check" value="单笔通过" onClick="singlePcPass()"/>
                            </bo:hasPerm>
                        %{--<input type="button" class="right_top_h2_button_clear" value="全部通过" onClick="allPass()"/>--}%
                        </td>
                    </tr>

                </table>
            </div>
        </g:form>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <th>请选择</th>
                <g:sortableColumn params="${params}" property="tradeNo" title="${message(code: 'tradeRefund.tradeNo.label')}"/>
                <g:sortableColumn params="${params}" property="payerName" title="${message(code: 'tradeRefund.payerName.label')}"/>
                <th>银行订单号</th>
                <th>支付银行</th>
                <th>支付方式</th>
                <th>订单金额</th>
                %{--<g:sortableColumn params="${params}" property="payerAccountNo" title="${message(code: 'tradeRefund.payerAccountNo.label')}"/>--}%
                <g:sortableColumn params="${params}" property="amount" title="${message(code: 'tradeRefund.amount.label')}"/>
                <g:sortableColumn params="${params}" property="handleStatus" title="${message(code: 'tradeRefund.handleStatus.label')}"/>

                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'tradeRefund.dateCreated.label')}"/>
                <th>交易时间</th>
                <th>拒绝原因</th>
            </tr>

            <g:each in="${tradeRefundInstanceList}" status="i" var="tradeRefund">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>
                        <g:checkBox name="chbox" id="chbox"></g:checkBox><g:hiddenField name="id" value="${tradeRefund.id}"></g:hiddenField>
                        <g:hiddenField name="chann" id="chann" value="${tradeRefund?.channel}"></g:hiddenField>
                        <g:hiddenField name="bank" id="bank" value="${TradeBase.findByRootIdAndTradeType(tradeRefund.rootId,'charge')?.payerName}"></g:hiddenField>
                    </td>

                    <td><g:if test="${bo.hasPerm(perm:Perm.Trade_RfdWait_ViewLs){true}}"><g:link action="show" id="${tradeRefund.id}">${fieldValue(bean: tradeRefund, field: "tradeNo")}</g:link></g:if><g:else>${fieldValue(bean: tradeRefund, field: "tradeNo")}</g:else></td>
                    <td>${fieldValue(bean: tradeRefund, field: "payerName")}</td>
                    <td><g:if test="${bo.hasPerm(perm:Perm.Trade_RfdWait_ViewBankNo){true}}"><g:link action="show" controller="gwTransaction" id="${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.id}">${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.bankTransNo}</g:link></g:if><g:else>${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.bankTransNo}</g:else></td>
                %{--<td>${fieldValue(bean: tradeRefund, field: "payerAccountNo")}</td>--}%
                %{--<g:if test="${TradePayment.get(tradeRefund.originalId)?.amount>0}">--}%
                %{--<td><g:formatNumber number="${TradePayment.get(tradeRefund.originalId)?.amount/100}" type="currency" currencyCode="CNY"/></td>--}%
                %{--</g:if>--}%
                %{--<td>${TradeBase.findByRootIdAndTradeType(tradeRefund.rootId, 'charge')?.payerName}</td>--}%

                    <g:if test="${tradeRefund?.acquirerMerchantNo!=null}">
                        <td>${BoBankDic.get(BoAcquirerAccount.get(BoMerchant.findByAcquireMerchant(tradeRefund?.acquirerMerchantNo)?.acquirerAccount?.id)?.bank?.id)?.name}</td>
                    </g:if>
                    <g:else><td></td></g:else>
                    <td>${TradeRefund.channelMap[tradeRefund?.channel]}</td>
                    <g:if test="${tradeRefund.partnerId==null}">
                        <g:if test="${TradeBase.findByRootIdAndTradeType(tradeRefund.rootId,'charge')?.amount>0}">
                            <td><g:formatNumber number="${TradeBase.findByRootIdAndTradeType(tradeRefund.rootId,'charge')?.amount/100}" type="currency" currencyCode="CNY"/></td>
                        </g:if>
                    </g:if>
                    <g:elseif test="${tradeRefund.partnerId!=null}">
                        <g:if test="${TradePayment.get(tradeRefund.originalId)?.amount>0}">
                            <td><g:formatNumber number="${TradePayment.get(tradeRefund.originalId)?.amount/100}" type="currency" currencyCode="CNY"/></td>
                        </g:if>
                    </g:elseif>
                    <g:else>
                        <td></td>
                    </g:else>
                    <td><g:formatNumber number="${tradeRefund?.amount/100}" type="currency" currencyCode="CNY"/></td>
                    <td>${TradeRefund.handleStatusMap[tradeRefund?.handleStatus]}</td>

                    <td><g:formatDate date="${tradeRefund?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <g:if test="${tradeRefund.partnerId==null}">
                        <td>
                            <g:formatDate date="${TradeBase.findByRootIdAndTradeType(tradeRefund.rootId,'charge')?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                    </g:if>
                    <g:elseif test="${tradeRefund.partnerId!=null}">
                        <td>
                            <g:formatDate date="${TradePayment.findByRootIdAndTradeType(tradeRefund.rootId,'payment')?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                    </g:elseif>
                    <g:else>
                        <td></td>
                    </g:else>

                    <td>${AppNote.findByAppIdAndAppName(tradeRefund.id, 'tradeRefund_first')?.appNote}</td>
                </tr>
            </g:each>
        </table>
        合计：订单金额总计：${totalAmount ? totalAmount / 100 : 0}元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;退款金额总计：${refundAmount ? refundAmount / 100 : 0}元
        <div class="paginateButtons">
            <span style=" float:left;">共${tradeRefundInstanceTotal}条记录</span>
            <g:paginat total="${tradeRefundInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
