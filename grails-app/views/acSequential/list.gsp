<%@ page import="boss.Perm; account.AcTransaction; account.AcAccount; account.AcSequential" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'acSequential.label', default: 'AcSequential')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <g:javascript>
        function empty_input(){
            document.getElementById('inputAccountNo').value = '';
            document.getElementById('inputAccountName').value = '';
            document.getElementById('selectTransferType').value = '';
            document.getElementById('inputTradeNo').value = '';

            document.getElementById('inputOutTradeNo').value = '';
            document.getElementById('selectSrvType').value = '';
            document.getElementById('startTime').value = '';
            document.getElementById('endTime').value = '';

            document.getElementById('startTime').focus();
        }
    </g:javascript>
</head>
<body>

<script type="text/javascript">
    $(function() {
        $("#startTime,#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });
    function checkDate() {
        var startDate = document.getElementById("startTime").value;
        var endDate = document.getElementById("endTime").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endTime").focus();
            return false;
        }
    }
        /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startDateCreated = document.getElementById('startTime').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endTime').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endTime').focus();
                return false;
            }
        }

    }
     /*---guonan update 2011-12-30----*/
    function doSearch() {
//          if(checkDate()){
//
//          }
          document.getElementById("downloadflag").value="0";
	      document.forms[0].submit();
    }
    function downLoad() {
        document.getElementById("downloadflag").value="1";
        document.forms[0].submit();
    }
</script>

<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <div class="table_serch">
            <table>
            <g:form>
                <g:hiddenField name="downloadflag" id="downloadflag"/>
                <tr>
                    <td>交易时间：</td>
                    <td colspan="3" class="left">
                        <g:textField name="startTime" readonly="true" value="${params.startTime}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" size="10" class="right_top_h2_input" style="width:80px"/>
                        ---
                        <g:textField name="endTime" readonly="true" value="${params.endTime}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" size="10" class="right_top_h2_input" style="width:80px"/>
                    </td>
                    <td>账户号：</td>
                    <td><g:textField id="inputAccountNo" name="accountNo" value="${params.accountNo}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input" style="width:120px"/></td>
                    <td>账户名称：</td>
                    <td class="left"><g:textField id="inputAccountName" name="accountName" value="${params.accountName}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input" style="width:120px"/></td>
                </tr>
                <tr>
                    <td>交易流水号：</td>
                    <td class="left"><g:textField id="inputTradeNo" name="tradeNo" value="${params.tradeNo}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input" style="width:120px"/></td>
                    <td>外部订单号：</td>
                    <td class="left"><g:textField id="inputOutTradeNo" name="outTradeNo" value="${params.outTradeNo}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input" style="width:120px"/></td>
                    <td>交易类型：</td>
                    <td><p><g:select id="selectTransferType" name="transferType" from="${AcTransaction.transTypeMap}" optionKey="key" optionValue="value" value="${params.transferType}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/></p></td>
                    <td>服务类型：</td>
                    <td><p><g:select id="selectSrvType" name="srvType" from="${AcTransaction.srvTypeMap}" optionKey="key" optionValue="value" value="${params.srvType}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/></p></td>

                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <input type="button" value="查询" class="right_top_h2_button_serch" onClick="doSearch()">
                    </td>
                    <td>&nbsp;</td>
                    <td>
                        <input type="button" class="right_top_h2_button_serch" onclick="javascript:empty_input();" value="清空" />
                    </td>
                    <td>&nbsp;</td>
                    <td>
                        <bo:hasPerm perm="${Perm.Account_Bill_Dl}">
                            <input type="button" value="下载" class="right_top_h2_button_download" onClick="downLoad()">
                        </bo:hasPerm>
                    </td>
                    <td colspan="2" class="left">默认只下载最近三天的数据、最多可下载六万条记录</td>
                </tr>
            </g:form>
            </table>
        </div>
        <div class="table_serch">
            <table>
                <tr>
                <td>总借记笔数：</td>
                <td>${debitTotal}</td>
                <td>总借记金额：</td>
                <td><g:formatNumber number="${debitAmount==null?0:debitAmount/100}" type="currency" currencyCode="CNY"/></td>
                <td>总贷记笔数：</td>
                <td>${creditTotal}</td>
                <td>总贷记金额：</td>
                <td><g:formatNumber number="${creditAmount==null?0:creditAmount/100}" type="currency" currencyCode="CNY"/></td>
                <td>本期余额：</td>
                <td><g:formatNumber number="${balanceAmount==null?0:balanceAmount/100}" type="currency" currencyCode="CNY"/></td>

                </tr>
            </table>
        </div>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <th>序号</th>
                <th>凭证码</th>
                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'acSequential.dateCreated.label', default: 'Date Created')}"/>
                <th>交易类型</th>
                <th>服务类型</th>
                <th>交易流水号</th>
                <th>外部订单号</th>
                <%--g:sortableColumn property="transaction.transactionCode" title="凭证码"/>
            <g:sortableColumn params="${params}"  property="transaction.tradeNo" title="交易类型"/>
            <g:sortableColumn params="${params}"  property="transaction.transferType" title="外部交易流水号"/>
            <g:sortableColumn params="${params}"  property="transaction.outTradeNo" title="外部订单号"/--%>
                <g:sortableColumn params="${params}" property="accountNo" title="${message(code: 'acSequential.accountNo.label', default: 'Account No')}"/>
                <th>账户名称</th>
                <g:sortableColumn params="${params}" property="debitAmount" title="${message(code: 'acSequential.debitAmount.label', default: 'debitAmount')}"/>
                <g:sortableColumn params="${params}" property="creditAmount" title="${message(code: 'acSequential.creditAmount.label', default: 'creditAmount')}"/>
                <g:sortableColumn params="${params}" property="balance" title="${message(code: 'acSequential.balance.label', default: 'Balance')}"/>
                <th>详细</th>
            </tr>

            <g:each in="${acSequentialInstanceList}" status="i" var="acSequentialInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>${i+1}</td>
                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.Account_Bill_View){true}}"><g:link action="show" id="${acSequentialInstance.id}">${acSequentialInstance?.transaction?.transactionCode}</g:link></g:if>
                        <g:else>${acSequentialInstance?.transaction?.transactionCode}</g:else>
                    </td>
                    <td><g:formatDate date="${acSequentialInstance.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${AcTransaction.transTypeMap[acSequentialInstance?.transaction?.transferType]}</td>
                    <td>${AcTransaction.srvTypeMap[acSequentialInstance?.transaction?.srvType]}</td>
                    <td>${acSequentialInstance?.transaction?.tradeNo}</td>
                    <td>${acSequentialInstance?.transaction?.outTradeNo}</td>
                    <td>${fieldValue(bean: acSequentialInstance, field: "accountNo")}</td>
                    <td>${acSequentialInstance?.account?.accountName}</td>
                    <td><g:formatNumber number="${acSequentialInstance.debitAmount/100}" type="currency" currencyCode="CNY"/></td>
                    <td><g:formatNumber number="${acSequentialInstance.creditAmount/100}" type="currency" currencyCode="CNY"/></td>
                    <td><g:formatNumber number="${acSequentialInstance.balance/100}" type="currency" currencyCode="CNY"/></td>
                    <td><g:link action="view" id="${acSequentialInstance.id}">查看</g:link>|<g:link action='receipt' id='${acSequentialInstance.id}'>回单</g:link></td>

                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${acSequentialInstanceTotal}条记录</span>
            <g:paginat total="${acSequentialInstanceTotal}" params="${params}"/>
        </div>

        <div class="paginateButtons">
            <span class="button"><input type="button" class="rigt_button" onclick="history.go(-1)" value="返回"/></span>
        </div>
    </div>
</div>
</body>
</html>
