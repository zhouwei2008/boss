<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'FeeSettleshenhe_his_show.lable')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startTradeDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endTradeDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });
    function checkDate() {
        if (!document.getElementById('endDateCreated').value.length == 0) {
            var startDateCreated = document.getElementById('startDateCreated').value;
            var endDateCreated = document.getElementById('endDateCreated').value;
            if (Number(startDateCreated > endDateCreated)) {
                alert('创建开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }

    }
    function download(){
         window.location.href='${createLink(controller:'postFeeSettle',action:'downloadDetails')}'+ '?id='+${params.id} ;
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <input type="button" class="right_top_h2_button_download" value="下载" onClick="download()">
        <table align="center" class="right_list_table" id="test">
            <tr>
                <th>序号</th>
                <th>商户编号</th>
                <th>商户名称</th>
                <th>流水号</th>
                <th>银行订单号</th>
                <th>业务类型</th>
                <th>交易类型</th>
                <th>订单时间</th>
                <th>支付时间</th>
                <th>金额</th>
                <th>手续费金额</th>
                <th>支付渠道</th>
            </tr>
            <g:each in="${ftTradeFeeList}" status="i" var="item">
                <tr>
                    <td>${i + 1}</td>
                    <td>${item.CUSTOMER_NO}</td>
                    <g:set var="cu" value="${ismp.CmCustomer.findByCustomerNo(item.CUSTOMER_NO)}"/>
                    <g:if test="${cu instanceof ismp.CmCorporationInfo}"><td>${cu?.registrationName}</td></g:if>
                    <g:else><td>${cu?.name}</td></g:else>
                    <td>${item.SEQ_NO}</td>
                    <td></td>
                    <td>${item.SRV_NAME}</td>
                    <td>${item.TRADE_NAME}</td>
                    <td><g:formatDate format="yyyy.MM.dd HH:mm:ss" date="${item.BILL_DATE}"/></td>
                    <td><g:formatDate format="yyyy.MM.dd HH:mm:ss" date="${item.TRADE_DATE}"/></td>
                    <td>${item.AMOUNT / 100}</td>
                    <td><g:if test="${item.POST_FEE}">${item.POST_FEE / 100}</g:if><g:elseif test="${item.PRE_FEE}">${item.PRE_FEE / 100}</g:elseif></td>
                    <td></td>
                </tr>
            </g:each>
        </table>
        <div class="paginateButtons">
            <div align="left"><div style="position:absolute;">共${total}条记录</div></div>
            <g:paginat total="${total}" params="${params}"/>
        </div>
        <div align="center">
            <input type="button" onclick="window.location.href = '${createLink(controller:'postFeeSettle',action:'settle_his_list')}'" value="返回"/>
        </div>
    </div>
</div>
</body>
</html>