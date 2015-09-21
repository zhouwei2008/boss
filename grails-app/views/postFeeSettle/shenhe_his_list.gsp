<%@ page import="boss.Perm" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'postFeeSettleshenhe_his_list.lable')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <style>
    table {
        width: 100%;
    }

    table th {
        word-break: keep-all;
        white-space: nowrap;
    }

    table td {
        word-break: keep-all;
        white-space: nowrap;
    }
    </style>
</head>
<body>
<g:javascript>
    $(function() {
        $("#startFootDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endFootDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#startcheckDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endcheckDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#startDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });

    function checkDate2() {
        if (!document.getElementById('endTradeDate').value.length == 0) {
            var startDateCreated = document.getElementById('startTradeDate').value;
            var endDateCreated = document.getElementById('endTradeDate').value;
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始日期不能大于结束日期!');
                document.getElementById('endTradeDate').focus();
                return false;
            }
        }

        if (!document.getElementById('endFootDate').value.length == 0) {
            var startDateCreated = document.getElementById('startFootDate').value;
            var endDateCreated = document.getElementById('endFootDate').value;
            if (Number(startDateCreated > endDateCreated)) {
                alert('提交开始日期不能大于结束日期!');
                document.getElementById('endFootDate').focus();
                return false;
            }
        }

        if (!document.getElementById('endcheckDate').value.length == 0) {
            var startDateCreated = document.getElementById('startcheckDate').value;
            var endDateCreated = document.getElementById('endcheckDate').value;
            if (Number(startDateCreated > endDateCreated)) {
                alert('复核开始日期不能大于结束日期!');
                document.getElementById('endcheckDate').focus();
                return false;
            }
        }
    }

            /*---guonan update 2011-12-30----*/
    function checkDate() {
        var startDateCreated = document.getElementById('startDate').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endDate').value.replace(/-/g,"//");
        var startFootDate = document.getElementById('startFootDate').value.replace(/-/g,"//");
        var endFootDate = document.getElementById('endFootDate').value.replace(/-/g,"//");
        var startcheckDate = document.getElementById('startcheckDate').value.replace(/-/g,"//");
        var endcheckDate = document.getElementById('endcheckDate').value.replace(/-/g,"//");

        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDate').focus();
                return false;
            }
        }
        if (endFootDate.length != 0) {
            if (Number(startFootDate > endFootDate)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endFootDate').focus();
                return false;
            }
        }

        if (endcheckDate.length != 0) {
            if (Number(startcheckDate > endcheckDate)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endcheckDate').focus();
                return false;
            }
        }
    }
     function empty() {
        $(':input') .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
        return false;
    }
</g:javascript>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top" style="width:auto;">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form controller="postFeeSettle" action="shenhe_his_list">
                提交日期：<g:textField name="startFootDate" value="${params.startFootDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--<g:textField name="endFootDate" value="${params.endFootDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>
                复核日期:<g:textField name="startcheckDate" value="${params.startcheckDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--<g:textField name="endcheckDate" value="${params.endcheckDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>
                日期：<g:textField name="startDate" value="${params.startDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--<g:textField name="endDate" value="${params.endDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>
                提交人:<g:textField name="createopt" maxlength="20" onblur="value=value.replace(/[ ]/g,'')" value="${params.createopt}" class="right_top_h2_input"/>
                <br/>
                复核人:<g:textField name="checkopt" maxlength="20" onblur="value=value.replace(/[ ]/g,'')" value="${params.checkopt}" class="right_top_h2_input"/>
                商户编码：<g:textField name="customerNo" maxlength="24" onblur="value=value.replace(/[ ]/g,'')" value="${params.customerNo}" class="right_top_h2_input"/>
                名称：<g:textField name="name" maxlength="64" onblur="value=value.replace(/[ ]/g,'')" value="${params.name}" class="right_top_h2_input"/>
                状态：<g:select name="checkstatus" value="${params.checkstatus}" from="${settle.FtFoot.checkStatusMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/>
                <g:actionSubmit class="right_top_h2_button_serch" action="shenhe_his_list" value="查询" onclick="return checkDate()" />
                <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
                <g:actionSubmit class="right_top_h2_button_download" action="shenhe_his_download" value="下载" onclick="return checkDate()" />
            </g:form>
        </h2>
    </div>
    <div class="right_list_tablebox">
    <table align="center" class="right_list_table" id="test">
        <tr>
            <th>序号</th>
            <th>商户编号</th>
            <th>名称/商户名称</th>
            <tH>批次号</tH>
            <th>提交日期</th>
            <th>复核日期</th>
            <th>日期</th>
            <th>业务类型</th>
            <th>交易类型</th>
            <th>交易笔数</th>
            <th>金额</th>
            <th>后返手续费</th>
            <th>还款金额</th>
            <th>操作</th>
            <th>提交人</th>
            <th>复核人</th>
            <th>状态</th>
            <th>备注</th>
        </tr>
        <g:each in="${ftTradeFeeList}" status="i" var="item">
            <tr>
                <td>${i + 1}</td>
                <td>${item.CUSTOMER_NO}</td>
                <g:set var="cu" value="${ismp.CmCustomer.findByCustomerNo(item.CUSTOMER_NO)}"/>
                <td>${cu?.name}/${cu?.registrationName}</td>
                <td>${item.FOOT_NO}</td>
                <td><g:formatDate format="yyyy.MM.dd" date="${item.FOOT_DATE}"/></td>
                <td><g:formatDate format="yyyy.MM.dd" date="${item.CHECK_DATE}"/></td>
                <td><g:formatDate format="yyyy.MM.dd" date="${item.MINTIME}"/>-<g:formatDate format="yyyy.MM.dd" date="${item.MAXTIME}"/></td>
                <td>${item.SRV_NAME}</td>
                <td>${item.TRADE_NAME}</td>
                <td>${item.TRANS_NUM}</td>
                <td>${item.AMOUNT / 100}</td>
                <td><g:if test="${item.POST_FEE}">${item.POST_FEE / 100}</g:if></td>
                <td><g:if test="${item.POST_FEE}">${item.POST_FEE / 100}</g:if></td>
                <td>
                  <bo:hasPerm perm="${Perm.Settle_PostSettleHis_Detail}">
                    <g:if test="${item.CHECK_STATUS.toString() != '2'}">
                        <a href='${createLink(controller: 'postFeeSettle', action: 'shenhe_his_show', params: ['customerNo': item.CUSTOMER_NO, 'customerName': item.CUSTOMR_NAME, 'FOOT_NO': item.FOOT_NO, 'tradecode': item.TRADE_CODE, 'srvcode': item.SRV_CODE, 'status': item.CHECK_STATUS.toString()])}'>查看明细</a>
                    </g:if>
                  </bo:hasPerm>
                </td>
                <td>${boss.BoOperator.get(item.CREATE_OP_ID)?.account}</td>
                <td>${boss.BoOperator.get(item.CHECK_OP_ID)?.account}</td>
                <td>${settle.FtFoot.checkStatusMap[item.CHECK_STATUS.toString()]}</td>
                <td>${item.REJECT_REASON}</td>
            </tr>
        </g:each>
    </table>
    </div>
    合计：金额：<g:formatNumber number="${total_amount / 100}" format="#.##"/>元，后返手续费金额：<g:formatNumber number="${total_postfee / 100}" format="#.##"/>元，还款金额：<g:formatNumber number="${total_postfee / 100}" format="#.##"/>元
    <div class="paginateButtons">
        <div align="left"><div style="position:absolute;">共${total}条记录</div></div>
        <g:paginat total="${total}" params="${params}"/>
    </div>
</div>
</body>
</html>