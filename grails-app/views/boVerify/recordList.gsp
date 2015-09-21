<%@ page import="boss.Perm; boss.BoVerify" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boVerify.label', default: 'BoVerify')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true,changeMonth: true });
        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true,changeMonth: true });
        $("#startAppDate").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endAppDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true,changeMonth: true });
    });
    function checkDate() {
        var startDate = document.getElementById("startDateCreated").value;
        var endDate = document.getElementById("endDateCreated").value;
        var startAppDate = document.getElementById("startAppDate").value;
        var endAppDate = document.getElementById("endAppDate").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endDateCreated").focus();
            return false;
        }
        if (startAppDate > endAppDate && endAppDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endAppDate").focus();
            return false;
        }
    }
             /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startDateCreated = document.getElementById('startDateCreated').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endDateCreated').value.replace(/-/g,"//");
        var startAppDate = document.getElementById("startAppDate").value.replace(/-/g,"//");
        var endAppDate = document.getElementById("endAppDate").value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }
        if (endAppDate.length != 0) {
            if (Number(startAppDate > endAppDate)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endAppDate').focus();
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
        var dSelectAppF=new Date(startAppDate);
        var dSelectAppT=new Date(endAppDate);
         var theFromAppM=dSelectAppF.getMonth();
         var theFromAppD=dSelectAppF.getDate();
        // 设置起始日期加一个月
          theFromAppM += 1;
          dSelectAppF.setMonth(theFromAppM,theFromAppD);
          if( dSelectAppF < dSelectAppT)
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
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="充提转记录" args="[entityName]"/></h1>
        <div class="table_serch">
            <table>
                <g:form action="recordList">
                    <tr>
                        <td><g:message code="类型"/>：</td><td><p><g:select name="type" value="${params.type}" from="${BoVerify.typeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/></p></td>
                        <td><g:message code="转入银行帐户"/>：</td><td><p><g:textField name="inBankAccountNo" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" onblur="value=value.replace(/[ ]/g,'')" value="${params.inBankAccountNo}" class="right_top_h2_input" style="width:120px"/></p></td>

                        <td><g:message code="状态"/>：</td><td><p><g:select name="status" value="${params.status}" from="${BoVerify.statusMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td><g:message code="转出银行帐户"/>：</td><td class="left"><p><g:textField name="outBankAccountNo" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" onblur="value=value.replace(/[ ]/g,'')" value="${params.outBankAccountNo}" class="right_top_h2_input" style="width:120px"/></p></td>
                        <td><g:message code="创建时间"/>：</td><td><g:textField name="startDateCreated" value="${params.startDateCreated}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input" onchange="checkDate();" style="width:80px"/>--<g:textField name="endDateCreated" value="${params.endDateCreated}" onblur="value=value.replace(/[ ]/g,'');" onchange="checkDate();" class="right_top_h2_input" style="width:80px"/></td>
                        <td><g:message code="操作员"/>：</td><td><g:textField name="operName" value="${params.operName}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input" style="width:60px"/></td>
                    </tr>
                    %{--增加转出转入银行名称　as sunweiguo --}%
                    <tr>
                        <td><g:message code="转出银行名称"/>：</td><td class="left"><p><g:textField name="outBankName" onblur="value=value.replace(/[ ]/g,'')" value="${params.outBankName}" class="right_top_h2_input" style="width:120px"/></p></td>
                        <td><g:message code="转入银行名称"/>：</td><td><p><g:textField name="inBankName" value="${params.inBankName}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input"  style="width:120px"/></p></td>

                    </tr>

                    <tr>
                        <td><g:message code="审核时间"/>：</td><td><g:textField name="startAppDate" value="${params.startAppDate}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input" onchange="checkDate();" style="width:80px"/>--<g:textField name="endAppDate" value="${params.endAppDate}" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate();" class="right_top_h2_input" style="width:80px"/></td>
                        <td><g:message code="审核员"/>：</td><td class="left"><p><g:textField name="appName" value="${params.appName}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input" style="width:120px"/></p></td>
                        %{--<g:message code="IP"/>：<g:textField name="outBankAccountNo" value="${params.outBankAccountNo}" class="right_top_h2_input" style="width:120px"/>--}%
                        <td><input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkDate()"></td>
                        <td><g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/></td>
                    </tr>
                </g:form>
            </table>
        </div>

        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'boVerify.dateCreated.label', default: '创建日期')}"/>

                <g:sortableColumn params="${params}" property="type" title="${message(code: 'boVerify.type.label', default: '类型')}"/>

                <g:sortableColumn params="${params}" property="inBankName" title="${message(code: 'boVerify.inBankName.label', default: '转入银行名称')}"/>

                <g:sortableColumn params="${params}" property="outBankName" title="${message(code: 'boVerify.outBankName.label', default: '转出银行名称')}"/>

                <g:sortableColumn params="${params}" property="outAmount" title="${message(code: 'boVerify.outBankName.label', default: '金额')}"/>
                <g:sortableColumn params="${params}" property="status" title="${message(code: 'boVerify.status.label', default: '状态')}"/>

                <g:sortableColumn params="${params}" property="operate" title="${message(code: 'boVerify.operate.label', default: '操作')}"/>

            </tr>

            <g:each in="${boVerifyInstanceList}" status="i" var="boVerifyInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td><g:formatDate date="${boVerifyInstance.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>
                        ${BoVerify.typeMap[boVerifyInstance.type]}
                    </td>
                    <td>${fieldValue(bean: boVerifyInstance, field: "inBankName")}</td>
                    <td>${fieldValue(bean: boVerifyInstance, field: "outBankName")}</td>
                    <td>
                        <g:set var="amt" value="${boVerifyInstance.outAmount ? boVerifyInstance.outAmount : 0}"/>
                        <g:formatNumber number="${amt/100}" type="currency" currencyCode="CNY"/>
                    </td>
                    <td>
                        ${BoVerify.statusMap[boVerifyInstance.status]}
                    </td>
                    <td>
                        <bo:hasPerm perm="${Perm.Bank_TransRec_View}"><g:link action="show" id="${boVerifyInstance.id}">详细</g:link></bo:hasPerm>
                    </td>
                </tr>
            </g:each>
        </table>
         合计：金额总计：<g:formatNumber number="${totalAmount?totalAmount/100:0}" format="#.##"/>元
        <div class="paginateButtons">
            <span style=" float:left;">共${boVerifyInstanceTotal}条记录</span>
            <g:paginat total="${boVerifyInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
