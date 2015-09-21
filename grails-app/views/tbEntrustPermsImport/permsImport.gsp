<%--
  Created by IntelliJ IDEA.
  User: xypeng
  Date: 12-6-13
  Time: 下午1:59
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <meta name="layout" content="main"/>
      <title>授权账户批量导入结果显示</title>
      <style type="text/css">
          .err_list_table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 5px;
    border: solid 1px #ccc;
    height: auto;
    table-layout:fixed;
}

.err_list_table tr th {
    height: 25px;
    text-align: center;
    background: #eeeeee;
    font-weight: bold;
    color: #656565;
    border-collapse: collapse;
    border: solid 1px #d1d1d1;
    line-height: 25px;
    padding: 3px 3px;
}

.err_list_table tr td {
    word-wrap:break-word;
    word-break:break-all;
    border: solid 1px #dadada;
    padding: 6px 6px;
}
      </style>
  </head>
  <body>
  <div style="width: 96%;height: auto;float: left;margin-left: 1%;margin-bottom: 10px;border-bottom: 1px #ccc dashed;">
      <br/>
      &nbsp;&nbsp;<strong>授权账户批量导入结果</strong>
      <br/>
      <br/>
  </div>
  <div style="width: 96%;height: auto;float: left;margin-left: 1%;margin-bottom: 10px;">
      导入结果：
      <g:if test="${result=='导入成功!'}">
           <span style="color: green;">${result}</span>
      </g:if><g:else>
           <span style="color: red;">${result}</span>
      </g:else>
      <br/><br/>
      上传文件名：${filename}<br/><br/>
      <g:if test="${totalNum!=null&&totalNum>0}">
           总记录：${totalNum}<br/><br/>
      </g:if>
      <g:if test="${addNum!=null&&addNum>0}">
           新增：${addNum}<br/><br/>
      </g:if>
      <g:if test="${updateNum!=null&&updateNum>0}">
           更新：${updateNum}<br/><br/>
      </g:if>
      <g:if test="${errMsg!=null&&errMsg!=''}">
           错误信息：<span style="color: red">${errMsg}<br/><br/></span>
      </g:if>
      <g:elseif test="${errNum!=null&&errNum>0}">
          错误记录：<span style="color: red">${errNum}<br/><br/></span>
          <div>
                 <table align="center" class="err_list_table">
              <tr>
                  <th style="width: 3%;">序号</th>
                  <th style="width: 5%;">开户名</th>
                  <th style="width: 7%;">开户银行</th>
                  <th style="width: 10%;">开户账户</th>
                  <th style="width: 7%;">代扣协议号</th>
                  <th style="width: 6%;">授权日期</th>
                  <th style="width: 6%;">截止日期</th>
                  <th style="width: 6%;">账户类型</th>
                  <th style="width: 6%;">证件类型</th>
                  <th style="width: 10%;">证件号</th>
                  <th style="width: 10%;">所属商户</th>
                  <th>错误信息</th>
              </tr>
              <g:each in="${tbEntrustPermErrList}" status="i" var="tbEntrustPermEO">
                  <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                       <td>${tbEntrustPermEO.seqNo}</td>
                      <td>${tbEntrustPermEO.cardname}</td>
                      <td>${tbEntrustPermEO.accountname}</td>
                      <td>${tbEntrustPermEO.cardnum}</td>
                      <td>${tbEntrustPermEO.entrustUsercode}</td>
                      <td>${tbEntrustPermEO.entrustStarttime}</td>
                      <td>${tbEntrustPermEO.entrustEndtime}</td>
                      <td>${tbEntrustPermEO.accounttype}</td>
                      <td>${tbEntrustPermEO.certificateType}</td>
                      <td>${tbEntrustPermEO.certificateNum}</td>
                      <td>${tbEntrustPermEO.customerNo}</td>
                      <td style="color: red">${tbEntrustPermEO.checkMsg}</td>
                  </tr>
              </g:each>
          </table>
          </div>
      </g:elseif>


  </div>
  <div style="width: 96%;text-align: right;">
      <g:form>
        <span class="button"><g:actionSubmit class="rigt_button" action="tbEntrustPermsImport" value="返回" onclick="return true"/></span>
      </g:form>
      <br/>
      <br/>
      <br/>
  </div>


  </body>
</html>