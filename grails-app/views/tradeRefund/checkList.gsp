<%@ page import="boss.AppNote; boss.BoMerchant; boss.BoBankDic; boss.BoAcquirerAccount; boss.Perm; gateway.GwTransaction; ismp.TradeCharge; ismp.TradePayment; ismp.TradeBase; ismp.TradeRefund" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeRefund.checkList.label', default: 'TradeRefund')}"/>
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

        document.getElementById("bankName").value = "";
        document.getElementById("channel").value = "";
//        document.getElementById("serviceType").value = "-1";
//        document.getElementById("paymentType").value = "-1";
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
        for (i = 0; i < len; i++) {
            if (document.getElementsByName("chbox")[i].checked) {
                id = id + document.getElementsByName("id")[i].value + ",";
                flag = 1
            }
        }
        if (flag == 0) {
            alert("请选择至少一条退款记录！");
        }
        if (flag == 1) {
            if (confirm("您确认要审批通过？")) {
                window.location.href = '${createLink(controller:'tradeRefund', action:'checkPass', params:['statusFlag':'1'])}&id=' + id;
            }
        }
    }
    function checkRefused(id) {
        var flag = 0;
        if (confirm("您确认要拒绝该退款处理？")) {
            var url = 'reasonInp.gsp?id=' + id + '&flag=' + flag;
            win1 = new Ext.Window({
                id:'win1',
                title:"请输入拒绝原因",
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
        <g:form>
            <div class="table_serch">
                <table>
                    <tr>
                        <td>申请时间：</td><td><g:textField name="startDateCreated" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.startDateCreated}" class="right_top_h2_input"/>--<g:textField name="endDateCreated" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.endDateCreated}" class="right_top_h2_input"/></td>
                        <td>银行订单号：</td><td><g:textField name="bankNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.bankNo}" class="right_top_h2_input"/></td>
                        <td>交易流水号：</td><td><g:textField name="tradeNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.tradeNo}" class="right_top_h2_input"/></td>
                        <td>批次号：</td><td><g:textField name="refundBatchNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.refundBatchNo}" class="right_top_h2_input"/></td>
                    </tr>
                    <tr>
                        <td>退款银行：</td><td><p><g:select from="${BoBankDic.findAll().name}" value="${params.bankName}" name="bankName" id="bankName" optionKey="value" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"></g:select></p></td>
                        <td>支付方式：</td><td><p><g:select name="channel" value="${params.channel}" from="${TradeRefund.channelMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                        <td>退款客户名称：</td><td><p><g:textField name="payerName" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerName}" class="right_top_h2_input"/></p></td>
                        <td>退款人账户：</td><td><g:textField name="payerAccountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerAccountNo}" class="right_top_h2_input"/></td>
                    </tr>
                    <tr>
                        <td>退款金额：</td><td><p><g:textField name="startAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${params.startAmount}" class="right_top_h2_input"/>--<g:textField name="endAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endAmount}" style="width:60px;" class="right_top_h2_input"/></p></td>
                        %{--处理状态：<g:select name="handleStatus" value="${params.handleStatus}" from="${TradeRefund.handleStatusMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/>--}%
                        %{--原交易时间 <g:textField name="startDateCreated" style="width:80px" value="${params.startDateCreated}" class="right_top_h2_input"/>--<g:textField name="endDateCreated" style="width:80px" value="${params.endDateCreated}" class="right_top_h2_input"/>--}%
                        %{--银行订单号 <g:textField name="payerAccountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerAccountNo}" class="right_top_h2_input"/>--}%
                        %{--申请人IP<g:textField name="payerAccountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerAccountNo}" class="right_top_h2_input"/>--}%
                        %{--<BR>--}%
                        <g:hiddenField name="flag" value="3"></g:hiddenField>
                        <td colspan="6" class="left"><g:actionSubmit class="right_top_h2_button_serch" action="checkList" value="查询"/>
                            <bo:hasPerm perm="${Perm.Trade_RfdBthRef_Dl}"><g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载"/></bo:hasPerm>
                            <input type="button" class="right_top_h2_button_clear" value="清空" onClick="cl()">
                            <input type="button" class="right_top_h2_button_check" value="全选" id="all" onClick="ckAll()"/>
                            <bo:hasPerm perm="${Perm.Trade_RfdBthRef_ProcPas}"><input type="button" class="right_top_h2_button_check" value="审批通过" onClick="checkPass()"/></bo:hasPerm>
                        </td>
                    </tr>
                </table>
            </div>
        </g:form>
        <table align="center" class="right_list_table" id="test">

            <tr>
                <th>请选择</th>
                <g:sortableColumn params="${params}" property="refundBatchNo" title="${message(code: 'tradeRefund.refundBatchNo.label')}"/>
                <g:sortableColumn params="${params}" property="tradeNo" title="${message(code: 'tradeRefund.tradeNo.label')}"/>
                <g:sortableColumn params="${params}" property="payerName" title="${message(code: 'tradeRefund.payerName.label')}"/>
                <th>银行订单号</th>
                <th>退款银行</th>
                <th>支付方式</th>
                <th>订单金额</th>
                %{--<g:sortableColumn params="${params}" property="payerAccountNo" title="${message(code: 'tradeRefund.payerAccountNo.label')}"/>--}%
                <g:sortableColumn params="${params}" property="amount" title="${message(code: 'tradeRefund.amount.label')}"/>
                <g:sortableColumn params="${params}" property="handleStatus" title="${message(code: 'tradeRefund.handleStatus.label')}"/>

                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'tradeRefund.dateCreated.label')}"/>
                <th>原交易时间</th>
                <th>拒绝原因</th>
                <th>操作</th>
            </tr>

            <g:each in="${tradeRefundInstanceList}" status="i" var="tradeRefund">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td><g:checkBox name="chbox" id="chbox"></g:checkBox><g:hiddenField name="id" value="${tradeRefund.id}"></g:hiddenField></td>
                    <td><g:if test="${bo.hasPerm(perm:Perm.Trade_RfdBthRef_ViewBatNo){true}}"><g:link action="checkShow" id="${tradeRefund.refundBatchNo}" params="['sign':'1']">${fieldValue(bean: tradeRefund, field: "refundBatchNo")}</g:link></g:if><g:else>${fieldValue(bean: tradeRefund, field: "refundBatchNo")}</g:else></td>
                    <td><g:if test="${bo.hasPerm(perm:Perm.Trade_RfdBthRef_ViewLs){true}}"><g:link action="unRefuseShow" id="${tradeRefund.id}" params="['sign':'3']">${fieldValue(bean: tradeRefund, field: "tradeNo")}</g:link></g:if><g:else>${fieldValue(bean: tradeRefund, field: "tradeNo")}</g:else></td>
                    <td>${fieldValue(bean: tradeRefund, field: "payerName")}</td>
                    <td><g:if test="${bo.hasPerm(perm:Perm.Trade_RfdBthRef_ViewBankNo){true}}"><g:link action="show" controller="gwTransaction" id="${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.id}">${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.bankTransNo}</g:link></g:if><g:else>${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.bankTransNo}</g:else></td>
                    %{--<td>${fieldValue(bean: tradeRefund, field: "payerAccountNo")}</td>--}%
                    %{--<g:if test="${TradePayment.get(tradeRefund.originalId)?.amount>0}">--}%
                    %{--<td><g:formatNumber number="${TradePayment.get(tradeRefund.originalId)?.amount/100}" type="currency" currencyCode="CNY"/></td>--}%
                    %{--</g:if>--}%

                    <td>${BoBankDic.get(BoAcquirerAccount.get(tradeRefund?.acquirer_account_id)?.bank?.id)?.name}</td>
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
                    <td>${AppNote.findByAppIdAndAppName(tradeRefund.id, 'tradeRefund_last')?.appNote}</td>
                    <td><g:if test="${bo.hasPerm(perm:Perm.Trade_RfdBthRef_ProcRef){true}}"><input type="button" value="拒绝" onclick="checkRefused('${tradeRefund.id}')"></g:if></td>
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
