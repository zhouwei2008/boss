
<%@ page import="boss.Perm; ismp.AcquireAccountTrade;ismp.AcquireSynTrx;boss.BoBankDic" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acquireAccountTrade.detail.label', default: 'AcquireAccountTrade')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
    <g:javascript library="My97DatePicker/WdatePicker"/>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:if test="${flash.error}">
    <div class="errors">${flash.error}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="acquireAccountTrade.detail.label" args="[entityName]"/></h1>
     <g:form>
                <div class="button_menu">
                    <g:hiddenField name="synSts"  value="${params.synSts}" />
                    <g:hiddenField name="batchnum"  value="${params.batchnum}" />
                    <g:hiddenField name="fbankCode"  value="${params.fbankCode}" />
                    <g:hiddenField name="foffset"  value="${params.foffset}" />
                    <g:hiddenField name="fmax"  value="${params.fmax}" />
                    <g:hiddenField name="fbeginTime"  value="${params.fbeginTime}" />
                    <g:hiddenField name="fendTime"  value="${params.fendTime}" />
                    <g:actionSubmit class="right_top_h2_button_tj1" action="list" value="返回对账结果列表" />
                    <bo:hasPerm perm="${Perm.Gworder_AccountTrade_Detail_DownLoad}"><g:actionSubmit class="right_top_h2_button_download" action="detailDownload" value="下载" /> </bo:hasPerm>
                </div>
        </g:form>
      <div class="right_list_tablebox">
    <table align="center" class="right_list_table" id="test">
      <tr>
        <g:sortableColumn params="${params}"  property="bankCode" title="${message(code: 'acquireAccountTrade.bankCode.label', default: 'bankCode')}"/>
        <g:sortableColumn params="${params}"  property="bankAccountNo" title="${message(code: 'acquireAccountTrade.bankAccountNo.label', default: 'bankAccountNo')}"/>
        <g:sortableColumn params="${params}"  property="acquireMerchant" title="${message(code: 'acquireAccountTrade.acquireMerchant.label', default: 'acquireMerchant')}"/>
        <g:sortableColumn params="${params}"  property="trxid" title="${message(code: 'acquireAccountTrade.trxid.label', default: 'trxid')}"/>
        <g:sortableColumn params="${params}"  property="tradeNum" title="${message(code: 'acquireAccountTrade.tradeNum.label', default: 'tradeNum')}"/>
        <g:sortableColumn params="${params}"  property="acquireDate" title="${message(code: 'acquireAccountTrade.acquireDate.label', default: 'acquireDate')}"/>
        <g:sortableColumn params="${params}"  property="accountDate" title="${message(code: 'acquireAccountTrade.accountDate.label', default: 'accountDate')}"/>
        <g:sortableColumn params="${params}"  property="tradeDate" title="${message(code: 'acquireAccountTrade.tradeDate.label', default: 'tradeDate')}"/>
        <g:sortableColumn params="${params}"  property="tradeType" title="${message(code: 'acquireAccountTrade.tradeType.label', default: 'tradeType')}"/>
        <g:sortableColumn params="${params}"  property="amount" title="${message(code: 'acquireAccountTrade.amount.label', default: 'amount')}"/>
        <g:sortableColumn params="${params}"  property="tradeAmount" title="${message(code: 'acquireAccountTrade.tradeAmount.label', default: 'tradeAmount')}"/>
        <g:sortableColumn params="${params}"  property="trxsts" title="${message(code: 'acquireAccountTrade.trxsts.label', default: 'trxsts')}"/>
        <g:sortableColumn params="${params}"  property="tradeTrxsts" title="${message(code: 'acquireAccountTrade.tradeTrxsts.label', default: 'tradeTrxsts')}"/>
        <g:sortableColumn params="${params}"  property="synSts" title="${message(code: 'acquireAccountTrade.synSts.label', default: 'synSts')}"/>
        <g:sortableColumn params="${params}"  property="remarks" title="${message(code: 'acquireAccountTrade.remarks.label', default: 'remarks')}"/>
      </tr>

      <g:each in="${acquireSynTrxList}" status="i" var="instance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td>${BoBankDic.findByCode(instance.bankCode)?.name}</td>
          <td>${fieldValue(bean: instance, field: "bankAccountNo")}</td>
          <td>${fieldValue(bean: instance, field: "acquireMerchant")}</td>
          <td>${fieldValue(bean: instance, field: "trxid")}</td>
          <td>${fieldValue(bean: instance, field: "tradeNum")}</td>
          <td><g:formatDate date="${instance.acquireDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td><g:formatDate date="${instance.accountDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td><g:formatDate date="${instance.tradeDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td>支付</td>
          <td><g:formatNumber number="${instance.amount?(instance.amount as Double)/100:0.00}" format="#.##"/></td>
          <td><g:formatNumber number="${instance.tradeAmount?(instance.tradeAmount as Double)/100:0.00}" format="#.##"/></td>
          <td>${(instance.trxsts!=null&&instance.trxsts!='')?(AcquireSynTrx.trxstsMap[instance.trxsts]):''}</td>
          <td>${(instance.tradeTrxsts!=null&&instance.tradeTrxsts!='')?(AcquireSynTrx.trxstsMap[instance.tradeTrxsts]):''}</td>
          <td>${(instance.synSts!=null&&instance.synSts!='')?(AcquireSynTrx.synStsMap[instance.synSts]):''}</td>
          <td>
              <g:if test="${instance.remarks}">
                  <bo:hasPerm perm="${Perm.Gworder_AccountTrade_Detail_Remarks_View}">
                  <g:link action="showRemarks" id="${instance.id}"  params="[synSts:params.synSts,batchnum:params.batchnum,offset:params.offset,max:params.max,fbankCode:params.fbankCode,foffset:params.foffset,fmax:params.fmax,fbeginTime:params.fbeginTime,fendTime:params.fendTime]">查看
                  </g:link>
                  </bo:hasPerm>
              </g:if>
              <g:else>
                  <bo:hasPerm perm="${Perm.Gworder_AccountTrade_Detail_Remarks_New}">
                  <g:link action="editRemarks" id="${instance.id}" params="[synSts:params.synSts,batchnum:params.batchnum,offset:params.offset,max:params.max,fbankCode:params.fbankCode,foffset:params.foffset,fmax:params.fmax,fbeginTime:params.fbeginTime,fendTime:params.fendTime]">添加
                  </g:link>
                  </bo:hasPerm>
              </g:else>
          </td>
        </tr>
      </g:each>
    </table>
      </div>
        <div class="paginateButtons">
	    <span style=" float:left;">共${acquireSynTrxInstanceTotal}条记录</span>
            <g:paginat total="${acquireSynTrxInstanceTotal}" params="${params}"/>
        </div>
  </div>
</div>
</body>
</html>
