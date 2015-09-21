<%@ page import="boss.Perm; ismp.NotifyFailWatcher" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="通知名单"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/>设置</h1>
        <h2>
            <g:form>
                <bo:hasPerm perm="${Perm.InterruptOrder_Watcher_AddUser}">
                    <g:actionSubmit class="right_top_h2_button_tj" action="create" value="添加通知人"/>
                </bo:hasPerm>
            </g:form>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="name" title="通知人"/>

                <g:sortableColumn params="${params}" property="mobile" title="通知手机"/>

                <g:sortableColumn params="${params}" property="email" title="通知邮箱"/>

            </tr>

            <g:each in="${notifyFailWatcherInstanceList}" status="i" var="notifyFailWatcherInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.InterruptOrder_Watcher_View){true}}">
                            <g:link action="show" id="${notifyFailWatcherInstance.id}">${fieldValue(bean: notifyFailWatcherInstance, field: "name")}</g:link>
                        </g:if>
                        <g:else>
                            ${fieldValue(bean: notifyFailWatcherInstance, field: "name")}
                        </g:else>
                    </td>

                    <td>${fieldValue(bean: notifyFailWatcherInstance, field: "mobile")}</td>

                    <td>${fieldValue(bean: notifyFailWatcherInstance, field: "email")}</td>

                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <g:paginate total="${notifyFailWatcherInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
