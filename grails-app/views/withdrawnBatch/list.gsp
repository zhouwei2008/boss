<%@ page import="boss.Perm; boss.BoBankDic; ismp.WithdrawnBatch" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'withdrawnBatch.label', default: 'WithdrawnBatch')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <g:javascript library="My97DatePicker/WdatePicker"/>
</head>
<body>
<script type="text/javascript">
    //    $(function() {
    //        $("#startWithdrawnDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    //        $("#endWithdrawnDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    //    });
    function checkDate() {
        var startDate = document.getElementById("startWithdrawnDate").value;
        var endDate = document.getElementById("endWithdrawnDate").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endWithdrawnDate").focus();
            return false;
        }
    }
    /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startWithdrawnDate = document.getElementById('startWithdrawnDate').value.replace(/-/g, "//");
        var endWithdrawnDate = document.getElementById('endWithdrawnDate').value.replace(/-/g, "//");
        if (endWithdrawnDate.length != 0) {
            if (Number(startWithdrawnDate > endWithdrawnDate)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endWithdrawnDate').focus();
                return false;
            }
        }
        // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectF = new Date(startWithdrawnDate);
        var dSelectT = new Date(endWithdrawnDate);
        var theFromM = dSelectF.getMonth();
        var theFromD = dSelectF.getDate();
        // 设置起始日期加一个月
        theFromM += 1;
        dSelectF.setMonth(theFromM, theFromD);
        if (dSelectF < dSelectT) {
            alert('每次只能查询1个月范围内的数据！');
            return false;
        }
    }
    function cl() {
        var form = document.forms[0];
        for (var i = 0; i < form.elements.length; i++) {
            if (form.elements[i].type == "text" || form.elements[i].type == "text")
                form.elements[i].value = "";
        }
        document.getElementById("bankName").value = "";
        document.getElementById("startWithdrawnDate").focus();
    }

</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <g:form>
            <div class="table_serch">
                <table>
                    <tr>
                        <td>批次号：</td><td><p><g:textField name="id" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.id}" class="right_top_h2_input"/></p></td>
                        <td>批次笔数：</td><td><p><g:textField name="batchCount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.batchCount}" class="right_top_h2_input"/></p></td>
                        <td>提现银行：</td><td><p><g:select from="${BoBankDic.findAll().name}" value="${params.bankName}" name="bankName" id="bankName" optionKey="value" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"></g:select></p></td>
                        <td>批次金额：</td><td><p><g:textField name="startBatchAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${params.startBatchAmount}" class="right_top_h2_input"/>--<g:textField name="endBatchAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endBatchAmount}" style="width:60px;" class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td>提现初审时间：</td><td colspan="3"><p><g:textField name="startWithdrawnDate" onchange="checkDate()" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" class="Wdate" value="${params.startWithdrawnDate}"/>--<g:textField name="endWithdrawnDate" onchange="checkDate()" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" class="Wdate" value="${params.endWithdrawnDate}"/></p></td>
                        <td colspan="4" class="left"><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询"/>
                        <bo:hasPerm perm="${Perm.WithDraw_ChkBth_Dl}"><g:actionSubmit class="right_top_h2_button_download" action="listDl" value="下载"/></bo:hasPerm>
                            <input type="button" class="right_top_h2_button_clear" value="清空" onClick="cl()">
                        </td>
                    </tr>
                </table>
            </div>
        </g:form>
        <table align="center" class="right_list_table" id="test">

            <tr>
                <g:sortableColumn params="${params}" property="id" title="${message(code: 'withdrawnBatch.id.label')}"/>
                <g:sortableColumn params="${params}" property="batchCount" title="${message(code: 'withdrawnBatch.batchCount.label')}"/>
                <g:sortableColumn params="${params}" property="batchAmount" title="${message(code: 'withdrawnBatch.batchAmount.label')}"/>
                <g:sortableColumn params="${params}" property="withdrawnBankName" title="${message(code: 'withdrawnBatch.withdrawnBankName.label')}"/>
                <g:sortableColumn params="${params}" property="appName" title="${message(code: 'withdrawnBatch.appName.label')}"/>
                <g:sortableColumn params="${params}" property="withdrawnDate" title="${message(code: 'withdrawnBatch.withdrawnDate.label')}"/>
                <g:sortableColumn params="${params}" property="status" title="${message(code: 'withdrawnBatch.status.label')}"/>
                <th>操作</th>
            </tr>

            <g:each in="${withdrawnBatchInstanceList}" status="i" var="withdrawnBatchInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>${withdrawnBatchInstance.id.toString().replace(',', '')}</td>
                    <td>${fieldValue(bean: withdrawnBatchInstance, field: "batchCount")}</td>
                    <td><g:formatNumber number="${withdrawnBatchInstance?.batchAmount?withdrawnBatchInstance?.batchAmount/100:0}" type="currency" currencyCode="CNY"/></td>
                    <td>${fieldValue(bean: withdrawnBatchInstance, field: "withdrawnBankName")}</td>

                    <td>${fieldValue(bean: withdrawnBatchInstance, field: "appName")}</td>
                    <td><g:formatDate date="${withdrawnBatchInstance?.withdrawnDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${WithdrawnBatch.statusMap[withdrawnBatchInstance?.status]}</td>
                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.WithDraw_ChkBth_View){true}}"><g:link action="show" id="${withdrawnBatchInstance.id}">详情</g:link></g:if>
                    </td>
                </tr>
            </g:each>
        </table>
        合计：金额总计：${totalAmount ? totalAmount / 100 : 0}元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;笔数总计：${totalCount ? totalCount : 0}笔
        <div class="paginateButtons">
            <span style=" float:left;">共${withdrawnBatchInstanceTotal}条记录</span>
            <g:paginat total="${withdrawnBatchInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>














