<%@ page import="settle.FtTradeFee" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8;pageEncoding=GBK"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftTradeFeeupdateList.label', default: 'FtTradeFee')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">

    function Is2smallNum(value, limitcount) {
        var s = new String(value);
        var array = s.split(".");
        if (array[1] == null)
            count = -1;
        else {
            var str = new String(array[1]);
            count = str.length;
        }
        if (count > limitcount) {
            return false;
        }
        return true;
    }

    //去左空格
    function ltrim(s) {
        return s.replace(/^\s*/, "");
    }
    //去右空格;
    function rtrim(s) {
        return s.replace(/\s*$/, "");
    }
    //去左右空格;
    function trim(s) {
        return rtrim(ltrim(s));
    }
    function edit_submit() {
        var feevalue = document.getElementById("feevalue").value;
        var feetype = document.getElementById("feetype").value;
        feevalue = trim(feevalue);

        if (document.getElementById("chose") != null && document.getElementById("chose").checked) {
            document.getElementById("chosevalue").value = 0;
            if (feevalue == null || feevalue == "") {
                alert("费率不能为空");
                return;
            }
            //按笔收

            if (feetype == 0) {
                var reg = /^-?[1-9]+(\.\d+)?$|^-?0(\.\d+)?$|^-?[1-9]+[0-9]*(\.\d+)?$/; //正整数
                if (!reg.test(feevalue)) {
                    alert("按笔收只能输入数字");
                    return;
                }


            }
            //按比率收
            if (feetype == 1) {
                var reg = /^-?[1-9]+(\.\d+)?$|^-?0(\.\d+)?$|^-?[1-9]+[0-9]*(\.\d+)?$/;
                if (!(reg.test(feevalue) && feevalue >= 0 && feevalue <= 100 )) {

                    alert("按比率只能输入0-100之间的数字");
                    return;
                }

            }
        }
        else {
            document.getElementById("feevalue").value = 0;
            document.getElementById("chosevalue").value = 1;
        }

        if (!Is2smallNum(feevalue, 2)) {
            alert("小数不能超过2位");
            return;
        }
        document.forms[0].submit();
    }

    function check_box_change() {
        var chose = document.getElementById("chose").checked;

        if (chose == false) {
            document.getElementById("feevalue").disabled = true;
            document.getElementById("feetype").disabled = true;
            document.getElementById("tradeWeight").disabled = true;
            document.getElementById("trade").disabled = true;
            document.getElementById("fetchtype").disabled = true;
        }
        else {
            document.getElementById("feevalue").disabled = false;
            document.getElementById("feetype").disabled = false;
            document.getElementById("tradeWeight").disabled = false;
            document.getElementById("trade").disabled = false;
            document.getElementById("fetchtype").disabled = false;
        }
    }
</script>
<g:form action="save">
    <div class="main">
        <g:if test="${flash.message}">
            <div class="message">${flash.message.encodeAsHTML()}</div>
        </g:if>
        <div class="right_top">
            <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
            <h2>
                商户编码：${customerNo}
                商户名称：${customerName}
                <g:hiddenField name="customerNo" value="${customerNo}"/>
                <g:hiddenField name="customerName" value="${customerName}"/>
            </h2>
            <% if (sucess == "true") {%>
            <div>
                <table align="center" class="right_list_table" id="test">
                    <tr>
                        <th>选择</th>
                        <th>业务类型</th>
                        <th>交易类型</th>
                        <th>结算方式</th>
                        <th>收取方向</th>
                        <th>费率模式</th>
                        <th>手续费</th>
                        <th>费率</th>
                    </tr>
                    <g:each in="${ftTradeFeeList}" status="i" var="item">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td>
                            <% if (chosevalue == "1") { %>
                            <input type="checkbox" name="chose" id="chose" disabled="true" />
                            <% } else { %>
                            <input type="checkbox" name="chose" id="chose" checked disabled="true" />
                            <% } %>
                            <input type="hidden" name="chosevalue" id="chosevalue" />
                        </td>
                        <td>${item.SRV_NAME}<input type="hidden" name="srvcode" value="${item.SRVID}"/></td>
                        <td>${item.TRADE_NAME}<input type="hidden" name="tradeid" value="${item.TRADEID}"/></td>
                        <td><g:select name="fetchtype" disabled="true" value="${fetchtype}" from="${FtTradeFee.fetchtypeMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/></td>
                        <td><g:select name="tradeWeight" disabled="true" value="${item.TRADE_WEIGHT?.intValue()}" from="${FtTradeFee.tradeWeightMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/></td>
                        <td><g:select name="trade" disabled="true" value="0" from="${FtTradeFee.settleMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/></td>
                        <td><g:select name="feetype" disabled="true" value="${feetype}" from="${FtTradeFee.feetypeMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/></td>
                        <td><g:textField name="feevalue" disabled="true" maxlength="10" value="${item.FEE_VALUE}" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>
                            <input type="hidden" name="feeid" disabled="true" maxlength="10" value="${item.FEEID}"/>
                        </td>
                        </tr>
                    </g:each>
                </table>
                <br>
                <div align="center">
                    <input type="button" onclick="edit_submit()" name="button" id="button" disabled="true" class="rigt_button" value="修改">
                    <input type="button" class="rigt_button" onclick="window.location.href = '${createLink(controller:'ftTradeFee', action:'list', params:['customerNo':customerNo,'customerName':customerName])}'" value="返回"/>
                </div>
            </div>
            <%} else { %>
            <div>
                <table align="center" class="right_list_table" id="test">
                    <tr>
                        <th>选择</th>
                        <th>业务类型</th>
                        <th>交易类型</th>
                        <th>结算方式</th>
                        <th>收取方向</th>
                        <th>费率模式</th>
                        <th>手续费</th>
                        <th>费率</th>
                    </tr>
                    <g:each in="${ftTradeFeeList}" status="i" var="item">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td><input type="checkbox" name="chose" id="chose" checked onclick="check_box_change()">
                            <input type="hidden" name="chosevalue" id="chosevalue">
                        </td>
                        <td>${item.SRV_NAME}<input type="hidden" name="srvcode" value="${item.SRVID}"/></td>
                        <td>${item.TRADE_NAME}<input type="hidden" name="tradeid" value="${item.TRADEID}"/></td>
                        <td><g:select name="fetchtype" value="${fetchtype}" from="${FtTradeFee.fetchtypeMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/></td>
                        <td><g:select name="tradeWeight" value="${item.TRADE_WEIGHT?.intValue()}" from="${FtTradeFee.tradeWeightMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/></td>
                        <td><g:select name="trade" value="0" from="${FtTradeFee.settleMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/></td>
                        <td><g:select name="feetype" value="${feetype}" from="${FtTradeFee.feetypeMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/></td>
                        <td><g:textField name="feevalue" maxlength="10" value="${item.FEE_VALUE}" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>
                            <input type="hidden" name="feeid" maxlength="10" value="${item.FEEID}"/>
                        </td>
                    </g:each>
                </table>
                <br>
                <div align="center">
                    <input type="button" onclick="edit_submit()" name="button" id="button" class="rigt_button" value="修改">
                    <input type="button" class="rigt_button" onclick="window.location.href = '${createLink(controller:'ftTradeFee', action:'list', params:['customerNo':customerNo,'customerName':customerName])}'" value="返回"/>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</g:form>
</body>
</html>