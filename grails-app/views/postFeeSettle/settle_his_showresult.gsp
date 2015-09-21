<!--
  To change this template, choose Tools | Templates
  and open the template in the editor.
-->

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>eere</title>
</head>
<body>
<script type="text/javascript">
    function checkMaxInput(obj) {


        var maxlength = 80;

        if (obj.value.length > maxlength) {

            obj.value = obj.value.substring(0, maxlength);

        }
    }
</script>
<h1>拒绝原因</h1>

<g:textArea cols="30" rows="20" name="reson" onkeydown="checkMaxInput(this)" onkeyup="checkMaxInput(this)" onblur="checkMaxInput(this)" value="${REJECT_REASON}" disabled="true"></g:textArea>
<br>
<div align="center">
    <input type="button" onclick="window.location.href = '${createLink(controller:'postFeeSettle', action:'settle_his_list')}'" value="返回"/>
</div>
</body>
</html>
