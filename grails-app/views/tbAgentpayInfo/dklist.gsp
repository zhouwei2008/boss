<%@ page import="boss.Perm; dsf.TbAgentpayDetailsInfo" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: '待处理打款信息')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <style type="text/css">
         span {display:-moz-inline-box; display:inline-block;}
    </style>
    <script type="text/javascript">
        parent.hideWait();
        function checkAllBox() {
            var len = document.getElementsByName("box").length;
            for (i = 0; i < len; i++) {
                if (document.getElementById("allBox").checked) {
                    document.getElementsByName("box")[i].checked = true;
                }
                else {
                    document.getElementsByName("box")[i].checked = false;
                }
            }
        }
        function selectCheck(actionName) {
            var len = document.getElementsByName("box").length;
            var ids = "";
            var flag = 0;
            for (i = 0; i < len; i++) {
                if (document.getElementsByName("box")[i].checked) {
                    ids = ids + document.getElementsByName("box")[i].value + ",";
                    flag = 1;
                }
            }

            document.getElementById("ids").value = ids;

            if (flag == 0) {
                alert("请选择明细！");
                return false;
            }
            else {
                var dklistForm = document.forms['dklistForm'];
                dklistForm.action = actionName;
                parent.showWait();
                dklistForm.submit();
            }

        }
        function cl() {

            var form = document.forms[0];
            for (var i = 0; i < form.elements.length; i++) {
                if (form.elements[i].type == "text" || form.elements[i].type == "text")
                    form.elements[i].value = "";
            }

            document.getElementById("tradeType").value = "";
            document.getElementById("bankName").value = "";
            document.getElementById("tradeAccounttype").value = "";
        }
        function allChecked() {
            document.getElementById("allCheck").value = "true";

            var len = document.getElementsByName("box").length;
            for (i = 0; i < len; i++) {
                document.getElementsByName("box")[i].checked = true;
            }
        }
    </script>
</head>
<body>
<script type="text/javascript">
    /**
     * 格式化金额
     */
    function fmoney(s, n) {

        var svalue;
        n = n > 0 && n <= 20 ? n : 2;
        svalue = parseFloat((s.value + "").replace(/[^\d\.-]/g, "")).toFixed(n) + "";
        var l = svalue.split(".")[0].split("").reverse(),
                r = svalue.split(".")[1];
        t = "";
        for (i = 0; i < l.length; i++) {
            t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? "," : "");
        }
        s.value = t.split("").reverse().join("") + "." + r;
        return s.value;
    }
    $(function() {
        $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });

    /*---guonan update 2011-12-30----*/
    function checkDate() {
        var startDateCreated = document.getElementById('startTime').value.replace(/-/g, "//");
        var endDateCreated = document.getElementById('endTime').value.replace(/-/g, "//");

        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }

        var len = document.getElementsByName("checkBankName").length;
        var checkBankNames = "";
        var flag = 0;
        for (i = 0; i < len; i++) {
            if (document.getElementsByName("checkBankName")[i].checked) {
                checkBankNames = checkBankNames + document.getElementsByName("checkBankName")[i].value + ",";
                flag = 1;
            }
        }
        document.getElementById("checkBankNames").value = checkBankNames;
    }
     /**
        *   取消明细选中的状态，取消全选效果
        * @param checkBoxObj
         */
        function disCheckAll(checkBoxObj){

            if(!checkBoxObj.checked){
              document.getElementById("allCheck").value = "false";
              document.getElementById("allBox").checked = false;
            }
        }


</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
    <div class="table_serch">

    <table align="center" class="right_list_table" >
        <g:form action="dklist" name = "dklistForm">

          <span >
            商户审核时间：<g:textField name="startTime" value="${params.startTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()"/>
            --<g:textField name="endTime" value="${params.endTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()"/>
           </span>
          <span >
            商户编号：<g:textField name="batchBizid" value="${params.batchBizid}" size="20" class="right_top_h2_input" style="width:150px"/>
        %{--  业务类型：<g:select name="tradeType" from="${TbAgentpayDetailsInfo.fkYwTypeMap}" optionKey="key" optionValue="value" value="${params.tradeType}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>  --}%
             </span>
             <span >
            商户名称：<g:textField name="name" value="${params.name}" size="20" class="right_top_h2_input" style="width:150px"/>
             </span>
          <span >
            收款人：<g:textField name="tradeCardname" value="${params.tradeCardname}" size="10" class="right_top_h2_input" style="width:150px"/>
            </span>
          <span >
            收款账号：<g:textField name="tradeCardnum" value="${params.tradeCardnum}" size="10" class="right_top_h2_input" style="width:150px"/>
            </span>
          <span >
            收款银行：<g:select name="bankName" from="${bankNameList}" optionKey="${1}" optionValue="${2}" noSelection="${['':'--请选择--']}" value="${params.bankName}"/>
            <g:each in="${checkNameList}" status="i" var="bank">
                <g:if test="${checkBankArr!=null && checkBankArr.size()>0}">
                    <g:each in="${checkBankArr}" status="j" var="arr">
                        <g:if test="${arr == bank[1]}">
                            <g:checkBox name="checkBankName" value="${bank[1]}" checked="true"></g:checkBox> ${bank[2]}
                            <g:set var="mark" value="${i}"/>
                        </g:if>
                    </g:each>
                    <g:if test="${mark != i}">
                        <g:checkBox name="checkBankName" value="${bank[1]}"  checked="false"></g:checkBox> ${bank[2]}
                    </g:if>

                </g:if>
                <g:else>
                    <g:checkBox name="checkBankName" value="${bank[1]}"  checked="false"></g:checkBox> ${bank[2]}
                </g:else>
            </g:each>
           </span>
          <span >
              &nbsp&nbsp账号类型：<g:select name="tradeAccounttype" from="${TbAgentpayDetailsInfo.accountTypeMap}" optionKey="key" optionValue="value" value="${params.tradeAccounttype}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
            </span>
          <span >
            <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkDate()"/>
            <input type="button" class="right_top_h2_button_serch" value="清空" onClick="cl()">
            <input type="button" class="right_top_h2_button_tj" value="全部全选" onClick="allChecked();">
            <g:hiddenField name="allCheck" id="allCheck"/>

            <g:hiddenField name="ids" id="ids"/>
            <g:hiddenField name="checkBankNames" id="checkBankNames"/>
            </span>

            <tr>
            </table>
            </div>
            <div class="right_list_tablebox" style="height: 380px">
                <table align="center" class="right_list_table" id="test">

                    <g:sortableColumn params="${params}" property="batch_Bizid" title="${message(code: 'tbAgentpayDetailsInfo.batchBizid.label', default: 'Batch Id')}"/>
                    <g:sortableColumn params="${params}" property="batchBizidName" title="${message(code: 'tbAgentpayDetailsInfo.batchBizidName.label', default: 'Batch name')}"/>
                    <g:sortableColumn params="${params}" property="detail_id" title="${message(code: 'tbAgentpayDetailsInfo.tradeNum.label', default: 'Trade Num')}"/>
                    <g:sortableColumn params="${params}" property="tradeType" title="${message(code: '业务类型', default: '业务类型')}"/>


                    <g:sortableColumn params="${params}" property="tradeCardname" title="收款人"/>

                    <g:sortableColumn params="${params}" property="trade_Cardnum" title="收款账号"/>

                    <g:sortableColumn params="${params}" property="tradeAccountname" title="收款银行"/>

                    <g:sortableColumn params="${params}" property="tradeCommdate" title="${message(code: 'tbAgentpayDetailsInfo.tradeCommdate.label', default: 'Trade Sysdate')}"/>

                    <g:sortableColumn params="${params}" property="tradeAccounttype" title="${message(code: 'tbAgentpayDetailsInfo.tradeAccounttype.label', default: 'Trade Account Type')}"/>

                    <g:sortableColumn params="${params}" property="tradeBranchbank" title="${message(code: 'tbAgentpayDetailsInfo.tradeBranchbank.label', default: 'tradeBranchbank')}"/>

                    <g:sortableColumn params="${params}" property="tradeSubbranchbank" title="${message(code: 'tbAgentpayDetailsInfo.tradeSubbranchbank.label', default: 'tradeSubbranchbank')}"/>

                    <g:sortableColumn params="${params}" property="trade_Amount" title="${message(code: 'tbAgentpayDetailsInfo.tradeAmount.label', default: 'Trade Amount')}"/>

                    <g:sortableColumn params="${params}" property="tradeFee" title="${message(code: 'tbAgentpayDetailsInfo.tradeFee.label', default: 'Trade Fee')}"/>

                    <g:sortableColumn params="${params}" property="tradeFeetype" title="${message(code: 'tbAgentpayDetailsInfo.tradeFeetype.label', default: '收费方式')}"/>


                    <g:sortableColumn params="${params}" property="tradeFeestyle" title="退手续费"/>

                    <g:sortableColumn params="${params}" property="tradeAccamount" title="实付金额"/>
                    <g:sortableColumn params="${params}" property="tradeProvince" title="${message(code: 'tbAgentpayDetailsInfo.tradeProvince.label', default: 'Trade tradeProvince')}"/>
                    <g:sortableColumn params="${params}" property="tradeCity" title="${message(code: 'tbAgentpayDetailsInfo.tradeCity.label', default: 'Trade tradeCity')}"/>

                    <g:sortableColumn params="${params}" property="payStatus" title="${message(code: 'tbAgentpayDetailsInfo.payStatus.label', default: 'Pay Status')}"/>

                    <td nowrap="nowrap">全选<input type="checkbox" id="allBox" name="allBox" onclick="checkAllBox();"></td>
                </tr>

                    <g:each in="${tbAgentpayDetailsInfoInstanceList}" status="i" var="tbAgentpayDetailsInfoInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                            <td>${tbAgentpayDetailsInfoInstance.batch_Bizid}</td>

                            <td>${tbAgentpayDetailsInfoInstance.name}</td>

                            <td>${tbAgentpayDetailsInfoInstance.detail_id}</td>

                            <td nowrap="nowrap">
                                ${TbAgentpayDetailsInfo.fkYwTypeMap[tbAgentpayDetailsInfoInstance.trade_Type]}
                            </td>

                            <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance.trade_Cardname}</td>

                            <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance.trade_Cardnum}</td>
                            <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance.trade_Accountname}</td>

                            <td nowrap="nowrap">
                                <g:formatDate date="${tbAgentpayDetailsInfoInstance.trade_Commdate}" format="yyyy-MM-dd HH:mm:ss"/>
                            </td>

                            <td>
                                ${TbAgentpayDetailsInfo.accountTypeMap[tbAgentpayDetailsInfoInstance.trade_Accounttype]}
                            </td>
                            <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance.trade_Branchbank}</td>

                            <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance.trade_Subbranchbank}</td>

                            <td>

                                <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.trade_Amount ? tbAgentpayDetailsInfoInstance.trade_Amount : 0}"/>
                                <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                            </td>
                            <td>
                                <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.trade_Fee ? tbAgentpayDetailsInfoInstance.trade_Fee : 0}"/>
                                <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                            </td>

                            <td>${TbAgentpayDetailsInfo.feeTypeMap[tbAgentpayDetailsInfoInstance.trade_Feetype]}</td>
                            <td>${TbAgentpayDetailsInfo.tradeFeeMap[tbAgentpayDetailsInfoInstance.trade_Feestyle]}</td>
                            <td>
                                <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.trade_Amount ? tbAgentpayDetailsInfoInstance.trade_Amount : 0}"/>
                                <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                            </td>
                            <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance.trade_Province ? tbAgentpayDetailsInfoInstance.trade_Province : ""}</td>
                            <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance.trade_City ? tbAgentpayDetailsInfoInstance.trade_City : ""}</td>
                            <td nowrap="nowrap">${TbAgentpayDetailsInfo.tradeStatusMap[tbAgentpayDetailsInfoInstance.trade_Status]}</td>


                            <td><g:checkBox name="box" value="${tbAgentpayDetailsInfoInstance.detail_id}" checked="false" onclick="disCheckAll(this);"></g:checkBox></td>

                        </tr>
                    </g:each>

                </table>
            </div>
            <table align="center">
                <tr>&nbsp;</tr>
                <tr>
                    <g:hiddenField name="flag" value="F"/>
                    <td align="center">
                        %{--<bo:hasPerm perm="${Perm.AgentPay_Check_CheckT}"><g:actionSubmit   class="right_top_h2_button_tj" action="frTrialPass" value="审核通过" onclick="return selectCheck();"/></bo:hasPerm>--}%
                        <bo:hasPerm perm="${Perm.AgentPay_Check_CheckT}"><input class="right_top_h2_button_tj" type="button" value="审核通过" onclick="selectCheck('frTrialPass')"/></bo:hasPerm>
                    </td>
                    <td align="center">
                        %{--<bo:hasPerm perm="${Perm.AgentPay_Check_CheckF}"><g:actionSubmit  class="right_top_h2_button_tj" action="frTrialRefuse" value="审核拒绝" onclick="return selectCheck();"/></bo:hasPerm>--}%
                        <bo:hasPerm perm="${Perm.AgentPay_Check_CheckF}"><input class="right_top_h2_button_tj" type="button" value="审核拒绝" onclick="selectCheck('frTrialRefuse')"/></bo:hasPerm>
                    </td>
                </tr>
            </table>
        </g:form>
        <div class="paginateButtons">
            <div style=" float:left;">共${tbAgentpayDetailsInfoInstanceTotal}条记录</div>
            <g:paginat total="${tbAgentpayDetailsInfoInstanceTotal}" params="${params}"/>
        </div>
        <div>
            <g:hiddenField name="m" value="${totalMoney}"/>
            <g:hiddenField name="f" value="${totalFee}"/>

            合计笔数：${tbAgentpayDetailsInfoInstanceTotal}笔&nbsp;&nbsp;&nbsp;&nbsp;金额：<g:formatNumber number="${totalMoney}" format="#.##"/>元&nbsp;&nbsp;&nbsp;&nbsp;手续费：<g:formatNumber number="${totalFee}" format="#.##"/>元&nbsp;&nbsp;&nbsp;&nbsp;实收/付金额： <g:formatNumber number="${totalMoney}" format="#.##"/>元

        </div>
    </div>
</div>

</body>
</html>
