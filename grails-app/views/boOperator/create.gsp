<%@ page import="boss.BossRole; boss.BoRole; boss.BoOperator; boss.BoBranchCompany" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boOperator.label', default: 'BoOperator')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<script type="text/javascript">
    function checkTest() {
//        var reg = ~/^[-_A-Za-z0-9]+@([_A-Za-z0-9]+.)+[A-Za-z0-9]{2,3}$/
        if (document.getElementById("account").value.replace(/[ ]/g, "").length == 0) {
            alert("登陆用户名不能为空，请填写登陆用户名！");
            document.getElementById("account").focus();
            return false;
        }
        if (document.getElementById("name").value.replace(/[ ]/g, "").length == 0) {
            alert("姓名不能为空，请填写姓名！");
            document.getElementById("name").focus();
            return false;
        }
        if (document.getElementById("mobile").value.replace(/[ ]/g, "").length == 0) {
            alert("手机不能为空，请填写手机号！");
            document.getElementById("mobile").focus();
            return false;
        } else if (!(/^1[3|4|5|8][0-9]\d{4,8}$/.test(document.getElementById("mobile").value))) {
            alert("不是完整的11位手机号或者正确的手机号前七位");
            document.getElementById("mobile").focus();
            return false;
        }
        if (document.getElementById("email").value.replace(/[ ]/g, "").length == 0) {
            alert("邮箱不能为空，请填写邮箱！");
            document.getElementById("email").focus();
            return false;
        } else if (!(/^[-_A-Za-z0-9]+@([_A-Za-z0-9]+.)+[A-Za-z0-9]{2,3}$/.test(document.getElementById("email").value))) {
            alert("邮箱格式不正确，请重新填写邮箱！");
            document.getElementById("email").focus();
            return false;
        }
        if (document.getElementById("password").value.replace(/[ ]/g, "").length == 0) {
            alert("密码不能为空，请填写密码！");
            document.getElementById("password").focus();
            return false;
        }
        else {
            return true;
        }
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <g:hasErrors bean="${boOperatorInstance}">
        <div class="errors">
            <g:renderErrors bean="${boOperatorInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="save" onsubmit="return checkTest()">
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boOperator.account.label"/>：</td>
                <td class="${hasErrors(bean: boOperatorInstance, field: 'account', 'errors')}"><g:textField name="account" onblur="value=value.replace(/[ ]/g,'')" maxlength="20" value="${boOperatorInstance?.account}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boOperator.name.label"/>：</td>
                <td class="${hasErrors(bean: boOperatorInstance, field: 'name', 'errors')}"><g:textField name="name" maxlength="30" onblur="value=value.replace(/[ ]/g,'')" value="${boOperatorInstance?.name}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boOperator.email.label"/>：</td>
                <td class="${hasErrors(bean: boOperatorInstance, field: 'email', 'errors')}"><g:textField name="email" onblur="value=value.replace(/[ ]/g,'')"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boOperator.mobile.label"/>：</td>
                <td class="${hasErrors(bean: boOperatorInstance, field: 'mobile', 'errors')}"><g:textField name="mobile" onblur="value=value.replace(/[ ]/g,'')"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boOperator.password.label"/>：</td>
                <td class="${hasErrors(bean: boOperatorInstance, field: 'password', 'errors')}"><g:passwordField name="password" onblur="value=value.replace(/[ ]/g,'')"/>
                    <label>密码长度必须大于8位，且必须是数字、字母和特殊字符组合而成</label>
                </td>

            </tr>

            %{--<tr>--}%
                %{--<td class="right label_name"><g:message code="boOperator.roleSet.label"/>：</td>--}%
                %{--<td class="${hasErrors(bean: boOperatorInstance, field: 'roleSet', 'errors')}"><g:select from="${BoRole.list()}" optionKey="roleCode" optionValue="roleName" name="roleSet" value="${boOperatorInstance?.roleSet}"/></td>--}%
            %{--</tr>--}%

            <tr>
                <td class="right label_name"><g:message code="boOperator.role.label"/>：</td>
                <td class="${hasErrors(bean: boOperatorInstance, field: 'role', 'errors')}"><g:select from="${BossRole.list()}"  style="width:170px" optionKey="id" optionValue="roleName" name="role.id"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boOperator.branchCompany.label"/>：</td>
                <td class="${hasErrors(bean: boOperatorInstance, field: 'branchCompany', 'errors')}">
		<g:select name="branchCompany" from="${BoBranchCompany.list()}"  style="width:170px" optionKey="id" optionValue="companyName" noSelection="${['':'-请选择-']}"/>
		</td>
            </tr>

         %{--<tr>--}%
                %{--<td class="right label_name"><g:message code="boOperator.belongToSale.label"/>：</td>--}%
                %{--<td class="${hasErrors(bean: boOperatorInstance, field: 'belongToSale', 'errors')}">--}%
		%{--<g:select name="belongToSale" from="${sales}"  style="width:170px"  noSelection="${['':'-请选择-']}" />--}%
		%{--</td>--}%
            %{--</tr>--}%

            <tr>
                <td class="right label_name"><g:message code="boOperator.status.label"/>：</td>
                <td class="${hasErrors(bean: boOperatorInstance, field: 'status', 'errors')}">
                    <g:select name="status" from="${BoOperator.statusMap}" optionKey="key" optionValue="value" value="${boOperatorInstance?.status}"/>
                </td>
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
