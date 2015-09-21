
<%@ page import="boss.BoAdjustType; boss.Perm; boss.BoAccountAdjustInfo" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boAccountAdjustInfo.label', default: 'BoAccountAdjustInfo')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<style>
    /*字符串截取*/
.aa{width:50px;height:24px;line-height:24px;overflow:hidden;margin:0px;color:#666;display:block;padding-left:55px}
</style>
<script type="text/javascript">
  $(function() {
    $("#startSponsorTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#endSponsorTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });

  function checkTime()
  {
      var sTime = document.getElementById("startSponsorTime").value;
      var eTime = document.getElementById("endSponsorTime").value;
      if(sTime!="" && eTime!="")
      {
          var vsTime = Date.parse(sTime.toString().substring(0,4)+"/"+sTime.toString().substring(5,7)+"/"+sTime.toString().substring(8,10));
          var veTime = Date.parse(eTime.toString().substring(0,4)+"/"+eTime.toString().substring(5,7)+"/"+eTime.toString().substring(8,10));
          if(vsTime>veTime)
          {
              alert("发起开始时间不能大于发起结束时间");
              return false;
          }else{
              return true;
          }
      }
  }

     /*---guonan update 2011-12-30----*/
    function checkDate() {
        var startDateCreated = document.getElementById('startSponsorTime').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endSponsorTime').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('发起开始时间不能大于发起结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
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
    <div class="message">${flash.message}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
    <div class="table_serch">
        <table>
        <g:form action="list">
            <tr>
                <td>调账发起时间：</td><td><g:textField name="startSponsorTime" value="${params.startSponsorTime}" size="10"  onchange="checkDate()" class="right_top_h2_input" style="width:80px"/>--<g:textField name="endSponsorTime" value="${params.endSponsorTime}" size="10"  onchange="checkDate()" class="right_top_h2_input" style="width:80px"/></td>
                <td>调账金额：</td><td><g:textField name="startAdjustAmount" value="${params.startAdjustAmount}" size="10" class="right_top_h2_input" style="width:80px"/>--<g:textField name="endAdjustAmount" value="${params.endAdjustAmount}" size="10" class="right_top_h2_input" style="width:80px"/></td>
                <td>状态：</td><td><p><g:select name="status" from="${BoAccountAdjustInfo.statusMap}" optionKey="key" optionValue="value" value="${params.status}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/></p></td>
            </tr>
            <tr>
                <td>调出账号：</td><td><g:textField name="fromAccountNo" value="${params.fromAccountNo}" class="right_top_h2_input" style="width:120px"/></td>
                <td>调入账号：</td><td><g:textField name="toAccountNo" value="${params.toAccountNo}" class="right_top_h2_input" style="width:120px"/></td>
                <td>发起人：</td><td><p><g:textField name="sponsor" value="${params.sponsor}" class="right_top_h2_input" style="width:120px"/></p></td>
            </tr>
            <tr>
                <td>调出账号名称：</td><td><g:textField name="fromAccountName" value="${params.fromAccountName}" class="right_top_h2_input" style="width:120px"/></td>
                <td>调入账号名称：</td><td><g:textField name="toAccountName" value="${params.toAccountName}" class="right_top_h2_input" style="width:120px"/></td>
                <td>单页展示数量：</td><td><p><g:select name="max" from="${BoAccountAdjustInfo.pageMap}" optionKey="key" optionValue="value" value="${params.max}" class="right_top_h2_input"/></p></td>
            </tr>
            <tr>
                <td>调账类型：</td><td><p><g:select name="boAdjustType" from="${adjTypeList}" optionKey="id" optionValue="name" value="${params.boAdjustType}" class="right_top_h2_input" noSelection="${['-1':'----请选择----']}"/></p></td>
                <td></td><td></td>
                <td></td><td></td>
            </tr>
            <tr>
                <td>
                    <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkDate()"/>
                </td>
                <td>
                <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
                </td>
                <td>
                    <bo:hasPerm perm="${Perm.Account_TransChk_Dl}">
                        <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()"/>
                    </bo:hasPerm>
                </td>
                <td>&nbsp;</td>
            </tr>
        </g:form>
        </table>
    </div>
    <table class="right_list_table" width="100%">
      <tr>
        <th>序号</th>

        <g:sortableColumn params="${params}"  property="SPONSOR_TIME" title="${message(code: 'boAccountAdjustInfo.sponsorTime.label', default: 'sponsorTime')}"/>

        <th>调账类型</th>

        <g:sortableColumn params="${params}"  property="FROM_ACCOUNT_NO" title="${message(code: 'boAccountAdjustInfo.fromAccountNo.label', default: 'From Account No')}"/>

        <th>调出账号名称</th>
        
        <g:sortableColumn params="${params}"  property="TO_ACCOUNT_NO" title="${message(code: 'boAccountAdjustInfo.toAccountNo.label', default: 'To Account No')}"/>

        <th>调入账号名称</th>
        
        <g:sortableColumn params="${params}"  property="ADJUST_AMOUNT" title="${message(code: 'boAccountAdjustInfo.adjustAmount.label', default: 'Adjust Amount')}"/>

        <g:sortableColumn params="${params}"  property="SPONSOR" title="${message(code: 'boAccountAdjustInfo.sponsor.label', default: 'sponsor')}"/>

        <g:sortableColumn params="${params}"  property="SIP" title="${message(code: 'boAccountAdjustInfo.sIP.label', default: 'sIP')}"/>

        <g:sortableColumn params="${params}"  property="STATUS" title="${message(code: 'boAccountAdjustInfo.status.label', default: 'Status')}"/>

        <g:sortableColumn params="${params}"  property="APPROVE_PERSON" title="${message(code: 'boAccountAdjustInfo.approvePerson.label', default: 'approvePerson')}"/>

        <th>审核时间</th>

        <g:sortableColumn params="${params}"  property="REMARK" title="${message(code: 'boAccountAdjustInfo.remark.label', default: 'Remark')}"/>

        <th>操作</th>

      </tr>

      <g:each in="${boAccountAdjustInfoInstanceList}" status="i" var="item">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
          <td width="3%">${i+1}</td>

          <td width="10%"><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${item.SPONSOR_TIME}"/></td>

          <td width="6%">${BoAdjustType.get((item.ADJ_TYPE ? item.ADJ_TYPE : 0) as long)?.name}</td>

          <td width="10%">${item.FROM_ACCOUNT_NO}</td>

          <td width="8%">${account.AcAccount.findByAccountNo(item.FROM_ACCOUNT_NO)?.accountName}</td>
          
          <td width="10%">${item.TO_ACCOUNT_NO}</td>

          <td width="8%">${account.AcAccount.findByAccountNo(item.TO_ACCOUNT_NO)?.accountName}</td>
          
          <td width="3%"><g:formatNumber number="${item.ADJUST_AMOUNT/100}" type="currency" currencyCode="CNY"/></td>

          <td width="4%">${item.SPONSOR}</td>

          <td width="8%">${item.SIP}</td>

          <td width="3%">${BoAccountAdjustInfo.statusMap[item.STATUS]}</td>

          <td width="4%">${item.APPROVE_PERSON}</td>

          <td width="10%"><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${item.APPROVE_TIME}"/></td>

          <td width="10%" style="text-align:left">${item.REMARK}</td>

          <td width="3%">
              <bo:hasPerm perm="${Perm.Account_TransChk_View}"><g:link action="show" id="${item.ID}">详细</g:link></bo:hasPerm>
          </td>

        </tr>
      </g:each>
    </table>
     合计：调账金额总计：<g:formatNumber number="${totalAdjust/100}" format="#.##"/>元
    <div class="paginateButtons">
      <span style=" float:left;">共${boAccountAdjustInfoInstanceTotal}条记录</span>
      <g:paginat total="${boAccountAdjustInfoInstanceTotal}" params="${params}"/>
    </div>
  </div>
</div>
</body>
</html>