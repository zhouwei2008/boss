<%@ page import="ismp.CmCustomer; ismp.TradeBase; ismp.TbRiskList" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbRiskList.label', default: '风险交易')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <g:javascript src="/My97DatePicker/WdatePicker.js"></g:javascript>
</head>

<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">风险交易列表</h1>
        <div class="table_serch">
            <g:form>

                <table>
                    <tr>
                        <td>
                            交易流水号：<g:textField name="serialNo" maxlength="64" style="width:100px" value="${params.serialNo}" />
                        </td>

                        <td>
                            交易时间：<g:textField name="startDate"  size="10" onclick="WdatePicker({dataFmt:'yyyy-MM-dd',readOnly:true})" value="${params.startDate}"  style="width:80px"/> —
                                     <g:textField name="endDate"  size="10" onclick="WdatePicker({dataFmt:'yyyy-MM-dd',readOnly:true})"  value="${params.endDate}"  style="width:80px"/>
                        </td>

                        <td>
                            业务类型：<g:select name="tradeType"
                                      from="${ismp.TbRiskList.TradeTypeMap}" value="${params.tradeType}" noSelection="${['':'--全部--']}" optionKey="key" optionValue="value" style="width:120px;height:23px;"/>
                        </td>
                       </tr>

                     <tr>
                        <td>
                            商户名称：<g:textField name="merchantName" maxlength="64" style="width:100px" value="${params.merchantName}" />
                        </td>

                        <td>
                            交易金额：<g:textField name="beginAmount" style="width:80px" maxlength="12" value="${params.beginAmount}" /> —
                                      <g:textField name="endAmount" style="width:80px" maxlength="12" value="${params.endAmount}" />
                        </td>

                        <td>
                            交易规则：<g:select name="riskControlId"
                                               from="${ismp.TbRiskControl.findAll()}" value="${params.riskControlId}" noSelection="${['':'--全部--']}" optionKey="id" optionValue="ruleAbout" style="width:120px;height:23px;"/>

                        </td>

                        <td>
                           <g:actionSubmit  action="list" value="查询" style="width:100px;height:23px;" onclick="return checkDate()"/>
                           <g:actionSubmit  action="listDownload" value="导出" style="width:100px;height:23px;" onclick="return checkDate()"/>
                        </td>
                    </tr>

                </table>


            </g:form>
        </div>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="serialNo"
                                  title="${message(code: 'tbRiskList.serialNo.label', default: '交易流水号')}"/>


                <g:sortableColumn params="${params}" property="createdDate"
                                  title="${message(code: 'tbRiskList.tradeType.label', default: '交易时间')}"/>

                <g:sortableColumn params="${params}" property="tradeType"
                                  title="${message(code: 'tbRiskList.tradeType.label', default: '业务类型')}"/>

                <g:sortableColumn params="${params}" property="tradeBase"
                                  title="${message(code: 'tbRiskList.tradeBase.label', default: '交易类型')}"/>

                <g:sortableColumn params="${params}" property="riskControl"
                                  title="${message(code: 'tbRiskList.riskControl.label', default: '交易规则')}"/>


                <g:sortableColumn params="${params}" property="amount"
                                  title="${message(code: 'tbRiskList.amount.label', default: '金额')}"/>


                <g:sortableColumn params="${params}" property="merchantNo"
                                  title="${message(code: 'tbRiskList.merchantNo.label', default: '商户号')}"/>

                <g:sortableColumn params="${params}" property="merchantName"
                                  title="${message(code: 'tbRiskList.merchantName.label', default: '商户名称')}"/>

                %{--<g:sortableColumn params="${params}" property="operation"--}%
                                  %{--title="${message(code: 'tbRiskList.operation.label', default: '操作')}"/>--}%
            </tr>

            <g:each in="${tbRiskListInstanceList}" status="i" var="tbRiskListInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="qry" controller="tradeBase"
                                id="${tbRiskListInstance.serialNo}">${fieldValue(bean: tbRiskListInstance, field: "serialNo")}</g:link></td>

                    <td><g:formatDate date="${tbRiskListInstance?.tradeDate}" format="yyyy-MM-dd HH:mm:ss"/></td>

                    <g:if test="${CmCustomer.findByCustomerNo(tbRiskListInstance?.merchantNo)?.type=='P'}">
                        <td>移动电话支付</td>
                    </g:if>
                    <g:elseif test="${CmCustomer.findByCustomerNo(tbRiskListInstance?.merchantNo)?.type=='C'}">
                    <td>互联网支付</td>
                    </g:elseif>

                    <td>${TradeBase.tradeTypeMap[tbRiskListInstance?.tradeBase?.tradeType]}</td>

                    <td>${tbRiskListInstance?.riskControl?.ruleAbout}</td>

                    <td>
                       <g:formatNumber number="${tbRiskListInstance?.amount/100}" type="currency" currencyCode="CNY"/>
                    </td>

                    <td>${fieldValue(bean: tbRiskListInstance, field: "merchantNo")}</td>

                    <td>${fieldValue(bean: tbRiskListInstance, field: "merchantName")}</td>
                    %{--<td>--}%
                        %{--<g:link action="#" controller="tradeBase">通过</g:link> |--}%
                        %{--<g:link action="#" controller="tradeBase">拒绝</g:link>--}%
                    %{--</td>--}%
                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${tbRiskListInstanceTotal}条记录</span>
            <g:paginat total="${tbRiskListInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function() {
        $("#startDate").WdatePicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endDate").WdatePicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
    });

    function checkDate() {
        var startDate = document.getElementById("startDate").value;
        var endDate = document.getElementById("endDate").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endDate").focus();
            return false;
        }
    }

</script>
</body>
</html>
