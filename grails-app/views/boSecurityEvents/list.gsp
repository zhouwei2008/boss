
<%@ page import="boss.BoSecurityEvents" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boSecurityEvents.label', default: 'BoSecurity')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>

<script type="text/javascript">
    $(function() {
        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
    });
    function checkDate() {
        var startDate = document.getElementById("startDateCreated").value;
        var endDate = document.getElementById("endDateCreated").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endDateCreated").focus();
            return false;
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

        <g:form action="list">
            <div class="table_serch">
                <table>
                   <tr>

                      <td>
                        日期 ：
                      <g:textField name="startDateCreated" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.startDateCreated}" style="width:80px" class="right_top_h2_input"/> --<g:textField name="endDateCreated" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.endDateCreated}" style="width:80px" class="right_top_h2_input"/>
                         </td>
                          <td>${message(code: 'boSecurityEvents.boStatus.label')}：</td>
                        <td><g:select name="boStatus" value="${params.boStatus}" from="${BoSecurityEvents.boStatusMap}" optionKey="key" optionValue="value" class="right_top_h2_input" noSelection="${['':'-请选择-']}"></g:select></td>

                       <td></td>
                       <td></td>
                       <td>${message(code: 'boSecurityEvents.boSort.label')}：</td>
                        <td><g:select name="boSort" value="${params.boSort}" from="${BoSecurityEvents.boSortMap}" optionKey="key" optionValue="value" class="right_top_h2_input" noSelection="${['':'-请选择-']}"></g:select></td>
                <td>

                          <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkDate()">

                </td>
                <td>
                        <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()"/>
                </td>
            </tr>
                </table>

            </div>

        </g:form>


       <h2>
      <g:form>
        <g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        
        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'boSecurityEvents.id.label', default: 'Id')}"/>
        
        <g:sortableColumn params="${params}"  property="boSort" title="${message(code: 'boSecurityEvents.boSort.label', default: 'BoSort')}"/>
        
        <g:sortableColumn params="${params}"  property="sketch" title="${message(code: 'boSecurityEvents.sketch.label', default: 'sSketch')}"/>
        
        %{--<g:sortableColumn params="${params}"  property="expatiate" title="${message(code: 'boSecurityEvents.expatiate.label', default: 'Expatiate')}"/>--}%
        
        <g:sortableColumn params="${params}"  property="startDateCreated" title="${message(code: 'boSecurityEvents.startDateCreated.label', default: 'Start Date Created')}"/>
        
        <g:sortableColumn params="${params}"  property="endDateCreated" title="${message(code: 'boSecurityEvents.endDateCreated.label', default: 'End Date Created ')}"/>

          <g:sortableColumn params="${params}"  property="boStatus" title="${message(code: 'boSecurityEvents.boStatus.label', default: 'BoStatus')}"/>

          <th>操作</th>
      </tr>

      <g:each in="${boSecurityEventsInstanceList}" status="i" var="boSecurityEventsInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          
          <td>${(pageNum - 1) * 10 + i +1 }</td>

            <td>${BoSecurityEvents.boSortMap[boSecurityEventsInstance?.boSort]} </td>
          
          <td>${fieldValue(bean: boSecurityEventsInstance, field: "sketch")}</td>
          
          <td><g:formatDate date="${boSecurityEventsInstance.startDateCreated}" format="yyyy-MM-dd"/></td>
          
           <td><g:formatDate date="${boSecurityEventsInstance.endDateCreated}" format="yyyy-MM-dd"/></td>


            <td>${BoSecurityEvents.boStatusMap[boSecurityEventsInstance?.boStatus]} </td>
             <td>
            <input type="button" onclick="window.location.href = '${createLink(controller:'boSecurityEvents', action:'edit', params:['id':boSecurityEventsInstance?.id])}'" value="修改"/>
             </td>
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
        <span style=" float:left;">共${boSecurityEventsInstanceTotal}条记录</span>
      <g:paginate total="${boSecurityEventsInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>

</body>
</html>
