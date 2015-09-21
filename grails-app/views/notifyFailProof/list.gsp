<%@ page import="gateway.GwTransaction; gateway.GwOrder; ismp.CmCustomerOperator; ismp.CmCustomer; boss.BoAdjustType; boss.Perm; boss.BoAccountAdjustInfo" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="订单掉单处理"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#orderCreateTimeStart").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#orderCreateTimeEnd").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#payCompleteTimeStart").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#payCompleteTimeEnd").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });

    function checkCreateDate() {
        var orderCreateTimeStart = document.getElementById('orderCreateTimeStart').value.replace(/-/g, "//");
        var orderCreateTimeEnd = document.getElementById('orderCreateTimeEnd').value.replace(/-/g, "//");
        if (orderCreateTimeEnd.length != 0) {
            if (Number(orderCreateTimeStart > orderCreateTimeEnd)) {
                alert('订单创建开始时间不能大于订单创建结束时间!');
                document.getElementById('orderCreateTimeStart').focus();
                return false;
            }
        }
        return true;
    }

    function checkCompletedDate() {
        var payCompleteTimeStart = document.getElementById('payCompleteTimeStart').value.replace(/-/g, "//");
        var payCompleteTimeEnd = document.getElementById('payCompleteTimeEnd').value.replace(/-/g, "//");
        if (payCompleteTimeEnd.length != 0) {
            if (Number(payCompleteTimeStart > payCompleteTimeEnd)) {
                alert('支付完成开始时间不能大于支付完成结束时间!');
                document.getElementById('payCompleteTimeStart').focus();
                return false;
            }
        }
        return true;
    }

    function validateAmount(amt) {
        if (isNaN(amt)) {
            return "金额必须为数字！";
        } else if (amt < 0) {
            return "金额必须为正值！";
        } else {
            var amtArr = amt.split(".");
            if (amtArr[0].length > 17) {
                return "金额超过最大允许值！";
            } else if (amtArr.length == 2 && amtArr[1].length > 2) {
                return "金额需保留小数点后两位";
            }
            return null;
        }
    }

    function checkAmountScope() {
        var orderAmountMin = document.getElementById('orderAmountMin').value.replace(/-/g, "//");
        var orderAmountMax = document.getElementById('orderAmountMax').value.replace(/-/g, "//");

        var minInfo = validateAmount(orderAmountMin)
        if (orderAmountMin && minInfo) {
            alert(minInfo);
            return false;
        }

        var maxInfo = validateAmount(orderAmountMax)
        if (orderAmountMax && maxInfo) {
            alert(maxInfo);
            return false;
        }

        if (orderAmountMax.length != 0) {
            if (Number(orderAmountMin > orderAmountMax)) {
                alert('订单金额开始值不能大于订单金额结束值!');
                document.getElementById('orderAmountMin').focus();
                return false;
            }
        }
        return true;
    }

    function empty_input() {
        document.getElementById('orderCreateTimeStart').value = '';
        document.getElementById('orderCreateTimeEnd').value = '';
        document.getElementById('payCompleteTimeStart').value = '';
        document.getElementById('payCompleteTimeEnd').value = '';
        document.getElementById('orderAmountMin').value = '';
        document.getElementById('orderAmountMax').value = '';

        document.getElementById('outTradeNo').value = '';
        document.getElementById('tradeNo').value = '';
        document.getElementById('bankTransNo').value = '';

        document.getElementById('sellerCustomerNo').value = '';
        document.getElementById('sellerName').value = '';
        document.getElementById('sellerAdminMail').value = '';

        document.getElementById('orderCreateTimeStart').focus();
    }

    function checkSubmit() {
        if (checkCreateDate() && checkCompletedDate() && checkAmountScope()) {
            return true;
        } else {
            return false;
        }
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <div class="table_serch">
            <table>
                <tr>
                    <td colspan="6" style="text-align:left">
                        <bo:hasPerm perm="${Perm.InterruptOrder_Manage_setting}">
                            <input type="button" value="通知名单设置" onclick="window.location = '${createLink(controller:"notifyFailWatcher",action:"list")}'"/>
                        </bo:hasPerm>
                    </td>
                </tr>
                <g:form action="list">
                    <tr>
                        <td>订单创建时间：</td>
                        <td><g:textField name="orderCreateTimeStart" value="${params.orderCreateTimeStart}" size="10" onchange="checkCreateDate()" class="right_top_h2_input" style="width:80px"/>--<g:textField name="orderCreateTimeEnd" value="${params.orderCreateTimeEnd}" size="10" onchange="checkCreateDate()" class="right_top_h2_input" style="width:80px"/></td>
                        <td>支付完成时间：</td>
                        <td><g:textField name="payCompleteTimeStart" value="${params.payCompleteTimeStart}" size="10" onchange="checkCompletedDate()" class="right_top_h2_input" style="width:80px"/>--<g:textField name="payCompleteTimeEnd" value="${params.payCompleteTimeEnd}" size="10" onchange="checkCompletedDate()" class="right_top_h2_input" style="width:80px"/></td>
                        <td>订单金额（元）：</td>
                        <td><g:textField name="orderAmountMin" value="${params.orderAmountMin}" size="10" onchange="checkAmountScope()" class="right_top_h2_input" style="width:80px"/>--<g:textField name="orderAmountMax" value="${params.orderAmountMax}" size="10" onchange="checkAmountScope()" class="right_top_h2_input" style="width:80px"/></td>
                    </tr>
                    <tr>
                        <td>商户订单号：</td>
                        <td><g:textField name="outTradeNo" value="${params.outTradeNo}" class="right_top_h2_input" style="width:120px"/></td>
                        <td>交易流水号：</td>
                        <td><g:textField name="tradeNo" value="${params.tradeNo}" class="right_top_h2_input" style="width:120px"/></td>
                        <td>银行订单号：</td>
                        <td><g:textField name="bankTransNo" value="${params.bankTransNo}" class="right_top_h2_input" style="width:120px"/></td>
                    </tr>
                    <tr>
                        <td>卖家客户号：</td>
                        <td><g:textField name="sellerCustomerNo" value="${params.sellerCustomerNo}" class="right_top_h2_input" style="width:120px"/></td>
                        <td>卖家客户名称：</td>
                        <td><g:textField name="sellerName" value="${params.sellerName}" class="right_top_h2_input" style="width:120px"/></td>
                        <td>卖家管理员邮箱：</td>
                        <td><g:textField name="sellerAdminMail" value="${params.sellerAdminMail}" class="right_top_h2_input" style="width:120px"/></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkSubmit();"/>
                        </td>
                        <td colspan="2">
                            <input type="button" class="right_top_h2_button_serch" value="清空" onclick="return empty_input();"/>
                        </td>
                        <td colspan="2">
                            <bo:hasPerm perm="${Perm.InterruptOrder_Manage_Dl}">
                                <g:actionSubmit class="right_top_h2_button_download" action="downloadList" value="下载" onclick="return checkSubmit();"/>
                            </bo:hasPerm>
                        </td>
                    </tr>
                </g:form>
            </table>
        </div>
        <table class="right_list_table" width="100%">
            <tr>
                <th>商户订单号</th>

                <th>交易流水号</th>

                <th>订单创建时间</th>

                <th>银行订单号</th>

                <th>订单金额（元）</th>

                <th>支付完成时间</th>

                <th>卖家客户号</th>

                <th>卖家客户名称</th>

                <th>联系人</th>

                <th>联系电话</th>

                <th>管理员邮箱</th>

            </tr>

            <g:each in="${list}" status="i" var="item">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td width="10%">
                        <g:if test="${bo.hasPerm(perm:Perm.InterruptOrder_Manage_ViewOutTradeNo){true}}">
                            <g:link action="show" controller="gwOrder" id="${GwOrder.findByOutTradeNo(item.OUTTRADENO).id}">${item.OUTTRADENO}</g:link>
                        </g:if>
                        <g:else>
                            ${item.OUTTRADENO}
                        </g:else>

                    </td>

                    <td width="10%">${item.TRADENO}</td>

                    <td width="10%"><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${item.ORDERCREATETIME}"/></td>

                    <td width="10%">${GwTransaction.findByOrder(GwOrder.get(item.ORDERID.toString()))?.bankTransNo}</td>

                    <td width="10%"><g:formatNumber number="${item.ORDERAMOUNT ? item.ORDERAMOUNT/100 : 0}" type="currency" currencyCode="CNY"/></td>

                    <td width="10%"><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${item.PAYCOMPLETETIME}"/></td>

                    <td width="10%">${item.SELLERCUSTOMERNO}</td>

                    <td width="10%">
                        <g:if test="${bo.hasPerm(perm:Perm.InterruptOrder_Manage_ViewUser){true}}">
                            <g:if test="${item.SELLERADMINMAIL!=null && CmCustomer.get(CmCustomerOperator.findByDefaultEmail(item.SELLERADMINMAIL)?.customer?.id)?.type=='C'}">
                                <g:link controller="cmCorporationInfo" action="show" id="${CmCustomerOperator.findByDefaultEmail(item.SELLERADMINMAIL)?.customer?.id},1">${item.SELLERNAME}</g:link>
                            </g:if>
                            <g:elseif test="${item.SELLERADMINMAIL!=null && CmCustomer.get(CmCustomerOperator.findByDefaultEmail(item.SELLERADMINMAIL)?.customer?.id)?.type=='P'}">
                                <g:link controller="cmPersonalInfo" action="show" id="${CmCustomerOperator.findByDefaultEmail(item.SELLERADMINMAIL)?.customer?.id},1">${item.SELLERNAME}</g:link>
                            </g:elseif>
                        </g:if>
                        <g:else>
                            ${item.SELLERNAME}
                        </g:else>
                    </td>

                    <td width="5%">${item.CONTACT}</td>

                    <td width="5%">${item.CONTACTPHONE}</td>

                    <td width="10%">${item.SELLERADMINMAIL}</td>

                </tr>
            </g:each>
        </table>
        <div class="paginateButtons">
            <span style=" float:left;">共${total}条记录</span>
            <g:paginat total="${total}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>