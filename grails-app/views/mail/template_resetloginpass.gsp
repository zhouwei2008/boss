<%@ page contentType="text/html" %>
<%@ page import="ismp.CmDynamicKey" %>
<html>
<body>

<h3>欢迎使用吉高系统，请点击以下链接设置您的登录密码，登录名为：${cmCustomerOperator.defaultEmail}。登录系统后，在我的账户—>账户信息->安全设置->支付密码，设置支付密码。<br>
<a href="${grailsApplication.config.grails.ismpURL}/login/resetloginpass/${cmDynamicKey.parameter}?verification=${cmDynamicKey.verification}">
    ${grailsApplication.config.grails.ismpURL}/login/resetloginpass/${cmDynamicKey.parameter}?verification=${cmDynamicKey.verification}
</a><br><br>
    如果链接无法打开，请复制连接地址，然后在浏览器的地址栏粘帖后打开。<br>
    如果该链接失效，请访问merchant.gigold.com,点击“找回密码”，系统会重新发送确认邮件。<br>
    该邮箱不受理业务，如有任何问题请拨打客服电话：xxx-xxx-xxxx。</h3>


</body>
</html>