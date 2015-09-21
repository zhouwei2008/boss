
<%@ page import="boss.Perm; boss.BossRole" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'bossRole.label', default: 'BossRole')}"/>
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
        <bo:hasPerm perm="${Perm.Security_Role_New}" ><g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/></bo:hasPerm>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        
        <g:sortableColumn params="${params}"  property="roleName" title="${message(code: 'bossRole.roleName.label', default: 'Role Name')}"/>
        <g:sortableColumn params="${params}"  property="dateCreated" title="${message(code: 'bossRole.dateCreated.label', default: 'dateCreated')}"/>
        <th>操作</th>
      </tr>

      <g:each in="${bossRoleInstanceList}" status="i" var="bossRoleInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

          <td><g:if test="${bo.hasPerm(perm:Perm.Security_Role_View){true} && bossRoleInstance.roleName != 'admin'}" ><g:link action="show" id="${bossRoleInstance.id}">${fieldValue(bean: bossRoleInstance, field: "roleName")}</g:link></g:if><g:else>${fieldValue(bean: bossRoleInstance, field: "roleName")}</g:else></td>
          <td><g:formatDate date="${bossRoleInstance.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td>
            <g:if test="${bo.hasPerm(perm:Perm.Security_Role_View){true} && bossRoleInstance.roleName != 'admin'}" >
              <g:link action="delete" id="${bossRoleInstance.id}" onClick="if(confirm('确定删除么?')){return true;}else{return false;}">删除</g:link>
            </g:if>
          </td>
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
      <span style=" float:left;">共${bossRoleInstanceTotal}条记录</span>
      <g:paginat total="${bossRoleInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>
