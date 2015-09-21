<%@ page import="ismp.TbCustomerBlackList; boss.Perm;ismp.TbPersonBlackList;" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbCustomerBlackList.label', default: '企业客户黑名单')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>

    <table align="center" class="rigt_tebl">
        <tr>
            <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
        </tr>

        <tr>
            <td class="right label_name">别称：</td>
            <td><span class="rigt_tebl_font">${tbCustomerBlackListInstance.nickname}</span></td>
        </tr>

        <tr>
            <td class="right label_name">客户名称：</td>
            <td><span class="rigt_tebl_font">${tbCustomerBlackListInstance.name}</span></td>
        </tr>

        <tr>
            <td class="right label_name">营业执照代码：</td>
            <td><span class="rigt_tebl_font">${tbCustomerBlackListInstance.businessLicenseCode}</span></td>
        </tr>

        <tr>
            <td class="right label_name">营业执照有效期：</td>
            <td><span class="rigt_tebl_font"><g:formatDate date="${tbCustomerBlackListInstance.businessValidity}" format="yyyy-MM-dd"/></span></td>
        </tr>

        <tr>
            <td class="right label_name">组织机构代码：</td>
            <td><span class="rigt_tebl_font">${tbCustomerBlackListInstance.organizationCode}</span></td>
        </tr>

        <tr>
            <td class="right label_name">客户地址：</td>
            <td><span class="rigt_tebl_font">${tbCustomerBlackListInstance.address}</span></td>
        </tr>

        <tr>
            <td class="right label_name">经营范围：</td>
            <td><span class="rigt_tebl_font">${tbCustomerBlackListInstance.businessScope}</span></td>
        </tr>

        <tr>
            <td class="right label_name">法定代表人：</td>
            <td><span class="rigt_tebl_font">${tbCustomerBlackListInstance.legalPerson}</span></td>
        </tr>

        <tr>
            <td class="right label_name">证件类型：</td>
            <td><span class="rigt_tebl_font">${TbCustomerBlackList.identityTypeMap[tbCustomerBlackListInstance.identityType]}</span></td>
        </tr>

        <tr>
            <td class="right label_name">证件号码：</td>
            <td><span class="rigt_tebl_font">${tbCustomerBlackListInstance.identityNo}</span></td>
        </tr>

        <tr>
            <td class="right label_name">证件有效期：</td>
            <td><span class="rigt_tebl_font"><g:formatDate date="${tbCustomerBlackListInstance.identityValidity}" format="yyyy-MM-dd"/></span></td>
        </tr>

        <tr>
            <td class="right label_name">来源：</td>
            <td><span class="rigt_tebl_font">${TbCustomerBlackList.sourceMap[tbCustomerBlackListInstance.source]}</span></td>
        </tr>

        <tr>
            <td class="right label_name">创建时间：</td>
            <td><span class="rigt_tebl_font"><g:formatDate date="${tbCustomerBlackListInstance.createDate}" format="yyyy-MM-dd"/></span></td>
        </tr>


        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${tbCustomerBlackListInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>

                        <span class="button">
                           <bo:hasPerm perm="${Perm.RiskManager_BlackList_EditCust}">
                                <g:actionSubmit class="rigt_button" action="editCust" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/>
                           </bo:hasPerm>
                        </span>
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>