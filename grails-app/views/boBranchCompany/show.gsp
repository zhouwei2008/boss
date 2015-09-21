<%@ page import="boss.Perm; boss.BoBranchCompany" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boBranchCompany.label', default: 'BoBranchCompany')}"/>
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

	%{--<tr>--}%
            %{--<td class="right label_name"><g:message code="boBranchCompany.companyNo.label"/>：</td>--}%
            %{--<td><span class="rigt_tebl_font">${fieldValue(bean: boBranchCompanyInstance, field: "companyNo")}</span></td>--}%
        %{--</tr>--}%
        <tr>
            <td class="right label_name"><g:message code="boBranchCompany.companyName.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: boBranchCompanyInstance, field: "companyName")}</span></td>
        </tr>
        <tr>
            <td class="right label_name"><g:message code="boBranchCompany.chargeMan.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: boBranchCompanyInstance, field: "chargeMan")}</span></td>
        </tr>
        <tr>
            <td class="right label_name"><g:message code="boBranchCompany.phone.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: boBranchCompanyInstance, field: "phone")}</span></td>
        </tr>
        <tr>
            <td class="right label_name"><g:message code="boBranchCompany.fax.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: boBranchCompanyInstance, field: "fax")}</span></td>
        </tr>
        <tr>
            <td class="right label_name"><g:message code="boBranchCompany.address.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: boBranchCompanyInstance, field: "address")}</span></td>
        </tr>
        <tr>
            <td class="right label_name"><g:message code="boBranchCompany.dateCreated.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatDate date="${boBranchCompanyInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
        </tr>

        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${boBranchCompanyInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <bo:hasPerm perm="${Perm.Security_BranchCompany_Edit}" ><span class="button"><g:actionSubmit class="rigt_button" action="edit"
                                                         value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span></bo:hasPerm>
                    <bo:hasPerm perm="${Perm.Security_BranchCompany_Del}" ><span class="button"><g:actionSubmit class="rigt_button" action="delete"
                                                         value="${message(code: 'default.button.delete.label', default: 'Delete')}"
                                                         onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span></bo:hasPerm>
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>