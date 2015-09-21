<%@ page import="ismp.CmCustomer; boss.BoCustomerWithdrawCycle" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boCustomerWithdrawCycle.label', default: 'BoCustomerWithdrawCycle')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
    <g:javascript library="jquery-1.4.4.min"/>
    <g:javascript>
        function getWeekString(num){
            var rst = '';
            if('1'==num){
                rst = '一';
            }else if('2'==num){
                rst = '二';
            }else if('3'==num){
                rst = '三';
            }else if('4'==num){
                rst = '四';
            }else if('5'==num){
                rst = '五';
            }else if('6'==num){
                rst = '六';
            }else if('7'==num){
                rst = '日';
            }
            return rst;
        }

        $(function(){
            var rst_html = "";
            var expr_str = "${(boCustomerWithdrawCycleInstance?.cycleExpr == null || boCustomerWithdrawCycleInstance?.cycleExpr == '') ? '':boCustomerWithdrawCycleInstance.cycleExpr}";
            if("0" == "${boCustomerWithdrawCycleInstance?.withdrawType}" && expr_str && $('#td_time_expr')){
                expr_str = expr_str.substring(1,expr_str.length -1);
                var expr_arr = expr_str.split(',');
                var cycle_times = parseInt("${boCustomerWithdrawCycleInstance?.cycleTimes}");
                if(expr_arr.length != cycle_times){
                    alert("周期次数和时间出现异常！");
                }else if("1" == "${boCustomerWithdrawCycleInstance?.cycleType.toString()}"){
                    for(var i = 0; i < cycle_times; i++){
                        var hour = expr_arr[i];
                        //hour = parseInt(hour) + 1
                        if(hour.length == 1){
                            hour = "0" + hour;
                        }
                        rst_html += '<div class="rigt_tebl_font">'+hour+'时</div>';
                    }
                }else if("2" == "${boCustomerWithdrawCycleInstance?.cycleType.toString()}"){
                    for(var i = 0; i < cycle_times; i++){
                        var week_hour = expr_arr[i];
                        var arr = week_hour.split('#',2);
                        var week = arr[0];
                        week = getWeekString(week);
                        var hour = arr[1];
                        //hour = parseInt(hour) + 1
                        if(hour.length == 1){
                            hour = "0" + hour;
                        }
                        rst_html += '<div class="rigt_tebl_font">周'+week+' '+hour+'时</div>';
                    }
                }else if("3" == "${boCustomerWithdrawCycleInstance?.cycleType.toString()}"){
                    for(var i = 0; i < cycle_times; i++){
                        var month_hour = expr_arr[i];
                        var arr = month_hour.split('#',2);
                        var month = arr[0];
                        if(month.length == 1){
                            month = "0"+month;
                        }
                        var hour = arr[1];
                        //hour = parseInt(hour) + 1
                        if(hour.length == 1){
                            hour = "0" + hour;
                        }
                        rst_html += '<div class="rigt_tebl_font">'+month+'日 '+hour+'时</div>';
                    }
                }
                //alert(rst_html);
                $('#td_time_expr').empty().append(rst_html);
            }
        });

        function backtolist(){
            window.location.href = "${createLink(controller: 'boCustomerWithdrawCycle',action:"list")}";
        }
    </g:javascript>
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
    </tr>
    <tr>
      <td class="right label_name">商户号：</td>
      <td><span class="rigt_tebl_font">${fieldValue(bean: boCustomerWithdrawCycleInstance, field: "customerNo")}</span></td>
    </tr>

    <tr>
      <td class="right label_name">商户名称：</td>
      <td><span class="rigt_tebl_font">${CmCustomer.findByCustomerNo(boCustomerWithdrawCycleInstance.customerNo)?.name}</span></td>
    </tr>
    
    <tr>
      <td class="right label_name">提现类型：</td>
      <td><span class="rigt_tebl_font">${BoCustomerWithdrawCycle.withdrawTypeMap[boCustomerWithdrawCycleInstance?.withdrawType.toString()]}</span></td>
    </tr>
    <tr>
          <td class="right label_name">提现选项：</td>
          <td><span class="rigt_tebl_font">${BoCustomerWithdrawCycle.amountTypeMap[boCustomerWithdrawCycleInstance?.amountType.toString()]}</span></td>
        </tr>
        <g:if test="${1 == boCustomerWithdrawCycleInstance?.amountType}">
            <tr>
              <td class="right label_name">预留金额：</td>
              <td><span class="rigt_tebl_font">${fieldValue(bean: boCustomerWithdrawCycleInstance, field: "keepAmount")}（元）</span></td>
            </tr>
        </g:if>
    <g:if test="${1 == boCustomerWithdrawCycleInstance?.withdrawType}">
        <tr>
          <td class="right label_name">触发金额：</td>
          <td><span class="rigt_tebl_font">${fieldValue(bean: boCustomerWithdrawCycleInstance, field: "withdrawAmount")}（元）</span></td>
        </tr>
    </g:if>
    <g:if test="${0 == boCustomerWithdrawCycleInstance?.withdrawType}">
        <tr>
          <td class="right label_name">提现周期：</td>
          <td><span class="rigt_tebl_font">${BoCustomerWithdrawCycle.cycleTypeMap[boCustomerWithdrawCycleInstance?.cycleType.toString()]}</span></td>
        </tr>
        <tr>
          <td class="right label_name">提现次数：</td>
          <td><span class="rigt_tebl_font">${fieldValue(bean: boCustomerWithdrawCycleInstance, field: "cycleTimes")}</span></td>
        </tr>
        <tr>
          <td class="right label_name">提现时间：</td>
          <td id="td_time_expr"></td>
        </tr>
        <%--tr>
          <td class="right label_name">节假日提现：</td>
          <td><span class="rigt_tebl_font">${BoCustomerWithdrawCycle.holidayWithdrawMap[boCustomerWithdrawCycleInstance?.holidayWithdraw.toString()]}</span></td>
        </tr--%>
    </g:if>

    <tr>
      <td class="right label_name">上次提现日期：</td>
      <td><span class="rigt_tebl_font"><g:formatDate date="${boCustomerWithdrawCycleInstance.lastFootDate}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
    </tr>
    <g:if test="${0 == boCustomerWithdrawCycleInstance?.withdrawType}">
    <tr>
      <td class="right label_name">下次提现日期：</td>
      <td><span class="rigt_tebl_font"><g:formatDate date="${boCustomerWithdrawCycleInstance.nextFootDate}" format="yyyy-MM-dd HH:mm:ss"/></span></td>
    </tr>
    </g:if>
    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="customerNo" value="${boCustomerWithdrawCycleInstance?.customerNo}"/>
          <span class="button"><input type="button" onclick="backtolist()" class="rigt_button" value="返回"/></span>
          <span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>
        </g:form>
      </td>
    </tr>
  </table>
</div>
</body>
</html>