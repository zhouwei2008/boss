<%@ page import="settle.FtSrvFootSetting" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8;pageEncoding=GBK"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftsrvfootsettingUpdate.label', default: 'FtTradeFee')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
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
        var foottype = document.getElementById("foottype").value;
        if (foottype == "0") {
            if (document.getElementById("chose").checked) {
                document.getElementById("chosevalue").value = 0;
            } else {
                document.getElementById("chosevalue").value = 1;
            }
            document.getElementById("type").value = 0;
            document.getElementById("withdraw").value = 0;
            //结算日期
            document.getElementById("footexpr").disabled = true;
            //风险预存期
            document.getElementById("mortday").disabled = true;
            //周期内频率
            document.getElementById("foottimes").disabled = true;
            //结算金额
            document.getElementById("footamount").disabled = true;
        } else {
            //结算日期
            document.getElementById("footexpr").disabled = false;
            //风险预存期
            document.getElementById("mortday").disabled = false;
            //周期内频率
            document.getElementById("foottimes").disabled = false;
            //结算金额
            document.getElementById("footamount").disabled = false;

            var footexpr = document.getElementById("footexpr").value;
            footexpr = trim(footexpr);
            if (footexpr == null || footexpr == "") {
                alert("结算日期不能为空");
                return;
            }

            var mortday = document.getElementById("mortday").value;
            mortday = trim(mortday);
            if (mortday == null || mortday == "") {
                alert("风险预存期不能为空");
                return;
            }

            var reg_mort = /^\d+$/; //正整数
            if (!reg_mort.test(mortday)) {

                alert("风险预存期只能为整数");
                return;
            }

            var footamount = document.getElementById("footamount").value;
            footamount = trim(footamount);
            if (footamount == null || footamount == "") {
                alert("结算金额不能为空");
                return;
            }

            var mny = /^([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}\d*(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/;
            if (! mny.test(footamount)) {
                alert("结算金额不是有效的金额数;最多只能输入至小数点后2位");
                return;
            }

            if (document.getElementById("chose").checked) {
                document.getElementById("chosevalue").value = 0;
            } else {
                document.getElementById("chosevalue").value = 1;
            }

            //结算频率等于1;结算日期必须输入数字
            var foottimes = document.getElementById("foottimes").value;
            if (footexpr.slice(-1) == ",") {
                footexpr = footexpr.slice(0, -1);
                document.getElementById("footexpr").value = footexpr;
            }

            if (foottimes == 1) {
                var reg = /^[0-9]*[1-9][0-9]*$/; //正整数
                if (!reg.test(footexpr) && foottype != 4) {
                    alert("结算周期内频率等于1,结算日期只能存在一个，且结算日期必须输入正整数");
                    return;
                }

                if (foottype == 1 && footexpr > 1) {
                    footexpr = 1;
//                         alert("结算周期为日结,结算日期不能大于１");
//                         return;
                }

                if (foottype == 2 && footexpr > 7) {
                    alert("日结结算日期不能大于７");
                    return;
                }

                if (foottype == 3 && footexpr > 31) {
                    alert("月结结算日期不能大于31");
                    return;
                }

                if (! check_0_first(footexpr) && foottype != 4) {
                    alert("结算日期不能以0做起始字符");
                    return false;
                }

                if (foottype == 4) {
                    var year_footexpr_str = "";
                    if (footexpr.slice(-1) == ".") {
                        year_footexpr_str = footexpr.slice(0, -1);

                    } else {
                        year_footexpr_str = footexpr;
                    }
                    var year_footexpr_str_arr = year_footexpr_str.split(".");

                    if (year_footexpr_str_arr.length != 2) {
                        alert("结算周期为年结，周期内频率为1,每个结算日期格式必须为月.日");
                        return;
                    }
                    var mon = year_footexpr_str_arr[0];
                    var day = year_footexpr_str_arr[1];
                    if (! check_0_first(mon)) {
                        alert("月份不能以0做起始字符");
                        return false;
                    }
                    if (! check_0_first(day)) {
                        alert("日期不能以0做起始字符");
                        return false;
                    }
                    var reg1 = /^[0-9]*[1-9][0-9]*$/; //正整数
                    if (!reg1.test(mon)) {
                        alert("结算周期为年结，每个结算日期.前数字必须为正整数");
                        return;
                    }
                    if (mon > 12) {
                        alert("年结月份不能大于12");
                        return;
                    }
                    if (!reg1.test(day)) {
                        alert("结算周期为年结，每个结算日期.后数字必须为正整数");
                        return;
                    }
                    if (mon.length > 2) {
                        alert("月份不能超过2位");
                        return false;
                    }
                    if (day.length > 2) {
                        alert("日期不能超过2位");
                        return false;
                    }
                    if (!check_monandday(mon, day)) {
                        alert("结算日期月份和每月天数不一致");
                        return;
                    }
                }
            }

            if (foottimes > 1) {
                var footexpr_s = footexpr.split(",");
                if (footexpr_s.length != foottimes) {
                    alert("结算周期内频率大于1,结算周期必须用,隔开多个日期,且日期数目必须与结算频率相同 ");
                    return;
                }

                for (var i = 0; i < footexpr_s.length; i++) {
                    var flag = false;
                    for (var j = 0; j < footexpr_s.length; j++) {
                        if (i != j && footexpr_s[i] == footexpr_s[j]) {
                            flag = true;
                            break;
                        }

                        if (i > j && parseInt(footexpr_s[i]) < parseInt(footexpr_s[j]) && foottype != 4) {
                            alert("结算日期必须按从小到大的顺序输入");
                            return;
                        }
                    }

                    if (flag) {
                        alert("结算日期不能重复");
                        return;
                    }


                    var reg1 = /^[0-9]*[1-9][0-9]*$/; //正整数
                    if (!reg1.test(footexpr_s[i]) && foottype != 4) {
                        alert("结算周期为周结,月结或年结时:结算日期必须输入正整数,且不能为空");
                        return;
                    }
                    if (! check_0_first(footexpr_s[i]) && foottype != 4) {
                        alert("结算日期不能以0做起始字符");
                        return false;
                    }
//
                    if (foottype == 4) {
                        var year_sett_str = "";
                        if (footexpr_s[i].slice(-1) == ".") {
                            year_sett_str = footexpr_s[i].slice(0, -1);
                        } else {
                            year_sett_str = footexpr_s[i];
                        }

                        var year_sett_str_arr = year_sett_str.split(".");

                        if (year_sett_str_arr.length != 2) {
                            alert("结算周期为年结，每个结算日期格式必须为月.日");
                            return;
                        }

                        var mon = year_sett_str_arr[0];
                        var day = year_sett_str_arr[1];

                        if (! check_0_first(mon)) {
                            alert("月份不能以0做起始字符");
                            return false;
                        }
                        if (! check_0_first(day)) {
                            alert("日期不能以0做起始字符");
                            return false;
                        }
                        if (mon.length > 2) {
                            alert("月份不能超过2位");
                            return false;
                        }
                        if (day.length > 2) {
                            alert("日期不能超过2位");
                            return false;
                        }
                        if (!reg1.test(mon)) {
                            alert("结算周期为年结，每个结算日期.前数字必须为正整数");
                            return;
                        }
                        if (mon > 12) {
                            alert("结算周期为年结，结算月份不能大于12");
                            return;
                        }
                        if (!reg1.test(day)) {
                            alert("结算周期为年结，每个结算日期.后数字必须为正整数");
                            return;
                        }
                        if (!check_monandday(mon, day)) {
                            alert("结算日期月份和每月天数不一致");
                            return;
                        }
                    }

                    if (foottype == 1 && footexpr_s[i] > 1) {
                        alert("结算周期为日结,结算日期不能大于１");
                        return;
                    }
                    if (foottype == 2 && footexpr_s[i] > 7) {
                        alert("结算周期为周结,结算日期不能大于７");
                        return;
                    }
                    if (foottype == 3 && footexpr_s[i] > 31) {
                        alert("月结结算日期不能大于31");
                        return;
                    }

                    for (var j = 0; j < footexpr_s.length; j++) {
                        var n_mon = footexpr_s[j].split(",")[0].split(".")[0];
                        if (i != j && mon == n_mon) {
                            flag = true;
                            break;
                        }

                        if (i > j && parseInt(mon) < parseInt(n_mon)) {
                            alert("结算月份必须按从小到大的顺序输入");
                            return;
                        }
                    }

                    if (flag) {
                        alert("结算月份不能重复");
                        return;
                    }
                }
            }
        }

        //结算日期
        document.getElementById("footexpr").disabled = false;
        //风险预存期
        document.getElementById("mortday").disabled = false;
        //周期内频率
        document.getElementById("foottimes").disabled = false;
        //结算金额
        document.getElementById("footamount").disabled = false;

        document.getElementById("type").disabled = false;
        document.getElementById("withdraw").disabled = false;

        document.forms[0].submit();
    }

    function check_0_first(value) {
        if (value && value.toString().indexOf('0') == 0)
            return false;
        else
            return true;
    }

    function check_monandday(mon, day) {
        var mon_01 = [1,3,5,7,8,10,12];
        var mon_02 = [2];
        var mon_03 = [4,6,9,11]
        var result = true;
        for (var i = 0; i < mon_01.length; i++) {
            if (mon_01[i] == mon && day > 31) {
                result = false;
                break;
            }
        }
        for (var i = 0; i < mon_02.length; i++) {
            if (mon_02[i] == mon && day > 29) {
                result = false;
                break;
            }
        }
        for (var i = 0; i < mon_03.length; i++) {
            if (mon_03[i] == mon && day > 30) {
                result = false;
                break;
            }
        }
        return result;
    }

    function foottype_select() {
        var foottype = document.getElementById("foottype").value;
        if (foottype == "0") {
            addOption(document.getElementById("foottimes"), "实时结算", 0);

            document.getElementById("foottimes").value = 0;
            //结算日期
            document.getElementById("footexpr").disabled = true;
            //风险预存期
            document.getElementById("mortday").disabled = true;
            //周期内频率
            document.getElementById("foottimes").disabled = true;
            //结算金额
            document.getElementById("footamount").disabled = true;

            document.getElementById("type").disabled = true;
            document.getElementById("type").value = 0;
            document.getElementById("withdraw").disabled = true;
            document.getElementById("withdraw").value = 0;
        } else {
            document.getElementById("type").value = 1;
            //结算日期
            document.getElementById("footexpr").disabled = false;
            //风险预存期
            document.getElementById("mortday").disabled = false;
            //周期内频率

            document.getElementById("foottimes").disabled = false;
            //结算金额
            document.getElementById("footamount").disabled = false;

            document.getElementById("type").disabled = false;
            document.getElementById("withdraw").disabled = false;

            var foottimes = document.getElementById("foottimes");
            foottimes.length = 0;
            //如果是日结算
            if (foottype == '1') {
                for (var i = 1; i <= 1; i++) {
                    addOption(foottimes, i, i);
                }
                document.getElementById("footexpr").value = 1;
                document.getElementById("footexpr").disabled = true;
            }else{
                document.getElementById("footexpr").disabled = false;
            }
            //如果是周结算
            if (foottype == '2') {
                for (var i = 1; i <= 7; i++) {
                    addOption(foottimes, i, i);
                }
            }

            //如果是月结算
            if (foottype == '3') {
                for (var i = 1; i <= 28; i++) {
                    addOption(foottimes, i, i);
                }
            }

            //如果是月结算
            if (foottype == '4') {
                for (var i = 1; i <= 12; i++) {
                    addOption(foottimes, i, i);
                }
            }
        }
    }

    function addOption(sel, text, value) {
        sel.options.add(new Option(text, value));
    }

    function check_box_change() {
        var chose = document.getElementById("chose").checked;

        if (chose == false) {
            //结算日期
            document.getElementById("foottype").disabled = true;
            //结算日期
            document.getElementById("footexpr").disabled = true;
            //风险预存期
            document.getElementById("mortday").disabled = true;
            //周期内频率
            document.getElementById("foottimes").disabled = true;
            //结算金额
            document.getElementById("footamount").disabled = true;
            document.getElementById("type").disabled = true;
            document.getElementById("withdraw").disabled = true;
        } else {
            document.getElementById("foottype").disabled = false;
            //结算日期
            document.getElementById("footexpr").disabled = false;
            //风险预存期
            document.getElementById("mortday").disabled = false;
            //周期内频率
            document.getElementById("foottimes").disabled = false;
            //结算金额
            document.getElementById("footamount").disabled = false;

            document.getElementById("type").disabled = false;
            document.getElementById("withdraw").disabled = false;
            foottype_select();
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
            <% if (sucess == "true") { %>
            <div>
                <table align="center" class="right_list_table" id="test">
                    <tr>
                        <th>选择</th>
                        <th>业务类型</th>
                        <th>交易类型</th>
                        <th>结算周期</th>
                        <th>周期内频率</th>
                        <th>结算日期</th>
                        <th>风险预存期(天)</th>
                        <th>最低结算金额</th>
                        <th>结算单审核</th>
                        <th>提现方式</th>
                    </tr>
                    <g:each in="${ftTradeFeeList}" status="i" var="item">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td><% if (chosevalue == "1") { %>
                                <input type="checkbox" name="chose" id="chose" disabled="true">
                                <% } else { %>
                                <input type="checkbox" name="chose" id="chose" checked disabled="true">
                                <% } %>
                                <input type="hidden" name="chosevalue" id="chosevalue"></td>
                            <td>${item.SRV_NAME}<input type="hidden" name="srvcode" value="${item.SRVID}"/></td>
                            <td>${item.TRADE_NAME}<input type="hidden" name="tradeid" value="${item.TRADEID}"/></td>
                            <td><g:select name="foottype" disabled="true" value="${item.FOOT_TYPE.toString()}" from="${FtSrvFootSetting.tradeTypeMap}" optionKey="key" optionValue="value" class="right_top_h2_input" onchange="foottype_select()"/></td>
                            <% if (foottype == "0" || foottype == null) { %>
                            <td><g:select name="foottimes" disabled="true" value="${item.FOOT_TIMES}" from="${FtSrvFootSetting.tradeTypeMap}" optionKey="key" optionValue="value" class="right_top_h2_input" disabled="true"/></td>
                            <td><g:textField name="footexpr" style="width:80px" disabled="true" maxlength="100" value="${item.FOOT_EXPR}" disabled="true"/></td>
                            <td><g:textField name="mortday" style="width:40px" disabled="true" maxlength="8" value="${item.MORT_DAY}" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" disabled="true"/>天</td>
                            <td><g:textField name="footamount" style="width:40px" disabled="true" maxlength="11" value="${item.FOOT_AMOUNT}" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" disabled="true"/></td>
                            <% } else { %>
                            <td>
                                <% if (item.FOOT_TYPE.toString() == "1") { %>
                                <g:select name="foottimes" disabled="true" value="${item.FOOT_TIMES.intValue()}" from="${FtSrvFootSetting.timesMap_01}" optionKey="key" optionValue="value" class="right_top_h2_input"/>
                                <% } %>
                                <% if (item.FOOT_TYPE.toString() == "2") { %>
                                <g:select name="foottimes" disabled="true" value="${item.FOOT_TIMES.intValue()}" from="${FtSrvFootSetting.timesMap_02}" optionKey="key" optionValue="value" class="right_top_h2_input"/>
                                <% } %>
                                <% if (item.FOOT_TYPE.toString() == "3") { %>
                                <g:select name="foottimes" disabled="true" value="${item.FOOT_TIMES.intValue()}" from="${FtSrvFootSetting.timesMap_03}" optionKey="key" optionValue="value" class="right_top_h2_input"/>
                                <% } %>
                                <% if (item.FOOT_TYPE.toString() == "4") { %>
                                <g:select name="foottimes" disabled="true" value="${item.FOOT_TIMES.intValue()}" from="${FtSrvFootSetting.timesMap_04}" optionKey="key" optionValue="value" class="right_top_h2_input"/>
                                <% } %>
                            </td>
                            <td><g:textField name="footexpr" style="width:80px" disabled="true" maxlength="255" value="${item.FOOT_EXPR}"/></td>
                            <td><g:textField name="mortday" style="width:40px" disabled="true" maxlength="8" value="${item.MORT_DAY}" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>天</td>
                            <td><g:textField name="footamount" style="width:40px" disabled="true" maxlength="11" value="${item.FOOT_AMOUNT}" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/></td>
                            <% } %>
                            <td><g:select name="type" value="${item.TYPE.toString()}" disabled="true" from="${FtSrvFootSetting.typeMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/></td>
                            <td><g:select name="withdraw" value="${item.WITHDRAW.toString()}" disabled="true" from="${FtSrvFootSetting.withdrawMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/></td>
                        </tr>
                    </g:each>
                </table>
            </div>
            <div align="center">
                <input type="button" onclick="edit_submit()" name="button" id="button" class="rigt_button" disabled="true" value="修改">
                <input type="button" class="rigt_button" onclick="window.location.href = '${createLink(controller:'ftsrvfootsetting', action:'list', params:['customerNo':customerNo,'customerName':customerName])}'" value="返回"/>
            </div>
            <% } else { %>
            <div>
                <table align="center" class="right_list_table" id="test">
                    <tr>
                        <th>选择</th>
                        <th>业务类型</th>
                        <th>交易类型</th>
                        <th>结算周期</th>
                        <th>周期内频率</th>
                        <th>结算日期</th>
                        <th>风险预存期(天)</th>
                        <th>最低结算金额</th>
                        <th>结算单审核</th>
                        <th>提现方式</th>
                    </tr>
                    <g:each in="${ftTradeFeeList}" status="i" var="item">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td><input type="checkbox" name="chose" id="chose" checked onclick="check_box_change()">
                                <input type="hidden" name="chosevalue" id="chosevalue"></td>
                            <td>${item.SRV_NAME}<input type="hidden" name="srvcode" value="${item.SRVID}"/></td>
                            <td>${item.TRADE_NAME}<input type="hidden" name="tradeid" value="${item.TRADEID}"/></td>
                            <td><g:select name="foottype" value="${item.FOOT_TYPE.toString()}" from="${FtSrvFootSetting.tradeTypeMap}" optionKey="key" optionValue="value" class="right_top_h2_input" onchange="foottype_select()"/></td>
                            <% if (item.FOOT_TYPE == null || item.FOOT_TYPE.toString() == "0") { %>
                            <td><g:select name="foottimes" value="${item.FOOT_TIMES}" from="${FtSrvFootSetting.tradeTypeMap}" optionKey="key" optionValue="value" class="right_top_h2_input" disabled="true"/></td>
                            <td><g:textField name="footexpr" maxlength="100" style="width:80px" value="${item.FOOT_EXPR}" disabled="true"/></td>
                            <td><g:textField name="mortday" maxlength="8" style="width:40px" value="${item.MORT_DAY}" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" disabled="true"/>天</td>
                            <td><g:textField name="footamount" maxlength="11" style="width:40px" value="${item.FOOT_AMOUNT}" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" disabled="true"/></td>
                            <td><g:select name="type" value="${item.TYPE!=null?item.TYPE.toString():'0'}" from="${FtSrvFootSetting.typeMap}" optionKey="key" optionValue="value" class="right_top_h2_input" disabled="true"/></td>
                            <td><g:select name="withdraw" value="${item.WITHDRAW!=null?item.WITHDRAW.toString():'0'}" from="${FtSrvFootSetting.withdrawMap}" optionKey="key" optionValue="value" class="right_top_h2_input" disabled="true"/></td>
                            <% } else { %>
                            <td>
                                <% if (item.FOOT_TYPE.toString() == "1") { %>
                                <g:select name="foottimes" value="${item.FOOT_TIMES.intValue()}" from="${FtSrvFootSetting.timesMap_01}" optionKey="key" optionValue="value" class="right_top_h2_input"/>
                                <% } %>
                                <% if (item.FOOT_TYPE.toString() == "2") { %>
                                <g:select name="foottimes" value="${item.FOOT_TIMES.intValue()}" from="${FtSrvFootSetting.timesMap_02}" optionKey="key" optionValue="value" class="right_top_h2_input"/>
                                <% } %>
                                <% if (item.FOOT_TYPE.toString() == "3") { %>
                                <g:select name="foottimes" value="${item.FOOT_TIMES.intValue()}" from="${FtSrvFootSetting.timesMap_03}" optionKey="key" optionValue="value" class="right_top_h2_input"/>
                                <% } %>
                                <% if (item.FOOT_TYPE.toString() == "4") { %>
                                <g:select name="foottimes" value="${item.FOOT_TIMES.intValue()}" from="${FtSrvFootSetting.timesMap_04}" optionKey="key" optionValue="value" class="right_top_h2_input"/>
                                <% } %>
                            </td>
                            <td><g:textField name="footexpr" maxlength="100" style="width:80px" value="${item.FOOT_EXPR}"/></td>
                            <td><g:textField name="mortday" maxlength="8" style="width:40px" value="${item.MORT_DAY}" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>天</td>
                            <td><g:textField name="footamount" maxlength="11" style="width:40px" value="${item.FOOT_AMOUNT}" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/></td>
                            <td><g:select name="type" value="${item.TYPE.toString()}" from="${FtSrvFootSetting.typeMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/></td>
                            <td><g:select name="withdraw" value="${item.WITHDRAW.toString()}" from="${FtSrvFootSetting.withdrawMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/></td>
                            <% } %>
                        </tr>
                    </g:each>
                </table>
            </div>
            <div align="center">
                <input type="button" onclick="edit_submit()" name="button" id="button" class="rigt_button" value="修改">
                <input type="button" class="rigt_button" onclick="window.location.href = '${createLink(controller:'ftsrvfootsetting', action:'list', params:['customerNo':customerNo,'customerName':customerName])}'" value="返回"/>
            </div>
            <% } %>
        </div>
    </div>
    <br>
</g:form>
</body>
</html>