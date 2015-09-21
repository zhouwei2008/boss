
<%@ page import="dsf.TbPcInfo" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbPcInfo.label', default: 'TbPcInfo')}"/>
  <title>批次打款</title>
    <script type="text/javascript">
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
<script type="text/javascript">
  $(function() {
    $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });
</script>
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

        <g:sortableColumn params="${params}"  property="tbPcDate" title="${message(code: 'tbPcInfo.tbPcDate.label', default: '日期')}"/>

        <g:sortableColumn params="${params}"  property="tbPcItems" title="${message(code: 'tbPcInfo.tbPcItems.label', default: '笔数')}"/>

        <g:sortableColumn params="${params}"  property="tbPcAmount" title="${message(code: 'tbPcInfo.tbPcAmount.label', default: '金额')}"/>

        <g:sortableColumn params="${params}"  property="tbPcFee" title="${message(code: 'tbPcInfo.tbPcFee.label', default: '手续费')}"/>
        
            <g:sortableColumn params="${params}"  property="tbPcAccamount" title="${message(code: 'tbPcInfo.tbPcAccamount.label', default: '实付金额')}"/>

        <g:sortableColumn params="${params}"  property="tbPcDkChanelname" title="${message(code: 'tbPcInfo.tbPcDkChanelname.label', default: '打款通道')}"/>

          <g:sortableColumn params="${params}"  property="tbPcDkStatus" title="${message(code: 'tbPcInfo.tbPcDkStatus.label', default: '打款状态')}"/>

          <td>打款明细</td>

          <td>操作</td>
      </tr>

      <g:each in="${tbPcInfoInstanceList}" status="i" var="tbPcInfoInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          
          <td>${tbPcInfoInstance.id}</td>

             <td><g:formatDate date="${tbPcInfoInstance.tbPcDate}" format="yyyy-MM-dd HH:mm:ss"/></td>

             <td>${fieldValue(bean: tbPcInfoInstance, field: "tbPcItems")}</td>

          <td>
           <g:set var="amt" value="${tbPcInfoInstance.tbPcAmount ? tbPcInfoInstance.tbPcAmount : 0}"/>
               <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
          </td>

            <td>
                 <g:if test="${tbPcInfoInstance.tbPcFee==null}">
                   ${fieldValue(bean: tbPcInfoInstance, field: "tbPcFee")}
                     </g:if>
                 <g:if test="${tbPcInfoInstance.tbPcFee!=null}">
             <g:set var="amt" value="${tbPcInfoInstance.tbPcFee ? tbPcInfoInstance.tbPcFee : 0}"/>
               <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                    </g:if>
            </td>

            <td>
                  <g:if test="${tbPcInfoInstance.tbPcFee!=null}">
             <g:set var="amt" value="${tbPcInfoInstance.tbPcAmount ? tbPcInfoInstance.tbPcAmount : 0}"/>
               <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                      </g:if>
                  <g:if test="${tbPcInfoInstance.tbPcAccamount==null}">
                    ${fieldValue(bean: tbPcInfoInstance, field: "tbPcAccamount")}
                  </g:if>
            </td>
          
            <td>${fieldValue(bean: tbPcInfoInstance, field: "tbPcDkChanelname")}</td>

             <td>${TbPcInfo.dkStatusMap[tbPcInfoInstance.tbPcDkStatus]}</td>

             <td> <g:link action="downLoad" id="${tbPcInfoInstance.id}" > 下载</g:link></td>

           <td><g:checkBox id="box" name="box" value="${tbPcInfoInstance.id}" checked="false"  ></g:checkBox>打款</td>
        </tr>
      </g:each>
         <g:hiddenField name="ids" id="ids"/>
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
      <div style=" float:left;">共${tbPcInfoInstanceTotal}条记录</div>
      <g:paginat total="${tbPcInfoInstanceTotal}" params="${params}"/>
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
