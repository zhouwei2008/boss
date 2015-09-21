<%@ page import="boss.Perm" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'postFeeSettle.lable')}"/>
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
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:hiddenField name="start" value="${params.start}"/>
            <g:hiddenField name="end" value="${params.end}"/>
            <table align="center" class="right_list_table" id="test">
                <tr>
                    <th>序号</th>
                    <th>商户编号</th>
                    <th>商户名称</th>
                    <th>开始时间</th>
                    <th>结束时间</th>
                    <th>业务类型</th>
                    <th>交易类型</th>
                    <th>交易笔数</th>
                    <th>金额</th>
                    <th>后返手续费</th>
                    <th>还款金额</th>
                    <th>操作</th>
                    <td>生成结算单</td>
                </tr>
                <g:each in="${result}" status="i" var="item">
                    <tr>
                        <td>${i + 1}</td>
                        <td>${item.CUSTOMERNO}</td>
                        <g:set var="cu" value="${ismp.CmCustomer.findByCustomerNo(item.CUSTOMERNO)}"/>
                        <g:if test="${cu instanceof ismp.CmCorporationInfo}"><td>${cu?.registrationName}</td></g:if>
                        <g:else><td>${cu?.name}</td></g:else>
                        <td><g:formatDate format="yyyy.MM.dd" date="${item.MINTIME}"/></td>
                        <td><g:formatDate format="yyyy.MM.dd" date="${item.MAXTIME}"/></td>
                        <td>${item.SRVNAME}</td>
                        <td>${item.TRADENAME}</td>
                        <td>${item.TRANSNUM}</td>
                        <td>${item.AMOUNT/100}</td>
                        <td><g:if test="${item.POSTFEE}">${item.POSTFEE/100}</g:if></td>
                        <td><g:if test="${item.POSTFEE}">${item.POSTFEE/100}</g:if></td>
                        <td>
                          <bo:hasPerm perm="${Perm.Settle_PostManualSettle_Proc_View}">
                            <a href='${createLink(controller:'postFeeSettle', action:'show', params:['customerNo':item.CUSTOMERNO,'customerName':cu?.name,'status':0,'startDate':item.MINTIME,'endDate':item.MAXTIME,'srvcode':item.SRVCODE,'tradecode':item.TRADECODE])}'>查看明细</a>
                          </bo:hasPerm>
                        </td>
                        <td>
                          <bo:hasPerm perm="${Perm.Settle_PostManualSettle_Proc_Gen}">
                            <input type="button" onclick="window.location.href = '${createLink(controller:'postFeeSettle', action:'create', params:['customerNo':item.CUSTOMERNO,'startDate':item.MINTIME,'endDate':item.MAXTIME,'srvcode':item.SRVCODE,'tradecode':item.TRADECODE,'amount':item.AMOUNT,'transNum':item.TRANSNUM,'postFee':item.POSTFEE,'start':params.start,'end':params.end])}'" value="生成"/>
                          </bo:hasPerm>
                        </td>
                    </tr>
                </g:each>
            </table>
            合计：金额：<g:formatNumber number="${totalAmount/100}" format="#.##"/>元，后返手续费金额：<g:formatNumber number="${totalPostFee/100}" format="#.##"/>元
            <br>
            <div class="paginateButtons">
                <div align="left"><div style="position:absolute;">共${total}条记录</div></div>
                <g:paginat total="${total}" params="${params}"/>
            </div>
            <div align="center">
                <input type="button" class="rigt_button" onclick="window.location.href = '${createLink(controller:'postFeeSettle', action:'merchant_list')}'" value="返回"/>
            </div>
        </h2>
    </div>
</div>
</body>
</html>