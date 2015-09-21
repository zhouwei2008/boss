<%@ page import="boss.BoMerchant; settle.FtFeeChannel" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftFeeChannel.label', default: 'FtFeeChannel')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<g:javascript>
    function updateCode() {
        document.getElementById('sign').value='1';
    }
</g:javascript>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${ftFeeChannelInstance}">
        <div class="errors">
            <g:renderErrors bean="${ftFeeChannelInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="update">
        <g:hiddenField name="id" value="${ftFeeChannelInstance?.id}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
                <g:hiddenField name="type" value="${ftFeeChannelInstance?.type}"></g:hiddenField>
                <g:hiddenField name="ftSrvTypeId" value="${ftFeeChannelInstance?.ftSrvTypeId}"></g:hiddenField>
                <g:hiddenField name="sign" id="sign" value="0"></g:hiddenField>
            </tr>

             <tr>
                <td class="right label_name"><g:message code="ftFeeChannel.code.label"/>：</td>
                <td class="${hasErrors(bean: ftFeeChannelInstance, field: 'code', 'errors')}"><g:textField name="code" maxlength="20" value="${ftFeeChannelInstance?.code}" onchange="updateCode()"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftFeeChannel.name.label"/>：</td>
                <td class="${hasErrors(bean: ftFeeChannelInstance, field: 'name', 'errors')}"><g:textField name="name" maxlength="30" value="${ftFeeChannelInstance?.name}"/></td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定"></span>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>
