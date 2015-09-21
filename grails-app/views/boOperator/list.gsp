<%@ page import="ismp.CmCorporationInfo; boss.BoOperatorController; boss.BossRole; boss.Perm; boss.BoRole; boss.BoOperator;boss.BoBranchCompany" %>
%{--<%@ page import="ismp.TradeBase; ismp.TradeBase4Query; boss.BoOperator" %>--}%
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boOperator.label', default: 'BoOperator')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>

</head>

<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <div class="table_serch">
            <table>
                <g:form name="operator">
                    <tr>
                        <td>登陆名:</td><td><p><g:textField name="account" onblur="value=value.replace(/[ ]/g,'')" value="${params.account}"></g:textField></p></td>
                        <td>姓名:</td><td><p><g:textField name="name" onblur="value=value.replace(/[ ]/g,'')" value="${params.name}"></g:textField></p></td>
			　　　　　　<td>状态:</td><td><g:select name="status" from="${BoOperator.statusMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" value="params.status"/></td>
                    </tr>

                    <tr>
                        <td>角色:</td><td><g:select name="role" from="${BossRole.list()}" optionKey="id" optionValue="roleName" style="width:230px" noSelection="${['':'-请选择-']}" value="${params?.role}"/></td>
                        <td>创建日期:</td><td><g:textField name="startTime" value="${params.startTime}" size="10" class="right_top_h2_input" style="width:80px" onchange="checkDate()" />
                    ----<g:textField name="endTime" value="${params.endTime}" size="10" class="right_top_h2_input" style="width:80px" onchange="checkDate()" /></td>
                    </tr>
                    <tr>
                    <td>分公司:</td><td><g:select name="branchCompany" from="${BoBranchCompany.list()}" optionKey="id" optionValue="companyName"  style="width:230px" noSelection="${['':'-请选择-']}" value="${params?.branchCompany}"/></td>
                    %{--<td>销售:</td><td><g:select name="belongToSale" from="${sales}" style="width:230px" noSelection="${['':'-请选择-']}" value="${params?.belongToSale}"/></td>--}%
                    <td><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkDate()"/></td>
                    <td><g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/></td>
                    <td><bo:hasPerm perm="${Perm.Security_Op_New}" ><g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/></bo:hasPerm></td>
                    </tr>
                </g:form>
            </table>
        </div>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="account" title="${message(code: 'boOperator.account.label', default: 'account')}"/>
                <g:sortableColumn params="${params}" property="name" title="${message(code: 'boOperator.name.label', default: 'name')}"/>
                <g:sortableColumn params="${params}" property="status" title="${message(code: 'boOperator.status.label', default: 'status')}"/>
                <g:sortableColumn params="${params}" property="role" title="${message(code: 'boOperator.role.label', default: 'role')}"/>
                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'boOperator.dateCreated.label', default: 'Date Created')}"/>
                <th>操作</th>
            </tr>

            <g:each in="${boOperatorInstanceList}" status="i" var="boOperatorInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:if test="${bo.hasPerm(perm:Perm.Security_Op_View){true}}" ><g:link action="show" id="${boOperatorInstance.id}">${fieldValue(bean: boOperatorInstance, field: "account")}</g:link></g:if><g:else>${fieldValue(bean: boOperatorInstance, field: "account")}</g:else></td>
                    <td>${fieldValue(bean: boOperatorInstance, field: "name")}</td>
                    <td>${BoOperator.statusMap[boOperatorInstance?.status]}</td>
                    <td>${boOperatorInstance.role?.roleName}</td>
                    <td><g:formatDate date="${boOperatorInstance.dateCreated}" format="yyyy-MM-dd"/></td>
                    <td>
                    %{--<input type="button" onclick="window.location.href = '${createLink(controller:'boRole', action:'addUser', params:['uid':boOperatorInstance?.id])}'" value="设置用户角色"/>--}%
                      <bo:hasPerm perm="${Perm.Security_Op_Status}">
                        <g:if test="${boOperatorInstance.account!='admin'}">

                            <g:if test="${boOperatorInstance?.status=='disabled'}">
                                <input type="button" onclick="return checkStatus(${boOperatorInstance?.id}, 1);" value="启用"/>
                              <bo:hasPerm perm="${Perm.Security_Op_Del}">
                                <input type="button" onclick="return delectOp(${boOperatorInstance?.id})
                                window.location.href = '${createLink(controller:'boOperator', action:'delete', params:['id':boOperatorInstance?.id])}';
                                return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" value="删除"/>
                              </bo:hasPerm>
                            </g:if>
                            <g:if test="${boOperatorInstance?.status=='normal'}">
                                <input type="button" onclick="return checkStatus(${boOperatorInstance?.id}, 2);" value="停用"/>
                            </g:if>

                        </g:if>
                      </bo:hasPerm>
                    </td>
                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${boOperatorInstanceTotal}条记录</span>
            <g:paginat total="${boOperatorInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function() {
        $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });

    function checkDate() {
        if (!document.getElementById('endTime').value.length == 0) {
            var startDateCreated = document.getElementById('startTime').value;
            var endDateCreated = document.getElementById('endTime').value;
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endTime').focus();
                return false;
            }
        }
    }
    //      function deleteCheck(str){
    //          document.forms['operator'].action="/Boss/boOperator/delete/"+str;
    //          alert(document.forms['operator'].action);
    //          document.forms['operator'].submit();
    //      }
    function checkStatus(str, flag) {
        if (confirm("确定要改变操作员状态吗！")) {
            if (flag == 1) {
                window.location.href = '${createLink(controller:'boOperator', action:'updateStatus', params:['statusFlag':'1'])}&id=' + str;
            }
            if (flag == 2) {
                window.location.href = '${createLink(controller:'boOperator', action:'updateStatus', params:['statusFlag':'0'])}&id=' + str;
            }
        }
    }
    function delectOp(str) {
        if (confirm("确定要删除该操作员吗！")) {
            window.location.href = '${createLink(controller:'boOperator', action:'delete', params:['statusFlag':'1'])}&id=' + str;
        }
    }
            function empty() {
        $(':input') .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
        return false;
    }
</script>
</body>
</html>
