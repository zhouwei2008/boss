<%--
  Created by IntelliJ IDEA.
  User: SunWeiGuo
  Date: 12-6-25
  Time: 下午5:04
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="ismp.CmDynamicKey;ismp.CmCustomer" %>
<%@ page import="boss.BoCustomerService" %>
<html>
  <head><title>执照到期提示</title></head>
  <body>
        您好，${CmCustomer.findById(item1.customerId)?.name}商户的${BoCustomerService.serviceMap[item1.serviceCode]}（服务类型）合同将于${item1?.endTime}到期，请及时洽谈新的合同。

  <p style="padding-left:25px">系统自动发送邮件，请不要回复，谢谢。</p>
  <p style="padding-left:825px">吉高</p>
  </body>
</html>