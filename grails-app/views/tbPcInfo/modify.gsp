

<%@ page import="dsf.TbPcInfo" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>

  <title>修改通道</title>
     <script type="text/javascript">

         function check() {

            var bank = document.getElementById("bankName");
             if (bank.value == "") {
                alert("请选择打款渠道！");
                return false;
            }
            else{
                return true
            }

        }
         </script>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${tbPcInfoInstance}">
    <div class="errors">
      <g:renderErrors bean="${tbPcInfoInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="updateDkChanel" >
    <g:hiddenField name="id" value="${tbPcInfoInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2">修改通道</th>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="批次号"/>：</td>
         <td>${tbPcInfoInstance.id}</td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="提交日期"/>：</td>
        <td> <g:formatDate date="${tbPcInfoInstance.tbPcDate}" format="yyyy-MM-dd HH:mm:ss"/></td>

      </tr>
       <tr>
        <td class="right label_name"><g:message code="笔数"/>：</td>
        <td>${tbPcInfoInstance.tbPcItems}</td>
      </tr>
        <tr>
        <td class="right label_name"><g:message code="金额"/>：</td>
        <td>
        <g:formatNumber number="${tbPcInfoInstance.tbPcAmount}" format="########################.##" />
        </td>
      </tr>
         <tr>
        <td class="right label_name"><g:message code="打款渠道"/>：</td>
        <td><g:select name="bankName" from="${bankNameList}" optionKey="id" optionValue="${{it.bank.name+'-'+it.aliasName}}" noSelection="${['':'--请选择--']}" /></td>
      </tr>
      <tr>

        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定" onclick="return check();"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
</body>
</html>
