<% import grails.persistence.Event %>
<%=packageName%>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="\${message(code: '${domainClass.propertyName}.label', default: '${className}')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="\${flash.message}">
    <div class="message">\${flash.message}</div>
  </g:if>

  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
    </tr>
    <% excludedProps = Event.allEvents.toList() << 'version'
    allowedNames = domainClass.persistentProperties*.name << 'id' << 'dateCreated' << 'lastUpdated'
    props = domainClass.properties.findAll { allowedNames.contains(it.name) && !excludedProps.contains(it.name) }
    Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
    props.each { p -> %>
    <tr>
      <td class="right label_name"><g:message code="${domainClass.propertyName}.${p.name}.label"/>：</td>
      <% if (p.isEnum()) { %>
      <td><span class="rigt_tebl_font">\${${propertyName}?.${p.name}?.encodeAsHTML()}</span></td>
      <% } else if (p.oneToMany || p.manyToMany) { %>
      <td><span class="rigt_tebl_font">
        <ul>
          <g:each in="\${${propertyName}.${p.name}}" var="${p.name[0]}">
            <li>\${${p.name[0]}?.encodeAsHTML()}</li>
          </g:each>
        </ul>
      </span></td>
      <% } else if (p.manyToOne || p.oneToOne) { %>
      <td><span class="rigt_tebl_font">\${${propertyName}?.${p.name}?.encodeAsHTML()}</span></td>
      <% } else if (p.type == Boolean.class || p.type == boolean.class) { %>
      <td><span class="rigt_tebl_font"><g:formatBoolean boolean="\${${propertyName}?.${p.name}}"/></span></td>
      <% } else if (p.type == Date.class || p.type == java.sql.Date.class || p.type == java.sql.Time.class || p.type == Calendar.class) { %>
      <td><span class="rigt_tebl_font"><g:formatDate date="\${${propertyName}?.${p.name}}"/></span></td>
      <% } else if (!p.type.isArray()) { %>
      <td><span class="rigt_tebl_font">\${fieldValue(bean: ${propertyName}, field: "${p.name}")}</span></td>
      <% } %>
    </tr>
    <% } %>
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="\${${propertyName}?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="button"><g:actionSubmit class="rigt_button" action="edit" value="\${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>
          <span class="button"><g:actionSubmit class="rigt_button" action="delete" value="\${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('\${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>