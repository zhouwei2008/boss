<%@ page import="boss.BoBranchCompany" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boBranchCompany.label', default: 'BoBranchCompany')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
        <style type="text/css">
   .required  {
       padding-left: 1px;
       color: #ff0000;
}
    </style>
</head>

<body style="overflow-x:hidden">
<script type="text/javascript">
    function checkTest() {
//        var reg = ~/^[-_A-Za-z0-9]+@([_A-Za-z0-9]+.)+[A-Za-z0-9]{2,3}$/
//        if (document.getElementById("companyNo").value.replace(/[ ]/g, "").length == 0) {
//            alert("分公司编号不能为空，请填写！");
//            document.getElementById("companyNo").focus();
//            return false;
//        }

        var  companyName= document.getElementById("companyName").value.replace(/[ ]/g, "")
        document.getElementById("companyName").value= companyName
        var  phone= document.getElementById("phone").value.replace(/[ ]/g, "")
        document.getElementById("phone").value= phone
        var  fax= document.getElementById("fax").value.replace(/[ ]/g, "")
        document.getElementById("fax").value= fax
        var  chargeMan= document.getElementById("chargeMan").value.replace(/[ ]/g, "")
        document.getElementById("chargeMan").value= chargeMan
        var  address= document.getElementById("address").value.replace(/[ ]/g, "")
        document.getElementById("address").value= address
        if (companyName.length == 0) {
            alert("分公司名称不能为空，请填写！");
            document.getElementById("companyName").focus();
            return false;
        }
        if (companyName.length !=0) {
            if(!(/^[^\|"'<>]*$/.test(companyName))){
                alert("分公司名称中不能含有\n\n 1 单引号: ' \n 2 双引号: \" \n 3 竖杠: | \n 4 尖角号: < > \n\n请检查输入！");
                return false;
            }
        }
        if (companyName.length > 100) {
            alert("分公司名称最多只能输入100个字符！");
            document.getElementById("companyName").focus();
            return false;
        }
        if (chargeMan.length !=0) {
           if(!(/^[^\|"'<>]*$/.test(chargeMan))){
                alert("负责人中不能含有\n\n 1 单引号: ' \n 2 双引号: \" \n 3 竖杠: | \n 4 尖角号: < > \n\n请检查输入！");
                return false;
            }
        }


        if (chargeMan.length > 100) {
            alert("负责人最多只能输入100个字符！");
            document.getElementById("chargeMan").focus();
            return false;
        }
        if (phone.length != 0) {
            if (!(/^(((\+86)|(86)|(\+86-)|(86-))?((\d{5,11})|((\d{2,4})-(\d{5,8}))|(((\+86)|(\d{2,4}))-(\d{2,8})-(\d{1,8}))|((\d{2,8})-(\d{1,4}))))$/.test(phone))) {
                alert("电话号码格式不正确，请重新填写！");
                document.getElementById("phone").focus();
                return false;
            }

        }
        if (fax.length!= 0) {
             if (!(/^(((\+86)|(86)|(\+86-)|(86-))?((\d{5,11})|((\d{2,4})-(\d{5,8}))|(((\+86)|(\d{2,4}))-(\d{2,8})-(\d{1,8}))|((\d{2,8})-(\d{1,4}))))$/.test(fax))) {
                alert("传真格式不正确，请重新填写！");
                document.getElementById("fax").focus();
                return false;
            }
        }
        if (phone.length > 100) {
            alert("联系电话最多只能输入100个字符！");
            document.getElementById("phone").focus();
            return false;
        }
        if (fax.length > 100) {
            alert("传真最多只能输入100个字符！");
            document.getElementById("fax").focus();
            return false;
        }
        if (address.length !=0) {
           if(!(/^[^\|"'<>]*$/.test(address))){
                alert("地址中不能含有\n\n 1 单引号: ' \n 2 双引号: \" \n 3 竖杠: | \n 4 尖角号: < > \n\n请检查输入！");
                return false;
            }
        }
        if (address.length > 100) {
            alert("地址最多只能输入100个字符！");
            document.getElementById("address").focus();
            return false;
        }


    }
    function checkAllTextValid(value){
       if(!(/^[^\|"'<>]*$/.test(value))){
           alert("文本框中不能含有\n\n 1 单引号: ' \n 2 双引号: \" \n 3 竖杠: | \n 4 尖角号: < > \n\n请检查输入！");
           return false;
      }
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${boBranchCompanyInstance}">
        <div class="errors">
            <g:renderErrors bean="${boBranchCompanyInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="save">
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
            </tr>
            %{--<tr>--}%
                %{--<td class="right label_name"><g:message code="boBranchCompany.companyNo.label"/>：</td>--}%
                %{--<td class="${hasErrors(bean: boBranchCompanyInstance, field: 'companyNo', 'errors')}"><g:textField name="companyNo" maxlength="100"/></td>--}%
            %{--</tr>--}%
            <tr>
                <td class="right label_name"><g:message code="boBranchCompany.companyName.label"/>：<span class="required">*</span></td>
                <td class="${hasErrors(bean: boBranchCompanyInstance, field: 'companyName', 'errors')}"><g:textField name="companyName" maxlength="100"/>最多输入100个字符</td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="boBranchCompany.chargeMan.label"/>：</td>
                <td class="${hasErrors(bean: boBranchCompanyInstance, field: 'chargeMan', 'errors')}"><g:textField name="chargeMan" maxlength="100"/>最多输入100个字符</td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="boBranchCompany.phone.label"/>：</td>
                <td class="${hasErrors(bean: boBranchCompanyInstance, field: 'phone', 'errors')}"><g:textField name="phone" maxlength="100"/>最多输入100个字符</td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="boBranchCompany.fax.label"/>：</td>
                <td class="${hasErrors(bean: boBranchCompanyInstance, field: 'fax', 'errors')}"><g:textField name="fax" maxlength="100"/>最多输入100个字符</td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="boBranchCompany.address.label"/>：</td>
                <td class="${hasErrors(bean: boBranchCompanyInstance, field: 'address', 'errors')}"><g:textField name="address" maxlength="100"/>最多输入100个字符</td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定" onclick="return checkTest()" />
                    </span>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>
