<html>
<head>
    <meta http-equiv="Content-Type" content="text ml; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: '手续费结算', default: '手续费结算')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <link rel="stylesheet" type="text/css" href="../ext/css/ext-all.css"/>
    <link rel="stylesheet" type="text/css" href="../ext/css/style.css"/>
    <script type="text/javascript" src="../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../ext/js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ext/js/common.js"></script>
</head>
<body style="overflow-x:hidden">
<div class="main">

    <g:form>
        <table align="center" class="rigt_tebl">
            <tr>
                <td class="right label_name">拒绝原因：</td>
                <td><g:textArea name="note" value="请输入拒绝原因" onfocus="value=''" cols="3" rows="3"/></td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="content"><input type="button" onclick="checkReason(<%=request.getParameter("id")%>)" onfocus="value = ''" id="button" class="rigt_button" value="确定"></span>
                    <span class="content"><input type="submit" onclick=" window.parent.win1.close();" name="button" id="button2" class="rigt_button" value="取消"></span>
                </td>
            </tr>
        </table>

    </g:form>
</div>
<script type="text/javascript">
      function check()  {
        var flag = "<%=request.getParameter("flag")%>";
        var id = "<%=request.getParameter("flag")%>";
        if  (flag.indexOf('alert')>-1)    {
           window.parent.win1.close();
        }
        if  (id.indexOf('alert')>-1)    {
           window.parent.win1.close();
        }

    }
    function checkReason(id) {
        var url = 'list.gsp';
        if (document.getElementById("note").value == '请输入拒绝原因' || document.getElementById("note").value == '') {
            alert("请输入拒绝原因!");
        } else {
            var reason = document.getElementById("note").value;
            window.location.href = '${createLink(controller:'boVerify', action:'refuse', params:['statusFlag':'1'])}&id=' + id + '&appNote=' + reason;
//           var win = parent.Ext.getCmp('win1');win.close();
            alert("您输入的拒绝原因为" + reason);
//          window.parent.reload();
            window.parent.document.forms[0].submit();
            window.parent.win1.close();

//            window.opener.sub_win = window;
//            alert(window.parent);
//         window.parent.reload();
        }
    }
    window.onload =check();
</script>
</body>
</html>