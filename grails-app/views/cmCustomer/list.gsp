<%@ page import="boss.Perm; ismp.CmPersonalInfo; ismp.CmCustomer" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cmCustomer.label', default: 'CmCustomer')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>


<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">黑名单库</h1>
        <div class="table_serch">
            <g:form>

                <table>

                    <tr>
                     <!--
                    <td>客户号：</td>
                    <td><g:textField name="customerNo" value="${params.customerNo}" class="right_top_h2_input"/></td>
                     -->
                     <td>
                        客户名称：
                    </td><td>
                        <g:textField name="name" value="${params.name}" class="right_top_h2_input"/>
                    </td>

                    <td>客户类型：</td>
                    <td>
                        <select name="type">
                                   <option value="C" <%=type.equals("C")?"selected":""%>>企业客户</option>
                                   <option value="P" <%=type.equals("P")?"selected":""%>>个人客户</option>
                        </select>
                    </td>
                     <td>黑名单状态：</td>
                     <td>
                        <g:select name="status" from="${CmCustomer.blackMap}" value="${params?.status}" noSelection="${['':'-请选择-']}" optionKey="key" optionValue="value"/>
                     </td>
                     <td><g:actionSubmit id="searchList" action="list" style="width:100px;height:23px;" value="查询"/></td>
                    </tr>

                </table>

            </g:form>
        </div>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <!--
                <g:sortableColumn params="${params}" property="customerNo"
                                  title="${message(code: 'cmCustomer.customerNo.label', default: 'Customer No')}"/>
                -->

                <g:if test="${type == 'C'}">
                    <g:sortableColumn params="${params}" property="name"
                                      title="${message(code: 'cmCorporationInfo.name.label',default:'name')}"/>

                    <g:sortableColumn params="${params}" property="registrationName"
                                      title="${message(code: 'cmCorporationInfo.registrationName.label',default:'registrationName')}"/>

                    <g:sortableColumn params="${params}" property="businessLicenseCode"
                                      title="${message(code: 'cmCorporationInfo.businessLicenseCode.label',default:'businessLicenseCode')}"/>

                    <g:sortableColumn params="${params}" property="organizationCode"
                                      title="${message(code: 'cmCorporationInfo.organizationCode.label',default:'organizationCode')}"/>

                </g:if>


                <g:if test="${type == 'P'}">

                    <g:sortableColumn params="${params}" property="name"
                                      title="${message(code: 'cmCustomer.name.label', default: 'Name')}"/>

                    <g:sortableColumn params="${params}" property="identityType" title="${message(code: 'cmPersonalInfo.identityType.label')}"/>
                    <g:sortableColumn params="${params}" property="identityNo" title="${message(code: 'cmPersonalInfo.identityNo.label')}"/>

                </g:if>

                <g:sortableColumn params="${params}" property="openStatus"
                                  title="${message(code: 'cmCustomer.openStatus.label', default: '开启审核状态')}"/>

                <g:sortableColumn params="${params}" property="closeStatus"
                                  title="${message(code: 'cmCustomer.closeStatus.label', default: '关闭审核状态')}"/>

                <g:sortableColumn params="${params}" property="status"
                                  title="${message(code: 'cmCustomer.status.label', default: '黑名单状态')}"/>

                <g:sortableColumn params="${params}" property="operate"
                                  title="${message(code: 'cmCustomer.operate.label', default: '操作')}"/>

            </tr>

           <g:if test="${type== 'C'}">
               <g:each in="${cmCorporationInfoInstanceList}" status="i" var="cmCorporationInfo">
               <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
               <td>${fieldValue(bean: cmCorporationInfo, field: "name")}</td>
               <td>${fieldValue(bean: cmCorporationInfo, field: "registrationName")}</td>
               <td>${fieldValue(bean: cmCorporationInfo, field: "businessLicenseCode")}</td>
               <td>${fieldValue(bean: cmCorporationInfo, field: "organizationCode")}</td>
               <td>
                   <g:if test="${cmCorporationInfo?.openStatus == '0'}">
                           开启待审核
                   </g:if>
                   <g:elseif test="${cmCorporationInfo?.openStatus == '1'}">
                           开启已审核
                   </g:elseif>
               </td>
               <td>
                   <g:if test="${cmCorporationInfo?.closeStatus == '0'}">
                       关闭待审核
                   </g:if>
                   <g:elseif test="${cmCorporationInfo?.closeStatus == '1'}">
                       关闭已审核
                   </g:elseif>
               </td>
               <td>${fieldValue(bean: cmCorporationInfo, field: "status")== 'disabled' ? '开启' : '关闭'}</td>
               <td>
                   <g:if test="${cmCorporationInfo?.status== 'normal'&& cmCorporationInfo?.openStatus == '0'}">
                       <bo:hasPerm perm="${Perm.RiskManager_BackList_Open_Audit}">
                         <g:link action="verify" id="${cmCorporationInfo.id}">开启审核</g:link>
                       </bo:hasPerm>
                   </g:if>
                   <g:elseif test="${cmCorporationInfo?.status== 'disabled' && cmCorporationInfo?.closeStatus == '0'}">
                      <bo:hasPerm perm="${Perm.RiskManager_BackList_Close_Audit}">
                       <g:link action="verify" id="${cmCorporationInfo.id}">关闭审核</g:link>
                      </bo:hasPerm>
                   </g:elseif>
                   <g:else>
                     <bo:hasPerm perm="${Perm.RiskManager_BackList_Open}">
                       <g:link action="save" id="${cmCorporationInfo.id}">${fieldValue(bean: cmCorporationInfo, field: "status") == 'disabled' ? '关闭' : '开启'}</g:link>
                     </bo:hasPerm>
                   </g:else>
               </td>
               </tr>
               </g:each>
           </g:if>

           <g:if test="${type== 'P'}">

               <g:each in="${cmPersonalInfoInstanceList}" status="i" var="cmPersonalInfoInstance">
               <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
               <td>${fieldValue(bean: cmPersonalInfoInstance, field: "name")}</td>
               <td>${CmPersonalInfo.identityTypeMap[cmPersonalInfoInstance.identityType]}</td>
               <td>${fieldValue(bean: cmPersonalInfoInstance, field: "identityNo")}</td>
               <td>
                   <g:if test="${cmPersonalInfoInstance?.openStatus == '0'}">
                       开启待审核
                   </g:if>
                   <g:elseif test="${cmPersonalInfoInstance?.openStatus == '1'}">
                       开启已审核
                   </g:elseif>
               </td>
               <td>
                   <g:if test="${cmPersonalInfoInstance?.closeStatus == '0'}">
                       关闭待审核
                   </g:if>
                   <g:elseif test="${cmPersonalInfoInstance?.closeStatus == '1'}">
                       关闭已审核
                   </g:elseif>
               </td>
               <td>${fieldValue(bean: cmPersonalInfoInstance, field: "status")== 'disabled' ? '开启' : '关闭'}</td>
               <td>
                   <g:if test="${cmPersonalInfoInstance?.status== 'normal'&& cmPersonalInfoInstance?.openStatus == '0'}">
                       <bo:hasPerm perm="${Perm.RiskManager_BackList_Open_Audit}">
                           <g:link action="verify" id="${cmPersonalInfoInstance.id}">开启审核</g:link>
                       </bo:hasPerm>
                   </g:if>
                   <g:elseif test="${cmPersonalInfoInstance?.status== 'disabled' && cmPersonalInfoInstance?.closeStatus == '0'}">
                       <bo:hasPerm perm="${Perm.RiskManager_BackList_Close_Audit}">
                           <g:link action="verify" id="${cmPersonalInfoInstance.id}">关闭审核</g:link>
                       </bo:hasPerm>
                   </g:elseif>
                   <g:else>
                       <bo:hasPerm perm="${Perm.RiskManager_BackList_Open}">
                            <g:link action="save" id="${cmPersonalInfoInstance.id}">${fieldValue(bean: cmPersonalInfoInstance, field: "status") == 'disabled' ? '关闭' : '开启'}</g:link>
                       </bo:hasPerm>
                   </g:else>
               </td>
               </tr>
               </g:each>
           </g:if>
        </table>

        <div class="paginateButtons">
            <g:if test="${type== 'C'}">
                <span style=" float:left;">共${cmCorporationInfoInstanceTotal}条记录</span>
                <g:paginat total="${cmCorporationInfoInstanceTotal}" params="${params}"/>
            </g:if>

            <g:if test="${type== 'P'}">
                <span style=" float:left;">共${cmPersonalInfoInstanceTotal}条记录</span>
                <g:paginat total="${cmPersonalInfoInstanceTotal}" params="${params}"/>
            </g:if>
        </div>
    </div>
</div>
</body>
</html>
