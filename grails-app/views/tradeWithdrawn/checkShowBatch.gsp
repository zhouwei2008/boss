<%@ page import="ismp.TradeWithdrawn; boss.BoMerchant; boss.BoBankDic; boss.BoAcquirerAccount; boss.Perm; gateway.GwTransaction; ismp.TradeCharge; ismp.TradePayment; ismp.TradeBase; ismp.TradeRefund" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeWithdrawn.checkListBatch.label', default: 'TradeWithdrawn')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <link rel="stylesheet" type="text/css" href="../ext/css/ext-all.css"/>
    <link rel="stylesheet" type="text/css" href="../ext/css/style.css"/>
    <script type="text/javascript" src="../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../ext/js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ext/js/common.js"></script>
</head>
<body>

<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <g:sortableColumn params="${params}" property="withdrawnBatchNo" title="${message(code: 'tradeWithdrawn.withdrawnBatchNo.label')}"/>
                <g:sortableColumn params="${params}" property="tradeNo" title="${message(code: 'tradeWithdrawn.tradeNo.label')}"/>
                <g:sortableColumn params="${params}" property="payerName" title="${message(code: 'tradeWithdrawn.payerName.label')}"/>
                <g:sortableColumn params="${params}" property="payerAccountNo" title="${message(code: 'tradeWithdrawn.payerAccountNo.label')}"/>
                <th>提现银行</th>
                <g:sortableColumn params="${params}" property="amount" title="${message(code: 'tradeWithdrawn.amount.label')}"/>
                <g:sortableColumn params="${params}" property="handleStatus" title="${message(code: 'tradeWithdrawn.handleStatus.label')}"/>

                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'tradeWithdrawn.dateCreated.label')}"/>

                <g:if test="${sign=='0'}">
                    <g:sortableColumn params="${params}" property="firstAppDate" title="${message(code: 'tradeWithdrawn.firstAppDate.label')}"/>
                    <g:sortableColumn params="${params}" property="firstAppName" title="${message(code: 'tradeWithdrawn.firstAppName.label')}"/>
                </g:if>
                <g:elseif test="${sign=='1'}">
                    <g:sortableColumn params="${params}" property="lastAppDate" title="${message(code: 'tradeWithdrawn.lastAppDate.label')}"/>
                    <g:sortableColumn params="${params}" property="lastAppName" title="${message(code: 'tradeWithdrawn.lastAppName.label')}"/>
                </g:elseif>
                <g:elseif test="${sign=='2'}">
                    <g:sortableColumn params="${params}" property="withdrawnHandleDate" title="${message(code: 'tradeWithdrawn.withdrawnHandleDate.label')}"/>
                    <g:sortableColumn params="${params}" property="withdrawnHandleName" title="${message(code: 'tradeWithdrawn.withdrawnHandleName.label')}"/>
                </g:elseif>
                %{--<th>拒绝原因</th>--}%
            </tr>

            <g:each in="${tradeWithdrawnInstanceList}" status="i" var="tradeWithdrawnInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:if test="${bo.hasPerm(perm:Perm.WithDraw_RfdBthRef_BatNo) {true}|| bo.hasPerm(perm:Perm.WithDraw_RfdBthRef_BatNo){true} || bo.hasPerm(perm:Perm.WithDraw_His_BatNo){true} }"><g:link action="checkBatchShow" id="${tradeWithdrawnInstance.withdrawnBatchNo}">${fieldValue(bean: tradeWithdrawnInstance, field: "withdrawnBatchNo")}</g:link></g:if><g:else>${fieldValue(bean: tradeWithdrawnInstance, field: "withdrawnBatchNo")}</g:else></td>
                    <td><g:if test="${bo.hasPerm(perm:Perm.WithDraw_RfdBthRef_TradeNo) {true}|| bo.hasPerm(perm:Perm.WithDraw_RfdBthRef_TradeNo){true} || bo.hasPerm(perm:Perm.WithDraw_His_TradeNo){true} }"><g:link action="refuseShow" id="${tradeWithdrawnInstance.id}">${fieldValue(bean: tradeWithdrawnInstance, field: "tradeNo")}</g:link></g:if><g:else>${fieldValue(bean: tradeWithdrawnInstance, field: "tradeNo")}</g:else></td>
                    <td>${fieldValue(bean: tradeWithdrawnInstance, field: "payerName")}</td>
                    <td>${fieldValue(bean: tradeWithdrawnInstance, field: "payerAccountNo")}</td>

                    <td>${BoBankDic.get(BoAcquirerAccount.get(tradeWithdrawnInstance?.acquirerAccountId)?.bank?.id)?.name}</td>

                    <td><g:formatNumber number="${tradeWithdrawnInstance?.amount/100}" type="currency" currencyCode="CNY"/></td>
                    <td>${TradeWithdrawn.handleStatusMap[tradeWithdrawnInstance?.handleStatus]}</td>

                    <td><g:formatDate date="${tradeWithdrawnInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <g:if test="${sign=='0'}">
                        <td><g:formatDate date="${tradeWithdrawnInstance?.firstAppDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>${tradeWithdrawnInstance?.firstAppName}</td>
                    </g:if>
                    <g:elseif test="${sign=='1'}">
                        <td><g:formatDate date="${tradeWithdrawnInstance?.lastAppDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>${tradeWithdrawnInstance?.lastAppName}</td>
                    </g:elseif>
                    <g:elseif test="${sign=='2'}">
                        <td><g:formatDate date="${tradeWithdrawnInstance?.withHandleDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>${tradeWithdrawnInstance?.withHandleName}</td>
                    </g:elseif>

                </tr>
            </g:each>
            <tr>
                <td colspan="13" align="center">
                    <g:form>
                        <g:hiddenField name="withdrawnBatchNo" value="${withdrawnBatchNo}"></g:hiddenField>
                        <g:hiddenField name="bankCode" value="${bankCode}"></g:hiddenField>
                        <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                        <g:if test="${bo.hasPerm(perm:Perm.WithDraw_RfdBthChk_AutoChk){true}}">
                            <g:if test="${sign=='1'}">
                                <span class="button"><g:actionSubmit class="rigt_button" action="autoCheck" value="自动对账"/></span>
                            </g:if>
                        </g:if>
                    </g:form>
                </td>
            </tr>
        </table>
        合计：提现金额总计：${withdrawnAmount ? withdrawnAmount / 100 : 0}元
        <div class="paginateButtons">
            <span style=" float:left;">共${tradeWithdrawnInstanceTotal}条记录</span>
            <g:paginat total="${tradeWithdrawnInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
