<%@ page import="boss.Perm;ismp.TbPersonBlackList;" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbPersonBlackList.label', default: '个人客户黑名单')}"/>
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
            <td class="right label_name">姓名：</td>
            <td><span class="rigt_tebl_font">${tbPersonBlackListInstance.name}</span></td>
        </tr>

        <tr>
            <td class="right label_name">国籍：</td>
            <td><span class="rigt_tebl_font">${TbPersonBlackList.nationalityMap[tbPersonBlackListInstance.nationality]}</span></td>
        <tr>
            <td class="right label_name">性别：</td>
            <td><span class="rigt_tebl_font">${TbPersonBlackList.genderMap[tbPersonBlackListInstance.gender]}</span></td>
        </tr>

        <tr>
            <td class="right label_name">职业：</td>
            <td><span class="rigt_tebl_font">${TbPersonBlackList.occupationMap[tbPersonBlackListInstance.occupation]}</span></td>
        </tr>

        <tr>
            <td class="right label_name">住址：</td>
            <td><span class="rigt_tebl_font">${tbPersonBlackListInstance.address}</span></td>
        </tr>

        <tr>
            <td class="right label_name">联系方式：</td>
            <td><span class="rigt_tebl_font">${tbPersonBlackListInstance.contactWay}</span></td>
        </tr>

        <tr>
            <td class="right label_name">证件类型：</td>
            <td class="${hasErrors(bean: tbPersonBlackListInstance, field: 'identityType', 'errors')}">${TbPersonBlackList.identityTypeMap[tbPersonBlackListInstance.identityType]}</td>
        </tr>


        <tr>
            <td class="right label_name">证件号码：</td>
            <td class="${hasErrors(bean: tbPersonBlackListInstance, field: 'identityNo', 'errors')}">${tbPersonBlackListInstance.identityNo}</td>
        </tr>

        <tr>
            <td class="right label_name">来源：</td>
            <td><span class="rigt_tebl_font">${TbPersonBlackList.sourceMap[tbPersonBlackListInstance.source]}</span></td>
        </tr>

        <tr>
            <td class="right label_name">创建时间：</td>
            <td><span class="rigt_tebl_font"><g:formatDate date="${tbPersonBlackListInstance.createDate}" format="yyyy-MM-dd"/></span></td>
        </tr>


        <tr>
            <td colspan="2" align="center">
                <g:form>
                    <g:hiddenField name="id" value="${tbPersonBlackListInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="button">
                       <bo:hasPerm perm="${Perm.RiskManager_BlackList_EditPer}">
                          <g:actionSubmit class="rigt_button" action="editPer" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/>
                       </bo:hasPerm>
                    </span>
                </g:form>
            </td>
        </tr>
    </table>

</div>
</body>
</html>