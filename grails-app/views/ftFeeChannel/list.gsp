<%@ page import="settle.FtFeeChannel" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftFeeChannel.label', default: 'FtFeeChannel')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<g:javascript>
function addFeeChannel(srvCode,srvId){
    window.location.href= '${createLink(controller: 'ftFeeChannel', action: 'create')}?srvCode='+srvCode+'&srvId='+srvId;
}
</g:javascript>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">费率通道设置</h1>
        <h2>
            <g:form>
                <td>业务名称：</td><td>${srvName}</td><br/>
                <input type="button" name="add" class="right_top_h2_button_tj" onclick="addFeeChannel('${srvCode}', '${srvId}')" value="${message(code: 'default.add.label', args: [entityName])}"/>
            </g:form>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="name" title="${message(code: 'ftFeeChannel.name.label', default: 'Name')}"/>

                <g:sortableColumn params="${params}" property="code" title="${message(code: 'ftFeeChannel.code.label', default: 'Code')}"/>

            </tr>

            <g:each in="${ftFeeChannelInstanceList}" status="i" var="ftFeeChannelInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${ftFeeChannelInstance.id}">${fieldValue(bean: ftFeeChannelInstance, field: "name")}</g:link></td>

                    <td>${fieldValue(bean: ftFeeChannelInstance, field: "code")}</td>

                </tr>
            </g:each>
            <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                </td>
            </tr>
        </table>

        <div class="paginateButtons">
          <div align="left">    <div style="position:absolute;">共${ftFeeChannelInstanceTotal}条记录</div></div>
            <g:paginat total="${ftFeeChannelInstanceTotal}" params="${params}"/>
        </div>
        %{--<div class="paginateButtons">--}%
            %{--<g:paginate total="${ftFeeChannelInstanceTotal}" params="${params}"/>--}%
        %{--</div>--}%
    </div>
</div>
</body>
</html>
