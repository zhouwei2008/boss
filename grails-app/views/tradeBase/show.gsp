<%@ page import="ismp.TradeBase" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeBase.label', default: 'TradeBase')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>

    <table align="center" class="rigt_tebl">
        <tr>
            <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.id.label"/>：</td>
            <td><span class="rigt_tebl_font">${trade.id}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.rootId.label"/>：</td>
            <td><span class="rigt_tebl_font">
                <g:link action="list" params="[rootId:trade.rootId]">${trade.rootId}</g:link>
            </span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.originalId.label"/>：</td>
            <td><span class="rigt_tebl_font">
                <g:if test="${trade.originalId}">
                    <g:link action="show" params="[id:trade.originalId]">${trade.originalId}</g:link>
                </g:if>
            </span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.tradeNo.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: trade, field: "tradeNo")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.tradeType.label"/>：</td>
            <td><span class="rigt_tebl_font">${TradeBase.tradeTypeMap[trade?.tradeType]}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.partner.label"/>：</td>
            <td><span class="rigt_tebl_font">
                <g:if test="${trade.partner}">
                    <g:link controller="cmCorporationInfo" action="show" id="${trade.partner.id}">${trade.partner.name}</g:link> <br/>
                </g:if>
            </span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.payerName.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: trade, field: "payerName")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.payerCode.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: trade, field: "payerCode")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.payerAccountNo.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: trade, field: "payerAccountNo")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.payeeName.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: trade, field: "payeeName")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.payeeCode.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: trade, field: "payeeCode")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.payeeAccountNo.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: trade, field: "payeeAccountNo")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.outTradeNo.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: trade, field: "outTradeNo")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.orderAmount.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatNumber number="${(trade.amount-(trade.feeAmount==null?0:trade.feeAmount))/100}" type="currency" currencyCode="CNY"/></span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.feeAmount.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatNumber number="${trade.feeAmount/100}" type="currency" currencyCode="CNY"/></span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.amount.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatNumber number="${trade.amount/100}" type="currency" currencyCode="CNY"/></span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.currency.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: trade, field: "currency")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.subject.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: trade, field: "subject")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.status.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:if test="${TradeBase.findByTradeNo(trade?.tradeNo) != null && TradeBase.findByTradeNo(trade?.tradeNo) != '' && TradeBase.findByTradeNo(trade?.tradeNo).status =='closed'}">完成</g:if>
                        <g:else>${TradeBase.statusMap[trade.status]}</g:else></span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.note.label"/>：</td>
            <td><span class="rigt_tebl_font">
                <g:if test="${TradeBase.findByTradeNo(trade?.tradeNo)?.tradeType=='payment' && TradeBase.findByTradeNo(trade?.tradeNo)?.status=='closed'}">
                    ${message(code:'已退款',default:'已退款')}
                </g:if>
                <g:else>
                    ${fieldValue(bean: trade, field: "note")}
                </g:else>
            </span>
            </td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.dateCreated.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatDate date="${trade?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.lastUpdated.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatDate date="${trade?.lastUpdated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="tradeBase.tradeDate.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatNumber number="${trade.tradeDate}" format="########"/></span></td>
        </tr>

        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${trade?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>