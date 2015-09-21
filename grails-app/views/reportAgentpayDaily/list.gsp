<%@ page import="boss.Perm; ismp.CmCustomer; boss.ReportAgentpayDaily;ismp.CmCorporationInfo" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'reportAgentpayDaily.label', default: 'ReportAgentpayDaily')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<script type="text/javascript">
    $(function() {
        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
    });

    /*---guonan update 2011-12-30----*/
    function checkDate() {
        var startDateCreated = document.getElementById('startDateCreated').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endDateCreated').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
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
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1>
           <g:if test="${params.tradeType == 'S'}">代收</g:if><g:else>代付</g:else>${message(code: 'reportAgentpayDaily.label', default: '')}
           </h1>
        <div class="table_serch">
            <table>
                <g:form>
                    <tr>
                        <td>${message(code: 'reportAgentpayDaily.customerRegion.label')}：</td>
                        <td><p><g:textField name="region"  value="${params.region}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'reportAgentpayDaily.customerName.label')}：</td>
                        <td><p><g:textField name="customerName"  value="${params.customerName}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'reportAgentpayDaily.customerNo.label')}：</td>
                        <td><p><g:textField name="customerNo"  value="${params.customerNo}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'reportAgentpayDaily.customerType.label')}：</td>
                        <td><p><g:select name="customerType" from="${ReportAgentpayDaily.customerTypeMap}" value="${params.customerType}" optionKey="key" optionValue="value"  class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td>${message(code: 'reportAgentpayDaily.tradeFinishdate.label')}：</td>
                        <td><p><g:textField name="startDateCreated" id='startDateCreated' readonly="true" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.startDateCreated}" class="right_top_h2_input"/>--<g:textField name="endDateCreated"  id='endDateCreated' readonly="true" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.endDateCreated}" onchange="checkDate()" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'reportAgentpayDaily.displayType.label', default: '')}:</td>
                        <td><p><g:select name="selType" from="${ReportAgentpayDaily.selTypeMap}" value="${params.selType}" optionKey="key" optionValue="value"  class="right_top_h2_input"/></p></td>
		            </tr>
                    <tr>
                        <td> &nbsp;</td>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkDate()"/></td>
                        <td><g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/></td>
                        <g:if test="${params.tradeType == 'S'}">
                            <bo:hasPerm perm="${Perm.Report_AgentcollDaily_Dl}">
                            <td><g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()"/></td>
                            </bo:hasPerm>
                         </g:if>
                        <g:else>
                            <bo:hasPerm perm="${Perm.Report_AgentpayDaily_Dl}">
                            <td><g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()"/></td>
                            </bo:hasPerm>
                        </g:else>
                    </tr>
                    <g:hiddenField name="tradeType"  value="${params.tradeType}" />
                </g:form>
            </table>
        </div>

        <table align="center" class="right_list_table" id="test">

            <tr>
                <th rowspan="2">${message(code: 'reportAgentpayDaily.customerRegion.label', default: '')}</th>

                <th rowspan="2">${message(code: 'reportAgentpayDaily.customerName.label', default: '')}</th>

                <th colspan="10"><g:if test="${params.tradeType == 'S'}">代收</g:if><g:else>代付</g:else>&nbsp;&nbsp;&nbsp;&nbsp;(金额单位:元)</th>
            </tr>
            <tr><g:if test="${params.tradeType == 'S'}">
                    <g:sortableColumn params="${params}" property="cc" title="代收${message(code: 'reportAgentpayDaily.count.label', default: 'count')}"/>
                    <g:sortableColumn params="${params}" property="aa" title="代收${message(code: 'reportAgentpayDaily.amount.label', default: 'amount')}"/>
                    <g:sortableColumn params="${params}" property="cs" title="代收${message(code: 'reportAgentpayDaily.tradeCountSuccess.label', default: 'tradeCountSuccess')}"/>
                    <g:sortableColumn params="${params}" property="ts" title="代收${message(code: 'reportAgentpayDaily.tradeAmountSuccess.label', default: 'tradeAmountSuccess')}"/>
                    <g:sortableColumn params="${params}" property="cf" title="代收${message(code: 'reportAgentpayDaily.tradeCountFail.label', default: 'tradeCountFail')}"/>
                    <g:sortableColumn params="${params}" property="af" title="代收${message(code: 'reportAgentpayDaily.tradeAmountFail.label', default: 'tradeAmountFail')}"/>
                </g:if>
                <g:else>
                    <g:sortableColumn params="${params}" property="cc" title="代付${message(code: 'reportAgentpayDaily.count.label', default: 'count')}"/>
                    <g:sortableColumn params="${params}" property="aa" title="代付${message(code: 'reportAgentpayDaily.amount.label', default: 'amount')}"/>
                    <g:sortableColumn params="${params}" property="cs" title="代付${message(code: 'reportAgentpayDaily.tradeCountSuccess.label', default: 'tradeCountSuccess')}"/>
                    <g:sortableColumn params="${params}" property="ts" title="代付${message(code: 'reportAgentpayDaily.tradeAmountSuccess.label', default: 'tradeAmountSuccess')}"/>
                    <g:sortableColumn params="${params}" property="cf" title="代付${message(code: 'reportAgentpayDaily.tradeCountFail.label', default: 'tradeCountFail')}"/>
                    <g:sortableColumn params="${params}" property="af" title="代付${message(code: 'reportAgentpayDaily.tradeAmountFail.label', default: 'tradeAmountFail')}"/>
                </g:else>
                <g:sortableColumn params="${params}" property="sa" title="${message(code: 'reportAgentpayDaily.tradeSettleAmount.label', default: 'tradeSettleAmount')}"/>
                <g:sortableColumn params="${params}" property="sf" title="${message(code: 'reportAgentpayDaily.tradeSettleFee.label', default: 'tradeSettleFee')}"/>
                <g:sortableColumn params="${params}" property="sf" title="${message(code: 'reportAgentpayDaily.bankfee.label', default: 'bankfee')}"/>
                <g:sortableColumn params="${params}" property="sn" title="${message(code: 'reportAgentpayDaily.netAmount.label', default: 'netAmount')}"/>
             </tr>

            <g:each in="${reportAgentpayDailyInstanceList}" status="i" var="instance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" align="right">

                    <td>${CmCorporationInfo.get(instance.CUSTOMER_ID)?.belongToArea}</td>
                    <td>${CmCustomer.get(instance.CUSTOMER_ID)?.name}</td>
                    <td>${instance.CC?instance.CC:0}</td>
                    <td><g:formatNumber number="${instance.AA?(instance.AA as Long)/100:0.00}" format="#.##"/></td>
                    <td>${instance.CS?instance.CS:0}</td>
                    <td><g:formatNumber number="${instance.TS?(instance.TS as Long)/100:0.00}" format="#.##"/></td>
                    <td>${instance.CF?instance.CF:0}</td>
                    <td><g:formatNumber number="${instance.AF?(instance.AF as Long)/100:0.00}" format="#.##"/></td>
                    <td><g:formatNumber number="${instance.SA?(instance.SA as Long)/100:0.00}" format="#.##"/></td>
                    <td><g:formatNumber number="${instance.SF?(instance.SF as Long)/100:0.00}" format="#.##"/></td>
                    <td>&nbsp;</td>
                    <td><g:formatNumber number="${instance.SN?(instance.SN as Long)/100:0.00}" format="#.##"/></td>
                </tr>
            </g:each>
            <tr align="right">
                    <td colspan="2">合计:${reportAgentpayDailyInstanceTotal}</td>
                    <td>${totalAgent.tcc?totalAgent.tcc:0}</td>
                    <td><g:formatNumber number="${totalAgent.taa?(totalAgent.taa as Long)/100:0.00}" format="#.##"/></td>
                    <td>${totalAgent.tcs?totalAgent.tcs:0}</td>
                    <td><g:formatNumber number="${totalAgent.tts?(totalAgent.tts as Long)/100:0.00}" format="#.##"/></td>
                    <td>${totalAgent.tcf?totalAgent.tcf:0}</td>
                    <td><g:formatNumber number="${totalAgent.taf?(totalAgent.taf as Long)/100:0.00}" format="#.##"/></td>
                    <td><g:formatNumber number="${totalAgent.tsa?(totalAgent.tsa as Long)/100:0.00}" format="#.##"/></td>
                    <td><g:formatNumber number="${totalAgent.tsf?(totalAgent.tsf as Long)/100:0.00}" format="#.##"/></td>
                    <td>&nbsp;</td>
                    <td><g:formatNumber number="${totalAgent.tsn?(totalAgent.tsn as Long)/100:0.00}" format="#.##"/></td>
            </tr>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${reportAgentpayDailyInstanceTotal}条记录</span>
            <g:paginat total="${reportAgentpayDailyInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
