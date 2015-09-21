<%@ page import="boss.Perm; boss.BoOperator; boss.BoBranchCompany" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boOperator.label', default: 'BoOperator')}"/>
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
            <td class="right label_name"><g:message code="boOperator.account.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: boOperatorInstance, field: "account")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="boOperator.name.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: boOperatorInstance, field: "name")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="boOperator.email.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: boOperatorInstance, field: "email")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="boOperator.mobile.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: boOperatorInstance, field: "mobile")}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="boOperator.status.label"/>：</td>
            <td><span class="rigt_tebl_font">${BoOperator.statusMap[boOperatorInstance?.status]}</span></td>
        </tr>

        <tr>
            <td class="right label_name"><g:message code="boOperator.role.label"/>：</td>
            <td><span class="rigt_tebl_font">${boOperatorInstance?.role?.roleName}</span></td>
        </tr>

	   <tr>
            <td class="right label_name"><g:message code="boOperator.branchCompany.label"/>：</td>
            <td><span class="rigt_tebl_font">
                <g:if test="${boOperatorInstance?.branchCompany==~/[0-9]+/}">
                    ${boOperatorInstance?.branchCompany?BoBranchCompany.get(boOperatorInstance?.branchCompany)?.companyName:''}
                    </g:if>
                <g:else>
                      ${boOperatorInstance?.branchCompany}
                </g:else>
            </span></td>
        </tr>

         %{--<tr>--}%
            %{--<td class="right label_name"><g:message code="boOperator.belongToSale.label"/>：</td>--}%
            %{--<td><span class="rigt_tebl_font">${boOperatorInstance?.belongToSale}</span></td>--}%
        %{--</tr>--}%

        <tr>
            <td class="right label_name"><g:message code="boOperator.dateCreated.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatDate date="${boOperatorInstance?.dateCreated}" format="yyyy-MM-dd"/></span></td>
        </tr>


        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${boOperatorInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                        <g:if test="${boOperatorInstance.account!='admin'}">
                            <bo:hasPerm perm="${Perm.Security_Op_Edit}" ><span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span></bo:hasPerm>
                            <bo:hasPerm perm="${Perm.Security_Op_Del}" ><span class="button"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span></bo:hasPerm>
                        </g:if>
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>