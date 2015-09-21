
<%@ page import="boss.Perm; dsf.TbAgentpayDetailsInfo" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbAgentpayDetailsInfo.label', default: '待处理打款信息')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript">
        function checkAllBox() {
            var len = document.getElementsByName("box").length;
            for (i = 0; i < len; i++) {
                if (document.getElementById("allBox").checked) {
                    document.getElementsByName("box")[i].checked = true;
                }
                else {
                    document.getElementsByName("box")[i].checked = false;
                }
            }
        }
         function selectCheck() {
            var len = document.getElementsByName("box").length;
            var ids="";
            var flag = 0;
            for (i = 0; i < len; i++) {
                if (document.getElementsByName("box")[i].checked) {
                    ids=ids+document.getElementsByName("box")[i].value+",";
                    flag = 1;
                }
            }

            document.getElementById("ids").value=ids;

            if (flag == 0) {
                alert("请选择明细！");
                return false;
            }
            else {
               return true;
            }

        }
           function cl(){

            var   form   =   document.forms[0];
            for(var   i=0;   i <form.elements.length;   i++)
            {
            if(form.elements[i].type==   "text" || form.elements[i].type==   "text" )
            form.elements[i].value   =   "";
             }

            document.getElementById("tradeType").value="";
            document.getElementById("bankName").value="";
            document.getElementById("tradeAccounttype").value="";
        }

           function allChecked(){
            if(!window.confirm("全部选择，将使选择命令失效。请确认。")){
                 return false;
             }
            document.getElementById("allCheck").value="true";
            document.getElementById("allBox").disabled = true
            var len = document.getElementsByName("box").length;
            for (i = 0; i < len; i++) {
              document.getElementsByName("box")[i].checked = true;
                document.getElementsByName("box")[i].disabled = true
            }
        }
        </script>
</head>
<body>

<script type="text/javascript">
      /**
    * 格式化金额
    */
    function fmoney(s, n)
    {

       var svalue;
       n = n>0 && n<=20?n:2;
       svalue = parseFloat((s.value + "").replace(/[^\d\.-]/g, "")).toFixed(n)+"";
       var l = svalue.split(".")[0].split("").reverse(),
       r = svalue.split(".")[1];
       t = "";
       for(i=0; i<l.length; i++ )
       {
          t +=l[i]+((i+1)%3==0 && (i+1)!=l.length?",":"");
       }
       s.value=t.split("").reverse().join("")+"."+r;
       return s.value;
    }
  $(function() {
    $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    $("#endTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
  });
           /*---guonan update 2011-12-30----*/
    function checkDate() {
        var startDateCreated = document.getElementById('startTime').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endTime').value.replace(/-/g,"//");

        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }

    }
</script>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
    <div class="table_serch">
    <table align="center" class="right_list_table" id="test">
         <g:form action="dkteminalList">

             开始时间：<g:textField name="startTime" value="${params.startTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
             结束时间：<g:textField name="endTime" value="${params.endTime}" size="10" class="right_top_h2_input" style="width:100px" onchange="checkDate()" />
             商户编号：<g:textField name="batchBizid" value="${params.batchBizid}" size="20" class="right_top_h2_input" style="width:150px"/>
             业务类型：<g:select name="tradeType" from="${TbAgentpayDetailsInfo.fkYwTypeMap}" optionKey="key" optionValue="value" value="${params.tradeType}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
             </br>
             收款人：<g:textField name="tradeCardname" value="${params.tradeCardname}" size="10" class="right_top_h2_input" style="width:150px"/>
             收款账号：<g:textField name="tradeCardnum" value="${params.tradeCardnum}" size="10" class="right_top_h2_input" style="width:150px"/>
             收款银行：<g:select name="bankName" from="${bankNameList}" optionKey="bankCode" optionValue="note" noSelection="${['':'--请选择--']}" value="${params.bankName}"/>
             账号类型：<g:select name="tradeAccounttype" from="${TbAgentpayDetailsInfo.accountTypeMap}" optionKey="key" optionValue="value" value="${params.tradeAccounttype}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
             <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkDate()" />
              <input type="button" class="right_top_h2_button_serch" value="清空" onClick="cl()">
               <input type="button" class="right_top_h2_button_tj" value="全部全选" onClick="allChecked();">
        <g:hiddenField name="allCheck" id="allCheck"/>
        <g:hiddenField name="ids" id="ids"/>
      <tr>
        
          </table>
            </div>
            <div class="right_list_tablebox">
                <table align="center" class="right_list_table" id="test">
        
        <g:sortableColumn params="${params}"  property="batchId" title="${message(code: 'tbAgentpayDetailsInfo.batchId.label', default: 'Batch Id')}"/>

        <g:sortableColumn params="${params}"  property="id" title="${message(code: 'tbAgentpayDetailsInfo.tradeNum.label', default: 'Trade Num')}"/>
        <g:sortableColumn params="${params}"  property="tradeType" title="${message(code: '业务类型', default: '业务类型')}"/>

        <g:sortableColumn params="${params}"  property="tradeCardname" title="收款人"/>

        <g:sortableColumn params="${params}"  property="tradeCardnum" title="收款账号"/>

        <g:sortableColumn params="${params}"  property="tradeAccountname" title="收款银行"/>

        <g:sortableColumn params="${params}"  property="tradeSysdate" title="${message(code: 'tbAgentpayDetailsInfo.tradeSysdate.label', default: 'Trade Sysdate')}"/>

        <g:sortableColumn params="${params}"  property="tradeAccounttype" title="${message(code: 'tbAgentpayDetailsInfo.tradeAccounttype.label', default: 'Trade Account Type')}"/>

        <g:sortableColumn params="${params}"  property="tradeBranchbank" title="${message(code: 'tbAgentpayDetailsInfo.tradeBranchbank.label', default: 'tradeBranchbank')}"/>

        <g:sortableColumn params="${params}"  property="tradeSubbranchbank" title="${message(code: 'tbAgentpayDetailsInfo.tradeSubbranchbank.label', default: 'tradeSubbranchbank')}"/>

        <g:sortableColumn params="${params}"  property="tradeAmount" title="${message(code: 'tbAgentpayDetailsInfo.tradeAmount.label', default: 'Trade Amount')}"/>

        <g:sortableColumn params="${params}"  property="tradeFee" title="${message(code: 'tbAgentpayDetailsInfo.tradeFee.label', default: 'Trade Fee')}"/>

      <g:sortableColumn params="${params}"  property="tradeFeetype" title="${message(code: 'tbAgentpayDetailsInfo.tradeFeetype.label', default: '收费方式')}"/>


        <g:sortableColumn params="${params}"  property="tradeFeestyle" title="退手续费"/>

        <g:sortableColumn params="${params}"  property="tradeAccamount" title="实付金额"/>
        <g:sortableColumn params="${params}" property="tradeRemark" title="省"/>
                 <g:sortableColumn params="${params}" property="tradeRemark" title="市"/>

        <g:sortableColumn params="${params}"  property="payStatus" title="${message(code: 'tbAgentpayDetailsInfo.payStatus.label', default: 'Pay Status')}"/>
        <g:sortableColumn params="${params}" property="fcheckName" title="打款初审"/>
        <td>全选<input type="checkbox" id="allBox" name="allBox" onclick="checkAllBox();"></td>
      </tr>

      <g:each in="${tbAgentpayDetailsInfoInstanceList}" status="i" var="tbAgentpayDetailsInfoInstance">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

          <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "batchBizid")}</td>
          
          <td>${tbAgentpayDetailsInfoInstance.id}</td>

          <td > ${TbAgentpayDetailsInfo.typeMap[tbAgentpayDetailsInfoInstance.tradeType]}</td>
          
          <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeCardname")}</td>
          
          <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeCardnum")}</td>
             <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeAccountname")}</td>

          <td><g:formatDate date="${tbAgentpayDetailsInfoInstance.tradeSysdate}" format="yyyy-MM-dd HH:mm:ss"/></td>

            <td>
                ${TbAgentpayDetailsInfo.accountTypeMap[tbAgentpayDetailsInfoInstance.tradeAccounttype]}
          </td>
            <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeBranchbank")}</td>

          <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeSubbranchbank")}</td>

          <td>
               <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.tradeAmount ? tbAgentpayDetailsInfoInstance.tradeAmount : 0}"/>
          <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>
          </td>
             <td>

                     <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.tradeFee ? tbAgentpayDetailsInfoInstance.tradeFee : 0}"/>
                     <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>

             </td>

         <td>${TbAgentpayDetailsInfo.feeTypeMap[tbAgentpayDetailsInfoInstance.tradeFeetype]}</td>
          <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "tradeFeestyle")}</td>

          <td>

          <g:set var="amt" value="${tbAgentpayDetailsInfoInstance.tradeAmount ? tbAgentpayDetailsInfoInstance.tradeAmount : 0}"/>
          <g:formatNumber number="${amt}" type="currency" currencyCode="CNY"/>

          </td>
            <td>${tbAgentpayDetailsInfoInstance.tradeRemark.split(';')[0]}</td>
            <td>${tbAgentpayDetailsInfoInstance.tradeRemark.split(';')[1]}</td>

          <td>${TbAgentpayDetailsInfo.dkStatusMap[tbAgentpayDetailsInfoInstance.payStatus]}</td>
           <td>${fieldValue(bean: tbAgentpayDetailsInfoInstance, field: "fcheckName")}</td>

           <td><g:checkBox name="box" value="${tbAgentpayDetailsInfoInstance.id}" checked="false"  ></g:checkBox></td>

          
        </tr>
      </g:each>

    </table>
       </div>
     <table align="center">
                <tr>&nbsp;</tr>
                <tr>
                    <g:hiddenField name="flag" value="F"/>
                    <td align="center">
                        <bo:hasPerm perm="${Perm.AgPay_FinalChk_Proc}"><g:actionSubmit id="submit" align="center" class="right_top_h2_button_tj" action="terminalPass" value="终审通过" onclick="return selectCheck();"/></bo:hasPerm>
                    </td>
                    <td align="center">
                        <bo:hasPerm perm="${Perm.AgPay_FinalChk_Proc}"><g:actionSubmit id="submit" align="center" class="right_top_h2_button_tj" action="terminalRefuse" value="终审拒绝" onclick="return selectCheck();"/></bo:hasPerm>
                    </td>
                </tr>
            </table>
             </g:form>
    <div class="paginateButtons">
       <div style=" float:left;">共${tbAgentpayDetailsInfoInstanceTotal}条记录</div>
      <g:paginat total="${tbAgentpayDetailsInfoInstanceTotal}" params="${params}"/>
    </div>
      <div>
  <g:hiddenField  name="m" value="${totalMoney}"/>
         <g:hiddenField  name="f" value="${totalFee}"/>

       合计笔数：${tbAgentpayDetailsInfoInstanceTotal}笔&nbsp;&nbsp;&nbsp;&nbsp;金额：<g:formatNumber number="${totalMoney}" format="#.##"/>元&nbsp;&nbsp;&nbsp;&nbsp;手续费：<g:formatNumber number="${totalFee}" format="#.##"/>元&nbsp;&nbsp;&nbsp;&nbsp;实收/付金额： <g:formatNumber number="${totalMoney}" format="#.##"/>元
      </div>
  </div>
</div>
</body>
</html>
