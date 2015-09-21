<%@ page import="boss.Perm;boss.BoOpRelation" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boOpRelation.label', default: 'BoOpRelation')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<script type="text/javascript">

       function empty() {

         document.getElementById('controllers').value='';
         document.getElementById('actions').value='';
         document.getElementById('names').value='';
           return false;
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message
                code="default.list.label" args="[entityName]"/></h1>

        <h2>
            <bo:hasPerm perm="${Perm.SysLog_Op_Relation_New}" ><g:form>
                <g:actionSubmit class="right_top_h2_button_tj" action="create"
                                value="${message(code: 'default.new.label', args:[entityName])}"/>
            </g:form></bo:hasPerm>
        </h2>
        <div class="table_serch">
            <table>
                <g:form>
                    <tr>
                        <td>${message(code: 'boOpRelation.controllers.label')}：</td>
                        <td><p><g:textField name="controllers" value="${params.controllers}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'boOpRelation.actions.label')}：</td>
                        <td><p><g:textField name="actions" value="${params.actions}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'boOpRelation.names.label')}：</td>
                        <td><p><g:textField name="names"  value="${params.names}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询"/></td>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="" value="清空" onclick="return empty()"/></td>
                        <td><g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载"/></td>
                    </tr>

                </g:form>
            </table>
        </div>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <g:sortableColumn params="${params}" property="controllers" title="${message(code: 'boOpRelation.controllers.label', default: 'Controller Type')}"/>
                <g:sortableColumn params="${params}" property="actions" title="${message(code: 'boOpRelation.actions.label', default: 'Action Type')}"/>
                <g:sortableColumn params="${params}" property="names" title="${message(code: 'boOpRelation.names.label', default: 'Name Type')}"/>
            </tr>

            <g:each in="${boOpRelationInstanceList}" status="i" var="boOpRelationInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>${fieldValue(bean: boOpRelationInstance, field: "controllers")}</td>
                    <td>${fieldValue(bean: boOpRelationInstance, field: "actions")}</td>
                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.SysLog_Op_Relation_View){true}}">
                            <g:link action="show" id="${boOpRelationInstance.id}">${fieldValue(bean: boOpRelationInstance, field: "names")}</g:link>
                        </g:if>
                        <g:else>
                            ${fieldValue(bean: boOpRelationInstance, field: "names")}
                        </g:else>
                    </td>
                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${boOpRelationInstanceTotal}条记录</span>
            <g:paginat total="${boOpRelationInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
