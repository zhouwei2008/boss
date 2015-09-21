<%--
  Created by IntelliJ IDEA.
  User: edward
  Date: 12-4-5
  Time: 下午2:12
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="ismp.TradeRefundController; ismp.TradeBase; ismp.TradeRefund; refund.AlipayService" contentType="text/html;charset=UTF-8" %>
<html>
  <head><title>Simple GSP page</title></head>
  <body>
    <script type="javascript">
          <%
              TradeRefundController trc = new TradeRefundController();
              String sHtmlText = trc.subBank(params.id);
              println sHtmlText;
              out.println(sHtmlText);
          %>
    </script>
  </body>
</html>