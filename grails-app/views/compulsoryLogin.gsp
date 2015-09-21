<%@ page import="ismp.TbRiskControl" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: '', default: '')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="params1" title="登陆名"/>

                <g:sortableColumn params="${params}" property="params2" title="登陆时间"/>

                <g:sortableColumn params="${params}" property="params3" title="登陆IP"/>

                <g:sortableColumn params="${params}" property="params4" title="操作"/>

            </tr>

            <tr>
                <td>${op?.account}</td>
                <td>${op?.lastLoginTime}</td>
                <td>${op?.loginIp}</td>
                <td><g:link action="resetLogin" id="${op?.id}">强制登陆</g:link></td>
            </tr>
        </table>
    </div>
</div>
</body>
</html>
