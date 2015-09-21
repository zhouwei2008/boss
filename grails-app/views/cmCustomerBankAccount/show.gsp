<%@ page import="boss.DesUtil; ismp.CmCorporationInfo; boss.Perm; boss.BoBankDic; ismp.CmCustomerBankAccount" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cmCustomerBankAccount.label', default: 'CmCustomerBankAccount')}"/>
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
            <td class="right label_name"><g:message code="cmCustomerBankAccount.customer.label"/>：</td>

            <td><span class="rigt_tebl_font">${cmCustomerBankAccountInstance?.customer?.name}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmCustomerBankAccount.bankName.label"/>：</td>

            <td><span class="rigt_tebl_font">${BoBankDic.findByCode(cmCustomerBankAccountInstance?.bankCode)?.name}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmCustomerBankAccount.branch.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerBankAccountInstance, field: "branch")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmCustomerBankAccount.subbranch.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerBankAccountInstance, field: "subbranch")}</span></td>

        </tr>

        <%--tr>
          <td class="right label_name">地区：</td>

          <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerBankAccountInstance, field: "region")}/${fieldValue(bean: cmCustomerBankAccountInstance, field: "city")}</span></td>

        </tr--%>
        <tr>
            <td class="right label_name">所在省份：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerBankAccountInstance, field: "accountProvince")}</span></td>
        </tr>
        <tr>
            <td class="right label_name">所在地区：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerBankAccountInstance, field: "accountCity")}</span></td>
        </tr>
        <tr>
            <td class="right label_name"><g:message code="cmCustomerBankAccount.bankNo.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerBankAccountInstance, field: "bankNo")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmCustomerBankAccount.bankAccountNo.label"/>：</td>

            <td><span class="rigt_tebl_font">${DesUtil.decrypt(cmCustomerBankAccountInstance.bankAccountNo,cmCustomerBankAccountInstance.customer.customerNo)}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmCustomerBankAccount.bankAccountName.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerBankAccountInstance, field: "bankAccountName")}</span></td>

        </tr>

        %{--<tr>--}%
        %{--<td class="right label_name"><g:message code="cmCustomerBankAccount.status.label"/>：</td>--}%

        %{--<td><span class="rigt_tebl_font">${CmCustomerBankAccount.statusMap[cmCustomerBankAccountInstance?.status]}</span></td>--}%

        %{--</tr>--}%

        <tr>
            <td class="right label_name"><g:message code="cmCustomerBankAccount.note.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: cmCustomerBankAccountInstance, field: "note")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmCustomerBankAccount.isCorporate.label"/>：</td>

            <td><span class="rigt_tebl_font">
                <g:if test="${cmCustomerBankAccountInstance?.isCorporate}">企业</g:if>
                <g:else>个人</g:else>
                %{--<g:formatBoolean boolean="${cmCustomerBankAccountInstance?.isCorporate}"/>--}%
                %{--${CmCustomerBankAccount.isCorporateMap[cmCustomerBankAccountInstance?.isCorporate]}--}%
            </span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmCustomerBankAccount.isDefault.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${cmCustomerBankAccountInstance?.isDefault}"/></span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmCustomerBankAccount.isVerify.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${cmCustomerBankAccountInstance?.isVerify}"/></span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmCustomerBankAccount.status.label"/>：</td>

            <td><span class="rigt_tebl_font">${CmCustomerBankAccount.statusMap[cmCustomerBankAccountInstance?.status]}</span></td>

        </tr>

        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${cmCustomerBankAccountInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <g:if test="${cmCustomerBankAccountInstance?.status!='deleted'}">
                        <g:if test="${cmCustomerBankAccountInstance?.customer instanceof CmCorporationInfo}">
                            <bo:hasPerm perm="${Perm.Cust_Corp_Bank_Edit}"><span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span></bo:hasPerm>
                        </g:if>
                        <g:else>
                            <bo:hasPerm perm="${Perm.Cust_Per_Bank_Edit}"><span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span></bo:hasPerm>
                        </g:else>
                    </g:if>
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>