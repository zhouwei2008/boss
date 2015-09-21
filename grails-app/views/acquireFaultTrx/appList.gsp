<%@ page import="boss.Perm; ismp.AcquireFaultTrx" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'acquireFaultTrx.label', default: 'AcquireFaultTrx')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startTrxdate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true,changeMonth: true });
        $("#endTrxdate").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#startAcquireDate").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endAcquireDate").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#startCreateDate").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endCreateDate").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
    });
    function checkStatus(str, flag) {
        if (flag == 1) {
            if (confirm("确定要审核通过！")) {
                window.location.href = '${createLink(controller:'acquireFaultTrx', action:'appPass', params:['statusFlag':'1'])}&id=' + str;
            }
        }
        if (flag == 2) {
            if (confirm("确定要审核拒绝！")) {
                window.location.href = '${createLink(controller:'acquireFaultTrx', action:'appUnpass', params:['statusFlag':'0'])}&id=' + str;
            }
        }
    }
    function checkDate() {
        var startAcquireDate = document.getElementById("startAcquireDate").value;
        var endAcquireDate = document.getElementById("endAcquireDate").value;
        var startTrxDate = document.getElementById("startTrxdate").value;
        var endTrxDate = document.getElementById("endTrxdate").value;
        var startCreateDate = document.getElementById("startCreateDate").value;
        var endCreateDate = document.getElementById("endCreateDate").value;
        if (startAcquireDate > endAcquireDate && endAcquireDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endAcquireDate").focus();
            return false;
        }
        if (startTrxDate > endTrxDate && endTrxDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endTrxdate").focus();
            return false;
        }
        if (startCreateDate > endCreateDate && endCreateDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endCreateDate").focus();
            return false;
        }
    }

      /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startAcquireDate = document.getElementById('startAcquireDate').value;
        var endAcquireDate = document.getElementById('endAcquireDate').value;
        var startTrxdate = document.getElementById('startTrxdate').value;
        var endTrxdate = document.getElementById('endTrxdate').value;
        var startCreateDate = document.getElementById('startCreateDate').value.replace(/-/g,"//");
        var endCreateDate = document.getElementById('endCreateDate').value.replace(/-/g,"//");
        if (endAcquireDate.length != 0) {
            if (Number(startAcquireDate > endAcquireDate)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endAcquireDate').focus();
                return false;
            }
        }
        if (endTrxdate.length != 0) {
            if (Number(startTrxdate > endTrxdate)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endTrxdate').focus();
                return false;
            }
        }

         if (endCreateDate.length != 0) {
            if (Number(startCreateDate > endCreateDate)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endCreateDate').focus();
                return false;
            }
        }

        // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectF=new Date(startAcquireDate.substring(0,4)+'/'+startAcquireDate.substring(4,6)+'/'+startAcquireDate.substring(6,8));
        var dSelectT=new Date(endAcquireDate.substring(0,4)+'/'+endAcquireDate.substring(4,6)+'/'+endAcquireDate.substring(6,8));
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

         // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectFh=new Date(startTrxdate.substring(0,4)+'/'+startTrxdate.substring(4,6)+'/'+startTrxdate.substring(6,8));
        var dSelectTh=new Date(endTrxdate.substring(0,4)+'/'+endTrxdate.substring(4,6)+'/'+endTrxdate.substring(6,8));
         var theFromMh=dSelectFh.getMonth();
         var theFromDh=dSelectFh.getDate();
        // 设置起始日期加一个月
          theFromMh += 1;
          dSelectFh.setMonth(theFromMh,theFromDh);
          if( dSelectFh < dSelectTh)
          {
              alert('每次只能查询1个月范围内的数据!');
              return false;
          }

         // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectFhc=new Date(startCreateDate);
        var dSelectThc=new Date(endCreateDate);
         var theFromMhc=dSelectFhc.getMonth();
         var theFromDhc=dSelectFhc.getDate();
        // 设置起始日期加一个月
          theFromMhc += 1;
          dSelectFhc.setMonth(theFromMhc,theFromDhc);
          if( dSelectFhc < dSelectThc)
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
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <div class="table_serch">
            <table>
                <g:form>
                    <tr>
                        <td>${message(code: 'acquireFaultTrx.trxid.label')}：</td>
                        <td><p><g:textField name="trxid" onblur="value=value.replace(/[ ]/g,'')" value="${params.trxid}" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'acquireFaultTrx.trxamount.label')}：</td>
                        <td><p><g:textField name="startTrxamount" value="${params.startTrxamount}" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px" class="right_top_h2_input"/>--<g:textField name="endTrxamount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endTrxamount}" style="width:60px" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'acquireFaultTrx.finalSts.label')}：</td>
                        <td><p><g:select name="finalSts" value="${params.finalSts}" from="${AcquireFaultTrx.finalStsMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td>${message(code: 'acquireFaultTrx.trxdate.label')}：</td>
                        <td><g:textField name="startTrxdate" value="${params.startTrxdate}" style="width:80px" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" class="right_top_h2_input"/>--<g:textField name="endTrxdate" style="width:80px" value="${params.endTrxdate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input"/></td>
                        <td>${message(code: 'acquireFaultTrx.acquireCode.label')}：</td>
                        <td><g:textField name="acquireCode" onblur="value=value.replace(/[ ]/g,'')" value="${params.acquireCode}" class="right_top_h2_input"/></td>
                        <td>${message(code: 'acquireFaultTrx.acquireMerchant.label')}：</td>
                        <td><p><g:textField name="acquireMerchant" onblur="value=value.replace(/[ ]/g,'')" value="${params.acquireMerchant}" class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td>${message(code: 'acquireFaultTrx.acquireSeq.label')}：</td>
                        <td><p><g:textField name="acquireSeq" onblur="value=value.replace(/[ ]/g,'')" value="${params.acquireSeq}" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'acquireFaultTrx.acquireCardnum.label')}：</td>
                        <td><g:textField name="acquireCardnum" onblur="value=value.replace(/[ ]/g,'')" value="${params.acquireCardnum}" class="right_top_h2_input"/></td>
                        <td>${message(code: 'acquireFaultTrx.acquireDate.label')}：</td>
                        <td><g:textField name="startAcquireDate" value="${params.startAcquireDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--<g:textField name="endAcquireDate" style="width:80px" value="${params.endAcquireDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input"/></td>
                    </tr>
                    <tr>
                        <td>${message(code: 'acquireFaultTrx.createDate.label')}：</td>
                        <td><g:textField name="startCreateDate" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" value="${params.startCreateDate}" style="width:80px" class="right_top_h2_input"/>--<g:textField name="endCreateDate" style="width:80px" value="${params.endCreateDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input"/></td>
                        <td>${message(code: 'acquireFaultTrx.changeApplier.label')}：
                        <td><g:textField name="changeApplier" onblur="value=value.replace(/[ ]/g,'')" value="${params.changeApplier}" class="right_top_h2_input"/></td>
                        <td>${message(code: 'acquireFaultTrx.authOper.label')}：
                        <td><p><g:textField name="authOper" onblur="value=value.replace(/[ ]/g,'')" value="${params.authOper}" class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="appList" value="查询" onclick="return checkDate()" /></td>
                        <td><g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/></td>
                        <td class="left">
                            <bo:hasPerm perm="${Perm.Gworder_ExcpChk_DL}">
                                <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()" />
                            </bo:hasPerm>
                        </td>
                        <td><g:hiddenField name="flag" value="1"></g:hiddenField></td>
                    </tr>
                </g:form>
            </table>
        </div>
        <table align="center" class="right_list_table" id="test">
            <tr>

                <g:sortableColumn params="${params}" property="trxid" title="${message(code: 'acquireFaultTrx.trxid.label', default: 'trxid')}"/>

                <g:sortableColumn params="${params}" property="acquireTrxnum" title="${message(code: 'acquireFaultTrx.acquireTrxnum.label', default: 'acquireTrxnum')}"/>

                <g:sortableColumn params="${params}" property="trxdate" title="${message(code: 'acquireFaultTrx.acquireCode.label', default: 'acquireCode')}"/>

                <g:sortableColumn params="${params}" property="iniSts" title="${message(code: 'acquireFaultTrx.acquireMerchant.label', default: 'acquireMerchant')}"/>

                <g:sortableColumn params="${params}" property="changeSts" title="${message(code: 'acquireFaultTrx.acquireSeq.label', default: 'acquireSeq')}"/>

                <g:sortableColumn params="${params}" property="trxid" title="${message(code: 'acquireFaultTrx.acquireCardnum.label', default: 'acquireCardnum')}"/>

                <g:sortableColumn params="${params}" property="acquireTrxnum" title="${message(code: 'acquireFaultTrx.acquireDate.label', default: 'acquireDate')}"/>

                <g:sortableColumn params="${params}" property="trxdate" title="${message(code: 'acquireFaultTrx.trxdate.label', default: 'trxdate')}"/>

                <g:sortableColumn params="${params}" property="trxamount" title="${message(code: 'acquireFaultTrx.trxamount.label', default: 'trxamount')}"/>

                <g:sortableColumn params="${params}" property="iniSts" title="${message(code: 'acquireFaultTrx.iniSts.label', default: 'iniSts')}"/>

                <g:sortableColumn params="${params}" property="changeSts" title="${message(code: 'acquireFaultTrx.finalSts.label', default: 'finalSts')}"/>
                <th>操作</th>
            </tr>

            <g:each in="${acquireFaultTrxInstanceList}" status="i" var="acquireFaultTrxInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.Gworder_ExcpChk_View){true}}"><g:link action="show" id="${acquireFaultTrxInstance.id}">${fieldValue(bean: acquireFaultTrxInstance, field: "trxid")}</g:link></g:if>
                        <g:else>${fieldValue(bean: acquireFaultTrxInstance, field: "trxid")}</g:else>
                    </td>

                    <td>${fieldValue(bean: acquireFaultTrxInstance, field: "acquireTrxnum")}</td>

                    <td>${fieldValue(bean: acquireFaultTrxInstance, field: "acquireCode")}</td>

                    <td>${fieldValue(bean: acquireFaultTrxInstance, field: "acquireMerchant")}</td>

                    <td>${fieldValue(bean: acquireFaultTrxInstance, field: "acquireSeq")}</td>

                    <td>${fieldValue(bean: acquireFaultTrxInstance, field: "acquireCardnum")}</td>

                    <td>${acquireFaultTrxInstance?.acquireDate}</td>

                    <td>${fieldValue(bean: acquireFaultTrxInstance, field: "trxdate")}</td>

                    <td><g:formatNumber number="${acquireFaultTrxInstance?.trxamount?acquireFaultTrxInstance?.trxamount/100:0}" type="currency" currencyCode="CNY"/></td>

                    <td>${AcquireFaultTrx.iniStsMap[acquireFaultTrxInstance?.iniSts]}</td>

                    <td>${AcquireFaultTrx.finalStsMap[acquireFaultTrxInstance?.finalSts]}</td>
                    <td>
                        <bo:hasPerm perm="${Perm.Gworder_ExcpChk_Proc}">
                            <input type="button" onclick=" return checkStatus(${acquireFaultTrxInstance?.id}, 1);" value="通过"/>
                            <input type="button" onclick=" return checkStatus(${acquireFaultTrxInstance?.id}, 2);" value="拒绝"/>
                        </bo:hasPerm>
                        %{--<input type="button" onclick="window.location.href = '${createLink(controller:'acquireFaultTrx', action:'appPass', params:['id':acquireFaultTrxInstance?.id])}';--}%
                        %{--return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" value="通过"/>--}%
                        %{--<input type="button" onclick="window.location.href = '${createLink(controller:'acquireFaultTrx', action:'appUnpass', params:['id':acquireFaultTrxInstance?.id])}';--}%
                        %{--return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" value="拒绝"/>--}%
                    </td>
                </tr>
            </g:each>
        </table>
        合计：交易金额总计：<g:formatNumber number="${totalTrx?totalTrx/100:0}" format="#.##"/>元
        <div class="paginateButtons">
            <span style=" float:left;">共${acquireFaultTrxInstanceTotal}条记录</span>
            <g:paginat total="${acquireFaultTrxInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
