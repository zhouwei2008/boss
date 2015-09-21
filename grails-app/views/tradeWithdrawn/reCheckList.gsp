<%@ page import="boss.AppNote; boss.BoMerchant; boss.BoBankDic; boss.BoAcquirerAccount; boss.Perm; gateway.GwTransaction; ismp.TradeCharge; ismp.TradePayment; ismp.TradeBase; ismp.TradeWithdrawn" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeWithdrawn.reCheckList.label', default: 'TradeWithdrawn')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <link rel="stylesheet" type="text/css" href="../ext/css/ext-all.css"/>
    <link rel="stylesheet" type="text/css" href="../ext/css/style.css"/>
    <script type="text/javascript" src="../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../ext/js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ext/js/common.js"></script>
    <g:javascript library="My97DatePicker/WdatePicker"/>
</head>
<body>
<script type="text/javascript">
//    $(function() {
//        $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
//        $("#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
//    });
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
        var startDateCreated = document.getElementById('startTime').value.replace(/-/g, "//");
        var endDateCreated = document.getElementById('endTime').value.replace(/-/g, "//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间！');
                document.getElementById('endTime').focus();
                return false;
            }
        }
        // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectF = new Date(startDateCreated);
        var dSelectT = new Date(endDateCreated);
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

        document.getElementById("bankCode").value = "";
        document.getElementById("startTime").focus();
    }
    function ckAll() {
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
        var flag = 0;
        var id = "";
        var status = "";
        for (i = 0; i < len; i++) {
            if (document.getElementsByName("chbox")[i].checked) {
                if (document.getElementsByName("chbox")[i].checked) {
                    var st = document.getElementsByName("status")[i].value
                    if (status != st && status != "" && status != null) {
                        alert("您选择的数据不是同一退款状态,请重新选择！");
                        return false;
                    }
                    status = st;
                    id = id + document.getElementsByName("id")[i].value + ",";
                    flag = 1
                }
            }
        }
        if (flag == 0) {
            alert("请选择至少一条退款记录！");
        }
        if (flag == 1) {
            if (confirm("您确认要审批通过？")) {
                if (status == 'success') {
                    window.location.href = '${createLink(controller:'tradeWithdrawn', action:'reCheckSuccessPass', params:['statusFlag':'1'])}&id=' + id;
                } else if (status == 'fail') {
                    window.location.href = '${createLink(controller:'tradeWithdrawn', action:'reCheckFailPass', params:['statusFlag':'2'])}&id=' + id;
                }
            }
        }
    }
    function checkRefused() {
        var len = document.getElementsByName("chbox").length;
        var flag = 0;
        var id = "";
        var status = "";
        for (i = 0; i < len; i++) {
            if (document.getElementsByName("chbox")[i].checked) {
                if (document.getElementsByName("chbox")[i].checked) {
                    var st = document.getElementsByName("status")[i].value
                    if (status != st && status != "" && status != null) {
                        alert("您选择的数据不是同一退款状态,请重新选择！");
                        return false;
                    }
                    status = st;
                    id = id + document.getElementsByName("id")[i].value + ",";
                    flag = 2
                }
            }
        }
        if (flag == 0) {
            alert("请选择至少一条退款记录！");
        } else if (flag == 2) {
            if (confirm("您确认要拒绝该退款复核！")) {
                var url = 'reasonInp.gsp?id=' + id + '&flag=' + flag;
                win1 = new Ext.Window({
                    id:'win1',
                    title:"请输入拒绝原因",
                    width:600,
                    modal:true,
                    height:300,
                    html: '<iframe src=' + url + ' height="100%" width="100%" name="userlist" scrolling="auto" frameborder="0" onLoad="Ext.MessageBox.hide();">',
                    maximizable:true
                });
                win1.show();
            }
        }
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

                        <td>交易流水号：</td><td><g:textField name="tradeNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.tradeNo}" class="right_top_h2_input"/></td>
                        <td>批次号：</td><td><g:textField name="withdrawnBatchNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.withdrawnBatchNo}" class="right_top_h2_input"/></td>
                        <td>退款银行：</td><td><p><g:select from="${BoBankDic.findAll()}" value="${params.bankCode}" name="bankCode" id="bankCode" optionKey="code" optionValue="name" noSelection="${['':'-全部-']}" class="right_top_h2_input"></g:select></p></td>
                        <td><g:message code="tradeWithdrawn.isCorporate.label"/>：</td><td><p><g:select name="isCorporate" from="${TradeWithdrawn.isCorporateMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" value="${params.isCorporate}"/></p></td>
                    </tr>
                    <tr>
                        <td>退款客户名称：</td><td><p><g:textField name="payerName" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerName}" class="right_top_h2_input"/></p></td>
                        <td>退款人账户：</td><td><p><g:textField name="payerAccountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerAccountNo}" class="right_top_h2_input"/></p></td>
                        <td>退款金额：</td><td><p><g:textField name="startAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${params.startAmount}" class="right_top_h2_input"/>--<g:textField name="endAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endAmount}" style="width:60px;" class="right_top_h2_input"/></p></td>
                        <TD>处理状态：</TD><td><p><g:select name="handleStatus" from="${TradeWithdrawn.handleNotAllStatusMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" value="${params.handleStatus}"/></p></td>
                        <g:hiddenField name="flag" value="4"></g:hiddenField>
                    </tr>
                    <tr>
                        <td>申请时间：</td><td colspan="3"><p><g:textField name="startTime" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" onchange="checkDate()" value="${params.startTime}" class="Wdate"/>
                        --<g:textField name="endTime" onchange="checkDate()" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" value="${params.endTime}" class="Wdate"/></p></td>
                        <td>提现处理时间：</td><td colspan="3"><p><g:textField name="startWithHandleDate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" onchange="checkDate()" value="${params.startWithHandleDate}" class="Wdate"/>
                        --<g:textField name="endWithHandleDate" onchange="checkDate()" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" value="${params.endWithHandleDate}" class="Wdate"/></p></td>
                    </tr>
                    <TR>
                        <td colspan="8">
                            <g:actionSubmit class="right_top_h2_button_serch" action="reCheckList" value="查询"/>
                            <bo:hasPerm perm="${Perm.WithDraw_RfdBthRef_Dl}"><g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载"/></bo:hasPerm>
                            <input type="button" class="right_top_h2_button_clear" value="清空" onClick="cl()">
                            <input type="button" class="right_top_h2_button_check" value="全选" id="all" onClick="ckAll()"/>
                            <bo:hasPerm perm="${Perm.WithDraw_RfdBthRef_ProcPas}">
                                <input type="button" class="right_top_h2_button_check" value="复核通过" onClick="checkPass()"/>
                            </bo:hasPerm>
                            <bo:hasPerm perm="${Perm.WithDraw_RfdBthRef_ProcRef}">
                                <input type="button" class="right_top_h2_button_check" value="复核拒绝" onClick="checkRefused()"/>
                            </bo:hasPerm>
                        </td>
                    </tr>
                </table>
            </div>
        </g:form>
        <table align="center" class="right_list_table" id="test">

            <tr>
                <th>请选择</th>
                <g:sortableColumn params="${params}" property="withdrawnBatchNo" title="${message(code: 'tradeWithdrawn.withdrawnBatchNo.label')}"/>
                <g:sortableColumn params="${params}" property="tradeNo" title="${message(code: 'tradeWithdrawn.tradeNo.label')}"/>
                <g:sortableColumn params="${params}" property="payerName" title="${message(code: 'tradeWithdrawn.payerName.label')}"/>
                <g:sortableColumn params="${params}" property="payerAccountNo" title="${message(code: 'tradeWithdrawn.payerAccountNo.label')}"/>
                <th>提现银行</th>
                <g:sortableColumn params="${params}" property="customerBankAccountNo" title="${message(code: 'tradeWithdrawn.customerBankAccountNo.label')}"/>
                <g:sortableColumn params="${params}" property="customerBankAccountName" title="${message(code: 'tradeWithdrawn.customerBankAccountName.label')}"/>
                <g:sortableColumn params="${params}" property="amount" title="${message(code: 'tradeWithdrawn.amount.label')}"/>
                <g:sortableColumn params="${params}" property="handleStatus" title="${message(code: 'tradeWithdrawn.handleStatus.label')}"/>

                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'tradeWithdrawn.dateCreated.label')}"/>
                <g:sortableColumn params="${params}" property="withHandleDate" title="${message(code: 'tradeWithdrawn.withdrawnHandleDate.label')}"/>
                <g:sortableColumn params="${params}" property="isCorporate" title="${message(code: 'tradeWithdrawn.isCorporate.label')}"/>
                <th>拒绝原因</th>
            </tr>

            <g:each in="${tradeWithdrawnInstanceList}" status="i" var="tradeWithdrawnInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td><g:checkBox name="chbox" id="chbox"></g:checkBox>
                    <g:hiddenField name="id" value="${tradeWithdrawnInstance.id}"></g:hiddenField>
                    <g:hiddenField name="status" id="status" value="${tradeWithdrawnInstance.handleStatus}"></g:hiddenField>
                    </td>
                    <td><g:if test="${bo.hasPerm(perm:Perm.WithDraw_RfdBthRef_ViewBat){true}}"><g:link action="checkShowBatch" id="${tradeWithdrawnInstance.withdrawnBatchNo}" params="['sign':'2']">${fieldValue(bean: tradeWithdrawnInstance, field: "withdrawnBatchNo")}</g:link></g:if><g:else>${fieldValue(bean: tradeWithdrawnInstance, field: "withdrawnBatchNo")}</g:else></td>
                    <td><g:if test="${bo.hasPerm(perm:Perm.WithDraw_RfdBthRef_ViewLs){true}}"><g:link action="refuseShow" id="${tradeWithdrawnInstance.id}" params="['sign':'4']">${fieldValue(bean: tradeWithdrawnInstance, field: "tradeNo")}</g:link></g:if><g:else>${fieldValue(bean: tradeWithdrawnInstance, field: "tradeNo")}</g:else></td>
                    <td>${fieldValue(bean: tradeWithdrawnInstance, field: "payerName")}</td>
                    <td>${fieldValue(bean: tradeWithdrawnInstance, field: "payerAccountNo")}</td>

                    <td>${BoBankDic.get(BoAcquirerAccount.get(tradeWithdrawnInstance?.acquirerAccountId)?.bank?.id)?.name}</td>
                    <td>${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankAccountNo")}</td>
                    <td>${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankAccountName")}</td>
                    <td><g:formatNumber number="${tradeWithdrawnInstance?.amount/100}" type="currency" currencyCode="CNY"/></td>
                    <td>${TradeWithdrawn.handleStatusMap[tradeWithdrawnInstance?.handleStatus]}</td>

                    <td><g:formatDate date="${tradeWithdrawnInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td><g:formatDate date="${tradeWithdrawnInstance?.withHandleDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td><g:formatBoolean boolean="${tradeWithdrawnInstance?.isCorporate}"/></td>
                    <td>${AppNote.findByAppIdAndAppName(tradeWithdrawnInstance.id, 'tradeWithdrawn_third')?.appNote}</td>
                </tr>
            </g:each>
        </table>
        合计：提现金额总计：${totalAmount ? totalAmount / 100 : 0}元
        <div class="paginateButtons">
            <span style=" float:left;">共${tradeWithdrawnInstanceTotal}条记录</span>
            <g:paginat total="${tradeWithdrawnInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
