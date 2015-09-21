<%@ page import="boss.Perm" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftLiquidate.postFee.label', default: 'FtLiquidate')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startTradeDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endTradeDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });

    });
    function checkDate() {
        if (!document.getElementById('endTradeDate').value.length == 0) {
            var startDateCreated = document.getElementById('startTradeDate').value;
            var endDateCreated = document.getElementById('endTradeDate').value;
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始日期不能大于结束日期!');
                document.getElementById('endTradeDate').focus();
                return false;
            }
        }
    }

       /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startDateCreated = document.getElementById('startTradeDate').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endTradeDate').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endTradeDate').focus();
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
        <g:form controller="postFeeSettle" action="merchant_list">
            <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
            <h2>
                日期：<g:textField name="startTradeDate" value="${params.startTradeDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--<g:textField name="endTradeDate" value="${params.endTradeDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>
                商户编码：<g:textField name="customerNo" maxlength="24" onblur="value=value.replace(/[ ]/g,'')" value="${params.customerNo}" class="right_top_h2_input"/>
                名称：<g:textField name="name" maxlength="64" onblur="value=value.replace(/[ ]/g,'')" value="${params.name}" class="right_top_h2_input"/>
                <g:actionSubmit class="right_top_h2_button_serch" action="merchant_list" value="查询" onclick="return checkDate()" />
                <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
            </h2>
        </g:form>
    </div>
    <table align="center" class="right_list_table" id="test">
        <tr>
            <g:sortableColumn params="${params}" property="customerNo" title="${message(code: 'ftCustomerlist.customer_no.label')}"/>
            <g:sortableColumn params="${params}" property="name" title="${message(code: 'default.search.result.name.label')}"/>
            <th>开始日期</th>
            <th>结束日期</th>
            <th>后返手续费总额</th>
            <th>操作</th>
        </tr>
        <g:each in="${result}" status="i" var="customerInstance">
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                <td>${customerInstance.CUSTOMERNO}</td>
                <g:set var="cu" value="${ismp.CmCustomer.findByCustomerNo(customerInstance.CUSTOMERNO)}"/>
                <td>${cu?.name}/${cu?.registrationName}</td>
                <td><g:formatDate format="yyyy.MM.dd" date="${customerInstance.MINTIME}" /></td>
                <td><g:formatDate format="yyyy.MM.dd" date="${customerInstance.MAXTIME}" /></td>
                <td>${customerInstance.POSTFEE/100}</td>
                <td><bo:hasPerm perm="${Perm.Settle_PostManualSettle_Proc}" ><input type="button" onclick="window.location.href = '${createLink(controller:'postFeeSettle', action:'settle_list', params:['mid':customerInstance?.CUSTOMERNO,'start':customerInstance.MINTIME,'end':customerInstance.MAXTIME])}'" value="处理"/></bo:hasPerm></td>
            </tr>
        </g:each>
    </table>
    后返手续费总额合计：<g:formatNumber number="${totalPostFee / 100}" format="#.##"/>元
    <div class="paginateButtons">
        <div align="left"><div style="position:absolute;">共${total}条记录</div></div>
        <g:paginat total="${total}" params="${params}"/>
    </div>
</div>
</body>
</html>