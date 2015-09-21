<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>批量上传黑名单客户</title>
    <script type="text/javascript">
        function check(){

            var file= document.getElementById('upload')

            if(file.value==""){
                alert("请选择对账文件!");
                return false;
            }

            var ends = file.value.substr(file.value.lastIndexOf('.'));

            if((ends!='.txt')&&(ends!='.TXT')&&(ends!='.xls')&&(ends!='.XLS')&&(ends!='.XLSX')&&(ends!='.xlsx')){
                alert("请选择正确的文件格式!");
                return false;
            }
        }
    </script>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message" style="word-wrap: break-word;word-break:break-all;">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <g:uploadForm name="myUpload" action="uploadBackCust">
            <table id="myTable" align="center" class="rigt_tebl">
                <tr>
                    <th colspan="2">黑名单客户上传</th>
                </tr>

                <tr>
                    <td class="right label_name">导入对账文件：</td>
                    <td>
                        &nbsp;<input type="file" name="custBackFile" id="custBackFile" />
                    </td>
                </tr>

                <tr>
                    <td colspan="2" align="center">
                        <span class="button"><g:actionSubmit id="uploadBackCust" class="rigt_button" action="uploadBackCust" value="确定" onclick="return check();"/></span>
                    </td>
                </tr>
            </table>
        </g:uploadForm>
    </div>
    <br/>
    <br/>
    <div id="wait" align="center" style="width: 20%;text-align:center;padding-left: 30%; display: none">
        <img src="${request.contextPath}/images/wait.gif" border="0"/>
        <br/>
        正在处理，处理过程可能需要几分钟<br/>
        请耐心等待……
    </div>
</div>
</body>
</html>
