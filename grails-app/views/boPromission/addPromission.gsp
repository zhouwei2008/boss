<%@ page import="boss.BoPromission" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boPromission.label', default: 'BoPromission')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript">
        function checkAllBox() {
            var len = document.getElementsByName("box").length;
            for (i = 0; i < len; i++) {
                if (document.getElementById("allBox").checked) {
                    document.getElementsByName("box")[i].checked = true;
                }
                else {
                    document.getElementsByName("box")[i].checked = false;
                }
            }
        }
        function selectCheck() {
            var len = document.getElementsByName("box").length;
            var flag = 0;
            for (i = 0; i < len; i++) {
                if (document.getElementsByName("box")[i].checked) {
                    flag = 1;
                }
            }
            if (flag == 0) {
                alert("请选择要分配的权限！");
                return false;
            }
            else {
//              alert(2222222222);
//              var url = "boPromission/updatePromission";
//			$.post(url, {
//				Ids:"12"
//			}, function (data, textStatus){
//				if(textStatus=="success")
//                alert(11111111);
////					window.location.reload()
//			});

            %{--var baseUrl = "${createLink(controller:'reportlist', action:'getIssuerTree')}";--}%
            %{--var dc = new DataCollection();--}%
            %{--dc.add("id","12")  ;--}%
            %{--Server.post(baseUrl,dc,update);--}%

            %{--document.getElementById("submit").action= "updatePromission?id=12";--}%
                return true;
            }
        }
        window.onload = function() {
            var perm = "${promission}".toString();
            var len = document.getElementsByName("box").length;
            for (i = 0; i < len; i++) {
                if (perm.indexOf(document.getElementsByName("box")[i].value) != -1) {
                    document.getElementsByName("box")[i].checked = true;
                }
            }
        }
        function selectPar(code, id) {
            var len = document.getElementsByName("box").length;
            for (i = 0; i < len; i++) {
                if (document.getElementsByName("code")[i].value == code.toString().substr(0, 3)) {
                    if (document.getElementsByName("code")[i].value.length == 3) {
                        if (document.getElementsByName("code")[i].value == code) {
                            if (document.getElementsByName("box")[i].checked) {
                                document.getElementsByName("box")[i].checked = true;
                                for (j = 0; j < len; j++) {
                                    if (document.getElementsByName("code")[j].value.toString().substr(0, 3) == code) {
                                        document.getElementsByName("box")[j].checked = true;
                                    }
                                }
                            }
                            else {
                                document.getElementsByName("box")[i].checked = false;
                                for (j = 0; j < len; j++) {
                                    if (document.getElementsByName("code")[j].value.toString().substr(0, 3) == code) {
                                        document.getElementsByName("box")[j].checked = false;
                                    }
                                }
                            }
                        } else {
                            document.getElementsByName("box")[i].checked = true;
                        }
                    } else {
                        document.getElementsByName("box")[i].checked = true;
                    }
                }

            }
        }
    </script>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <g:form>
        %{--<h2>--}%
        %{--<g:actionSubmit id="submit" class="right_top_h2_button_tj" action="updatePromission" value="${message(code: 'boPromission.new.label')}" onclick="return selectCheck();"/>--}%
        %{--</h2>--}%
            <table align="center" class="right_list_table" id="test" style="width:400px">
            <g:hiddenField name="roleId" id="roleId" value="${roleId}"></g:hiddenField>
            <tr>
                <th>请选择</th>

                <g:sortableColumn params="${params}" property="promissionName" title="${message(code: 'boPromission.promissionName.label', default: 'Promission Name')}"/>

            </tr>

            <g:each in="${boPromissionInstanceList}" status="i" var="boPromissionInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <g:if test="${boPromissionInstance.promissionCode.toString()!='admin'}">
                        <td><g:checkBox name="box" value="${boPromissionInstance.id}" checked="false" onclick="selectPar(${boPromissionInstance.promissionCode},${boPromissionInstance.id})"></g:checkBox></td>
                        <g:hiddenField name="code" value="${boPromissionInstance.promissionCode}"></g:hiddenField>
                        <td>${fieldValue(bean: boPromissionInstance, field: "promissionCode")}---${fieldValue(bean: boPromissionInstance, field: "promissionName")}</td>
                    </g:if>
                %{--<g:else>--}%
                %{--<td>${fieldValue(bean: boPromissionInstance, field: "promissionCode")}---${fieldValue(bean: boPromissionInstance, field: "promissionName")}</td>--}%
                %{--</g:else>--}%

                </tr>
                </tr>
            </g:each>
            <td>全选<input type="checkbox" id="allBox" name="allBox" onclick="checkAllBox();"></td>
            </table>
            <table align="center">
                <tr>&nbsp;</tr>
                <tr>
                    <td align="center">
                        <g:actionSubmit id="submit" align="center" class="right_top_h2_button_tj" action="updatePromission" value="${message(code: 'boPromission.new.label')}" onclick="return selectCheck();"/>
                    </td>
                </tr>
            </table>
        </g:form>
        <div class="paginateButtons">
            <g:paginat total="${boPromissionInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
