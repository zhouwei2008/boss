<%@ page import="boss.Perm" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boOffineCharge.label', default: 'boOffineCharge')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>

</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <g:hasErrors bean="${boOfflineChargeInstance}">
    <div class="errors">
      <g:renderErrors bean="${boOfflineChargeInstance}" as="list"/>
    </div>
  </g:hasErrors>


    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boOffineCharge.account.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'accountNo', 'errors')}">
            ${fieldValue(bean: boOfflineChargeInstance, field: "accountNo")}
        </td>
      </tr>
       <tr>
        <td class="right label_name"><g:message code="boOffineCharge.trxtype.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'trxtype', 'errors')}">
            <g:if test="${boOfflineChargeInstance?.trxtype=='charge'}">充值</g:if>
            <g:if test="${boOfflineChargeInstance?.trxtype=='void'}">充值撤销</g:if>
        </td>
      </tr>

        <tr>
        <td class="right label_name"><g:message code="boOffineCharge.branchname.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'accountNo', 'errors')}">
            ${fieldValue(bean: boOfflineChargeInstance, field: "branchname")}
        </td>
      </tr>

        <tr>
        <td class="right label_name"><g:message code="boOffineCharge.createtime.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'createdate', 'errors')}">
            <g:formatDate date="${boOfflineChargeInstance.createdate}" format="yyyy-MM-dd HH:mm:ss"/>
        </td>
      </tr>

       <tr>
        <td class="right label_name"><g:message code="boOffineCharge.apptime.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'authdate', 'errors')}">
            <g:formatDate date="${boOfflineChargeInstance.authdate}" format="yyyy-MM-dd HH:mm:ss"/>
        </td>
      </tr>

          <tr>
        <td class="right label_name"><g:message code="boOffineCharge.authsts.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'authsts', 'errors')}">
                <g:if test="${boOfflineChargeInstance?.authsts=='N'}">待审核</g:if>
                <g:if test="${boOfflineChargeInstance?.authsts=='P'}">审核中</g:if>
                <g:if test="${boOfflineChargeInstance?.authsts=='Y'}">审核通过</g:if>
                <g:if test="${boOfflineChargeInstance?.authsts=='F'}">审核拒绝</g:if>
        </td>
      </tr>

          <tr>
        <td class="right label_name"><g:message code="boOffineCharge.authdesc.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'authdesc', 'errors')}">
            ${fieldValue(bean: boOfflineChargeInstance, field: "authdesc")}
        </td>
      </tr>

       <tr>
        <td class="right label_name"><g:message code="boOffineCharge.creator.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'creator_name', 'errors')}">
            ${fieldValue(bean: boOfflineChargeInstance, field: "creator_name")}
        </td>
      </tr>

        <tr>
          <td class="right label_name"><g:message code="boOffineCharge.trxsqe.label"/>：</td>
            <td>
                ${fieldValue(bean: boOfflineChargeInstance, field: "trxSeq")}
            </td>
      </tr>

        <tr>
             <td class="right label_name"><g:message code="boOffineCharge.oldsqe.label"/>：</td>
                  <td>
                      ${fieldValue(bean: boOfflineChargeInstance, field: "oldSeq")}
                  </td>
            </tr>
      <tr>
        <td class="right label_name"><g:message code="boOffineCharge.amount.label"/>：</td>
         <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'amount', 'errors')}">
             <g:formatNumber number="${boOfflineChargeInstance.amount/100}" type="currency" currencyCode="CNY"/>
         </td>
      </tr>

        <tr>
        <td class="right label_name"><g:message code="boOffineCharge.realamount.label"/>：</td>
          <td>
              <g:formatNumber number="${boOfflineChargeInstance.realamount/100}" type="currency" currencyCode="CNY"/>
          </td>
      </tr>


       <tr>
        <td class="right label_name"><g:message code="boOffineCharge.billmode.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'billmode', 'errors')}">
              <g:if test="${boOfflineChargeInstance?.billmode=='cashier'}">现金</g:if>
              <g:if test="${boOfflineChargeInstance?.billmode=='check'}">支票</g:if>
              <g:if test="${boOfflineChargeInstance?.billmode=='transfer'}">转账</g:if>
              <g:if test="${boOfflineChargeInstance?.billmode=='other'}">其他</g:if>
        </td>
      </tr>

         <tr>
        <td class="right label_name"><g:message code="boOffineCharge.status.label"/>：</td>
        <td class="${hasErrors(bean: boOfflineChargeInstance, field: 'status', 'errors')}">
               <g:if test="${boOfflineChargeInstance?.status=='Y'}">完成</g:if>
                <g:if test="${boOfflineChargeInstance?.status=='N'}">待处理</g:if>
                <g:if test="${boOfflineChargeInstance?.status=='P'}">处理中</g:if>
                <g:if test="${boOfflineChargeInstance?.status=='F'}">失败</g:if>
                <g:if test="${boOfflineChargeInstance?.status=='C'}">取消</g:if>
        </td>
      </tr>





      
      <tr>
          <g:form action="save" >
            <g:hiddenField name="id" value="${boOfflineChargeInstance?.id}"/>
            <td colspan="2" align="center">
              <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
              %{--<span class="button"><bo:hasPerm perm="${Perm.TravelCard_ReCharge_Appay_Edit}"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></bo:hasPerm></span>--}%
            </td>
         </g:form>
      </tr>
    </table>


</div>
</body>
</html>
