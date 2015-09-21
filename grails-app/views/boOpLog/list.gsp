<%@ page import="boss.BoOpRelation; boss.BoOpLog" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boOpLog.label', default: 'BoOpLog')}"/>
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
        var dates = $( "#startDateCreated, #endDateCreated" ).datepicker({
			dateFormat: 'yy-mm-dd',
            changeYear: true,
			changeMonth: true
		});
//        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeMonth: true });
//        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeMonth: true });
    });
    function checkDate() {
        if (!document.getElementById('endDateCreated').value.length == 0) {
            var startDateCreated = document.getElementById('startDateCreated').value;
            var endDateCreated = document.getElementById('endDateCreated').value;
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }
    }
     /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startDateCreated = document.getElementById('startDateCreated').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endDateCreated').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
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
    }
     function empty() {

         document.getElementById('startDateCreated').value='';
         document.getElementById('endDateCreated').value='';
         document.getElementById('names').value='';
         document.getElementById('account').value='';
           return false;
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message
                code="default.list.label" args="[entityName]"/></h1>
         <div class="table_serch">
            <table>
                <g:form>
                    <tr>
                        <td>${message(code: 'boOpLog.opRelation.names.label')}：</td>
                        <td><p><g:textField name="names"  value="${params.names}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'boOpLog.account.label')}：</td>
                        <td><p><g:textField name="account"  value="${params.account}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                    <td>${message(code: 'boOpLog.dateCreated.label')}：</td>
                    <td><g:textField name="startDateCreated" id='startDateCreated' onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.startDateCreated}" class="right_top_h2_input"/>--<g:textField name="endDateCreated"  id='endDateCreated' onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.endDateCreated}" onchange="checkDate()" class="right_top_h2_input"/></td>
                    </tr>
                    <tr>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkDate()"/></td>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="" value="清空" onclick="return empty()"/></td>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="listDownload" value="下载" onclick="return checkDate()"/></td>
                    </tr>
                %{--<g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载"/>--}%
                </g:form>
            </table>
        </div>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <g:sortableColumn params="${params}" property="account"
                                  title="${message(code: 'boOpLog.account.label', default: 'Account')}"/>

                <g:sortableColumn params="${params}" property="id"
                                  title="${message(code: 'boOpLog.opRelation.names.label', default: 'Name')}"/>

                <g:sortableColumn params="${params}" property="ip"
                                  title="${message(code: 'boOpLog.ip.label', default: 'Ip')}"/>

                <g:sortableColumn params="${params}" property="dateCreated"
                                  title="${message(code: 'boOpLog.dateCreated.label', default: 'Date Created')}"/>



            </tr>

            <g:each in="${boOpLogInstanceList}" status="i" var="boOpLogInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>${fieldValue(bean: boOpLogInstance, field: "account")}</td>

                    <td><g:link action="show" id="${boOpLogInstance.id}">${BoOpRelation.findByActionsAndControllers(boOpLogInstance.action,boOpLogInstance.controller)?.names}</g:link></td>

                    <td>${fieldValue(bean: boOpLogInstance, field: "ip")}</td>

                    <td><g:formatDate date="${boOpLogInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>

                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${boOpLogInstanceTotal}条记录</span>
            <g:paginat total="${boOpLogInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
