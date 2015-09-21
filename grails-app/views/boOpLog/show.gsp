<%@ page import="boss.BoOpRelation; boss.BoOpLog" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boOpLog.label', default: 'BoOpLog')}"/>
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
            <td class="right label_name"><g:message code="boOpLog.account.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: boOpLogInstance, field: "account")}</span></td>
        </tr>
        <tr>
            <td class="right label_name"><g:message code="boOpLog.opRelation.names.label"/>：</td>
            <td><span class="rigt_tebl_font">${BoOpRelation.findByActionsAndControllers(boOpLogInstance.action,boOpLogInstance.controller)?.names}</span></td>
        </tr>
        <tr>
            <td class="right label_name"><g:message code="boOpLog.params.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: boOpLogInstance, field: "params")}</span></td>
        </tr>
        <tr>
            <td class="right label_name"><g:message code="boOpLog.ip.label"/>：</td>
            <td><span class="rigt_tebl_font">${fieldValue(bean: boOpLogInstance, field: "ip")}</span></td>
        </tr>
        <tr>
            <td class="right label_name"><g:message code="boOpLog.dateCreated.label"/>：</td>
            <td><span class="rigt_tebl_font"><g:formatDate date="${boOpLogInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
        </tr>


        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${boOpLogInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                 </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>