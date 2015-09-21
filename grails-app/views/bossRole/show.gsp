
<%@ page import="boss.Perm; boss.BossRole" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'bossRole.label', default: 'BossRole')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
  <link rel="stylesheet" href="${resource(dir: 'js/tree/css', file: 'tree.css')}"/>
</head>
<body style="overflow-x:hidden">
<g:javascript library="tree/jquery.tree"/>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
    </tr>

    <tr>
      <td class="right label_name"><g:message code="bossRole.roleName.label"/>：</td>

      <td><span class="rigt_tebl_font">${fieldValue(bean: bossRoleInstance, field: "roleName")}</span></td>

    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="bossRole.rolePerms.label"/>：</td>
      
      <td>
        <div id="tree"></div>
      </td>
      
    </tr>

    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${bossRoleInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <bo:hasPerm perm="${Perm.Security_Role_Edit}" ><span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span></bo:hasPerm>
        </g:form>
      </td>
    </tr>
  </table>

</div>
<script type="text/javascript">
  $(function() {
    load();
  });

  function load() {
    var o = {
      showcheck: false,
      clicktoggle: false,
      cbiconpath:"${resource(dir: 'js/tree/css/images/icons/')}"
    };
    o.data = [${permTree}]
    $("#tree").treeview(o);
  }
</script>
</body>
</html>