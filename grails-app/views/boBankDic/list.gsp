<%@ page import="boss.Perm; boss.BoBankDic" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boBankDic.label', default: 'BoBankDic')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <bo:hasPerm perm="${Perm.Bank_Manage_New}"><g:form><g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/></g:form></bo:hasPerm>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="code" title="${message(code: 'boBankDic.code.label', default: 'Code')}"/>

                <g:sortableColumn params="${params}" property="name" title="${message(code: 'boBankDic.name.label', default: 'Name')}"/>

            </tr>

            <g:each in="${boBankDicInstanceList}" status="i" var="boBankDicInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:if test="${bo.hasPerm(perm:Perm.Bank_Manage_View){true}}"><g:link action="show" id="${boBankDicInstance.id}">${fieldValue(bean: boBankDicInstance, field: "code")}</g:link></g:if><g:else>${fieldValue(bean: boBankDicInstance, field: "code")}</g:else></td>

                    <td>${fieldValue(bean: boBankDicInstance, field: "name")}</td>

                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${boBankDicInstanceTotal}条记录</span>
            <g:paginat total="${boBankDicInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
