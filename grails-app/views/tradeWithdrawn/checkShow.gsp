<%@ page import="account.AcAccount; boss.Perm; boss.BoAcquirerAccount; ismp.TradeWithdrawn" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeWithdrawn.label', default: 'TradeWithdrawn')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
    <link rel="stylesheet" type="text/css" href="../../ext/css/ext-all.css"/>
    <link rel="stylesheet" type="text/css" href="../../ext/css/style.css"/>
    <script type="text/javascript" src="../../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../../ext/js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../../ext/js/common.js"></script>
</head>
<body style="overflow-x:hidden">
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
                <td class="right label_name"><g:message code="tradeWithdrawn.tradeNo.label"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "tradeNo")}</span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.payerName.label"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "payerName")}</span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.payerAccountNo.label"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "payerAccountNo")}</span></td>

            </tr>

            <tr>
                <td class="right label_name">账户余额：</td>
                <td><span class="rigt_tebl_font"><g:formatNumber number="${AcAccount.findByAccountNo(tradeWithdrawnInstance?.payerAccountNo)?.balance/100}" type="currency" currencyCode="CNY"/></span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.amount.label"/>：</td>

                <td><span class="rigt_tebl_font" id="amount" val="${tradeWithdrawnInstance?.amount / 100}"><g:formatNumber number="${tradeWithdrawnInstance?.amount/100}" type="currency" currencyCode="CNY"/></span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.feeAmount.label"/>：</td>

                <td><span class="rigt_tebl_font" id="feeAmount" val="${tradeWithdrawnInstance?.feeAmount / 100}"><g:formatNumber number="${tradeWithdrawnInstance?.feeAmount/100}" type="currency" currencyCode="CNY"/></span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.transferFee.label"/>：</td>
                <td><g:textField name="transferFee" value="${tradeWithdrawnInstance?.transferFee/100}" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" onChange="changeFee()"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.realTransferAmount.label"/>：</td>
                <td><g:textField name="realTransferAmount" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${(tradeWithdrawnInstance?.amount-tradeWithdrawnInstance?.feeAmount-tradeWithdrawnInstance?.transferFee)/ 100}" onChange="changeTransAmount()"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.acquirerAccountId.label"/>：</td>
                <td>
                    <g:select name="acquirerAccountId" from="${BoAcquirerAccount.findAll()}" optionKey="id" optionValue="comboName" value="${tradeWithdrawnInstance?.acquirerAccountId}" noSelection="${['':'--请选择--']}"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name">收款账号省份：</td>
                <td><span class="rigt_tebl_font">${tradeWithdrawnInstance?.accountProvince}</span></td>
            </tr>

            <tr>
                <td class="right label_name">收款账号地市：</td>
                <td><span class="rigt_tebl_font">${tradeWithdrawnInstance?.accountCity}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.customerBankCode.label"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankCode")}</span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.customerBankNo.label"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankNo")}</span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.customerBankAccountNo.label"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankAccountNo")}</span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.customerBankAccountName.label"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankAccountName")}</span></td>

            </tr>


            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.isCorporate.label"/>：</td>

                <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${tradeWithdrawnInstance?.isCorporate}"/></span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.handleStatus.label"/>：</td>

                <td><span class="rigt_tebl_font">${TradeWithdrawn.handleStatusMap[tradeWithdrawnInstance?.handleStatus]}</span></td>

            </tr>


            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.dateCreated.label"/>：</td>

                <td><span class="rigt_tebl_font"><g:formatDate date="${tradeWithdrawnInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>

            </tr>

            <tr>
                <td class="right label_name"><g:message code="tradeWithdrawn.note.label"/>：</td>

                <td><g:textArea name="note" cols="10" rows="10" value="${tradeWithdrawnInstance?.note}"/></td>

            </tr>
            <tr>
                <td colspan="2" align="center">
                    <g:hiddenField name="id" value="${tradeWithdrawnInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <bo:hasPerm perm="${Perm.WithDraw_Wait_ProcPas}">
                        <span class="button"><g:actionSubmit class="rigt_button" action="check" value="通过"/></span>
                    </bo:hasPerm>
                    <bo:hasPerm perm="${Perm.WithDraw_Wait_ProcRef}">
                        <span class="button"><input type="button" class="rigt_button" onclick="return checkReason(${tradeWithdrawnInstance?.id})" value="拒绝"/></span>
                    </bo:hasPerm>
                </td>
            </tr>
        </table>
    </g:form>

</div>
<script type="text/javascript">
    function changeFee() {
        $("#realTransferAmount").val(($("#amount").attr("val") - $("#feeAmount").attr("val") - $("#transferFee").val()).toFixed(2))
    }

    function changeTransAmount() {
        $("#transferFee").val(($("#amount").attr("val") - $("#feeAmount").attr("val") - $("#realTransferAmount").val()).toFixed(2))
    }
    function checkReason(id) {
        var flag = 3;
        if (confirm("您确认要拒绝该待处理提现申请？")) {
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
</body>
</html>