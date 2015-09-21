<%@ page import="boss.BoCustomerWithdrawCycle" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boCustomerWithdrawCycle.label', default: 'BoCustomerWithdrawCycle')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
    <g:javascript library="jquery-1.4.4.min"/>
    <g:javascript>
        var DAY_OPTION_STR = '<option value="1">01</option><option value="2">02</option><option value="3">03</option><option value="4">04</option><option value="5">05</option>' +
                                '<option value="6">06</option><option value="7">07</option><option value="8">08</option><option value="9">09</option><option value="10">10</option>' +
                                '<option value="11">11</option><option value="12">12</option><option value="13">13</option><option value="14">14</option><option value="15">15</option>' +
                                '<option value="16">16</option><option value="17">17</option><option value="18">18</option><option value="19">19</option><option value="20">20</option>' +
                                '<option value="21">21</option><option value="22">22</option><option value="23">23</option><option value="24">24</option><option value="25">25</option>' +
                                '<option value="26">26</option><option value="27">27</option><option value="28">28</option><option value="29">29</option><option value="30">30</option><option value="31">31</option>';

        var WEEK_OPTION_STR = '<option value="1">一</option><option value="2">二</option><option value="3">三</option><option value="4">四</option>' +
                                 '<option value="5">五</option><option value="6">六</option><option value="7">日</option>';

        var HOUR_OPTION_STR = '<option value="1">01</option><option value="2">02</option><option value="3">03</option><option value="4">04</option>' +
                                 '<option value="5">05</option><option value="6">06</option><option value="7">07</option><option value="8">08</option>' +
                                 '<option value="9">09</option><option value="10">10</option><option value="11">11</option><option value="12">12</option>' +
                                 '<option value="13">13</option><option value="14">14</option><option value="15">15</option><option value="16">16</option>' +
                                 '<option value="17">17</option><option value="18">18</option><option value="19">19</option><option value="20">20</option>' +
                                 '<option value="21">21</option><option value="22">22</option><option value="23">23</option><option value="0">00</option>';

        function removeDiv(obj){
            var divObj = $(obj).parent();
            if(divObj){
                divObj.empty().remove();
                var cycleTimes = $('#text_cycleTimes').val();
                cycleTimes--;
                $('#text_cycleTimes').val(cycleTimes);
            }
        }

        function getMonthSelect(num, monthSelectArray){
            var rst = '<div id="expr_month_'+num+'"><select name="select_cycleExpr_month_'+num+'">' + DAY_OPTION_STR +
                      '</select>日<select name="select_cycleExpr_hour_'+num+'">' + HOUR_OPTION_STR +
                      '</select>时   <input type="button" value="删除" onclick="removeDiv(this)"/></div>';
            $('#td_cycleExpr').append(rst);
            if(monthSelectArray && monthSelectArray.length > 0){
                for(var i = 0; i < monthSelectArray.length; i++){
                    var item = monthSelectArray[i];
                    var newSel = $('select[name="select_cycleExpr_month_'+num+'"]')[0];
                    var newOpts = newSel.options;
                    for(var j = 0; j < newOpts.length; j++){
                        var opt = newOpts[j];
                        if(opt.value == item.value){
                            newSel.remove(opt.index);
                        }
                    }
                }
            }
        }

        function getWeekSelect(num, weekSelectArray){
            var rst = '<div id="expr_week_'+num+'">周<select name="select_cycleExpr_week_'+num+'">' + WEEK_OPTION_STR +
                      '</select><select name="select_cycleExpr_hour_'+num+'">' + HOUR_OPTION_STR +
                      '</select>时   <input type="button" value="删除" onclick="removeDiv(this)"/></div>';
            $('#td_cycleExpr').append(rst);
            if(weekSelectArray && weekSelectArray.length > 0){
                for(var i = 0; i < weekSelectArray.length; i++){
                    var item = weekSelectArray[i];
                    var newSel = $('select[name="select_cycleExpr_week_'+num+'"]')[0];
                    var newOpts = newSel.options;
                    for(var j = 0; j < newOpts.length; j++){
                        var opt = newOpts[j];
                        if(opt.value == item.value){
                            newSel.remove(opt.index);
                        }
                    }
                }
            }
        }

        function getDaySelect(num){
            var rst = '<div id="expr_day_'+num+'"><select name="select_cycleExpr_hour_'+num+'">' + HOUR_OPTION_STR +
                      '</select>时   <input type="button" value="删除" onclick="removeDiv(this)"/></div>'
            $('#td_cycleExpr').append(rst);
        }

        $(function(){
            var rst_html = "";
            var expr_str = "${(boCustomerWithdrawCycleInstance?.cycleExpr == null || boCustomerWithdrawCycleInstance?.cycleExpr == '') ? '':boCustomerWithdrawCycleInstance.cycleExpr}";
            if(expr_str && $('#td_cycleExpr')){
                expr_str = expr_str.substring(1,expr_str.length -1);
                var expr_arr = expr_str.split(',');
                var cycle_times = parseInt("${boCustomerWithdrawCycleInstance?.cycleTimes}");
                if(expr_arr.length != cycle_times){
                    alert("周期次数和时间出现异常！");
                }else if("1" == "${boCustomerWithdrawCycleInstance?.cycleType.toString()}"){
                    for(var i = 0; i < cycle_times; i++){
                        var num = i+1;
                        getDaySelect(num);
                        var hour = expr_arr[i];
                        $('select[name="select_cycleExpr_hour_'+num+'"]').val(hour);
                    }
                }else if("2" == "${boCustomerWithdrawCycleInstance?.cycleType.toString()}"){
                    for(var i = 0; i < cycle_times; i++){
                        var num = i+1;
                        getWeekSelect(num);
                        var week_hour = expr_arr[i];
                        var arr = week_hour.split('#',2);
                        var week = arr[0];
                        var hour = arr[1];
                        $('select[name="select_cycleExpr_week_'+num+'"]').val(week);
                        $('select[name="select_cycleExpr_hour_'+num+'"]').val(hour);
                    }
                }else if("3" == "${boCustomerWithdrawCycleInstance?.cycleType.toString()}"){
                    for(var i = 0; i < cycle_times; i++){
                        var num = i+1;
                        getMonthSelect(num);
                        var month_hour = expr_arr[i];
                        var arr = month_hour.split('#',2);
                        var month = arr[0];
                        var hour = arr[1];
                        $('select[name="select_cycleExpr_month_'+num+'"]').val(month);
                        $('select[name="select_cycleExpr_hour_'+num+'"]').val(hour);
                    }
                }
            }

            $(':radio[name="withdrawType"]').change( function() {
                var val = $(':radio[name="withdrawType"]:checked').val();
                if('0' == val){
                    $('#span_withdrawType').hide();
                    $('#tr_time_head').show();
                    $('#tr_time_value').show();
                    $('#div_time_note').show();
                }else if('1' == val){
                    $('#span_withdrawType').show();
                    $('#tr_time_head').hide();
                    $('#tr_time_value').hide();
                    $('#div_time_note').hide();
                }
            });
            $(':radio[name="amountType"]').change(function() {
                var val = $(':radio[name="amountType"]:checked').val();
                if('0' == val){
                    $('#span_amountType').hide();
                }else if('1' == val){
                    $('#span_amountType').show();
                }
            });
            $('#select_cycleType').change(function(){
                $('#td_cycleExpr').empty();
                $('#text_cycleTimes').val(0);
            });
            $('#button_empty_time').click(function(){
                $('#td_cycleExpr').empty();
                $('#text_cycleTimes').val(0);
            });
            $('#button_add_time').click(function(){
                var cycleTimes = $('#text_cycleTimes').val();
                var val = $('#select_cycleType').val();
                cycleTimes++;
                if(1 == val){
                    //if(cycleTimes > 24){ 修改需求，单日不能超过一次
                    if(cycleTimes > 1){
                        alert("按日只能提现一次");
                        return false;
                    }
                    getDaySelect(cycleTimes);
                }else if(2 == val){
                    if(cycleTimes > 7){
                        alert("超过提现次数最大值");
                        return false;
                    }
                    var weekSelectArray = $('select[name^="select_cycleExpr_week_"]');
                    getWeekSelect(cycleTimes, weekSelectArray);
                }else if(3 == val){
                    if(cycleTimes > 31){
                        alert("超过提现次数最大值");
                        return false;
                    }
                    var monthSelectArray = $('select[name^="select_cycleExpr_month_"]');
                    getMonthSelect(cycleTimes, monthSelectArray);
                }
                $('#text_cycleTimes').val(cycleTimes);
            });
        });

        function validateAmount(amt){
            if(''==$.trim(amt)){
                return "金额不能为空！";
            }
            amt = amt.replace(/,/g, "");
            if(isNaN(amt)){
                return "金额必须为数字！";
            }else if(amt < 0){
                return "金额必须为正值！";
            }else{
                var amtArr = amt.split(".");
                if(amtArr[0].length > 17){
                    return "金额超过最大允许值！";
                }else if(amtArr.length == 2 && amtArr[1].length > 2){
                    return "金额需保留小数点后两位";
                }
                return null;
            }
        }

        function updateSetting(){
            var amountType = $(':radio[name="amountType"]:checked').val();
            if(1 == amountType){
                var keepAmount = $('input[name="keepAmount"]').val();
                var msg = validateAmount(keepAmount);
                if(msg){
                    alert("预留"+msg);
                    return false;
                }
            }

            var withdrawType = $(':radio[name="withdrawType"]:checked').val();
            if(1 == withdrawType){
                var withdrawAmount = $('input[name="withdrawAmount"]').val();
                var msg = validateAmount(withdrawAmount);
                if(msg){
                    alert("提现"+msg);
                    return false;
                }
            }else if(0 == withdrawType){
                var selectArr = $('select[name^="select_cycleExpr_week_"]');
                if(selectArr && selectArr.length > 1){
                    for(var i = 0; i < selectArr.length - 1; i++){
                        var sel1 = selectArr[i];
                        for(var j = i+1; j < selectArr.length; j++){
                            var sel2 = selectArr[j];
                            if(sel1.value == sel2.value){
                                alert("星期不能重复");
                                return false;
                            }
                        }
                    }
                }else{
                    selectArr = $('select[name^="select_cycleExpr_month_"]');
                    if(selectArr && selectArr.length > 1){
                        for(var i = 0; i < selectArr.length - 1; i++){
                            var sel1 = selectArr[i];
                            for(var j = i+1; j < selectArr.length; j++){
                                var sel2 = selectArr[j];
                                if(sel1.value == sel2.value){
                                    alert("日期不能重复");
                                    return false;
                                }
                            }
                        }
                    }
                }
            }else{
                alert("提现类型错误！");
                return false;
            }

            document.forms[0].submit();
        }
    </g:javascript>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boCustomerWithdrawCycleInstance}">
    <div class="errors">
      <g:renderErrors bean="${boCustomerWithdrawCycleInstance}" as="list"/>
    </div>
  </g:hasErrors>
  <g:form action="update" >
      <table align="center" class="rigt_tebl">
          <g:hiddenField name="customerNo" value="${boCustomerWithdrawCycleInstance?.customerNo}" />
          <tr>
              <th colspan="3"><g:message code="default.edit.label" args="[entityName]"/></th>
          </tr>
          <tr>
              <td colspan="2" width="50%" style="padding-left:5px">
                  <g:radioGroup name="withdrawType" values="[0,1]" labels="['按时间提现','按金额提现']" value="${boCustomerWithdrawCycleInstance?.withdrawType}">${it.radio}<g:message code="${it.label}" /></g:radioGroup>&nbsp;&nbsp;
                  <g:if test="${0==boCustomerWithdrawCycleInstance?.withdrawType}">
                      <span id="span_withdrawType" style="display:none;">达到：<g:textField maxlength="25" name="withdrawAmount" value="${fieldValue(bean: boCustomerWithdrawCycleInstance, field: 'withdrawAmount')}" />（元）&nbsp;&nbsp;</span>
                  </g:if>
                  <g:if test="${1==boCustomerWithdrawCycleInstance?.withdrawType}">
                      <span id="span_withdrawType" style="display:block;">达到：<g:textField maxlength="25" name="withdrawAmount" value="${fieldValue(bean: boCustomerWithdrawCycleInstance, field: 'withdrawAmount')}" />（元）&nbsp;&nbsp;</span>
                  </g:if>
              </td>
              <td width="50%">
                  <g:radioGroup name="amountType" value="${boCustomerWithdrawCycleInstance?.amountType}" values="[0,1]" labels="['全部提现','预留提现']">${it.radio}&nbsp;<g:message code="${it.label}" /><br/></g:radioGroup>
                  <g:if test="${0==boCustomerWithdrawCycleInstance?.amountType}">
                      <span id="span_space">&nbsp;</span>
                      <span id="span_amountType" style="display:none;"><g:textField maxlength="25" name="keepAmount" value="${fieldValue(bean: boCustomerWithdrawCycleInstance, field: 'keepAmount')}" />（元）</span>
                  </g:if>
                  <g:if test="${1==boCustomerWithdrawCycleInstance?.amountType}">
                      <span id="span_amountType" style="display:block;"><g:textField maxlength="25" name="keepAmount" value="${fieldValue(bean: boCustomerWithdrawCycleInstance, field: 'keepAmount')}" />（元）</span>
                  </g:if>
              </td>
          </tr>
          <tr id="tr_time_head" ${0==boCustomerWithdrawCycleInstance?.withdrawType ? "style='display:block;'" : "style='display:none;'"}>
              <td width="25%" style="padding-left:5px">提现周期</td>
              <td width="25%" style="padding-left:5px">提现次数</td>
              <td width="50%" style="padding-left:5px">
                  提现时间
                  <input type="button" value="添加" id="button_add_time"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="清空" id="button_empty_time"/>
              </td>
              <!--td width="20%" style="padding-left:5px">节假日提现</td-->
          </tr>
          <tr id="tr_time_value" ${0==boCustomerWithdrawCycleInstance?.withdrawType ? "style='display:block;'" : "style='display:none;'"}>
              <td width="25%"><g:select id="select_cycleType" name="cycleType" from="${BoCustomerWithdrawCycle.cycleTypeMap}" optionKey="key" optionValue="value" value="${boCustomerWithdrawCycleInstance?.cycleType}"/></td>
              <td width="25%"><g:textField id="text_cycleTimes" name="cycleTimes" style="width:25px" maxlength="3" readonly="readonly" value="${fieldValue(bean: boCustomerWithdrawCycleInstance, field: 'cycleTimes')}" /></td>
              <td width="50%" id="td_cycleExpr">&nbsp;</td>
              <%--td width="20%"><g:radioGroup name="holidayWithdraw" value="${boCustomerWithdrawCycleInstance?.holidayWithdraw}" values="[1,0]" labels="['是','否']">${it.radio}&nbsp;<g:message code="${it.label}" />&nbsp;&nbsp;</g:radioGroup></td--%>
          </tr>
          <tr>
              <td colspan="3" align="center">
                  <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                  <span class="content"><input type="button" onclick="updateSetting()" class="rigt_button" value="确定"></span>
              </td>
          </tr>
    </table>
  </g:form>
</div>
<br/>
<br/>
<br/>
</body>
</html>