<%@ page import="ismp.RefundAuth; boss.BoMerchant; ismp.TradePayment; boss.BoBankDic; boss.Perm; ismp.TradeBase; boss.BoAcquirerAccount; ismp.TradeRefund" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeRefund.label', default: 'TradeRefund')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<script type="text/javascript">
    var id;
    function appPass(str) {
        document.getElementById("reason").style.display = '';
        id = str;
        return false;
    }
    function checkReason() {
        if (document.getElementById("inputWhy").value == '请输入拒绝原因' || document.getElementById("inputWhy").value == '') {
            alert("请输入拒绝原因!");
            document.getElementById("inputWhy").focus();
            return false;
        } else {
            var reason = document.getElementById("inputWhy").value;
            var note = document.getElementById("note").value;
            window.location.href = '${createLink(controller:'tradeRefund', action:'refused', params:['flag':'1'])}&id=' + id + '&appNote=' + reason + '&note=' + note;
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
                <td class="right label_name">退回持卡人手续费：</td>
                <td><span class="rigt_tebl_font"><g:formatNumber number="${(tradeRefundInstance?.realityRefundAmount-tradeRefundInstance?.amount)/100}" type="currency" currencyCode="CNY"/></span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="银行订单号"/>：</td>
                <td><span class="rigt_tebl_font">${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId, 'charge')?.outTradeNo}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="支付银行"/>：</td>
                <g:if test="${tradeRefundInstance.acquirerMerchantNo!=null}"><td>${BoBankDic.get(BoAcquirerAccount.get(BoMerchant.findByAcquireMerchant(tradeRefundInstance.acquirerMerchantNo)?.acquirerAccount?.id)?.bank?.id)?.name}</td></g:if>
                <g:else><td></td></g:else>

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
                    <td><span class="rigt_tebl_font">${RefundAuth.findByOutTradeNoAndType(TradeBase.get(tradeRefundInstance.originalId)?.outTradeNo, 'completed')?.refundAccName}</span></td>
                </tr>
                <tr>
                    <td class="right label_name"><g:message code="企业账户号"/>：</td>
                    <td><span class="rigt_tebl_font">${RefundAuth.findByOutTradeNoAndType(TradeBase.get(tradeRefundInstance.originalId)?.outTradeNo, 'completed')?.refundAccNo}</span></td>
                </tr>
                <tr>
                    <td class="right label_name"><g:message code="开户行名称"/>：</td>
                    <td><span class="rigt_tebl_font">${RefundAuth.findByOutTradeNoAndType(TradeBase.get(tradeRefundInstance.originalId)?.outTradeNo, 'completed')?.bankName}</span></td>
                </tr>
            </g:if>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.acquirer_account_id.label"/>：</td>
                <td>
                    <g:select name="acquirer_account_id" from="${BoAcquirerAccount.findAll()}" optionKey="id" optionValue="comboName" value="${tradeRefundInstance?.acquirer_account_id}"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeRefund.dateCreated.label"/>：</td>

                <td><span class="rigt_tebl_font"><g:formatDate date="${tradeRefundInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
            </tr>

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

                <td><g:textArea name="note" value="${tradeRefundInstance?.note}"></g:textArea></td>

            </tr>
            <tr id="reason" style="display:none">
                <td class="right label_name"><font color="red"><g:message code="拒绝原因"/>：</font></td>
                <td>
                    <input type="text" name="inputWhy" size="200" style="width:400px" id="inputWhy" onfocus="value = ''" value="请输入拒绝原因"/>
                    <input type="button" name="button" value="确定" onclick="checkReason()"/>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <g:form>
                        <g:hiddenField name="id" value="${tradeRefundInstance?.id}"/>
                        <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                        <bo:hasPerm perm="${Perm.Trade_RfdWait_ProcPas}">
                            <span class="button"><g:actionSubmit class="rigt_button" action="fCheck" value="通过"/></span>
                        %{--<span class="button"><g:actionSubmit class="rigt_button" action="refused" flag='1' value="拒绝"/></span>--}%
                        </bo:hasPerm>
                        <bo:hasPerm perm="${Perm.Trade_RfdWait_ProcRef}">
                            %{--<g:if test="${TradeBase.findByOriginalIdAndTradeType(tradeRefundInstance.originalId,'royalty')!=null }">--}%
                                <span class="button"><input type="button" class="rigt_button" onclick="return appPass(${tradeRefundInstance?.id})" value="拒绝"/></span>
                            %{--</g:if>--}%
                        </bo:hasPerm>
                    </g:form>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>