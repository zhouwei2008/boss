<%@ page import="boss.BoAcquirerAccount; boss.BoBankDic; boss.Perm; ismp.TradeWithdrawn" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeWithdrawn.label', default: 'TradeWithdrawn')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <g:javascript library="My97DatePicker/WdatePicker"/>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">提现历史查询</h1>
    <div class="table_serch">
    <table>
        <g:form action="histList">
            <tr>

                <td><g:message code="tradeWithdrawn.withdrawnBatchNo.label"/>：</td><td><p><g:textField name="withdrawnBatchNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.withdrawnBatchNo}" class="right_top_h2_input" style="width:120px"/></p></td>
                <td><g:message code="tradeWithdrawn.tradeNo.label"/>：</td><td><p><g:textField name="tradeNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.tradeNo}" class="right_top_h2_input" style="width:120px"/></p></td>
                <td>银行渠道：</td><td><p><g:select name="bankCode" value="${params.bankCode}" from="${BoBankDic.findAll()}" optionKey="code" optionValue="name" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/></p></td>
                <td><g:message code="tradeWithdrawn.isCorporate.label"/>：</td><td><p><g:select name="isCorporate" from="${TradeWithdrawn.isCorporateMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" value="${params.isCorporate}"/></p>
            </tr>
            <tr>

                <td><g:message code="tradeWithdrawn.payerAccountNo.label"/>：</td><td><p><g:textField name="payerAccountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerAccountNo}" class="right_top_h2_input" style="width:120px"/></p></td>
                <td><g:message code="tradeWithdrawn.payerName.label"/>：</td><td><g:textField name="payerName" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerName}" class="right_top_h2_input" style="width:120px"/></td>

                <td><g:message code="tradeWithdrawn.amount.label"/>：</td><td><g:textField name="startAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.startAmount}" class="right_top_h2_input" style="width:60px"/>--<g:textField name="endAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endAmount}" class="right_top_h2_input" style="width:60px"/></td>
                <td><g:message code="tradeWithdrawn.handleStatus.label"/>：</td><td><p><g:select name="handleStatus" value="${params.handleStatus}" from="${TradeWithdrawn.handleStatusMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" onchange="displayHandleTime(this.value)" class="right_top_h2_input"/></p></td>
            </tr>
            <tr>
                <td><g:message code="tradeWithdrawn.dateCreated.label"/> ：</td>
                <td colspan="3"><p><g:textField name="startTime" value="${params.startTime}" onchange="checkDate()" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" class="Wdate"/>
                    -- <g:textField name="endTime" value="${params.endTime}" onchange="checkDate()" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" class="Wdate"/></p></td>
                 <td >提现终审时间 ：</td>
                <td colspan="3"><p><g:textField name="startLastAppDate" value="${params.startLastAppDate}" onchange="checkDate()" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" class="Wdate"/>
                    -- <g:textField name="endLastAppDate" value="${params.endLastAppDate}" onchange="checkDate()" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" class="Wdate"/></p></td>
            </tr>
            <tr>
                 <td >提现复核时间 ：</td>
                <td colspan="3"><p><g:textField name="startWithReHandleDate" value="${params.startWithReHandleDate}" onchange="checkDate()" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" class="Wdate"/>
                    -- <g:textField name="endWithReHandleDate" value="${params.endWithReHandleDate}" onchange="checkDate()" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" class="Wdate"/></p></td>
                <td colspan="4" ><input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkDate()"/>
                    <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
                    <bo:hasPerm perm="${Perm.WithDraw_His_Dl}">
                        <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载"></g:actionSubmit>
                    </bo:hasPerm>
            </tr>
            </table>
        </div>
            <table align="center" class="right_list_table" id="test">
                <g:hiddenField name="flag" value="5"></g:hiddenField>
                <tr>
                    <g:sortableColumn params="${params}" property="withdrawnBatchNo" title="${message(code: 'tradeWithdrawn.withdrawnBatchNo.label')}"/>
                    <g:sortableColumn params="${params}" property="tradeNo" title="${message(code: 'tradeWithdrawn.tradeNo.label')}"/>
                    <g:sortableColumn params="${params}" property="payerName" title="${message(code: 'tradeWithdrawn.payerName.label')}"/>
                    <g:sortableColumn params="${params}" property="payerAccountNo" title="${message(code: 'tradeWithdrawn.payerAccountNo.label')}"/>
                    <g:sortableColumn params="${params}" property="customerBankAccountNo" title="${message(code: 'tradeWithdrawn.customerBankAccountNo.label')}"/>
                    <g:sortableColumn params="${params}" property="customerBankAccountName" title="${message(code: 'tradeWithdrawn.customerBankAccountName.label')}"/>
                    <g:sortableColumn params="${params}" property="amount" title="${message(code: 'tradeWithdrawn.amount.label')}"/>
                    <g:sortableColumn params="${params}" property="handleStatus" title="${message(code: 'tradeWithdrawn.handleStatus.label')}"/>
                    <g:sortableColumn params="${params}" property="payerBank" title="${message(code: 'tradeWithdrawn.payerBank.label')}"/>
                    <th>提现银行渠道</th>
                    <g:sortableColumn params="${params}" property="isCorporate" title="${message(code: 'tradeWithdrawn.isCorporate.label')}"/>
                    <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'tradeWithdrawn.dateCreated.label')}"/>
                    <g:sortableColumn params="${params}" property="lastAppDate" title="${message(code: 'tradeWithdrawn.lastAppDate.label')}"/>
                    <g:sortableColumn params="${params}" property="withReHandleDate" title="${message(code: 'tradeWithdrawn.withReHandleDate.label')}"/>
                </tr>

                <g:each in="${tradeWithdrawnInstanceList}" status="i" var="tradeWithdrawnInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td>
                            <g:if test="${bo.hasPerm(perm:Perm.WithDraw_His_ViewLs){true}}"><g:link action="checkShowBatch" id="${tradeWithdrawnInstance.withdrawnBatchNo}">${fieldValue(bean: tradeWithdrawnInstance, field: "withdrawnBatchNo")}</g:link></g:if>
                            <g:else>${fieldValue(bean: tradeWithdrawnInstance, field: "withdrawnBatchNo")}</g:else>
                        </td>
                        <td>
                            <g:if test="${bo.hasPerm(perm:Perm.WithDraw_His_ViewBat){true}}"><g:link action="refuseShow" id="${tradeWithdrawnInstance.id}">${fieldValue(bean: tradeWithdrawnInstance, field: "tradeNo")}</g:link></g:if>
                            <g:else>${fieldValue(bean: tradeWithdrawnInstance, field: "tradeNo")}</g:else>
                        </td>
                        <td>${fieldValue(bean: tradeWithdrawnInstance, field: "payerName")}</td>
                        <td>${fieldValue(bean: tradeWithdrawnInstance, field: "payerAccountNo")}</td>
                        <td>${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankAccountNo")}</td>
                        <td>${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankAccountName")}</td>
                        <td><g:formatNumber number="${tradeWithdrawnInstance?.amount/100}" type="currency" currencyCode="CNY"/></td>
                        <td>${TradeWithdrawn.handleStatusMap[tradeWithdrawnInstance?.handleStatus]}</td>
                        <td>${boss.BoBankDic.findByCode(tradeWithdrawnInstance?.customerBankCode)?.name}</td>
                        <td>${boss.BoBankDic.get(BoAcquirerAccount.get(tradeWithdrawnInstance?.acquirerAccountId)?.bank?.id)?.name}</td>
                        <td><g:formatBoolean boolean="${tradeWithdrawnInstance?.isCorporate}"/></td>
                        <td><g:formatDate date="${tradeWithdrawnInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        <td><g:formatDate date="${tradeWithdrawnInstance?.lastAppDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        <td><g:formatDate date="${tradeWithdrawnInstance?.withReHandleDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
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
    //        $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    //        $("#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    //        $("#startTimeHandle").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    //        $("#endTimeHandle").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    //    });
    function checkDate() {
        var startDate = document.getElementById("startTime").value;
        var endDate = document.getElementById("endTime").value;
        var startTimeHandle = document.getElementById("startTimeHandle").value;
        var endTimeHandle = document.getElementById("endTimeHandle").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endTime").focus();
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
        var startTimeCreate = document.getElementById('startTime').value.replace(/-/g, "//");
        var endTimeCreate = document.getElementById('endTime').value.replace(/-/g, "//");
        var startTimeHandle = document.getElementById('startTimeHandle').value.replace(/-/g, "//");
        var endTimeHandle = document.getElementById('endTimeHandle').value.replace(/-/g, "//");
        if (endTimeCreate.length != 0) {
            if (Number(startTimeCreate > endTimeCreate)) {
                alert('开始时间不能大于结束时间！');
                document.getElementById('endTime').focus();
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
        var dSelectF = new Date(startTime);
        var dSelectT = new Date(endTime);
        var theFromM = dSelectF.getMonth();
        var theFromD = dSelectF.getDate();
        // 设置起始日期加一个月
        theFromM += 1;
        dSelectF.setMonth(theFromM, theFromD);
        if (dSelectF < dSelectT) {
            alert('每次只能查询1个月范围内的数据!');
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
    function empty() {
        $(':input').not(':button, :submit, :reset, :hidden')
                .val('')
                .removeAttr('checked')
                .removeAttr('selected');

        return false;
    }
//    function displayHandleTime(val) {
//        if (val != "") {
//            document.getElementById("stDate").style.display = "inline";
//            document.getElementById("stDate1").style.display = "inline";
//        } else {
//            document.getElementById("stDate").style.display = "none";
//            document.getElementById("stDate1").style.display = "none";
//        }
//    }
    window.onload = function () {
        if (document.getElementById("handleStatus").value != "") {
            document.getElementById("stDate").style.display = "inline";
            document.getElementById("stDate1").style.display = "inline";
        }
    }
</script>
</body>
</html>
