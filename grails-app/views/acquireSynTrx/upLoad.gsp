<%@ page import="boss.BoBankDic; ismp.AcquireSynTrx;" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'acSequential.label', default: 'AcSequential')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body onload="init()">

<script type="text/javascript">
    function init() {
    <g:if test="${flash.message}">
        alert("${flash.message}");
    </g:if>
    }
    $(function() {
        $("#upLoadDate").datepicker({ dateFormat: 'yy-mm-dd', changeMonth: true });
    });
    function checkUpLoad() {
        document.getElementById("projectLogoPath").value.length
        if (document.getElementById("projectLogoPath").value == "") {
            alert("请选择要上传的文件!");
            return false;
        }
        else if (document.getElementById("projectLogoPath").value.substring(document.getElementById("projectLogoPath").value.lastIndexOf('.') + 1) != "xls"
                && document.getElementById("projectLogoPath").value.substring(document.getElementById("projectLogoPath").value.lastIndexOf('.') + 1) != "xlsx") {
            alert("上传文件扩展名必须为 .xls、.xlsx");
            return false;
        }
    }
</script>

<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>

        <g:form action="upLoad" onsubmit="return checkUpLoad()" method="post" enctype="multipart/form-data">

            <table align="center" class="right_list_table" id="test">
                <tr>
                    <td width=100>导入：</td>
                    <td>
                        <input type="file" name="myFile"/>
                    </td>
                    <td width=100>上传时间：<font color="red">*</font></td>
                    <td>
                        <g:textField name="upLoadDate"  onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.upLoadDate}" class="right_top_h2_input"/>
                    </td>
                    <td width=100>银行名称：<font color="red">*</font></td>
                    <td>
                        <g:select name="bankName" from="${BoBankDic.findAll()}" optionKey="code" optionValue="name" noSelection="${['':'-请选择-']}"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="submit" onclick="checkUpLoad();" value="上传"/>
                        %{--<a href='applylist' class='zPushBtn'><img src="${resource(dir: 'images/icons', file: 'icon400a8.gif')}" width="20" height="20"/><b>取消&nbsp;</b></a>--}%
                    </td>
                </tr>
            </table>
            <table align="center" class="right_list_table" id="test">
                <tr>

                    <g:sortableColumn params="${params}" property="id" title="${message(code: 'acquireSynTrx.id.label', default: 'Id')}"/>

                    <g:sortableColumn params="${params}" property="acquireAuthcode" title="${message(code: 'acquireSynTrx.acquireAuthcode.label', default: 'Acquire Authcode')}"/>

                    <g:sortableColumn params="${params}" property="acquireCardnum" title="${message(code: 'acquireSynTrx.acquireCardnum.label', default: 'Acquire Cardnum')}"/>

                    <g:sortableColumn params="${params}" property="acquireDate" title="${message(code: 'acquireSynTrx.acquireDate.label', default: 'Acquire Date')}"/>

                    <g:sortableColumn params="${params}" property="acquireRefnum" title="${message(code: 'acquireSynTrx.acquireRefnum.label', default: 'Acquire Refnum')}"/>

                    <g:sortableColumn params="${params}" property="acquireSeq" title="${message(code: 'acquireSynTrx.acquireSeq.label', default: 'Acquire Seq')}"/>

                </tr>

                <g:each in="${acquireSynTrxInstanceList}" status="i" var="acquireSynTrxInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                        <td>${fieldValue(bean: acquireSynTrxInstance, field: "acquireAuthcode")}</td>

                        <td>${fieldValue(bean: acquireSynTrxInstance, field: "acquireCardnum")}</td>

                        <td>${fieldValue(bean: acquireSynTrxInstance, field: "acquireDate")}</td>

                        <td>${fieldValue(bean: acquireSynTrxInstance, field: "acquireRefnum")}</td>

                        <td>${fieldValue(bean: acquireSynTrxInstance, field: "acquireSeq")}</td>

                        <td><g:formatDate date="${acquireSynTrxInstance.createDate}" format="yyyy-MM-dd"/></td>

                        <td>${AcquireSynTrx.trxstsMap[acquireSynTrxInstance.trxsts]}</td>

                        <td>${acquireSynTrxInstance.amount / 100}</td>

                        <td>${fieldValue(bean: acquireSynTrxInstance, field: "batchnum")}</td>

                        <td>${fieldValue(bean: acquireSynTrxInstance, field: "payerIp")}</td>

                        <td>${fieldValue(bean: acquireSynTrxInstance, field: "trxid")}</td>
                    </tr>
                </g:each>
            </table>
        </g:form>
    </div>
</div>
</body>
</html>
