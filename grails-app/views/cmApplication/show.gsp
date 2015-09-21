<%--
  Created by IntelliJ IDEA.
  User: zhaoshuang
  Date: 12-11-28
  Time: 下午3:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="boss.Perm"%>
<%@ page import="ismp.CmApplicationInfo;"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <meta name="layout" content="main"/>
      <title>在线申请客户查看</title>
  </head>
  <body>
    <table align="center" class="rigt_tebl">
        <tr>
            <th colspan="2">查看 在线申请客户</th>
        </tr>

        <tr>
            <td class="right label_name">客户名称：</td>
            <td><span class="rigt_tebl_font">${cmApplicationInfoInstance?.registrationName}</span></td>
        </tr>

        <tr>
            <td class="right label_name">接入网址：</td>
            <td><span class="rigt_tebl_font"><a href="${cmApplicationInfoInstance?.companyWebsite}" target="_blank">${cmApplicationInfoInstance?.companyWebsite}</a></span></td>
        </tr>

        %{--<tr>--}%
            %{--<td class="right label_name">客户类型：</td>--}%
            %{--<td><span class="rigt_tebl_font">${CmApplicationInfo.typeMap[cmApplicationInfoInstance?.registrationType]}</span></td>--}%
        %{--</tr>--}%

        <tr>
            <td class="right label_name">所在地区：</td>
            <td><span class="rigt_tebl_font">${cmApplicationInfoInstance?.belongToArea}</span></td>
        </tr>
        <tr>
            <td class="right label_name">所属行业：</td>
            <td><span class="rigt_tebl_font">${cmApplicationInfoInstance.belongToBusiness}</span></td>
        </tr>


        <tr>
            <td class="right label_name">联系人：</td>
            <td><span class="rigt_tebl_font">${cmApplicationInfoInstance.bizMan}</span></td>
        </tr>

        <tr>
            <td class="right label_name">联系人手机：</td>
            <td><span class="rigt_tebl_font">${cmApplicationInfoInstance?.bizMPhone}</span></td>
        </tr>

        <tr>
            <td class="right label_name">联系人座机：</td>
            <td><span class="rigt_tebl_font">${cmApplicationInfoInstance?.bizPhone}</span></td>
        </tr>

        <tr>
            <td class="right label_name">联系人邮箱：</td>
            <td><span class="rigt_tebl_font">${cmApplicationInfoInstance?.bizEmail}</span></td>
        </tr>

        <tr>
            <td class="right label_name">通信地址：</td>
            <td><span class="rigt_tebl_font">${cmApplicationInfoInstance?.officeLocation}</span></td>
        </tr>

        <tr>
            <td class="right label_name">邮编：</td>
            <td><span class="rigt_tebl_font">${cmApplicationInfoInstance?.zipCode}</span></td>
        </tr>

        <tr>
            <td class="right label_name">签约状态：</td>
            <td><span class="rigt_tebl_font">${CmApplicationInfo.statusMap[cmApplicationInfoInstance?.status]}</span></td>
        </tr>

        <tr>
            <td class="right label_name">申请时间：</td>
            <td><span class="rigt_tebl_font"><g:formatDate date="${cmApplicationInfoInstance?.dateCreated}" fromaDate="yyyy-mm-dd HH:mm:ss"/></span></td>
        </tr>

        <tr>
            <td colspan="2" align="center">
                <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
            </td>
        </tr>
    </table>
  </body>
</html>