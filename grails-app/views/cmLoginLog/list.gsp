<%@ page import="ismp.CmCustomer;ismp.CmLoginLog" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cmOpLog.label', default: 'CmOpLog')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <link rel="stylesheet" type="text/css" href="../ext/css/ext-all.css"/>
    <link rel="stylesheet" type="text/css" href="../ext/css/style.css"/>
    <script type="text/javascript" src="../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../ext/js/common.js"></script>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
    });

    /*---guonan update 2011-12-30----*/
    function checkDate() {
        var startDateCreated = document.getElementById('startDateCreated').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endDateCreated').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }

    }
    function empty() {

        document.getElementById('startDateCreated').value='';
        document.getElementById('endDateCreated').value='';
        document.getElementById('customerNo').value='';
        document.getElementById('customerName').value='';
        return false;
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <div class="table_serch">
            <table>
                <g:form>
                    <tr>
                        <td>商户名称：</td>
                        <td><p><g:textField name="customerName"  value="${params.customerName}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                        <td>商户号：</td>
                        <td><p><g:textField name="customerNo"  value="${params.customerNo}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td>登陆时间：</td>
                        <td><g:textField name="startDateCreated" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.startDateCreated}" class="right_top_h2_input" />--<g:textField name="endDateCreated" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.endDateCreated}" onchange="checkDate()" class="right_top_h2_input" /></td>
                    </tr>
                    <tr>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkDate()"/></td>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="" value="清空" onclick="return empty()"/></td>
                    </tr>
                </g:form>
            </table>
        </div>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}"  property="loginCertificate" title="${message(code: 'cmLoginlog.loginCertificate.label', default: '登陆用户名')}"/>

                <g:sortableColumn params="${params}"  property="loginResult" title="${message(code: 'cmLoginlog.loginResult.label', default: '登陆结果')}" />

                <g:sortableColumn params="${params}"  property="customerNo" title="${message(code: 'cmLoginlog.customerNo.label', default: '商户号')}"/>

                <g:sortableColumn params="${params}"  property="customerNo" title="${message(code: 'cmLoginlog.customerNo.label', default: '商户名称')}"/>

                <g:sortableColumn params="${params}"  property="loginIp" title="${message(code: 'cmLoginlog.loginIp.label', default: 'Ip')}"/>

                <g:sortableColumn params="${params}"  property="dateCreated" title="${message(code: 'cmLoginlog.dateCreated.label', default: '登陆时间')}"/>

            </tr>

            <g:each in="${cmLoginLogInstanceList}" status="i" var="cmLoginLogInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">


                    <td>${fieldValue(bean: cmLoginLogInstance, field: "loginCertificate")}</td>

                    <td>${fieldValue(bean: cmLoginLogInstance, field: "loginResult")}</td>

                    <td>${cmLoginLogInstance?.customer?.customerNo}</td>

                    <td>${cmLoginLogInstance?.customer?.name}</td>

                    <td>${fieldValue(bean: cmLoginLogInstance, field: "loginIp")}</td>

                    <td><g:formatDate date="${cmLoginLogInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>

                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${cmLoginLogInstanceTotal}条记录</span>
            <g:paginat total="${cmLoginLogInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
