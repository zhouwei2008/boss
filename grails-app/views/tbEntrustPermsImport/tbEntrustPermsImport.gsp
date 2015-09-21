<%--
  Created by IntelliJ IDEA.
  User: xypeng
  Date: 12-6-12
  Time: 上午9:38
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <meta name="layout" content="main"/>
      <title>批量导入授权账户</title>
  </head>
  <body>
     <div class="right_top">
         <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">批量导入授权账户</h1>
     </div>
     <div id="divMain">
        <g:uploadForm name="myUpload" action="permsImport">
            <br/>
            <br/>
            &nbsp; &nbsp;&nbsp;<span style="font-size: 14px">选择上传文件: </span> <input type="file" name="upload" id="upload"/>
            &nbsp; &nbsp;
            <g:actionSubmit id="permsImport" class="rigt_button" action="permsImport" value="提交"
            onClick="document.getElementById('wait').style.display='block';document.getElementById('divMain').style.display='none';return true;"/>
            <br/>
            <br/>
            <br/>
            &nbsp; &nbsp;
            <g:link style="text-decoration: underline" action="downloadTemplate">
                <strong style="font-size: 13px">批量导入模板下载</strong>
            </g:link>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>

        </g:uploadForm>
      </div>

      <div id="wait" align="center" style="width: 20%;text-align:center;padding-left: 30%; display: none">
          <br/>
          <br/>
          <br/>
          <img src="${request.contextPath}/images/wait.gif" border="0"/>
          <br/>
          正在处理，处理过程可能需要几分钟<br/>
                  请耐心等待……
      </div>

  </body>
</html>