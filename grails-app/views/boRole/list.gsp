<%@ page import="boss.BoRole" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boRole.label', default: 'BoRole')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript">
        function checkStatus(str, flag) {
            if (confirm("确定要改变角色状态吗！")) {
                if (flag == 1) {
                    window.location.href = '${createLink(controller:'boRole', action:'updateStatus', params:['statusFlag':'1'])}&id=' + str;
                }
                if (flag == 2) {
                    window.location.href = '${createLink(controller:'boRole', action:'updateStatus', params:['statusFlag':'0'])}&id=' + str;
                }
            }
        }
    </script>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
         <g:form>
             <div class="table_serch">
            <table>

                    <tr>
                        <td>角色编码:</td><td><g:textField name="roleCode" onblur="value=value.replace(/[ ]/g,'')" value="${params.roleCode}"></g:textField></td>
                        <td>角色名称:</td><td><g:textField name="roleName" onblur="value=value.replace(/[ ]/g,'')" value="${params.roleName}"></g:textField></td>
                        <td>角色状态:</td><td><g:select name="status" from="${BoRole.statusMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" value="params.status"/></td>
                        <td ><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询"/></td>
                        <td ><g:actionSubmit class="right_top_h2_button_serch" action="listDownload" value="下载"/></td>

                    </tr>

            </table>
        </div>
             <div class="button_menu"><g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/></div>
        </g:form>

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
                        <g:if test="${boRoleInstance.roleCode!='admin'}">
                            <g:if test="${boRoleInstance?.status=='2'}">
                                <input type="button" onclick=" return checkStatus(${boRoleInstance?.id}, 1);" value="启用"/>
                            </g:if>
                            <g:if test="${boRoleInstance?.status=='1'}">
                                <input type="button" onclick="return checkStatus(${boRoleInstance?.id}, 2)" value="停用"/>
                            </g:if>
                            <g:if test="${boRoleInstance.status=='1'}">
                                <input type="button" onclick="if (confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}')) {
                                    window.location.href = '${createLink(controller:'boPromission', action:'addPromission', params:['uid':boRoleInstance?.id,'permId':boRoleInstance?.permission_id])}'
                                }
                                ;" value="设置角色权限"/>
                            </g:if>
                        </g:if>
                    </td>

                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${boRoleInstanceTotal}条记录</span>
            <g:paginat total="${boRoleInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
