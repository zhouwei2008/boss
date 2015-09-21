<%@ page import="boss.BoAcquirerAccount; boss.BoBankDic" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text ml; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: '出款银行选择', default: '出款银行选择')}"/>
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
                <td class="right label_name" nowrap>请选择出款银行：<font color="red">*</font></td>
                <td>
                    <g:select from="${BoBankDic.findAll()}" name="bankName" id="bankName" optionKey="code" optionValue="name" noSelection="${['':'-请选择-']}" class="right_top_h2_input" onchange="setBankAccounts(this.value)"></g:select>
                </td>
                <td class="right label_name" nowrap>请选择出款银行支行：<font color="red">*</font></td>
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
                    <span class="content"><input type="button" onclick="checkReason('<%=request.getParameter("id")%>', '1')" id="button" class="rigt_button" value="审批通过" disabled></span>
                    <% } %>
                    <% if (request.getParameter("flag") == '1') { %>
                    <span class="content"><input type="button" onclick="checkReason('<%=request.getParameter("id")%>', '2')" id="button3" class="rigt_button" value="审批通过"></span>
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
            var baseUrl = "${createLink(controller:'tradeWithdrawn', action:'getAcquireAccountsJson')}";
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

    function checkReason(id, flag) {
        var acquirerAccountId = document.getElementById("acquirerAccountName").value;
        var bankName = document.getElementById("bankName").value;
        if (!bankName) {
            alert("出款银行不允许为空，请选择出款银行！");
            return false;
        }
        if (!acquirerAccountId) {
            alert("出款银行支行不允许为空，请选择出款银行支行！");
            return false;
        }
        window.parent.location.href = '${createLink(controller:'tradeWithdrawn', action:'selectCheck', params:['statusFlag':'1'])}&id=' + id + '&bankName=' + bankName + '&flag=' + flag + '&acquirerAccountId=' + acquirerAccountId;
        window.parent.win1.close();
    }
    function dlSelect() {
        var flag = "<%=request.getParameter("flag")%>";
        var bankName = document.getElementById("bankName").value;
        var acquirerAccountId = document.getElementById("acquirerAccountName").value;
        var id = "<%=request.getParameter("id")%>";
        if (!bankName) {
            alert("出款银行不允许为空，请选择出款银行！");
            return false;
        }
        if (!acquirerAccountId) {
            alert("出款银行支行不允许为空，请选择出款银行支行！");
            return false;
        }

        if (bankName.toLocaleLowerCase() != 'icbc' && bankName.toLocaleLowerCase() != 'ccb' && bankName.toLocaleLowerCase() != 'abc' && bankName.toLocaleLowerCase() != 'jinlian_wanjia') {
            alert("该银行不支持模板下载！");
        } else {
            if (flag == 0) {
                window.parent.location.href = '${createLink(controller:'tradeWithdrawn', action:'selectDl', params:['statusFlag':'1'])}&id=' + id + '&bankName=' + bankName+'&acquirerAccountId='+acquirerAccountId;
            } else if (flag == 1) {
                window.parent.location.href = '${createLink(controller:'tradeWithdrawn', action:'selectCheck', params:['statusFlag':'1'])}&id=' + id + '&bankName=' + bankName+'&acquirerAccountId='+acquirerAccountId;
            }
        }

//        document.getElementById('button2').disabled=false;
        document.getElementById('button').disabled = false;

    }
</script>
</body>
</html>