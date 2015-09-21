<%@ page contentType="text/html" %>
<%@ page import="ismp.SlaEvents;" %>
<html>
<body>

<h3>风险报告（<g:formatDate date="${new Date()}" format="yyyy-MM-dd HH:mm"/>）</h3>
<br><br>
    <table align="left" border="1">
      <tr>
        <th>${message(code: 'slaEvents.createdate.label')}</th>
        <th>${message(code: 'slaEvents.createor.label')}</th>
        <th>${message(code: 'slaEvents.meslever.label')}</th>
        <th>${message(code: 'slaEvents.eventtype.label')}</th>
        <th>${message(code: 'slaEvents.mescontent.label')}</th>
        <th>${message(code: 'slaEvents.status.label')}</th>
        <th>${message(code: 'slaEvents.updated.label')}</th>
        <th>${message(code: 'slaEvents.descs.label')}</th>
        <th>${message(code: 'slaEvents.prdsrc.label')}</th>
        <th>${message(code: 'slaEvents.features.label')}</th>
      </tr>

      <g:each in="${result}" status="i" var="event">
        <tr>
          <td><g:formatDate date="${event.createdate}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td>${fieldValue(bean: event, field: "createor")}</td>
          <td>${fieldValue(bean: event, field: "meslever")}</td>
          <td>${event?.eventtype?.name}</td>
          <td>${fieldValue(bean: event, field: "mescontent")}</td>
          <td>${SlaEvents.statusMap[event?.status]}</td>
          <td><g:formatDate date="${event.updated}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td>${fieldValue(bean: event, field: "descs")}</td>
          <td>${fieldValue(bean: event, field: "prdsrc")}</td>
          <td>${fieldValue(bean: event, field: "features")}</td>
        </tr>
      </g:each>
    </table>

</body>
</html>