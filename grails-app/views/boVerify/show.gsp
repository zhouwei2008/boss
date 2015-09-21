<%@ page import="boss.AppNote; boss.BoVerify" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boVerify.label', default: 'BoVerify')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>

    <table align="center" class="rigt_tebl">
        <tr>
            <th colspan="2"><g:message code="查看明细" args="[entityName]"/></th>
        </tr>


        <tr>
            <td class="right label_name"><g:message code="创建日期"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatDate date="${boVerifyInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="类型"/>：</td>

            <td><span class="rigt_tebl_font">${BoVerify.typeMap[boVerifyInstance.type]}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="状态"/>：</td>

            <td><span class="rigt_tebl_font">${BoVerify.statusMap[boVerifyInstance.status]}</span></td>

        </tr>
        <g:if test="${boVerifyInstance.status=='2'}">
            <tr>
                <td class="right label_name"><g:message code="拒绝原因"/>：</td>
                <td><span class="rigt_tebl_font">${AppNote.findByAppIdAndAppName(boVerifyInstance?.id, 'boVerify')?.appNote}</span></td>
            </tr>
        </g:if>

        <tr>
            <td class="right label_name"><g:message code="转出银行"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boVerifyInstance, field: "outBankName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="转出银行帐户号"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boVerifyInstance, field: "outBankAccountNo")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="转出银行帐户名称"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boVerifyInstance, field: "outBankAccountName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="转出银行余额"/>：</td>

            <td><span class="rigt_tebl_font">
                <g:set var="amt" value="${boVerifyInstance.outRemainAmount ? boVerifyInstance.outRemainAmount : 0}"/>
                <g:formatNumber number="${amt/100}" type="currency" currencyCode="CNY"/>
            </span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="金额"/>：</td>

            <td><span class="rigt_tebl_font">

                <g:set var="amt" value="${boVerifyInstance.outAmount ? boVerifyInstance.outAmount : 0}"/>
                <g:formatNumber number="${amt/100}" type="currency" currencyCode="CNY"/>
            </span>
            </td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="转入银行"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boVerifyInstance, field: "inBankName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="转入银行帐户号"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boVerifyInstance, field: "inBankAccountNo")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="转入银行帐户名称"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boVerifyInstance, field: "inBankAccountName")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="转入银行余额"/>：</td>

            <td><span class="rigt_tebl_font">
                <g:set var="amt" value="${boVerifyInstance.inRemainAmount ? boVerifyInstance.inRemainAmount : 0}"/>
                <g:formatNumber number="${amt/100}" type="currency" currencyCode="CNY"/>
            </span></td>

        </tr>

         <tr>
            <td class="right label_name"><g:message code="备注"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boVerifyInstance, field: "note")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="操作员"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boVerifyInstance, field: "operName")}</span></td>

        </tr>

        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${boVerifyInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                %{--<span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>--}%
                %{--<span class="button"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>--}%
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>