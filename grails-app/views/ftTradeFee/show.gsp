
<%@ page import="settle.FtFeeChannel; settle.FtTradeFee" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'ftTradeFee.label', default: 'FtTradeFee')}"/>
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
      <td class="right label_name"><g:message code="ftTradeFee.id.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeInstance, field: "id")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.customerNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeInstance, field: "customerNo")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.tradeWeight.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeInstance, field: "tradeWeight")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.fetchType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeInstance, field: "fetchType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.feeType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeInstance, field: "feeType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.feeValue.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeInstance, field: "feeValue")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.category.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeInstance, field: "category")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.channelCode.label"/>：</td>
      
      <td><span class="rigt_tebl_font">
          <g:if test="${ftTradeFeeInstance?.channelCode!=null}">
               ${FtFeeChannel.findByCode(ftTradeFeeInstance?.channelCode)?.name}
          </g:if>
          <g:else>全部</g:else>
        </span>
      </td>
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.dateBegin.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${ftTradeFeeInstance?.dateBegin}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.dateEnd.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${ftTradeFeeInstance?.dateEnd}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.feeMax.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeInstance, field: "feeMax")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.feeMin.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeInstance, field: "feeMin")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.firstLiqDate.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${ftTradeFeeInstance?.firstLiqDate}"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.packLen.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeInstance, field: "packLen")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.packType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: ftTradeFeeInstance, field: "packType")}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.srv.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${ftTradeFeeInstance?.srv?.encodeAsHTML()}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="ftTradeFee.tradeType.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${ftTradeFeeInstance?.tradeType?.encodeAsHTML()}</span></td>
      
    </tr>

      <tr>
          <td class="right label_name">${message(code:"审核状态",default:"审核状态")}：</td>
          <td colspan = "8">
              <g:if test="${ftTradeFeeInstance.isverify == '1'}">
                  已审核
              </g:if>
              <g:else>
                  待审核
              </g:else>
          </td>
      </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${ftTradeFeeInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>
          <span class="button"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
        </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>