
<%@ page import="gateway.GwTransaction" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'gwTransaction.label', default: 'GwTransaction')}"/>
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
            <td class="right label_name"><g:message code="gwTransaction.id.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "id")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.order.label"/>：</td>

            <td><span class="rigt_tebl_font">
                <g:if test="${gwTransactionInstance.order}">
                    <g:link controller="gwOrder" action="show" id="${gwTransactionInstance.order.id}">${gwTransactionInstance.order.id}</g:link>
                </span></g:if>
            </td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.acquirerCode.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "acquirerCode")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.acquirerDate.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "acquirerDate")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.acquirerInnerAccountName.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "acquirerInnerAccountName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.acquirerInnerAccountNo.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "acquirerInnerAccountNo")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.acquirerMerchant.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "acquirerMerchant")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.acquirerMsg.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "acquirerMsg")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.acquirerName.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "acquirerName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.acquirerSeq.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "acquirerSeq")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.amount.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatNumber number="${gwTransactionInstance.amount/100}" type="currency" currencyCode="CNY"/></span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.authNo.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "authNo")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.bankTransNo.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "bankTransNo")}</span></td>

        </tr>
        <tr>
            <td class="right label_name"><g:message code="gwTransaction.buyerCode.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "buyerCode")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.buyerCustomerNo.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "buyerCustomerNo")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.cardType.label"/>：</td>

            <td><span class="rigt_tebl_font">${GwTransaction.cardTypeMap[gwTransactionInstance.cardType]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.channel.label"/>：</td>

            <td><span class="rigt_tebl_font">${GwTransaction.channelMap[gwTransactionInstance.channel]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.completionTime.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatDate date="${gwTransactionInstance?.completionTime}" format="yyyy-MM-dd HH:mm:ss"/></span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.currency.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "currency")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.dateCreated.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatDate date="${gwTransactionInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.gwServiceCode.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "gwServiceCode")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.handleOperName.label"/>/财务联系人：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "handleOperName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.handleTime.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatDate date="${gwTransactionInstance?.handleTime}" format="yyyy-MM-dd HH:mm:ss"/></span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.note.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "note")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.payinfo.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "payinfo")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.paymentType.label"/>：</td>

            <td><span class="rigt_tebl_font">${GwTransaction.paymentTypeMap[gwTransactionInstance.paymentType]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.referenceNo.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "referenceNo")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.returnIp.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "returnIp")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.status.label"/>：</td>

            <td><span class="rigt_tebl_font">${GwTransaction.statusMap[gwTransactionInstance.status]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.submitTime.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: gwTransactionInstance, field: "submitTime")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="gwTransaction.transType.label"/>：</td>

            <td><span class="rigt_tebl_font">${GwTransaction.transTypeMap[gwTransactionInstance.transType]}</span></td>

        </tr>

        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${gwTransactionInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>