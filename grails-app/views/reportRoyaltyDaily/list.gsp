<%@ page import="boss.Perm; boss.ReportAgentpayDaily" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="分润业务统计报表"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <g:javascript library="jquery-1.4.4.min"/>
    <g:javascript>
        $(function() {
            $("#startTime").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
            $("#endTime").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        });

        function checkDate() {
            var startTime = document.getElementById('startTime').value.replace(/-/g,"//");
            var endTime = document.getElementById('endTime').value.replace(/-/g,"//");
            if (endTime.length != 0) {
                if (Number(startTime > endTime)) {
                    alert('开始时间不能大于结束时间!');
                    document.getElementById('endTime').focus();
                    return false;
                }
            }
        }

        function empty() {
            document.getElementById('startTime').value='';
            document.getElementById('endTime').value='';
            document.getElementById('customerName').value='';
            document.getElementById('customerName').focus();
            return false;
        }
    </g:javascript>
</head>

<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1>分润业务统计报表</h1>
        <div class="table_serch">
            <table>
                <g:form>
                    <tr>
                        <td>商户名称：</td>
                        <td><p><g:textField name="customerName"  value="${params.customerName}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                        <td>交易完成时间：</td>
                        <td>
                            <g:textField name="startTime" id='startTime' readonly="true" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.startTime}" class="right_top_h2_input"/>
                            --
                            <g:textField name="endTime"  id='endTime' readonly="true" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.endTime}" class="right_top_h2_input"/>
                        </td>
                    </tr>
                    <tr>
                        <td> &nbsp;</td>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkDate()"/></td>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="" value="清空" onclick="return empty()"/></td>
                        <bo:hasPerm perm="${Perm.Report_RoyaltyDaily_Dl}">
                        <td><g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载"/></td>
                        </bo:hasPerm>
                    </tr>
                </g:form>
            </table>
        </div>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <th>&nbsp;</th>
                <g:sortableColumn params="${params}" property="AREA" title="区域"/>
                <g:sortableColumn params="${params}" property="CUSTOMER_NAME" title="商户名称"/>
                <g:sortableColumn params="${params}" property="RPN" title="分润支付笔数"/>
                <g:sortableColumn params="${params}" property="RPA" title="分润支付金额"/>
                <g:sortableColumn params="${params}" property="RRN" title="分润支付退款笔数"/>
                <g:sortableColumn params="${params}" property="RRA" title="分润支付退款金额"/>
                <g:sortableColumn params="${params}" property="SA" title="结算金额"/>
                <g:sortableColumn params="${params}" property="SF" title="手续费收入"/>
                <g:sortableColumn params="${params}" property="NN" title="交易笔数小计"/>
                <g:sortableColumn params="${params}" property="NA" title="交易净额"/>
            </tr>
            <g:each in="${list}" status="i" var="item">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>&nbsp;</td>
                    <td>${item.AREA}</td>
                    <td>${item.CUSTOMER_NAME}</td>
                    <td>${item.RPN}</td>
                    <td><g:formatNumber number="${item.RPA?item.RPA/100:0}" type="currency" currencyCode="CNY"/></td>
                    <td>${item.RRN}</td>
                    <td><g:formatNumber number="${item.RRA?item.RRA/100:0}" type="currency" currencyCode="CNY"/></td>
                    <td><g:formatNumber number="${item.SA?item.SA/100:0}" type="currency" currencyCode="CNY"/></td>
                    <td><g:formatNumber number="${item.SF?item.SF/100:0}" type="currency" currencyCode="CNY"/></td>
                    <td>${item.NN}</td>
                    <td><g:formatNumber number="${item.NA?item.NA/100:0}" type="currency" currencyCode="CNY"/></td>
                </tr>
            </g:each>
            <tr>
                <td>合计</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>${sumList.trpn}</td>
                <td><g:formatNumber number="${sumList.trpa?sumList.trpa/100:0}" type="currency" currencyCode="CNY"/></td>
                <td>${sumList.trrn}</td>
                <td><g:formatNumber number="${sumList.trra?sumList.trra/100:0}" type="currency" currencyCode="CNY"/></td>
                <td><g:formatNumber number="${sumList.tsa?sumList.tsa/100:0}" type="currency" currencyCode="CNY"/></td>
                <td><g:formatNumber number="${sumList.tsf?sumList.tsf/100:0}" type="currency" currencyCode="CNY"/></td>
                <td>${sumList.tnn}</td>
                <td><g:formatNumber number="${sumList.tna?sumList.tna/100:0}" type="currency" currencyCode="CNY"/></td>
            </tr>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${total}条记录</span>
            <g:paginat total="${total}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>