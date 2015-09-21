
<%@ page import="boss.Perm; ismp.AcquireAccountTrade; ismp.AcquireSynResult;boss.BoBankDic" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
    <g:javascript library="My97DatePicker/WdatePicker"/>
</head>
<body>
<script type="text/javascript">
    function check() {
        if (document.getElementById("selectBank").value.length == 0) {
            alert("请选择银行名称!");
            document.getElementById("selectBank").focus();
            return false;
        }
    }
     function empty() {
         document.getElementById('beginTime').value='';
         document.getElementById('endTime').value='';
         document.getElementById('selectBank').value='';
         return false;
    }
</script>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:if test="${msg}">
    <div class="message">${msg}</div>
  </g:if>
  <g:if test="${err}">
    <div class="errors">${err}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="acquireAccountTrade.label" args="[entityName]"/></h1>
   <g:form>
	<div class="table_serch">
            <table>
                    <tr>
                        <td>${message(code: 'acquireAccountTrade.synDate.label', default: 'synDate')}:</td>
                        <td>
                            <input name="beginTime" id="beginTime" class='Wdate' type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'endTime\')}'})" value="${params.beginTime}" />
                            --<input name="endTime" id="endTime" class='Wdate' type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'beginTime\')}'})" value="${params.endTime}" />
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>${message(code: 'acquireAccountTrade.bankCode.label', default: 'bankCode')}:</td>
                        <td>
                            <g:select id ="selectBank" name="bankCode" from="${banks}" value="${params.bankCode}" optionKey="code" optionValue="name" noSelection="${['':'--请选择--']}"  style="width:150px"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="5">
                            <g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询"/>
                            <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
                            <bo:hasPerm perm="${Perm.Gworder_AccountTrade_DownLoad}"><g:actionSubmit class="right_top_h2_button_download" action="download" value="下载" /></bo:hasPerm>
                        </td>
                    </tr>
            </table>
        </div>
            <bo:hasPerm perm="${Perm.Gworder_AccountTrade_UpLoad}">
                <div class="button_menu">
                   <g:actionSubmit class="right_top_h2_button_tj" action="upfile" value="${message(code: 'acquireAccountTrade.upfile.label', default: 'upfile')}"/>
                </div>
            </bo:hasPerm>
        </g:form>
   <div class="right_list_tablebox">
    <table align="center" class="right_list_table" id="test">
      <tr>
        <g:sortableColumn params="${params}"  property="bankCode" title="${message(code: 'acquireAccountTrade.bankCode.label', default: 'bankCode')}"/>
        <g:sortableColumn params="${params}"  property="bankAccountNo" title="${message(code: 'acquireAccountTrade.bankAccountNo.label', default: 'bankAccountNo')}"/>
        <g:sortableColumn params="${params}"  property="acquireMerchant" title="${message(code: 'acquireAccountTrade.acquireMerchant.label', default: 'acquireMerchant')}"/>
        <g:sortableColumn params="${params}"  property="synDateFrom" title="${message(code: 'acquireAccountTrade.synDateFrom.label', default: 'synDateFrom')}"/>
        <g:sortableColumn params="${params}"  property="synDateTo" title="${message(code: 'acquireAccountTrade.synDateTo.label', default: 'synDateTo')}"/>
        <g:sortableColumn params="${params}"  property="createDate" title="${message(code: 'acquireAccountTrade.createDate.label', default: 'createDate')}"/>
        <g:sortableColumn params="${params}"  property="successNum" title="${message(code: 'acquireAccountTrade.successNum.label', default: 'successNum')}"/>
        <g:sortableColumn params="${params}"  property="successAmount" title="${message(code: 'acquireAccountTrade.successAmount.label', default: 'successAmount')}"/>
        <g:sortableColumn params="${params}"  property="overNum" title="${message(code: 'acquireAccountTrade.overNum.label', default: 'overNum')}"/>
        <g:sortableColumn params="${params}"  property="overAmount" title="${message(code: 'acquireAccountTrade.overAmount.label', default: 'overAmount')}"/>
        <g:sortableColumn params="${params}"  property="shortNum" title="${message(code: 'acquireAccountTrade.shortNum.label', default: 'shortNum')}"/>
        <g:sortableColumn params="${params}"  property="shortAmount" title="${message(code: 'acquireAccountTrade.shortAmount.label', default: 'shortAmount')}"/>
        <g:sortableColumn params="${params}"  property="disNum" title="${message(code: 'acquireAccountTrade.disNum.label', default: 'disNum')}"/>
        <g:sortableColumn params="${params}"  property="disAmount" title="${message(code: 'acquireAccountTrade.disAmount.label', default: 'disAmount')}"/>
        <g:sortableColumn params="${params}"  property="otherNum" title="${message(code: 'acquireAccountTrade.otherNum.label', default: 'otherNum')}"/>
        <g:sortableColumn params="${params}"  property="otherAmount" title="${message(code: 'acquireAccountTrade.otherAmount.label', default: 'otherAmount')}"/>
        <g:sortableColumn params="${params}"  property="synOp" title="${message(code: 'acquireAccountTrade.synOp.label', default: 'synOp')}"/>
        <g:sortableColumn params="${params}"  property="batchnum" title="${message(code: 'acquireAccountTrade.batchnum.label', default: 'batchnum')}"/>
      </tr>

      <g:each in="${acquireSynResultList}" status="i" var="instance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td>${BoBankDic.findByCode(instance.bankCode)?.name}</td>
          <td>${fieldValue(bean: instance, field: "bankAccountNo")}</td>
          <td>${fieldValue(bean: instance, field: "acquireMerchant")}</td>
          <td><g:formatDate date="${instance.synDateFrom}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td><g:formatDate date="${instance.synDateTo}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <td><g:formatDate date="${instance.createDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
          <g:if test="${bo.hasPerm(perm:Perm.Gworder_AccountTrade_Detail_View){true}}">
          <td>
               <g:if test="${instance.successNum!=null&&instance.successNum!=0}">
                   <g:link action="detailList" params="[synSts:0,batchnum:instance.batchnum,fbankCode:params.bankCode,foffset:params.offset,fmax:params.max,fbeginTime:params.beginTime,fendTime:params.endTime]">${instance.successNum}</g:link>
               </g:if>
              <g:else>0</g:else>
          </td>
          <td><g:formatNumber number="${instance.successAmount?(instance.successAmount as Double)/100:0.00}" format="#.##"/></td>
          <td>
              <g:if test="${instance.overNum!=null&&instance.overNum!=0}"><g:link action="detailList" params="[synSts:1,batchnum:instance.batchnum,fbankCode:params.bankCode,foffset:params.offset,fmax:params.max,fbeginTime:params.beginTime,fendTime:params.endTime]">${instance.overNum}</g:link></g:if>
              <g:else>0</g:else>
          </td>
          <td><g:formatNumber number="${instance.overAmount?(instance.overAmount as Double)/100:0.00}" format="#.##"/></td>
          <td>
              <g:if test="${instance.shortNum!=null&&instance.shortNum!=0}"><g:link action="detailList" params="[synSts:2,batchnum:instance.batchnum,fbankCode:params.bankCode,foffset:params.offset,fmax:params.max,fbeginTime:params.beginTime,fendTime:params.endTime]">${instance.shortNum}</g:link></g:if>
              <g:else>0</g:else>
          </td>
          <td><g:formatNumber number="${instance.shortAmount?(instance.shortAmount as Double)/100:0.00}" format="#.##"/></td>
          <td>
              <g:if test="${instance.disNum!=null&&instance.disNum!=0}"><g:link action="detailList" params="[synSts:3,batchnum:instance.batchnum,fbankCode:params.bankCode,foffset:params.offset,fmax:params.max,fbeginTime:params.beginTime,fendTime:params.endTime]">${instance.disNum}</g:link></g:if>
              <g:else>0</g:else>
          </td>
          <td><g:formatNumber number="${instance.disAmount?(instance.disAmount as Double)/100:0.00}" format="#.##"/></td>
          <td>
              <g:if test="${instance.otherNum!=null&&instance.otherNum!=0}"><g:link action="detailList" params="[synSts:4,batchnum:instance.batchnum,fbankCode:params.bankCode,foffset:params.offset,fmax:params.max,fbeginTime:params.beginTime,fendTime:params.endTime]">${instance.otherNum}</g:link></g:if>
              <g:else>0</g:else>
          </td>
          <td><g:formatNumber number="${instance.otherAmount?(instance.otherAmount as Double)/100:0.00}" format="#.##"/></td>
          </g:if>
           <g:else>
               <td>${instance.successNum?instance.successNum:0}</td>
               <td><g:formatNumber number="${instance.successAmount?(instance.successAmount as Double)/100:0.00}" format="#.##"/></td>
               <td>${instance.overNum?instance.overNum:0}</td>
               <td><g:formatNumber number="${instance.overAmount?(instance.overAmount as Double)/100:0.00}" format="#.##"/></td>
               <td>${instance.shortNum?instance.shortNum:0}</td>
               <td><g:formatNumber number="${instance.shortAmount?(instance.shortAmount as Double)/100:0.00}" format="#.##"/></td>
               <td>${instance.disNum?instance.disNum:0}</td>
               <td><g:formatNumber number="${instance.disAmount?(instance.disAmount as Double)/100:0.00}" format="#.##"/></td>
               <td>${instance.otherNum?instance.otherNum:0}</td>
               <td><g:formatNumber number="${instance.otherAmount?(instance.otherAmount as Double)/100:0.00}" format="#.##"/></td>
           </g:else>

          <td>${fieldValue(bean: instance, field: "synOp")}</td>
          <td>${fieldValue(bean: instance, field: "batchnum")}</td>
        </tr>
      </g:each>
    </table>
    </div>
        <div class="paginateButtons">
	    <span style=" float:left;">共${acquireSynResultInstanceTotal}条记录</span>
            <g:paginat total="${acquireSynResultInstanceTotal}" params="${params}"/>
        </div>
  </div>
</div>
</body>
</html>
