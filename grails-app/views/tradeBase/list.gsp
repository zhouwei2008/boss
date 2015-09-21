<%@ page import="ismp.TradeTransfer; ismp.TradePayment; ismp.TradeCharge; ismp.CmCorporationInfo; boss.BoAcquirerAccount; boss.BoMerchant; gateway.GwTransaction; boss.Perm; ismp.CmCustomer; ismp.TradeBase; ismp.TradeBase4Query" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeBase.label', default: 'TradeBase')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startTradeDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endTradeDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#startLastUpdated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endLastUpdated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });

    });
    function checkDate() {
        if (!document.getElementById('endDateCreated').value.length == 0) {
            var startDateCreated = document.getElementById('startDateCreated').value;
            var endDateCreated = document.getElementById('endDateCreated').value;
            if (Number(startDateCreated > endDateCreated)) {
                alert('创建开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }
        if (!document.getElementById('endLastUpdated').value.length == 0) {
            var startLastUpdated = document.getElementById('startLastUpdated').value;
            var endLastUpdated = document.getElementById('endLastUpdated').value;
            if (Number(startLastUpdated > endLastUpdated)) {
                alert("修改开始时间不能大于结束时间!");
                document.getElementById('endLastUpdated').focus();
                return false;
            }
        }
        if (!document.getElementById('endTradeDate').value.length == 0) {
            var startTradeDate = document.getElementById('startTradeDate').value;
            var endTradeDate = document.getElementById('endTradeDate').value;
            if (Number(startTradeDate > endTradeDate)) {
                alert("交易开始时间不能大于结束时间!");
                document.getElementById('endTradeDate').focus();
                return false;
            }
        }
    }
    function cl() {
        var form = document.forms[0];
        for (var i = 0; i < form.elements.length; i++) {
            if (form.elements[i].type == "text" || form.elements[i].type == "text")
                form.elements[i].value = "";
        }

        document.getElementById("tradeType").value = "";
        document.getElementById("status").value = "";
        document.getElementById("serviceType").value = "-1";
        document.getElementById("paymentType").value = "-1";
        document.getElementById("startDateCreated").focus();
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <g:if test="${flag==-1}">
        <script type="text/javascript">
            alert("您的账号没有任何分公司权限");
         </script>
    </g:if>
    <g:if test="${flag==-2}">
        <script type="text/javascript">
            alert("您的账号没有关联任何销售");
         </script>
    </g:if>
    <div class="right_top">
        <h1><img alt="" src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <div class="table_serch">
            <table>
                <g:form>
                    <tr>
                        <td>创建时间：</td><td><g:textField name="startDateCreated" value="${params.startDateCreated}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--<g:textField name="endDateCreated" value="${params.endDateCreated}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/></td>
                        <td>交易日期：</td><td><g:textField name="startTradeDate" value="${params.startTradeDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--<g:textField name="endTradeDate" value="${params.endTradeDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/></td>
                        <td>完成时间：</td><td><g:textField name="startLastUpdated" value="${params.startLastUpdated}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--<g:textField name="endLastUpdated" value="${params.endLastUpdated}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/></td>
                    </tr>
                    <tr>
                        <td>交易流水号：</td><td><p><g:textField name="tradeNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.tradeNo}" class="right_top_h2_input"/></p></td>
                        <td>外部订单号：</td><td><p><g:textField name="outTradeNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.outTradeNo}" class="right_top_h2_input"/></p></td>
                        <td>交易类型：</td><td><p><g:select name="tradeType" value="${params.tradeType}" from="${TradeBase.tradeTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                        <td>交易状态：</td><td><p><g:select name="status" value="${params.status}" from="${TradeBase.statusMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td>付款客户：</td><td><p><g:textField name="payerCustomerNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerCustomerNo}" class="right_top_h2_input"/></p></td>
                        <td>收款客户：</td><td><p><g:textField name="payeeCustomerNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payeeCustomerNo}" class="right_top_h2_input"/></p></td>
                        <td>交易客户：</td><td><p><g:textField name="customerNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.customerNo}" class="right_top_h2_input"/></p></td>
                        <td>交易金额：</td><td><p><g:textField name="startAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.startAmount}" class="right_top_h2_input" style="width:60px"/>--<g:textField name="endAmount" onkeyup="if(isNaN(value))execCommand('undo')" onblur="value=value.replace(/[ ]/g,'')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endAmount}" class="right_top_h2_input" style="width:60px"/></p></td>
                    </tr>
                    <tr>
                        <td>服务类型：</td><td><p><g:select name="serviceType" value="${params.serviceType}" from="${TradeBase.serviceTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                        <td>支付方式：</td><td><p><g:select name="paymentType" value="${params.paymentType}" from="${TradeBase.paymentTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                         <g:if test="${params.companyType == 'branch'||params.saleType == 'sale'}">
                            <td>商户行业：</td><td><p><g:textField name="belongToBusiness" onblur="value=value.replace(/[ ]/g,'')" value="${params.belongToBusiness}" class="right_top_h2_input"/></p></td>
                            <td>商户等级：</td><td><p><g:select name="grade" from="${CmCorporationInfo.gradeMap}" value="${params.grade}" optionKey="key" optionValue="value" noSelection="${['':'--请选择--']}" class="right_top_h2_input"/></p></td>
                         </g:if>
                    </tr>

                    <tr>
                        <g:hiddenField name="rootId" value="${rootId}"></g:hiddenField>
                        <g:hiddenField name="companyType" value="${params.companyType}"/>
                        <g:hiddenField name="saleType" value="${params.saleType}"/>
                        <g:if test="${flag!=-1&&flag!=-2}">
                            <td colspan="4" class="center"><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询"/>
                            <input type="button" class="right_top_h2_button_clear" value="清空" onClick="cl()">
                            <g:if test="${params.companyType == 'branch'}">
                                <bo:hasPerm perm="${Perm.Trade_BranchQry_Dl}">
                                    <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载"/></bo:hasPerm>
                            </g:if>
                            <g:elseif test="${params.saleType == 'sale'}">
                                <bo:hasPerm perm="${Perm.Trade_SaleQry_Dl}">
                                    <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载"/></bo:hasPerm>
                            </g:elseif>
                            <g:else>
                                <bo:hasPerm perm="${Perm.Trade_Qry_Dl}">
                                    <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载"/></bo:hasPerm>
                            </g:else>
                            <td colspan="2" align="left">默认只查询、下载最近30天内的数据</td>
                        </g:if>
                    </td>
                    </tr>
                </g:form>
            </table>
        </div>
        <div class="right_list_tablebox">
            <g:if test="${flag==1}">
                <table align="center" class="right_list_table" id="test" style="background:#E8FAD1">
            </g:if>
            <g:else>
                <table align="center" class="right_list_table" id="test">
            </g:else>
            <tr>
                <th>序号</th>
                <th>${message(code: 'tradeBase.tradeNo.label')}</th>
                <th>${message(code: 'tradeBase.outTradeNo.label')}</th>
                <g:sortableColumn params="${params}" property="tradeType" title="${message(code: 'tradeBase.tradeType.label')}"/>
                <th>支付方式</th>
                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'tradeBase.dateCreated.label')}"/>
                <g:sortableColumn params="${params}" property="partner" title="${message(code: 'tradeBase.partner.label')}"/>                
                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'tradeBase.tradeDate.label')}"/>
                %{--<th>银行通道</th>--}%
                <g:sortableColumn params="${params}" property="payer" title="${message(code: 'tradeBase.payer.label')}"/>

                <g:sortableColumn params="${params}" property="payee" title="${message(code: 'tradeBase.payee.label')}"/>
                <th>${message(code: 'tradeBase.orderAmount.label')}</th>
                <th>${message(code: 'tradeBase.amount.label')}</th>
                <g:sortableColumn params="${params}" property="status" title="${message(code: 'tradeBase.status.label')}"/>
                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'tradeBase.lastUpdated.label')}"/>

                <th>操作</th>
            </tr>

            <g:each in="${tradeList}" status="i" var="trade">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <g:if test="${params?.int('offset')>=0}">
                        <td>${params?.int('offset') + i + 1}</td>
                    </g:if>
                    <g:else>
                        <td>${i + 1}</td>
                    </g:else>
                    <td nowrap>${fieldValue(bean: trade, field: "tradeNo")}</td>
                    <td nowrap>${fieldValue(bean: trade, field: "outTradeNo")}</td>
                    <td nowrap>${TradeBase.tradeTypeMap[trade.tradeType]}</td>
                    <td nowrap>${TradeBase.paymentTypeMap[trade?.paymentType]}</td>

                    <td nowrap><g:formatDate date="${trade.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td nowrap>
                        <g:if test="${trade.partner}">
                            <g:if test="${trade.partner.type=='C'}">
                                <g:link controller="cmCorporationInfo" action="show" id="${trade.partner.id},${trade.tradeType}">${trade.partner.name}</g:link>
                            </g:if>
                            <g:elseif test="${trade.partner.type=='P'}">
                                <g:link controller="cmPersonalInfo" action="show" id="${trade.partner.id},${trade.tradeType}">${trade.partner.name}</g:link>
                            </g:elseif>
                        </g:if>
                    </td>
                    <td nowrap>${String.valueOf(trade.tradeDate).substring(0,4) + '-' + String.valueOf(trade.tradeDate).substring(4,6) + '-' + String.valueOf(trade.tradeDate).substring(6,8)}</td>
                    %{--<g:if test="${TradeBase.findByRootIdAndTradeType(trade.rootId,'charge')?.outTradeNo!=null && GwTransaction.findByBankTransNo(TradeBase.findByRootIdAndTradeType(trade.rootId, 'charge')?.outTradeNo)?.acquirerMerchant!=null}">--}%
                        %{--<td nowrap>${BoAcquirerAccount.get(BoMerchant.findByAcquireMerchant(GwTransaction.findByBankTransNo(TradeBase.findByRootIdAndTradeType(trade.rootId, 'charge')?.outTradeNo)?.acquirerMerchant)?.acquirerAccount?.id)?.aliasName}</td>--}%
                    %{--</g:if>--}%
                    %{--<g:else>--}%
                        %{--<td></td>--}%
                    %{--</g:else>--}%
                    <td nowrap>
                        <g:if test="${trade.payer && trade.payer.type=='C'}">
                            <g:link controller="cmCorporationInfo" action="show" id="${trade.payer.id},${trade.tradeType}">${trade.payerName}</g:link>
                        </g:if>
                        <g:elseif test="${trade.payer && trade.payer.type=='P'}">
                            <g:link controller="cmPersonalInfo" action="show" id="${trade.payer.id},${trade.tradeType}">${trade.payerName}</g:link>
                        </g:elseif>
                        <g:else>
                            ${trade.payerName}
                        </g:else>
                    </td>
                    %{--<g:if test="${trade.tradeType=='charge'}">--}%
                        %{--<td nowrap>${TradeCharge.get(trade.id)?.paymentIp}</td>--}%
                    %{--</g:if>--}%
                    %{--<g:elseif test="${trade.tradeType=='payment'}">--}%
                        %{--<td nowrap>${TradePayment.get(trade.id)?.paymentIp}</td>--}%
                    %{--</g:elseif>--}%
                    %{--<g:elseif test="${trade.tradeType=='transfer'}">--}%
                        %{--<td nowrap>${TradeTransfer.get(trade.id)?.submitIp}</td>--}%
                    %{--</g:elseif>--}%
                    %{--<g:else>--}%
                        %{--<td></td>--}%
                    %{--</g:else>--}%
                    <td nowrap>
                        <g:if test="${trade.payee && trade.payee.type=='C'}">
                            <g:link controller="cmCorporationInfo" action="show" id="${trade.payee.id},${trade.tradeType}">${trade.payeeName}</g:link>
                        </g:if>
                        <g:elseif test="${trade.payee && trade.payee.type=='P'}">
                            <g:link controller="cmPersonalInfo" action="show" id="${trade.payee.id},${trade.tradeType}">${trade.payeeName}</g:link>
                        </g:elseif>
                        <g:else>
                            ${trade.payeeName}
                        </g:else>
                    </td>
                    <td nowrap>
                        <g:set var="amt" value="${trade?.amount-(trade?.feeAmount==null?0:trade?.feeAmount)}"/>
                        <g:formatNumber number="${amt/100}" type="currency" currencyCode="CNY"/>
                    </td>
                    <td nowrap>
                        <g:set var="amt" value="${trade.amount ? trade.amount : 0}"/>
                        <g:formatNumber number="${amt/100}" type="currency" currencyCode="CNY"/>
                    </td>
                    <td nowrap><g:if test="${TradeBase.findByTradeNo(trade?.tradeNo) != null && TradeBase.findByTradeNo(trade?.tradeNo) != '' && TradeBase.findByTradeNo(trade?.tradeNo).status =='closed'}">完成</g:if>
                        <g:else>${TradeBase.statusMap[trade.status]}</g:else></td>

                    <td nowrap><g:formatDate date="${trade.lastUpdated}" format="yyyy-MM-dd HH:mm:ss"/></td>

                    <td nowrap>

                        <g:if test="${params.companyType == 'branch'}">
                            <bo:hasPerm perm="${Perm.Trade_BranchQry_View}"><g:link action="show" id="${trade.id}">详情</g:link></bo:hasPerm>
                            <g:if test="${flag==0}">
                                <bo:hasPerm perm="${Perm.Trade_BranchQry_Relate}">|<g:link action="list" params="[rootId:trade.rootId,companyType:params.companyType]">相关交易</g:link></bo:hasPerm>
                            </g:if>
                        </g:if>
                        <g:elseif test="${params.saleType == 'sale'}">
                            <bo:hasPerm perm="${Perm.Trade_SaleQry_View}"><g:link action="show" id="${trade.id}">详情</g:link></bo:hasPerm>
                            <g:if test="${flag==0}">
                                <bo:hasPerm perm="${Perm.Trade_SaleQry_Relate}">|<g:link action="list" params="[rootId:trade.rootId,saleType:params.saleType]">相关交易</g:link></bo:hasPerm>
                            </g:if>
                        </g:elseif>
                        <g:else>
                            <bo:hasPerm perm="${Perm.Trade_Qry_View}"><g:link action="show" id="${trade.id}">详情</g:link></bo:hasPerm>
                            <g:if test="${flag==0}">
                                <bo:hasPerm perm="${Perm.Trade_Qry_Relate}">|<g:link action="list" params="[rootId:trade.rootId]">相关交易</g:link></bo:hasPerm>
                            </g:if>
                        </g:else>
                    </td>
                </tr>
            </g:each>
            <g:if test="${flag==1}">
                <tr>
                    <td colspan="12" align="center">
                        <g:form>
                            <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                        </g:form>
                    </td>
                </tr>
            </g:if>
        </table>
        </div>
        合计：交易金额总计：<g:formatNumber number="${totalAmount ? totalAmount / 100 : 0}" format="#.##"/>元
        <div class="paginateButtons">
            <div style=" float:left;">共${tradeTotal}条记录</div>
            <g:paginat total="${tradeTotal}" params="${params}"/>
        </div>

    <div class="paginateButtons">
        <span class="button"><input type="button" class="rigt_button" onclick="history.go(-1)" value="返回"/></span>
    </div>
    </div>
</div>
</div>
</body>
</html>
