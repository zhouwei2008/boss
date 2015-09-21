<%@ page import="boss.BoNews" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boNews.label', default: 'BoNews')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<script type="text/javascript">
    function checkLen() {
        var val = document.getElementById("content").value;
        if (val.length > 150) {
            val = val.substr(0, 150);
            document.getElementById("content").value = val;
        }
    }

</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${boNewsInstance}">
        <div class="errors">
            <g:renderErrors bean="${boNewsInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="update">
        <g:hiddenField name="id" value="${boNewsInstance?.id}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boNews.msgColumn.label"/>：</td>
                <td class="${hasErrors(bean: boNewsInstance, field: 'msgColumn', 'errors')}">
                    <g:select name="msgColumn" from="${BoNews.columnLs}"/>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boNews.content.label"/>：</td>
                <td class="${hasErrors(bean: boNewsInstance, field: 'content', 'errors')}">
                    <g:textArea name="content" onblur="checkLen();">${boNewsInstance?.content}</g:textArea>
                </td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定"></span>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>
