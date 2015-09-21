<%@ page import="boss.BoAcquirerAccount; boss.Perm; boss.BoBankDic" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script language="JavaScript" type="text/javascript">
        function check() {
            if (document.getElementById("upFile").value == "") {
                alert("请选择要上传的文件!");
                document.getElementById("upFile").focus();
                return false;
            }
        }
    </script>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">上传银行回盘文件</h1>
        <div class="table_serch">
            <g:form action="upLoad" method="post" enctype="multipart/form-data">
                <g:hiddenField name="withdrawnBatchNo" value="${withdrawnBatchNo}"></g:hiddenField>
                <g:hiddenField name="bankCode" value="${bankCode}"></g:hiddenField>
                <table id='uptable'>
                    <tr>
                        <td>提现银行：</td>
                        <td>
                            %{--${boss.BoBankDic.findByCode(bankCode)?.name}--}%
                            ${BoBankDic.get(BoAcquirerAccount.get(bankCode)?.bank?.id)?.name}
                        </td>
                    </tr>
                    <tr>
                        <td>
                            提现批次号：
                        </td>
                        <td>
                            ${withdrawnBatchNo}
                        </td>
                    </tr>
                    <tr>
                        <td>回盘文件：</td>
                        <td colspan="3">
                            <input type="file" name="myFile" id="upFile"/>
                        <td>
                            <bo:hasPerm perm="${Perm.WithDraw_RfdBthChk_AutoChkUp}">
                                <g:actionSubmit class="right_top_h2_button_serch" value="上传" action="upLoad" onclick="check()"/>
                            </bo:hasPerm>
                            <span class="button"><input type="button" class="rigt_button" onclick="javascript:history.back(-1);" value="返回"/></span>
                        </td>
                    </tr>
                </table>
            </g:form>
        </div>
    </div>

        <table align="center" class="right_list_table" id="test">
            <tr><h1>对账结果:</h1></tr></br>
            <tr><h1>批次号：${withdrawnBatchNo}</h1></tr></br>
            <tr><h1>对账时间：<g:formatDate date="${new Date()}" format="yyyy-MM-dd HH:mm:ss"/></h1></tr> </br>
            <tr><h1>共处理 ${count} 记录，其中成功${count-failCount} 条，共失败${failCount}条</h1></tr> </br>
            <tr>
                <th>上传失败行数</th>
                <th>上传失败内容</th>
                <th>上传失败原因</th>
            </tr>

            <g:each in="${errorDetail}" status="i" var="errorDetailIn">
                <tr>
                    <td>${errorDetailIn.num}</td>
                    <td>${errorDetailIn.detail}</td>
                    <td>${errorDetailIn.reason}</td>
                    %{--<td>${errorDetailIn}</td>--}%
            </tr>
                </g:each>
        </table>
    <div class="paginateButtons">
            <span style=" float:left;">共${totalCount}条记录</span>
            <g:paginat total="${totalCount}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
