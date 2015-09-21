<%@ page import="boss.BoPromission" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boPromission.label', default: 'BoPromission')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
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
            %{--<g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/>--}%
            </g:form>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="id" title="${message(code: 'boPromission.id.label', default: 'Id')}"/>

                <g:sortableColumn params="${params}" property="promissionCode" title="${message(code: 'boPromission.promissionCode.label', default: 'Promission Code')}"/>

                <g:sortableColumn params="${params}" property="promissionName" title="${message(code: 'boPromission.promissionName.label', default: 'Promission Name')}"/>

                <g:sortableColumn params="${params}" property="status" title="${message(code: 'boPromission.status.label', default: 'Status')}"/>

            </tr>

            <g:each in="${boPromissionInstanceList}" status="i" var="boPromissionInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td>${fieldValue(bean: boPromissionInstance, field: "id")}</td>

                    <td>${fieldValue(bean: boPromissionInstance, field: "promissionCode")}</td>

                    <td>${fieldValue(bean: boPromissionInstance, field: "promissionName")}</td>

                    <td>${BoPromission.statusMap[boPromissionInstance?.status]}</td>

                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${boPromissionInstanceTotal}条记录</span>
            <g:paginat total="${boPromissionInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
