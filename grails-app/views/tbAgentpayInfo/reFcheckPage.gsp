<%@ page import="boss.Perm; dsf.TbPcInfo; dsf.TbAgentpayDetailsInfo" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: '退款初审信息')}"/>
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
               var reFcheckPageForm = document.forms['reFcheckPageForm'];
                reFcheckPageForm.action = "reFcheck";
                parent.showWait();
                reFcheckPageForm.submit();
            }

        }
        function cl() {

            var form = document.forms[0];
            for (var i = 0; i < form.elements.length; i++) {
                if (form.elements[i].type == "text" || form.elements[i].type == "text")
                    form.elements[i].value = "";
            }
            document.getElementById("bankNames").value = "";
            document.getElementById("tradeAccounttype").value = "";
            document.getElementById("tbPcDkChanel").value = "";
        }
    </script>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });
              /*---guonan update 2011-12-30----*/
    function checkDate() {
        var startDateCreated = document.getElementById('startTime').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endTime').value.replace(/-/g,"//");

        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }

    }
    /**
        *   取消明细选中的状态，取消全选效果
        * @param checkBoxObj
         */
        function disCheckAll(checkBoxObj){
            if(!checkBoxObj.checked){
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
    <div>
    <table align="center" class="right_list_table" >
        <g:form action="reFcheckPage" name = "reFcheckPageForm">
            <span>
            对账时间：<g:textField name="startTime" value="${params.startTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
            --<g:textField name="endTime" value="${params.endTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
            </span>
            <span>
            商户编号：<g:textField name="batchBizid" value="${params.batchBizid}" size="20" class="right_top_h2_input" style="width:140px"/>
            </span>
            <span>
            批次号：<input name="id" value="${params.id}" onKeyUp="value = value.replace(/[^\d|]/g, '')" />
            %{--打款通道：<g:select name="tbPcDkChanel" from="${bankChanelList}" optionKey="id" optionValue="${{it.bank.name+'-'+it.aliasName}}" value="${params.tbPcDkChanel}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>--}%
            </span>
            <span>
            收款人：<g:textField name="tradeCardname" value="${params.tradeCardname}" size="10" class="right_top_h2_input" style="width:150px"/>
            </span>
            <span>
            收款账号：<g:textField name="tradeCardnum" value="${params.tradeCardnum}" size="10" class="right_top_h2_input" style="width:150px"/>
            </span>
            <span>
            收款银行：<g:select name="bankNames" from="${bankNameList}" optionKey="${1}" optionValue="${2}" noSelection="${['':'--请选择--']}" value="${params.bankNames}"/>
        %{--<g:textField name="tradeAccountname" value="${params.tradeAccountname}" size="10" class="right_top_h2_input" style="width:150px"/>--}%
            </span>
            <span>
            账号类型：<g:select name="tradeAccounttype" from="${TbAgentpayDetailsInfo.accountTypeMap}" optionKey="key" optionValue="value" value="${params.tradeAccounttype}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
            </span>
            <span>
            <input type="submit" class="right_top_h2_button_serch" value="查询" />
            <input type="button" class="right_top_h2_button_serch" value="清空" onclick="cl();">
            <g:hiddenField name="ids" id="ids"/>
            </span>
            <tr>
            </table>
            </div>
            <div class="right_list_tablebox" style="height: 380px">
                <table align="center" class="right_list_table" id="test">
                    <g:sortableColumn params="${params}" property="dkPcNo" title="${message(code: 'tbAgentpayDetailsInfo.dkPcNo.label', default: '批次号')}"/>

                    <g:sortableColumn params="${params}" property="batchBizid" title="${message(code: 'tbAgentpayDetailsInfo.batchBizid.label', default: 'batchBizid Id')}"/>

                    <g:sortableColumn params="${params}" property="id" title="${message(code: 'tbAgentpayDetailsInfo.tradeNum.label', default: 'Trade Num')}"/>

                    %{--<g:sortableColumn params="${params}"  property="tradeRemark2" title="${message(code: 'tbAgentpayDetailsInfo.tradeRemark2.label', default: 'Trade Remark2')}"/>--}%
                    <td nowrap>业务类型</td>
                    <g:sortableColumn params="${params}" property="tradeCardname" title="${message(code: 'tbAgentpayDetailsInfo.tradeCardname.label', default: 'Trade Card Name')}"/>

                    <g:sortableColumn params="${params}" property="tradeCardnum" title="${message(code: 'tbAgentpayDetailsInfo.tradeCardnum.label', default: 'Trade Card Num')}"/>

                    <g:sortableColumn params="${params}" property="tradeAccountname" title="${message(code: 'tbAgentpayDetailsInfo.tradeAccountname.label', default: 'trade Account Name')}"/>

                    <g:sortableColumn params="${params}" property="tradeCommdate" title="${message(code: 'tbAgentpayDetailsInfo.tradeCommdate.label', default: 'Trade Sysdate')}"/>

                    <g:sortableColumn params="${params}" property="tradeAccounttype" title="${message(code: 'tbAgentpayDetailsInfo.tradeAccounttype.label', default: 'Trade Account Type')}"/>

                    <g:sortableColumn params="${params}" property="tradeBranchbank" title="${message(code: 'tbAgentpayDetailsInfo.tradeBranchbank.label', default: 'tradeBranchbank')}"/>

                    <g:sortableColumn params="${params}" property="tradeSubbranchbank" title="${message(code: 'tbAgentpayDetailsInfo.tradeSubbranchbank.label', default: 'tradeSubbranchbank')}"/>

                    %{--<th>打款通道</th>--}%


                    <g:sortableColumn params="${params}" property="tradeAmount" title="${message(code: 'tbAgentpayDetailsInfo.tradeAmount.label', default: 'Trade Amount')}"/>

                    <g:sortableColumn params="${params}" property="tradeFee" title="${message(code: 'tbAgentpayDetailsInfo.tradeFee.label', default: 'Trade Fee')}"/>

                    <g:sortableColumn params="${params}" property="tradeFeetype" title="${message(code: 'tbAgentpayDetailsInfo.tradeFeetype.label', default: '收费方式')}"/>


                    <g:sortableColumn params="${params}" property="tradeFeestyle" title="退手续费"/>

                   %{-- <g:sortableColumn params="${params}" property="fcheckName" title="打款初审"/>    --}%
                   %{-- <g:sortableColumn params="${params}" property="tcheckName" title="打款审核"/>  --}%
                    <g:sortableColumn params="${params}" property="tradeProvince" title="${message(code: 'tbAgentpayDetailsInfo.tradeProvince.label', default: 'Trade tradeProvince')}"/>
                    <g:sortableColumn params="${params}" property="tradeCity" title="${message(code: 'tbAgentpayDetailsInfo.tradeCity.label', default: 'Trade tradeCity')}"/>


                    <g:sortableColumn params="${params}" property="tradeAccamount" title="实付金额"/>
                    <g:sortableColumn params="${params}" property="tradeDonedate" title="对账时间"/>
                    <g:sortableColumn params="${params}" property="tradeRefued" title="${message(code: 'tbAgentpayDetailsInfo.tradeRefued.label', default: 'Pay Status')}"/>
                    <g:sortableColumn params="${params}"  property="tradeFeedbackcode" title="${message(code: 'tbAgentpayDetailsInfo.tradeFeedbackcode.label', default: 'Trade Feedback Code')}"/>
                    <g:sortableColumn params="${params}" property="tradeReason" title="${message(code: 'tbAgentpayDetailsInfo.tradeReason.label', default: 'Check Fail Reson')}"/>


                    <td nowrap>全选<input type="checkbox" id="allBox" name="allBox" onclick="checkAllBox();"></td>
                </tr>

                    <g:each in="${tbAgentpayDetailsInfoInstanceList}" status="i" var="tbAgentpayDetailsInfoInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td nowrap>${tbAgentpayDetailsInfoInstance.batch.id}</td>

                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "batchBizid")}</td>

                            <td nowrap>${tbAgentpayDetailsInfoInstance.id}</td>

                            <td nowrap>${TbAgentpayDetailsInfo.typeMap[tbAgentpayDetailsInfoInstance.tradeType]}</td>

                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeCardname")}</td>

                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeCardnum")}</td>
                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeAccountname")}</td>

                            <td nowrap><g:formatDate date="${tbAgentpayDetailsInfoInstance.tradeCommdate}" format="yyyy-MM-dd HH:mm:ss"/></td>

                            <td nowrap>
                                ${TbAgentpayDetailsInfo.accountTypeMap[tbAgentpayDetailsInfoInstance.tradeAccounttype]}
                            </td>
                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeBranchbank")}</td>

                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeSubbranchbank")}</td>

                            %{--<td nowrap>${TbPcInfo.get((tbAgentpayDetailsInfoInstance?.dkPcNo) as long)?.tbPcDkChanelname}</td>--}%

                            <td nowrap>
                                <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.tradeAmount ? tbAgentpayDetailsInfoInstance.tradeAmount : 0}"/>
                                <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                            </td>
                            <td nowrap>
                                <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.tradeFee ? tbAgentpayDetailsInfoInstance.tradeFee : 0}"/>
                                <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                            </td>

                            <td nowrap>${TbAgentpayDetailsInfo.feeTypeMap[tbAgentpayDetailsInfoInstance.tradeFeetype]}</td>
                            <td>${TbAgentpayDetailsInfo.tradeFeeMap[tbAgentpayDetailsInfoInstance.tradeFeestyle]}</td>

                             %{--<td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "fcheckName")}</td>  --}%
                             %{--<td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tcheckName")}</td>  --}%
                            <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance.tradeProvince?tbAgentpayDetailsInfoInstance.tradeProvince:""}</td>
                            <td nowrap="nowrap">${tbAgentpayDetailsInfoInstance.tradeCity?tbAgentpayDetailsInfoInstance.tradeCity:""}</td>

                            <td nowrap>
                                <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.tradeAmount ? tbAgentpayDetailsInfoInstance.tradeAmount : 0}"/>
                                <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
                            </td>
                              <td nowrap><g:formatDate date="${tbAgentpayDetailsInfoInstance.tradeDonedate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                            <td nowrap>${TbAgentpayDetailsInfo.tradeRefuedMap[tbAgentpayDetailsInfoInstance.tradeRefued]}</td>
                             <td nowrap="nowrap">${TbAgentpayDetailsInfo.tradeFeedbackcodeMap[tbAgentpayDetailsInfoInstance.tradeFeedbackcode]}</td>
                            <td nowrap>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeReason")}</td>

                            <td nowrap><g:checkBox name="box" value="${tbAgentpayDetailsInfoInstance.id}" checked="false" onclick="disCheckAll(this);"></g:checkBox></td>

                        </tr>
                    </g:each>

                </table>
            </div>

            <table align="center">
                <tr>&nbsp;</tr>
                <tr>
                    <td align="center">
                        %{--<bo:hasPerm perm="${Perm.Agent_RfdPreChk_CheckT}"><g:actionSubmit class="right_top_h2_button_tj" action="reFcheck" value="初审通过" onclick="return selectCheck();"/></bo:hasPerm>--}%
                        <bo:hasPerm perm="${Perm.Agent_RfdPreChk_CheckT}"><input class="right_top_h2_button_tj" type="button" value="初审通过" onclick="selectCheck()"/></bo:hasPerm>
                    </td>
                </tr>
            </table>
        </g:form>
    合计：金额总计：<g:formatNumber number="${totalAmount?totalAmount:0}" format="#.##"/>元&nbsp;&nbsp;&nbsp;&nbsp;手续费总计：<g:formatNumber number="${totalFee?totalFee:0}" format="#.##"/>元
        <div class="paginateButtons">
            <span class="left">共${tbAgentpayDetailsInfoInstanceTotal}条记录</span>
            <g:paginat total="${tbAgentpayDetailsInfoInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>

</body>
</html>
