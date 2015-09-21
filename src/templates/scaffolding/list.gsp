<% import grails.persistence.Event %>
<%=packageName%>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="\${message(code: '${domainClass.propertyName}.label', default: '${className}')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
  <g:if test="\${flash.message}">
    <div class="message">\${flash.message}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="\${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
    <h2>
      <g:form>
        <g:actionSubmit class="right_top_h2_button_tj" action="create" value="\${message(code: 'default.new.label', args:[entityName])}"/>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <% excludedProps = Event.allEvents.toList() << 'version'
        allowedNames = domainClass.persistentProperties*.name << 'id' << 'dateCreated' << 'lastUpdated'
        props = domainClass.properties.findAll { allowedNames.contains(it.name) && !excludedProps.contains(it.name) && !Collection.isAssignableFrom(it.type) }
        Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
        props.eachWithIndex { p, i ->
          if (i < 6) {
            if (p.isAssociation()) { %>
        <th><g:message code="${domainClass.propertyName}.${p.name}.label" default="${p.naturalName}"/></th>
        <% } else { %>
        <g:sortableColumn params="\${params}"  property="${p.name}" title="\${message(code: '${domainClass.propertyName}.${p.name}.label', default: '${p.naturalName}')}"/>
        <% }
        }
        } %>
      </tr>

      <g:each in="\${${propertyName}List}" status="i" var="${propertyName}">
        <tr class="\${(i % 2) == 0 ? 'odd' : 'even'}">
          <% props.eachWithIndex { p, i ->
            if (i == 0) { %>
          <td><g:link action="show" id="\${${propertyName}.id}">\${fieldValue(bean: ${propertyName}, field: "${p.name}")}</g:link></td>
          <% } else if (i < 6) {
            if (p.type == Boolean.class || p.type == boolean.class) { %>
          <td><g:formatBoolean boolean="\${${propertyName}.${p.name}}"/></td>
          <% } else if (p.type == Date.class || p.type == java.sql.Date.class || p.type == java.sql.Time.class || p.type == Calendar.class) { %>
          <td><g:formatDate date="\${${propertyName}.${p.name}}"/></td>
          <% } else { %>
          <td>\${fieldValue(bean: ${propertyName}, field: "${p.name}")}</td>
          <% }
          }
          } %>
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
      <g:paginate total="\${${propertyName}Total}" params="\${params}"/>
    </div>
  </div>
</div>
</body>
</html>
