<%@ page import="ebank.tools.StringUtil; boss.Perm" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boRevocationApplyApprove.label', default: 'boRevocationApplyApprove')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>

</head>
<body style="overflow-x:hidden">
<script type="text/javascript">
    $(function() {
        $("#billdate").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
    });

     function checkValid()
    {
        var a =  document.getElementById("authdesc").value
          if(a!=null&a!=''){
             if(!WidthCheck(a,250))
             {
                 alert("输入的备注框长度不能超过125个汉字或者250个字符!");
                 document.getElementById("authdesc").focus();
                 return false;
             }
          }
        return true;
    }

    function WidthCheck(s, n){
        var w = 0;
        for (var i=0; i<s.length; i++) {
          var c = s.charCodeAt(i);
           //单字节加1
          if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {
          w++;
           }
          else {
           w+=2;
          }
        }
    if (w > n) {
      return false;
    }
    return true;
}
 </script>

<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <g:hasErrors bean="${boRevocationApplyApproveInstance}">
    <div class="errors">
      <g:renderErrors bean="${boRevocationApplyApproveInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form>
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="boRevocationApplyApprove.app.label" args="[entityName]"/></th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.account.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'accountNo', 'errors')}">
            ${fieldValue(bean: boRevocationApplyApproveInstance, field: "accountNo")}
        </td>
      </tr>
        <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.accountName.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'accountName', 'errors')}">
            ${fieldValue(bean: boRevocationApplyApproveInstance, field: "accountName")}
        </td>
      </tr>
       <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.trxtype.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'trxtype', 'errors')}">
            <g:if test="${boRevocationApplyApproveInstance?.trxtype=='charge'}">充值</g:if>
            <g:if test="${boRevocationApplyApproveInstance?.trxtype=='void'}">充值撤销</g:if>
        </td>
      </tr>

        <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.branchname.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'branchname', 'errors')}">
            ${fieldValue(bean: boRevocationApplyApproveInstance, field: "branchname")}
        </td>
      </tr>

        <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.createtime.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'createdate', 'errors')}">

             <g:formatDate date="${boRevocationApplyApproveInstance.createdate}" format="yyyy-MM-dd HH:mm:ss"/>
        </td>
      </tr>

       <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.apptime.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'authdate', 'errors')}">

             <g:formatDate date="${boRevocationApplyApproveInstance.authdate}" format="yyyy-MM-dd HH:mm:ss"/>
        </td>
      </tr>

          <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.authsts.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'authsts', 'errors')}">
                <g:if test="${boRevocationApplyApproveInstance?.authsts=='N'}">待审核</g:if>
                <g:if test="${boRevocationApplyApproveInstance?.authsts=='P'}">审核中</g:if>
                <g:if test="${boRevocationApplyApproveInstance?.authsts=='Y'}">审核通过</g:if>
                <g:if test="${boRevocationApplyApproveInstance?.authsts=='F'}">审核拒绝</g:if>
        </td>
      </tr>

          <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.authdesc.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'authdesc', 'errors')}">
            ${fieldValue(bean: boRevocationApplyApproveInstance, field: "authdesc")}
        </td>
      </tr>

       <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.creator.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'creator_name', 'errors')}">
            ${fieldValue(bean: boRevocationApplyApproveInstance, field: "creator_name")}
        </td>
      </tr>

          <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.author.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'author_name', 'errors')}">
            ${fieldValue(bean: boRevocationApplyApproveInstance, field: "author_name")}
        </td>
      </tr>

        <tr>
          <td class="right label_name"><g:message code="boRevocationApplyApprove.trxsqe.label"/>：</td>
            <td>
                ${fieldValue(bean: boRevocationApplyApproveInstance, field: "trxSeq")}
            </td>
      </tr>

        <tr>
             <td class="right label_name"><g:message code="boRevocationApplyApprove.oldsqe.label"/>：</td>
                  <td>
                      ${fieldValue(bean: boRevocationApplyApproveInstance, field: "oldSeq")}
                       <g:hiddenField name="oldSeq" value="${boRevocationApplyApproveInstance?.oldSeq}"/>
                  </td>
            </tr>
      <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.amount.label"/>：</td>
         <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'amount', 'errors')}">
             ￥<g:if test="${boRevocationApplyApproveInstance?.trxtype=='void'}">-</g:if>${StringUtil.getAmountFromNum(String.valueOf(boRevocationApplyApproveInstance.amount))}
         </td>
      </tr>

        <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.realamount.label"/>：</td>
          <td>
              ￥<g:if test="${boRevocationApplyApproveInstance?.trxtype=='void'}">-</g:if>${StringUtil.getAmountFromNum(String.valueOf(boRevocationApplyApproveInstance.realamount))}
          </td>
      </tr>


       <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.billmode.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'billmode', 'errors')}">
              <g:if test="${boRevocationApplyApproveInstance?.billmode=='cashier'}">现金</g:if>
              <g:if test="${boRevocationApplyApproveInstance?.billmode=='check'}">支票</g:if>
              <g:if test="${boRevocationApplyApproveInstance?.billmode=='transfer'}">转账</g:if>
              <g:if test="${boRevocationApplyApproveInstance?.billmode=='other'}">其他</g:if>
        </td>
      </tr>

         <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.status.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'status', 'errors')}">
               <g:if test="${boRevocationApplyApproveInstance?.status=='Y'}">完成</g:if>
                <g:if test="${boRevocationApplyApproveInstance?.status=='N'}">待处理</g:if>
                <g:if test="${boRevocationApplyApproveInstance?.status=='P'}">处理中</g:if>
                <g:if test="${boRevocationApplyApproveInstance?.status=='F'}">失败</g:if>
                <g:if test="${boRevocationApplyApproveInstance?.status=='C'}">取消</g:if>
        </td>
      </tr>
        <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.recepit.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'recepit', 'errors')}">
            ${boRevocationApplyApproveInstance?.recepit}
        </td>
      </tr>
          <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.billref.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'billref', 'errors')}">
             ${boRevocationApplyApproveInstance?.billref}
        </td>
      </tr>

            <tr>
        <td class="right label_name"><g:message code="boRevocationApplyApprove.billdate.label"/>：</td>
        <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'billdate', 'errors')}">
                  ${boRevocationApplyApproveInstance?.billdate}
        </td>
      </tr>

        <tr>
           <td class="right label_name"><g:message code="boRevocationApplyApprove.authdesc.label"/>：</td>
           <td class="${hasErrors(bean: boRevocationApplyApproveInstance, field: 'authdesc', 'errors')}">
               <g:textArea name="authdesc" maxlength="100" rows="5" cols="6" value="${boRevocationApplyApproveInstance?.authdesc}" onblur="checkValid()"/>
           </td>
         </tr>
      <tr>
            <g:hiddenField name="id" value="${boRevocationApplyApproveInstance?.id}"/>
            <td colspan="2" align="center">
              <span class="button"><g:actionSubmit class="rigt_button" action="goback" value="返回"/></span>
              <span class="button"><bo:hasPerm perm="${Perm.TravelCard_ReCharge_CanApp_pass}"><g:actionSubmit class="rigt_button" action="appsave" value="通过"/></bo:hasPerm></span>
              <span class="button"><bo:hasPerm perm="${Perm.TravelCard_ReCharge_CanApp_refuse}"><g:actionSubmit class="rigt_button" action="refuse" value="拒绝"/></bo:hasPerm></span>
            </td>

      </tr>
    </table>
   </g:form>

</div>
</body>
</html>
