
<%@ page import="gateway.GwTransaction; gateway.GwOrder" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'gwOrder.label', default: 'GwOrder')}"/>
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
      <td class="right label_name"><g:message code="gwOrder.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.amount.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatNumber number="${gwOrderInstance.amount/100}" type="currency" currencyCode="CNY"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.apiversion.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "apiversion")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.body.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${gwOrderInstance.body}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.buyerCode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "buyerCode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.buyerCustomerNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "buyerCustomerNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.buyerRemarks.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "buyerRemarks")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.charset.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "charset")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.closeDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${gwOrderInstance?.closeDate}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.currency.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "currency")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.dateCreated.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${gwOrderInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.expires.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "expires")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.ip.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "ip")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.notifyUrl.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "notifyUrl")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.orderType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "orderType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.orderdate.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "orderdate")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.outTradeNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "outTradeNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.partnerCustomerNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "partnerCustomerNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.queryKey.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "queryKey")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.returnUrl.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "returnUrl")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.royaltyParams.label"/>：</td>
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "royaltyParams")}</span></td>
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.royaltyType.label"/>：</td>
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "royaltyType")}</span></td>
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.sellerCode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "sellerCode")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.sellerCustomerNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "sellerCustomerNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.sellerRemarks.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "sellerRemarks")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.service.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "service")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.showUrl.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "showUrl")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.signType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "signType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.status.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${GwOrder.statusMap[gwOrderInstance.status]}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.subject.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: gwOrderInstance, field: "subject")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="gwOrder.transactions.label"/>：</td>
      
      <td><span class="rigt_tebl_font">
        <ul>
          <g:each in="${gwOrderInstance.transactions}" var="t">
            <li>
                <g:link controller="gwTransaction" action="show" id="${t.id}">${t.id}</g:link>：
                ${GwTransaction.statusMap[t.status]}
            </li>
          </g:each>
        </ul>
      </span></td>
      
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${gwOrderInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>