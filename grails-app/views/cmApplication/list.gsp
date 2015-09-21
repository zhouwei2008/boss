<%--
  Created by IntelliJ IDEA.
  User: zhaoshuang
  Date: 12-11-28
  Time: 上午10:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="boss.Perm"%>
<%@ page import="ismp.CmApplicationInfo;"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <meta name="layout" content="main"/>
      <title>在线申请客户列表</title>
  </head>
  <body>
      <div class="main">
        <g:if test="${flash.message}">
            <div class="message">${flash.message.encodeAsHTML()}</div>
        </g:if>
        <div class="right_top">
            <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">在线申请客户 列表</h1>
            <g:form>
                <div class="table_serch">
                    <table>
                        <tr>
                            <td>商户名称：</td>
                            <td><g:textField name="registrationName" onblur="value=value.replace(/[ ]/g,'')" value="${params.registrationName}" class="right_top_h2_input"/></td>

                            <td>联系人：</td>
                            <td colspan="2"><g:textField name="bizMan" onblur="value=value.replace(/[ ]/g,'')" value="${params.bizMan}" class="right_top_h2_input"/></td>

                            <td>签约状态：</td>
                            <td><p><g:select name="status" value="${params.status}" from="${CmApplicationInfo.statusMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                            <td style="display:none;">企业性质：</td>
                            <td style="display:none;><p><g:select name="registrationType" value="${params.registrationType}" from="${CmApplicationInfo.typeMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                        </tr>
                        <tr>
                            <td>网站域名：</td>
                            <td><g:textField name="companyWebsite" onblur="value=value.replace(/[ ]/g,'')" value="${params.companyWebsite}" class="right_top_h2_input"/></td>

                            <td>申请日期：</td>
                            <td colspan="2"><p><g:textField name="startDateCreated" style="width:80px" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.startDateCreated}" class="right_top_h2_input"/>--<g:textField name="endDateCreated" style="width:80px" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.endDateCreated}" class="right_top_h2_input"/></p></td>
                            <td colspan="2">
                                <input class = "right_top_h2_button_clear" type = "button" onclick="empty();" value="清空"/>
                                <g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkDate();"/>
                                <bo:hasPerm perm="${Perm.Cust_Application_Dl}">
                                    <g:actionSubmit class="right_top_h2_button_download" action="downLoad" value="下载" onclick="return checkDate();"/>
                                </bo:hasPerm>
                            </td>
                        </tr>
                    </table>
                </div>
            </g:form>
            <table align="center" class="right_list_table" id="test">
                <tr>
                    <g:sortableColumn params="${params}" property="registrationName" title="商户名称"/>
                    <g:sortableColumn params="${params}" property="companyWebsite" title="网站域名"/>
                    %{--<g:sortableColumn params="${params}" property="registrationType" title="商户性质"/> --}%
                    <g:sortableColumn params="${params}" property="belongToArea" title="所在地区"/>
                    <g:sortableColumn params="${params}" property="belongToBusiness" title="所属行业"/>
                    <g:sortableColumn params="${params}" property="bizMan" title="联系人"/>
                    <g:sortableColumn params="${params}" property="bizMPhone" title="手机"/>
                    <g:sortableColumn params="${params}" property="bizEmail" title="邮箱"/>
                    <g:sortableColumn params="${params}" property="dateCreated" title="申请日期"/>
                    <g:sortableColumn params="${params}" property="status" title="签约状态"/>
                    <th>操作</th>
                </tr>

                <g:each in="${cmApplicationInfoInstanceList}" status="i" var="cmApplicationInfoInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td nowrap>${fieldValue(bean: cmApplicationInfoInstance, field: "registrationName")}</td>
                        <td nowrap><a href="${cmApplicationInfoInstance?.companyWebsite}" target="_blank">${fieldValue(bean: cmApplicationInfoInstance, field: "companyWebsite")}</a></td>
                        %{--<td nowrap>${CmApplicationInfo.typeMap[cmApplicationInfoInstance?.registrationType]}</td>--}%
                        <td nowrap>${fieldValue(bean: cmApplicationInfoInstance, field: "belongToArea")}</td>
                        <td nowrap>${fieldValue(bean: cmApplicationInfoInstance, field: "belongToBusiness")}</td>
                        <td nowrap>${fieldValue(bean: cmApplicationInfoInstance, field: "bizMan")}</td>
                        <td nowrap>${fieldValue(bean: cmApplicationInfoInstance, field: "bizMPhone")}</td>
                        <td nowrap>${fieldValue(bean: cmApplicationInfoInstance, field: "bizEmail")}</td>
                        <td nowrap><g:formatDate date="${cmApplicationInfoInstance?.dateCreated}" format="yyyy-MM-dd"/></td>
                        <td nowrap>${CmApplicationInfo.statusMap[cmApplicationInfoInstance?.status]}</td>
                        <td nowrap>
                            <bo:hasPerm perm="${Perm.Cust_Application_View}">
                                <input type="button" onclick="doShow(${cmApplicationInfoInstance?.id});" value="查看"/>
                            </bo:hasPerm>
                            <bo:hasPerm perm="${Perm.Cust_Application_Del}">
                                <g:if test="${cmApplicationInfoInstance?.status=='0'}">
                                    <input type="button" onclick="doDelete(${cmApplicationInfoInstance?.id});" value="删除"/>
                                </g:if>
                            </bo:hasPerm>
                            <bo:hasPerm perm="${Perm.Cust_Application_New}">
                                <g:if test="${cmApplicationInfoInstance?.status=='0'}">
                                    <input type="button" onclick="window.location.href = '${createLink(controller:'cmApplication', action:'createCustomer', params:['id':cmApplicationInfoInstance?.id])}'" value="新建客户"/>
                                </g:if>
                            </bo:hasPerm>
                        </td>
                    </tr>
                </g:each>
            </table>

            <div class="paginateButtons">
                <span style=" float:left;">共${cmApplicationInfoInstanceTotal}条记录</span>
                <g:paginat total="${cmApplicationInfoInstanceTotal}" params="${params}"/>
            </div>
        </div>
      </div>

      <script type="text/javascript">

        $(function() {
            $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
            $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        });

        function empty() {
            $(':input') .not(':button, :submit, :reset, :hidden')
            .val('')
            .removeAttr('checked')
            .removeAttr('selected');
            return false;
        }

        function checkDate() {
            var startDate = document.getElementById("startDateCreated").value;
            var endDate = document.getElementById("endDateCreated").value;
            if (startDate > endDate && endDate != '') {
                alert("开始时间不能大于结束时间！");
                document.getElementById("endDateCreated").focus();
                return false;
            }
        }

        function doShow(id) {
            var registrationName = document.getElementsByName("registrationName")[0].value;
            var bizMan = document.getElementsByName("bizMan")[0].value;
            var status = document.getElementsByName("status")[0].value;
            var companyWebsite = document.getElementsByName("companyWebsite")[0].value;
            var startDateCreated = document.getElementsByName("startDateCreated")[0].value;
            var endDateCreated = document.getElementsByName("endDateCreated")[0].value;
//            var registrationType = document.getElementsByName("registrationType")[0].value;
            window.location.href = '${createLink(controller:'cmApplication', action:'show')}?id='+id+'&registrationName='+registrationName+'&bizMan='+bizMan+
                    '&status='+status+'&companyWebsite='+companyWebsite+'&startDateCreated='+startDateCreated+'&endDateCreated='+endDateCreated;
        }

        function doDelete(id) {
            if(confirm("确定将此条信息删除?")) {
                var registrationName = document.getElementsByName("registrationName")[0].value;
                var bizMan = document.getElementsByName("bizMan")[0].value;
                var status = document.getElementsByName("status")[0].value;
                var companyWebsite = document.getElementsByName("companyWebsite")[0].value;
                var startDateCreated = document.getElementsByName("startDateCreated")[0].value;
                var endDateCreated = document.getElementsByName("endDateCreated")[0].value;
//                var registrationType = document.getElementsByName("registrationType")[0].value;
                window.location.href = '${createLink(controller:'cmApplication', action:'delete')}?id='+id+'&registrationName='+registrationName+'&bizMan='+bizMan+
                        '&status='+status+'&companyWebsite='+companyWebsite+'&startDateCreated='+startDateCreated+'&endDateCreated='+endDateCreated;
            }
        }
      </script>
  </body>
</html>