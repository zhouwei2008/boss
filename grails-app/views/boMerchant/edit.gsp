<%@ page import="boss.BoMerchant" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boMerchant.label', default: 'BoMerchant')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <g:hasErrors bean="${boMerchantInstance}">
        <div class="errors">
            <g:renderErrors bean="${boMerchantInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="update" name="update">
        <g:hiddenField name="id" value="${boMerchantInstance?.id}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boMerchant.acquireIndexc.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: boMerchantInstance, field: 'acquireIndexc', 'errors')}"><g:textField name="acquireIndexc" maxlength="20" value="${boMerchantInstance?.acquireIndexc}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boMerchant.acquireMerchant.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: boMerchantInstance, field: 'acquireMerchant', 'errors')}"><g:textField name="acquireMerchant" maxlength="64" value="${boMerchantInstance?.acquireMerchant}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boMerchant.terminal.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: boMerchantInstance, field: 'terminal', 'errors')}"><g:textField name="terminal" maxlength="10" value="${boMerchantInstance?.terminal}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boMerchant.acquireName.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: boMerchantInstance, field: 'acquireName', 'errors')}"><g:textField name="acquireName" maxlength="20" value="${boMerchantInstance?.acquireName}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boMerchant.serviceCode.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: boMerchantInstance, field: 'serviceCode', 'errors')}"><g:textField name="serviceCode" maxlength="10" value="${boMerchantInstance?.serviceCode}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boMerchant.channelType.label"/>：</td>
                <td class="${hasErrors(bean: boMerchantInstance, field: 'channelType', 'errors')}">
                    <g:select name='channelType' from="${BoMerchant.channelTypeMap}" optionKey="key" optionValue="value" value="${boMerchantInstance?.channelType}"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boMerchant.bankType.label"/>：</td>
                <td class="${hasErrors(bean: boMerchantInstance, field: 'bankType', 'errors')}">
                    <g:select name='bankType' from="${BoMerchant.bankTypeMap}" optionKey="key" optionValue="value" value="${boMerchantInstance?.bankType}"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boMerchant.paymentType.label"/>：</td>
                <td class="${hasErrors(bean: boMerchantInstance, field: 'paymentTypeMap', 'errors')}">
                    <g:select name='paymentType' from="${BoMerchant.paymentTypeMap}" optionKey="key" optionValue="value" value="${boMerchantInstance?.paymentType}"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boMerchant.paymentMode.label"/>：</td>
                <td class="${hasErrors(bean: boMerchantInstance, field: 'paymentMode', 'errors')}">
                    <g:select name='paymentMode' from="${BoMerchant.paymentModeMap}" optionKey="key" optionValue="value" value="${boMerchantInstance?.paymentMode}"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boMerchant.channelSts.label"/>：</td>
                <td class="${hasErrors(bean: boMerchantInstance, field: 'channelSts', 'errors')}">
                    <g:select name='channelSts' from="${BoMerchant.statusMap}" optionKey="key" optionValue="value" value="${boMerchantInstance?.channelSts}"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boMerchant.channelDesc.label"/>：</td>
                <td class="${hasErrors(bean: boMerchantInstance, field: 'channelDesc', 'errors')}"><g:textField name="channelDesc" maxlength="128" value="${boMerchantInstance?.channelDesc}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boMerchant.dayQutor.label"/>（元）<font color="red">*</font>：</td>
                <g:if test="${boMerchantInstance?.dayQutor!=null}">
                    <td class="${hasErrors(bean: boMerchantInstance, field: 'dayQutor', 'errors')}"><g:textField name="dayQutor" maxlength="10" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${dQutor}"/></td>
                </g:if>
                <g:else><td></td></g:else>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boMerchant.qutor.label"/>（元）<font color="red">*</font>：</td>
                 <g:if test="${boMerchantInstance?.qutor!=null}">
                     <td class="${hasErrors(bean: boMerchantInstance, field: 'qutor', 'errors')}"><g:textField name="qutor" maxlength="10" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${qutor}"/></td>
                 </g:if>
                <g:else><td></td></g:else>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="content"><input type="button" name="button" onclick="onSubmit();" id="button" class="rigt_button" value="确定"></span>
                </td>
            </tr>
        </table>

    </g:form>
</div>
<script type="text/javascript">
    function onSubmit(){
        var dayQutor = $("#dayQutor").val() - 0;
        var qutor = $("#qutor").val() - 0;
        if(qutor>dayQutor){
            alert("单笔限额不能大于每日限额！");
            return false;
        }
        $("#update").submit();
    }
</script>
</body>
</html>
