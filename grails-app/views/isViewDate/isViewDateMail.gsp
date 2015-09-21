<%--
  Created by IntelliJ IDEA.
  User: SunWeiGuo
  Date: 12-6-25
  Time: 下午3:02
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="ismp.CmDynamicKey" %>
<%@ page import="ismp.CmCustomer;ismp.CmCorporationInfo" %>
<html>
  <head><title>执照到期提示</title></head>
  <body>
        您好,${item?.name}商户的营业执照将于${item?.licenseExpires}到期，请及时更新营业执照。

  <p style="padding-left:25px">系统自动发送邮件，请不要回复，谢谢。</p>
  <p style="padding-left:825px">吉高</p>
  </body>
</html>