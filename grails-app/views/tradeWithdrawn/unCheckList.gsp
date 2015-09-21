<%@ page import="boss.AppNote; boss.BoBankDic; boss.Perm; ismp.TradeWithdrawn" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeWithdrawn.label', default: 'TradeWithdrawn')}"/>
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
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">待处理提现请求</h1>
        <div class="table_serch">
            <table>
                <g:form action="unCheckList">
                    <tr>
                        <td><g:message code="tradeWithdrawn.tradeNo.label"/>：</td><td><p><g:textField name="tradeNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.tradeNo}" class="right_top_h2_input" style="width:150px"/></td></p>
                    <td><g:message code="tradeWithdrawn.payerName.label"/>：</td><td><p><g:textField name="payerName" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerName}" class="right_top_h2_input" style="width:120px"/></p></td>
                    <td><g:message code="tradeWithdrawn.payerAccountNo.label"/>：</td><td><p><g:textField name="payerAccountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerAccountNo}" class="right_top_h2_input" style="width:120px"/></p></td>
                    <td><g:message code="tradeWithdrawn.isCorporate.label"/>：</td><td><p><g:select name="isCorporate" from="${TradeWithdrawn.isCorporateMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" value="${params.isCorporate}"/></p>
                    </tr>
                    <tr>
                        <td><g:message code="tradeWithdrawn.payerBank.label"/>：</td><td><p><g:select from="${BoBankDic.findAll()}" value="${params.bankCode}" name="bankCode" id="bankCode" optionKey="code" optionValue="name" noSelection="${['':'-全部-']}" class="right_top_h2_input"></g:select></p>
                        <td><g:message code="tradeWithdrawn.dateCreated.label"/> ：</td>
                        <td colspan="5"><p><g:textField name="startTime" value="${params.startTime}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" onchange="checkDate()" class="Wdate"/>
                            -- <g:textField name="endTime" value="${params.endTime}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true })" onchange="checkDate()" class="Wdate"/></p></td>

                    </tr>
                    <tr>
                        <td><g:message code="tradeWithdrawn.amount.label"/>：</td><td colspan="2"><p><g:textField name="startAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" align="left" value="${params.startAmount}" class="right_top_h2_input" style="width:80px"/>
                        --<g:textField name="endAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endAmount}" class="right_top_h2_input" style="width:80px"/></p></td>
                        <td colspan="5">
                            <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkDate()"/>
                            <bo:hasPerm perm="${Perm.WithDraw_Wait_Dl}">
                                <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()"></g:actionSubmit>
                            </bo:hasPerm>
                            <input type="button" class="right_top_h2_button_clear" value="清空" onClick="cl()">
                            <input type="button" class="right_top_h2_button_check" value="全选" id="all" onClick="ckAll()"/>
                            <bo:hasPerm perm="${Perm.WithDraw_Wait_ProcBatPas}">
                                <input type="button" class="right_top_h2_button_check" value="批量通过" onClick="checkPass()"/>
                            </bo:hasPerm>
                            <bo:hasPerm perm="${Perm.WithDraw_Wait_ProcSigPas}">
                                <input type="button" class="right_top_h2_button_check" value="单笔通过" onClick="singlePass()"/>
                            </bo:hasPerm>
                        </td>
                        <td><g:hiddenField name="flag" value="0"></g:hiddenField></td>

                    </tr>
                </g:form>
            </table>
        </div>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <th>请选择</th>
                <g:sortableColumn params="${params}" property="tradeNo" title="${message(code: 'tradeWithdrawn.tradeNo.label')}"/>
                <g:sortableColumn params="${params}" property="payerName" title="${message(code: 'tradeWithdrawn.payerName.label')}"/>
                <g:sortableColumn params="${params}" property="payerAccountNo" title="${message(code: 'tradeWithdrawn.payerAccountNo.label')}"/>
                <g:sortableColumn params="${params}" property="amount" title="${message(code: 'tradeWithdrawn.amount.label')}"/>
                %{--<g:sortableColumn params="${params}" property="customerBankNo" title="${message(code: 'tradeWithdrawn.customerBankNo.label')}"/>--}%
                <th>提现银行</th>
                <g:sortableColumn params="${params}" property="customerBankAccountNo" title="${message(code: 'tradeWithdrawn.customerBankAccountNo.label')}"/>
                <g:sortableColumn params="${params}" property="customerBankAccountName" title="${message(code: 'tradeWithdrawn.customerBankAccountName.label')}"/>
                <g:sortableColumn params="${params}" property="handleStatus" title="${message(code: 'tradeWithdrawn.handleStatus.label')}"/>
                <g:sortableColumn params="${params}" property="isCorporate" title="${message(code: 'tradeWithdrawn.isCorporate.label')}"/>
                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'tradeWithdrawn.dateCreated.label')}"/>
                <th>拒绝原因</th>
            </tr>

            <g:each in="${tradeWithdrawnInstanceList}" status="i" var="tradeWithdrawnInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td><g:checkBox name="chbox" id="chbox"></g:checkBox><g:hiddenField name="id" value="${tradeWithdrawnInstance.id}"></g:hiddenField>
                    <g:hiddenField name="bank" id="bank" value="${tradeWithdrawnInstance.customerBankCode}"></g:hiddenField>
                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.WithDraw_Wait_ViewLs){true}}"><g:link action="checkShow" id="${tradeWithdrawnInstance.id}">${fieldValue(bean: tradeWithdrawnInstance, field: "tradeNo")}</g:link></g:if>
                        <g:else>${fieldValue(bean: tradeWithdrawnInstance, field: "tradeNo")}</g:else>
                    </td>
                    <td>${fieldValue(bean: tradeWithdrawnInstance, field: "payerName")}</td>
                    <td>${fieldValue(bean: tradeWithdrawnInstance, field: "payerAccountNo")}</td>
                    <td><g:formatNumber number="${tradeWithdrawnInstance?.amount/100}" type="currency" currencyCode="CNY"/></td>
                    %{--<td>${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankNo")}</td>--}%
                    <td>${boss.BoBankDic.findByCode(tradeWithdrawnInstance?.customerBankCode)?.name}</td>
                    <td>${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankAccountNo")}</td>
                    <td>${fieldValue(bean: tradeWithdrawnInstance, field: "customerBankAccountName")}</td>
                    <td>${TradeWithdrawn.handleStatusMap[tradeWithdrawnInstance?.handleStatus]}</td>
                    <td><g:formatBoolean boolean="${tradeWithdrawnInstance?.isCorporate}"/></td>
                    <td><g:formatDate date="${tradeWithdrawnInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${AppNote.findByAppIdAndAppName(tradeWithdrawnInstance.id, 'tradeWithdrawn_second')?.appNote}</td>
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
<script type="text/javascript">
    //    $(function() {
    //        $("#startTime").attr("readonly","true").datetimepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    //        $("#endTime").attr("readonly","true").datetimepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
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
        var startTimeCreate = document.getElementById('startTime').value.replace(/-/g, "//");
        var endTimeCreate = document.getElementById('endTime').value.replace(/-/g, "//");
        if (endTimeCreate.length != 0) {
            if (Number(startTimeCreate > endTimeCreate)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endTime').focus();
                return false;
            }
        }

        // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectF = new Date(startTimeCreate);
        var dSelectT = new Date(endTimeCreate);
        var theFromM = dSelectF.getMonth();
        var theFromD = dSelectF.getDate();
        // 设置起始日期加一个月
        theFromM += 1;
        dSelectF.setMonth(theFromM, theFromD);
        if (dSelectF < dSelectT) {
            alert('每次只能查询1个月范围内的数据!');
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
        document.getElementById("isCorporate").value = "";
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
        var bank = "";

        for (i = 0; i < len; i++) {
//            var ba = "";
            if (document.getElementsByName("chbox")[i].checked) {
//                ba = document.getElementsByName("bank")[i].value
//                if (bank != ba && bank != "" && bank != null) {
//                    alert("您选择的数据不是同一提现银行,请重新选择！");
//                    return false;
//                }
//                bank = ba;
                id = id + document.getElementsByName("id")[i].value + ",";
                flag = 1
            }
        }
        if (flag == 0) {
            alert("请选择至少一条待处理的提现请求！");
        }
        if (flag == 1) {
            if (confirm("您确认要批量处理提现请求？")) {
                var url = 'editRea.gsp?id=' + id + '&flag=0';
                win1 = new Ext.Window({
                    id:'win1',
                    title:"请选择提现银行",
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
    function singlePass() {

        var len = document.getElementsByName("chbox").length;
        var flag = 0;
        var id = "";
//        var bank = "";
        for (i = 0; i < len; i++) {
            if (document.getElementsByName("chbox")[i].checked) {
//                var ba = document.getElementsByName("bank")[i].value
//                if (bank != ba && bank != "" && bank != null) {
//                    alert("您选择的数据不是同一提现银行,请重新选择！");
//                    return false;
//                }
//                bank = ba;
                id = id + document.getElementsByName("id")[i].value + ",";
                flag = 1
            }
        }
        if (flag == 0) {
            alert("请选择至少一条待处理的提现请求！");
        }
        if (flag == 1) {
            if (confirm("您确认要单笔处理提现请求？")) {
                var url = 'editRea.gsp?id=' + id + '&flag=1';
                win1 = new Ext.Window({
                    id:'win1',
                    title:"请选择提现银行",
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
</body>
</html>
