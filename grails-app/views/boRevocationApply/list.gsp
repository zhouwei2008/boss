<%@ page import="ebank.tools.StringUtil; boss.BoBranchCompany; boss.BoOfflineCharge; boss.Perm" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boRevocationApply.label', default: 'boRevocationApply')}"/>
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

                        <td>${message(code: 'boRevocationApply.trxsqe.label')}：</td>
                        <td><g:textField name="trxsqe" onblur="value=value.replace(/[ ]/g,'')" value="${params.trxsqe}" class="right_top_h2_input"/></td>
                        <td>${message(code: 'boRevocationApply.amount.label')}：</td>
                        <td><p><g:textField name="amount" onblur="checkmoney(this)"   value="${params.amount}" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'boRevocationApply.creator.label')}：</td>
                        <td><g:textField name="creator_name" value="${params.creator_name}" class="right_top_h2_input"/></td>
                    </tr>

                    <tr>
                        <td>${message(code: 'boRevocationApplyApprove.oldSeq.label')}：</td>
                        <td><g:textField name="oldSeq" value="${params.oldSeq}" class="right_top_h2_input"/></td>
                         <td>${message(code: 'boRevocationApply.branchname.label')}：</td>
                         <td><p>
                            <g:if test="${flag}">
                                 <g:select name="branchCode" from="${BoBranchCompany.list()}"  value="${params.branchCode}" style="width:170px" optionKey="id" optionValue="companyName" noSelection="${['':'-请选择-']}" disabled="true"/>
                            </g:if>
                             <g:if test="${flag==false}">
                                 <g:select name="branchCode" from="${BoBranchCompany.list()}"  value="${params.branchCode}" style="width:170px" optionKey="id" optionValue="companyName" noSelection="${['':'-请选择-']}" />
                            </g:if>
                        </p></td>
                        <td>${message(code: 'boRevocationApply.authsts.label')}：</td>
                        <td><p><g:select name="authsts" from="${BoOfflineCharge.authstsMap}" value="${params.authsts}" noSelection="${['':'-全部-']}" optionKey="key" optionValue="value" class="left_top_h2_input"/></p></td>

                    </tr>
                  <tr>
                       <td>${message(code: 'boRevocationApplyApprove.accountName.label')}：</td>
                        <td><g:textField name="accountName" value="${params.accountName}" class="right_top_h2_input"/></td>
                      <td>${message(code: 'boRevocationApply.createtime.label')}：</td>
                                            <td><g:textField name="startTime" style="width:80px" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.startTime}" class="right_top_h2_input"/>--<g:textField name="endTime" style="width:80px" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.endTime}" class="right_top_h2_input"/></td>

                         <td>
                            <bo:hasPerm perm="${Perm.TravelCard_ReCharge_CanApply_Quary}">
                            <g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkDate()"/>
                            </bo:hasPerm>
                            <bo:hasPerm perm="${Perm.TravelCard_ReCharge_CanApply_DL}">
                            <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()"/>
                            </bo:hasPerm>
                        </td>
                    </tr>
                </table>
            </div>

        </g:form>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="trxtype" title="${message(code: 'boRevocationApply.trxtype.label', default: 'trxtype')}"/>

                <g:sortableColumn params="${params}" property="accountNo" title="${message(code: 'boRevocationApply.account.label', default: 'accountNo')}"/>

                  <g:sortableColumn params="${params}" property="accountName" title="${message(code: 'boRevocationApply.accountName.label', default: 'accountName')}"/>

                <g:sortableColumn params="${params}" property="branchname" title="${message(code: 'boRevocationApply.branchname.label', default: 'branchname')}"/>

                <g:sortableColumn params="${params}" property="createdate" title="${message(code: 'boRevocationApply.createtime.label', default: 'createdate')}"/>

                <g:sortableColumn params="${params}" property="authdate" title="${message(code: 'boRevocationApply.apptime.label', default: 'authdate')}"/>

                <g:sortableColumn params="${params}" property="creator_name" title="${message(code: 'boRevocationApply.creator.label', default: 'creator_name')}"/>

                <g:sortableColumn params="${params}" property="author_name" title="${message(code: 'boRevocationApply.author.label', default: 'author_name')}"/>

                <g:sortableColumn params="${params}" property="trxSeq" title="${message(code: 'boRevocationApply.trxsqe.label', default: 'trxSeq')}"/>

                <g:sortableColumn params="${params}" property="oldSeq" title="${message(code: 'boRevocationApply.oldsqe.label', default: 'oldSeq')}"/>

                <g:sortableColumn params="${params}" property="amount" title="${message(code: 'boRevocationApply.amount.label', default: 'amount')}"/>

                <g:sortableColumn params="${params}" property="realamount" title="${message(code: 'boRevocationApply.realamount.label', default: 'realamount')}"/>

                <g:sortableColumn params="${params}" property="billmode" title="${message(code: 'boRevocationApply.billmode.label', default: 'billmode')}"/>

                <g:sortableColumn params="${params}" property="status" title="${message(code: 'boRevocationApply.status.label', default: 'status')}"/>

                <g:sortableColumn params="${params}" property="authsts" title="${message(code: 'boRevocationApply.authsts.label', default: 'authsts')}"/>

                 <g:sortableColumn params="${params}" property="voidstatus" title="${message(code: 'boRevocationApply.voidstatus.label', default: 'voidstatus')}"/>

                <g:sortableColumn params="${params}" property="note" title="${message(code: 'boRevocationApply.note.label', default: 'note')}"/>
                  <th>操作</th>
            </tr>

            <g:each in="${boRevocationApplyInstanceList}" status="i" var="boRevocationApplyInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                   <g:if test="${boRevocationApplyInstance?.authsts=='Y'&&boRevocationApplyInstance?.trxtype=='charge'}">
                    <td>
                        <g:if test="${boRevocationApplyInstance?.trxtype=='charge'}">充值</g:if>
                        <g:if test="${boRevocationApplyInstance?.trxtype=='void'}">撤销</g:if>
                      </td>
                    <td>${fieldValue(bean: boRevocationApplyInstance, field: "accountNo")}</td>
                        <td>${fieldValue(bean: boRevocationApplyInstance, field: "accountName")}</td>
                    <td>${fieldValue(bean: boRevocationApplyInstance, field: "branchname")}</td>

                   <td><g:formatDate date="${boRevocationApplyInstance.createdate}" format="yyyy-MM-dd HH:mm:ss"/></td>

                    <td><g:formatDate date="${boRevocationApplyInstance.authdate}" format="yyyy-MM-dd HH:mm:ss"/></td>

                    <td>${fieldValue(bean: boRevocationApplyInstance, field: "creator_name")}</td>
                     <td>${fieldValue(bean: boRevocationApplyInstance, field: "author_name")}</td>
                    <td>
                         <g:if test="${bo.hasPerm(perm:Perm.TravelCard_ReCharge_CanApply_View){true}}">
                         <g:link action="show" id="${boRevocationApplyInstance.id}">${fieldValue(bean: boRevocationApplyInstance, field: "trxSeq")}</g:link>
                         </g:if>
                     </td>
                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.TravelCard_ReCharge_CanApply_View){true}}">
                         <g:link action="show" id="${boRevocationApplyInstance.id}">${fieldValue(bean: boRevocationApplyInstance, field: "oldSeq")}</g:link>
                         </g:if>
                    </td>

                       <td>￥<g:if test="${boRevocationApplyInstance?.trxtype=='void'}">-</g:if>${StringUtil.getAmountFromNum(String.valueOf(boRevocationApplyInstance.amount))}</td>

                        <td>￥<g:if test="${boRevocationApplyInstance?.trxtype=='void'}">-</g:if>${StringUtil.getAmountFromNum(String.valueOf(boRevocationApplyInstance.realamount))}</td>


                    <td>
                        <g:if test="${boRevocationApplyInstance?.billmode=='cashier'}">现金</g:if>
                        <g:if test="${boRevocationApplyInstance?.billmode=='check'}">支票</g:if>
                        <g:if test="${boRevocationApplyInstance?.billmode=='transfer'}">转账</g:if>
                        <g:if test="${boRevocationApplyInstance?.billmode=='other'}">其他</g:if>
                    </td>
                    <td>
                        <g:if test="${boRevocationApplyInstance?.status=='Y'}">完成</g:if>
                        <g:if test="${boRevocationApplyInstance?.status=='N'}">待处理</g:if>
                        <g:if test="${boRevocationApplyInstance?.status=='P'}">处理中</g:if>
                        <g:if test="${boRevocationApplyInstance?.status=='F'}">失败</g:if>
                        <g:if test="${boRevocationApplyInstance?.status=='C'}">取消</g:if>
                    </td>

                     <td>
                        <g:if test="${boRevocationApplyInstance?.authsts=='N'}">待审</g:if>
                        <g:if test="${boRevocationApplyInstance?.authsts=='P'}">审核中</g:if>
                        <g:if test="${boRevocationApplyInstance?.authsts=='Y'}">审核通过</g:if>
                        <g:if test="${boRevocationApplyInstance?.authsts=='F'}">审核拒绝</g:if>
                    </td>
                        <td>
                        <g:if test="${boRevocationApplyInstance?.voidstatus=='Y'}">已撤销</g:if>
                        <g:if test="${boRevocationApplyInstance?.voidstatus=='N'}">处理中</g:if>
                            </td>
                    <td>${fieldValue(bean: boRevocationApplyInstance, field: "note")}</td>
                    <td>
                                           <bo:hasPerm perm="${Perm.TravelCard_ReCharge_CanApply_Add}">
                                               <g:if test="${boRevocationApplyInstance?.authsts=='Y'&&boRevocationApplyInstance?.trxtype=='charge'&&boRevocationApplyInstance?.voidstatus==null}"><input type="button" onclick="window.location.href = '${createLink(controller:'boRevocationApply', action:'create', params:['id':boRevocationApplyInstance?.id])}'" value="撤销"/></g:if>
                                               %{--<g:if test="${boRevocationApplyInstance?.authsts!='Y'||boRevocationApplyInstance?.trxtype!='charge'}"><input type="button"  value="撤销" disabled="false"/></g:if>--}%
                                           </bo:hasPerm>
                                       </td>
                       </g:if>
                    <g:else>
                    <td>
                        <g:if test="${boRevocationApplyInstance?.trxtype=='charge'}">充值</g:if>
                        <g:if test="${boRevocationApplyInstance?.trxtype=='void'}">充值撤销</g:if>
                      </td>
                    <td>${fieldValue(bean: boRevocationApplyInstance, field: "accountNo")}</td>
                   <td>${fieldValue(bean: boRevocationApplyInstance, field: "accountName")}</td>
                    <td>${fieldValue(bean: boRevocationApplyInstance, field: "branchname")}</td>
                    <td><g:formatDate date="${boRevocationApplyInstance.createdate}" format="yyyy-MM-dd HH:mm:ss"/></td>

                     <td><g:formatDate date="${boRevocationApplyInstance.authdate}" format="yyyy-MM-dd HH:mm:ss"/></td>


                    <td>${fieldValue(bean: boRevocationApplyInstance, field: "creator_name")}</td>
                     <td>${fieldValue(bean: boRevocationApplyInstance, field: "author_name")}</td>

                    <td>
                         <g:if test="${bo.hasPerm(perm:Perm.TravelCard_ReCharge_Appay_View){true}}">
                         <g:link action="show" id="${boRevocationApplyInstance.id}">${fieldValue(bean: boRevocationApplyInstance, field: "trxSeq")}</g:link>
                         </g:if>
                     </td>
                     <td>
                        <g:if test="${bo.hasPerm(perm:Perm.TravelCard_ReCharge_Appay_View){true}}">
                         <g:link action="show" id="${boRevocationApplyInstance.id}">${fieldValue(bean: boRevocationApplyInstance, field: "oldSeq")}</g:link>
                         </g:if>
                    </td>
                    <td>￥<g:if test="${boRevocationApplyInstance?.trxtype=='void'}">-</g:if>${StringUtil.getAmountFromNum(String.valueOf(boRevocationApplyInstance.amount))}</td>

                    <td>￥<g:if test="${boRevocationApplyInstance?.trxtype=='void'}">-</g:if>${StringUtil.getAmountFromNum(String.valueOf(boRevocationApplyInstance.realamount))}</td>

                    <td>
                        <g:if test="${boRevocationApplyInstance?.billmode=='cashier'}">现金</g:if>
                        <g:if test="${boRevocationApplyInstance?.billmode=='check'}">支票</g:if>
                        <g:if test="${boRevocationApplyInstance?.billmode=='transfer'}">转账</g:if>
                        <g:if test="${boRevocationApplyInstance?.billmode=='other'}">其他</g:if>
                    </td>
                    <td>
                        <g:if test="${boRevocationApplyInstance?.status=='Y'}">完成</g:if>
                        <g:if test="${boRevocationApplyInstance?.status=='N'}">待处理</g:if>
                        <g:if test="${boRevocationApplyInstance?.status=='P'}">处理中</g:if>
                        <g:if test="${boRevocationApplyInstance?.status=='F'}">失败</g:if>
                        <g:if test="${boRevocationApplyInstance?.status=='C'}">取消</g:if>
                    </td>

                     <td>
                        <g:if test="${boRevocationApplyInstance?.authsts=='N'}">待审</g:if>
                        <g:if test="${boRevocationApplyInstance?.authsts=='P'}">审核中</g:if>
                        <g:if test="${boRevocationApplyInstance?.authsts=='Y'}">审核通过</g:if>
                        <g:if test="${boRevocationApplyInstance?.authsts=='F'}">审核拒绝</g:if>
                    </td>
                      <td>    <g:if test="${boRevocationApplyInstance?.voidstatus=='Y'}">已撤销</g:if>
                        <g:if test="${boRevocationApplyInstance?.voidstatus=='N'}">处理中</g:if></td>
                    <td>${fieldValue(bean: boRevocationApplyInstance, field: "note")}</td>
                    <td>

                                       </td>
                       </g:else>
                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${boRevocationApplyInstanceTotal}条记录</span>
            <g:paginat total="${boRevocationApplyInstanceTotal}" params="${params}"/>
     </div>
</div>
</body>
</html>


