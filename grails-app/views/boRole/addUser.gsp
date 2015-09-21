<%@ page import="boss.BoRole" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boRole.label', default: 'BoRole')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <g:sortableColumn params="${params}" property="id" title="${message(code: 'boRole.id.label', default: 'Id')}"/>

                <g:sortableColumn params="${params}" property="roleCode" title="${message(code: 'boRole.roleCode.label', default: 'Role Code')}"/>

                <g:sortableColumn params="${params}" property="roleName" title="${message(code: 'boRole.roleName.label', default: 'Role Name')}"/>

                <g:sortableColumn params="${params}" property="status" title="${message(code: 'boRole.status.label', default: 'Status')}"/>

                <th>操作</th>
            </tr>

            <g:each in="${boRoleInstanceList}" status="i" var="boRoleInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${boRoleInstance.id}">${fieldValue(bean: boRoleInstance, field: "id")}</g:link></td>

                    <td>${fieldValue(bean: boRoleInstance, field: "roleCode")}</td>

                    <td>${fieldValue(bean: boRoleInstance, field: "roleName")}</td>

                    <td>${BoRole.statusMap[boRoleInstance?.status]}</td>

                    <td>
                        <input type="button" onclick="window.location.href = '${createLink(controller:'boOperator', action:'updateUser', params:[id:params.uid, 'roleCode':boRoleInstance?.roleCode])}'" value="选择用户角色"/>
                    </td>
                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <div style="position:absolute;">共${boRoleInstanceTotal}条记录</div>
            <g:paginat total="${boRoleInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
