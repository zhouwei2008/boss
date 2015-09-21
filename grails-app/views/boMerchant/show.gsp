<%@ page import="boss.Perm; boss.BoMerchant" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boMerchant.label', default: 'BoMerchant')}"/>
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
            <td class="right label_name"><g:message code="boMerchant.acquireIndexc.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boMerchantInstance, field: "acquireIndexc")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.acquireMerchant.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boMerchantInstance, field: "acquireMerchant")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.terminal.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boMerchantInstance, field: "terminal")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.acquireName.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boMerchantInstance, field: "acquireName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.serviceCode.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boMerchantInstance, field: "serviceCode")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.channelType.label"/>：</td>

            <td><span class="rigt_tebl_font">${BoMerchant.channelTypeMap[boMerchantInstance?.channelType]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.bankType.label"/>：</td>

            <td><span class="rigt_tebl_font">${BoMerchant.bankTypeMap[boMerchantInstance?.bankType]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.paymentType.label"/>：</td>

            <td><span class="rigt_tebl_font">${BoMerchant.paymentTypeMap[boMerchantInstance?.paymentType]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.paymentMode.label"/>：</td>

            <td><span class="rigt_tebl_font">${BoMerchant.paymentModeMap[boMerchantInstance?.paymentMode]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.channelSts.label"/>：</td>

            <td><span class="rigt_tebl_font">${BoMerchant.statusMap[boMerchantInstance?.channelSts]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.channelDesc.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boMerchantInstance, field: "channelDesc")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.dayQutor.label"/>：</td>
            <g:if test="${boMerchantInstance?.dayQutor!=null}">
                <td>
                    <span class="rigt_tebl_font"><g:formatNumber number="${boMerchantInstance?.dayQutor/100}" type="currency" currencyCode="CNY"/></span>
                </td>
            </g:if>
            <g:else>
                <td>￥0.00</td>
            </g:else>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.qutor.label"/>：</td>
            <g:if test="${boMerchantInstance?.qutor!=null}">
                <td>
                    <span class="rigt_tebl_font"><g:formatNumber number="${boMerchantInstance?.qutor/100}" type="currency" currencyCode="CNY"/></span>
                </td>
            </g:if>
            <g:else>
                <td>￥0.00</td>
            </g:else>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.acquirerAccount.label"/>：</td>

            <td><span class="rigt_tebl_font">${boMerchantInstance?.acquirerAccount?.bankAccountName}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.dateCreated.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatDate date="${boMerchantInstance?.dateCreated}" format="yyyy-MM-dd"/></span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boMerchant.lastUpdated.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatDate date="${boMerchantInstance?.lastUpdated}" format="yyyy-MM-dd"/></span></td>

        </tr>

        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${boMerchantInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="button"><bo:hasPerm perm="${Perm.Bank_Issu_Merc_Edit}"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></bo:hasPerm></span>
                    %{--<span class="button"><bo:hasPerm perm="${Perm.Bank_Issu_Merc_Delete}"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></bo:hasPerm></span>--}%
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>