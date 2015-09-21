<%@ page import="boss.Perm; boss.BoAcquirerAccount; ismp.TradeRefund" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="报表"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    function cl() {
        document.getElementById("startDate").value = '';
        document.getElementById("endDate").value = '';
        document.getElementById("paymentType").value = '-1';
        document.getElementById("bankName").value = '';
        document.getElementById("startDate").focus();
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">按银行划分系统数据统计表</h1>
        <h2>
            <g:form action="bankType">
                <table>
                    <tr>
                        <td>日期 ：</td>
                        <td><g:textField name="startDate" value="${params.startDate}" size="10" class="right_top_h2_input" style="width:80px"/>
                            -- <g:textField name="endDate" value="${params.endDate}" size="10" class="right_top_h2_input" style="width:80px"/></td>
                        <td>银行：</td><TD><p><g:select from="${BoAcquirerAccount.findAllWhere(bankAccountType: 'company',status:'normal')}" value="${params.bankName}" name="bankName" id="bankName" optionKey="id" optionValue="branchName" noSelection="${['':'-全部-']}" class="right_top_h2_input"></g:select></p></TD>
                        <td>银行渠道：</td><td><select name="paymentType" id="paymentType">
                        <option value="-1">--请选择--</option>
                        <option value="1" ${bankChannel == '1' ? 'selected' : ''}>B2C</option>
                        <option value="2" ${bankChannel == '2' ? 'selected' : ''}>B2B</option>
                        <option value="3" ${bankChannel == '3' ? 'selected' : ''}>大额通道</option>
                        <option value="S" ${bankChannel == 'S' ? 'selected' : ''}>代收</option>
                        <option value="F" ${bankChannel == 'F' ? 'selected' : ''}>代付</option>
                    </select>
                    </td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>
                            <input type="submit" class="right_top_h2_button_serch" value="查询">
                            <input type="button" class="right_top_h2_button_clear" value="清空" onClick="cl()">
                            <bo:hasPerm perm="${Perm.Report_BankTypeDaily_Dl}"><g:actionSubmit class="right_top_h2_button_download" action="bankListDownload" value="下载"/></bo:hasPerm>
                        </td>
                    </tr>
                    <tr>

                    </tr>
                </table>
            </g:form>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr align="center"><font size="5"><b>按银行划分系统数据统计表</b></font></tr>
            <tr>&nbsp;&nbsp; 日期:&nbsp;&nbsp;&nbsp;&nbsp;<g:formatDate date="${date}" format="yyyy-MM-dd"/></tr>
            <tr>&nbsp;</tr>
            <tr>
                <td rowspan="2">银行类贷记账户</td>
                <td rowspan="2">银行通道</td>
                <td colspan="3">交易入账</td>
                <td colspan="3">退款</td>
                <td colspan="3">付款结算金额</td>
                <td rowspan="2">银行手续费<br>（成本合计）</td>
            </tr>
            <tr>
                <td>笔数</td>
                <td>金额</td>
                <td>银行手续费成本</td>
                <td>笔数</td>
                <td>金额</td>
                <td>银行手续费成本</td>
                <td>笔数</td>
                <td>金额</td>
                <td>银行手续费成本</td>
            </tr>

            <g:each in="${result1}" status="i" var="trade1">
                <% int j = 0; l = 0; m = 0; n = 0; flag = 0; %>
                <tr>
                    <td rowspan="2">${trade1.NAME}</td>
                    <td>B2C</td>
                    <td>
                        <g:each in="${result}" status="K" var="trade">
                            <g:if test="${trade.NUM==trade1.NO && trade.CHANNEL=='1'}">${trade.CO}<% flag = 1 %></g:if>
                        </g:each>
                        <g:if test="${flag==0}">
                            0
                        </g:if>
                        <% flag = 0 %>
                    </td>
                    <td>
                        <g:each in="${result}" status="K1" var="trade2">
                            <g:if test="${trade2.NUM==trade1.NO && trade2.CHANNEL=='1'}">${trade2.AM == null ? 0 : trade2.AM / 100}<% flag = 1 %></g:if>
                        </g:each>
                        <g:if test="${flag==0}">
                            0
                        </g:if>
                        <% flag = 0 %>
                    </td>
                    <td>0</td>
                    <td>
                        <g:each in="${result2}" status="r" var="refund">
                            <g:if test="${refund.NO==trade1.NO && refund.CHANNEL=='1'}">${refund.CO}<% flag = 1 %></g:if>
                        </g:each>
                        <g:if test="${flag==0}">
                            0
                        </g:if>
                        <% flag = 0 %>
                    </td>
                    <td>
                        <g:each in="${result2}" status="r1" var="refund1">
                            <g:if test="${refund1.NO==trade1.NO && refund1.CHANNEL=='1'}">${refund1.AM == null ? 0 : refund1.AM / 100}<% flag = 1 %></g:if>
                        </g:each>
                        <g:if test="${flag==0}">
                            0
                        </g:if>
                        <% flag = 0 %>
                    </td>
                    <td>0</td>
                    <td rowspan="2">
                        <g:each in="${result3}" status="w" var="withdrawn">
                            <g:if test="${withdrawn.NO==trade1.NO }">${withdrawn.CO}<% flag = 1 %></g:if>
                        </g:each>
                        <g:if test="${flag==0}">
                            0
                        </g:if>
                        <% flag = 0 %>
                    </td>
                    <td rowspan="2">
                        <g:each in="${result3}" status="w" var="withdrawn">
                            <g:if test="${withdrawn.NO==trade1.NO }">${withdrawn.AM == null ? 0 : withdrawn.AM / 100}<% flag = 1 %></g:if>
                        </g:each>
                        <g:if test="${flag==0}">
                            0
                        </g:if>
                        <% flag = 0 %>
                    </td>
                    <td rowspan="2">0</td>
                    <td rowspan="2">0</td>
                </tr>

                <tr>
                    <td>小计</td>
                    <td>
                        <g:each in="${result}" status="K7" var="trade7">
                            <g:if test="${trade7.NUM==trade1.NO }"><% j = j + trade7.CO %></g:if>
                        </g:each>
                        <font color="red"><%=j%></font>
                    </td>
                    <td>
                        <g:each in="${result}" status="K8" var="trade8">
                            <g:if test="${trade8.NUM==trade1.NO }"><% l = l + trade8.AM / 100 %></g:if>
                        </g:each>
                        <font color="red"><%=l%></font>
                    </td>
                    <td>0</td>
                    <td>
                        <% int m = 0; n = 0; %>
                        <g:each in="${result2}" status="r6" var="refund6">
                            <g:if test="${refund6.NO==trade1.NO }"><% m = m + refund6.CO %></g:if>
                        </g:each>
                        <font color="red"><%=m%></font>
                    </td>
                    <td>
                        <g:each in="${result2}" status="r7" var="refund7">
                            <g:if test="${refund7.NO==trade1.NO }"><% n = n + refund7.AM / 100 %></g:if>
                        </g:each>
                        <font color="red"><%=n%></font>
                    </td>
                    <td>0</td>

                </tr>
            </g:each>
            <tr>
                <td colspan="2" align="left">合计</td>
                <td>${inTotalCo == null ? 0 : inTotalCo}</td>
                <td>${inTotalAm == null ? 0 : inTotalAm / 100}</td>
                <td>0</td>
                <td>${totalCo == null ? 0 : totalCo}</td>
                <td>${totalAm == null ? 0 : totalAm / 100}</td>
                <td>0</td>
                <td>${totalWithdrawnCo == null ? 0 : totalWithdrawnCo}</td>
                <td>${totalWithdrawnAm == null ? 0 : totalWithdrawnAm / 100}</td>
                <td>0</td>
                <td>0</td>
            </tr>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${total}条记录</span>
            <g:paginat total="${total}" params="${params}"/>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function() {
        $("#startDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });
</script>
</body>
</html>
