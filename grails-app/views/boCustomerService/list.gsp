<%@ page import="ismp.CmCustomer; boss.Perm; ismp.CmCorporationInfo; boss.BoCustomerService" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boCustomerService.label', default: 'BoCustomerService')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">${customer?.name} <g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form>
                <g:hiddenField name="customerId" value="${customer?.id}"/>
                <g:if test="${customer instanceof CmCorporationInfo}">
                    <bo:hasPerm perm="${Perm.Cust_Corp_Srv_New}"><g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/></bo:hasPerm>
                </g:if>
                <g:else>
                    <bo:hasPerm perm="${Perm.Cust_Per_Srv_New}"><g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/></bo:hasPerm>
                </g:else>
            </g:form>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <g:sortableColumn params="${params}" property="contractNo" title="${message(code: 'boCustomerService.contractNo.label', default: 'Contract No')}"/>
                <g:sortableColumn params="${params}" property="serviceCode" title="${message(code: 'boCustomerService.serviceCode.label', default: 'Service Code')}"/>
                <g:sortableColumn params="${params}" property="startTime" title="${message(code: 'boCustomerService.startTime.label', default: 'Start Time')}"/>
                <g:sortableColumn params="${params}" property="endTime" title="${message(code: 'boCustomerService.endTime.label', default: 'End Time')}"/>
                <g:sortableColumn params="${params}" property="belongToSale" title="${message(code: 'boCustomerService.belongToSale.label', default: 'Belong To Sale')}"/>
                <g:sortableColumn params="${params}" property="isCurrent" title="${message(code: 'boCustomerService.isCurrent.label', default: 'isCurrent')}"/>
                <g:sortableColumn params="${params}" property="enable" title="${message(code: 'boCustomerService.enable.label', default: 'enable')}"/>
                <th>操作</th>
            </tr>

            <g:each in="${boCustomerServiceInstanceList}" status="i" var="boCustomerServiceInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>
                        <g:if test="${customer instanceof CmCorporationInfo}">
                            <g:if test="${bo.hasPerm(perm:Perm.Cust_Corp_Srv_View){true}}"><g:link action="show" id="${boCustomerServiceInstance.id}">${fieldValue(bean: boCustomerServiceInstance, field: "contractNo")}</g:link></g:if><g:else>${fieldValue(bean: boCustomerServiceInstance, field: "contractNo")}</g:else>
                        </g:if>
                        <g:else>
                            <g:if test="${bo.hasPerm(perm:Perm.Cust_Per_Srv_View){true}}"><g:link action="show" id="${boCustomerServiceInstance.id}">${fieldValue(bean: boCustomerServiceInstance, field: "contractNo")}</g:link></g:if><g:else>${fieldValue(bean: boCustomerServiceInstance, field: "contractNo")}</g:else>
                        </g:else>
                    </td>
                    <td>${BoCustomerService.serviceMap[boCustomerServiceInstance?.serviceCode]}</td>
                    <td><g:formatDate date="${boCustomerServiceInstance.startTime}" format="yyyy-MM-dd"/></td>
                    <td><g:formatDate date="${boCustomerServiceInstance.endTime}" format="yyyy-MM-dd"/></td>
                    <td>${boCustomerServiceInstance?.belongToSale}</td>
                    <td><g:formatBoolean boolean="${boCustomerServiceInstance?.isCurrent}"/></td>
                    <td><g:formatBoolean boolean="${boCustomerServiceInstance?.enable}"/></td>
                    <td>
                        <g:if test="${customer instanceof CmCorporationInfo}">
                            <g:if test="${boCustomerServiceInstance.serviceCode=='online'}">
                                <bo:hasPerm perm="${Perm.Cust_Corp_Srv_BankSet}"><input type="button" onclick="window.location.href = '${createLink(controller:'boCustomerService', action:'channelList', params:['id':boCustomerServiceInstance?.id])}';" value="设置支付通道"/></bo:hasPerm>
                            %{--<bo:hasPerm perm="${Perm.Cust_Corp_Srv_RfdSet}" ><input type="button" onclick="window.location.href = '${createLink(controller:'boRefundModel', action:'list', params:['customerId':boCustomerServiceInstance?.id])}';" value="设置退款模式"/></bo:hasPerm>--}%
                            %{--<bo:hasPerm perm="${Perm.Cust_Corp_Srv_PaySet}" ><input type="button" onclick="window.location.href = '${createLink(controller:'boRefundModel', action:'payList', params:['customerId':boCustomerServiceInstance?.id])}';" value="设置支付模式"/></bo:hasPerm>--}%
                                <bo:hasPerm perm="${Perm.Cust_Corp_Srv_SerSet}"><input type="button" onclick="window.location.href = '${createLink(controller:'boRefundModel', action:'list', params:['customerId':boCustomerServiceInstance?.id])}';" value="设置服务模式"/></bo:hasPerm>
                            </g:if>
                            <g:if test="${boCustomerServiceInstance.serviceCode=='agentpay'}">
                                <bo:hasPerm perm="${Perm.Cust_Corp_Srv_ParamSet}"><input type="button" onclick="window.location.href = '${createLink(controller:'boAgentPayServiceParams', action:'create', params:['id':boCustomerServiceInstance?.id,'customerId':customer?.id])}';" value="服务参数管理"/></bo:hasPerm>
                            </g:if>
                            <g:if test="${boCustomerServiceInstance.serviceCode=='agentcoll'}">
                                <bo:hasPerm perm="${Perm.Cust_Corp_Srv_ParamSet}"><input type="button" onclick="window.location.href = '${createLink(controller:'boAgentPayServiceParams', action:'create', params:['id':boCustomerServiceInstance?.id,'customerId':customer?.id])}';" value="服务参数管理"/></bo:hasPerm>
                            </g:if>
                        </g:if>
                        <g:else>
                            <g:if test="${boCustomerServiceInstance.serviceCode=='online'}">
                                <bo:hasPerm perm="${Perm.Cust_Per_Srv_BankSet}"><input type="button" onclick="window.location.href = '${createLink(controller:'boCustomerService', action:'channelList', params:['id':boCustomerServiceInstance?.id])}';" value="设置支付通道"/></bo:hasPerm>
                            %{--<bo:hasPerm perm="${Perm.Cust_Per_Srv_RfdSet}" ><input type="button" onclick="window.location.href = '${createLink(controller:'boRefundModel', action:'list', params:['customerId':boCustomerServiceInstance?.id])}';" value="设置退款模式"/></bo:hasPerm>--}%
                            %{--<bo:hasPerm perm="${Perm.Cust_Per_Srv_PaySet}" ><input type="button" onclick="window.location.href = '${createLink(controller:'boRefundModel', action:'payList', params:['customerId':boCustomerServiceInstance?.id])}';" value="设置支付模式"/></bo:hasPerm>--}%
                                <bo:hasPerm perm="${Perm.Cust_Corp_Srv_SerSet}"><input type="button" onclick="window.location.href = '${createLink(controller:'boRefundModel', action:'list', params:['customerId':boCustomerServiceInstance?.id])}';" value="设置服务模式"/></bo:hasPerm>
                            </g:if>
                            <g:if test="${boCustomerServiceInstance.serviceCode=='agentpay'}">
                                <bo:hasPerm perm="${Perm.Cust_Per_Srv_ParamSet}"><input type="button" onclick="window.location.href = '${createLink(controller:'boAgentPayServiceParams', action:'create', params:['id':boCustomerServiceInstance?.id,'customerId':customer?.id])}';" value="服务参数管理"/></bo:hasPerm>
                            </g:if>
                            <g:if test="${boCustomerServiceInstance.serviceCode=='agentcoll'}">
                                <bo:hasPerm perm="${Perm.Cust_Per_Srv_ParamSet}"><input type="button" onclick="window.location.href = '${createLink(controller:'boAgentPayServiceParams', action:'create', params:['id':boCustomerServiceInstance?.id,'customerId':customer?.id])}';" value="服务参数管理"/></bo:hasPerm>
                            </g:if>
                        </g:else>
                    </td>
                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${boCustomerServiceInstanceTotal}条记录</span>
            <g:paginat total="${boCustomerServiceInstanceTotal}" params="${params}"/>
        </div>
        <div class="paginateButtons">
        <span class="button">
            <g:if test="${customer instanceof CmCorporationInfo}">
            %{--<input type="button" class="rigt_button" onclick="window.location.href = '${createLink(controller:'cmCorporationInfo')}'" value="返回"/></span>--}%
                <input type="button" class="rigt_button" onclick="history.go(-1)" value="返回"/></span>
            </g:if>
            <g:else>
            %{--<input type="button" class="rigt_button" onclick="window.location.href = '${createLink(controller:'cmPersonalInfo')}'" value="返回"/></span>--}%
                <input type="button" class="rigt_button" onclick="history.go(-1)" value="返回"/></span>
            </g:else>
        </div>
    </div>
</div>
</body>
</html>
