<%@ page import="boss.Perm; boss.BoNews" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boNews.label', default: 'BoNews')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <style>
    /*字符串截取*/
    .aa {
        width: 300px;
        height: 24px;
        line-height: 24px;
        overflow: hidden;
        margin: 0px;
        color: #666;
        text-align:center;
        display: block;
        padding-right: 0px;
    }
    </style>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form>
                栏目:<g:select name="msgColumn" from="${BoNews.columnLs}" value="${params.msgColumn}"/>
                <g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询"/>
                <bo:hasPerm perm="${Perm.News_Manage_New}"><g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/></bo:hasPerm>
            </g:form>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="id" title="ID"/>

                <g:sortableColumn params="${params}" property="msgColumn" title="${message(code: 'boNews.msgColumn.label', default: 'Msg Column')}"/>

                <g:sortableColumn params="${params}" property="content" title="${message(code: 'boNews.content.label', default: 'Content')}"/>

                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'boNews.dateCreated.label', default: 'Date Created')}"/>

                <g:sortableColumn params="${params}" property="publisher" title="${message(code: 'boNews.publisher.label', default: 'publisher')}"/>

            </tr>

            <g:each in="${boNewsInstanceList}" status="i" var="boNewsInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:if test="${bo.hasPerm(perm:Perm.News_Manage_View){true}}"><g:link action="show" id="${boNewsInstance.id}">${fieldValue(bean: boNewsInstance, field: "id")}</g:link></g:if><g:else>${fieldValue(bean: boNewsInstance, field: "id")}</g:else></td>

                    <td>${fieldValue(bean: boNewsInstance, field: "msgColumn")}</td>

                    <td class="center_tebl_font" style="width:300px"><a href="#" title="${boNewsInstance?.content}" class="aa">${fieldValue(bean: boNewsInstance, field: "content")}</a></td>

                    <td><g:formatDate date="${boNewsInstance.dateCreated}" format="yyyy-MM-dd HH:mm"/></td>

                    <td>${boNewsInstance.publisher.name}</td>

                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${boNewsInstanceTotal}条记录</span>
            <g:paginat total="${boNewsInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
