<%@ page import="pay.PtbPayBatch" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbPcInfo.label', default: 'TbPcInfo')}"/>
  <title>批次打款</title>
    <script type="text/javascript">
        parent.hideWait();
        function selectCheck() {
            var len = document.getElementsByName("box").length;
            var ids="";
            var flag = 0;
            for (i = 0; i < len; i++) {
                if (document.getElementsByName("box")[i].checked) {
                    ids=ids+document.getElementsByName("box")[i].value+",";
                    flag = 1;
                }
            }

            document.getElementById("ids").value=ids;

            if (flag == 0) {
                alert("请选择批次！");
                return false;
            }
            else {
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
      <g:form>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">批次打款</h1>
    <h2>

    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        
        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'tbPcInfo.id.label', default: '批次号')}"/>

        <g:sortableColumn params="${params}"  property="batchDate" title="${message(code: 'tbPcInfo.tbPcDate.label', default: '日期')}"/>

        <g:sortableColumn params="${params}"  property="batchCount" title="${message(code: 'tbPcInfo.tbPcItems.label', default: '笔数')}"/>

        <g:sortableColumn params="${params}"  property="batchAmount" title="${message(code: 'tbPcInfo.tbPcAmount.label', default: '金额')}"/>

        <g:sortableColumn params="${params}"  property="tbPcDkChanelname" title="${message(code: 'tbPcInfo.tbPcDkChanelname.label', default: '打款通道')}"/>

          <g:sortableColumn params="${params}"  property="tbPcDkStatus" title="${message(code: 'tbPcInfo.tbPcDkStatus.label', default: '打款状态')}"/>

          <td>打款明细</td>

          <td>操作</td>
      </tr>

      <g:each in="${ptbPayBatchList}" status="i" var="ptbPayBatch">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          
          <td>${ptbPayBatch.id}</td>

             <td><g:formatDate date="${ptbPayBatch.batchDate}" format="yyyy-MM-dd HH:mm:ss"/></td>

             <td>${fieldValue(bean: ptbPayBatch, field: "batchCount")}</td>

          <td>
           <g:set var="amt" value="${ptbPayBatch.batchAmount ? ptbPayBatch.batchAmount : 0}"/>
               <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
          </td>


          
            <td>${fieldValue(bean: ptbPayBatch, field: "batchChanelname")}</td>

             <td>${PtbPayBatch.BatchStatusMap[ptbPayBatch.batchStatus]}</td>

             <td> <g:link action="downLoad" params="[id:ptbPayBatch.id]"> 下载</g:link></td>

           <td><g:checkBox id="box" name="box" value="${ptbPayBatch.id}" checked="false"  ></g:checkBox>打款</td>
        </tr>
      </g:each>
         <g:hiddenField name="ids" id="ids"/>
         <g:hiddenField id="allIds" name="allIds" value="${allIds}"/>
    </table>

           <table align="center">
                <tr>&nbsp;</tr>
                <tr>
                    <td align="center">

                        <g:actionSubmit id="submit" align="center" class="right_top_h2_button_tj" action="confirm" value="确定" onclick="return selectCheck();"/>
                    </td>
                </tr>
            </table>

       </g:form>
    <div class="paginateButtons">
      <div style=" float:left;">共${ptbPayBatchTotal}条记录</div>
      <g:paginat total="${ptbPayBatchTotal}" params="${params}"/>
    </div>
  </div>
</div>
<script type="text/javascript">
    document.onkeydown=function(){
        if(document.activeElement.className!="right_top_h2_input"){
        if((event.keyCode==8)||(event.keyCode==116)||(event.ctrlKey && event.keyCode==82)) {
            event.keyCode=0;
            event.returnValue=false;
        }
      }
    };
    document.oncontextmenu=function(){
        return false;
    }
    function nocontextmenu(){
        if(document.all) {
            event.cancelBubble=true;
            event.returnvalue=false;
            return false;
        }
    }
</script>
</body>
</html>
