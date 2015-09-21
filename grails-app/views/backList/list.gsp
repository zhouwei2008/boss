<%@ page import="boss.Perm; ismp.TbPersonBlackList; ismp.TbCustomerBlackList" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: '', default: '')}"/>
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
            <g:form name="backlist" id="backlist" method="post" enctype="multipart/form-data" action="">
                <table>
                 <tr>
                    <td>客户名称：</td>
                    <td><g:textField name="name" value="${params.name}" class="right_top_h2_input"/></td>
                    <td>客户类型：</td>
                    <td>
                        <select name="type" id="type" onchange="typeChange()">
                                <option value="C" <%=type.equals("C")?"selected":""%>>企业客户</option>
                                <option value="P" <%=type.equals("P")?"selected":""%>>个人客户</option>
                        </select>
                    </td>

                     <td id="cust1">营业执照：</td>
                     <td id="cust2"><g:textField name="businessLicenseCode" value="${params.businessLicenseCode}" class="right_top_h2_input"/></td>

                     <td id="cust3">法人代表：</td>
                     <td id="cust4"><g:textField name="legalPerson" value="${params.legalPerson}" class="right_top_h2_input"/></td>

                     <td id="cust5">组织机构代码：</td>
                     <td id="cust6"><g:textField name="organizationCode" value="${params.organizationCode}" class="right_top_h2_input"/></td>

                     <td id="per1">身份证号码：</td>
                     <td id="per2"><g:textField name="identityNo" value="${params.identityNo}" class="right_top_h2_input"/></td>

                     %{--<td id="per3">银行账号：</td>--}%
                     %{--<td id="per4"><g:textField name="bankAccount" value="${params.bankAccount}" class="right_top_h2_input"/></td>--}%

                     <td><g:actionSubmit id="searchList" action="list" style="width:80px;height:23px;" value="查询"/></td>

                </tr>
              </table>

                <table>
                 <tr>
                        <td colspan="2">
                            <bo:hasPerm perm="${Perm.RiskManager_BlackList_NewCust}">
                                <g:actionSubmit id="customer" action="createCust" style="width:120px;height:23px;" value="创建企业客户黑名单"/>
                            </bo:hasPerm>
                        </td>
                        <td colspan="2">
                            <bo:hasPerm perm="${Perm.RiskManager_BlackList_NewPer}">
                                <g:actionSubmit id="person" action="createPer" style="width:120px;height:23px;" value="创建个人客户黑名单"/>
                            </bo:hasPerm>
                        </td>

                        <td colspan="2">
                            <bo:hasPerm perm="${Perm.RiskManager_BlackList_DownloadCust}">
                                <g:actionSubmit id="downloadcust" action="getCustBackListXlsFile" style="width:140px;height:23px;" value="下载企业客户黑名单模板"/>
                            </bo:hasPerm>
                        </td>
                        <td colspan="2">
                            <bo:hasPerm perm="${Perm.RiskManager_BlackList_DownloadPer}">
                                <g:actionSubmit id="downloadper" action="getPerBackListXlsFile" style="width:140px;height:23px;" value="下载个人客户黑名单模板"/>
                            </bo:hasPerm>
                        </td>

                        <td colspan="2">
                                %{--<input type="button" style="width:80px;height:23px;"  value="全选" id="all" onClick="checkAll()"/>--}%
                        </td>
                    </tr>

                    <tr>
                        <td colspan="3"><input type="file" name="backlistFile" id="backlistFile" style="height:24px;width:200px;"/></td>
                        <td colspan="3">
                            <bo:hasPerm perm="${Perm.RiskManager_BlackList_UploadCust}">
                                <input type="button" style="width:140px;height:23px;" id="custSubmit" value="企业客户黑名单批量导入" onclick="doSubmit('C');"/>
                            </bo:hasPerm>
                        </td>
                        <td colspan="3">
                            <bo:hasPerm perm="${Perm.RiskManager_BlackList_UploadPer}">
                                <input type="button" style="width:140px;height:23px;" id="preSubmit" value="个人客户黑名单批量导入" onclick="doSubmit('P');"/>
                            </bo:hasPerm>
                        </td>
                        <td>
                            <bo:hasPerm perm="${Perm.RiskManager_BlackList_SearchCust}">
                                %{--<input type="button" style="width:80px;height:23px;"  value="核查" onClick="audit()"/>--}%
                            </bo:hasPerm>
                        </td>
                    </tr>
                </table>
            </g:form>
        </div>
        <table align="center" class="right_list_table" id="test">
            <tr>
                %{--<th>请选择</th>--}%
                <g:if test="${type == 'C'}">

                    <g:sortableColumn params="${params}" property="nickname"
                                      title="${message(code: 'customerBlackList.nickname.label',default:'别称')}"/>

                    <g:sortableColumn params="${params}" property="name"
                                      title="${message(code: 'customerBlackList.name.label',default:'客户名称')}"/>

                    <g:sortableColumn params="${params}" property="businessLicenseCode"
                                      title="${message(code: 'customerBlackList.businessLicenseCode.label',default:'营业执照代码')}"/>

                    <g:sortableColumn params="${params}" property="businessValidity"
                                      title="${message(code: 'customerBlackList.businessValidity.label',default:'营业执照有效期')}"/>

                    <g:sortableColumn params="${params}" property="organizationCode"
                                      title="${message(code: 'customerBlackList.organizationCode.label',default:'组织机构代码')}"/>

                    <g:sortableColumn params="${params}" property="address"
                                      title="${message(code: 'customerBlackList.address.label',default:'客户地址')}"/>

                    <g:sortableColumn params="${params}" property="businessScope"
                                      title="${message(code: 'customerBlackList.businessScope.label',default:'经营范围')}"/>

                    <g:sortableColumn params="${params}" property="legalPerson"
                                      title="${message(code: 'customerBlackList.legalPerson.label',default:'法定代表人')}"/>

                    <g:sortableColumn params="${params}" property="identityType"
                                      title="${message(code: 'customerBlackList.identityType.label',default:'证件类型')}"/>

                    <g:sortableColumn params="${params}" property="identityNo"
                                      title="${message(code: 'customerBlackList.identityNo.label',default:'证件号码')}"/>

                    <g:sortableColumn params="${params}" property="identityValidity"
                                      title="${message(code: 'customerBlackList.identityValidity.label',default:'证件有效期')}"/>
                </g:if>


                <g:if test="${type == 'P'}">

                    <g:sortableColumn params="${params}" property="name"
                                      title="${message(code: 'cmCustomer.name.label', default: 'Name')}"/>

                    <g:sortableColumn params="${params}" property="nationality"
                                      title="${message(code: 'customerBlackList.nationality.label',default:'国籍')}"/>

                    <g:sortableColumn params="${params}" property="gender"
                                      title="${message(code: 'customerBlackList.gender.label',default:'性别')}"/>

                    <g:sortableColumn params="${params}" property="occupation"
                                      title="${message(code: 'customerBlackList.occupation.label',default:'职业')}"/>

                    <g:sortableColumn params="${params}" property="address"
                                      title="${message(code: 'customerBlackList.address.label',default:'地址')}"/>

                    <g:sortableColumn params="${params}" property="contactWay"
                                      title="${message(code: 'customerBlackList.contactWay.label',default:'联系方式')}"/>

                    <g:sortableColumn params="${params}" property="identityType" title="${message(code: 'cmPersonalInfo.identityType.label')}"/>
                    <g:sortableColumn params="${params}" property="identityNo" title="${message(code: 'cmPersonalInfo.identityNo.label')}"/>

                    <g:sortableColumn params="${params}" property="validTime"
                                      title="${message(code: 'customerBlackList.validTime.label',default:'证件有效期')}"/>

                </g:if>

                <g:sortableColumn params="${params}" property="source" title="来源"/>

                <g:sortableColumn params="${params}" property="id" title="操作"/>
            </tr>

           <g:if test="${type== 'C'}">
               <g:each in="${customerBlackList}" status="i" var="customerBlack">
               <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                   %{--<td><g:checkBox name="chbox" id="chbox"></g:checkBox>--}%
                   %{--<g:hiddenField name="id" value="${customerBlack.id}"></g:hiddenField>--}%
                   %{--</td>--}%
                   <td>${fieldValue(bean: customerBlack, field: "nickname")}</td>
                   <td><g:link action="showCust" id="${customerBlack.id}">${fieldValue(bean: customerBlack, field: "name")}</g:link></td>
                   <td>${fieldValue(bean: customerBlack, field: "businessLicenseCode")}</td>
                   <td><g:formatDate date="${customerBlack.businessValidity}" format="yyyy-MM-dd"/></td>
                   <td>${fieldValue(bean: customerBlack, field: "organizationCode")}</td>
                   <td>${fieldValue(bean: customerBlack, field: "address")}</td>
                   <td>${fieldValue(bean: customerBlack, field: "businessScope")}</td>
                   <td>${fieldValue(bean: customerBlack, field: "legalPerson")}</td>
                   <td>${TbCustomerBlackList.identityTypeMap[customerBlack.identityType]}</td>
                   <td>${fieldValue(bean: customerBlack, field: "identityNo")}</td>
                   <td><g:formatDate date="${customerBlack.identityValidity}" format="yyyy-MM-dd"/></td>
                   <td>${TbCustomerBlackList.sourceMap[customerBlack.source]}</td>
                   <td>
                        <bo:hasPerm perm="${Perm.RiskManager_BlackList_DelCust}">
                             <g:link action="deleteCust" id="${customerBlack.id}" onClick="if(confirm('确定删除么?')){return true;}else{return false;}">删除</g:link>
                        </bo:hasPerm>
                   </td>
               </tr>
               </g:each>
           </g:if>

           <g:if test="${type== 'P'}">

               <g:each in="${personBlackList}" status="i" var="personBlack">
               <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                   <td><g:link action="showPer" id="${personBlack.id}">${fieldValue(bean: personBlack, field: "name")}</g:link></td>
                   <td>${TbPersonBlackList.nationalityMap[personBlack.nationality]}</td>
                   <td>${TbPersonBlackList.genderMap[personBlack.gender]}</td>
                   <td>${TbPersonBlackList.occupationMap[personBlack.occupation]}</td>
                   <td>${fieldValue(bean: personBlack, field: "address")}</td>
                   <td>${fieldValue(bean: personBlack, field: "contactWay")}</td>
                   <td>${TbPersonBlackList.identityTypeMap[personBlack.identityType]}</td>
                   <td>${fieldValue(bean: personBlack, field: "identityNo")}</td>
                   <td><g:formatDate date="${personBlack.validTime}" format="yyyy-MM-dd"/></td>
                   <td>${TbCustomerBlackList.sourceMap[personBlack.source]}</td>
                   <td>
                        <bo:hasPerm perm="${Perm.RiskManager_BlackList_DelPer}">
                           <g:link action="deletePer" id="${personBlack.id}" onClick="if(confirm('确定删除么?')){return true;}else{return false;}">删除</g:link>
                        </bo:hasPerm>
                   </td>
               </tr>
               </g:each>
           </g:if>
        </table>

        <div class="paginateButtons">
            <g:if test="${type== 'C'}">
                <span style=" float:left;">共${customerBlackListTotal}条记录</span>
                <g:paginat total="${customerBlackListTotal}" params="${params}"/>
            </g:if>

            <g:if test="${type== 'P'}">
                <span style=" float:left;">共${personBlackListTotal}条记录</span>
                <g:paginat total="${personBlackListTotal}" params="${params}"/>
            </g:if>
        </div>
    </div>
</div>
<script type="text/javascript">
    parent.hideWait();
    $(function() {
          var type = "${type}";
          if(type == "C"){
               $("#per1").css('display','none');
               $("#per2").css('display','none');
               $("#per3").css('display','none');
               $("#per4").css('display','none');
          }else if(type == "P"){
              $("#cust1").css('display','none');
              $("#cust2").css('display','none');
              $("#cust3").css('display','none');
              $("#cust4").css('display','none');
              $("#cust5").css('display','none');
              $("#cust6").css('display','none');
          }
    });


    function typeChange(){
        var type = $("#type").val();
        if(type == "C"){
            $("#per1").css('display','none');
            $("#per2").css('display','none');
//            $("#per3").css('display','none');
//            $("#per4").css('display','none');

            $("#cust1").css('display','inline');
            $("#cust2").css('display','inline');
            $("#cust3").css('display','inline');
            $("#cust4").css('display','inline');
            $("#cust5").css('display','inline');
            $("#cust6").css('display','inline');
        }else if(type == "P"){
            $("#per1").css('display','inline');
            $("#per2").css('display','inline');
//            $("#per3").css('display','inline');
//            $("#per4").css('display','inline');

            $("#cust1").css('display','none');
            $("#cust2").css('display','none');
            $("#cust3").css('display','none');
            $("#cust4").css('display','none');
            $("#cust5").css('display','none');
            $("#cust6").css('display','none');
        }
    }

    function doSubmit(type){
        var filepath=$("input[name='backlistFile']").val();
        if(filepath == ""){
             alert("请选择文件！");
            return false;
        }
        var fileStart=filepath.lastIndexOf(".");
        var ext=filepath.substring(fileStart,filepath.length).toUpperCase();
        if(ext != ".XLS"){
            alert("文件限于xls格式！");
            return false;
        }

        if(type == 'C'){
//            var backlistForm = document.forms['backlist'];
//            backlistForm.action = "uploadBackCust";
//            backlistForm.submit();

            $("#backlist").attr("action","uploadBackCust");
            parent.showWait();
            $("#backlist").submit();
        }else if(type == 'P'){
            $("#backlist").attr("action","uploadBackPer");
            parent.showWait();
            $("#backlist").submit();
        }
    }

    function checkAll() {
        var name = document.getElementById("all").value;
        var len = document.getElementsByName("chbox").length;
        if (name == "全选") {
            for (i = 0; i < len; i++) {
                document.getElementsByName("chbox")[i].checked = true;
                document.getElementById("all").value = "反选";
            }
        } else {
            for (i = 0; i < len; i++) {
                document.getElementsByName("chbox")[i].checked = false;
                document.getElementById("all").value = "全选";
            }
        }
    }

    function audit(){
        var len = document.getElementsByName("chbox").length;
        var type = document.getElementsByName("type").value;
        var flag = 0;
        var id = "";

        for (i = 0; i < len; i++) {
            if (document.getElementsByName("chbox")[i].checked) {
                id = id + document.getElementsByName("id")[i].value + ",";
                flag = 1
            }
        }
        if (flag == 0) {
            alert("请选择至少一条黑名单记录！");
        }

        if(flag == 1){
            window.location.href = '${createLink(controller:'backList', action:'audit', params:['type':type])}&id=' + id;
        }
    }
</script>
</body>
</html>
