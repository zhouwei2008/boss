<%@ page import="boss.BoOperator; ismp.CmCustomerOperator; ismp.CmCustomer; ismp.CmCorporationInfo; boss.BoBranchCompany" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'cmCorporationInfo.label', default: 'CmCorporationInfo')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <g:hasErrors bean="${cmCorporationInfoInstance}">
    <div class="errors">
      <g:renderErrors bean="${cmCorporationInfoInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" name="saveForm" method="post" enctype="multipart/form-data">
      <g:hiddenField name="appId" value="${params.appId}"/>
    <table align="center" class="rigt_tebl" style="border:none">
      <tr>
        <th colspan="9"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>

      <tr >
        <th colspan="9" style="background:#ccc" >必填信息</th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.registrationName.label"/><font color="red">*</font>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'registrationName', 'errors')}"><g:textField name="registrationName" maxlength="32" value="${params.registrationName}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.name.label"/><font color="red">*</font> ：</td>
        <td colspan = "2"class="${hasErrors(bean: cmCorporationInfoInstance, field: 'name', 'errors')}"><g:textField name="name" maxlength="32" value="${cmCorporationInfoInstance?.name}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.adminEmail.label"/><font color="red">*</font>：</td>
        <td colspan = "2"><g:textField name="defaultEmail" maxlength="50" value="${params?params.defaultEmail:''}"/></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.taxRegistrationNo.label"/><font color="red">*</font>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'taxRegistrationNo', 'errors')}"><g:textField name="taxRegistrationNo" maxlength="20" value="${cmCorporationInfoInstance?.taxRegistrationNo}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.organizationCode.label"/><font color="red">*</font>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'organizationCode', 'errors')}"><g:textField name="organizationCode" maxlength="20" value="${cmCorporationInfoInstance?.organizationCode}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.companyWebsite.label"/><font color="red">*</font>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'companyWebsite', 'errors')}"><g:textField name="companyWebsite" maxlength="50" value="${params.companyWebsite}"/></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.status.label"/>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'status', 'errors')}"><g:select name="status" from="['init': '受限']" value="init" optionKey="key" optionValue="value"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.customerCategory.label"/>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'customerCategory', 'errors')}"><g:select name="customerCategory" from="${CmCustomer.customerCategoryMap}" value="${cmCorporationInfoInstance?.customerCategory}" optionKey="key" optionValue="value"/></td>
          <td class="right label_name"><g:message code="cmCorporationInfo.fraudcheck.label"/>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'fraud_check', 'errors')}"><g:select name="fraud_check" from="${CmCorporationInfo.fraudcheckMap}" value="${cmCorporationInfoInstance?.fraud_check}" optionKey="key" optionValue="value"/></td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.businessLicenseCode.label"/><font color="red">*</font>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'businessLicenseCode', 'errors')}"><g:textField name="businessLicenseCode" maxlength="20" value="${cmCorporationInfoInstance?.businessLicenseCode}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.registrationDate.label"/>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'registrationDate', 'errors')}"><bo:datePicker name="registrationDate" precision="day" value="${cmCorporationInfoInstance?.registrationDate}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.licenseExpires.label"/>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'licenseExpires', 'errors')}"><bo:datePicker name="licenseExpires" precision="day" value="${cmCorporationInfoInstance?.licenseExpires}"/></td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.belongToBusiness.label"/><font color="red">*</font>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'belongToBusiness', 'errors')}">
            %{--<g:textField name="belongToBusiness" maxlength="20" value="${params.belongToBusiness}"/>--}%
            <g:select name="belongToBusiness" from="${CmCorporationInfo.belongToBusinessMap}" optionKey="key" optionValue="value"  style="width:170px"  noSelection="${['':'-请选择-']}" value="${cmCorporationInfoInstance?.belongToBusiness}"/>
        </td>

        <td class="right label_name"><g:message code="cmCorporationInfo.belongToSale.label"/><font color="red">*</font>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'belongToSale', 'errors')}"><g:textField name="belongToSale" maxlength="20" value="${cmCorporationInfoInstance?.belongToSale}"/></td>

        <td class="right label_name"><g:message code="cmCorporationInfo.branchCompany.label"/><font color="red">*</font>：</td>
        <td colspan="2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'branchCompany', 'errors')}">
	        <g:select name="branchCompany" from="${BoBranchCompany.list()}" optionKey="id" optionValue="companyName"  style="width:170px"  noSelection="${['':'-请选择-']}" value="${cmCorporationInfoInstance?.branchCompany}"/>
	    </td>
      </tr>
          <tr>
        <td class="right label_name">支付单笔交易限额(元)<font color="red">*</font>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'qutor', 'errors')}"><g:textField name="qutor" maxlength="20"  onkeyup="this.value=this.value.replace(/[^\\d]/g,'')" onblur="value=value.replace(/[^\\d]/g,'')" onafterpaste="this.value=this.value.replace(\\[^d]/g,'')" value="${cmCorporationInfoInstance.qutor}"/></td>

        <td class="right label_name">支付单日累计交易限额(元)<font color="red">*</font>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'dayQutor', 'errors')}"><g:textField name="dayQutor" maxlength="20" onkeyup="this.value=this.value.replace(/[^\\d]/g,'')" onblur="value=value.replace(/[^\\d]/g,'')" onafterpaste="this.value=this.value.replace(\\[^d]/g,'')"  value="${cmCorporationInfoInstance?.dayQutor}"/></td>

        <td class="right label_name">支付单月累计交易限额(元)<font color="red">*</font>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'monthQutor', 'errors')}"><g:textField name="monthQutor" maxlength="20" onkeyup="this.value=this.value.replace(/[^\\d]/g,'')" onblur="value=value.replace(/[^\\d]/g,'')" onafterpaste="this.value=this.value.replace(\\[^d]/g,'')"  value="${cmCorporationInfoInstance?.monthQutor}"/></td>
      </tr>
      <tr>
        <td class="right label_name">支付单日交易笔数<font color="red">*</font>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'qutorNum', 'errors')}"><g:textField name="qutorNum" maxlength="20" onkeyup="this.value=this.value.replace(/[^\\d]/g,'')" onblur="value=value.replace(/[^\\d]/g,'')" onafterpaste="this.value=this.value.replace(\\[^d]/g,'')"  value="${cmCorporationInfoInstance?.qutorNum}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.belongToArea.label"/><font color="red">*</font>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'belongToArea', 'errors')}"><g:textField name="belongToArea" maxlength="200" value="${params.belongToArea}"/></td>
        <td class="right label_name">商户等级<font color="red">*</font>：</td>
        <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'grade', 'errors')}"><g:select name="grade" from="${CmCorporationInfo.gradeMap}" value="${cmCorporationInfoInstance?.grade}" optionKey="key" optionValue="value" noSelection="${['':'--请选择--']}"/></td>
      </tr>

        <tr>
            <td class="right label_name">法定代表人<font color="red">*</font>：</td>
            <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'legal', 'errors')}"><g:textField name="legal" maxlength="20" value="${cmCorporationInfoInstance.legal}"/></td>
            <td class="right label_name">有效证件：</td>
            <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'identityType', 'errors')}"><g:select name="identityType" from="${CmCorporationInfo.identityTypeMap}" optionKey="key" optionValue="value"/></td>
            <td class="right label_name">证件号码<font color="red">*</font>：</td>
            <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'identityNo', 'errors')}"><g:textField name="identityNo" maxlength="20"  onkeyup="this.value=this.value.replace(/[^\\w]/g,'')" onblur="value=value.replace(/[^\\w]/g,'')" onpaste="this.value=this.value.replace(/[^\\w]/g,'')" value="${cmCorporationInfoInstance.identityNo}"/></td>
        </tr>

        <tr>
            <td class="right label_name">有效期限：</td>
            <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'validTime', 'errors')}"><bo:datePicker name="validTime" precision="day" value="${cmCorporationInfoInstance?.validTime}"/></td>
            <td class="right label_name">证件正面照：</td>
            <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'idPositivePhoto', 'errors')}"><input type="file" name="idPositivePhotoFile" id="idPositivePhotoFile" value="${cmCorporationInfoInstance?.idPositivePhoto}"/></td>
            <td class="right label_name">证件背面照：</td>
            <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'idOppositePhoto', 'errors')}"><input type="file" name="idOppositePhotoFile" id="idOppositePhotoFile" value="${cmCorporationInfoInstance?.idOppositePhoto}"/></td>

        </tr>

        <tr>
            <td class="right label_name">营业执照：</td>
            <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'businessLicensePhoto', 'errors')}"><input type="file" name="businessLicensePhotoFile" id="businessLicensePhotoFile" value="${cmCorporationInfoInstance?.businessLicensePhoto}"/></td>
            <td class="right label_name">税务登记照：</td>
            <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'taxRegistrationPhoto', 'errors')}"><input type="file" name="taxRegistrationPhotoFile" id="taxRegistrationPhotoFile" value="${cmCorporationInfoInstance?.taxRegistrationPhoto}"/></td>
            <td class="right label_name">控股股东：</td>
            <td colspan = "2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'controlling', 'errors')}"><g:textField name="controlling" maxlength="20" value="${cmCorporationInfoInstance.controlling}"/></td>
        </tr>

      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.businessScope.label"/><font color="red">*</font>：</td>
        <td colspan = "8" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'businessScope', 'errors')}" ><g:textArea name="businessScope"   style = "width:80%"  cols="5" rows="5" value="${cmCorporationInfoInstance?.businessScope}"/></td>
      </tr>

       <tr>
        <td class="right label_name"><p>${message(code:'是否提示执照到期',default:'是否提示执照到期')}<font color="red">*</font>：</p></td>
        <td colspan = "8" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'isViewDate', 'errors')}" ><g:checkBox name="isViewDate" value="${cmCorporationInfoInstance?.isViewDate}" /></td>
      </tr>



      <tr >
        <th colspan="9" style="background:#ccc">联系信息</th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.officeLocation.label"/><font color="red">*</font>：</td>
        <td colspan="3" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'officeLocation', 'errors')}"><g:textField style="width:97%" name="officeLocation" maxlength="200" value="${params.officeLocation}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.companyPhone.label"/>：</td>
        <td colspan="1" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'companyPhone', 'errors')}"><g:textField name="companyPhone" maxlength="20" value="${params.companyPhone}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.zipCode.label"/>：</td>
        <td colspan="2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'zipCode', 'errors')}"><g:textField name="zipCode"  onafterpaste="this.value=this.value.replace(\\[^d]/g,'')"  onblur="value=value.replace(/[\\^]|[^0-9]/g, '')" onkeyup="value=value.replace(/[\\^]|[^0-9]/g, '')"  maxlength="10" value="${params.zipCode}"/></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.bizMan.label"/><font color="red">*</font>：</td>
        <td class="${hasErrors(bean: cmCorporationInfoInstance, field: 'bizMan', 'errors')}"><g:textField name="bizMan" maxlength="32"  value="${params.bizMan}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.bizMPhone.label"/><font color="red">*</font>：</td>
        <td class="${hasErrors(bean: cmCorporationInfoInstance, field: 'bizMPhone', 'errors')}"><g:textField name="bizMPhone"  onafterpaste="this.value=this.value.replace(\\[^d]/g,'')"  onblur="value=value.replace(/[\\^]|[^0-9]/g, '')" onkeyup="value=value.replace(/[\\^]|[^0-9]/g, '')" maxlength="20" value="${params.bizMPhone}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.bizPhone.label"/>：</td>
        <td class="${hasErrors(bean: cmCorporationInfoInstance, field: 'bizPhone', 'errors')}"><g:textField name="bizPhone" maxlength="20" value="${params.bizPhone}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.bizEmail.label"/>：</td>
        <td colspan="2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'bizEmail', 'errors')}"><g:textField name="bizEmail" maxlength="30" value="${params.bizEmail}"/></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.techMan.label"/>：</td>
        <td class="${hasErrors(bean: cmCorporationInfoInstance, field: 'techMan', 'errors')}"><g:textField name="techMan" maxlength="32" value="${cmCorporationInfoInstance?.techMan}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.techMPhone.label"/>：</td>
        <td class="${hasErrors(bean: cmCorporationInfoInstance, field: 'techMPhone', 'errors')}"><g:textField name="techMPhone"  onafterpaste="this.value=this.value.replace(\\[^d]/g,'')"   onblur="value=value.replace(/[\\^]|[^0-9]/g, '')" onkeyup="value=value.replace(/[\\^]|[^0-9]/g, '')" maxlength="20" value="${cmCorporationInfoInstance?.techMPhone}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.techPhone.label"/>：</td>
        <td class="${hasErrors(bean: cmCorporationInfoInstance, field: 'techPhone', 'errors')}"><g:textField name="techPhone" maxlength="20" value="${cmCorporationInfoInstance?.techPhone}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.techEmail.label"/>：</td>
        <td colspan="2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'techEmail', 'errors')}"><g:textField name="techEmail" maxlength="30" value="${cmCorporationInfoInstance?.techEmail}"/></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.financeMan.label"/>：</td>
        <td class="${hasErrors(bean: cmCorporationInfoInstance, field: 'financeMan', 'errors')}"><g:textField name="financeMan" maxlength="32" value="${cmCorporationInfoInstance?.financeMan}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.financeMPhone.label"/>：</td>
        <td class="${hasErrors(bean: cmCorporationInfoInstance, field: 'financeMPhone', 'errors')}"><g:textField name="financeMPhone"  onafterpaste="this.value=this.value.replace(\\[^d]/g,'')" onblur="value=value.replace(/[\\^]|[^0-9]/g, '')" onblur="value=value.replace(/[\\^]|[^0-9]/g, '')"  onkeyup="value=value.replace(/[\\^]|[^0-9]/g, '')" maxlength="20" value="${cmCorporationInfoInstance?.financeMPhone}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.financePhone.label"/>：</td>
        <td class="${hasErrors(bean: cmCorporationInfoInstance, field: 'financePhone', 'errors')}"><g:textField name="financePhone" maxlength="20" value="${cmCorporationInfoInstance?.financePhone}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.financeEmail.label"/>：</td>
        <td colspan="2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'financeEmail', 'errors')}"><g:textField name="financeEmail" maxlength="30" value="${cmCorporationInfoInstance?.financeEmail}"/></td>
      </tr>



      <tr >
        <th colspan="9" style="background:#ccc">发票信息</th>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.needInvoice.label"/>：</td>
        <td colspan="8" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'needInvoice', 'errors')}"><g:checkBox name="needInvoice" value="${cmCorporationInfoInstance?.needInvoice}"/></td>
      </tr>

      <tr >
        <th colspan="9" style="background:#ccc" >扩展信息</th>
      </tr>
      <tr >
        <td class="right label_name"><g:message code="cmCorporationInfo.registeredPlace.label"/><font color="red">*</font>：</td>
        <td colspan="2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'registeredPlace', 'errors')}"><g:textField name="registeredPlace" maxlength="200" value="${cmCorporationInfoInstance?.registeredPlace}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.registeredFunds.label"/><font color="red">*</font>：</td>
        <td colspan="2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'registeredFunds', 'errors')}"><g:textField name="registeredFunds" maxlength="8" onafterpaste="this.value=this.value.replace(\\[^d]/g,'')" onblur="value=value.replace(/[\\^]|[^0-9]/g, '')" onkeyup="value=value.replace(/[\\^]|[^0-9]/g, '')"  value="${cmCorporationInfoInstance?.registeredFunds}"/></td>
        <td class="right label_name"></td>
        <td colspan="2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'corporate', 'errors')}"></td>
      </tr>
      <tr >
        <td class="right label_name"><g:message code="cmCorporationInfo.numberOfStaff.label"/>：</td>
        <td colspan="2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'numberOfStaff', 'errors')}"><g:textField name="numberOfStaff" maxlength="10" onafterpaste="this.value=this.value.replace(\\[^d]/g,'')" onblur="value=value.replace(/[\\^]|[^0-9]/g, '')" onkeyup="value=value.replace(/[\\^]|[^0-9]/g, '')" value="${fieldValue(bean: cmCorporationInfoInstance, field: 'numberOfStaff')}"/></td>
        <td class="right label_name"><g:message code="cmCorporationInfo.expectedTurnoverOfYear.label"/>：</td>
        <td colspan="2" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'expectedTurnoverOfYear', 'errors')}"><g:textField name="expectedTurnoverOfYear" maxlength="8" onafterpaste="this.value=this.value.replace(\\[^d]/g,'')" onblur="value=value.replace(/[\\^]|[^0-9]/g, '')" onkeyup="value=value.replace(/[\\^]|[^0-9]/g, '')" value="${cmCorporationInfoInstance?.expectedTurnoverOfYear}"/></td>
        <td class="right label_name"></td>
        <td colspan="2" ></td>
      </tr>
      <tr>
        <td class="right label_name"><g:message code="cmCorporationInfo.note.label"/>：</td>
        <td colspan="8" class="${hasErrors(bean: cmCorporationInfoInstance, field: 'note', 'errors')}"><g:textArea style = "width:80%" cols="40" rows="5" name="note" maxlength="128" value="${cmCorporationInfoInstance?.note}"/></td>
      </tr>


      <tr>
        <td colspan="9" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="button" onclick="onSubmit();" name="button" id="button" class="rigt_button" value="确定"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
<script type="text/javascript">

  $(function() {
    $("#saveForm").validate({
      rules: {
        businessLicenseCode:{required: true},
        registrationName:{required: true},
        name:{required: true},
        taxRegistrationNo:{required: true},
        organizationCode:{required: true},
        businessScope:{required: true},
        companyWebsite:{required: true},
        defaultEmail: {required: true, email: true},
        belongToBusiness: {required: true},
        belongToSale: {required: true},
        belongToArea: {required: true},
        branchCompany: {required: true},
        grade: {required: true},
        officeLocation:{required: true},
        isViewDate:{required: true},
        bizMan:{required: true},
        bizMPhone:{required: true},
        registeredPlace:{required: true},
        registeredFunds:{required: true},
        qutor:{required: true},
        dayQutor:{required: true},
        monthQutor:{required: true},
        qutorNum:{required: true},
        legal:{required: true},
        identityNo:{required: true},
        bizEmail:{email: true},
        techEmail:{email: true},
        financeEmail:{email: true}
      },
      focusInvalid: false,
      onkeyup: false
    });
  })

     function checkData(){

         var registrationDate_year = $("#registrationDate_year").val();
         var registrationDate_month = $("#registrationDate_month").val();
         var registrationDate_day = $("#registrationDate_day").val() > 9 ? $("#registrationDate_day").val():"0"+ $("#registrationDate_day").val();
         var registrationDate = registrationDate_year + registrationDate_month + registrationDate_day;

         var licenseExpires_year = $("#licenseExpires_year").val();
         var licenseExpires_month = $("#licenseExpires_month").val();
         var licenseExpires_day = $("#licenseExpires_day").val() > 9 ? $("#licenseExpires_day").val():"0"+ $("#licenseExpires_day").val();
         var licenseExpiresDate = licenseExpires_year + licenseExpires_month + licenseExpires_day;

         if(registrationDate > licenseExpiresDate){
             alert("执照登记时间不能大于执照有效期")
             return false;
         }

         var qutor = $("#qutor").val() - 0;//单笔交易限额
         var dayQutor = $("#dayQutor").val() - 0;//单日累计交易限额
         var monthQutor = $("#monthQutor").val() - 0;//单月累计交易限额

         if(qutor > dayQutor){
             alert("单笔交易限额不能大于单日累计交易限额");
             return false;
         }

         if(dayQutor > monthQutor){
             alert("单日累计交易限额不能大于单月累计交易限额");
             return false;
         }


         var validTime_year = $("#validTime_year").val();
         var validTime_month = $("#validTime_month").val();
         var validTime_day = $("#validTime_day").val()> 9 ? $("#validTime_day").val():"0"+ $("#validTime_day").val();
         var validTimeDate = validTime_year + validTime_month + validTime_day;

         var d=new Date(),str='';
         str +=d.getFullYear();
         str +=d.getMonth()+1 > 9 ? d.getMonth()+1 : "0"+d.getMonth()+1;
         str +=d.getDate() > 9 ? d.getDate() : "0"+d.getDate();
         if(validTimeDate < str){
              alert("证件有效期不能少于当前日期");
              return false;
         }

         var idPositivePhoto = $("#idPositivePhotoFile").val();
         var idOppositePhoto = $("#idOppositePhotoFile").val();
         var businessLicensePhoto = $("#businessLicensePhotoFile").val();
         var taxRegistrationPhoto = $("#taxRegistrationPhotoFile").val();

         var filepath = ''
         if(idPositivePhoto != null && idPositivePhoto != ''){
             filepath = idPositivePhoto;
             if(!checkSuffix(filepath,"证件正面照")){
                 return false;
             }
         }
         if(idOppositePhoto != null && idOppositePhoto != ''){
             filepath = idOppositePhoto;
             if(!checkSuffix(filepath,"证件背面照")){
                 return false;
             }
         }
         if(businessLicensePhoto != null && businessLicensePhoto != ''){
             filepath = businessLicensePhoto;
             if(!checkSuffix(filepath,"营业执照")){
                 return false;
             }
         }
         if(taxRegistrationPhoto != null && taxRegistrationPhoto != ''){
             filepath = taxRegistrationPhoto;
             if(!checkSuffix(filepath,"税务登记照")){
                 return false;
             }
         }

         $("#saveForm").submit();
     }

      function checkSuffix(filepath,msg){
          var extStart=filepath.lastIndexOf(".");
          var ext=filepath.substring(extStart,filepath.length).toUpperCase();
          if(ext!=".BMP"&&ext!=".PNG"&&ext!=".GIF"&&ext!=".JPG"&&ext!=".JPEG"){
              alert(msg+"限于bmp,png,gif,jpeg,jpg等格式");
              return false;
          }
          return true;
      }

    function onSubmit(){
        checkData();
    }
</script>
</body>
</html>
