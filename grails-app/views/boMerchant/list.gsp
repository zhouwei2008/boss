<%@ page import="boss.Perm; boss.BoMerchant" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boMerchant.label', default: 'BoMerchant')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">${acquirerAccount?.bankAccountName} <g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <bo:hasPerm perm="${Perm.Bank_Issu_Merc_New}"><g:form><g:hiddenField name="acquirerAccount.id" value="${acquirerAccount?.id}"/><g:actionSubmit class="right_top_h2_button_tj1" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/></g:form></bo:hasPerm>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="acquireIndexc" title="${message(code: 'boMerchant.acquireIndexc.label', default: 'Acquire Indexc')}"/>

                <g:sortableColumn params="${params}" property="acquireMerchant" title="${message(code: 'boMerchant.acquireMerchant.label', default: 'Acquire Merchant')}"/>

                <g:sortableColumn params="${params}" property="terminal" title="${message(code: 'boMerchant.terminal.label', default: 'Terminal')}"/>

                <g:sortableColumn params="${params}" property="acquireName" title="${message(code: 'boMerchant.acquireName.label', default: 'Acquire Name')}"/>

                <g:sortableColumn params="${params}" property="serviceCode" title="${message(code: 'boMerchant.serviceCode.label', default: 'Service Code')}"/>

                <g:sortableColumn params="${params}" property="channelType" title="${message(code: 'boMerchant.channelType.label')}"/>

                <g:sortableColumn params="${params}" property="bankType" title="${message(code: 'boMerchant.bankType.label')}"/>

                <g:sortableColumn params="${params}" property="channelSts" title="${message(code: 'boMerchant.channelSts.label')}"/>

                <th>操作</th>

            </tr>

            <g:each in="${boMerchantInstanceList}" status="i" var="boMerchantInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td>${fieldValue(bean: boMerchantInstance, field: "acquireIndexc")}</td>

                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.Bank_Issu_Merc_View){true}}"><g:link action="show" id="${boMerchantInstance.id}">${fieldValue(bean: boMerchantInstance, field: "acquireMerchant")}</g:link></g:if>
                        <g:else>${fieldValue(bean: boMerchantInstance, field: "acquireMerchant")}</g:else>
                    </td>

                    <td>${fieldValue(bean: boMerchantInstance, field: "terminal")}</td>

                    <td>${fieldValue(bean: boMerchantInstance, field: "acquireName")}</td>

                    <td>${fieldValue(bean: boMerchantInstance, field: "serviceCode")}</td>

                    <td>${BoMerchant.channelTypeMap[boMerchantInstance?.channelType]}</td>

                    <td>${BoMerchant.bankTypeMap[boMerchantInstance?.bankType]}</td>

                    <td>${BoMerchant.statusMap[boMerchantInstance?.channelSts]}</td>
                    <g:if test="${boMerchantInstance?.channelSts == '0'}">
                        <g:if test="${bo.hasPerm(perm:Perm.Bank_Issu_Merc_Channel_View){true}}">
                            <td><bo:hasPerm perm="${Perm.Bank_Issu_Merc_Channel_View}" ><input type="button" onclick="window.location.href = '${createLink(controller:'boChannelRate', action:'list', params:['merchantId':boMerchantInstance?.id])}';" value="手续费设置"/></bo:hasPerm></td>
                        </g:if>
                        <g:else><td></td></g:else>
                    </g:if>
                    <g:else><td></td></g:else>
                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${boMerchantInstanceTotal}条记录</span>
            <g:paginat total="${boMerchantInstanceTotal}" params="${params}"/>
        </div>
        <div class="paginateButtons">
            <span class="button"><input type="button" class="rigt_button" onclick="javascript:history.go(-1)" value="返回"/></span>
        </div>
    </div>
</div>
</body>
</html>
