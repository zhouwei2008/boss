<%@ page import="boss.BoCustomerService" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boCustomerService.label', default: 'BoCustomerService')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<script type="text/javascript">
    function fromCheck() {
        var year = document.getElementById("startTime_year").value;
        var month = document.getElementById("startTime_month").value;
        var day = document.getElementById("startTime_day").value;
        var startTime = year + month + day;
        var endYear = document.getElementById("endTime_year").value;
        var endMonth = document.getElementById("endTime_month").value;
        var endDay = document.getElementById("endTime_day").value;
        var endTime = endYear + endMonth + endDay;

        if (document.getElementById("contractNo").value.length == 0) {
            alert("请输入合同号码!");
            document.getElementById("contractNo").focus();
            return false;
        }
        if (document.getElementById("serviceCode").value == 'precharge') {
            if (document.getElementById("serviceParams").value.length == 0) {
                alert("服务类型为预付费卡支付时，服务参数不允许为空，请输入收款方邮箱!");
                document.getElementById("serviceParams").focus();
                return false;
            }
        }
        if(document.getElementById("fanDian_1").checked){
            if(document.getElementById("fanDianAmount").value=='' || document.getElementById("fanDianAmount").value==null){
                alert("请输入返点金额");
                document.getElementById("fanDianAmount").focus();
                return false;
            }
        }
        if (Number(startTime) > Number(endTime)) {
            alert("生效时间不能早于终止时间！");
            return false;
        }
        else {
            return true;
        }
    }
    function check1(){
        if(document.getElementById("fanDian_1").checked){
            document.getElementById("fanDianAmount").disabled=false;
            document.getElementById("fanDianAmount").focus();
        }else{
            document.getElementById("fanDianAmount").value='';
            document.getElementById("fanDianAmount").disabled=true;
        }
    }

    function dateCheck() {
        var year = document.getElementById("startTime_year").value;
        var month = document.getElementById("startTime_month").value;
        var day = document.getElementById("startTime_day").value;
        var startTime = year + month + day;
        var endYear = document.getElementById("endTime_year").value;
        var endMonth = document.getElementById("endTime_month").value;
        var endDay = document.getElementById("endTime_day").value;
        var endTime = endYear + endMonth + endDay;
        if (Number(startTime) > Number(endTime)) {
            alert("生效时间不能早于终止时间！");
            return false;
        }

        /* if (document.getElementById("endTime").value.length != 0) {
         if (document.getElementById("startTime").value > document.getElementById("endTime").value) {
         alert("生效时间不能早于终止时间！");
         document.getElementById("endTime").focus();
         return false;
         }
         }*/
    }

    function changeShow() {
        var serviceCode = document.getElementById("serviceCode").value;
        if (serviceCode == "agentcoll" || serviceCode == "agentpay") {
            document.getElementById("feeLabel").style.display = "none";
            document.getElementById("serviceLabel").style.display = "none";
        } else if (serviceCode == "online" || serviceCode == "royalty") {
            document.getElementById("feeLabel").style.display = "";
            document.getElementById("serviceLabel").style.display = "";
        }
    }

    $(function() {
        $("#startTime").datepicker({ dateFormat: 'yymmdd', changeYear: true, changeMonth: true });
        $("#endTime").datepicker({ dateFormat: 'yymmdd', changeYear: true, changeMonth: true });
    })

    function Is2smallNum(value, limitcount) {
            var s = new String(value);
            var array = s.split(".");
            if (array[1] == null)
                count = -1;
            else {
                var str = new String(array[1]);
                count = str.length;
            }
            if (count > limitcount) {
                return false;
            }
            return true;
    }

    function regPrice(){
      if(document.getElementById("fanDian_1").checked){
        var price = document.getElementById("fanDianAmount").value;
        var reg = /^-?[1-9]+(\.\d+)?$|^-?0(\.\d+)?$|^-?[1-9]+[0-9]*(\.\d+)?$/;
        if (!(reg.test(price) && price >= 0 && price <= 100 )) {
          alert("返点率请输入0-100之间的数字");
          return false;
        }
        if (!Is2smallNum(price, 2)) {
            alert("小数不能超过2位");
            return false;
        }
      }
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <g:hasErrors bean="${boCustomerServiceInstance}">
        <div class="errors">
            <g:renderErrors bean="${boCustomerServiceInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form onsubmit="return fromCheck();" action="save">
        <g:hiddenField name="customerId" value="${params.customerId}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boCustomerService.contractNo.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'contractNo', 'errors')}"><g:textField name="contractNo" maxlength="20" value="${boCustomerServiceInstance?.contractNo}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boCustomerService.serviceCode.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'serviceCode', 'errors')}">
                    <g:select name="serviceCode" from="${BoCustomerService.serviceMap}" optionKey="key" optionValue="value" value="${boCustomerServiceInstance?.serviceCode}" onchange="changeShow()"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boCustomerService.startTime.label"/>：</td>
                <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'startTime', 'errors')}"><bo:datePicker id="startTime" name="startTime" precision="day" value="${boCustomerServiceInstance?.startTime}"></bo:datePicker>
                %{--<g:textField name="startTime" onchange="dateCheck()" value="${boCustomerServiceInstance?.startTime}"/>--}%
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boCustomerService.endTime.label"/>：</td>
                <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'endTime', 'errors')}"><bo:datePicker id="endTime" name="endTime" precision="day" value="${boCustomerServiceInstance?.endTime}"></bo:datePicker>
                %{--<g:textField name="endTime" onchange="dateCheck()" value="${boCustomerServiceInstance?.endTime}"/>--}%
                </td>
            </tr>

            %{--<tr id="feeLabel">--}%
                %{--<td class="right label_name"><g:message code="boCustomerService.feeParams.label"/>：</td>--}%
                %{--<td class="${hasErrors(bean: boCustomerServiceInstance, field: 'feeParams', 'errors')}"><g:textField name="feeParams" maxlength="64" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${boCustomerServiceInstance?.feeParams}"/><span><font color="red">%</font>（计费参数按百分比计算）</span></td>--}%

            %{--</tr>--}%

            %{--<tr id="serviceLabel">--}%
                %{--<td class="right label_name"><g:message code="boCustomerService.serviceParams.label"/>：</td>--}%
                %{--<td class="${hasErrors(bean: boCustomerServiceInstance, field: 'serviceParams', 'errors')}"><g:textArea name="serviceParams" cols="40" rows="5" value="${boCustomerServiceInstance?.serviceParams}"/></td>--}%
            %{--</tr>--}%

            <tr>
                <td class="right label_name"><g:message code="boCustomerService.belongToSale.label"/>：</td>
                <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'belongToSale', 'errors')}"><g:textField name="belongToSale" maxlength="20" value="${boCustomerServiceInstance?.belongToSale}"/></td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="boCustomerService.isFanDian.label"/>：</td>
                <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'isFanDian', 'errors')}">
                    <input type="radio" id="fanDian_1" name="isFanDian" value="1" onclick="check1();"><label for="fanDianAmount">是&nbsp;&nbsp;</label>
                    <g:message code="boCustomerService.fanDianAmount.label"/>&nbsp;<g:textField name="fanDianAmount" maxlength="64" disabled="disabled" onblur="regPrice();" onkeyup="value=value.replace(/[^0-9.]/g, '')" onafterpaste="if(isNaN(value))execCommand('undo')" value="" style="width:120px;"/><font color="red">%</font>&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" id="fanDian_0" name="isFanDian" value="0" checked onclick="check1();">否
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boCustomerService.isCurrent.label"/>：</td>
                <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'isCurrent', 'errors')}"><g:checkBox name="isCurrent" value="${boCustomerServiceInstance?.isCurrent}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="boCustomerService.enable.label"/>：</td>
                <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'enable', 'errors')}"><g:checkBox name="enable" value="${boCustomerServiceInstance?.enable}"/></td>
            </tr>

             <tr>
                <td class="right label_name">${message(code:'是否提示合同到期',default:'是否提示合同到期')}：</td>
                <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'isViewDate', 'errors')}"><g:checkBox name="isViewDate" value="${boCustomerServiceInstance?.isViewDate}"/></td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定" onclick="return regPrice()"></span>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>
