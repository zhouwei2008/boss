<%@ page import="boss.Perm; settle.FtSrvTradeType" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftSrvTradeType.label', default: 'FtSrvTradeType')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>

    <table align="center" class="rigt_tebl">
        <tr>
            <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="ftSrvTradeType.tradeCode.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: ftSrvTradeTypeInstance, field: "tradeCode")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="ftSrvTradeType.tradeName.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: ftSrvTradeTypeInstance, field: "tradeName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="ftSrvTradeType.netWeight.label"/>：</td>

            <td><span class="rigt_tebl_font">${FtSrvTradeType.netWeightMap[ftSrvTradeTypeInstance?.netWeight.toString()]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="ftSrvTradeType.srv.label"/>：</td>

            <td><span class="rigt_tebl_font">${ftSrvTradeTypeInstance?.srv?.srvName}</span></td>

        </tr>

        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${ftSrvTradeTypeInstance?.id}"/>
                      <span class="button"><g:actionSubmit class="rigt_button" action="list" value="返回"/></span>
<!--                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>-->
                    <bo:hasPerm perm="${Perm.Settle_TradeType_Edit}" ><span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span></bo:hasPerm>
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>