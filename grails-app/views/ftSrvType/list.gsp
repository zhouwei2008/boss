<%@ page import="boss.Perm; settle.FtSrvType" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftSrvType.label', default: 'FtSrvType')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<g:javascript>
 function setFeeChannel(srvName,srvCode,srvId){
      window.location.href = '${createLink(controller:'ftFeeChannel', action:'list')}?srvName='+srvName+'&srvCode='+srvCode+'&srvId='+srvId;
 }
</g:javascript>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form>
                <bo:hasPerm perm="${Perm.Settle_SrvType_New}" ><g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/></bo:hasPerm>
            </g:form>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <g:sortableColumn params="${params}" property="srvCode" title="${message(code: 'ftSrvType.srvCode.label', default: 'Srv Code')}"/>
                <g:sortableColumn params="${params}" property="srvName" title="${message(code: 'ftSrvType.srvName.label', default: 'Srv Name')}"/>
                <th>操作</th>
            </tr>

            <g:each in="${ftSrvTypeInstanceList}" status="i" var="ftSrvTypeInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td><g:if test="${bo.hasPerm(perm:Perm.Settle_SrvType_View){true}}" ><g:link action="show" id="${ftSrvTypeInstance.id}">${fieldValue(bean: ftSrvTypeInstance, field: "srvCode")}</g:link></g:if><g:else>${fieldValue(bean: ftSrvTypeInstance, field: "srvCode")}</g:else></td>

                    <td>${fieldValue(bean: ftSrvTypeInstance, field: "srvName")}</td>
                    <td><input type="button" name='button' value="费率通道设置" onclick="setFeeChannel('${ftSrvTypeInstance.srvName}','${ftSrvTypeInstance.srvCode}','${ftSrvTypeInstance.id}')" > </td>
            </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
          <div align="left">    <div style="position:absolute;">共${ftSrvTypeInstanceTotal}条记录</div></div>
            <g:paginat total="${ftSrvTypeInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
