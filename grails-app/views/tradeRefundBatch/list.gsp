<%@ page import="boss.Perm; boss.BoBankDic; ismp.TradeRefundBatch" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeRefundBatch.list.label', default: 'TradeRefundBatch')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startRefundDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endRefundDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });
    function checkDate() {
        var startDate = document.getElementById("startRefundDate").value;
        var endDate = document.getElementById("endRefundDate").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endRefundDate").focus();
            return false;
        }
    }
    /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startRefundDate = document.getElementById('startRefundDate').value.replace(/-/g, "//");
        var endRefundDate = document.getElementById('endRefundDate').value.replace(/-/g, "//");
        if (endRefundDate.length != 0) {
            if (Number(startRefundDate > endRefundDate)) {
                alert('开始时间不能大于结束时间！');
                document.getElementById('endRefundDate').focus();
                return false;
            }
        }
        // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectF = new Date(startRefundDate);
        var dSelectT = new Date(endRefundDate);
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
        document.getElementById("refundType").value = "";
        document.getElementById("startRefundDate").focus();
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
                        <td>退款初审时间：</td><td><g:textField name="startRefundDate" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.startRefundDate}" class="right_top_h2_input"/>--<g:textField name="endRefundDate" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.endRefundDate}" class="right_top_h2_input"/></td>
                        <td>批次号：</td><td><g:textField name="id" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.id}" class="right_top_h2_input"/></td>
                        <td>批次笔数：</td><td><g:textField name="batchCount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.batchCount}" class="right_top_h2_input"/></td>
                        <td>退款银行：</td><td><p><g:select from="${BoBankDic.findAll().name}" value="${params.bankName}" name="bankName" id="bankName" optionKey="value" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"></g:select></p></td>
                    </tr>
                    <tr>

                        <td>订单类型：</td><td><p><g:select name="refundType" value="${params.refundType}" from="${TradeRefundBatch.refundTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                        <td>批次金额：</td><td><p><g:textField name="startBatchAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${params.startBatchAmount}" class="right_top_h2_input"/>--<g:textField name="endBatchAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endBatchAmount}" style="width:60px;" class="right_top_h2_input"/></p></td>
                        <td colspan="2" class="left"><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询"/>
                        <bo:hasPerm perm="${Perm.Trade_RfdBthChk_Dl}"><g:actionSubmit class="right_top_h2_button_download" action="listDl" value="下载"/></bo:hasPerm>
                            <input type="button" class="right_top_h2_button_clear" value="清空" onClick="cl()">
                        </td>
                    </tr>
                    <tr>

                    </tr>
                </table>
            </div>
        </g:form>
        <table align="center" class="right_list_table" id="test">

            <tr>
                <g:sortableColumn params="${params}" property="id" title="${message(code: 'tradeRefundBatch.id.label')}"/>
                <g:sortableColumn params="${params}" property="batchCount" title="${message(code: 'tradeRefundBatch.batchCount.label')}"/>
                <g:sortableColumn params="${params}" property="batchAmount" title="${message(code: 'tradeRefundBatch.batchAmount.label')}"/>
                <g:sortableColumn params="${params}" property="refundType" title="${message(code: 'tradeRefundBatch.refundType.label')}"/>
                <g:sortableColumn params="${params}" property="refundBankName" title="${message(code: 'tradeRefundBatch.refundBankName.label')}"/>
                <g:sortableColumn params="${params}" property="appName" title="${message(code: 'tradeRefundBatch.appName.label')}"/>
                <g:sortableColumn params="${params}" property="refundDate" title="${message(code: 'tradeRefundBatch.refundDate.label')}"/>
                <g:sortableColumn params="${params}" property="status" title="${message(code: 'tradeRefundBatch.status.label')}"/>
                <th>操作</th>
            </tr>

            <g:each in="${tradeRefundBatchInstanceList}" status="i" var="tradeRefundBatch">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>${tradeRefundBatch.id.toString().replace(',','')}</td>
                    <td>${fieldValue(bean: tradeRefundBatch, field: "batchCount")}</td>
                    <td><g:formatNumber number="${tradeRefundBatch?.batchAmount?tradeRefundBatch?.batchAmount/100:0}" type="currency" currencyCode="CNY"/></td>
                    <td>${tradeRefundBatch.refundTypeMap[tradeRefundBatch?.refundType]}</td>
                    <td>${fieldValue(bean: tradeRefundBatch, field: "refundBankName")}</td>

                    <td>${fieldValue(bean: tradeRefundBatch, field: "appName")}</td>
                    <td><g:formatDate date="${tradeRefundBatch?.refundDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${tradeRefundBatch.statusMap[tradeRefundBatch?.status]}</td>
                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.Trade_RfdBthChk_View){true}}"><g:link action="batchDetailShow" id="${tradeRefundBatch.id}">详情</g:link></g:if>
                    </td>
                </tr>
            </g:each>
        </table>
        合计：金额总计：${totalAmount ? totalAmount / 100 : 0}元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;笔数总计：${totalCount ? totalCount : 0}笔
        <div class="paginateButtons">
            <span style=" float:left;">共${tradeRefundBatchInstanceTotal}条记录</span>
            <g:paginat total="${tradeRefundBatchInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
