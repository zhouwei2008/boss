<%@ page import="gateway.GwTransaction" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="title" value="更改网关支付(${gwTrans.id})的状态到成功"/>
    <title>${title}</title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <g:hasErrors bean="${gwTrans}">
        <div class="errors">
            <g:renderErrors bean="${gwTrans}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form>
        <g:hiddenField name="id" value="${gwTrans?.id}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2">${title}</th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="gwTransaction.acquirerName.label"/>：</td>
                <td class="rigt_tebl_font">${gwTrans?.acquirerName}</td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="gwTransaction.acquirerMerchant.label"/>：</td>
                <td class="rigt_tebl_font">${gwTrans?.acquirerMerchant}</td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="gwTransaction.bankTransNo.label"/>：</td>
                <td class="rigt_tebl_font">${gwTrans?.bankTransNo}</td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="gwTransaction.buyerCode.label"/>：</td>
                <td class="rigt_tebl_font">${gwTrans?.buyerCode}</td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="gwTransaction.amount.label"/>：</td>
                <td class="rigt_tebl_font">
                    <g:formatNumber number="${gwTrans.amount/100}" type="currency" currencyCode="CNY"/>
                </td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="gwTransaction.status.label"/>：</td>
                <td class="rigt_tebl_font">${gwTrans?.status}</td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="gwTransaction.acquirerSeq.label"/>：</td>
                <td><g:textField name="acquirerSeq" value="${gwTrans?.acquirerSeq}" /><font style="color:red">（为保证退款成功，请务必填写并保证正确!）</font></td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="gwTransaction.referenceNo.label"/>：</td>
                <td><g:textField name="referenceNo" value="${gwTrans?.referenceNo}" /></td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="gwTransaction.authNo.label"/>：</td>
                <td><g:textField name="authNo" value="${gwTrans?.authNo}" /></td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="button">
                        <g:actionSubmit class="rigt_button" action="toFinished" value="更改成成功" onclick="return confirm('你确定将这笔支付(${gwTrans.id})改成成功？')"/>
                    </span>
                </td>
            </tr>
        </table>
    </g:form>
</div>
</body>
</html>
