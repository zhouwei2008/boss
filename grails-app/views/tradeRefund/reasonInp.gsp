<%@ page import="boss.BoBankDic" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text ml; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: '退款银行选择', default: '退款银行选择')}"/>
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
                <td class="right label_name" nowrap=""><font color="red">*</font>请输入拒绝原因：</td>
                <td>
                    <g:textArea name="note" cols="10" rows="10" style="width:400px;" id="note"></g:textArea>
                </td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="content"><input type="button" onclick="checkReason('<%=request.getParameter("id")%>', '<%=request.getParameter("flag")%>')" id="button" class="rigt_button" value="确认"></span>
                    <span class="content"><input type="submit" onclick=" window.parent.win1.close();" name="button" id="button2" class="rigt_button" value="取消"></span>
                </td>
            </tr>
        </table>

    </g:form>
</div>
<script type="text/javascript">
    function checkReason(id, flag) {
        var note = document.getElementById("note").value;
        var len=document.getElementById("note").value.length;
        if(len>255){
            alert("您輸入的拒绝原因太长，请删除部分内容！");
            return false;
        }
        if (note.trim().length==0) {
            alert("您还未填写拒绝原因,请填写拒绝原因！");
            return false;
        }
        if (flag == 0) {
            //退款处理
            window.parent.location.href = '${createLink(controller:'tradeRefund', action:'checkRefused', params:['flag':'0'])}&id=' + id + '&appNote=' + note;
        } else if(flag==1){
            //单笔，单笔审批拒绝
            window.parent.location.href = '${createLink(controller:'tradeRefund', action:'endRefused', params:['flag':'1'])}&id=' + id + '&appNote='+ note;
        } else if(flag==2){
            //复核审批拒绝
            window.parent.location.href = '${createLink(controller:'tradeRefund', action:'reCheckRefused', params:['flag':'2'])}&id=' + id + '&appNote='+ note;
        }

        window.parent.win1.close();
    }
</script>
</body>
</html>