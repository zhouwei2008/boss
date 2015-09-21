<%@ page import="boss.Perm" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boRechargeTime.label', default: 'boRechargeTime')}"/>
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
            <bo:hasPerm perm="${Perm.TravelCard_ReCharge_EndTime_Add}"><g:form><g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/></g:form></bo:hasPerm>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>

                %{--<g:sortableColumn params="${params}" property="branchName" title="${message(code: 'boRechargeTime.branchName.label', default: 'branchName')}"/>--}%

                <g:sortableColumn params="${params}" property="dateCode" title="${message(code: 'boRechargeTime.dateCode.label', default: 'dateCode')}"/>

                <g:sortableColumn params="${params}" property="allowdate" title="${message(code: 'boRechargeTime.time.label', default: 'time')}"/>

                <g:sortableColumn params="${params}" property="status" title="${message(code: 'boRechargeTime.status.label', default: 'status')}"/>

            </tr>

            <g:each in="${boRechargeTimeInstanceList}" status="i" var="boRechargeTimeInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    %{--<td>${fieldValue(bean: boRechargeTimeInstance, field: "branchName")}</td>--}%

                    <td>
                        <g:if test="${boRechargeTimeInstance?.dateCode=='startTime'}">开始时间</g:if>
                         <g:if test="${boRechargeTimeInstance?.dateCode=='endTime'}">结束时间</g:if>
                    </td>

                    <td><g:if test="${bo.hasPerm(perm:Perm.TravelCard_ReCharge_EndTime_View){true}}"><g:link action="edit" id="${boRechargeTimeInstance.id}"> ${fieldValue(bean: boRechargeTimeInstance, field: "allowHour")}:${fieldValue(bean: boRechargeTimeInstance, field: "allowMits")}</g:link></g:if></td>

                    <td>
                         <g:if test="${boRechargeTimeInstance?.status==0}">启用</g:if>
                         <g:if test="${boRechargeTimeInstance?.status==1}">停用</g:if>
                    </td>

                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${boRechargeTimeInstanceTotal}条记录</span>
            <g:paginat total="${boRechargeTimeInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
