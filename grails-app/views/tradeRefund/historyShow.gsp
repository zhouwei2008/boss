<%@ page import="boss.BoBankDic; boss.BoMerchant; ismp.TradePayment; ismp.TradeBase; gateway.GwTransaction; ismp.TradeCharge; boss.AppNote; boss.BoAcquirerAccount; ismp.TradeRefund" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeRefund.label', default: 'TradeRefund')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>

    <g:form>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2">查看退款历史明细</th>
            </tr>
            <tr>
                <td class="right label_name">批次号：</td>
                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeRefundInstance, field: "refundBatchNo")}</span></td>
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
            <% def account = account.AcAccount.findByAccountNo (tradeRefundInstance?.payerAccountNo) %>
            <tr>
                <td class="right label_name">账户余额：</td>
                <td><span class="rigt_tebl_font" id="balance"><g:formatNumber number="${account?.balance==null?0:account?.balance/100}" type="currency" currencyCode="CNY"/></span></td>
            </tr>
            <tr>
                <td class="right label_name">商家订单号：</td>
                <g:if test="${tradeRefundInstance.tradeType=='refund'}">
                    <td><span class="rigt_tebl_font">${TradeBase.get(tradeRefundInstance.originalId)?.outTradeNo}</span></td>
                </g:if>
                <g:elseif test="${tradeRefundInstance.tradeType=='royalty_ref'}">
                    <td><span class="rigt_tebl_font">${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId, 'payment')?.outTradeNo}</span></td>
                </g:elseif>
                <g:else>
                    <td></td>
                </g:else>
                <td><span class="rigt_tebl_font"></span></td>
            </tr>
            <tr>
                <td class="right label_name">订单金额：</td>
                    <g:if test="${tradeRefundInstance.partnerId==null}">
                        <g:if test="${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'charge')?.amount>0}">
                            <td><span class="rigt_tebl_font"><g:formatNumber number="${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'charge')?.amount/100}" type="currency" currencyCode="CNY"/></span></td>
                        </g:if>
                    </g:if>
                    <g:elseif test="${tradeRefundInstance.partnerId!=null}">
                        <g:if test="${TradePayment.get(tradeRefundInstance.originalId)?.amount>0}">
                            <td><span class="rigt_tebl_font"><g:formatNumber number="${TradePayment.get(tradeRefundInstance.originalId)?.amount/100}" type="currency" currencyCode="CNY"/></span></td>
                        </g:if>
                    </g:elseif>
                    <g:else>
                        <td></td>
                    </g:else>
                %{--<g:if test="${tradeRefundInstance.tradeType=='refund'}">--}%
                    %{--<td><span class="rigt_tebl_font"><g:formatNumber number="${TradeBase.get(tradeRefundInstance.originalId)?.amount==null?0:TradeBase.get(tradeRefundInstance.originalId)?.amount/100}" type="currency" currencyCode="CNY"/></span></td>--}%
                %{--</g:if>--}%
                %{--<g:elseif test="${tradeRefundInstance.tradeType=='royalty_ref'}">--}%
                    %{--<td><span class="rigt_tebl_font"><g:formatNumber number="${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment')?.amount==null?0:TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment')?.amount/100}" type="currency" currencyCode="CNY"/></span></td>--}%
                %{--</g:elseif>--}%
            </tr>
            <tr>
                <td class="right label_name"><g:message code="tradeRefund.amount.label"/>：</td>
                <td><span class="rigt_tebl_font"><g:formatNumber number="${tradeRefundInstance?.amount/100}" type="currency" currencyCode="CNY"/></span></td>

            </tr>
                 <tr>
                            <td class="right label_name"><g:message code="实退金额"/>：</td>

                            <td><span class="rigt_tebl_font" id="amount" val="${tradeRefundInstance?.realityRefundAmount / 100}"><g:formatNumber number="${tradeRefundInstance?.realityRefundAmount==null?0:tradeRefundInstance?.realityRefundAmount/100}" type="currency" currencyCode="CNY"/></span></td>

                        </tr>
            <tr>
                <td class="right label_name">可退款金额：</td>
                <g:if test="${tradeRefundInstance.tradeType=='refund'}">
                    <%
                       def tradeBase = TradeBase.get(tradeRefundInstance.originalId)
                       def tradePay =  TradePayment.get(tradeRefundInstance.originalId)
                    %>
                    <td><span class="rigt_tebl_font"><g:formatNumber number="${(tradeBase?.amount-tradePay?.refundAmount)==null?0:(tradeBase?.amount-tradePay?.refundAmount)/100}" type="currency" currencyCode="CNY"/></span></td>
                </g:if>
                <g:elseif test="${tradeRefundInstance.tradeType=='royalty_ref'}">
                    <%
                       def royalty = TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment')
                       def payment = TradePayment.get(TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment').id)
                    %>
                    <td><span class="rigt_tebl_font"><g:formatNumber number="${(royalty?.amount-payment?.refundAmount)==null?0:(royalty?.amount-payment?.refundAmount)/100}" type="currency" currencyCode="CNY"/></span></td>
                </g:elseif>
                <g:else>
                    <td></td>
                </g:else>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="tradeRefund.feeAmount.label"/>：</td>

                <td><span class="rigt_tebl_font"><g:formatNumber number="${tradeRefundInstance?.feeAmount/100}" type="currency" currencyCode="CNY"/></span></td>

            </tr>
            <tr>
                <td class="right label_name">银行订单号：</td>
                <td><span class="rigt_tebl_font">${GwTransaction.get(TradeCharge.findByRootId(tradeRefundInstance.rootId)?.tradeNo)?.bankTransNo}</span></td>
            </tr>
            <tr>
                <td class="right label_name">支付银行：</td>
                <g:if test="${tradeRefundInstance.acquirerMerchantNo!=null && tradeRefundInstance.acquirerMerchantNo!=''}">
                    <td><span class="rigt_tebl_font">${BoBankDic.get(BoAcquirerAccount.get(BoMerchant.findByAcquireMerchant(tradeRefundInstance.acquirerMerchantNo)?.acquirerAccount?.id)?.bank?.id)?.name}</span></td>
                </g:if>
                <g:else>
                    <td></td>
                </g:else>
            </tr>
            <tr>
                <td class="right label_name">支付方式：</td>
                <td><span class="rigt_tebl_font">${TradeRefund.channelMap[tradeRefundInstance?.channel]}</span></td>
            </tr>
            %{--<tr>--}%
                %{--<td class="right label_name"><g:message code="tradeRefund.backFee.label"/>：</td>--}%
                %{--<td><span class="rigt_tebl_font"><g:formatNumber number="${tradeRefundInstance?.backFee/100}" type="currency" currencyCode="CNY"/></span></td>--}%
            %{--</tr>--}%

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.acquirer_account_id.label"/>：</td>
                <td>
                    ${BoAcquirerAccount.get(tradeRefundInstance.acquirer_account_id)?.comboName}
                </td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="tradeRefund.dateCreated.label"/>：</td>
                <td><span class="rigt_tebl_font"><g:formatDate date="${tradeRefundInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
            </tr>
            <tr>
                <td class="right label_name">退款原因：</td>
                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeRefundInstance, field: "subject")}</span></td>
            </tr>
            <tr>
                <td class="right label_name">申请人：</td>
                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeRefundInstance, field: "submitter")}</span></td>
            </tr>
            <tr>
                <td class="right label_name">初审时间：</td>
                <td><span class="rigt_tebl_font"><g:formatDate date="${tradeRefundInstance?.firstAppDate}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
            </tr>
            <tr>
                <td class="right label_name">初审人：</td>
                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeRefundInstance, field: "firstAppName")}</span></td>
            </tr>
            <tr>
                <td class="right label_name">终审时间：</td>
                <td><span class="rigt_tebl_font"><g:formatDate date="${tradeRefundInstance?.lastAppDate}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
            </tr>
            <tr>
                <td class="right label_name">终审人：</td>
                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeRefundInstance, field: "lastAppName")}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.handleStatus.label"/>：</td>
                <td><span class="rigt_tebl_font">${TradeRefund.handleStatusMap[tradeRefundInstance?.handleStatus]}</span></td>
            </tr>

            <tr>
                <td class="right label_name">处理时间：</td>
                <td><span class="rigt_tebl_font"><g:formatDate date="${tradeRefundInstance?.refundHandleDate}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
            </tr>
            <tr>
                <td class="right label_name">处理人：</td>
                <td><span class="rigt_tebl_font">${tradeRefundInstance?.refundHandleName}</span></td>
            </tr>
            <g:if test="${tradeRefundInstance?.handleStatus=='fRefuse' || tradeRefundInstance?.handleStatus=='sRefuse'}">

                <tr>
                    <td class="right label_name"><g:message code="拒绝原因"/>：</td>

                    <td><span class="rigt_tebl_font">${AppNote.findByAppIdAndAppName(tradeRefundInstance?.id,'tradeRefund')?.appNote}</span></td>

                </tr>

            </g:if>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.note.label"/>：</td>
                <td>${tradeRefundInstance?.note}</td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <g:form>
                        <g:hiddenField name="id" value="${tradeRefundInstance?.id}"/>
                        <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    %{--<span class="button"><g:actionSubmit class="rigt_button" action="fCheck" value="通过"/></span>--}%
                    %{--<span class="button"><g:actionSubmit class="rigt_button" action="unCheck" flag='1' value="拒绝"/></span>--}%
                    </g:form>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>