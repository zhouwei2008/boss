<%@ page import="ebank.tools.StringUtil; boss.Perm" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boRevocationApply.label', default: 'boRevocationApply')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>

</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <g:hasErrors bean="${boRevocationApplyInstance}">
    <div class="errors">
      <g:renderErrors bean="${boRevocationApplyInstance}" as="list"/>
    </div>
  </g:hasErrors>


    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boRevocationApply.account.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'accountNo', 'errors')}">
            ${fieldValue(bean: boRevocationApplyInstance, field: "accountNo")}
        </td>
      </tr>
             <tr>
        <td class="right label_name"><g:message code="boRevocationApply.accountName.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'accountName', 'errors')}">
            ${fieldValue(bean: boRevocationApplyInstance, field: "accountName")}
        </td>
      </tr>
       <tr>
        <td class="right label_name"><g:message code="boRevocationApply.trxtype.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'trxtype', 'errors')}">
            <g:if test="${boRevocationApplyInstance?.trxtype=='charge'}">充值</g:if>
            <g:if test="${boRevocationApplyInstance?.trxtype=='void'}">充值撤销</g:if>
        </td>
      </tr>

        <tr>
        <td class="right label_name"><g:message code="boRevocationApply.branchname.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'branchname', 'errors')}">
            ${fieldValue(bean: boRevocationApplyInstance, field: "branchname")}
        </td>
      </tr>

        <tr>
        <td class="right label_name"><g:message code="boRevocationApply.createtime.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'createdate', 'errors')}">
              <g:formatDate date="${boRevocationApplyInstance.createdate}" format="yyyy-MM-dd HH:mm:ss"/>
        </td>
      </tr>

       <tr>
        <td class="right label_name"><g:message code="boRevocationApply.apptime.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'authdate', 'errors')}">
             <g:formatDate date="${boRevocationApplyInstance.authdate}" format="yyyy-MM-dd HH:mm:ss"/>
        </td>
      </tr>

          <tr>
        <td class="right label_name"><g:message code="boRevocationApply.authsts.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'authsts', 'errors')}">
                <g:if test="${boRevocationApplyInstance?.authsts=='N'}">待审核</g:if>
                <g:if test="${boRevocationApplyInstance?.authsts=='P'}">审核中</g:if>
                <g:if test="${boRevocationApplyInstance?.authsts=='Y'}">审核通过</g:if>
                <g:if test="${boRevocationApplyInstance?.authsts=='F'}">审核拒绝</g:if>
        </td>
      </tr>

          <tr>
        <td class="right label_name"><g:message code="boRevocationApply.authdesc.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'authdesc', 'errors')}">
            ${fieldValue(bean: boRevocationApplyInstance, field: "authdesc")}
        </td>
      </tr>

       <tr>
        <td class="right label_name"><g:message code="boRevocationApply.creator.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'creator_name', 'errors')}">
            ${fieldValue(bean: boRevocationApplyInstance, field: "creator_name")}
        </td>
      </tr>

        <tr>
              <td class="right label_name"><g:message code="boRevocationApply.author.label"/>：</td>
              <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'author_name', 'errors')}">
                  ${fieldValue(bean: boRevocationApplyInstance, field: "author_name")}
              </td>
            </tr>


        <tr>
          <td class="right label_name"><g:message code="boRevocationApply.trxsqe.label"/>：</td>
            <td>
                ${fieldValue(bean: boRevocationApplyInstance, field: "trxSeq")}
            </td>
      </tr>

        <tr>
             <td class="right label_name"><g:message code="boRevocationApply.oldsqe.label"/>：</td>
                  <td>
                      ${fieldValue(bean: boRevocationApplyInstance, field: "oldSeq")}
                  </td>
            </tr>
      <tr>
        <td class="right label_name"><g:message code="boRevocationApply.amount.label"/>：</td>
         <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'amount', 'errors')}">
             ￥<g:if test="${boRevocationApplyInstance?.trxtype=='void'}">-</g:if>${StringUtil.getAmountFromNum(String.valueOf(boRevocationApplyInstance.amount))}
         </td>
      </tr>

        <tr>
        <td class="right label_name"><g:message code="boRevocationApply.realamount.label"/>：</td>
          <td>
              ￥<g:if test="${boRevocationApplyInstance?.trxtype=='void'}">-</g:if>${StringUtil.getAmountFromNum(String.valueOf(boRevocationApplyInstance.realamount))}
          </td>
      </tr>


       <tr>
        <td class="right label_name"><g:message code="boRevocationApply.billmode.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'billmode', 'errors')}">
              <g:if test="${boRevocationApplyInstance?.billmode=='cashier'}">现金</g:if>
              <g:if test="${boRevocationApplyInstance?.billmode=='check'}">支票</g:if>
              <g:if test="${boRevocationApplyInstance?.billmode=='transfer'}">转账</g:if>
              <g:if test="${boRevocationApplyInstance?.billmode=='other'}">其他</g:if>
        </td>
      </tr>

         <tr>
        <td class="right label_name"><g:message code="boRevocationApply.status.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyInstance, field: 'status', 'errors')}">
               <g:if test="${boRevocationApplyInstance?.status=='Y'}">完成</g:if>
                <g:if test="${boRevocationApplyInstance?.status=='N'}">待处理</g:if>
                <g:if test="${boRevocationApplyInstance?.status=='P'}">处理中</g:if>
                <g:if test="${boRevocationApplyInstance?.status=='F'}">失败</g:if>
                <g:if test="${boRevocationApplyInstance?.status=='C'}">取消</g:if>
        </td>
      </tr>





      
      <tr>
          <g:form action="save" >
            <g:hiddenField name="id" value="${boRevocationApplyInstance?.id}"/>
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
