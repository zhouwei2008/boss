<%@ page import="settle.FtSrvType; boss.Perm" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftCustomerlist_sett.lable', default: 'FtCustomer')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form>
                商户编码：<g:textField name="customerNo" maxlength="24" onblur="value=value.replace(/[ ]/g,'')" value="${params.customerNo}" class="right_top_h2_input"/>
                商户名称：<g:textField name="name" maxlength="64" onblur="value=value.replace(/[ ]/g,'')" value="${params.name}" class="right_top_h2_input"/>
                业务类型：<g:select name="type" value="${params.type}" from="${FtSrvType.findAll()}" optionKey="srvCode" optionValue="srvName" noSelection="${['':'-全部-']}" class="right_top_h2_input"/>
                <g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询"/>
                <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
            </g:form>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <g:sortableColumn params="${params}" property="customerNo" title="${message(code: 'ftCustomerlist.customer_no.label')}"/>
                <g:sortableColumn params="${params}" property="name" title="${message(code: 'default.search.result.name.label')}"/>
                <th>业务类型</th>
                <th>操作</th>
            </tr>
            <g:each in="${ftCustomerList}" status="i" var="customerInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>${customerInstance?.NO}</td>
                    <td>${customerInstance?.NAME}</td>
                    <td>${customerInstance?.SRVNAME}</td>
                    %{--<td><bo:hasPerm perm="${Perm.Settle_Fee_View}" ><input type="button" onclick="window.location.href = '${createLink(controller:'ftTradeFee', action:'list', params:['customerNo':customerInstance?.NO,'customerName':customerInstance?.NAME])}'" value="查看"/></bo:hasPerm></td>--}%
                    <td><bo:hasPerm perm="${Perm.Settle_Fee_View}" ><input type="button" onclick="window.location.href = '${createLink(controller:'ftTradeFee', action:'list', params:['customerNo':customerInstance?.NO,'customerName':customerInstance?.NAME,'srvName':customerInstance?.SRVNAME])}'" value="设置费率"/></bo:hasPerm></td>
                </tr>
            </g:each>
        </table>
        <div class="paginateButtons">
            <div align="left"><div style="position:absolute;">共${ftCustomerTotal}条记录</div></div>
            <g:paginat total="${ftCustomerTotal}" params="${params}"/>
        </div>
    </div>
</div>
<script type="text/javascript">
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