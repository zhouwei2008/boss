<%@ page import="settle.FtFeeChannel; settle.FtSrvType; settle.FtSrvTradeType; settle.FtTradeFee" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftTradeFee.label', default: 'FtTradeFee')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<g:javascript>
    window.onload = function changeFeeModel() {

        var str = "${ftTradeFeeInstance?.feeModel}";
        var step1FeeType= "${ftTradeFeeInstance?.step1FeeType}";
        var step2FeeType= "${ftTradeFeeInstance?.step2FeeType}";
        var step3FeeType= "${ftTradeFeeInstance?.step3FeeType}";
        var step4FeeType= "${ftTradeFeeInstance?.step4FeeType}";
        var step5FeeType= "${ftTradeFeeInstance?.step5FeeType}";
        var feeType="${ftTradeFeeInstance?.feeType}"

        if(step1FeeType!='' && step1FeeType!=-1){
            changeStepFeeType('1',step1FeeType)
        }
        if(step2FeeType!='' && step2FeeType!=-1){
            changeStepFeeType('2',step2FeeType)
        }
        if(step3FeeType!='' && step3FeeType!=-1){
            changeStepFeeType('3',step3FeeType)
        }
        if(step4FeeType!='' && step4FeeType!=-1){
            changeStepFeeType('4',step4FeeType)
        }
        if(step5FeeType!='' && step5FeeType!=-1){
            changeStepFeeType('5',step5FeeType)
        }
        if(feeType==1){
            changeFeeType(1)
        } else if (feeType==0) {
            changeFeeType(0)
        } else if (feeType==2) {
            changeFeeType(2)
        }
        if (str == 0) {
            document.getElementById("feeType1").style.display = 'table-row';
            document.getElementById("feeValue3").style.display = 'none';
            document.getElementById("firstLiqDate1").style.display = 'none';
            document.getElementById("packLen1").style.display = 'none';
            document.getElementById("jt").style.display = 'none';
            document.getElementById("jt1").style.display = 'none';
        } else if (str == 1) {
            document.getElementById("feeValue3").style.display = 'table-row';
            document.getElementById("feeType1").style.display = 'none';
            document.getElementById("feeValue1").style.display = 'none';
            document.getElementById("feeValue2").style.display = 'none';
            document.getElementById("packLen1").style.display = 'none';
            document.getElementById("jt").style.display = 'none';
            document.getElementById("jt1").style.display = 'none';
            document.getElementById("firstLiqDate1").style.display = 'table-row';
        } else if (str == 2) {
            document.getElementById("firstLiqDate1").style.display = 'table-row';
            document.getElementById("packLen1").style.display = 'table-row';
            document.getElementById("feeValue3").style.display = 'none';
            document.getElementById("feeType1").style.display = 'none';
            document.getElementById("feeValue1").style.display = 'none';
            document.getElementById("feeValue2").style.display = 'none';
            document.getElementById("jt").style.display = 'table-row';
            document.getElementById("jt1").style.display = 'table-row';
        }
    }

    $(function() {
        $("#dateBegin1").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#dateEnd1").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true ,minDate:new Date()});
        $("#firstLiqDate2").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });
    function checkDate() {
        var startDate = document.getElementById("dateBegin1").value;
        var endDate = document.getElementById("dateEnd1").value;
        var firstLiqDate = document.getElementById("firstLiqDate2").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("dateEnd1").focus();
            return false;
        }
        if (startDate < firstLiqDate && firstLiqDate != '') {
            alert("开始时间不能早于首节日时间！");
            document.getElementById("dateBegin1").focus();
            return false;
        }
    }
    function changeStepFeeType(i, str) {
        if (str == 1) {
            document.getElementById(i + "1").style.display = '';
            document.getElementById(i + "2").style.display = '';
            document.getElementById(i + "3").style.display = '';
            document.getElementById(i + "4").style.display = 'none';
        } else if (str == 0) {
            document.getElementById(i + "1").style.display = 'none';
            document.getElementById(i + "2").style.display = 'none';
            document.getElementById(i + "3").style.display = 'none';
            document.getElementById(i + "4").style.display = '';
        } else {
            document.getElementById(i + "1").style.display = 'none';
            document.getElementById(i + "2").style.display = 'none';
            document.getElementById(i + "3").style.display = 'none';
            document.getElementById(i + "4").style.display = 'none';
        }
    }
    function changeCategory(str) {
        if (str == 0) {
            document.getElementById("feeType1").style.display = 'table-row';
            document.getElementById("feeValue3").style.display = 'none';
            document.getElementById("firstLiqDate1").style.display = 'none';
            document.getElementById("packLen1").style.display = 'none';
            document.getElementById("jt").style.display = 'none';
            document.getElementById("jt1").style.display = 'none';
        } else if (str == 1) {
            document.getElementById("feeValue3").style.display = 'table-row';
            document.getElementById("feeType1").style.display = 'none';
            document.getElementById("feeValue1").style.display = 'none';
            document.getElementById("feeValue2").style.display = 'none';
            document.getElementById("packLen1").style.display = 'none';
            document.getElementById("jt").style.display = 'none';
            document.getElementById("jt1").style.display = 'none';
            document.getElementById("firstLiqDate1").style.display = 'table-row';
        } else if (str == 2) {
            document.getElementById("firstLiqDate1").style.display = 'table-row';
            document.getElementById("packLen1").style.display = 'table-row';
            document.getElementById("feeValue3").style.display = 'none';
            document.getElementById("feeType1").style.display = 'none';
            document.getElementById("feeValue1").style.display = 'none';
            document.getElementById("feeValue2").style.display = 'none';
            document.getElementById("jt").style.display = 'table-row';
            document.getElementById("jt1").style.display = 'table-row';
        } else {
            document.getElementById("feeValue3").style.display = 'none';
            document.getElementById("feeType1").style.display = 'none';
            document.getElementById("feeValue1").style.display = 'none';
            document.getElementById("feeValue2").style.display = 'none';
            document.getElementById("packLen1").style.display = 'none';
            document.getElementById("firstLiqDate1").style.display = 'none';
            document.getElementById("jt").style.display = 'none';
            document.getElementById("jt1").style.display = 'none';
        }
    }
    function changeFeeType(str) {
        if (str == 1) {
            document.getElementById("feeValue1").style.display = 'table-row';
            document.getElementById("feeValue2").style.display = 'none';
            document.getElementById("flowNote").style.display = 'none';
            document.getElementById("feeFlowTr").style.display = 'none';
            document.getElementById("feePreTr").style.display = 'none';
            document.getElementById("flowShow").style.display = 'none';
        } else if (str == 0) {
            document.getElementById("feeValue1").style.display = 'none';
            document.getElementById("feeValue2").style.display = 'table-row';
            document.getElementById("flowNote").style.display = 'none';
            document.getElementById("feeFlowTr").style.display = 'none';
            document.getElementById("feePreTr").style.display = 'none';
            document.getElementById("flowShow").style.display = 'none';
        } else if (str == 2) {
            document.getElementById("feeValue1").style.display = 'table-row';
            document.getElementById("feeValue2").style.display = 'none';
            document.getElementById("flowNote").style.display = 'table-row';
            document.getElementById("feeFlowTr").style.display = 'table-row';
            document.getElementById("feePreTr").style.display = 'table-row';
            document.getElementById("flowShow").style.display = 'table-row';
        } else {
            document.getElementById("feeValue1").style.display = 'none';
            document.getElementById("feeValue2").style.display = 'none';
            document.getElementById("flowNote").style.display = 'none';
            document.getElementById("feeFlowTr").style.display = 'none';
            document.getElementById("feePreTr").style.display = 'none';
            document.getElementById("flowShow").style.display = 'none';
        }
    }
    var money = 0;
    function checkFiled() {

        if (document.getElementById("feeType").value == '2') {
            if (document.getElementById("feeFlow").value == "") {
                alert("流量限额不允许为空，请填写流量限额！");
                document.getElementById("feeFlow").focus();
                return false;
            }
            if (document.getElementById("feePre").value == "") {
                alert("预付手续费不允许为空，请填写预付手续费！");
                document.getElementById("feePre").focus();
                return false;
            }
            if (document.getElementById("feePre").value - 1 <= -1) {
                alert("预付手续费必须大于0！");
                document.getElementById("feePre").focus();
                return false;
            }
        }
        if (document.getElementById("tradeType1").value == '') {
            alert("交易类型不允许为空，请选择交易类型！");
            document.getElementById("tradeType1").focus();
            return false;
        }
%{--if (document.getElementById("channelCode").value == '') {--}%
%{--alert("费率通道不允许为空，请选择费率通道！");--}%
%{--document.getElementById("channelCode").focus();--}%
%{--return false;--}%
%{--}--}%
    if (document.getElementById("feeModel").value == '') {
            alert("计费模式不允许为空，请选择计费模式！");
            document.getElementById("feeModel").focus();
            return false;
        } else if (document.getElementById("feeModel").value != null && document.getElementById("feeModel").value != '') {
            if (document.getElementById("feeModel").value == "0") {
                if (document.getElementById("feeType1").value == "") {
                    alert("分类不允许为空，请选择分类！");
                    document.getElementById("feeType").focus();
                    return false;
                } else if (document.getElementById("feeType").value == "1") {
                    if (document.getElementById("feeValue").value == "") {
                        alert("费率不允许为空，请填写费率！");
                        document.getElementById("feeValue").focus();
                        return false;
                    }
                    if (document.getElementById("c1").checked) {
                        if (document.getElementById("feeMin").value == "") {
                            alert("最低手续费不允许为空，请填写最低手续费！");
                            document.getElementById("feeMin").focus();
                            return false;
                        }
                    }
                    if (document.getElementById("c2").checked) {
                        if (document.getElementById("feeMax").value == "") {
                            alert("最高手续费不允许为空，请填写最高手续费！");
                            document.getElementById("feeMax").focus();
                            return false;
                        }
                    }
                    if (document.getElementById("feeMin").value != "" && document.getElementById("feeMax").value != "") {
                        if (document.getElementById("feeMax").value < document.getElementById("feeMin").value) {
                            alert("最高手续费不能小于最低手续费，请核实手续费！");
                            document.getElementById("feeMax").focus();
                            return false;
                        }
                    }
                } else if (document.getElementById("feeType").value == "0") {
                    if (document.getElementById("feeValue12").value == "") {
                        alert("费率不允许为空，请填写费率！");
                        document.getElementById("feeValue12").focus();
                        return false;
                    }
                } else if (document.getElementById("feeType").value == "2") {
                    if (document.getElementById("feeFlow").value == "") {
                        alert("流量限额不允许为空，请填写流量限额！");
                        document.getElementById("feeFlow").focus();
                        return false;
                    }
                    if (document.getElementById("feePre").value == "") {
                        alert("预付手续费不允许为空，请填写预付手续费！");
                        document.getElementById("feePre").focus();
                        return false;
                    }
                    if (document.getElementById("feePre").value - 1 <= -1) {
                        alert("预付手续费必须大于0！");
                        document.getElementById("feePre").focus();
                        return false;
                    }
                }
            } else if (document.getElementById("feeModel").value == "1") {
                if (document.getElementById("feeValue13").value == "") {
                    alert("费率不允许为空，请填写费率！");
                    document.getElementById("feeValue13").focus();
                    return false;
                }
                if (document.getElementById("packLen").value == "") {
                    alert("周期不允许为空，请填写周期！");
                    document.getElementById("packLen").focus();
                    return false;
                }
                if (document.getElementById("packType").value == "") {
                    alert("周期类型不允许为空，请选择周期类型！");
                    document.getElementById("packType").focus();
                    return false;
                }
                if (document.getElementById("firstLiqDate2").value == "") {
                    alert("首结日不允许为空，请选择首结日！");
                    document.getElementById("firstLiqDate2").focus();
                    return false;
                }
            } else if (document.getElementById("feeModel").value == "2") {
                if (document.getElementById("packLen11").value == "") {
                    alert("周期不允许为空，请填写周期！");
                    document.getElementById("packLen11").focus();
                    return false;
                }
                if (document.getElementById("packType11").value == "") {
                    alert("周期类型不允许为空，请选择周期类型！");
                    document.getElementById("packType11").focus();
                    return false;
                }
                if (document.getElementById("firstLiqDate2").value == "") {
                    alert("首结日不允许为空，请选择首结日！");
                    document.getElementById("firstLiqDate2").focus();
                    return false;
                }
                if (document.getElementById("step1To").value == "") {
                    alert("阶梯终止交易额不允许为空，请填写阶梯终止交易额！");
                    document.getElementById("step1To").focus();
                    return false;
                }
                if (document.getElementById("step1FeeType").value == "1") {
                    if (document.getElementById("step1FeeValue").value == "") {
                        alert("阶梯费率不允许为空，请填写阶梯费率！");
                        document.getElementById("step1FeeValue").focus();
                        return false;
                    }
                    if (document.getElementById("c11").checked) {
                        if (document.getElementById("step1FeeMin").value == "") {
                            alert("最低手续费不允许为空，请填写最低手续费！");
                            document.getElementById("step1FeeMin").focus();
                            return false;
                        }
                    }
                    if (document.getElementById("c21").checked) {
                        if (document.getElementById("step1FeeMax").value == "") {
                            alert("最高手续费不允许为空，请填写最高手续费！");
                            document.getElementById("step1FeeMax").focus();
                            return false;
                        }
                    }
                    if (document.getElementById("step1FeeMin").value != "" && document.getElementById("step1FeeMax").value != "") {
                        if (document.getElementById("step1FeeMax").value < document.getElementById("step1FeeMin").value) {
                            alert("最高手续费不能小于最低手续费，请核实手续费！");
                            document.getElementById("step1FeeMax").focus();
                            return false;
                        }
                    }
                } else {
                    if (document.getElementById("step1FeeValue1").value == "") {
                        alert("阶梯费率不允许为空，请填写阶梯费率！");
                        document.getElementById("step1FeeValue1").focus();
                        return false;
                    }
                }
                if (document.getElementById("step5FeeType").value == "1") {
                    if (document.getElementById("step5FeeValue").value == "") {
                        alert("阶梯费率不允许为空，请填写阶梯费率！");
                        document.getElementById("step5FeeValue").focus();
                        return false;
                    }
                    if (document.getElementById("c15").checked) {
                        if (document.getElementById("step5FeeMin").value == "") {
                            alert("最低手续费不允许为空，请填写最低手续费！");
                            document.getElementById("step5FeeMin").focus();
                            return false;
                        }
                    }
                    if (document.getElementById("c25").checked) {
                        if (document.getElementById("step5FeeMax").value == "") {
                            alert("最高手续费不允许为空，请填写最高手续费！");
                            document.getElementById("step5FeeMax").focus();
                            return false;
                        }
                    }
                    if (document.getElementById("step5FeeMin").value != "" && document.getElementById("step5FeeMax").value != "") {
                        if (document.getElementById("step5FeeMax").value < document.getElementById("step5FeeMin").value) {
                            alert("最高手续费不能小于最低手续费，请核实手续费！");
                            document.getElementById("step5FeeMax").focus();
                            return false;
                        }
                    }
                } else {
                    if (document.getElementById("step5FeeValue1").value == "") {
                        alert("阶梯费率不允许为空，请填写阶梯费率！");
                        document.getElementById("step5FeeValue1").focus();
                        return false;
                    }
                }
                if (document.getElementById("step2To") != null) {
                    if (document.getElementById("step2To").value == "") {
                        alert("阶梯终止交易额不允许为空，请填写阶梯终止交易额！");
                        document.getElementById("step2To").focus();
                        return false;
                    }
                    if (document.getElementById("step2FeeType").value == "1") {
                        if (document.getElementById("step2FeeValue").value == "") {
                            alert("阶梯费率不允许为空，请填写阶梯费率！");
                            document.getElementById("step2FeeValue").focus();
                            return false;
                        }
                        if (document.getElementById("c12").checked) {
                            if (document.getElementById("step2FeeMin").value == "") {
                                alert("最低手续费不允许为空，请填写最低手续费！");
                                document.getElementById("step2FeeMin").focus();
                                return false;
                            }
                        }
                        if (document.getElementById("c22").checked) {
                            if (document.getElementById("step2FeeMax").value == "") {
                                alert("最高手续费不允许为空，请填写最高手续费！");
                                document.getElementById("step2FeeMax").focus();
                                return false;
                            }
                        }
                        if (document.getElementById("step2FeeMin").value != "" && document.getElementById("step2FeeMax").value != "") {
                            if (document.getElementById("step2FeeMax").value < document.getElementById("step2FeeMin").value) {
                                alert("最高手续费不能小于最低手续费，请核实手续费！");
                                document.getElementById("step2FeeMax").focus();
                                return false;
                            }
                        }
                    } else {
                        if (document.getElementById("step2FeeValue1").value == "") {
                            alert("阶梯费率不允许为空，请填写阶梯费率！");
                            document.getElementById("step2FeeValue1").focus();
                            return false;
                        }
                    }
                }
                if (document.getElementById("step3To") != null) {
                    if (document.getElementById("step3To").value == "") {
                        alert("阶梯终止交易额不允许为空，请填写阶梯终止交易额！");
                        document.getElementById("step3To").focus();
                        return false;
                    }
                    if (document.getElementById("step3FeeType").value == "1") {
                        if (document.getElementById("step3FeeValue").value == "") {
                            alert("阶梯费率不允许为空，请填写阶梯费率！");
                            document.getElementById("step3FeeValue").focus();
                            return false;
                        }
                        if (document.getElementById("c13").checked) {
                            if (document.getElementById("step3FeeMin").value == "") {
                                alert("最低手续费不允许为空，请填写最低手续费！");
                                document.getElementById("step3FeeMin").focus();
                                return false;
                            }
                        }
                        if (document.getElementById("c23").checked) {
                            if (document.getElementById("step3FeeMax").value == "") {
                                alert("最高手续费不允许为空，请填写最高手续费！");
                                document.getElementById("step3FeeMax").focus();
                                return false;
                            }
                        }
                        if (document.getElementById("step3FeeMin").value != "" && document.getElementById("step3FeeMax").value != "") {
                            if (document.getElementById("step3FeeMax").value < document.getElementById("step3FeeMin").value) {
                                alert("最高手续费不能小于最低手续费，请核实手续费！");
                                document.getElementById("step3FeeMax").focus();
                                return false;
                            }
                        }
                    } else {
                        if (document.getElementById("step3FeeValue1").value == "") {
                            alert("阶梯费率不允许为空，请填写阶梯费率！");
                            document.getElementById("step3FeeValue1").focus();
                            return false;
                        }
                    }
                }
                if (document.getElementById("step4To") != null) {
                    if (document.getElementById("step4To").value == "") {
                        alert("阶梯终止交易额不允许为空，请填写阶梯终止交易额！");
                        document.getElementById("step4To").focus();
                        return false;
                    }
                    if (document.getElementById("step4FeeType").value == "1") {
                        if (document.getElementById("step4FeeValue").value == "") {
                            alert("阶梯费率不允许为空，请填写阶梯费率！");
                            document.getElementById("step4FeeValue").focus();
                            return false;
                        }
                        if (document.getElementById("c14").checked) {
                            if (document.getElementById("step4FeeMin").value == "") {
                                alert("最低手续费不允许为空，请填写最低手续费！");
                                document.getElementById("step4FeeMin").focus();
                                return false;
                            }
                        }
                        if (document.getElementById("c24").checked) {
                            if (document.getElementById("step4FeeMax").value == "") {
                                alert("最高手续费不允许为空，请填写最高手续费！");
                                document.getElementById("step4FeeMax").focus();
                                return false;
                            }
                        }
                        if (document.getElementById("step4FeeMin").value != "" && document.getElementById("step4FeeMax").value != "") {
                            if (document.getElementById("step4FeeMax").value < document.getElementById("step4FeeMin").value) {
                                alert("最高手续费不能小于最低手续费，请核实手续费！");
                                document.getElementById("step4FeeMax").focus();
                                return false;
                            }
                        }
                    } else {
                        if (document.getElementById("step4FeeValue1").value == "") {
                            alert("阶梯费率不允许为空，请填写阶梯费率！");
                            document.getElementById("step4FeeValue1").focus();
                            return false;
                        }
                    }
                }
            }
        }
        %{--if (document.getElementById("fetchType").value == '') {--}%
            %{--alert("结算方式不允许为空，请填写结算方式！");--}%
            %{--document.getElementById("fetchType").focus();--}%
            %{--return false;--}%
        %{--}--}%
        %{--if (document.getElementById("tradeWeight").value == '') {--}%
            %{--alert("收取方向不允许为空，请填写收取方向！");--}%
            %{--document.getElementById("tradeWeight").focus();--}%
            %{--return false;--}%
        %{--}--}%
        %{--if (document.getElementById("dateBegin1").value == '') {--}%
            %{--alert("有效期开始时间不允许为空，请填写有效期开始时间！");--}%
            %{--document.getElementById("dateBegin1").focus();--}%
            %{--return false;--}%
        %{--}--}%
        if (document.getElementById("dateEnd1").value == '') {
            alert("有效期结束时间不允许为空，请填写有效期结束时间！");
            document.getElementById("dateEnd1").focus();
            return false;
        }
    }
</g:javascript>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${ftTradeFeeInstance}">
        <div class="errors">
            <g:renderErrors bean="${ftTradeFeeInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="update">
        <g:hiddenField name="id" value="${ftTradeFeeInstance?.id}"/>
        <g:hiddenField name="srvName" value="${srvName}"/>
        <g:hiddenField name="feeModel" id="feeModel" value="${ftTradeFeeInstance?.feeModel}"/>
        <g:hiddenField name="feeType" id="feeType" value="${ftTradeFeeInstance?.feeType}"/>
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
            </tr>

            %{--<tr>--}%
            %{--<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;客户：${customerName}&nbsp;&nbsp;&nbsp;&nbsp; 服务：${settle.FtSrvType.findBySrvCode(srvType)?.srvName}--}%
            %{--<g:hiddenField name="customerName" value="${customerName}"></g:hiddenField>--}%
            %{--<g:hiddenField name="srvCode" value="${srvType}"></g:hiddenField>--}%
            %{--<g:hiddenField name="customerNo" value="${customerNo}"></g:hiddenField>--}%
            %{--<g:hiddenField name="srvId" value="${srvId}"></g:hiddenField>--}%
            %{--</td>--}%
            %{--<td>${FtSrvTradeType.get(ftTradeFeeInstance?.tradeType?.id)?.tradeName}</td>--}%
            %{--</tr>--}%

            <tr>
                <td class="right label_name"><g:message code="ftTradeFee.tradeType.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'tradeType', 'errors')}">
                    ${FtSrvTradeType.get(ftTradeFeeInstance?.tradeType?.id)?.tradeName}
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftTradeFee.channelCode.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'channelCode', 'errors')}">
                    <g:if test="${ftTradeFeeInstance?.channelCode!=null}">
                        ${FtFeeChannel.findByCode(ftTradeFeeInstance?.channelCode)?.name}
                    </g:if>
                    <g:else>全部</g:else>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftTradeFee.feeModel.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'feeModel', 'errors')}">
                    ${FtTradeFee.categoryMap[ftTradeFeeInstance?.feeModel]}
                </td>
            </tr>
            <tr id='feeType1' style="display:none">
                <td class="right label_name"><g:message code="ftTradeFee.feeType.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'feeType', 'errors')}">
                    ${FtTradeFee.feeType2Map[ftTradeFeeInstance?.feeType]}
                </td>
            </tr>

            <tr id='feeFlowTr' style="display:none">
                <td class="right label_name"><g:message code="流量限额"/>：</td>

                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'feeFlow', 'errors')}">
                    <g:if test="${ftTradeFeeInstance?.feeFlow}">
                        ${ftTradeFeeInstance?.feeFlow/10000}万元
                    </g:if>
                    <g:if test="${flag!='1'&& sign!='3'}">
                        &nbsp;&nbsp;增加<g:textField name="feeFlow" maxlength="5" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="0.0"/>万元
                    </g:if>
                </td>
            </tr>
            <tr id='feePreTr' style="display:none">
                <td class="right label_name"><g:message code="预付手续费"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'feePre', 'errors')}">
                    ${ftTradeFeeInstance?.feePre}元
                    <g:if test="${flag!='1'&& sign!='3'}">
                        &nbsp;&nbsp;增加<g:textField name="feePre" maxlength="5" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="0.0"/>元
                    </g:if>
                </td>
            </tr>

            <tr id='feeValue1' style="display:none">
                <td class="right label_name"><span id="flowShow">超量</span><g:message code="ftTradeFee.feeValue.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'feeValue', 'errors')}">
                    <g:formatNumber number="${ftTradeFeeInstance?.feeValue}" format="###,##0.00"/>%
                    最低 <g:formatNumber number="${ftTradeFeeInstance?.feeMin}" format="###,##0.00"/>元/笔
                    最高 <g:formatNumber number="${ftTradeFeeInstance?.feeMax}" format="###,##0.00"/>元/笔
                </td>
            </tr>

            <tr id='feeValue2' style="display:none">
                <td class="right label_name"><g:message code="ftTradeFee.feeValue.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'feeValue', 'errors')}">
                    <g:formatNumber number="${ftTradeFeeInstance?.feeValue}" format="###,##0.00"/>元/笔
                </td>
            </tr>

            <tr id='feeValue3' style="display:none">
                <td class="right label_name"><g:message code="ftTradeFee.feeValue.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'feeValue', 'errors')}">
                    <g:formatNumber number="${ftTradeFeeInstance?.feeValue}" format="###,##0.00"/>元/${ftTradeFeeInstance?.packLen}${FtTradeFee.packTypeMap[ftTradeFeeInstance?.packType]}
                </td>
            </tr>

            <tr id='packLen1' style="display:none">
                <td class="right label_name"><g:message code="ftTradeFee.packLen.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'packLen', 'errors')}">
                    ${ftTradeFeeInstance?.packLen}${FtTradeFee.packTypeMap[ftTradeFeeInstance?.packType]}
                </td>
            </tr>

            <tr id="firstLiqDate1" style="display:none">
                <td class="right label_name"><g:message code="ftTradeFee.firstLiqDate.label"/>：</td>
                <td>
                    ${firstDate}
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftTradeFee.fetchType.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'fetchType', 'errors')}">
                    ${FtTradeFee.fetchTypeMap[ftTradeFeeInstance?.fetchType]}
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftTradeFee.tradeWeight.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'tradeWeight', 'errors')}">
                    ${FtTradeFee.tradeWeightMap[ftTradeFeeInstance?.tradeWeight]}
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftTradeFee.dateBegin.label"/></td>
                <td>${beginDate}--<g:if test="${flag=='1'|| sign=='3'|| ftTradeFeeInstance.feeType == 2}">${endDate}</g:if>
                <g:else>
                    <g:textField name="dateEnd1" readonly="true" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${endDate}" class="right_top_h2_input"/></td>
                </g:else>

            </tr>
            <tr>
                <td class="right label_name">${message(code:"是否提示费率",default:"是否提示费率")}：</td>
                <td colspan = "8">
                    <span id="flowNote" style="display:none;">
                        <g:if test="${flag=='1'|| sign=='3'}">
                            80%：<g:if test="${ftTradeFeeInstance?.isViewPer == true}">是</g:if><g:else>否</g:else>&nbsp;&nbsp;
                            超量：<g:if test="${ftTradeFeeInstance?.isViewOver == true}">是</g:if><g:else>否</g:else>&nbsp;&nbsp;
                        </g:if>
                        <g:else>
                            <g:checkBox name="isViewPer" value="${ftTradeFeeInstance?.isViewPer}"/>80%&nbsp;&nbsp;
                            <g:checkBox name="isViewOver" value="${ftTradeFeeInstance?.isViewOver}"/>超量&nbsp;&nbsp;
                        </g:else>
                    </span>
                    <g:if test="${flag=='1'|| sign=='3'}">
                        到期：<g:if test="${ftTradeFeeInstance?.isViewDate == true}">是</g:if><g:else>否</g:else>&nbsp;&nbsp;
                    </g:if>
                    <g:else>
                        <g:checkBox name="isViewDate" value="${ftTradeFeeInstance?.isViewDate}"/>到期
                    </g:else>
                </td>
            </tr>

            <tr id="jt" style="display:none">
                <td colspan="2" >
                    <table width="100%" id="fljt"  cellpadding="0" cellspacing="0">
                        <tr>
                            <td colspan="6">费率阶梯：</td>
                        </tr>
                        <tr>
                            <td>
                                0 ~ <g:formatNumber number="${ftTradeFeeInstance?.step1To}" format="###,##0.00"/> 元
                            </td>
                            <td>
                                ${FtTradeFee.feeTypeMap[ftTradeFeeInstance?.step1FeeType]}
                            </td>
                            <td id="11">
                                <g:formatNumber number="${ftTradeFeeInstance?.step1FeeValue}" format="###,##0.00"/>%
                            </td>

                            <td id="12">
                                最低 <g:formatNumber number="${ftTradeFeeInstance?.step1FeeMin}" format="###,##0.00"/>元/笔
                            </td>
                            <td id="13" colspan="2">
                                最高 <g:formatNumber number="${ftTradeFeeInstance?.step1FeeMax}" format="###,##0.00"/>元/笔
                            </td>
                            <td id="14" colspan="4" style="display:none">
                                <g:formatNumber number="${ftTradeFeeInstance?.step1FeeValue}" format="###,##0.00"/>元
                            </td>
                            <td>
                                <g:hiddenField name="num" value="1"></g:hiddenField>
                            </td>
                        </tr>

                        <g:if test="${ftTradeFeeInstance?.step2To!=0 && ftTradeFeeInstance?.step2To!=null}">
                            <tr>
                                <td>
                                    <g:formatNumber number="${ftTradeFeeInstance?.step1To}" format="###,##0.00"/>~ <g:formatNumber number="${ftTradeFeeInstance?.step2To}" format="###,##0.00"/> 元
                                </td>
                                <td>
                                    ${FtTradeFee.feeTypeMap[ftTradeFeeInstance?.step2FeeType]}
                                </td>
                                <td id="21">
                                    <g:formatNumber number="${ftTradeFeeInstance?.step2FeeValue}" format="###,##0.00"/>%
                                </td>

                                <td id="22">
                                    最低 <g:formatNumber number="${ftTradeFeeInstance?.step2FeeMin}" format="###,##0.00"/>元/笔
                                </td>
                                <td id="23">
                                    最高 <g:formatNumber number="${ftTradeFeeInstance?.step2FeeMax}" format="###,##0.00"/>元/笔
                                </td>
                                <td id="24" colspan="4" style="display:none">
                                    <g:formatNumber number="${ftTradeFeeInstance?.step2FeeValue}" format="###,##0.00"/>元
                                </td>

                                <td>
                                    <g:hiddenField name="num" value="2"></g:hiddenField>
                                </td>
                            </tr>
                        </g:if>
                        <g:if test="${ftTradeFeeInstance?.step3To!=0 && ftTradeFeeInstance?.step3To!=null}">
                            <tr>
                                <td>
                                    <g:formatNumber number="${ftTradeFeeInstance?.step2To}" format="###,##0.00"/>~ <g:formatNumber number="${ftTradeFeeInstance?.step3To}" format="###,##0.00"/> 元
                                </td>
                                <td>
                                    ${FtTradeFee.feeTypeMap[ftTradeFeeInstance?.step3FeeType]}
                                </td>
                                <td id="31">
                                    <g:formatNumber number="${ftTradeFeeInstance?.step3FeeValue}" format="###,##0.00"/>%
                                </td>

                                <td id="32">
                                    最低 <g:formatNumber number="${ftTradeFeeInstance?.step3FeeMin}" format="###,##0.00"/>元/笔
                                </td>
                                <td id="33">
                                    最高 <g:formatNumber number="${ftTradeFeeInstance?.step3FeeMax}" format="###,##0.00"/>元/笔
                                </td>
                                <td colspan="4" style="display:none" id="34">
                                    <g:formatNumber number="${ftTradeFeeInstance?.step3FeeValue}" format="###,##0.00"/>元
                                </td>

                                <td>
                                    <g:hiddenField name="num" value="3"></g:hiddenField>
                                </td>
                            </tr>
                        </g:if>
                        <g:if test="${ftTradeFeeInstance?.step4To!=0 && ftTradeFeeInstance?.step4To!=null}">
                            <tr>
                                <td>
                                    <g:formatNumber number="${ftTradeFeeInstance?.step3To}" format="###,##0.00"/>~ <g:formatNumber number="${ftTradeFeeInstance?.step4To}" format="###,##0.00"/> 元
                                </td>
                                <td>
                                    ${FtTradeFee.feeTypeMap[ftTradeFeeInstance?.step4FeeType]}
                                </td>
                                <td id="41">
                                    <g:formatNumber number="${ftTradeFeeInstance?.step4FeeValue}" format="###,##0.00"/>%
                                </td>

                                <td id="42">
                                    最低 <g:formatNumber number="${ftTradeFeeInstance?.step4FeeMin}" format="###,##0.00"/>元/笔
                                </td>
                                <td id="43">
                                    最高 <g:formatNumber number="${ftTradeFeeInstance?.step4FeeMax}" format="###,##0.00"/>元/笔
                                </td>
                                <td id="44" colspan="4" style="display:none">
                                    <g:formatNumber number="${ftTradeFeeInstance?.step4FeeValue}" format="###,##0.00"/>元
                                </td>

                                <td>
                                    <g:hiddenField name="num" value="4"></g:hiddenField>
                                </td>
                            </tr>
                        </g:if>
                    </table>
                </td>
            </tr>
            <tr id="jt1" style="display:none">
                <td colspan="2" >
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="fljt1">
                        <tr>
                            <td>
                                大于<g:formatNumber number="${ftTradeFeeInstance.step5To}" format="###,##0.00"/>元
                            </td>
                            <td>
                                ${FtTradeFee.feeTypeMap[ftTradeFeeInstance?.step5FeeType]}
                            </td>
                            <td id="51">
                                <g:formatNumber number="${ftTradeFeeInstance?.step5FeeValue}" format="###,##0.00"/>%
                            </td>
                            <td id="52">
                                最低<g:formatNumber number="${ftTradeFeeInstance?.step5FeeMin}" format="###,##0.00"></g:formatNumber>元/笔
                            </td>
                            <td id="53" colspan="2">
                                最高 <g:formatNumber number="${ftTradeFeeInstance?.step5FeeMax}" format="###,##0.00"/>元/笔
                            </td>
                            <td id="54" colspan="4" style="display:none">
                                <g:formatNumber number="${ftTradeFeeInstance?.step5FeeValue}" format="###,##0.00"/>元
                            </td>
                            <td></td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                %{--<span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定"></span>--}%
                    <g:if test="${flag=='0'}">
                        <span class="content"><g:actionSubmit value="确定" action="update" class="rigt_button" onclick="return checkFiled()"></g:actionSubmit>
                    </g:if>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>
