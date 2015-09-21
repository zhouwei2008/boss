<%@ page import="boss.Perm; boss.BoBankDic; ismp.AcquireSynTrx" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'acquireSynTrx.label', default: 'AcquireSynTrx')}"/>
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
        $("#upLoadDate").datepicker({ dateFormat: 'yymmdd', changeMonth: true });
    });
    function checkUpLoad() {
        if (document.getElementById("bankName").value.length == 0) {
            alert("请选择银行名称!");
            document.getElementById("bankName").focus();
            return false;
        }
        else if (document.getElementById("myFile").value == "") {
            alert("请选择要上传的文件!");
//            document.getElementById("bankName").focus();
            return false;
        }
    }
    function checkDownLoad() {
        if (document.getElementById("upLoadDate").value.length == 0) {
            alert("请选择上传时间!");
            document.getElementById("upLoadDate").focus();
            return false;
        }
        else if (document.getElementById("bankName").value.length == 0) {
            alert("请选择银行名称!");
            document.getElementById("bankName").focus();
            return false;
        }
        else {
            var bankName = document.getElementById("bankName").value;
            var upLoadDate = document.getElementById("upLoadDate").value;
            window.location.href = '${createLink(controller:'acquireSynTrx', action:'showUpLoad', params:['flag':'1'])}&bankName=' + bankName.toUpperCase() + '&upLoadDate=' + upLoadDate;
        }
    }
    function checkBank() {
        if (document.getElementById("upLoadDate").value.length == 0) {
            alert("请选择上传时间!");
            document.getElementById("upLoadDate").focus();
            return false;
        }
        else if (document.getElementById("bankName").value.length == 0) {
            alert("请选择银行名称!");
            document.getElementById("bankName").focus();
            return false;
        }
        else {
            var bankName = document.getElementById("bankName").value;
            var upLoadDate = document.getElementById("upLoadDate").value;
            window.location.href = '${createLink(controller:'acquireSynTrx', action:'showGetBank', params:['flag':'1'])}&bankName=' + bankName.toUpperCase() + '&upLoadDate=' + upLoadDate;
        }
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form action="upLoad" onsubmit="return checkUpLoad()" method="post" enctype="multipart/form-data">
                <tr>
                    <td width=100>上传时间<font color="red">*</font>：</td>
                    <td>
                        <g:textField name="upLoadDate" id="upLoadDate"  onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.upLoadDate}" class="right_top_h2_input"/>
                    </td>
                    <td width=100>银行名称<font color="red">*</font>：</td>
                    <td>
                        <g:select name="bankName" from="${BoBankDic.findAll()}" value="${params.bankName}" optionKey="code" optionValue="name" noSelection="${['':'-请选择-']}"/>
                    </td>
                    <td width=100>导入：</td>
                    <td>
                        <input type="file" name="myFile" id="myFile"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <bo:hasPerm perm="${Perm.Gworder_Sync_UpLoad}"><input type="submit" class="right_top_h2_button_tj" value="文件上传"/></bo:hasPerm>
                        <bo:hasPerm perm="${Perm.Gworder_Sync_DownLoad}"><input type="button" class="right_top_h2_button_tj" onclick="checkBank();" value="文件下载"/></bo:hasPerm>
                        <input type="button" class="right_top_h2_button_tj" onclick="checkDownLoad();" value="查询"/>
                        %{--<a href='applylist' class='zPushBtn'><img src="${resource(dir: 'images/icons', file: 'icon400a8.gif')}" width="20" height="20"/><b>取消&nbsp;</b></a>--}%
                    </td>
                </tr>

            </g:form>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="id" title="${message(code: 'acquireSynTrx.id.label', default: 'Id')}"/>

                <g:sortableColumn params="${params}" property="acquireAuthcode" title="${message(code: 'acquireSynTrx.acquireCode.label', default: 'Acquire Code')}"/>

                <g:sortableColumn params="${params}" property="acquireCardnum" title="${message(code: 'acquireSynTrx.acquireCardnum.label', default: 'Acquire Cardnum')}"/>

                <g:sortableColumn params="${params}" property="acquireDate" title="${message(code: 'acquireSynTrx.acquireDate.label', default: 'Acquire Date')}"/>

                <g:sortableColumn params="${params}" property="acquireRefnum" title="${message(code: 'acquireSynTrx.acquireRefnum.label', default: 'Acquire Refnum')}"/>

                <g:sortableColumn params="${params}" property="acquireSeq" title="${message(code: 'acquireSynTrx.acquireSeq.label', default: 'Acquire Seq')}"/>

                <g:sortableColumn params="${params}" property="id" title="${message(code: 'acquireSynTrx.createDate.label', default: 'CreateDate')}"/>

                <g:sortableColumn params="${params}" property="acquireAuthcode" title="${message(code: 'acquireSynTrx.trxsts.label', default: 'Trxsts')}"/>

                <g:sortableColumn params="${params}" property="acquireCardnum" title="${message(code: 'acquireSynTrx.amount.label', default: 'Amount')}"/>

                <g:sortableColumn params="${params}" property="acquireDate" title="${message(code: 'acquireSynTrx.batchnum.label', default: 'Batchnum')}"/>

                <g:sortableColumn params="${params}" property="acquireRefnum" title="${message(code: 'acquireSynTrx.payerIp.label', default: 'Payer Ip')}"/>

                %{--<g:sortableColumn params="${params}" property="acquireSeq" title="${message(code: 'acquireSynTrx.trxid.label', default: 'trxid')}"/>--}%

            </tr>

            <g:each in="${acquireSynTrxInstanceList}" status="i" var="acquireSynTrxInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td>
                      <g:if test="${bo.hasPerm(perm:Perm.Gworder_Sync_View){true}}" ><g:link action="show" id="${acquireSynTrxInstance.id}">${acquireSynTrxInstance.id.toString().replace(',','')}</g:link></g:if>
                      <g:else>${acquireSynTrxInstance.id.toString().replace(',','')}</g:else>
                    </td>

                    <td>${fieldValue(bean: acquireSynTrxInstance, field: "acquireCode")}</td>

                    <td>${fieldValue(bean: acquireSynTrxInstance, field: "acquireCardnum")}</td>

                    <td>${fieldValue(bean: acquireSynTrxInstance, field: "acquireDate")}</td>

                    <td>${fieldValue(bean: acquireSynTrxInstance, field: "acquireRefnum")}</td>

                    <td>${fieldValue(bean: acquireSynTrxInstance, field: "acquireSeq")}</td>

                    <td>${acquireSynTrxInstance.createDate}</td>

                    <td>${AcquireSynTrx.trxstsMap[acquireSynTrxInstance.trxsts]}</td>

                    <td><g:formatNumber number="${acquireSynTrxInstance?.amount?acquireSynTrxInstance?.amount / 100:0}" type="currency" currencyCode="CNY"></g:formatNumber></td>

                    <td>${fieldValue(bean: acquireSynTrxInstance, field: "batchnum")}</td>

                    <td>${fieldValue(bean: acquireSynTrxInstance, field: "payerIp")}</td>

                    %{--<td>${fieldValue(bean: acquireSynTrxInstance, field: "trxid")}</td>--}%
                </tr>
            </g:each>
            <tr align="left">
                <td colspan="11" style="text-align:right;" align="left">
                  <bo:hasPerm perm="${Perm.Gworder_Sync_Export}" ><g:link action="downloadList">文件导出</g:link></bo:hasPerm>
                </td>
            </tr>
        </table>
         合计：金额总计：<g:formatNumber number="${totalAmount?totalAmount/100:0}" format="#.##"/>元
        <div class="paginateButtons">
            <span style=" float:left;">共${acquireSynTrxInstanceTotal}条记录</span>
            <g:paginat total="${acquireSynTrxInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
