<%@ page import="ismp.CmCustomer; ismp.CmOpRelation; ismp.CmOpLog" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'cmOpLog.label', default: 'CmOpLog')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="cmOpLog.account.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmOpLogInstance, field: "account")}</span></td>
      
    </tr>

       <tr>
            <td class="right label_name"><g:message code="cmOpLog.names.label"/>：</td>
            <td><span class="rigt_tebl_font">${CmOpRelation.findByActionsAndControllers(cmOpLogInstance.action,cmOpLogInstance.controller)?.names}</span></td>
        </tr>

    
    <tr>
      <td class="right label_name"><g:message code="cmOpLog.customerNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: cmOpLogInstance, field: "customerNo")}</span></td>
      
    </tr>
    <tr>
      <td class="right label_name"><g:message code="cmOpLog.customerName.label"/>：</td>

      <td><span class="rigt_tebl_font">${CmCustomer.findByCustomerNo(cmOpLogInstance.customerNo)?.name}</span></td>

    </tr>
    <tr>
          <td class="right label_name"><g:message code="cmOpLog.params.label"/>：</td>
          <td><span class="rigt_tebl_font">${fieldValue(bean: cmOpLogInstance, field: "params")}</span></td>
     </tr>
     <tr>
      <td class="right label_name"><g:message code="cmOpLog.ip.label"/>：</td>

      <td><span class="rigt_tebl_font">${fieldValue(bean: cmOpLogInstance, field: "ip")}</span></td>

    </tr>
    <tr>
      <td class="right label_name"><g:message code="cmOpLog.dateCreated.label"/>：</td>
      <td><span class="rigt_tebl_font"><g:formatDate date="${cmOpLogInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
    </tr>
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${cmOpLogInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>