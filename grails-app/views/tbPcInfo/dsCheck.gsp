
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbBindBank.label', default: 'TbBindBank')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript">
        function check(){

            var file= document.getElementById('upload')

            var chanel = document.getElementById('tbPcDkChanel')
            var batch = document.getElementById('batchNo');
            var regu = "^[0-9]+$";
            var re = new RegExp(regu);
            //var bfile=file.value.substr(file.value.lastIndexOf('.'));

            var ends = file.value.substr(file.value.lastIndexOf('.'));

            if((ends!='.txt')&&(ends!='.TXT')&&(ends!='.xls')&&(ends!='.XLS')&&(ends!='.XLSX')&&(ends!='.xlsx')){
                alert("请选择正确的文件格式!");
                 return false;
             }
            if(file.value==""){
               alert("请选择对账文件!");
                return false;
            } else if (chanel.value==""){
                alert("请选择打款渠道!");
                return false;
            }else if(batch.value==""){
                 alert("请输入批次号");
                 return false;
             }else if (batch.value.search(re) == -1) {
                 alert("批次号需输入数字");
                 return false;
             }else {
                return true;
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
     <g:uploadForm name="myUpload" action="dsUpload">
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2">代收手工对账</th>
      </tr>



      <tr>
        <td class="right label_name">选择打款通道：</td>
        <td>
            <g:select name="tbPcDkChanel" from="${bankNameList}" optionKey="id" optionValue="${{it.bank.name+'-'+it.aliasName}}" noSelection="${['':'--请选择--']}" />

        </td>
      </tr>
       <tr>
        <td class="right label_name">输入对账批次：</td>
        <td>
            <input type="text" id="batchNo" name="batchNo">
        </td>
      </tr>
      <tr>
        <td class="right label_name">导入对账文件：</td>
        <td>
            <input type="hidden" name="handle" value="upload">
            <input type="file" name="upload" id="upload" />
        </td>

      </tr>

      <tr>
        <td colspan="2" align="center">
          <span class="button"><g:actionSubmit class="rigt_button" action="dsUpload" value="确定" onclick="return check();"/></span>
        </td>
      </tr>


    </table>
  </g:uploadForm>

  </div>
</div>
</body>
</html>
