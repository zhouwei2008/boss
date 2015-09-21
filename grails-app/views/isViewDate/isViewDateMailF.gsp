<%--
  Created by IntelliJ IDEA.
  User: SunWeiGuo
  Date: 12-7-11
  Time: 下午4:55
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="settle.FtTrade; settle.FtTradeFee; settle.FtSrvType; ismp.CmDynamicKey;ismp.CmCustomer" %>
<html>
  <head><title>费率到期提示</title></head>
  <body>
      您好，${CmCustomer.findByCustomerNo(item.customerNo)?.name}商户的${srvName}费率将于${item?.dateEnd}到期，请及时洽谈新的费率。
      <p style="padding-left:25px">系统自动发送邮件，请不要回复，谢谢。</p>
      <p style="padding-left:825px">吉高</p>
  </body>
</html>