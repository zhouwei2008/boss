<%@ page import="boss.Perm; boss.BoNews" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boNews.label', default: 'BoNews')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
    <style>
    /*字符串截取*/
    .aa {
        width: 200px;
        height: 24px;
        line-height: 24px;
        overflow: hidden;
        margin: 0px;
        color: #666;
        display: block;
        padding-right: 0px;
    }
    </style>
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
            <td class="right label_name"><g:message code="boNews.msgColumn.label"/>：</td>

            <td><span class="rigt_tebl_font">${fieldValue(bean: boNewsInstance, field: "msgColumn")}</span></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boNews.content.label"/>：</td>

            <td><a href="#" title="${boNewsInstance?.content}" class="aa">${fieldValue(bean: boNewsInstance, field: "content")}</a></td>

        </tr>

        <tr>
            <td class="right label_name"><g:message code="boNews.dateCreated.label"/>：</td>

            <td><span class="rigt_tebl_font"><g:formatDate date="${boNewsInstance?.dateCreated}"/></span></td>

        </tr>

        <tr>
            <td class="right label_name" nowrap><g:message code="boNews.publisher.label"/>：</td>

            <td><span class="rigt_tebl_font">${boNewsInstance?.publisher?.name}</span></td>

        </tr>

        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${boNewsInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <bo:hasPerm perm="${Perm.News_Manage_Edit}"><span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span></bo:hasPerm>
                    <bo:hasPerm perm="${Perm.News_Manage_Del}"><span class="button"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span></bo:hasPerm>
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>