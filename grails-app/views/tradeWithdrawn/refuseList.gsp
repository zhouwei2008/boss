<%@ page import="boss.BoAcquirerAccount; boss.AppNote; boss.BoBankDic; boss.Perm; ismp.TradeWithdrawn" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeWithdrawn.refuseList.label', default: 'TradeWithdrawn')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <g:javascript library="My97DatePicker/WdatePicker"/>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
    <div class="table_serch">
    <table>
        <g:form action="refuseList">
            <tr>

                <td><g:message code="tradeWithdrawn.tradeNo.label"/>：</td><td><p><g:textField name="tradeNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.tradeNo}" class="right_top_h2_input" style="width:120px"/></p></td>
                <td><g:message code="tradeWithdrawn.payerName.label"/>：</td><td><p><g:textField name="payerName" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerName}" class="right_top_h2_input" style="width:120px"/></p></td>
                <td><g:message code="tradeWithdrawn.payerAccountNo.label"/>：</td><td><p><g:textField name="payerAccountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerAccountNo}" class="right_top_h2_input" style="width:120px"/></p></td>
                <td><g:message code="tradeWithdrawn.handleStatus.label"/>：</td><td><p><g:select name="handleStatus" value="${params.handleStatus}" from="${TradeWithdrawn.handleFristStatusMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/></p></td>
            </tr>
            <tr>
                <td><g:message code="tradeWithdrawn.payerBank.label"/>：</td><td><p><g:select from="${BoBankDic.findAll()}" value="${params.bankCode}" name="bankCode" id="bankCode" optionKey="code" optionValue="name" noSelection="${['':'-全部-']}" class="right_top_h2_input"></g:select></p></td>
                <td><g:message code="tradeWithdrawn.isCorporate.label"/>：</td><td><p><g:select name="isCorporate" from="${TradeWithdrawn.isCorporateMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" value="${params.isCorporate}"/></p>
                <td ><g:message code="tradeWithdrawn.amount.label"/>：</td><td colspan="3"><p><g:textField name="startAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.startAmount}" class="right_top_h2_input" style="width:80px"/>
                --<g:textField name="endAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endAmount}" class="right_top_h2_input" style="width:80px"/></p></td>
                %{--<td><g:message code="tradeWithdrawn.handleTime.label"/> ：</td>--}%
                %{--<td><g:textField name="startTimeHandle" value="${params.startTimeHandle}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" size="10" class="right_top_h2_input" style="width:80px"/>--}%
                %{---- <g:textField name="endTimeHandle" value="${params.endTimeHandle}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" size="10" class="right_top_h2_input" style="width:80px"/></td>--}%
                %{--<td>--}%

            </tr>
            <tr>
                <td><g:message code="tradeWithdrawn.dateCreated.label"/> ：</td>
                <td colspan="3"><p><g:textField name="startTimeCreate" value="${params.startTimeCreate}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" onchange="checkDate()" class="Wdate"/>
                    -- <g:textField name="endTimeCreate" value="${params.endTimeCreate}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" onchange="checkDate()" class="Wdate" /></p></td>
                <td><g:message code="tradeWithdrawn.firstAppDate.label"/> ：</td>
                <td colspan="3"><p><g:textField name="startFirstAppDate" value="${params.startFirstAppDate}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" onchange="checkDate()" class="Wdate"/>
                    -- <g:textField name="endFirstAppDate" value="${params.endFirstAppDate}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" onchange="checkDate()" class="Wdate" /></p></td>
            </tr>
            <tr>
                <td colspan="8">
                    <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkDate()"/>
                    <input type="button" class="right_top_h2_button_clear" value="清空" onClick="cl()">
                    <bo:hasPerm perm="${Perm.WithDraw_Chk_Dl}">
                        <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载"></g:actionSubmit>
                    </bo:hasPerm>
                    <input type="button" class="right_top_h2_button_check" value="全选" id="all" onClick="checkAll()"/>
                    <bo:hasPerm perm="${Perm.WithDraw_Chk_ProcBatPas}">
                        <input type="button" class="right_top_h2_button_check" value="审批通过" onClick="checkPass()"/>
                    </bo:hasPerm>
                </td>
            </tr>
            </table>
        </div>


            <table align="center" class="right_list_table" id="test">
                <g:hiddenField name="flag" value="1"></g:hiddenField>
                <tr>
                    <th>请选择</th>
                    <g:sortableColumn params="${params}" property="tradeNo" title="${message(code: 'tradeWithdrawn.tradeNo.label')}"/>
                    <g:sortableColumn params="${params}" property="payerName" title="${message(code: 'tradeWithdrawn.payerName.label')}"/>
                    <g:sortableColumn params="${params}" property="payerAccountNo" title="${message(code: 'tradeWithdrawn.payerAccountNo.label')}"/>
                    <th>提现银行</th>
                    <g:sortableColumn params="${params}" property="customerBankAccountNo" title="${message(code: 'tradeWithdrawn.customerBankAccountNo.label')}"/>
                    <g:sortableColumn params="${params}" property="customerBankAccountName" title="${message(code: 'tradeWithdrawn.customerBankAccountName.label')}"/>
                    <g:sortableColumn params="${params}" property="amount" title="${message(code: 'tradeWithdrawn.amount.label')}"/>
                    <g:sortableColumn params="${params}" property="handleStatus" title="${message(code: 'tradeWithdrawn.handleStatus.label')}"/>
                    <g:sortableColumn params="${params}" property="isCorporate" title="${message(code: 'tradeWithdrawn.isCorporate.label')}"/>
                    <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'tradeWithdrawn.dateCreated.label')}"/>
                    <g:sortableColumn params="${params}" property="firstAppDate" title="${message(code: 'tradeWithdrawn.firstAppDate.label')}"/>
                    %{--<g:sortableColumn params="${params}" property="firstAppName" title="${message(code: 'tradeWithdrawn.firstAppName.label')}"/>--}%
                    <th>拒绝原因</th>
                </tr>

                <g:each in="${tradeWithdrawnInstanceList}" status="i" var="tradeWithdrawnInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td><g:checkBox name="chbox" id="chbox"></g:checkBox>
                        <g:hiddenField name="id" value="${tradeWithdrawnInstance.id}"></g:hiddenField>
                        <g:hiddenField name="handleStatus1" id="handleStatus1" value="${tradeWithdrawnInstance.handleStatus}"></g:hiddenField>
                        </td>
                        <td>
                            <g:if test="${bo.hasPerm(perm:Perm.WithDraw_Chk_ViewLs){true}}"><g:link action="refuseShow" id="${tradeWithdrawnInstance.id}" params="['sign':'1']">${fieldValue(bean: tradeWithdrawnInstance, field: "tradeNo")}</g:link></g:if>
                            <g:else>${fieldValue(bean: tradeWithdrawnInstance, field: "tradeNo")}</g:else>
                        </td>
                        <td>${fieldValue(bean: tradeWithdrawnInstance, field: "payerName")}</td>
                        <td>${fieldValue(bean: tradeWithdrawnInstance, field: "payerAccountNo")}</td>
                        <td>${BoBankDic.get(BoAcquirerAccount.get(tradeWithdrawnInstance?.acquirerAccountId)?.bank?.id)?.name}</td>
                        <td>${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankAccountNo")}</td>
                        <td>${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankAccountName")}</td>
                        <td><g:formatNumber number="${tradeWithdrawnInstance?.amount/100}" type="currency" currencyCode="CNY"/></td>
                        <td>${TradeWithdrawn.handleStatusMap[tradeWithdrawnInstance?.handleStatus]}</td>
                        <td><g:formatBoolean boolean="${tradeWithdrawnInstance?.isCorporate}"/></td>
                        <td><g:formatDate date="${tradeWithdrawnInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        <td><g:formatDate date="${tradeWithdrawnInstance?.firstAppDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        %{--<td>${fieldValue(bean: tradeWithdrawnInstance, field: "firstAppName")}</td>--}%
                        <td>${AppNote.findByAppIdAndAppName(tradeWithdrawnInstance.id, 'tradeWithdrawn_first')?.appNote}</td>
                    </tr>
                </g:each>
            </table>
        </g:form>
        合计：提现金额总计：${totalAmount ? totalAmount / 100 : 0}元
        <div class="paginateButtons">
            <span style=" float:left;">共${tradeWithdrawnInstanceTotal}条记录</span>
            <g:paginat total="${tradeWithdrawnInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
<script type="text/javascript">
//    $(function() {
//        $("#startTimeCreate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
//        $("#endTimeCreate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
//        $("#startTimeHandle").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
//        $("#endTimeHandle").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
//    });
    function checkDate() {
        var startDate = document.getElementById("startTimeCreate").value;
        var endDate = document.getElementById("endTimeCreate").value;
        var startTimeHandle = document.getElementById("startTimeHandle").value;
        var endTimeHandle = document.getElementById("endTimeHandle").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endTimeCreate").focus();
            return false;
        }
        if (startTimeHandle > endTimeHandle && endTimeHandle != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endTimeHandle").focus();
            return false;
        }
    }
    /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startTimeCreate = document.getElementById('startTimeCreate').value.replace(/-/g, "//");
        var endTimeCreate = document.getElementById('endTimeCreate').value.replace(/-/g, "//");
        var startTimeHandle = document.getElementById('startTimeHandle').value.replace(/-/g, "//");
        var endTimeHandle = document.getElementById('endTimeHandle').value.replace(/-/g, "//");
        if (endTimeCreate.length != 0) {
            if (Number(startTimeCreate > endTimeCreate)) {
                alert('开始时间不能大于结束时间！');
                document.getElementById('endTimeCreate').focus();
                return false;
            }
        }
        if (endTimeHandle.length != 0) {
            if (Number(startTimeHandle > endTimeHandle)) {
                alert('开始时间不能大于结束时间！');
                document.getElementById('endTimeHandle').focus();
                return false;
            }
        }
        // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectF = new Date(startTimeCreate);
        var dSelectT = new Date(endTimeCreate);
        var theFromM = dSelectF.getMonth();
        var theFromD = dSelectF.getDate();
        // 设置起始日期加一个月
        theFromM += 1;
        dSelectF.setMonth(theFromM, theFromD);
        if (dSelectF < dSelectT) {
            alert('每次只能查询1个月范围内的数据！');
            return false;
        }

        // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectFh = new Date(startTimeHandle);
        var dSelectTh = new Date(endTimeHandle);
        var theFromMh = dSelectFh.getMonth();
        var theFromDh = dSelectFh.getDate();
        // 设置起始日期加一个月
        theFromMh += 1;
        dSelectFh.setMonth(theFromMh, theFromDh);
        if (dSelectFh < dSelectTh) {
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
        document.getElementById("handleStatus").value = "";
        document.getElementById("bankCode").value = "";
        document.getElementById("startTimeCreate").focus();
    }
    function checkAll() {
        var name = document.getElementById("all").value;
        var len = document.getElementsByName("chbox").length;
        if (name == "全选") {
            for (i = 0; i < len; i++) {
                document.getElementsByName("chbox")[i].checked = true;
                document.getElementById("all").value = "反选";
            }
        } else {
            for (i = 0; i < len; i++) {
                document.getElementsByName("chbox")[i].checked = false;
                document.getElementById("all").value = "全选";
            }
        }
    }
    function checkPass() {
        var len = document.getElementsByName("chbox").length;
        var status = "";
        var flag = 0;
        var id = "";
        for (i = 0; i < len; i++) {
            if (document.getElementsByName("chbox")[i].checked) {
                var st = document.getElementsByName("handleStatus1")[i].value
                if (status != st && status != "" && status != null) {
                    alert("您选择的数据不是同一提现状态,请重新选择！");
                    return false;
                }
                status = st;
                id = id + document.getElementsByName("id")[i].value + ",";
                flag = 1
            }
        }
        if (flag == 0) {
            alert("请选择至少一条待审批的提现请求！");
        }
        if (flag == 1 && status == 'fChecked') {
            if (confirm("您确认要批量处理提现请求？")) {
                window.location.href = '${createLink(controller:'tradeWithdrawn', action:'selectSingleCheck', params:['statusFlag':'1'])}&id=' + id;
            }
        }
        if (flag == 1 && status == 'fRefuse') {
            if (confirm("您确认要批量处理提现请求？")) {
                window.location.href = '${createLink(controller:'tradeWithdrawn', action:'selectCheckFailPass', params:['statusFlag':'1'])}&id=' + id;
            }
        }
    }
</script>
</body>
</html>
