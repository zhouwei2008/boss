<%@ page import="boss.BoOperator; boss.Perm; boss.BoRole; ismp.CmCustomerOperator; ismp.CmCustomer; ismp.CmCorporationInfo; boss.BoBranchCompany" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cmCorporationInfo.label', default: 'CmCorporationInfo')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>

    <table align="center" class="rigt_tebl">
        <tr>
        <th colspan="9"><g:message code="default.show.label" args="[entityName]"/></th>
      </tr>
      <tr >
        <th colspan="9" style="background:#ccc">必填信息</th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.customerNo.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">${cmCorporationInfoInstance?.customerNo}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.accountNo.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "accountNo")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.dateCreated.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font"><g:formatDate date="${cmCorporationInfoInstance?.dateCreated}" format="yyyy-MM-dd"/></span></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.type.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">${CmCustomer.typeMap[cmCorporationInfoInstance?.type]}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.status.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">${CmCustomer.statusMap[cmCorporationInfoInstance?.status]}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.customerCategory.label"/>：</td>
        <td class="${hasErrors(bean: cmCorporationInfoInstance, field: 'customerCategory', 'errors')}"><span class="rigt_tebl_font">${cmCorporationInfoInstance?cmCorporationInfoInstance.customerCategoryMap.get(cmCorporationInfoInstance.customerCategory?cmCorporationInfoInstance.customerCategory:""):""}</span></td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.registrationName.label"/>：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "registrationName")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.name.label"/>：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "name")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.adminEmail.label"/>：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${CmCustomerOperator.findWhere(roleSet:'1',status: 'normal',customer: cmCorporationInfoInstance)?.defaultEmail}</span></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.taxRegistrationNo.label"/>：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "taxRegistrationNo")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.organizationCode.label"/>：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "organizationCode")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.companyWebsite.label"/>：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "companyWebsite")}</span></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.businessLicenseCode.label"/>：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "businessLicenseCode")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.registrationDate.label"/>：</td>
        <td colspan = "2"><span class="rigt_tebl_font"><g:formatDate date="${cmCorporationInfoInstance?.registrationDate}" format="yyyy-MM-dd"/></span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.licenseExpires.label"/>：</td>
        <td colspan = "2"><span class="rigt_tebl_font"><g:formatDate date="${cmCorporationInfoInstance?.licenseExpires}" format="yyyy-MM-dd"/></span></td>
      </tr>



      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.belongToBusiness.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">
            %{--${fieldValue(bean: cmCorporationInfoInstance, field: "belongToBusiness")}--}%
           ${CmCorporationInfo.belongToBusinessMap[cmCorporationInfoInstance?.belongToBusiness]}
        </span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.belongToSale.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "belongToSale")}</span></td>

        <td class="right label_name"><g:message code="cmCorporationInfo.branchCompany.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">
            <g:if test="${cmCorporationInfoInstance?.branchCompany==~/[0-9]+/}">
                    ${cmCorporationInfoInstance?.branchCompany?BoBranchCompany.get(cmCorporationInfoInstance?.branchCompany)?.companyName:''}
                    </g:if>
                <g:else>
                      ${cmCorporationInfoInstance?.branchCompany}
                </g:else>
        </span></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.belongToArea.label"/>：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "belongToArea")}</span></td>
        <td class="right label_name">商户风险等级：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${CmCorporationInfo.gradeMap[cmCorporationInfoInstance?.grade]}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.fraudcheck.label"/>：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${CmCorporationInfo.fraudcheckMap[cmCorporationInfoInstance?.fraud_check]}</span></td>
      </tr>
         <tr>
        <td class="right label_name">支付单笔交易限额(元)：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "qutor")}</span></td>
        <td class="right label_name">支付单日累计交易限额(元)：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "dayQutor")}</span></td>
        <td class="right label_name">支付单月累计交易限额(元)：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "monthQutor")}</span></td>
      </tr>
        <tr>
        <td class="right label_name">支付单日交易笔数：</td>
        <td colspan = "8"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "qutorNum")}</span></td>
      </tr>

    <tr>
        <td class="right label_name">法定代表人：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${cmCorporationInfoInstance?.legal}</span></td>
        <td class="right label_name">有效证件：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${CmCorporationInfo.identityTypeMap[cmCorporationInfoInstance.identityType]}</span></td>
        <td class="right label_name">证件号码：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${cmCorporationInfoInstance?.identityNo}</span></td>
    </tr>


    <tr>
        <td class="right label_name">有效期限：</td>
        <td colspan = "2"><span class="rigt_tebl_font"><g:formatDate date="${cmCorporationInfoInstance?.validTime}" format="yyyy-MM-dd"/></span></td>
        <td class="right label_name">证件正面照：</td>
        <td colspan = "2">
              <span class="rigt_tebl_font">${cmCorporationInfoInstance?.idPositivePhoto}</span>
              <span class="rigt_tebl_font">
                  <g:if test="${cmCorporationInfoInstance?.idPositiveReview == 'pass'}">
                   审核通过
                  </g:if>
                  <g:elseif test="${cmCorporationInfoInstance?.idPositiveReview == 'refuse'}">
                   审核拒绝
                  </g:elseif>
                  <g:else>
                  等待审核
                  </g:else>
              </span>
        </td>
        <td class="right label_name">证件背面照：</td>
        <td colspan = "2">
            <span class="rigt_tebl_font">${cmCorporationInfoInstance?.idOppositePhoto}</span>
            <span class="rigt_tebl_font">
                <g:if test="${cmCorporationInfoInstance?.idOppositeReview == 'pass'}">
                    审核通过
                </g:if>
                <g:elseif test="${cmCorporationInfoInstance?.idOppositeReview == 'refuse'}">
                    审核拒绝
                </g:elseif>
                <g:else>
                    等待审核
                </g:else>
            </span>
        </td>
    </tr>

    <tr>
        <td class="right label_name">营业执照：</td>
        <td colspan = "2">
            <span class="rigt_tebl_font">${cmCorporationInfoInstance?.businessLicensePhoto}</span>
            <span class="rigt_tebl_font">
                <g:if test="${cmCorporationInfoInstance?.businessLicenseReview == 'pass'}">
                    审核通过
                </g:if>
                <g:elseif test="${cmCorporationInfoInstance?.businessLicenseReview == 'refuse'}">
                    审核拒绝
                </g:elseif>
                <g:else>
                    等待审核
                </g:else>
            </span>
        </td>
        <td class="right label_name">税务登记照：</td>
        <td colspan = "2">
             <span class="rigt_tebl_font">${cmCorporationInfoInstance?.taxRegistrationPhoto}</span>
             <span class="rigt_tebl_font">
                 <g:if test="${cmCorporationInfoInstance?.taxRegistrationReview =='pass'}">
                     审核通过
                 </g:if>
                 <g:elseif test="${cmCorporationInfoInstance?.taxRegistrationReview == 'refuse'}">
                     审核拒绝
                 </g:elseif>
                 <g:else>
                     等待审核
                 </g:else>
             </span>
        </td>
        <td class="right label_name">控股股东：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${cmCorporationInfoInstance?.controlling}</span></td>
    </tr>

      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.businessScope.label"/>：</td>
        <td colspan = "8"><span class="rigt_tebl_font">${cmCorporationInfoInstance?.businessScope}</span></td>
      </tr>

       <!--update sunweiguo 2012-06-18 增加执照是否到期提示-->
      <tr>
        <td class="right label_name">${message(code:'是否提示执照到期',default:'是否提示执照到期')}：</td>
        <td colspan = "8"><span class="rigt_tebl_font"><g:formatBoolean boolean="${cmCorporationInfoInstance?.isViewDate}"/></span></td>
      </tr>



      <tr >
        <th colspan="9" style="background:#ccc">联系信息</th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.officeLocation.label"/>：</td>
        <td colspan="3"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "officeLocation")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.companyPhone.label"/>：</td>
        <td colspan="1"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "companyPhone")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.zipCode.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "zipCode")}</span></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.bizMan.label"/>：</td>
        <td><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "bizMan")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.bizMPhone.label"/>：</td>
        <td><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "bizMPhone")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.bizPhone.label"/>：</td>
        <td><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "bizPhone")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.bizEmail.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "bizEmail")}</span></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.techMan.label"/>：</td>
        <td><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "techMan")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.techMPhone.label"/>：</td>
        <td><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "techMPhone")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.techPhone.label"/>：</td>
        <td><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "techPhone")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.techEmail.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "techEmail")}</span></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.financeMan.label"/>：</td>
        <td><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "financeMan")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.financeMPhone.label"/>：</td>
        <td><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "financeMPhone")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.financePhone.label"/>：</td>
        <td><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "financePhone")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.financeEmail.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "financeEmail")}</span></td>
      </tr>


      <tr >
        <th colspan="9" style="background:#ccc">发票信息</th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.needInvoice.label"/>：</td>
        <td colspan="8"><span class="rigt_tebl_font"><g:formatBoolean boolean="${cmCorporationInfoInstance?.needInvoice}"/></span></td>
      </tr>

      <tr >
        <th colspan="9" style="background:#ccc">扩展信息</th>
      </tr>
      <tr >
        <td class="right label_name"><g:message code="cmCorporationInfo.registeredPlace.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "registeredPlace")}</span></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.registeredFunds.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "registeredFunds")}</span></td>
        <td class="right label_name"></td>
        <td colspan="2"><span class="rigt_tebl_font"></span></td>
      </tr>
      <tr >
        <td class="right label_name"><g:message code="cmCorporationInfo.numberOfStaff.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "numberOfStaff")}</span></td>
        <td style="width:10%" class="right label_name"><g:message code="cmCorporationInfo.expectedTurnoverOfYear.label"/>：</td>
        <td colspan="2"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "expectedTurnoverOfYear")}</span></td>
        <td class="right label_name"></td>
        <td colspan="2" ></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.note.label"/>：</td>
        <td colspan="8"><span class="rigt_tebl_font">${fieldValue(bean: cmCorporationInfoInstance, field: "note")}</span></td>
      </tr>

      <tr>
        <td class="right label_name">审核状态：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${CmCorporationInfo.checkStatusMap[cmCorporationInfoInstance?.checkStatus]}</span></td>
        <td class="right label_name">接入方式：</td>
        <td colspan = "2"><span class="rigt_tebl_font">${CmCorporationInfo.accessModeMap[cmCorporationInfoInstance?.accessMode]}</span></td>
        <td class="right label_name"></td>
        <td colspan = "2"></td>
      </tr>
      <tr>
        <td colspan="9" align="center">
          <g:form>
                    <g:hiddenField name="id" value="${cmCorporationInfoInstance?.id}"/>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <g:if test="${cmCorporationInfoInstance?.status!='deleted'}">
                        <g:if test="${flag!=1}">
                            <span class="button">
                                <bo:hasPerm perm="${Perm.Cust_Corp_Edit}"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></bo:hasPerm>
                            </span>
                        </g:if>
                    </g:if>
                </g:form>
        </td>
      </tr>



    </table>

</div>
</body>
</html>