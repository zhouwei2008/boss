<%@ page import="boss.Perm; boss.BoBankDic; boss.BoAcquirerAccount; ismp.TradePayment; ismp.TradeBase; ismp.TradeCharge; gateway.GwTransaction; ismp.WithdrawnBatch" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'withdrawnBatch.label', default: 'WithdrawnBatch')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
    <link rel="stylesheet" type="text/css" href="../../ext/css/ext-all.css"/>
    <link rel="stylesheet" type="text/css" href="../../ext/css/style.css"/>
    <script type="text/javascript" src="../../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../../ext/js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../../ext/js/common.js"></script>
</head>
<body>
<script type="text/javascript">
    function selRefused(id, withdrawnBatchNo) {
        if (confirm("您确认要拒绝该退款请求？")) {
            var url = '../editRea.gsp?id=' + id + '&withdrawnBatchNo=' + withdrawnBatchNo;
            win1 = new Ext.Window({
                id:'win1',
                title:"请输入拒绝原因",
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
        <div class="message">${flash.message}</div>
    </g:if>

    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>

        <table align="center" class="right_list_table" id="test">

            <tr>
                <g:sortableColumn params="${params}" property="withdrawnBatchNo" title="${message(code: 'tradeWithdrawn.withdrawnBatchNo.label')}"/>
                <g:sortableColumn params="${params}" property="tradeNo" title="${message(code: 'tradeWithdrawn.tradeNo.label')}"/>
                <g:sortableColumn params="${params}" property="payerName" title="${message(code: 'tradeWithdrawn.payerName.label')}"/>
                <g:sortableColumn params="${params}" property="amount" title="${message(code: 'tradeWithdrawn.amount.label')}"/>
                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'tradeWithdrawn.dateCreated.label')}"/>
                <th>提现银行</th>
                <th>提现客户账户</th>
                <th>客户账户名称</th>
                <g:sortableColumn params="${params}" property="appDate" title="${message(code: 'tradeWithdrawn.firstAppDate.label')}"/>
                <g:sortableColumn params="${params}" property="appName" title="${message(code: 'tradeWithdrawn.firstAppName.label')}"/>
                <th>操作</th>
            </tr>

            <g:each in="${tradeWithdrawnBatchInstance}" status="i" var="tradeWithdrawnBatch">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>${fieldValue(bean: tradeWithdrawnBatch, field: "withdrawnBatchNo")}</td>
                    <td><g:if test="${bo.hasPerm(perm:Perm.WithDraw_ChkBth_ProcView){true}}">
                        <g:link controller="tradeWithdrawn" action="refuseShow" id="${tradeWithdrawnBatch.id}" params="['sign':'2']">${fieldValue(bean: tradeWithdrawnBatch, field: "tradeNo")}</g:link>
                    </g:if>
                    <g:else>${fieldValue(bean: tradeWithdrawnBatch, field: "tradeNo")}</g:else>
                    </td>
                    <td>${fieldValue(bean: tradeWithdrawnBatch, field: "payerName")}</td>
                    <td><g:formatNumber number="${tradeWithdrawnBatch?.amount?tradeWithdrawnBatch?.amount/100:0}" type="currency" currencyCode="CNY"/></td>
                    <td><g:formatDate date="${tradeWithdrawnBatch?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${BoBankDic.get(BoAcquirerAccount.get(tradeWithdrawnBatch?.acquirerAccountId)?.bank?.id)?.name}</td>
                    <td>${fieldValue(bean: tradeWithdrawnBatch, field: "payerAccountNo")}</td>
                    <td>${fieldValue(bean: tradeWithdrawnBatch, field: "customerBankAccountName")}</td>
                    <td><g:formatDate date="${tradeWithdrawnBatch?.firstAppDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${fieldValue(bean: tradeWithdrawnBatch, field: "firstAppName")}</td>
                    <td><g:if test="${bo.hasPerm(perm:Perm.WithDraw_ChkBth_ProcRef){true}}"><input type="button" value="拒绝" onclick="selRefused(${tradeWithdrawnBatch.id}, ${withdrawnBatchNo})"></g:if></td>
                </tr>
            </g:each>
            <tr>
                <td colspan="12" align="content">
                    <g:form>
                        <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                        <g:hiddenField name="id" value="${withdrawnBatchNo}"></g:hiddenField>
                        <bo:hasPerm perm="${Perm.WithDraw_ChkBth_ProcPas}">
                            <span class="button"><g:actionSubmit class="rigt_button" action="batchCheck" value="通过"/></span>
                        </bo:hasPerm>
                        <bo:hasPerm perm="${Perm.WithDraw_ChkBth_ProcDl}">
                            <span class="rigt_button_down"><g:link controller="tradeWithdrawn" action="listDownload" params="['flag':'2','withdrawnBatchNo':withdrawnBatchNo]">下载</g:link></span>
                        </bo:hasPerm>
                    </g:form>
                </td>
            </tr>
        </table>
        合计：金额总计：${totalAmount ? totalAmount / 100 : 0}元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;笔数总计：${totalCount ? totalCount : 0}笔
        <div class="paginateButtons">
            <span style=" float:left;">共${totalCount}条记录</span>
            <g:paginat total="${totalCount}" params="${params}"/>
        </div>
    </div>

</div>
</body>
</html>
