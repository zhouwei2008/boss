<%@ page import="ismp.CmCustomerBankAccount; ismp.CmPersonalInfo; ismp.CmCustomer;boss.Perm" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cmPersonalInfo.label', default: 'CmPersonalInfo')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
    });
    function checkDate() {
        var startDate = document.getElementById("startDateCreated").value;
        var endDate = document.getElementById("endDateCreated").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endDateCreated").focus();
            return false;
        }
    }
        /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startDateCreated = document.getElementById('startDateCreated').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endDateCreated').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }
        // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectF=new Date(startDateCreated);
        var dSelectT=new Date(endDateCreated);
         var theFromM=dSelectF.getMonth();
         var theFromD=dSelectF.getDate();
        // 设置起始日期加一个月
          theFromM += 1;
          dSelectF.setMonth(theFromM,theFromD);
          if( dSelectF < dSelectT)
          {
              alert('每次只能查询1个月范围内的数据!');
              return false;
          }
    }
         function empty() {
        $(':input') .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');

        return false;
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <g:form>
        <div class="table_serch">
            <table>

                <tr>

                    <td>${message(code: 'cmPersonalInfo.customerNo.label')}：</td>
                    <td><g:textField name="customerNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.customerNo}" class="right_top_h2_input"/>  </td>
                    <td>${message(code: 'cmPersonalInfo.name.label')}：</td>
                    <td><g:textField name="name" onblur="value=value.replace(/[ ]/g,'')" value="${params.name}" class="right_top_h2_input"/> </td>
                    <td>${message(code: 'cmPersonalInfo.status.label')}：</td>
                    <td><p><g:select name="status" value="${params.status}" from="${CmPersonalInfo.statusMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/> </p></td>
                </tr>
                <tr>
                    <td>${message(code: 'cmPersonalInfo.accountNo.label')}：</td>
                    <td><g:textField name="accountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.accountNo}" class="right_top_h2_input"/></td>
                    <td>${message(code: 'cmPersonalInfo.identityNo.label')}：  </td>
                    <td><g:textField name="identityNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.identityNo}" class="right_top_h2_input"/>  </td>
                    <td>${message(code: 'cmPersonalInfo.dateCreated.label')}：   </td>
                    <td><g:textField name="startDateCreated" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.startDateCreated}" style="width:80px" class="right_top_h2_input"/> --<g:textField name="endDateCreated" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.endDateCreated}" style="width:80px" class="right_top_h2_input"/></td>
                </tr>
                <tr>
                    <td>  </td>
                    <td> </td>
                    <td> </td>
                    <td> </td>
                    <td> </td>
                    <td>
                        <g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkDate()" />
                        <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
                        <bo:hasPerm perm="${Perm.Cust_Per_Dl}">
                        <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()" />
                        </bo:hasPerm>
                    </td>
                </tr>

            </table>
        </div>
        <bo:hasPerm perm="${Perm.Cust_Per_New}">
        <div class="button_menu"><g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/></div>
        </bo:hasPerm>
        </g:form>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <g:sortableColumn params="${params}" property="customerNo" title="${message(code: 'cmPersonalInfo.customerNo.label', default: 'customerNo')}"/>
                <g:sortableColumn params="${params}" property="name" title="${message(code: 'cmPersonalInfo.name.label', default: 'Name')}"/>
                <g:sortableColumn params="${params}" property="nationality" title="国籍"/>
                <g:sortableColumn params="${params}" property="gender" title="性别"/>
                <g:sortableColumn params="${params}" property="occupation" title="职业"/>
                <g:sortableColumn params="${params}" property="validTime" title="有效期限"/>
                <g:sortableColumn params="${params}" property="status" title="${message(code: 'cmPersonalInfo.status.label', default: 'Status')}"/>
                <g:sortableColumn params="${params}" property="accountNo" title="${message(code: 'cmPersonalInfo.accountNo.label', default: 'Account No')}"/>
                <g:sortableColumn params="${params}" property="identityType" title="${message(code: 'cmPersonalInfo.identityType.label')}"/>
                <g:sortableColumn params="${params}" property="identityNo" title="${message(code: 'cmPersonalInfo.identityNo.label')}"/>
                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'cmPersonalInfo.dateCreated.label', default: 'dateCreated')}"/>
                <th>操作</th>
            </tr>

            <g:each in="${cmPersonalInfoInstanceList}" status="i" var="cmPersonalInfoInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td><g:if test="${bo.hasPerm(perm:Perm.Cust_Per_View){true}}" ><g:link action="show" id="${cmPersonalInfoInstance.id}">${fieldValue(bean: cmPersonalInfoInstance, field: "customerNo")}</g:link></g:if><g:else>${fieldValue(bean: cmPersonalInfoInstance, field: "customerNo")}</g:else></td>
                    <td>${fieldValue(bean: cmPersonalInfoInstance, field: "name")}</td>
                    <td>${CmPersonalInfo.nationalityMap[cmPersonalInfoInstance.nationality]}</td>
                    <td>${CmPersonalInfo.genderMap[cmPersonalInfoInstance.gender]}</td>
                    <td>${CmPersonalInfo.occupationMap[cmPersonalInfoInstance.occupation]}</td>
                    <td><g:formatDate date="${cmPersonalInfoInstance?.validTime}" format="yyyy-MM-dd"/></td>
                    <td>${CmCustomer.statusMap[cmPersonalInfoInstance?.status]}</td>
                    <td>${fieldValue(bean: cmPersonalInfoInstance, field: "accountNo")}</td>
                    <td>${CmPersonalInfo.identityTypeMap[cmPersonalInfoInstance.identityType]}</td>
                    <td>${fieldValue(bean: cmPersonalInfoInstance, field: "identityNo")}</td>
                    <td><g:formatDate date="${cmPersonalInfoInstance?.dateCreated}" format="yyyy-MM-dd"/></td>
                    <td>
                        <g:if test="${cmPersonalInfoInstance?.status!='deleted'}">
                            <bo:hasPerm perm="${Perm.Cust_Per_Bank}">
                            <input type="button" onclick="window.location.href = '${createLink(controller:'cmCustomerBankAccount', action:'list', params:['customer.id':cmPersonalInfoInstance?.id])}'" value="银行账户"/>
                            </bo:hasPerm>
                            <bo:hasPerm perm="${Perm.Cust_Per_Srv}">
                            <input type="button" onclick="window.location.href = '${createLink(controller:'boCustomerService', action:'list', params:['customerId':cmPersonalInfoInstance?.id])}'" value="服务管理"/>
                            </bo:hasPerm>
                        </g:if>
                    </td>
                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${cmPersonalInfoInstanceTotal}条记录</span>
            <g:paginat total="${cmPersonalInfoInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
