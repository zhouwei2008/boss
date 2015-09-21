<%@ page import="boss.BoMerchant; boss.BoBankDic; boss.BoAcquirerAccount; boss.Perm; gateway.GwTransaction; ismp.TradeCharge; ismp.TradePayment; ismp.TradeBase; ismp.TradeRefund" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeRefund.completeList.label', default: 'TradeRefund')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#startDateCheck").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endDateCheck").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });
    function checkDate() {
        var startDate = document.getElementById("startDateCreated").value;
        var endDate = document.getElementById("endDateCreated").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endDateCreated").focus();
            return false;
        }

        if (!document.getElementById('endDateCheck').value.length == 0) {
            var startDate = document.getElementById('startDateCheck').value;
            var endDate = document.getElementById('endDateCheck').value;
            if (Number(startDate > endDate)) {
                alert("终审开始时间不能大于结束时间！");
                document.getElementById('endDateCheck').focus();
                return false;
            }
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
    function statusChange() {
        var status = document.getElementById("handleStatus").value;
        if (status == null || status == "" || status == 'fChecked') {
            document.getElementById("startDateCheck").value = "";
            document.getElementById("endDateCheck").value = "";
        }
    }
    function cl() {
        var form = document.forms[0];
        for (var i = 0; i < form.elements.length; i++) {
            if (form.elements[i].type == "text" || form.elements[i].type == "text")
                form.elements[i].value = "";
        }

        document.getElementById("channel").value = "";
        document.getElementById("handleStatus").value = "";
        document.getElementById("startDateCreated").focus();
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">退款历史明细列表</h1>
        <g:form>
            <div class="table_serch">
                <table>
                    <tr>
                        <td>批次号：</td><td><p><g:textField name="refundBatchNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.refundBatchNo}" class="right_top_h2_input"/></p></td>
                        <td>交易流水号：</td><td><p><g:textField name="tradeNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.tradeNo}" class="right_top_h2_input"/></p></td>
                        <td>退款客户名称：</td><td><p><g:textField name="payerName" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerName}" class="right_top_h2_input"/></p></td>
                        <td>退款客户账户：</td><td><p><g:textField name="payerAccountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerAccountNo}" class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td>退款金额：</td><td><p><g:textField name="startAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${params.startAmount}" class="right_top_h2_input"/>--
                        <g:textField name="endAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endAmount}" style="width:60px;" class="right_top_h2_input"/></p></td>
                        <td>退款银行：</td><td><p><g:select name="bankName" value="${params.bankName}" from="${BoBankDic.list()}" optionKey="id" optionValue="name" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                        <td>支付方式：</td><td><p><g:select name="channel" value="${params.channel}" from="${TradeRefund.channelMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                        <td>退款状态：</td><td><p><g:select name="handleStatus" value="${params.handleStatus}" from="${[[key:'success',value:'成功状态'],[key:'fail',value:'失败状态'],[key:'fRefuse',value:'初审拒绝'],[key:'fChecked',value:'初审通过'],[key:'sRefuse',value:'终审拒绝'],[key:'checked',value: '处理中'],[key:'completed',value:'退款成功'],[key:'refFail',value:'退款失败']]}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input" onchange="statusChange()"/></p></td>

                    </tr>
                    <tr>
                        <td>银行订单号：</td><td><g:textField name="bankNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.bankNo}" class="right_top_h2_input"/></td>
                        <td>申请时间：</td><td><g:textField name="startDateCreated" value="${params.startDateCreated}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--
                        <g:textField name="endDateCreated" value="${params.endDateCreated}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/></td>
                        <td>终审时间：</td><td><g:textField name="startDateCheck" value="${params.startDateCheck}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--
                        <g:textField name="endDateCheck" value="${params.endDateCheck}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/></td>
                        <g:hiddenField name="flag" value="2"></g:hiddenField>
                    </tr>
                    <tr>
                        <td colspan="2"><g:actionSubmit class="right_top_h2_button_serch" action="historyList" value="查询" onclick="return checkDate()"/>
                            <input type="button" class="right_top_h2_button_clear" value="清空" onClick="cl()">
                            <bo:hasPerm perm="${Perm.Trade_RfdHis_Dl}"><g:actionSubmit class="right_top_h2_button_download" action="historyDownload" value="下载" onclick="return checkDate()"/></bo:hasPerm></td>
                    </tr>
                </table>
            </div>
        </g:form>
        <table align="center" class="right_list_table" id="test">

            <tr>
                <th>批次号</th>
                <th>${message(code: 'tradeRefund.tradeNo.label')}</th>
                <th>${message(code: 'tradeRefund.payerName.label')}</th>
                <th>${message(code: 'tradeRefund.payerAccountNo.label')}</th>
                <th>原银行订单号</th>
                <th>原订单金额</th>
                <th>原订单支付时间</th>
                <th>${message(code: 'tradeRefund.amount.label')}</th>
                <th>支付方式</th>
                <th>付款银行</th>
                <th>退款银行</th>
                <th>申请时间</th>
                <th>终审时间</th>
                <th>退款状态</th>
            </tr>

            <g:each in="${tradeRefundInstanceList}" status="i" var="tradeRefund">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td><g:if test="${bo.hasPerm(perm:Perm.Trade_RfdHis_ViewBatNo){true}}"><g:link action="checkShow" id="${tradeRefund.refundBatchNo}">${fieldValue(bean: tradeRefund, field: "refundBatchNo")}</g:link></g:if><g:else>${fieldValue(bean: tradeRefund, field: "refundBatchNo")}</g:else></td>
                    <td><g:if test="${bo.hasPerm(perm:Perm.Trade_RfdHis_ViewLs){true}}"><g:link action="historyShow" id="${tradeRefund.id}">${fieldValue(bean: tradeRefund, field: "tradeNo")}</g:link></g:if><g:else>${fieldValue(bean: tradeRefund, field: "tradeNo")}</g:else></td>
                    <td>${fieldValue(bean: tradeRefund, field: "payerName")}</td>
                    <td>${fieldValue(bean: tradeRefund, field: "payerAccountNo")}</td>
                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.Trade_RfdHis_ViewBankNo){true}}">
                            <g:link action="show" controller="gwTransaction" id="${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.id}">${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.bankTransNo}</g:link>
                        </g:if>
                        <g:else>
                            ${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.bankTransNo}
                        </g:else>
                    </td>
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
                    %{--增加原订单支付时间 as sunweiguo 2012-08-10--}%
                    <td><g:formatDate date="${TradeBase.findByRootIdAndTradeTypeInList(tradeRefund.rootId,['payment','charge'])?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>


                    <td><g:formatNumber number="${tradeRefund?.amount/100}" type="currency" currencyCode="CNY"/></td>
                    <td>${TradeRefund.channelMap[tradeRefund?.channel]}</td>
                    <g:if test="${tradeRefund.acquirerMerchantNo!=null && tradeRefund.acquirerMerchantNo!=''}">
                        <td>${BoBankDic.get(BoAcquirerAccount.get(BoMerchant.findByAcquireMerchant(tradeRefund.acquirerMerchantNo)?.acquirerAccount?.id)?.bank?.id)?.name}</td>
                    </g:if>
                    <g:else>
                        <td></td>
                    </g:else>
                    <td>${BoBankDic.get(BoAcquirerAccount.get(tradeRefund.acquirer_account_id)?.bank?.id)?.name}</td>
                    <td><g:formatDate date="${tradeRefund?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td><g:formatDate date="${tradeRefund?.lastAppDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${TradeRefund.handleStatusMap[tradeRefund?.handleStatus]}</td>
                </tr>
            </g:each>
        </table>
        合计：原订单金额总计：${totalAmount ? totalAmount / 100 : 0}元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;退款金额总计：${refundAmount ? refundAmount / 100 : 0}元
        <div class="paginateButtons">
            <span style=" float:left;">共${tradeRefundInstanceTotal}条记录</span>
            <g:paginat total="${tradeRefundInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
