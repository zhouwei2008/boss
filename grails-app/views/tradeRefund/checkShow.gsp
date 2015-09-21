<%@ page import="boss.BoMerchant; boss.BoBankDic; boss.BoAcquirerAccount; boss.Perm; gateway.GwTransaction; ismp.TradeCharge; ismp.TradePayment; ismp.TradeBase; ismp.TradeRefund" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeRefund.checkListBatch.label', default: 'TradeRefund')}"/>
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
        for (i = 0; i < len; i++) {
            document.getElementsByName("chbox")[i].checked = true;
        }
    }
    function checkPass() {
        var len = document.getElementsByName("chbox").length;
        var flag = 0;
        var id = "";
        for (i = 0; i < len; i++) {
            if (document.getElementsByName("chbox")[i].checked) {
                if (i == len - 1) {
                    id = id + document.getElementsByName("id")[i].value
                } else {
                    id = id + document.getElementsByName("id")[i].value + ",";
                }
                flag = 1
            }
        }
        if (flag == 0) {
            alert("请选择至少一条待处理的退款请求！");
        }
        if (flag == 1) {
            if (confirm("您确认要批量处理退款请求？")) {
                var url = 'editRea.gsp?id=' + id + '&flag=1';
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
        var startDateCreated = document.getElementById('startDateCreated').value;
        var endDateCreated = document.getElementById('endDateCreated').value;
        var bankNo = document.getElementById('bankNo').value;
        var tradeNo = document.getElementById('tradeNo').value;
        var outTradeNo = document.getElementById('outTradeNo').value;
        var bankName = document.getElementById('bankName').value;
        var paymentType = document.getElementById('channel').value;
        var startAmount = document.getElementById('startAmount').value;
        var endAmount = document.getElementById('endAmount').value;
        if (confirm("您确认要批量处理退款请求？")) {
            var url = 'allPass.gsp?startDateCreated=' + startDateCreated + '&endDateCreated=' + endDateCreated + '&bankNo' + bankNo + '&tradeNo=' + tradeNo + '&outTradeNo' + outTradeNo
                    + '&bankName=' + bankName + '&paymentType' + paymentType + '&startAmount=' + startAmount + '&endAmount=' + endAmount + '&flag=1';
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
        <table align="center" class="right_list_table" id="test">

            <tr>
                %{--<th>请选择</th>--}%
                <g:sortableColumn params="${params}" property="refundBatchNo" title="${message(code: 'tradeRefund.refundBatchNo.label')}"/>
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
                <th>原交易时间</th>
                <g:if test="${sign=='0'}">
                    <g:sortableColumn params="${params}" property="firstAppDate" title="${message(code: 'tradeRefund.firstAppDate.label')}"/>
                    <g:sortableColumn params="${params}" property="firstAppName" title="${message(code: 'tradeRefund.firstAppName.label')}"/>
                </g:if>
                <g:elseif test="${sign=='1'}">
                    <g:sortableColumn params="${params}" property="lastAppDate" title="${message(code: 'tradeRefund.lastAppDate.label')}"/>
                    <g:sortableColumn params="${params}" property="lastAppName" title="${message(code: 'tradeRefund.lastAppName.label')}"/>
                </g:elseif>
                <g:elseif test="${sign=='2'}">
                    <g:sortableColumn params="${params}" property="refundHandleDate" title="${message(code: 'tradeRefund.refundHandleDate.label')}"/>
                    <g:sortableColumn params="${params}" property="refundHandleName" title="${message(code: 'tradeRefund.refundHandleName.label')}"/>
                </g:elseif>
                %{--<th>拒绝原因</th>--}%
            </tr>

            <g:each in="${tradeRefundInstanceList}" status="i" var="tradeRefund">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td><g:if test="${bo.hasPerm(perm:Perm.Trade_RfdBthRef_BatchNo){true} || bo.hasPerm(perm:Perm.Trade_RfdBthReChk_BatchNo){true} || bo.hasPerm(perm:Perm.Trade_RfdHis_BatchNo){true} }"><g:link action="checkBatchShow" id="${tradeRefund.refundBatchNo}">${fieldValue(bean: tradeRefund, field: "refundBatchNo")}</g:link></g:if><g:else>${fieldValue(bean: tradeRefund, field: "refundBatchNo")}</g:else></td>
                    <td><g:if test="${bo.hasPerm(perm:Perm.Trade_RfdBthRef_TradeNo){true} || bo.hasPerm(perm:Perm.Trade_RfdBthReChk_TradeNo){true} || bo.hasPerm(perm:Perm.Trade_RfdHis_TradeNo){true}}"><g:link action="unRefuseShow" id="${tradeRefund.id}">${fieldValue(bean: tradeRefund, field: "tradeNo")}</g:link></g:if><g:else>${fieldValue(bean: tradeRefund, field: "tradeNo")}</g:else></td>
                    <td>${fieldValue(bean: tradeRefund, field: "payerName")}</td>
                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.Trade_RfdBthRef_BankNo){true} || bo.hasPerm(perm:Perm.Trade_RfdBthReChk_BankNo){true} || bo.hasPerm(perm:Perm.Trade_RfdHis_BankNo){true}}">
                            <g:link action="show" controller="gwTransaction" id="${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.id}">${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.bankTransNo}</g:link>
                        </g:if>
                        <g:else>
                            ${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.bankTransNo}
                        </g:else>
                    </td>
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
                %{--<td>${AppNote.findByAppIdAndAppName(tradeRefund.id, 'tradeRefund')?.appNote}</td>--}%
                    <g:if test="${sign=='0'}">
                        <td><g:formatDate date="${tradeRefund?.firstAppDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>${tradeRefund?.firstAppName}</td>
                    </g:if>
                    <g:elseif test="${sign=='1'}">
                        <td><g:formatDate date="${tradeRefund?.lastAppDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>${tradeRefund?.lastAppName}</td>
                    </g:elseif>
                    <g:elseif test="${sign=='2'}">
                        <td><g:formatDate date="${tradeRefund?.refundHandleDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>${tradeRefund?.refundHandleName}</td>
                    </g:elseif>

                </tr>
            </g:each>
            <tr>
                <td colspan="13" align="center">
                    <g:form>
                        <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    %{--<bo:hasPerm perm="${Perm.Trade_RfdChk_Proc}">--}%
                    %{--<span class="button"><g:actionSubmit class="rigt_button" action="check" value="通过"/></span>--}%
                    %{--<span class="button"><g:actionSubmit class="rigt_button" action="endRefused" value="拒绝"/></span>--}%
                    %{--<span class="button"><input type="button" class="rigt_button" onclick="return appPass()" value="拒绝"/></span>--}%
                    %{--</bo:hasPerm>--}%
                    </g:form>
                </td>
            </tr>
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
