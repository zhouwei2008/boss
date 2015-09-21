<%@ page import="boss.Perm; ismp.AcquireSynTrx" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'acquireAccountTrade.remarks.label', default: 'remarks')}"/>
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
            <td class="right label_name"><g:message code="acquireAccountTrade.remarks.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: acquireSynTrxInstance, field: "remarks")}</span></td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${acquireSynTrxInstance?.id}"/>
                    <g:hiddenField name="synSts"  value="${params.synSts}" />
                    <g:hiddenField name="batchnum"  value="${params.batchnum}" />
                    <g:hiddenField name="offset"  value="${params.offset}" />
                    <g:hiddenField name="max"  value="${params.max}" />
                    <g:hiddenField name="fbankCode"  value="${params.fbankCode}" />
                    <g:hiddenField name="foffset"  value="${params.foffset}" />
                    <g:hiddenField name="fmax"  value="${params.fmax}" />
                    <g:hiddenField name="fbeginTime"  value="${params.fbeginTime}" />
                    <g:hiddenField name="fendTime"  value="${params.fendTime}" />
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <bo:hasPerm perm="${Perm.Gworder_AccountTrade_Detail_Remarks_Edit}" ><span class="button"><g:actionSubmit class="rigt_button" action="editRemarks"
                                                         value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span></bo:hasPerm>
                    <bo:hasPerm perm="${Perm.Gworder_AccountTrade_Detail_Remarks_Del}" ><span class="button"><g:actionSubmit class="rigt_button" action="deleteRemarks"
                                                         value="${message(code: 'default.button.delete.label', default: 'Delete')}"
                                                         onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span></bo:hasPerm>
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>