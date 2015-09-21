<%@ page import="boss.Perm; ismp.MapiAsyncNotify" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'mapiAsyncNotify.label', default: 'MapiAsyncNotify')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <link rel="stylesheet" type="text/css" href="../ext/css/ext-all.css"/>
    <link rel="stylesheet" type="text/css" href="../ext/css/style.css"/>
    <script type="text/javascript" src="../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../ext/js/ext-all.js"></script>
    %{--<script type="text/javascript" src="../ext/js/ext-lang-zh_CN.js"></script>--}%
    <script type="text/javascript" src="../ext/js/common.js"></script>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#startLastUpdated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endLastUpdated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#startNotifyTime").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endNotifyTime").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
    });
    function checkDate() {
        if (!document.getElementById('endDateCreated').value.length == 0) {
            var startDateCreated = document.getElementById('startDateCreated').value;
            var endDateCreated = document.getElementById('endDateCreated').value;
            if (Number(startDateCreated > endDateCreated)) {
                alert('创建开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }
        if (!document.getElementById('endLastUpdated').value.length == 0) {
            var startLastUpdated = document.getElementById('startLastUpdated').value;
            var endLastUpdated = document.getElementById('endLastUpdated').value;
            if (Number(startLastUpdated > endLastUpdated)) {
                alert("更新开始时间不能大于结束时间!");
                document.getElementById('endLastUpdated').focus();
                return false;
            }
        }
        if (!document.getElementById('endNotifyTime').value.length == 0) {
            var startNotifyTime = document.getElementById('startNotifyTime').value;
            var endNotifyTime = document.getElementById('endNotifyTime').value;
            if (Number(startNotifyTime > endNotifyTime)) {
                alert("通知开始时间不能大于结束时间!");
                document.getElementById('endNotifyTime').focus();
                return false;
            }
        }
    }

     /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startDateCreated = document.getElementById('startDateCreated').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endDateCreated').value.replace(/-/g,"//");
        var startLastUpdated = document.getElementById('startLastUpdated').value.replace(/-/g,"//");
        var endLastUpdated = document.getElementById('endLastUpdated').value.replace(/-/g,"//");
        var startNotifyTime = document.getElementById('startNotifyTime').value.replace(/-/g,"//");
        var endNotifyTime = document.getElementById('endNotifyTime').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('创建开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }
        if (endLastUpdated.length != 0) {
            if (Number(startLastUpdated > endLastUpdated)) {
                alert('更新开始时间不能大于结束时间!');
                document.getElementById('endLastUpdated').focus();
                return false;
            }
        }
         if (endNotifyTime.length != 0) {
            if (Number(startNotifyTime > endNotifyTime)) {
                alert('通知开始时间不能大于结束时间!');
                document.getElementById('endNotifyTime').focus();
                return false;
            }
        }
        // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectF=new Date(startDateCreated);
        var dSelectT=new Date(endDateCreated);
        var theFromM=dSelectF.getMonth();
        var theFromD=dSelectF.getDate();
        // 设置起始日期加一个月
          theFromM += 1;
          dSelectF.setMonth(theFromM,theFromD);
          if( dSelectF < dSelectT)
          {
              alert('每次只能查询1个月范围内的数据!');
              return false;
          }

         // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectFh=new Date(startLastUpdated);
        var dSelectTh=new Date(endLastUpdated);
        var theFromMh=dSelectFh.getMonth();
        var theFromDh=dSelectFh.getDate();
        // 设置起始日期加一个月
          theFromMh += 1;
          dSelectFh.setMonth(theFromMh,theFromDh);
          if( dSelectFh < dSelectTh)
          {
              alert('每次只能查询1个月范围内的数据!');
              return false;
          }

        // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectFhn=new Date(startNotifyTime);
        var dSelectThn=new Date(endNotifyTime);
        var theFromMhn=dSelectFhn.getMonth();
        var theFromDhn=dSelectFhn.getDate();
        // 设置起始日期加一个月
          theFromMhn += 1;
          dSelectFhn.setMonth(theFromMhn,theFromDhn);
          if( dSelectFhn < dSelectThn)
          {
              alert('每次只能查询1个月范围内的数据!');
              return false;
          }
    }
        function empty() {
        $(':input') .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
        return false;
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <div class="table_serch">
            <table>
                <g:form>
                    <tr>
                        <td>${message(code: '订单号')}：</td>
                        <td><g:textField name="orderNum" onblur="value=value.replace(/[ ]/g,'')" value="${params.orderNum}" class="right_top_h2_input"/></td>
                        <td>${message(code: '订单主题')}：</td>
                        <td><p><g:textField name="subject" value="${params.subject}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input"/></p></td>
                        <td>${message(code: '订单说明')}：</td>
                        <td><p><g:textField name="bodys" value="${params.bodys}" class="right_top_h2_input" onblur="value=value.replace(/[ ]/g,'')"/></p></td>
                    </tr>
                    <tr>
                        <td>${message(code: '总金额')}：</td>
                        <td><g:textField name="amount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.amount}" class="right_top_h2_input"/></td>
                        <td>${message(code: 'mapiAsyncNotify.dateCreated.label')}：</td>
                        <td><g:textField name="startDateCreated" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.startDateCreated}" class="right_top_h2_input"/>--<g:textField name="endDateCreated" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.endDateCreated}" onchange="checkDate()" class="right_top_h2_input"/></td>
                        <td>${message(code: 'mapiAsyncNotify.lastUpdated.label')}：</td>
                        <td><g:textField name="startLastUpdated" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.startLastUpdated}" onchange="checkDate()" class="right_top_h2_input"/>-- <g:textField name="endLastUpdated" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.endLastUpdated}" onchange="checkDate()" class="right_top_h2_input"/></td>
                    </tr>
                    <tr>
                        <td>${message(code: 'mapiAsyncNotify.notifyMethod.label')}：</td>
                        <td><p><g:select name="notifyMethod" value="${params.notifyMethod}" from="${MapiAsyncNotify.notifyMethodMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'mapiAsyncNotify.notifyAddress.label')}：</td>
                        <td><p><g:textField name="notifyAddress" value="${params.notifyAddress}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'mapiAsyncNotify.notifyTime.label')}：</td>
                        <td><g:textField name="startNotifyTime" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.startNotifyTime}" class="right_top_h2_input"/>--<g:textField name="endNotifyTime" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.endNotifyTime}" class="right_top_h2_input"/></td>
                    </tr>
                    <tr>
                        <td>${message(code: 'mapiAsyncNotify.status.label')}：</td>
                        <td><p><g:select name="status" value="${params.status}" from="${MapiAsyncNotify.statusMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'mapiAsyncNotify.response.label')}：</td>
                        <td><g:textField name="response" value="${params.amount}" class="right_top_h2_input"/></td>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkDate()"/></td>
                        <td><g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/></td>
                    </tr>
                %{--<g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载"/>--}%
                </g:form>
            </table>
        </div>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="orderNum" title="${message(code: '订单号', default: '订单号')}"/>

                <g:sortableColumn params="${params}" property="response" title="${message(code: 'mapiAsyncNotify.response.label', default: 'Response')}"/>

                %{--<g:sortableColumn params="${params}" property="price" title="${message(code: '商品单价', default: '商品单价')}"/>--}%

                %{--<g:sortableColumn params="${params}" property="subject" title="${message(code: '订单主题', default: '订单主题')}"/>--}%

                %{--<g:sortableColumn params="${params}" property="bodys" title="${message(code: '订单说明l', default: '订单说明')}"/>--}%

                <g:sortableColumn params="${params}" property="amount" title="${message(code: '总金额', default: '总金额')}"/>

                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'mapiAsyncNotify.dateCreated.label', default: 'DateCreated Type')}"/>

                <g:sortableColumn params="${params}" property="lastUpdated" title="${message(code: 'mapiAsyncNotify.lastUpdated.label', default: 'LastUpdated Type')}"/>

                <g:sortableColumn params="${params}" property="notifyMethod" title="${message(code: 'mapiAsyncNotify.notifyMethod.label', default: 'NotifyMethod Type')}"/>

                <g:sortableColumn params="${params}" property="notifyAddress" title="${message(code: 'mapiAsyncNotify.notifyAddress.label', default: 'NotifyAddress Type')}"/>

                %{--<g:sortableColumn params="${params}" property="notifyContents" title="${message(code: 'mapiAsyncNotify.notifyContents.label', default: 'NotifyContents Type')}"/>--}%

                <g:sortableColumn params="${params}" property="notifyTime" title="${message(code: 'mapiAsyncNotify.notifyTime.label', default: 'NotifyTime Type')}"/>

                <g:sortableColumn params="${params}" property="status" title="${message(code: 'mapiAsyncNotify.status.label', default: 'Status Type')}"/>

                <g:sortableColumn params="${params}" property="notifyMethod" title="操作"/>
            </tr>

            <g:each in="${mapiAsyncNotifyInstanceList}" status="i" var="mapiAsyncNotifyInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show" id="${mapiAsyncNotifyInstance.id}">${mapiAsyncNotifyInstance?.record?.outTradeNo}</g:link></td>

                    <td>${fieldValue(bean: mapiAsyncNotifyInstance, field: "response")}</td>

                    %{--<td>${mapiAsyncNotifyInstance.record?.subject}</td>--}%

                    %{--<td>${mapiAsyncNotifyInstance.record?.body}</td>--}%

                    <td>${mapiAsyncNotifyInstance.record?.amount / 100}</td>

                    <td><g:formatDate date="${mapiAsyncNotifyInstance.dateCreated}" format="yyyy-MM-dd"/></td>

                    <td><g:formatDate date="${mapiAsyncNotifyInstance.lastUpdated}" format="yyyy-MM-dd"/></td>

                    <td>${MapiAsyncNotify.notifyMethodMap[mapiAsyncNotifyInstance.notifyMethod]}</td>

                    <td>${fieldValue(bean: mapiAsyncNotifyInstance, field: "notifyAddress")}</td>

                    %{--<td>${fieldValue(bean: mapiAsyncNotifyInstance, field: "notifyContents")}</td>--}%

                    <td><g:formatDate date="${mapiAsyncNotifyInstance.notifyTime}" format="yyyy-MM-dd"></g:formatDate></td>

                    <td>${MapiAsyncNotify.statusMap[mapiAsyncNotifyInstance.status]}</td>
                  <td>
                    <g:if test="${mapiAsyncNotifyInstance.status=='fail'}">
                      <bo:hasPerm perm="${Perm.SysLog_Merc_Notify}">
                        <g:link controller="mapiAsyncNotify" action="updateStatus" params="[id: mapiAsyncNotifyInstance.id]">发送通知</g:link>
                      </bo:hasPerm>
                    </g:if>
                  </td>
                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${mapiAsyncNotifyInstanceTotal}条记录</span>
            <g:paginat total="${mapiAsyncNotifyInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
