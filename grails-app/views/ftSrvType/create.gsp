<%@ page import="settle.FtSrvType" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftSrvType.label', default: 'FtSrvType')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
    <g:javascript>
        function regExpTest(src,re){
            var result = false;
            if(src==null || src==""){
                return false;
            }

            if(src==re.exec(src)){
                result = true;
            }

            return result;
        }

        function checkAndSubmit(){
            var code = document.getElementById('srvCodeInput').value;
            var name = document.getElementById('srvNameInput').value;
            if($.trim(code)  == ''){
                alert("${message(code:'ftSrvType.invalid.notnull.srvCode.label')}");
                return;
            }else if(!regExpTest(code,/\w+/g)){
                alert("${message(code:'ftSrvType.invalid.notpattern.srvCode.label')}");
                return;
            }else if($.trim(name) == ''){
                alert("${message(code:'ftSrvType.invalid.notnull.srvName.label')}");
                return;
            }else if(!regExpTest(name,/[u4e00-u9fa5]+/)){
                alert("${message(code:'ftSrvType.invalid.notpattern.srvName.label')}");
                return;
            }
            document.getElementById('saveForm').submit();
        }
    </g:javascript>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${ftSrvTypeInstance}">
        <div class="errors">
            <g:renderErrors bean="${ftSrvTypeInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="save" name="saveForm">
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftSrvType.srvCode.label"/>：</td>
                <td class="${hasErrors(bean: ftSrvTypeInstance, field: 'srvCode', 'errors')}"><g:textField id="srvCodeInput" name="srvCode" maxlength="20" value="${ftSrvTypeInstance?.srvCode}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftSrvType.srvName.label"/>：</td>
                <td class="${hasErrors(bean: ftSrvTypeInstance, field: 'srvName', 'errors')}"><g:textField id="srvNameInput" name="srvName" maxlength="30" value="${ftSrvTypeInstance?.srvName}"/></td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                     <input type="hidden" name="fanhui" value="1" id="fanhui">
                   <span class="button"><g:actionSubmit class="rigt_button" action="list" value="返回"/></span>
<!--                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>-->
                    <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定"></span>
                </td>
            </tr>
        </table>
    </g:form>
</div>
</body>
</html>