<%@ page import="ismp.AcquireSynTrx" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'acquireAccountTrade.remarks.label', default: 'remarks')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
    <style type="text/css">
   .required  {
       padding-left: 1px;
       color: #ff0000;
}
    </style>
</head>

<body style="overflow-x:hidden">
<script type="text/javascript">

</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${acquireSynTrxInstance}">
        <div class="errors">
            <g:renderErrors bean="${acquireSynTrxInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="updateRemarks">
        <g:hiddenField name="id" value="${acquireSynTrxInstance?.id}"/>
        <g:hiddenField name="synSts"  value="${params.synSts}" />
        <g:hiddenField name="batchnum"  value="${params.batchnum}" />
        <g:hiddenField name="offset"  value="${params.offset}" />
        <g:hiddenField name="max"  value="${params.max}" />
        <g:hiddenField name="fbankCode"  value="${params.fbankCode}" />
        <g:hiddenField name="foffset"  value="${params.foffset}" />
        <g:hiddenField name="fmax"  value="${params.fmax}" />
        <g:hiddenField name="fbeginTime"  value="${params.fbeginTime}" />
        <g:hiddenField name="fendTime"  value="${params.fendTime}" />
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="acquireAccountTrade.remarks.label"/>：</td>
                <td class="${hasErrors(bean: acquireSynTrxInstance, field: 'remarks', 'errors')}">
                    <g:textArea name="remarks" rows="3" cols="5">${acquireSynTrxInstance?.remarks}</g:textArea>
                </td>
            </tr>
           <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定" />
                    </span>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>
