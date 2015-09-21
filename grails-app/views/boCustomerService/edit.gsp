<%@ page import="boss.BoCustomerService" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boCustomerService.label', default: 'BoCustomerService')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
    <script type="text/javascript">
        function fromCheck() {
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
            if(document.getElementById("isFanDian_1").checked){
                if(document.getElementById("fanDianAmount").value=='' || document.getElementById("fanDianAmount").value==null){
                    alert("请输入返点率");
                    document.getElementById("fanDianAmount").focus();
                    return false;
                }
            }
            else {
                return true;
            }
        }

    function check1(){
        if(document.getElementById("isFanDian_1").checked){
            document.getElementById("fanDianAmount").disabled=false;
            document.getElementById("fanDianAmount").value=${boCustomerServiceInstance?.fanDianAmount==null?0:boCustomerServiceInstance?.fanDianAmount};
        }else{
            document.getElementById("fanDianAmount").value='';
            document.getElementById("fanDianAmount").disabled=true;
        }
    }
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
      if(document.getElementById("isFanDian_1").checked){
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
</head>
<body style="overflow-x:hidden">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <g:hasErrors bean="${boCustomerServiceInstance}">
        <div class="errors">
            <g:renderErrors bean="${boCustomerServiceInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form onsubmit="return fromCheck()" action="update">
        <g:hiddenField name="id" value="${boCustomerServiceInstance?.id}"/>
        <g:hiddenField name="customerId" value="${boCustomerServiceInstance?.customerId}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
            </tr>

            <g:if test="${boCustomerServiceInstance?.isCurrent==true}">
                <tr>
                    <td class="right label_name"><g:message code="boCustomerService.contractNo.label"/>：</td>
                    <td>${boCustomerServiceInstance?.contractNo}</td>
                </tr>

                <tr>
              <td class="right label_name"><g:message code="boCustomerService.serviceCode.label"/>：</td>
                <td>${BoCustomerService.serviceMap[boCustomerServiceInstance?.serviceCode]}</td>
                </td>
                </tr>

                <tr>
                    <td class="right label_name"><g:message code="boCustomerService.startTime.label"/>：</td>
                    <td><g:formatDate date="${boCustomerServiceInstance.startTime}" format="yyyy-MM-dd HH:mm:ss"/></td>
                </tr>

                <tr>
                    <td class="right label_name"><g:message code="boCustomerService.endTime.label"/>：</td>
                    <td><g:formatDate date="${boCustomerServiceInstance?.endTime}" format="yyyy-MM-dd HH:mm:ss"/></td>
                </tr>

                %{--<tr id="feeLabel">--}%
                    %{--<td class="right label_name"><g:message code="boCustomerService.feeParams.label"/>：</td>--}%
                    %{--<td class="${hasErrors(bean: boCustomerServiceInstance, field: 'feeParams', 'errors')}">${boCustomerServiceInstance?.feeParams}</td>--}%
                %{--</tr>--}%

                %{--<tr id="serviceLabel">--}%
                    %{--<td class="right label_name"><g:message code="boCustomerService.serviceParams.label"/>：</td>--}%
                    %{--<td class="${hasErrors(bean: boCustomerServiceInstance, field: 'serviceParams', 'errors')}">${boCustomerServiceInstance?.serviceParams}</td>--}%
                %{--</tr>--}%

                <tr>
                    <td class="right label_name"><g:message code="boCustomerService.belongToSale.label"/>：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'belongToSale', 'errors')}">${boCustomerServiceInstance?.belongToSale}</td>
                </tr>
                <tr>
                    <td class="right label_name"><g:message code="boCustomerService.isFanDian.label"/>：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'isFanDian', 'errors')}"><g:formatBoolean boolean="${boCustomerServiceInstance?.isFanDian}"/></td>
                </tr>
                <tr>
                    <td class="right label_name"><g:message code="boCustomerService.fanDianAmount.label"/>：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'fanDianAmount', 'errors')}">${boCustomerServiceInstance?.fanDianAmount}</td>
                </tr>
                <tr>
                    <td class="right label_name"><g:message code="boCustomerService.enable.label"/>：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'enable', 'errors')}"><g:formatBoolean boolean="${boCustomerServiceInstance?.enable}"/></td>

                </tr>
                 <tr>
                    <td class="right label_name">${message(code:'是否提示执照到期',default:'是否提示执照到期')}：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'isViewDate', 'errors')}"><g:checkBox name="isViewDate" value="${boCustomerServiceInstance?.isViewDate}"/></td>
                </tr>
            </g:if>
            <g:else>
                <tr>
                    <td class="right label_name"><g:message code="boCustomerService.contractNo.label"/><font color="red">*</font>：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'contractNo', 'errors')}"><g:textField name="contractNo" maxlength="20" value="${boCustomerServiceInstance?.contractNo}"/></td>
                </tr>

                <tr>
                    <td class="right label_name"><g:message code="boCustomerService.serviceCode.label"/><font color="red">*</font>：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'serviceCode', 'errors')}">
                        <g:select name="serviceCode" from="${BoCustomerService.serviceMap}" optionKey="key" optionValue="value" value="${boCustomerServiceInstance?.serviceCode}"/>
                    </td>
                </tr>

                <tr>
                    <td class="right label_name"><g:message code="boCustomerService.startTime.label"/>：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'startTime', 'errors')}"><bo:datePicker name="startTime" precision="day" value="${boCustomerServiceInstance?.startTime}"/></td>
                </tr>

                <tr>
                    <td class="right label_name"><g:message code="boCustomerService.endTime.label"/>：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'endTime', 'errors')}"><bo:datePicker name="endTime" precision="day" value="${boCustomerServiceInstance?.endTime}"/></td>
                </tr>

                <tr id="feeLabelEdit">
                    <td class="right label_name"><g:message code="boCustomerService.feeParams.label"/>：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'feeParams', 'errors')}"><g:textField name="feeParams" maxlength="64" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${boCustomerServiceInstance?.feeParams}"/></td>
                </tr>

                <tr id="serviceLabelEdit">
                    <td class="right label_name"><g:message code="boCustomerService.serviceParams.label"/>：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'serviceParams', 'errors')}"><g:textArea name="serviceParams" cols="40" rows="5" value="${boCustomerServiceInstance?.serviceParams}"/></td>
                </tr>

                <tr>
                    <td class="right label_name"><g:message code="boCustomerService.belongToSale.label"/>：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'belongToSale', 'errors')}"><g:textField name="belongToSale" maxlength="20" value="${boCustomerServiceInstance?.belongToSale}"/></td>
                </tr>

               <tr>
                <td class="right label_name"><g:message code="boCustomerService.isFanDian.label"/>：</td>
                <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'isFanDian', 'errors')}">
                    <g:radio name="isFanDian" id="isFanDian_1" value="1" checked="${boCustomerServiceInstance?.isFanDian?.equals(true)}" onclick="check1();"/>是&nbsp;&nbsp;
                    <g:message code="boCustomerService.fanDianAmount.label"/>&nbsp;<g:textField name="fanDianAmount" maxlength="64" onblur="regPrice();" onkeyup="value=value.replace(/[^0-9.]/g, '')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${boCustomerServiceInstance?.fanDianAmount}" style="width:120px;"/><font color="red">%</font>&nbsp;&nbsp;&nbsp;&nbsp;
                    <g:radio name="isFanDian" id="isFanDian_0" value="0" checked="${boCustomerServiceInstance?.isFanDian?.equals(false)}" onclick="check1();"/>否
                </td>
            </tr>

                <tr>
                    <td class="right label_name"><g:message code="boCustomerService.enable.label"/>：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'enable', 'errors')}"><g:checkBox name="enable" value="${boCustomerServiceInstance?.enable}"/></td>
                </tr>

                 <tr>
                    <td class="right label_name">${message(code:'是否提示执照到期',default:'是否提示执照到期')}：</td>
                    <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'isViewDate', 'errors')}"><g:checkBox name="isViewDate" value="${boCustomerServiceInstance?.isViewDate}"/></td>
                </tr>

            </g:else>
            <tr>
                <td class="right label_name"><g:message code="boCustomerService.isCurrent.label"/>：</td>
                <td class="${hasErrors(bean: boCustomerServiceInstance, field: 'isCurrent', 'errors')}"><g:checkBox name="isCurrent" value="${boCustomerServiceInstance?.isCurrent}"/></td>
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
<script type="text/javascript">

    var serviceCode = "";
    <g:if test="${boCustomerServiceInstance?.isCurrent==true}">
    serviceCode = "${boCustomerServiceInstance?.serviceCode}";
    </g:if>
    <g:else>
    serviceCode = document.getElementById("serviceCode").value;
    </g:else>
    if (serviceCode == "agentcoll" || serviceCode == "agentpay") {
    <g:if test="${boCustomerServiceInstance?.isCurrent==true}">
        document.getElementById("feeLabel").style.display = "none";
        document.getElementById("serviceLabel").style.display = "none";
    </g:if>
    <g:else>
        document.getElementById("feeLabelEdit").style.display = "none";
        document.getElementById("serviceLabelEdit").style.display = "none";
    </g:else>
    }
</script>
</body>
</html>
