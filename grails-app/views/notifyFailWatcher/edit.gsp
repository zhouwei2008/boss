<%@ page import="ismp.NotifyFailWatcher" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="通知名单"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
    <g:javascript>
        function validateForm() {
            var name = $('input[name="name"]').val();
            var namePattern = /^[\\`,\\~,\\!,\\@,\#,\\$,\\%,\\^,\\+,\\*,\\&,\\\\,\\/,\\?,\\|,\\:,\\.,\\<,\\>,\\{,\\},\\(,\\),\\'',\\;,\\=,\"]+$/;
            if (namePattern.test(name)) {
                alert("请不要输入特殊字符！");
                return false;
            }
            if (name == null || name == '') {
                alert("请输入通知人名称！");
                return false;
            }

            var mobile = $('input[name="mobile"]').val();
            var mobilePattern = /^\d{11}$/;
            if (!mobilePattern.test(mobile)) {
                alert("请输入11位手机号码！");
                return false;
            }

            var email = $('input[name="email"]').val();
            var emailPattern = /^\w+([-+._]\w+)*@\w+([-._]\w+)*\.\w+([-._]\w+)*$/;
            if (!emailPattern.test(email)) {
                alert("请输入正确邮箱！");
                return false;
            }
        }
    </g:javascript>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${notifyFailWatcherInstance}">
        <div class="errors">
            <g:renderErrors bean="${notifyFailWatcherInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="update">
        <g:hiddenField name="id" value="${notifyFailWatcherInstance?.id}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name">通知人：</td>
                <td class="${hasErrors(bean: notifyFailWatcherInstance, field: 'name', 'errors')}"><g:textField name="name" maxlength="10" value="${notifyFailWatcherInstance?.name}"/></td>
            </tr>

            <tr>
                <td class="right label_name">通知手机：</td>
                <td class="${hasErrors(bean: notifyFailWatcherInstance, field: 'mobile', 'errors')}"><g:textField name="mobile" maxlength="11" value="${notifyFailWatcherInstance?.mobile}"/></td>
            </tr>

            <tr>
                <td class="right label_name">通知邮箱：</td>
                <td class="${hasErrors(bean: notifyFailWatcherInstance, field: 'email', 'errors')}"><g:textField name="email" maxlength="100" value="${notifyFailWatcherInstance?.email}"/></td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="content"><input type="submit" name="button" id="button" onclick="return validateForm();" class="rigt_button" value="确定"></span>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>
