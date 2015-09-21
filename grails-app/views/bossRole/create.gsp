<%@ page import="boss.BossRole" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'bossRole.label', default: 'BossRole')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
  <link rel="stylesheet" href="${resource(dir: 'js/tree/css', file: 'tree.css')}"/>
</head>
<body style="overflow-x:hidden">
<g:javascript library="tree/jquery.tree"/>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${bossRoleInstance}">
    <div class="errors">
      <g:renderErrors bean="${bossRoleInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" name="createForm">
    <g:hiddenField name="permLs"/>
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="bossRole.roleName.label"/>：</td>
        <td class="${hasErrors(bean: bossRoleInstance, field: 'roleName', 'errors')}"><g:textField name="roleName" value="${bossRoleInstance?.roleName}" maxlength="30"/></td>
      </tr>

      <tr>
        <td class="right label_name">权限：</td>
        <td>
          <div id="tree"></div>
        </td>
      </tr>

      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
<script type="text/javascript">
  $(function() {
    load();

    $("#createForm").validate({
      rules: {
        roleName : {required: true}
      },
      submitHandler: function(form) {
        var permLs = getCheckNodes()
        if (!permLs) {
          alert("请分配权限！")
          return false
        }
        $("#permLs").val(permLs)
        form.submit();
      },
      onkeyup: false
    })

  });

  function getCheckNodes() {
    var s = $("#tree").getTSNs(true);
    var result = "";
    $.each(s,
        function(inx, node) {
          if (inx != 0) {
            result += ","
          }
          result += node.id
        }
    )
    return result
  }

  function load() {
    var o = {
      showcheck: true,
      clicktoggle: false,
      cbiconpath:"${resource(dir: 'js/tree/css/images/icons/')}"
    };
    o.data = [${permTree}]
    $("#tree").treeview(o);
  }
</script>
</body>
</html>
