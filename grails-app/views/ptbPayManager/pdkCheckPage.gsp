<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <title>打款手工对账</title>
    <script type="text/javascript">
        function check(){

            var file= document.getElementById('upload')

            var chanels = document.getElementById('merchantId')

            var batchId = document.getElementById('batchId')

            //var bfile=file.value.substr(file.value.lastIndexOf('.'));

            var ends = file.value.substr(file.value.lastIndexOf('.'));

            if((ends!='.txt')&&(ends!='.TXT')&&(ends!='.xls')&&(ends!='.XLS')&&(ends!='.XLSX')&&(ends!='.xlsx')&&(ends!='.csv')&&(ends!='.CSV')){
                alert("请选择正确的文件格式!");
                 return false;
             }
            if(file.value==""){
                alert("请选择对账文件!");
                return false;
            }else if (batchId.value==""||batchId.value==null){
                alert("请填写批次号!");
                return false;
            } else if (chanels.value==""){
                alert("请选择打款渠道!");
                return false;
            }else {
                document.getElementById('myTable').style.display="none";
                document.getElementById('wait').style.display="block";
                return true;
            }

        }

        function onChanelChange()
        {
            var merchantId = $("#merchantId").val()
            var tradeType = $("#tradeType").val()
            if(merchantId==''){
                document.getElementById("uploadAndCheck").style.display = 'none'
                return false;
            }
            $.ajax({
               url:'onChanelChange', //后台处理程序
               type:'post',         //数据发送方式
               dataType:'json',     //接受数据格式
               data:{
                   merchantId:merchantId,
                   tradeType:tradeType
               },                    //要传递的数据
               success:callBackChanelChange //回传函数(这里是函数名)
            });
        }
        function callBackChanelChange(data){
            var msg = null
            if(data!=null){
                if(data.autoOrHandle!=null){
                    if(data.autoOrHandle=='handle'||data.autoOrHandle=='all'){
                        document.getElementById("uploadAndCheck").style.display = 'block'
                    }else{
                        msg = '此渠道暂不支持手工对账'
                    }
                }else if(data.error!='undefined'&&data.error!=null){
                    msg = data.error
                }else{
                    msg = '此渠道暂不支持手工对账'
                }
            }else{
                msg = '此渠道暂不支持手工对账'
            }
            if(msg!=null){
                document.getElementById("uploadAndCheck").style.display = 'none'
                alert(msg)
            }

        }
    </script>
</head>
<body>
<script type="text/javascript">
    $(function(){
        onChanelChange();
    });
</script>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message" style="word-wrap: break-word;word-break:break-all;">${flash.message}</div>
  </g:if>
  <div class="right_top">
     <g:uploadForm name="myUpload" action="uploadAndCheck">
    <table id="myTable" align="center" class="rigt_tebl">
      <tr>
        <th colspan="2">打款手工对账</th>
      </tr>



      <tr>
        <td class="right label_name">选择打款通道：</td>
        <td>
            <g:select onChange="onChanelChange()" name="merchantId" from="${bankChanelList}" optionKey="${{it.MERCHANTID}}" optionValue="${{it.BANKNAME+'-'+it.ALIAS_NAME+'-'+it.SERVICECODE}}" value="${params.merchantId}" noSelection="${['':'--请选择--']}" />

        </td>
      </tr>


      <tr>
        <td class="right label_name" style="width: 30%">打款批次号：</td>
        <td>
            <input type="text" name="batchId" id="batchId" value="${params.batchId}" onKeyUp="value=value.replace(/^\s+/,'').replace(/\s+$/,'')"/>
        </td>
      </tr>

      <tr>
        <td class="right label_name">导入对账文件：</td>
        <td>
            &nbsp;<input type="file" name="upload" id="upload" />
        </td>

      </tr>

      <tr>
        <td colspan="2" align="center">
            <span class="button"><g:actionSubmit id="uploadAndCheck" class="rigt_button" action="uploadAndCheck" value="确定" onclick="return check();"/></span>
            <g:hiddenField name="tradeType" value="F"/>
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
