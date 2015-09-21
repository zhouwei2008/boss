
<%@ page import="boss.BoAdjustType; boss.Perm; boss.BoAccountAdjustInfo" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boAccountAdjustInfo.label', default: 'BoAccountAdjustInfo')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<g:form action="save">
<g:hiddenField id="appFlag" name="appFlag"/>
<g:hiddenField id="status" name="status" value="${boAccountAdjustInfoInstance.status}"/>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
    </tr>

    <tr>
      <td class="right label_name"><g:message code="boAccountAdjustInfo.fromAccountNo.label"/>：</td>

      <td><span class="rigt_tebl_font">${fieldValue(bean: boAccountAdjustInfoInstance, field: "fromAccountNo")}</span></td>

    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAccountAdjustInfo.toAccountNo.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${fieldValue(bean: boAccountAdjustInfoInstance, field: "toAccountNo")}</span></td>
      
    </tr>

    <tr>
      <td class="right label_name">调账类型：</td>

      <td><span class="rigt_tebl_font">${BoAdjustType.get((boAccountAdjustInfoInstance.adjType ? boAccountAdjustInfoInstance.adjType : 0) as long)?.name}</span></td>

    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAccountAdjustInfo.adjustAmount.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatNumber number="${boAccountAdjustInfoInstance.adjustAmount/100}" type="currency" currencyCode="CNY"/></span></td>
      
    </tr>

    <tr>
      <td class="right label_name"><g:message code="boAccountAdjustInfo.sponsor.label"/>：</td>

      <td><span class="rigt_tebl_font">${boAccountAdjustInfoInstance.sponsor}</span></td>

    </tr>

    <tr>
      <td class="right label_name"><g:message code="boAccountAdjustInfo.sponsorTime.label"/>：</td>

      <td><span class="rigt_tebl_font"><g:formatDate date="${boAccountAdjustInfoInstance?.sponsorTime}" format="yyyy-MM-dd HH:mm:ss"/></span></td>

    </tr>

    <tr>
      <td class="right label_name"><g:message code="boAccountAdjustInfo.sIP.label"/>：</td>

      <td><span class="rigt_tebl_font">${boAccountAdjustInfoInstance.sIP}</span></td>

    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAccountAdjustInfo.remark.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${boAccountAdjustInfoInstance.remark}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAccountAdjustInfo.status.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${boss.BoAccountAdjustInfo.statusMap[boAccountAdjustInfoInstance.status]}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAccountAdjustInfo.approveTime.label"/>：</td>
      
      <td><span class="rigt_tebl_font"><g:formatDate date="${boAccountAdjustInfoInstance?.approveTime}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAccountAdjustInfo.approvePerson.label"/>：</td>
      
      <td><span class="rigt_tebl_font">${boAccountAdjustInfoInstance.approvePerson}</span></td>
      
    </tr>
    
    <tr>
      <td class="right label_name"><g:message code="boAccountAdjustInfo.approveView.label"/>：</td>
      
      <td>
          <span class="rigt_tebl_font"><g:textArea id="approveView" name="approveView" rows="5" cols="70">${boAccountAdjustInfoInstance.approveView ? boAccountAdjustInfoInstance.approveView : ""}</g:textArea></span>
      </td>
    </tr>
    
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField id="id" name="id" value="${boAccountAdjustInfoInstance?.id}"/>
            <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
            <bo:hasPerm perm="${Perm.Account_TransChk_Proc}">
            <span class="button"><input type="button" id="sPass" class="rigt_button" onclick="doApp('0')" value="通过"/></span>
            <span class="button"><input type="button" id="sRefuse" class="rigt_button" onclick="doApp('1')" value="拒绝"/></span>
             </bo:hasPerm>
        </g:form>
      </td>
    </tr>
  </table>

</div>
    </g:form>
<script type="text/javascript">
        var status = document.getElementById("status").value;
        if(status=="waitApp"){
            document.getElementById("sPass").disabled=false;
            document.getElementById("sRefuse").disabled=false;
        }else if(status=="pass" || status=="refuse"){
            document.getElementById("sPass").disabled=true;
            document.getElementById("sRefuse").disabled=true;
            document.getElementById("approveView").disabled = true;
        }
        function trim(s)
		{
			return s.replace(/(^\s*)|(\s*$)/g, "");
		}
        function doApp(nFlag)
        {
             var approveView = document.getElementById("approveView").value;
             if(trim(approveView)=="")
             {
                 alert("请输入审核信息");
                 return false;
             }else if(trim(approveView)!="" && trim(approveView).replace(/[^\x00-\xFF]/g,'**').length>1000)
             {
                 alert("审核信息最多输入1000个字符");
                 return false;
             }
             if(nFlag=="0"){
                 document.getElementById("appFlag").value="0";
                 if(!confirm("确定要通过吗？")) return false;
                 document.forms[0].submit();
             }else if(nFlag=="1"){
                 document.getElementById("appFlag").value="1";
                 if(!confirm("确定要拒绝吗？")) return false;
                 document.forms[0].submit();
             }
        }
    </script>
</body>
</html>