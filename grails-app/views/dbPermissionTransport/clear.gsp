<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>clear permission transport db</title>
</head>
<body style="overflow-x:hidden">
<g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
</g:if>
<div>Clear permission transport db ${result ? "success" : "failed"}!</div>
</body>
</html>