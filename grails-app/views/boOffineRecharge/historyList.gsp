<%@ page import="boss.BoBranchCompany; boss.BoOfflineCharge; boss.Perm" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boOffineCharge.history.label', default: 'boOffineCharge')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<script type="text/javascript">
    $(function() {
        $("#startTime").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endTime").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
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
      function checkmoney(obj){
        var patrn=/^\d+(\.\d{0,2})?$/;
        if(obj!=null&&obj.value!=''){
            if (!patrn.exec(obj.value)) {
                  alert("金额为无效金额，请重新填写！");
                   obj.value='';
                   obj.focus();
                   return false;
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

                        <td>${message(code: 'boOffineCharge.trxsqe.label')}：</td>
                        <td><p><g:textField name="trxsqe" onblur="value=value.replace(/[ ]/g,'')" value="${params.trxsqe}" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'boOffineCharge.amount.label')}：</td>
                        <td><g:textField name="amount" onblur="checkmoney(this)"  value="${params.amount}" class="right_top_h2_input"/></td>
                        <td>${message(code: 'boOffineCharge.creator.label')}：</td>
                        <td><g:textField name="creator_name" value="${params.creator_name}" class="right_top_h2_input"/></td>
                    </tr>
                    <tr>
                        <td>${message(code: 'boOffineCharge.billmode.label')}：</td>
                        <td><p><g:select name="billmode" from="${BoOfflineCharge.billmodeMap}" value="${params.billmode}" noSelection="${['':'-全部-']}" optionKey="key" optionValue="value" class="left_top_h2_input"/></p></td>
                        <td>${message(code: 'boOffineCharge.status.label')}：</td>
                        <td><p><g:select name="status" from="${BoOfflineCharge.statusMap}" value="${params.status}" noSelection="${['':'-全部-']}" optionKey="key" optionValue="value" class="left_top_h2_input"/></p></td>
                        <td>${message(code: 'boOffineCharge.branchname.label')}：</td>
                        <td><p>
                            <g:if test="${flag}">
                                 <g:select name="branchCode" from="${BoBranchCompany.list()}"  value="${params.branchCode}" style="width:170px" optionKey="id" optionValue="companyName" noSelection="${['':'-请选择-']}" disabled="true"/>
                            </g:if>
                             <g:if test="${flag==false}">
                                 <g:select name="branchCode" from="${BoBranchCompany.list()}"  value="${params.branchCode}" style="width:170px" optionKey="id" optionValue="companyName" noSelection="${['':'-请选择-']}" />
                            </g:if>
                        </p></td>
                    </tr>

                    <tr>
                        <td>${message(code: 'boOffineCharge.authsts.label')}：</td>
                        <td><p><g:select name="authsts" from="${BoOfflineCharge.authstsMap}" value="${params.authsts}" noSelection="${['':'-全部-']}" optionKey="key" optionValue="value" class="left_top_h2_input"/></p></td>
                          <td>${message(code: 'boOffineCharge.account.label')}：</td>
                        <td><g:textField name="accountNo" value="${params.accountNo}" class="right_top_h2_input" /></td>
                        <td>${message(code: 'boOffineCharge.accountName.label')}：</td>
                        <td><g:textField name="accountName" value="${params.accountName}" class="right_top_h2_input" /></td>
                     </tr>
                    <tr>
                        <td>${message(code: 'boOffineCharge.createtime.label')}：</td>
                         <td><g:textField name="startTime" style="width:80px" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.startTime}" class="right_top_h2_input"/>--<g:textField name="endTime" style="width:80px" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.endTime}" class="right_top_h2_input"/></td>
                        <td>
                            <bo:hasPerm perm="${Perm.TravelCard_ReCharge_ApplyQuary_Quary}">
                            <g:actionSubmit class="right_top_h2_button_serch" action="historyList" value="查询" onclick="return checkDate()"/>
                             </bo:hasPerm>
                            <bo:hasPerm perm="${Perm.TravelCard_ReCharge_ApplyQuary_DL}">
                            <g:actionSubmit class="right_top_h2_button_download" action="historyListDownload" value="下载" onclick="return checkDate()"/>
                            </bo:hasPerm>
                        </td>
                    </tr>
                </table>
            </div>
        </g:form>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="trxtype" title="${message(code: 'boOffineCharge.trxtype.label', default: 'trxtype')}"/>

                <g:sortableColumn params="${params}" property="accountNo" title="${message(code: 'boOffineCharge.account.label', default: 'accountNo')}"/>

                <g:sortableColumn params="${params}" property="accountName" title="${message(code: 'boOffineCharge.accountName.label', default: 'accountName')}"/>

                <g:sortableColumn params="${params}" property="branchname" title="${message(code: 'boOffineCharge.branchname.label', default: 'branchname')}"/>

                <g:sortableColumn params="${params}" property="createdate" title="${message(code: 'boOffineCharge.createtime.label', default: 'createdate')}"/>

                <g:sortableColumn params="${params}" property="authdate" title="${message(code: 'boOffineCharge.apptime.label', default: 'authdate')}"/>

                <g:sortableColumn params="${params}" property="creator_name" title="${message(code: 'boOffineCharge.creator.label', default: 'creator_name')}"/>

                <g:sortableColumn params="${params}" property="trxSeq" title="${message(code: 'boOffineCharge.trxsqe.label', default: 'trxSeq')}"/>

                %{--<g:sortableColumn params="${params}" property="oldSeq" title="${message(code: 'boOffineCharge.oldsqe.label', default: 'oldSeq')}"/>--}%

                <g:sortableColumn params="${params}" property="amount" title="${message(code: 'boOffineCharge.amount.label', default: 'amount')}"/>

                <g:sortableColumn params="${params}" property="realamount" title="${message(code: 'boOffineCharge.realamount.label', default: 'realamount')}"/>

                <g:sortableColumn params="${params}" property="billmode" title="${message(code: 'boOffineCharge.billmode.label', default: 'billmode')}"/>

                <g:sortableColumn params="${params}" property="status" title="${message(code: 'boOffineCharge.status.label', default: 'status')}"/>

                <g:sortableColumn params="${params}" property="authsts" title="${message(code: 'boOffineCharge.authsts.label', default: 'authsts')}"/>

                <g:sortableColumn params="${params}" property="note" title="${message(code: 'boOffineCharge.note.label', default: 'note')}"/>

            </tr>

            <g:each in="${boOffineChargeInstanceList}" status="i" var="boOffineChargeInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td>
                        <g:if test="${boOffineChargeInstance?.trxtype=='charge'}">充值</g:if>
                        <g:if test="${boOffineChargeInstance?.trxtype=='void'}">充值撤销</g:if>
                      </td>
                    <td>${fieldValue(bean: boOffineChargeInstance, field: "accountNo")}</td>
                    <td>${fieldValue(bean: boOffineChargeInstance, field: "accountName")}</td>

                    <td>${fieldValue(bean: boOffineChargeInstance, field: "branchname")}</td>

                    <td><g:formatDate date="${boOffineChargeInstance.createdate}" format="yyyy-MM-dd HH:mm:ss"/></td>

                    <td><g:formatDate date="${boOffineChargeInstance.authdate}" format="yyyy-MM-dd HH:mm:ss"/></td>

                    <td>${fieldValue(bean: boOffineChargeInstance, field: "creator_name")}</td>

                    <td>
                         <g:if test="${bo.hasPerm(perm:Perm.TravelCard_ReCharge_ApplyQuary_View){true}}">
                         <g:link action="show" id="${boOffineChargeInstance.id}">${fieldValue(bean: boOffineChargeInstance, field: "trxSeq")}</g:link>
                         </g:if>
                     </td>
                    %{--<td>${fieldValue(bean: boOffineChargeInstance, field: "oldSeq")}</td>--}%

                   <td><g:formatNumber number="${boOffineChargeInstance.amount/100}" type="currency" currencyCode="CNY"/></td>

                    <td><g:formatNumber number="${boOffineChargeInstance.realamount/100}" type="currency" currencyCode="CNY"/></td>

                    <td>
                        <g:if test="${boOffineChargeInstance?.billmode=='cashier'}">现金</g:if>
                        <g:if test="${boOffineChargeInstance?.billmode=='check'}">支票</g:if>
                        <g:if test="${boOffineChargeInstance?.billmode=='transfer'}">转账</g:if>
                        <g:if test="${boOffineChargeInstance?.billmode=='other'}">其他</g:if>
                    </td>
                    <td>
                        <g:if test="${boOffineChargeInstance?.status=='Y'}">完成</g:if>
                        <g:if test="${boOffineChargeInstance?.status=='N'}">待处理</g:if>
                        <g:if test="${boOffineChargeInstance?.status=='P'}">处理中</g:if>
                        <g:if test="${boOffineChargeInstance?.status=='F'}">失败</g:if>
                        <g:if test="${boOffineChargeInstance?.status=='C'}">取消</g:if>
                    </td>

                     <td>
                        <g:if test="${boOffineChargeInstance?.authsts=='N'}">待审</g:if>
                        <g:if test="${boOffineChargeInstance?.authsts=='P'}">审核中</g:if>
                        <g:if test="${boOffineChargeInstance?.authsts=='Y'}">审核通过</g:if>
                        <g:if test="${boOffineChargeInstance?.authsts=='F'}">审核拒绝</g:if>
                    </td>

                    <td>${fieldValue(bean: boOffineChargeInstance, field: "note")}</td>

                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${boOffineChargeInstanceTotal}条记录</span>
            <g:paginat total="${boOffineChargeInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>


