<%@ page import="ismp.RefundAuth; boss.BoMerchant; ismp.TradePayment; ismp.TradeBase; boss.BoBankDic; boss.Perm; boss.BoAcquirerAccount; ismp.TradeRefund" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeRefund.label', default: 'TradeRefund')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
    <link rel="stylesheet" type="text/css" href="../../ext/css/ext-all.css"/>
    <link rel="stylesheet" type="text/css" href="../../ext/css/style.css"/>
    <script type="text/javascript" src="../../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../../ext/js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../../ext/js/common.js"></script>
</head>
<body style="overflow-x:hidden">
<script type="text/javascript">
    function checkReason(id) {
        var flag = 1;
        if (confirm("您确认要拒绝该退款处理？")) {
            var url = '../reasonInp.gsp?id=' + id + '&flag=' + flag;
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
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>

    <g:form>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.tradeNo.label"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeRefundInstance, field: "tradeNo")}</span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.payerName.label"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeRefundInstance, field: "payerName")}</span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.payerAccountNo.label"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeRefundInstance, field: "payerAccountNo")}</span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="账户余额"/>：</td>

                <td><span class="rigt_tebl_font" id="balance"><g:formatNumber number="${account.AcAccount.findByAccountNo (tradeRefundInstance?.payerAccountNo)?.balance==null?0:account.AcAccount.findByAccountNo (tradeRefundInstance?.payerAccountNo)?.balance/100}" type="currency" currencyCode="CNY"/></span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="商家订单号"/>：</td>
                <g:if test="${tradeRefundInstance.tradeType=='refund'}">
                    <td><span class="rigt_tebl_font" id="outTradeNo">${TradeBase.get(tradeRefundInstance.originalId)?.outTradeNo}</span></td>
                </g:if>
                <g:elseif test="${tradeRefundInstance.tradeType=='royalty_ref'}">
                    <td><span class="rigt_tebl_font" id="outTradeNo">${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId, 'payment')?.outTradeNo}</span></td>
                </g:elseif>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="订单金额"/>：</td>
                <g:if test="${tradeRefundInstance.tradeType=='refund'}">
                    <td><span class="rigt_tebl_font" id="money"><g:formatNumber number="${TradeBase.get(tradeRefundInstance.originalId)?.amount==null?0:TradeBase.get(tradeRefundInstance.originalId)?.amount/100}" type="currency" currencyCode="CNY"/></span></td>
                </g:if>
                <g:elseif test="${tradeRefundInstance.tradeType=='royalty_ref'}">
                    <td><span class="rigt_tebl_font" id="money"><g:formatNumber number="${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment')?.amount==null?0:TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment')?.amount/100}" type="currency" currencyCode="CNY"/></span></td>
                </g:elseif>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.amount.label"/>：</td>

                <td><span class="rigt_tebl_font" id="amount" val="${tradeRefundInstance?.amount / 100}"><g:formatNumber number="${tradeRefundInstance?.amount==null?0:tradeRefundInstance?.amount/100}" type="currency" currencyCode="CNY"/></span></td>

            </tr>

            <tr>
                            <td class="right label_name"><g:message code="实退金额"/>：</td>

                            <td><span class="rigt_tebl_font" id="amount" val="${tradeRefundInstance?.realityRefundAmount / 100}"><g:formatNumber number="${tradeRefundInstance?.realityRefundAmount==null?0:tradeRefundInstance?.realityRefundAmount/100}" type="currency" currencyCode="CNY"/></span></td>

                        </tr>


            <tr>
                <td class="right label_name"><g:message code="可退款金额"/>：</td>
                <g:if test="${tradeRefundInstance.tradeType=='refund'}">
                    <td>
                        <g:if test="${TradePayment.get(tradeRefundInstance.originalId)?.refundAmount!=null}">
                            <span class="rigt_tebl_font" id="refundMoney"><g:formatNumber number="${(TradeBase.get(tradeRefundInstance.originalId)?.amount-TradePayment.get(tradeRefundInstance.originalId)?.refundAmount)/100}" type="currency" currencyCode="CNY"/></span>
                        </g:if>
                        <g:else>
                            <g:formatNumber number="${TradeBase.get(tradeRefundInstance.originalId)?.amount==null?0:TradeBase.get(tradeRefundInstance.originalId)?.amount/100}" type="currency" currencyCode="CNY"/>
                        </g:else>
                    </td>
                </g:if>
                <g:elseif test="${tradeRefundInstance.tradeType=='royalty_ref'}">
                    <td><span class="rigt_tebl_font" id="refundMoney"><g:formatNumber number="${(TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment')?.amount-TradePayment.get(TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment').id)?.refundAmount)==null?0:(TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment')?.amount-TradePayment.get(TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment').id)?.refundAmount)/100}" type="currency" currencyCode="CNY"/></span></td>
                </g:elseif>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.feeAmount.label"/>：</td>

                <td><span class="rigt_tebl_font"><g:formatNumber number="${tradeRefundInstance?.feeAmount/100}" type="currency" currencyCode="CNY"/></span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.backFee.label"/>：</td>
                <td><span class="rigt_tebl_font"><g:formatNumber number="${tradeRefundInstance?.backFee/100}" type="currency" currencyCode="CNY"/></span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="银行订单号"/>：</td>
                <td><span class="rigt_tebl_font">${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId, 'charge')?.outTradeNo}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="支付银行"/>：</td>
                <td>${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId, 'charge')?.payerName}</td>
                %{--<g:if test="${tradeRefundInstance.acquirerMerchantNo!=null && tradeRefundInstance.acquirerMerchantNo!=''}">
                    <td>${BoBankDic.get(BoAcquirerAccount.get(BoMerchant.findByAcquireMerchant(tradeRefundInstance.acquirerMerchantNo)?.acquirerAccount?.id)?.bank?.id)?.name}</td>
                </g:if>
                <g:else>
                    <td></td>
                </g:else>--}%
            </tr>

            <tr>
                <td class="right label_name"><g:message code="支付方式"/>：</td>
                <td><span class="rigt_tebl_font">${TradeRefund.channelMap[tradeRefundInstance?.channel]}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="交易时间"/>：</td>
                <g:if test="${tradeRefundInstance.tradeType=='refund'}">
                    <td><span class="rigt_tebl_font" id="tradeTime"><g:formatDate date="${TradeBase.get(tradeRefundInstance.originalId)?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
                </g:if>
                <g:elseif test="${tradeRefundInstance.tradeType=='royalty_ref'}">
                    <td><span class="rigt_tebl_font" id="tradeTime"><g:formatDate date="${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment')?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
                </g:elseif>
            </tr>
            <g:if test="${tradeRefundInstance.tradeType=='refund'}">
                <tr>
                    <td class="right label_name"><g:message code="企业账户名称"/>：</td>
                    <td><span class="rigt_tebl_font">${RefundAuth.findByOutTradeNoAndType(TradeBase.get(tradeRefundInstance.originalId)?.outTradeNo,'completed')?.refundAccName}</span></td>
                </tr>
                <tr>
                    <td class="right label_name"><g:message code="企业账户号"/>：</td>
                    <td><span class="rigt_tebl_font">${RefundAuth.findByOutTradeNoAndType(TradeBase.get(tradeRefundInstance.originalId)?.outTradeNo,'completed')?.refundAccNo}</span></td>
                </tr>
                <tr>
                    <td class="right label_name"><g:message code="开户行名称"/>：</td>
                    <td><span class="rigt_tebl_font">${RefundAuth.findByOutTradeNoAndType(TradeBase.get(tradeRefundInstance.originalId)?.outTradeNo,'completed')?.bankName}</span></td>
                </tr>
            </g:if>
            <tr>
                <td class="right label_name"><g:message code="tradeRefund.acquirer_account_id.label"/>：</td>
                <td>${BoBankDic.get(BoAcquirerAccount.get(tradeRefundInstance?.acquirer_account_id)?.bank?.id)?.name}</td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.dateCreated.label"/>：</td>

                <td><span class="rigt_tebl_font"><g:formatDate date="${tradeRefundInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
            </tr>

            <g:if test="${sign!='0'}">
                <tr>
                    <td class="right label_name"><g:message code="tradeRefund.firstAppDate.label"/>：</td>

                    <td><span class="rigt_tebl_font"><g:formatDate date="${tradeRefundInstance?.firstAppDate}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
                </tr>
                <tr>
                    <td class="right label_name"><g:message code="tradeRefund.firstAppName.label"/>：</td>

                    <td><span class="rigt_tebl_font">${tradeRefundInstance?.firstAppName}</span></td>
                </tr>
            </g:if>
             <g:if test="${sign=='3' || sign=='4'}">
                <tr>
                    <td class="right label_name"><g:message code="tradeRefund.lastAppDate.label"/>：</td>

                    <td><span class="rigt_tebl_font"><g:formatDate date="${tradeRefundInstance?.lastAppDate}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
                </tr>
                <tr>
                    <td class="right label_name"><g:message code="tradeRefund.lastAppName.label"/>：</td>

                    <td><span class="rigt_tebl_font">${tradeRefundInstance?.lastAppName}</span></td>
                </tr>
            </g:if>

            <g:if test="${sign=='4'}">
                <tr>
                    <td class="right label_name"><g:message code="tradeRefund.refundHandleDate.label"/>：</td>

                    <td><span class="rigt_tebl_font"><g:formatDate date="${tradeRefundInstance?.refundHandleDate}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
                </tr>
                <tr>
                    <td class="right label_name"><g:message code="tradeRefund.refundHandleName.label"/>：</td>

                    <td><span class="rigt_tebl_font">${tradeRefundInstance?.refundHandleName}</span></td>
                </tr>
            </g:if>

            <tr>
                <td class="right label_name"><g:message code="退款原因"/>：</td>

                <td><span class="rigt_tebl_font">${tradeRefundInstance?.subject}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.handleStatus.label"/>：</td>

                <td><span class="rigt_tebl_font">${TradeRefund.handleStatusMap[tradeRefundInstance?.handleStatus]}</span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.note.label"/>：</td>
                <td>
                    %{--<g:if test="${tradeRefundInstance?.refundBatchNo!=null}">--}%
                    ${tradeRefundInstance?.note}
                    %{--</g:if>--}%
                    %{--<g:else>--}%
                    %{--<g:textArea name="note" value="${tradeRefundInstance?.note}"></g:textArea>--}%
                    %{--</g:else>--}%
                </td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <g:form>
                        <g:hiddenField name="id" value="${tradeRefundInstance?.id}"/>
                        <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                        <g:if test="${tradeRefundInstance?.refundBatchNo==null && sign=='1'}">
                            <bo:hasPerm perm="${Perm.Trade_RfdChk_ProcPas}">
                                <span class="button"><g:actionSubmit class="rigt_button" action="singleCheck" value="通过"/></span>
                            </bo:hasPerm>
                             <bo:hasPerm perm="${Perm.Trade_RfdChk_ProcRef}">
                                <span class="button"><input type="button" class="rigt_button" onclick="checkReason('${tradeRefundInstance?.id}')" value="拒绝"/></span>
                            </bo:hasPerm>
                        </g:if>
                    </g:form>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>