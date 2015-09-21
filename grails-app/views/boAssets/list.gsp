
<%@ page import="boss.BoAssets;boss.Perm" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boAssets.label', default: 'BoAssets')}"/>
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
    <div class="message">${flash.message.encodeAsHTML()}</div>
</g:if>
<div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
<g:form action="list">
    <div class="table_serch">
        <table>

            <tr>
                <td>${message(code: '启用日期')}：   </td>
                <td><g:textField name="startDateCreated" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.startDateCreated}" style="width:80px" class="right_top_h2_input"/> --<g:textField name="endDateCreated" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.endDateCreated}" style="width:80px" class="right_top_h2_input"/></td>

                <td>${message(code: '资源状态')}：</td>
                    <td><p><g:select name="status" value="${params.status}" from="${BoAssets.statusMap}" optionKey="key" optionValue="value"  noSelection="${['':'-请选择-']}" class="right_top_h2_input"/> </p></td>

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
        
        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'boAssets.id.label', default: 'Id')}"/>
        
        <g:sortableColumn params="${params}"  property="asId" title="${message(code: 'boAssets.asId.label', default: 'As Id')}"/>
        
        <g:sortableColumn params="${params}"  property="name" title="${message(code: 'boAssets.name.label', default: 'Name')}"/>
        
        <g:sortableColumn params="${params}"  property="brand" title="${message(code: 'boAssets.brand.label', default: 'Brand')}"/>
        
        <g:sortableColumn params="${params}"  property="model" title="${message(code: 'boAssets.model.label', default: 'Model')}"/>
        
        <g:sortableColumn params="${params}"  property="num" title="${message(code: 'boAssets.num.label', default: 'Num')}"/>

        <g:sortableColumn params="${params}"  property="startDate" title="${message(code: 'boAssets.startDate.label', default: 'Start Date')}"/>

        <g:sortableColumn params="${params}"  property="status" title="${message(code: 'boAssets.status.label', default: 'Status')}"/>

          <th>操作</th>
        
      </tr>

      <g:each in="${boAssetsInstanceList}" status="i" var="boAssetsInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

          <td>${(pageNum - 1) * 10 + i +1 }</td>
          
          <td>${fieldValue(bean: boAssetsInstance, field: "asId")}</td>
          
          <td>${fieldValue(bean: boAssetsInstance, field: "name")}</td>
          
          <td>${fieldValue(bean: boAssetsInstance, field: "brand")}</td>
          
          <td>${fieldValue(bean: boAssetsInstance, field: "model")}</td>
          
          <td>${fieldValue(bean: boAssetsInstance, field: "num")}</td>

            %{--<td>${fieldValue(bean: boAssetsInstance, field: "startDate")}</td>--}%

            <td><g:formatDate date="${boAssetsInstance.startDate}" format="yyyy-MM-dd"/></td>


            <td>${BoAssets.statusMap[boAssetsInstance?.status]} </td>

            <td>
                <input type="button" onclick="window.location.href = '${createLink(controller:'boAssets', action:'edit', params:['id':boAssetsInstance?.id])}'" value="修改"/>

            </td>
        </tr>
      </g:each>
    </table>
    
    <div class="paginateButtons">
        <span style=" float:left;">共${boAssetsInstanceTotal}条记录</span>
      <g:paginate total="${boAssetsInstanceTotal}" params="${params}"/>
    </div>
  </div>



</body>
</html>
