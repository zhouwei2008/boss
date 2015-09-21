<%@ page import="boss.BoBankDic" %>
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
                <td class="right label_name">请选择退款银行：</td>
                <td><g:select from="${BoBankDic.findAll().name}" name="seBankName" id="seBankName"></g:select></td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="content"><input type="button" onclick="checkReason()" id="button" class="rigt_button" value="确定"></span>
                    <span class="content"><input type="submit" onclick=" window.parent.win1.close();" name="button" id="button2" class="rigt_button" value="取消"></span>
                </td>
            </tr>
        </table>

    </g:form>
</div>
<script type="text/javascript">
    function checkReason() {
        var startDateCreated = "<%=request.getParameter("startDateCreated")%>";
        var endDateCreated = "<%=request.getParameter("endDateCreated")%>";
        %{--var bankNo = "<%=request.getParameter("bankNo")%>";--}%
        var tradeNo = "<%=request.getParameter("tradeNo")%>";
        %{--var outTradeNo = "<%=request.getParameter("outTradeNo")%>";--}%
        var payerName="<%=request.getParameter("payerName")%>"
        var payerAccountNo="<%=request.getParameter("payerAccountNo")%>"
        var bankName = "<%=request.getParameter("bankName")%>";
        var paymentType = "<%=request.getParameter("paymentType")%>";
        var startAmount = "<%=request.getParameter("startAmount")%>";
        var endAmount = "<%=request.getParameter("endAmount")%>";
        var seBankName = document.getElementById("seBankName").value;
        var flag = "<%=request.getParameter("flag")%>";
        if(flag==0){
             window.parent.location.href = '${createLink(controller:'tradeRefund', action:'allCheckPass', params:['statusFlag':'1'])}&startDateCreated=' + startDateCreated
                + '&endDateCreated=' + endDateCreated + '&payerName=' + payerName + '&tradeNo=' + tradeNo + '&payerAccountNo=' + payerAccountNo
                + '&bankName=' + bankName + '&paymentType=' + paymentType + '&startAmount=' + startAmount + '&endAmount=' + endAmount + '&seBankName=' + seBankName;
        } else if(flag==1){
             window.parent.location.href = '${createLink(controller:'tradeRefund', action:'allSelectPass', params:['statusFlag':'1'])}&startDateCreated=' + startDateCreated
                + '&endDateCreated=' + endDateCreated + '&payerName=' + payerName + '&tradeNo=' + tradeNo + '&payerCode=' + payerCode
                + '&bankName=' + bankName + '&paymentType=' + paymentType + '&startAmount=' + startAmount + '&endAmount=' + endAmount + '&seBankName=' + seBankName;
        }

        window.parent.win1.close();
    }
</script>
</body>
</html>