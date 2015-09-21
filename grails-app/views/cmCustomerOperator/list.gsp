<%@ page import="ismp.CmCustomerOperatorController; ismp.CmCustomerOperator" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cmCustomerOperator.label', default: 'CmCustomerOperator')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript">
        function checkStatus(str, flag) {
            if (confirm("确定要改变操作员状态吗！")) {
                if (flag == 1) {
                    window.location.href = '${createLink(controller:'cmCustomerOperator', action:'updateStatus', params:['status':'disabled'])}&id=' + str;
                }
                if (flag == 2) {
                    window.location.href = '${createLink(controller:'cmCustomerOperator',action:'updateStatus', params:['status':'normal'])}&id=' + str;
                }
                if (flag == 3) {
                    window.location.href = '${createLink(controller:'cmCustomerOperator',action:'updateStatus', params:['status':'normal'])}&id=' + str;
                }
            }
        }
    </script>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            %{--<g:form>--}%
                %{--<g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/>--}%
            %{--</g:form>--}%
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="id" title="${message(code: 'cmCustomerOperator.name.label', default: 'Name')}"/>

                <g:sortableColumn params="${params}" property="defaultEmail" title="${message(code: 'cmCustomerOperator.defaultEmail.label', default: 'Default Email')}"/>

                <g:sortableColumn params="${params}" property="defaultMobile" title="${message(code: 'cmCustomerOperator.defaultMobile.label', default: 'Default Mobile')}"/>

                <g:sortableColumn params="${params}" property="roleSet" title="${message(code: 'cmCustomerOperator.roleSet.label', default: 'RoleSet')}"/>

                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'cmCustomerOperator.dateCreated.label', default: 'DateCreated')}"/>

                <g:sortableColumn params="${params}" property="status" title="${message(code: 'cmCustomerOperator.status.label', default: 'Status')}"/>

                <g:sortableColumn params="${params}" property="status" title="操作"/>

            </tr>

            <g:each in="${cmCustomerOperatorInstanceList}" status="i" var="cmCustomerOperatorInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td>${fieldValue(bean: cmCustomerOperatorInstance, field: "name")}</td>

                    <td>${fieldValue(bean: cmCustomerOperatorInstance, field: "defaultEmail")}</td>

                    <td>${fieldValue(bean: cmCustomerOperatorInstance, field: "defaultMobile")}</td>

                    <td>${CmCustomerOperator.roleSetMap[cmCustomerOperatorInstance?.roleSet]}</td>

                    <td><g:formatDate date="${cmCustomerOperatorInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>

                    <td>${CmCustomerOperator.statusMap[cmCustomerOperatorInstance?.status]}</td>
                    <td>
                        <g:if test="${cmCustomerOperatorInstance?.status=='normal'}">
                            <input type="button" onclick=" return checkStatus(${cmCustomerOperatorInstance?.id}, 1);" value="停用"/>
                        </g:if>
                        <g:if test="${cmCustomerOperatorInstance?.status=='disabled'}">
                            <input type="button" onclick=" return checkStatus(${cmCustomerOperatorInstance?.id}, 2);" value="启用"/>
                        </g:if>
                        <g:if test="${cmCustomerOperatorInstance?.status=='locked'}">
                            <input type="button" onclick=" return checkStatus(${cmCustomerOperatorInstance?.id}, 3);" value="解锁"/>
                        </g:if>
                        <input type="button" onclick=" window.location.href = '${createLink(action:'edit', params:['id':cmCustomerOperatorInstance?.id])}'" value="修改"/>
                        <g:if test="${status=='init'}">
                            <input type="button" onclick=" window.location.href = '${createLink(action:'sendEmail', params:['id':cmCustomerOperatorInstance?.id])}'" value="重新验证"/>
                        </g:if>
                    </td>
                </tr>
            </g:each>

        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${cmCustomerOperatorInstanceTotal}条记录</span>
            <g:paginat total="${cmCustomerOperatorInstanceTotal}" params="${params}"/>
        </div>

        <div class="paginateButtons">
              <span class="button"><input type="button" class="rigt_button" onclick="history.go(-1)" value="返回"/></span>
        </div>
    </div>
</div>
</body>
</html>
