<%@ page import="boss.Perm; ismp.TbRiskControl" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbRiskControl.label', default: 'TbRiskControl')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">

        <div class="table_serch">
            <g:form>

                <table>

                    <tr><td>
                        业务类型：

                    </td><td>

                        <g:select name="bType" from='${TbRiskControl.BTypeMap}' value="${params.bType}" noSelection="${['':'--全部--']}" class="right_top_h2_input" optionKey="key" optionValue="value"/>

                    </td><td>
                        <bo:hasPerm perm="${Perm.RiskManager_Risk_Rule_Query}">
                                <g:actionSubmit action="list" style="width:100px;height:23px;" value="查询"/>
                        </bo:hasPerm>
                    </td>
                    <td>
                        <bo:hasPerm perm="${Perm.RiskManager_Risk_Rule_Create}">
                            <g:actionSubmit action="create" style="width:100px;height:23px;" value="创建"/>
                        </bo:hasPerm>
                    </td>
                    </tr>
                </table>

            </g:form>
        </div>


        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="id"
                                  title="序号"/>

                <g:sortableColumn params="${params}" property="bType"
                                  title="业务类型"/>

                <g:sortableColumn params="${params}" property="ruleAbout"
                                  title="规则简介"/>

                <g:sortableColumn params="${params}" property="bDesc"
                                  title="规则描述"/>

                <g:sortableColumn params="${params}" property="status"
                                  title="状态"/>

                <g:sortableColumn params="${params}" property="rule" title="操作"/>

            </tr>

            <g:each in="${tbRiskControlInstanceList}" status="i" var="tbRiskControlInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td>${(pageNum - 1) * 10 + i +1 }</td>

                    <g:if test='${fieldValue(bean: tbRiskControlInstance, field: "bType") == "onlinePay"}'>
                        <td>在线支付</td>
                    </g:if>

                    <g:if test='${fieldValue(bean: tbRiskControlInstance, field: "bType") == "mobilePay"}'>
                        <td>移动电话支付</td>
                    </g:if>

                    <td>${fieldValue(bean: tbRiskControlInstance, field: "ruleAbout")}</td>

                    <td>${fieldValue(bean: tbRiskControlInstance, field: "bDesc")}</td>

                    <td>${fieldValue(bean: tbRiskControlInstance, field: "status") == '1' ? '启用' : '关闭'}</td>

                    <td>

                        <bo:hasPerm perm="${Perm.RiskManager_Risk_Rule_View}">
                           <g:link action="show" id="${tbRiskControlInstance.id}">详情</g:link>
                        </bo:hasPerm>
                        <bo:hasPerm perm="${Perm.RiskManager_Risk_Rule_Audit}">
                             <g:link action="edit" params="['id':tbRiskControlInstance?.id,'verify':'0']">审核</g:link>
                        </bo:hasPerm>
                    </td>
                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">

            <div style="float:left"><span/>一共${tbRiskControlInstanceTotal}条</span></div>

            <div style="float:right"><g:paginate total="${tbRiskControlInstanceTotal}" params="${params}"/></div>

        </div>
    </div>
</div>
</body>
</html>
