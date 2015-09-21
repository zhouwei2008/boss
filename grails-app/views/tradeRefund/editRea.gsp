<%@ page import="boss.BoAcquirerAccount; boss.BoBankDic" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text ml; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: '退款银行选择', default: '退款银行选择')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <link rel="stylesheet" type="text/css" href="../ext/css/ext-all.css"/>
    <link rel="stylesheet" type="text/css" href="../ext/css/style.css"/>
    <script type="text/javascript" src="../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../ext/js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ext/js/common.js"></script>
</head>
<body style="overflow-x:hidden">
<div class="main">

    <g:form>
        <table align="center" class="rigt_tebl">
            <tr>
                <td class="right label_name" nowrap>请选择退款银行：<font color="red">*</font></td>
                <td>
                    <g:select from="${BoBankDic.findAll()}" name="bankName" id="bankName" optionKey="code" optionValue="name" noSelection="${['':'-请选择-']}" class="right_top_h2_input" onchange="setBankAccounts(this.value)"></g:select>
                </td>
                <td class="right label_name" nowrap>请选择退款银行支行：<font color="red">*</font></td>
                <td>
                    <g:select from="" name="acquirerAccountName" id="acquirerAccountName" optionKey="id" optionValue="${{it.bankAccountName+' -- '+it.branchName}}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"></g:select>
                </td>
            </tr>
            <% if (request.getParameter("flag") == '0') { %>
            <tr>
                <td colspan="4">
                    <font style="color:red">请在报文文件下载完成后，点击审批通过！</font>
                </td>
            </tr>
            <% } %>

            <tr>
                <td colspan="4" align="center">
                    <% if (request.getParameter("flag") == '0') { %>
                    <span class="content"><input type="button" onclick="dlSelect()" id="button1" class="rigt_button" value="模板下载"></span>
                    <span class="content"><input type="button" onclick="checkReason('<%=request.getParameter("id")%>')" id="button3" class="rigt_button" value="审批通过" disabled></span>
                    <% } %>
                    <% if (request.getParameter("flag") != '0') { %>
                    <span class="content"><input type="button" onclick="checkReason('<%=request.getParameter("id")%>')" id="button4" class="rigt_button" value="审批通过"></span>
                    <% } %>
                    <span class="content"><input type="submit" onclick=" window.parent.win1.close();" name="button" id="button2" class="rigt_button" value="取消"></span>
                </td>
            </tr>
        </table>

    </g:form>
</div>
<script type="text/javascript">
    function setBankAccounts(id) {
        if (id == '') {
            $("#interfaced").empty();
            $("#selectAcquirerAccount option").remove();
            $("#selectAcquirerAccount").append("<option value=''>-请选择-</option>");
            $("#selectMerchant option").remove();
            $("#selectMerchant").append("<option value=''>-请选择-</option>");
        } else {
            var baseUrl = "${createLink(controller:'tradeRefund', action:'getAcquireAccountsJson')}";
            $.ajax({
                url: baseUrl,
                type: 'post',
                dataType: 'json',
                data:'bankCode=' + id,
                error: function() {
                    alert('对不起，加载失败！');
                },
                success: function(json) {
                    $("#interfaced").empty();
                    $("#acquirerAccountName option").remove();
                    $("#acquirerAccountName").append("<option value=''>-请选择-</option>");
                    $.each(json, function(i) {
                        $("#acquirerAccountName").append("<option value='" + json[i].id + "'>" + json[i].bankAccountName+' -- '+json[i].branchName + "</option>");
                    })
                }
            });
        }
    }

    function checkReason(id) {
        var flag = "<%=request.getParameter("flag")%>";
        var acquirerAccountId = document.getElementById("acquirerAccountName").value;
        var bankName = document.getElementById("bankName").value;
        if (!bankName) {
            alert("提现银行不允许为空，请选择提现银行！");
            return false;
        }
        if (!acquirerAccountId) {
            alert("提现银行支行不允许为空，请选择提现银行支行！");
            return false;
        }
        if (flag == 0) {
            window.parent.location.href = '${createLink(controller:'tradeRefund', action:'chCheck', params:['statusFlag':'1'])}&id=' + id + '&bankName=' + bankName + '&acquirerAccountId=' + acquirerAccountId;
        } else if (flag == 1) {
            window.parent.location.href = '${createLink(controller:'tradeRefund', action:'selectCheckPass', params:['statusFlag':'1'])}&id=' + id + '&bankName=' + bankName + '&acquirerAccountId=' + acquirerAccountId;
        } else if (flag == 2) {
            window.parent.location.href = '${createLink(controller:'tradeRefund', action:'singlePcPass', params:['statusFlag':'1'])}&id=' + id + '&bankName=' + bankName + '&acquirerAccountId=' + acquirerAccountId;
        }
        window.parent.win1.close();
    }
    function dlSelect() {
        var flag = "<%=request.getParameter("flag")%>";
        var sign = 1;
        var bankName = document.getElementById("bankName").value;
        var acquirerAccountId = document.getElementById("acquirerAccountName").value;
        var id = "<%=request.getParameter("id")%>";
        if (!bankName) {
            alert("提现银行不允许为空，请选择提现银行！");
            return false;
        }
        if (!acquirerAccountId) {
            alert("提现银行支行不允许为空，请选择提现银行支行！");
            return false;
        }
        var list = new Array("icbc", "ceb", "boc", "ccb", "hsbc", "unionpay", "citic","yep","abc","cmbc","sdb");
        for (i = 0; i < list.length; i++) {
            if (bankName.toLocaleLowerCase() == list[i]) {
                sign = 0
            }
        }
        if (sign == 1) {
            alert("该银行不支持模板下载！");
        } else {
            if (flag == 0) {
                window.parent.location.href = '${createLink(controller:'tradeRefund', action:'selectDl', params:['statusFlag':'1'])}&id=' + id + '&bankName=' + bankName;
            } else if (flag == 1) {
                window.parent.location.href = '${createLink(controller:'tradeRefund', action:'selectCheckPass', params:['statusFlag':'1'])}&id=' + id + '&bankName=' + bankName;
            }
        }
        document.getElementById('button3').disabled = false;
    }
</script>
</body>
</html>