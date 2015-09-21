<%@ page import="boss.Perm; boss.BoBranchCompany" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boBranchCompany.label', default: 'BoBranchCompany')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<script type="text/javascript">
    $(function() {
        var dates = $( "#startDateCreated, #endDateCreated" ).datepicker({
			dateFormat: 'yy-mm-dd',
            changeYear: true,
			changeMonth: true
		});
    });
    function checkDate() {
        if (!document.getElementById('endDateCreated').value.length == 0) {
            var startDateCreated = document.getElementById('startDateCreated').value;
            var endDateCreated = document.getElementById('endDateCreated').value;
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }
    }
     function empty() {
         document.getElementById('startDateCreated').value='';
         document.getElementById('endDateCreated').value='';
         document.getElementById('companyName').value='';
           return false;
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message
                code="default.list.label" args="[entityName]"/></h1>
     <g:form>
	<div class="table_serch">
            <table>
                    <tr>
                        <td>${message(code: 'boBranchCompany.companyName.label')}:</td>
                        <td><p><g:textField name="companyName"  value="${params.companyName}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                        %{--<td>${message(code: 'boBranchCompany.companyNo.label')}:</td>--}%
                        %{--<td><p><g:textField name="companyNo"  value="${params.companyNo}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>--}%
                        <td>${message(code: 'boBranchCompany.chargeMan.label')}:</td>
                        <td><p><g:textField name="chargeMan"  value="${params.chargeMan}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'boBranchCompany.phone.label')}:</td>
                        <td><p><g:textField name="phone"  value="${params.phone}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                    <td>${message(code: 'boOpLog.dateCreated.label')}:</td>
                    <td><g:textField name="startDateCreated" id='startDateCreated' readonly="true" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.startDateCreated}" class="right_top_h2_input"/>--<g:textField name="endDateCreated"  id='endDateCreated' readonly="true" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.endDateCreated}" onchange="checkDate()" class="right_top_h2_input"/></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkDate()"/></td>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="" value="清空" onclick="return empty()"/></td>
                        <td><bo:hasPerm perm="${Perm.Security_BranchCompany_Dl}"><g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()"/></bo:hasPerm></td>
                    </tr>
            </table>
        </div>
            <bo:hasPerm perm="${Perm.Security_BranchCompany_New}">
            <div class="button_menu"><g:actionSubmit class="right_top_h2_button_tj" action="create"  value="${message(code: 'default.new.label', args:[entityName])}"/></div>
               </bo:hasPerm>
        </g:form>
        <table align="center" class="right_list_table" id="test">
            
            <tr>
                %{--<g:sortableColumn params="${params}" property="companyNo"--}%
                                  %{--title="${message(code: 'boBranchCompany.companyNo.label', default: 'companyNo')}"/>--}%
                <g:sortableColumn params="${params}" property="id"
                                  title="${message(code: 'boBranchCompany.companyName.label', default: 'companyName')}"/>
                <g:sortableColumn params="${params}" property="id"
                                  title="${message(code: 'boBranchCompany.chargeMan.label', default: 'chargeMan')}"/>
                <g:sortableColumn params="${params}" property="id"
                                  title="${message(code: 'boBranchCompany.phone.label', default: 'phone')}"/>
                <g:sortableColumn params="${params}" property="id"
                                  title="${message(code: 'boBranchCompany.fax.label', default: 'fax')}"/>
                 <g:sortableColumn params="${params}" property="id"
                                  title="${message(code: 'boBranchCompany.address.label', default: 'address')}"/>
                <g:sortableColumn params="${params}" property="dateCreated"
                                  title="${message(code: 'boBranchCompany.dateCreated.label', default: 'Date Created')}"/>

            </tr>


            <g:each in="${boBranchCompanyInstanceList}" status="i" var="boBranchCompanyInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    %{--<td>--}%
                         %{--<g:if test="${bo.hasPerm(perm:Perm.Security_BranchCompany_View){true}}">--}%
                        %{--<g:link action="show" id="${boBranchCompanyInstance.id}">${fieldValue(bean: boBranchCompanyInstance, field: "companyNo")}</g:link>--}%
                          %{--</g:if>--}%
                        %{--<g:else>--}%
                            %{--${fieldValue(bean: boBranchCompanyInstance, field: "companyNo")}--}%
                         %{--</g:else>--}%
                    %{--</td>--}%
                    <td>
                         <g:if test="${bo.hasPerm(perm:Perm.Security_BranchCompany_View){true}}">
                        <g:link action="show" id="${boBranchCompanyInstance.id}" title="查看">${fieldValue(bean: boBranchCompanyInstance, field: "companyName")}</g:link>
                          </g:if>
                        <g:else>
                            ${fieldValue(bean: boBranchCompanyInstance, field: "companyName")}
                         </g:else>
                    </td>

                    <td>${fieldValue(bean: boBranchCompanyInstance, field: "chargeMan")}</td>
                    <td>${fieldValue(bean: boBranchCompanyInstance, field: "phone")}</td>
                    <td>${fieldValue(bean: boBranchCompanyInstance, field: "fax")}</td>
                    <td>${fieldValue(bean: boBranchCompanyInstance, field: "address")}</td>
                    <td><g:formatDate date="${boBranchCompanyInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
	    <span style=" float:left;">共${boBranchCompanyInstanceTotal}条记录</span>
            <g:paginat total="${boBranchCompanyInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
