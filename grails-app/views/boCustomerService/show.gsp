<%@ page import="ismp.CmCorporationInfo; ismp.CmCustomer; boss.Perm; boss.BoCustomerService" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boCustomerService.label', default: 'BoCustomerService')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>

  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
    </tr>

    <tr>
      <td class="right label_name"><g:message code="boCustomerService.contractNo.label"/>：</td>

      <td><span class="rigt_tebl_font">${fieldValue(bean: boCustomerServiceInstance, field: "contractNo")}</span></td>

    </tr>

    <tr>
      <td class="right label_name"><g:message code="boCustomerService.serviceCode.label"/>：</td>

      <td><span class="rigt_tebl_font">${BoCustomerService.serviceMap[boCustomerServiceInstance?.serviceCode]}</span></td>

    </tr>

    <tr>
      <td class="right label_name"><g:message code="boCustomerService.startTime.label"/>：</td>

      <td><span class="rigt_tebl_font"><g:formatDate date="${boCustomerServiceInstance?.startTime}" format="yyyy-MM-dd HH:mm:ss"/></span></td>

    </tr>

    <tr>
      <td class="right label_name"><g:message code="boCustomerService.endTime.label"/>：</td>

      <td><span class="rigt_tebl_font"><g:formatDate date="${boCustomerServiceInstance?.endTime}" format="yyyy-MM-dd HH:mm:ss"/></span></td>

    </tr>

    <tr>
      <td class="right label_name"><g:message code="boCustomerService.srvAccNo.label"/>：</td>

      <td><span class="rigt_tebl_font">${boCustomerServiceInstance?.srvAccNo}</span></td>

    </tr>

    <tr>
      <td class="right label_name"><g:message code="boCustomerService.feeAccNo.label"/>：</td>

      <td><span class="rigt_tebl_font">${boCustomerServiceInstance?.feeAccNo}</span></td>

    </tr>

    %{--<tr id="feeLabel">--}%
      %{--<td class="right label_name"><g:message code="boCustomerService.feeParams.label"/>：</td>--}%

      %{--<td><span class="rigt_tebl_font">${fieldValue(bean: boCustomerServiceInstance, field: "feeParams")}</span></td>--}%

    %{--</tr>--}%

    %{--<tr id="serviceLabel">--}%
      %{--<td class="right label_name"><g:message code="boCustomerService.serviceParams.label"/>：</td>--}%

      %{--<td><span class="rigt_tebl_font">${fieldValue(bean: boCustomerServiceInstance, field: "serviceParams")}</span></td>--}%
    %{--</tr>--}%

    <tr>
      <td class="right label_name"><g:message code="boCustomerService.belongToSale.label"/>：</td>

      <td><span class="rigt_tebl_font">${fieldValue(bean: boCustomerServiceInstance, field: "belongToSale")}</span></td>

    </tr>
    <tr>
      <td class="right label_name"><g:message code="boCustomerService.isFanDian.label"/>：</td>
      <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${boCustomerServiceInstance?.isFanDian}"/></span></td>
    </tr>
    <tr>
      <td class="right label_name"><g:message code="boCustomerService.fanDianAmount.label"/>：</td>
      <td><span class="rigt_tebl_font">${fieldValue(bean: boCustomerServiceInstance, field: "fanDianAmount")}</span></td>
    </tr>
    <tr>
      <td class="right label_name"><g:message code="boCustomerService.isCurrent.label"/>：</td>

      <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${boCustomerServiceInstance?.isCurrent}"/></span></td>

    </tr>

    <tr>
      <td class="right label_name"><g:message code="boCustomerService.enable.label"/>：</td>

      <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${boCustomerServiceInstance?.enable}"/></span></td>

    </tr>

    <tr>
        <td class="right label_name">${message(code:'是否提示执照到期',default:'是否提示执照到期')}</td>
        <td><span class="rigt_tebl_font"><g:formatBoolean boolean="${boCustomerServiceInstance?.isViewDate}"/></span></td>
    </tr>

    <tr>
      <td class="right label_name"><g:message code="boCustomerService.dateCreated.label"/>：</td>

      <td><span class="rigt_tebl_font"><g:formatDate date="${boCustomerServiceInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>

    </tr>

    <tr>
      <td class="right label_name"><g:message code="boCustomerService.lastUpdated.label"/>：</td>

      <td><span class="rigt_tebl_font"><g:formatDate date="${boCustomerServiceInstance?.lastUpdated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>

    </tr>

    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${boCustomerServiceInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <bo:hasPerm perm="${Perm.Cust_Corp_Srv_Edit}" ><span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span></bo:hasPerm>
        </g:form>
      </td>
    </tr>
  </table>

</div>
    <script type="text/javascript">
        var serviceCode = "${boCustomerServiceInstance?.serviceCode}";
        if(serviceCode=="agentcoll" || serviceCode=="agentpay")
        {
            document.getElementById("feeLabel").style.display="none";
            document.getElementById("serviceLabel").style.display="none";
        }
    </script>
</body>
</html>