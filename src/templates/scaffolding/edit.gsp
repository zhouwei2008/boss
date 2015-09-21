<% import grails.persistence.Event %>
<% import org.codehaus.groovy.grails.plugins.PluginManagerHolder %>
<%=packageName%>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="\${message(code: '${domainClass.propertyName}.label', default: '${className}')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="\${flash.message}">
    <div class="message">\${flash.message}</div>
  </g:if>
  <g:hasErrors bean="\${${propertyName}}">
    <div class="errors">
      <g:renderErrors bean="\${${propertyName}}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="update" <%= multiPart ? ' enctype="multipart/form-data"' : '' %>>
    <g:hiddenField name="id" value="\${${propertyName}?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>
      <% excludedProps = Event.allEvents.toList() << 'version' << 'id' << 'dateCreated' << 'lastUpdated'
      persistentPropNames = domainClass.persistentProperties*.name
      props = domainClass.properties.findAll { persistentPropNames.contains(it.name) && !excludedProps.contains(it.name) }
      Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
      display = true
      boolean hasHibernate = PluginManagerHolder.pluginManager.hasGrailsPlugin('hibernate')
      props.each { p ->
        if (hasHibernate) {
          cp = domainClass.constrainedProperties[p.name]
          display = (cp?.display ?: true)
        }
        if (display) { %>
      <tr>
        <td class="right label_name"><g:message code="${domainClass.propertyName}.${p.name}.label"/>：</td>
        <td class="\${hasErrors(bean: ${propertyName}, field: '${p.name}', 'errors')}">${renderEditor(p)}</td>
      </tr>
      <% }
      } %>
      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
</body>
</html>
