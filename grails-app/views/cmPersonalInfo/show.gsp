<%@ page import="boss.Perm; ismp.CmCustomerOperator; ismp.CmPersonalInfo; ismp.CmCustomer" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cmPersonalInfo.label', default: 'CmPersonalInfo')}"/>
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
            <td class="right label_name"><g:message code="cmPersonalInfo.customerNo.label"/>：</td>
            <td><span class="rigt_tebl_font">${cmPersonalInfoInstance?.customerNo}</span></td>
        </tr>

        <tr>
            <td class="right label_name">登陆邮箱：</td>
            <td><span class="rigt_tebl_font">${CmCustomerOperator.findByCustomer(cmPersonalInfoInstance)?.defaultEmail}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmPersonalInfo.name.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: cmPersonalInfoInstance, field: "name")}</span></td>
        </tr>

        <tr>
            <td class="right label_name">国籍：</td>
            <td><span class="rigt_tebl_font">${CmPersonalInfo.nationalityMap[cmPersonalInfoInstance.nationality]}</span></td>
        </tr>

        <tr>
            <td class="right label_name">性别：</td>
            <td><span class="rigt_tebl_font">${CmPersonalInfo.genderMap[cmPersonalInfoInstance.gender]}</span></td>
        </tr>

        <tr>
            <td class="right label_name">职业：</td>
            <td><span class="rigt_tebl_font">${CmPersonalInfo.occupationMap[cmPersonalInfoInstance.occupation]}</span></td>
        </tr>

        <tr>
            <td class="right label_name">住址：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: cmPersonalInfoInstance, field: "address")}</span></td>
        </tr>

        <tr>
            <td class="right label_name">联系方式：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: cmPersonalInfoInstance, field: "contactWay")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmPersonalInfo.identityType.label"/>：</td>
            <td><span class="rigt_tebl_font">${CmPersonalInfo.identityTypeMap[cmPersonalInfoInstance.identityType]}</span></td>
        </tr>
        <tr>
            <td class="right label_name"><g:message code="cmPersonalInfo.identityNo.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: cmPersonalInfoInstance, field: "identityNo")}</span></td>
        </tr>
        <tr>
            <td class="right label_name">证件有效期：</td>
            <td><span class="rigt_tebl_font"><g:formatDate date="${cmPersonalInfoInstance?.validTime}" format="yyyy-MM-dd"/></span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmPersonalInfo.status.label"/>：</td>
            <td><span class="rigt_tebl_font">${CmCustomer.statusMap[cmPersonalInfoInstance?.status]}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmPersonalInfo.accountNo.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: cmPersonalInfoInstance, field: "accountNo")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmPersonalInfo.type.label"/>：</td>
            <td><span class="rigt_tebl_font">${CmCustomer.typeMap[cmPersonalInfoInstance?.type]}</span></td>
        </tr>

        <tr>
            <td class="right label_name">账户风险等级：</td>
            <td><span class="rigt_tebl_font">${CmPersonalInfo.gradeMap[cmPersonalInfoInstance.grade]}</span></td>
        </tr>

        <tr>
            <td class="right label_name">单笔限额：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: cmPersonalInfoInstance, field: "limitPerTrx")}</span></td>
        </tr>

        <tr>
            <td class="right label_name">单日累计限额：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: cmPersonalInfoInstance, field: "totalAmountlimitPerDay")}</span></td>
        </tr>

        <tr>
            <td class="right label_name">单日累计笔数：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: cmPersonalInfoInstance, field: "trxsCountNumPerDay")}</span></td>
        </tr>

        <tr>
            <td class="right label_name">单月累计限额：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: cmPersonalInfoInstance, field: "totalAmountLimitPermonth")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmPersonalInfo.needInvoice.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${cmPersonalInfoInstance?.needInvoice}"/></span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="cmPersonalInfo.dateCreated.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatDate date="${cmPersonalInfoInstance?.dateCreated}" format="yyyy-MM-dd"/></span></td>
        </tr>

        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${cmPersonalInfoInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <g:if test="${cmPersonalInfoInstance?.status!='deleted'}">
                        <g:if test="${flag!=1}">
                            <span class="button">
                                <bo:hasPerm perm="${Perm.Cust_Per_Edit}">
                                <g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/>
                                </bo:hasPerm>
                            </span>
                        </g:if>
                    </g:if>
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>