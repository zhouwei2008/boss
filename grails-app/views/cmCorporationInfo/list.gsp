<%@ page import="settle.FtSrvFootSetting; boss.BoCustomerService; boss.BoOperator; ismp.CmCustomerOperator; boss.Perm; ismp.CmCustomer; ismp.CmCorporationInfo; boss.BoBranchCompany" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cmCorporationInfo.label', default: 'CmCorporationInfo')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>

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

                        <td>${message(code: 'cmCorporationInfo.customerNo.label')}：</td>
                        <td><g:textField name="customerNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.customerNo}" class="right_top_h2_input"/></td>

                        <td>${message(code: 'cmCorporationInfo.name.label')}：</td>
                        <td><g:textField name="name" onblur="value=value.replace(/[ ]/g,'')" value="${params.name}" class="right_top_h2_input"/></td>

                        <td>${message(code: 'cmCorporationInfo.registrationName.label')}：</td>
                        <td><p><g:textField name="registrationName" onblur="value=value.replace(/[ ]/g,'')" value="${params.registrationName}" class="right_top_h2_input"/></p></td>

                         <td>${message(code: 'cmCorporationInfo.status.label')}：</td>
                        <td><p><g:select name="status" value="${params.status}" from="${CmCorporationInfo.statusMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                    </tr>

                    <tr>
                        <td>${message(code: 'cmCorporationInfo.accountNo.label')}：</td>
                        <td><g:textField name="accountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.accountNo}" class="right_top_h2_input"/></td>

                        <td>${message(code: 'cmCorporationInfo.companyWebsite.label')}：</td>
                        <td><g:textField name="companyWebsite" value="${params.companyWebsite}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input"/>


                        <td>${message(code: 'cmCorporationInfo.registeredPlace.label')}：</td>
                        <td><p><g:textField name="registeredPlace" value="${params.registeredPlace}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input"/></p></td>

                        <td>${message(code:'执照到期时间',default:'执照到期时间')}：</td>
                        <td><p><g:select name="expire" from="${ismp.CmCorporationInfo.expireMap}"  optionKey="key" optionValue="value" noSelection="${['':'-全部-']}"  value="${params.expire}" onchange="changeShow()"/></p>
                        </td>

                    </tr>

                    <tr>
                        <td>${message(code: 'cmCorporationInfo.belongToSale.label')}：</td>
                        <td><p><g:textField name="belongToSale" value="${params.belongToSale}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'cmCorporationInfo.branchCompany.label')}：</td>
			            <td><p><g:select class="right_top_h2_input" style="width:170px"  name="branchCompany" from="${BoBranchCompany.list()}" optionKey="id" optionValue="companyName" noSelection="${['':'-请选择-']}" value="${params?.branchCompany}"/></p></td>
                        <td>${message(code: 'cmCorporationInfo.adminEmail.label')}：</td>
                        <td><p><g:textField name="adminEmail" value="${params.adminEmail}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input"/></p></td>
                        <td>${message(code:'服务类型',default:'服务类型')}：</td>
                        <td><p><g:select name="serviceCode" from="${BoCustomerService.serviceMap}"  optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" value="${params.serviceCode}" onchange="changeShow()"/></p>
                        </td>
                    </tr>

                    <tr>
                        <td>${message(code:'结算周期',default:'结算周期')}：</td>
                        <td><p><g:select name="footType" from="${FtSrvFootSetting.tradeTypeMap}"  optionKey="key" optionValue="value" noSelection="${['':'-全部-']}"  value="${params.footType}" onchange="changeShow()"/></p>
                         </td>
                        <td>${message(code:'合同号码',default:'合同号码')}：</td>
                        <td><g:textField name="contractNo" value="${params.contractNo}"  class="right_top_h2_input" onblur="value=value.replace(/[ ]/g,'')"/></td>

                        <td>${message(code: 'cmCorporationInfo.dateCreated.label')}：</td>
                        <td><p><g:textField name="startDateCreated" style="width:80px" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.startDateCreated}" class="right_top_h2_input"/>--<g:textField name="endDateCreated" style="width:80px" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" value="${params.endDateCreated}" class="right_top_h2_input"/></p></td>
                        <td />
                    </tr>

                    <tr>
                        <td><input class = "right_top_h2_button_clear" type = "button" onclick="empty();" value="清空"/></td>
                        <td>
                            <g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkDate()"/>

                            <bo:hasPerm perm="${Perm.Cust_Corp_Dl}">
                                <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()"/>
                            </bo:hasPerm>
                        </td>
                        <td>
                            <bo:hasPerm perm="${Perm.Cust_Corp_New}">
                               <g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:[entityName])}"/>
                            </bo:hasPerm>
                        </td>
                    </tr>

                </table>
            </div>

        </g:form>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <g:sortableColumn params="${params}" property="customerNo" title="${message(code: 'cmCorporationInfo.customerNo.label', default: 'customerNo')}"/>
                <g:sortableColumn params="${params}" property="name" title="${message(code: 'cmCorporationInfo.name.label', default: 'Name')}"/>
                <g:sortableColumn params="${params}" property="registrationName" title="${message(code: 'cmCorporationInfo.registrationName.label', default: 'registrationName')}"/>
                <g:sortableColumn params="${params}" property="status" title="${message(code: 'cmCorporationInfo.status.label', default: 'Status')}"/>
                <g:sortableColumn params="${params}" property="accountNo" title="${message(code: 'cmCorporationInfo.accountNo.label', default: 'Account No')}"/>
                <g:sortableColumn params="${params}" property="belongToSale" title="${message(code: 'cmCorporationInfo.belongToSale.label', default: 'belongToSale')}"/>
                <g:sortableColumn params="${params}" property="branchCompany" title="${message(code: 'cmCorporationInfo.branchCompany.label', default: 'branchCompany')}"/>
                <g:sortableColumn params="${params}" property="registeredPlace" title="${message(code: 'cmCorporationInfo.registeredPlace.label', default: 'registeredPlace')}"/>
                <g:sortableColumn params="${params}" property="adminEmail" title="${message(code: 'cmCorporationInfo.adminEmail.label', default: 'adminEmail')}"/>
                <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'cmCorporationInfo.dateCreated.label', default: 'dateCreated')}"/>

                <th>操作</th>
            </tr>

            <g:each in="${cmCorporationInfoInstanceList}" status="i" var="cmCorporationInfoInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td nowrap>
                        <g:if test="${bo.hasPerm(perm:Perm.Cust_Corp_View){true}}"><g:link action="show" id="${cmCorporationInfoInstance.id}">${fieldValue(bean: cmCorporationInfoInstance, field: "customerNo")}</g:link></g:if>
                        <g:else>${fieldValue(bean: cmCorporationInfoInstance, field: "customerNo")}</g:else>
                    </td>
                    <td nowrap>${fieldValue(bean: cmCorporationInfoInstance, field: "name")}</td>
                    <td nowrap>${fieldValue(bean: cmCorporationInfoInstance, field: "registrationName")}</td>
                    <td nowrap>${CmCustomer.statusMap[cmCorporationInfoInstance?.status]}</td>
                    <td nowrap>${fieldValue(bean: cmCorporationInfoInstance, field: "accountNo")}</td>
                    <td nowrap>${fieldValue(bean: cmCorporationInfoInstance, field: "belongToSale")}</td>

                    <td nowrap><g:if test="${cmCorporationInfoInstance?.branchCompany !=null}">${BoBranchCompany.findById(cmCorporationInfoInstance?.branchCompany)?.companyName}</g:if></td>
                    <td nowrap>${fieldValue(bean: cmCorporationInfoInstance, field: "registeredPlace")}</td>
                    <td nowrap>${CmCustomerOperator.findWhere(roleSet:'1',status: 'normal',customer: cmCorporationInfoInstance)?.defaultEmail}</td>

                    <td nowrap><g:formatDate date="${cmCorporationInfoInstance?.dateCreated}" format="yyyy-MM-dd"/></td>
                    <td nowrap>
                        <g:if test="${cmCorporationInfoInstance?.status!='deleted'}">
                            <bo:hasPerm perm="${Perm.Cust_Corp_Bank}">
                            <input type="button" onclick="window.location.href = '${createLink(controller:'cmCustomerBankAccount', action:'list', params:['customer.id':cmCorporationInfoInstance?.id])}'" value="银行账户"/>
                            </bo:hasPerm>
                            <bo:hasPerm perm="${Perm.Cust_Corp_Srv}">
                            <input type="button" onclick="window.location.href = '${createLink(controller:'boCustomerService', action:'list', params:['customerId':cmCorporationInfoInstance?.id])}'" value="服务管理"/>
                            </bo:hasPerm>
                            <!--待修改-->
                            <g:if test="${cmCorporationInfoInstance?.customerCategory=='travel'}">
                                <bo:hasPerm perm="${Perm.Cust_Corp_DirectBind}">
                                <input type="button" onclick="window.location.href = '${createLink(controller:'boDirectPayBind', action:'list', params:['customerNo':cmCorporationInfoInstance?.customerNo,'accountNo':cmCorporationInfoInstance?.accountNo])}'" value="定向支付绑定"/>
                                </bo:hasPerm>
                            </g:if>
                        </g:if>
                        <bo:hasPerm perm="${Perm.Cust_Corp_Op}">
                        <input type="button" onclick="window.location.href = '${createLink(controller:'cmCustomerOperator', action:'list', params:['customerNo':cmCorporationInfoInstance?.customerNo,'status':cmCorporationInfoInstance?.status])}'" value="操作员管理"/>
                        </bo:hasPerm>
                    </td>
                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${cmCorporationInfoInstanceTotal}条记录</span>
            <g:paginat total="${cmCorporationInfoInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
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
        $(':input') .not(':button, :submit, :reset, :hidden,#customerCategory')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
        $('#customerCategory').val('-1');
        return false;
    }
    
    /*---ZS 2012-03-06----*/
    function clearAll(){
//        alert("AA");
//        $("#startDateCreated").val("")
//        $("#endDateCreated").val("")
        $("#customerNo").val("")
        $("#name").val("")
        $("#registrationName").val("")
        $("#status").val("")
        $("#accountNo").val("")
        $("#registeredWebsite").val("")
        $("#registeredPlace").val("")
        $("#adminEmail").val("")
        $("#branchCompany").val("")
    }
</script>
</body>
</html>
