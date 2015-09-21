<%@ page import="boss.DesUtil; ismp.CmCustomer; boss.Perm; ismp.CmCorporationInfo; boss.BoBankDic; ismp.CmCustomerBankAccount" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'cmCustomerBankAccount.label', default: 'CmCustomerBankAccount')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">${customer?.name} <g:message code="default.list.label" args="[entityName]"/></h1>
    <h2>
      <g:form>
        <g:hiddenField name="customer.id" value="${customer?.id}"/>
        <g:if test="${customer instanceof CmCorporationInfo}">
          <bo:hasPerm perm="${Perm.Cust_Corp_Bank_New}" ><g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:['银行账户'])}"/></bo:hasPerm>
        </g:if>
        <g:else>
          <bo:hasPerm perm="${Perm.Cust_Per_Bank_New}" ><g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.new.label', args:['银行账户'])}"/></bo:hasPerm>
        </g:else>
      </g:form>
    </h2>
    <table align="center" class="right_list_table" id="test">
      <tr>
        <g:sortableColumn params="${params}"  property="bankNo" title="${message(code: 'cmCustomerBankAccount.bankName.label', default: 'bankNo')}"/>
        <g:sortableColumn params="${params}"  property="branch" title="${message(code: 'cmCustomerBankAccount.branch.label', default: 'Branch')}"/>
        <g:sortableColumn params="${params}"  property="subbranch" title="${message(code: 'cmCustomerBankAccount.subbranch.label', default: 'Subbranch')}"/>
        <g:sortableColumn params="${params}"  property="bankAccountNo" title="${message(code: 'cmCustomerBankAccount.bankAccountNo.label', default: 'bankAccountNo')}"/>
        <g:sortableColumn params="${params}"  property="isDefault" title="${message(code: 'cmCustomerBankAccount.isDefault.label', default: 'isDefault')}"/>
        <th>操作</th>
      </tr>

      <g:each in="${cmCustomerBankAccountInstanceList}" status="i" var="cmCustomerBankAccountInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td>${BoBankDic.findByCode(cmCustomerBankAccountInstance?.bankCode)?.name}</td>
          <td>${fieldValue(bean: cmCustomerBankAccountInstance, field: "branch")}</td>
          <td>${fieldValue(bean: cmCustomerBankAccountInstance, field: "subbranch")}</td>
          <td>
            <g:if test="${customer instanceof CmCorporationInfo}">
              <g:if test="${bo.hasPerm(perm:Perm.Cust_Corp_Bank_View){true}}" >
                  <g:link action="show" id="${cmCustomerBankAccountInstance.id}">
                     ${DesUtil.decrypt(cmCustomerBankAccountInstance.bankAccountNo,cmCustomerBankAccountInstance.customer.customerNo)}
                  </g:link>
              </g:if>
              <g:else>
                    ${DesUtil.decrypt(cmCustomerBankAccountInstance.bankAccountNo,cmCustomerBankAccountInstance.customer.customerNo)}
              </g:else>
            </g:if>
            <g:else>
              <g:if test="${bo.hasPerm(perm:Perm.Cust_Per_Bank_View){true}}" >
                  <g:link action="show" id="${cmCustomerBankAccountInstance.id}">
                      ${DesUtil.decrypt(cmCustomerBankAccountInstance.bankAccountNo,cmCustomerBankAccountInstance.customer.customerNo)}
                  </g:link>
              </g:if>
              <g:else>
                     ${DesUtil.decrypt(cmCustomerBankAccountInstance.bankAccountNo,cmCustomerBankAccountInstance.customer.customerNo)}
              </g:else>
            </g:else>
          </td>
          <td>${cmCustomerBankAccountInstance?.isDefault ? '默认' : '否'}</td>
          <td>
            <g:if test="${customer instanceof CmCorporationInfo}">
              <bo:hasPerm perm="${Perm.Cust_Corp_Bank_Default}" ><input type="button" onclick="window.location.href = '${createLink(controller:'cmCustomerBankAccount', action:'setDefault', params:['id':cmCustomerBankAccountInstance?.id, 'customer.id':customer?.id])}'" value="设为默认账户"/></bo:hasPerm>
            </g:if>
            <g:else>
              <bo:hasPerm perm="${Perm.Cust_Per_Bank_Default}" ><input type="button" onclick="window.location.href = '${createLink(controller:'cmCustomerBankAccount', action:'setDefault', params:['id':cmCustomerBankAccountInstance?.id, 'customer.id':customer?.id])}'" value="设为默认账户"/></bo:hasPerm>
            </g:else>
          </td>
        </tr>
      </g:each>
    </table>

    <div class="paginateButtons">
      <span style=" float:left;">共${cmCustomerBankAccountInstanceTotal}条记录</span>
      <g:paginat total="${cmCustomerBankAccountInstanceTotal}" params="${params}"/>
    </div>
    <div class="paginateButtons">
    <span class="button">
      <g:if test="${customer instanceof CmCorporationInfo}">
        %{--<input type="button" class="rigt_button" onclick="window.location.href = '${createLink(controller:'cmCorporationInfo')}'" value="返回"/></span>--}%
          <input type="button" class="rigt_button" onclick="history.go(-1)" value="返回"/></span>
      </g:if>
      <g:else>
        %{--<input type="button" class="rigt_button" onclick="window.location.href = '${createLink(controller:'cmPersonalInfo')}'" value="返回"/></span>--}%
          <input type="button" class="rigt_button" onclick="history.go(-1)" value="返回"/></span>
      </g:else>
    </span>
    </div>
  </div>
</div>
</body>
</html>
