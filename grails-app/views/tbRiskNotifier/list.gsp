
<%@ page import="ismp.TbRiskNotifier" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbRiskNotifier.label', default: '通知名单')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div class="right_top" >

      <div class="table_serch">
      <g:form>

          <table>
                             <tr>


                                 <td>

                                     <g:actionSubmit style="width:100px;height:23px;" action="create" value="添加通知人"/>

                                 </td>


                             </tr>

                         </table>

      </g:form>
   </div>
    <table align="center" class="right_list_table" id="test" style="margin-top: 10px;">
      <tr>
        


        <g:sortableColumn params="${params}"  property="name" title="${message(code: 'tbRiskNotifier.name.label', default: '通知人')}"/>
        
        <g:sortableColumn params="${params}"  property="subId" title="${message(code: 'tbRiskNotifier.subId.label', default: '手机号')}"/>
        
        <g:sortableColumn params="${params}"  property="email" title="${message(code: 'tbRiskNotifier.email.label', default: 'Email')}"/>
        
      </tr>

      <g:each in="${tbRiskNotifierInstanceList}" status="i" var="tbRiskNotifierInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

          <td><g:link action="show" id="${tbRiskNotifierInstance.id}">${fieldValue(bean: tbRiskNotifierInstance, field: "name")}</g:link></td>
          
          <td>${fieldValue(bean: tbRiskNotifierInstance, field: "subId")}</td>
          
          <td>${fieldValue(bean: tbRiskNotifierInstance, field: "email")}</td>
          
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">

        <div style="float:left"><span/>一共${tbRiskNotifierInstanceTotal}条</span></div>

        <div style="float:right"><g:paginate total="${tbRiskNotifierInstanceTotal}" params="${params}"/></div>


    </div>
  </div>
</div>
</body>
</html>
