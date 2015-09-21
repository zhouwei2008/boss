<%@ page import="boss.Perm; dsf.TbAgentpayDetailsInfo" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: '')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript">
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
        function selectCheck() {
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
                return true;
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
        function checkQueryParams(){

           var startMoney = document.getElementById("startMoney");
           var endMoney = document.getElementById("endMoney");
           var rex = "^\\d{1,8}(\\.\\d{1,2}){0,1}$";
           var re = new RegExp(rex);
           if(startMoney!= null && startMoney.value!=""){
               if(startMoney.value.search(re)==-1){
                   alert("起始金额输入有误,且最大值99999999.99！！");
                   return false;
               }
           }
           if(endMoney!= null && endMoney.value!=""){
               if(endMoney.value.search(re)==-1){
                   alert("截止金额输入有误,且最大值99999999.99！！");
                   return false;
                }
           }

           if(startMoney.value!="" && endMoney.value!=""){
                if(parseFloat(startMoney.value)> parseFloat(endMoney.value)){
                    alert("起始金额不能大于截止金额，请确认！");
                    return false;
                }
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
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>

        </h2>
    <table align="center" class="right_list_table" id="test">
        <g:form  action="itemShow">
            <g:hiddenField name="id" id="id" value="${id}"/>
            收款人：<g:textField name="tradeCardname" value="${params.tradeCardname}" size="10" class="right_top_h2_input" style="width:150px"/>
            收款账号：<g:textField name="tradeCardnum" value="${params.tradeCardnum}" size="10" class="right_top_h2_input" style="width:150px"/>
            起始金额：<g:textField id ="startMoney" name="startMoney" value="${params.startMoney}" size="10" class="right_top_h2_input" style="width:150px"/>
            截止金额：<g:textField id = "endMoney" name="endMoney" value="${params.endMoney}" size="10" class="right_top_h2_input" style="width:150px"/>
            <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkQueryParams()" />
            <g:hiddenField name="ids" id="ids"/>
            <tr>

                <g:sortableColumn params="${params}" property="batchId" title="${message(code: 'tbAgentpayDetailsInfo.batchId.label', default: 'Batch Id')}"/>
                <g:sortableColumn params="${params}" property="id" title="${message(code: 'tbAgentpayDetailsInfo.tradeNum.label', default: 'Trade Num')}"/>
                <g:sortableColumn params="${params}" property="dkPcNo" title="批次号"/>
                <g:sortableColumn params="${params}" property="tradeType" title="${message(code: '业务类型', default: '业务类型')}"/>


                <g:sortableColumn params="${params}" property="tradeCardname" title="收款人"/>

                <g:sortableColumn params="${params}" property="tradeCardnum" title="收款账号"/>

                <g:sortableColumn params="${params}" property="tradeAccountname" title="收款银行"/>

                <g:sortableColumn params="${params}" property="tradeSysdate" title="${message(code: 'tbAgentpayDetailsInfo.tradeSysdate.label', default: 'Trade Sysdate')}"/>
                <g:sortableColumn params="${params}" property="tradeRemark" title="省"/>
                 <g:sortableColumn params="${params}" property="tradeRemark" title="市"/>
                <g:sortableColumn params="${params}" property="tradeAccounttype" title="${message(code: 'tbAgentpayDetailsInfo.tradeAccounttype.label', default: 'Trade Account Type')}"/>

                <g:sortableColumn params="${params}" property="tradeBranchbank" title="${message(code: 'tbAgentpayDetailsInfo.tradeBranchbank.label', default: 'tradeBranchbank')}"/>

                <g:sortableColumn params="${params}" property="tradeSubbranchbank" title="${message(code: 'tbAgentpayDetailsInfo.tradeSubbranchbank.label', default: 'tradeSubbranchbank')}"/>

                <g:sortableColumn params="${params}" property="tradeAmount" title="${message(code: 'tbAgentpayDetailsInfo.tradeAmount.label', default: 'Trade Amount')}"/>

                <g:sortableColumn params="${params}" property="tradeFee" title="${message(code: 'tbAgentpayDetailsInfo.tradeFee.label', default: 'Trade Fee')}"/>

                <g:sortableColumn params="${params}" property="tradeFeetype" title="${message(code: 'tbAgentpayDetailsInfo.tradeFeetype.label', default: '收费方式')}"/>


                <g:sortableColumn params="${params}" property="tradeFeestyle" title="退手续费"/>

                <g:sortableColumn params="${params}" property="tradeAccamount" title="实付金额"/>

                <g:sortableColumn params="${params}" property="payStatus" title="${message(code: 'tbAgentpayDetailsInfo.payStatus.label', default: 'Pay Status')}"/>
                <td nowrap>手工操作</td>
            </tr>

            <g:each in="${tbAgentpayDetailsInfoInstanceList}" status="i" var="tbAgentpayDetailsInfoInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "batchBizid")}</td>

                    <td>${tbAgentpayDetailsInfoInstance.id}</td>
                    <td>${tbAgentpayDetailsInfoInstance.dkPcNo}</td>
                    <td>
                        ${TbAgentpayDetailsInfo.typeMap[tbAgentpayDetailsInfoInstance.tradeType]}
                    </td>

                    <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeCardname")}</td>

                    <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeCardnum")}</td>
                    <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeAccountname")}</td>

                    <td>
                        <g:formatDate date="${tbAgentpayDetailsInfoInstance.tradeSysdate}" format="yyyy-MM-dd HH:mm:ss"/>
                    </td>
                    <td>${tbAgentpayDetailsInfoInstance.tradeRemark.split(';')[0]}</td>
                    <td>${tbAgentpayDetailsInfoInstance.tradeRemark.split(';')[1]}</td>
                    <td>
                        ${TbAgentpayDetailsInfo.accountTypeMap[tbAgentpayDetailsInfoInstance.tradeAccounttype]}
                    </td>
                    <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeBranchbank")}</td>

                    <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeSubbranchbank")}</td>

                    <td>

                        <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.tradeAmount ? tbAgentpayDetailsInfoInstance.tradeAmount : 0}"/>
                        <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                    </td>
                    <td>
                         <g:if test="${tbAgentpayDetailsInfoInstance.tradeType=='F'}">
                        <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.tradeFee ? tbAgentpayDetailsInfoInstance.tradeFee : 0}"/>
                        <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                         </g:if>
                         <g:if test="${tbAgentpayDetailsInfoInstance.tradeType=='S'}">
                           ${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeFee")}
                         </g:if>
                    </td>

                    <td>${TbAgentpayDetailsInfo.feeTypeMap[tbAgentpayDetailsInfoInstance.tradeFeetype]}</td>
                    <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeFeestyle")}</td>
                    <td>
                       <g:if test="${tbAgentpayDetailsInfoInstance.tradeType=='F'}">
                           <g:hiddenField name="dsflag" value="F"/>
                           <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.tradeAmount ? tbAgentpayDetailsInfoInstance.tradeAmount : 0}"/>
                           <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>

                       </g:if>
                       <g:if test="${tbAgentpayDetailsInfoInstance.tradeType=='S'}">
                           <g:hiddenField name="dsflag" value="S"/>
                       ${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeAmount")}
                       </g:if>
                    </td>

                    <td>${TbAgentpayDetailsInfo.dkStatusMap[tbAgentpayDetailsInfoInstance.payStatus]}</td>
                     <g:if test="${tbAgentpayDetailsInfoInstance.payStatus=='5'}">
                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.AgPay_Batch_View_ChangeFail){true}}">
                            <g:link action="updateF"  id="${tbAgentpayDetailsInfoInstance.id}">改失败</g:link>
                        </g:if>
                    </td>
                     </g:if>
                    <g:if test="${tbAgentpayDetailsInfoInstance.payStatus!='5'}">
                      <td></td>
                     </g:if>
                </tr>
            </g:each>
            <tr>
                <td colspan="19" align="center">
                    <input type="button" class="rigt_button back_btn" value="返回"/>

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

            合计笔数:${tbAgentpayDetailsInfoInstanceTotal}&nbsp;  金额：<g:formatNumber number="${totalMoney}" format="########################.##"/>&nbsp;手续费：<g:formatNumber number="${totalFee}" format="#.##"/>&nbsp;实收/付金额： <g:formatNumber number="${totalMoney}" format="########################.##"/>

        </div>
    </div>
</div>
</body>
</html>
