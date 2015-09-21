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
        var str = document.getElementById("feeModel").value;
        var feeValue=${ftTradeFeeInstance?.feeValue};
        var toValue2= "${ftTradeFeeInstance?.step2To}";
        var toValue3= "${ftTradeFeeInstance?.step3To}";
        var toValue4= "${ftTradeFeeInstance?.step4To}";
        var feeType="${ftTradeFeeInstance?.feeType}"
        var step1FeeType= "${ftTradeFeeInstance?.step1FeeType}";
        var step2FeeType= "${ftTradeFeeInstance?.step2FeeType}";
        var step3FeeType= "${ftTradeFeeInstance?.step3FeeType}";
        var step4FeeType= "${ftTradeFeeInstance?.step4FeeType}";
        var step5FeeType= "${ftTradeFeeInstance?.step5FeeType}";
        if(feeValue){
            if(feeType==1){
                 document.getElementById("feeValue").value=feeValue;
            }else if(feeType==0){
                 document.getElementById("feeValue12").value=feeValue;
            }
        }
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
        }else if(feeType==0){
            changeFeeType(0)
        }
        if(toValue2!=0){
            document.getElementById("bt2").style.display = 'table-row';
        }
        if(toValue3!=0){
            document.getElementById("bt2").style.display = 'none';
            document.getElementById("bt3").style.display = 'table-row';
        }
        if(toValue4!=0){
            document.getElementById("bt2").style.display = 'none';
            document.getElementById("bt3").style.display = 'none';
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
    function changeCategory(str) {
        if (str == 0) {
            document.getElementById("feeType1").style.display = 'table-row';
            if(${ftTradeFeeInstance?.feeType}==0){
                 document.getElementById("feeValue2").style.display = 'table-row';
            }else if(${ftTradeFeeInstance?.feeType}==1){
                  document.getElementById("feeValue1").style.display = 'table-row';
            }
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
            document.getElementById("feeValue").value=${ftTradeFeeInstance?.feeValue};
        } else if (str == 0) {
            document.getElementById("feeValue1").style.display = 'none';
            document.getElementById("feeValue2").style.display = 'table-row';
            document.getElementById("feeValue12").value=${ftTradeFeeInstance?.feeValue};
        } else {
            document.getElementById("feeValue1").style.display = 'none';
            document.getElementById("feeValue2").style.display = 'none';
        }
    }
    var money = 0;
    function AddAction() {
        var _table = document.getElementById("fljt");
        var cks = document.getElementsByName("num");
        if (cks.length > 3) {
            alert("费率阶梯最多允许有5个！");
            return false;
        }
        for (var j = cks.length; j <= cks.length; j++) {
            if (j >= 2) {
                document.getElementById("button" + j).style.display = 'none';
            }
            if (j >= 1) {
                if (!document.getElementById("step" + j + "To").value) {
                    alert("请填写区间金额！");
                    document.getElementById("button" + j).style.display = '';
                    return false;
                }
                money = document.getElementById("step" + j + "To").value;
            }
        }
        var _tr = _table.insertRow(-1);
        var _td = new Array(8);
        for (var i = 0; i < _td.length; i++) {
            _td[i] = _tr.insertCell(-1);
        }
        _td[2].id = j + '1';
        _td[3].id = j + '2';
        _td[4].id = j + '3';
        _td[5].id = j + '4';
        _td[5].style.display = 'none';
        _td[5].colSpan = '4';
        _td[0].innerHTML = "<input type='text' name='step" + j + "From' id='step" + j + "From' style='width:60px;' value='"+money+"' readonly='true' onblur='checkMoney1(this.value, " + j + ")'/>~<input type='text' name='step" + j + "To' id='step" + j + "To' style='width:60px;' value='' onblur='checkMoney(this.value, " + j + ");checkValue(this.value, " + j + ");checkMoney1(this.value, " + j + ")'/>元";
        _td[1].innerHTML = "<select id='step" + j + "FeeType' name='step" + j + "FeeType' size='1' onchange='changeStepFeeType(" + j + ", this.value)'><option value='1'>按流量</option> <option value='0'>按笔</option></select> ";
        _td[2].innerHTML = "<input type='text' maxlength='12' name='step" + j + "FeeValue' id='step" + j + "FeeValue' style='width:60px;' onblur='checkFee(this.value, " + j + ")' value=''/>%";
        _td[3].innerHTML = "最低<input type='text' maxlength='7' name='step" + j + "FeeMin' id='step" + j + "FeeMin' style='width:60px;' onblur='checkMin(this.value, " + j + ")' value=''/>元/笔";
        _td[4].innerHTML = "最高<input type='text' maxlength='7' name='step" + j + "FeeMax' id='step" + j + "FeeMax' style='width:60px;' onblur='checkMax(this.value, " + j + ")' value=''/>元/笔";
        _td[5].innerHTML = "<input type='text' maxlength='12' name='step" + j + "FeeValue1' id='step" + j + "FeeValue1' style='width:60px;' onblur='checkFeeValue(this.value, " + j + ")' value=''/>元";
        _td[6].innerHTML = "<input type='button' name='button' id='button" + j + "' value='删除' style='width:60px;' onclick='TableDel()'/>";
        _td[7].innerHTML = "<input type='hidden' name='num' id='num' value='" + j + "'/>";
    }
    function TableDel() {
        var _table = document.getElementById("fljt");
        var len = document.getElementsByName("num").length;
        if (len > 2) {
            if(document.getElementById("bt" + (len - 1))!=null){
                document.getElementById("bt" + (len - 1)).style.display = 'table-row';
            }
             document.getElementById("button" + (len - 1)).style.display = 'table-row';
        }
        document.getElementById("step" + (len - 1) + "To").focus();
        _table.deleteRow(len);
    }
    function checkMoney(str, i) {
        var len= document.getElementsByName("num").length;
        if (isNaN(str)) {
            document.getElementById("step" + i + "To").value = '';
            document.getElementById("step5To").value = ''
            document.getElementById("step" + i + "To").focus();
        } else {
            if(len==1){
                 document.getElementById("step5To").value = str;
            }else{
                if(i==len){
                    document.getElementById("step5To").value = str;
                    document.getElementById("step5To").focus();
                }else{
                    document.getElementById("step" + (i + 1) + "From").value = str;
                    document.getElementById("step" + (i + 1) + "From").focus();
                }
            }
        }
%{--if (i > 1) {--}%
%{--if (document.getElementById("step" + i + "To").value - document.getElementById("step" + (i - 1) + "To").value <= 0) {--}%
%{--alert("终止交易额应大于起始交易额！");--}%
%{--document.getElementById("step" + i + "To").focus();--}%
%{--return false;--}%
%{--}--}%
%{--}--}%
%{--if (document.getElementById("step1To").value == 0) {--}%
%{--alert("终止交易额应大于起始交易额！");--}%
%{--document.getElementById("step5To").value = document.getElementById("step1To").value;--}%
%{--document.getElementById("step1To").focus();--}%
%{--return false;--}%
%{--}--}%
    document.getElementById("step" + i + "To").value = str.replace(/[ ]/g, '');
}

function checkMoney1(str, i) {
    if (i > 1) {
        if (document.getElementById("step" + i + "To").value - document.getElementById("step" + (i - 1) + "To").value <= 0) {
            alert("终止交易额应大于起始交易额！");
            document.getElementById("step" + i + "To").focus();
            return false;
        }
    }
    if (document.getElementById("step1To").value == 0) {
        alert("终止交易额应大于起始交易额！");
        document.getElementById("step5To").value = document.getElementById("step1To").value;
        document.getElementById("step1To").focus();
        return false;
    }
//        document.getElementById("step" + i + "To").value = str.replace(/[ ]/g, '');
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
function checkValue(str, i) {
    if (isNaN(str)) {
        document.getElementById("step" + i + "To").value = '';
        document.getElementById("step" + i + "To").focus();
    }
}
function checkFee(str, i) {

    if (isNaN(str)) {
        document.getElementById("step" + i + "FeeValue").value = '';
        document.getElementById("step" + i + "FeeValue").focus();
    }
}
function checkMax(str, i) {

    if (isNaN(str)) {
        document.getElementById("step" + i + "FeeMax").value = '';
        document.getElementById("step" + i + "FeeMax").focus();
    }
}
function checkMin(str, i) {

    if (isNaN(str)) {
        document.getElementById("step" + i + "FeeMin").value = '';
        document.getElementById("step" + i + "FeeMin").focus();
    }
}
function checkFeeValue(str, i) {

    if (isNaN(str)) {
        document.getElementById("step" + i + "FeeValue1").value = '';
        document.getElementById("step" + i + "FeeValue1").focus();
    }
}
function checkFiled() {
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
            if (document.getElementById("feeType").value == "") {
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
        if (document.getElementById("feeMax").value - document.getElementById("feeMin").value < 0) {
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
    if (document.getElementById("step1FeeValue").value == "" || document.getElementById("step1FeeValue").value<=0) {
        alert("阶梯费率不允许为空或不大于零，请填写阶梯费率！");
        document.getElementById("step1FeeValue").focus();
        return false;
    }
%{--if (document.getElementById("c11").checked) {--}%
%{--if (document.getElementById("step1FeeMin").value == "") {--}%
%{--alert("最低手续费不允许为空，请填写最低手续费！");--}%
%{--document.getElementById("step1FeeMin").focus();--}%
%{--return false;--}%
%{--}--}%
%{--}--}%
%{--alert(888);--}%
%{--if (document.getElementById("c21").checked) {--}%
%{--if (document.getElementById("step1FeeMax").value == "") {--}%
%{--alert("最高手续费不允许为空，请填写最高手续费！");--}%
%{--document.getElementById("step1FeeMax").focus();--}%
%{--return false;--}%
%{--}--}%
%{--}--}%
    if (document.getElementById("step1FeeMin").value != "" && document.getElementById("step1FeeMax").value != "") {
        if (document.getElementById("step1FeeMax").value - document.getElementById("step1FeeMin").value < 0) {
            alert("最高手续费不能小于最低手续费，请核实手续费！");
            document.getElementById("step1FeeMax").focus();
            return false;
        }
    }
} else {
    if (document.getElementById("step1FeeValue1").value == "" || document.getElementById("step1FeeValue1").value<=0) {
        alert("阶梯费率不允许为空或不大于零，请填写阶梯费率！");
        document.getElementById("step1FeeValue1").focus();
        return false;
    }
}
if (document.getElementById("step5FeeType").value == "1") {
    if (document.getElementById("step5FeeValue").value == "" || document.getElementById("step5FeeValue").value<=0) {
        alert("阶梯费率不允许为空或不大于零，请填写阶梯费率！");
        document.getElementById("step5FeeValue").focus();
        return false;
    }
%{--if (document.getElementById("c15").checked) {--}%
%{--if (document.getElementById("step5FeeMin").value == "") {--}%
%{--alert("最低手续费不允许为空，请填写最低手续费！");--}%
%{--document.getElementById("step5FeeMin").focus();--}%
%{--return false;--}%
%{--}--}%
%{--}--}%
%{--if (document.getElementById("c25").checked) {--}%
%{--if (document.getElementById("step5FeeMax").value == "") {--}%
%{--alert("最高手续费不允许为空，请填写最高手续费！");--}%
%{--document.getElementById("step5FeeMax").focus();--}%
%{--return false;--}%
%{--}--}%
%{--}--}%
    if (document.getElementById("step5FeeMin").value != "" && document.getElementById("step5FeeMax").value != "") {
        if (document.getElementById("step5FeeMax").value - document.getElementById("step5FeeMin").value < 0) {
            alert("最高手续费不能小于最低手续费，请核实手续费！");
            document.getElementById("step5FeeMax").focus();
            return false;
        }
    }
    } else {
        if (document.getElementById("step5FeeValue1").value == "" || document.getElementById("step5FeeValue1").value<=0) {
            alert("阶梯费率不允许为空或不大于零，请填写阶梯费率！");
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
    if (document.getElementById("step2FeeValue").value == ""  || document.getElementById("step2FeeValue").value <= 0) {
        alert("阶梯费率不允许为空或不大于零，请填写阶梯费率！");
        document.getElementById("step2FeeValue").focus();
        return false;
    }
%{--if (document.getElementById("c12").checked) {--}%
%{--if (document.getElementById("step2FeeMin").value == "") {--}%
%{--alert("最低手续费不允许为空，请填写最低手续费！");--}%
%{--document.getElementById("step2FeeMin").focus();--}%
%{--return false;--}%
%{--}--}%
%{--}--}%
%{--if (document.getElementById("c22").checked) {--}%
%{--if (document.getElementById("step2FeeMax").value == "") {--}%
%{--alert("最高手续费不允许为空，请填写最高手续费！");--}%
%{--document.getElementById("step2FeeMax").focus();--}%
%{--return false;--}%
%{--}--}%
%{--}--}%
    if (document.getElementById("step2FeeMin").value != "" && document.getElementById("step2FeeMax").value != "") {
        if (document.getElementById("step2FeeMax").value - document.getElementById("step2FeeMin").value < 0) {
            alert("最高手续费不能小于最低手续费，请核实手续费！");
            document.getElementById("step2FeeMax").focus();
            return false;
        }
    }
    } else {
    if (document.getElementById("step2FeeValue1").value == "" || document.getElementById("step2FeeValue1").value <= 0) {
        alert("阶梯费率不允许为空或不大于零，请填写阶梯费率！");
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
    if (document.getElementById("step3FeeValue").value == "" || document.getElementById("step3FeeValue").value <= 0) {
        alert("阶梯费率不允许为空或不大于零，请填写阶梯费率！");
        document.getElementById("step3FeeValue").focus();
        return false;
    }
%{--if (document.getElementById("c13").checked) {--}%
%{--if (document.getElementById("step3FeeMin").value == "") {--}%
%{--alert("最低手续费不允许为空，请填写最低手续费！");--}%
%{--document.getElementById("step3FeeMin").focus();--}%
%{--return false;--}%
%{--}--}%
%{--}--}%
%{--if (document.getElementById("c23").checked) {--}%
%{--if (document.getElementById("step3FeeMax").value == "") {--}%
%{--alert("最高手续费不允许为空，请填写最高手续费！");--}%
%{--document.getElementById("step3FeeMax").focus();--}%
%{--return false;--}%
%{--}--}%
%{--}--}%
    if (document.getElementById("step3FeeMin").value != "" && document.getElementById("step3FeeMax").value != "") {
        if (document.getElementById("step3FeeMax").value - document.getElementById("step3FeeMin").value < 0) {
            alert("最高手续费不能小于最低手续费，请核实手续费！");
            document.getElementById("step3FeeMax").focus();
            return false;
        }
        }
    } else {
    if (document.getElementById("step3FeeValue1").value == "" || document.getElementById("step3FeeValue1").value <= 0) {
        alert("阶梯费率不允许为空或不大于零，请填写阶梯费率！");
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
    if (document.getElementById("step4FeeValue").value == "" || document.getElementById("step4FeeValue").value <= 0) {
        alert("阶梯费率不允许为空或不大于零，请填写阶梯费率！");
        document.getElementById("step4FeeValue").focus();
        return false;
    }
%{--if (document.getElementById("c14").checked) {--}%
%{--if (document.getElementById("step4FeeMin").value == "") {--}%
%{--alert("最低手续费不允许为空，请填写最低手续费！");--}%
%{--document.getElementById("step4FeeMin").focus();--}%
%{--return false;--}%
%{--}--}%
%{--}--}%
%{--if (document.getElementById("c24").checked) {--}%
%{--if (document.getElementById("step4FeeMax").value == "") {--}%
%{--alert("最高手续费不允许为空，请填写最高手续费！");--}%
%{--document.getElementById("step4FeeMax").focus();--}%
%{--return false;--}%
%{--}--}%
%{--}--}%
    if (document.getElementById("step4FeeMin").value != "" && document.getElementById("step4FeeMax").value != "") {
        if (document.getElementById("step4FeeMax").value - document.getElementById("step4FeeMin").value < 0) {
            alert("最高手续费不能小于最低手续费，请核实手续费！");
            document.getElementById("step4FeeMax").focus();
            return false;
        }
    }
} else {
     if (document.getElementById("step4FeeValue1").value == "" || document.getElementById("step4FeeValue1").value <= 0) {
            alert("阶梯费率不允许为空或不大于零，请填写阶梯费率！");
            document.getElementById("step4FeeValue1").focus();
            return false;
        }
     }
    }
}
        }
        if (document.getElementById("fetchType").value == '') {
            alert("结算方式不允许为空，请填写结算方式！");
            document.getElementById("fetchType").focus();
            return false;
        }
        if (document.getElementById("tradeWeight").value == '') {
            alert("收取方向不允许为空，请填写收取方向！");
            document.getElementById("tradeWeight").focus();
            return false;
        }
        if (document.getElementById("dateBegin1").value == '') {
            alert("有效期开始时间不允许为空，请填写有效期开始时间！");
            document.getElementById("dateBegin1").focus();
            return false;
        }
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
        <g:hiddenField name="check" value="${flag}"/>
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
                    <g:select from="${FtSrvTradeType.findAllBySrv(FtSrvType.findBySrvName(srvName))}" value="${ftTradeFeeInstance?.tradeType?.id}" name="tradeType1" id="tradeType1" optionKey="id" optionValue="tradeName" noSelection="${['':'-请选择-']}" class="right_top_h2_input"></g:select>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftTradeFee.channelCode.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'channelCode', 'errors')}">
                    <g:select from="${FtFeeChannel.findAllByType(FtSrvType.findBySrvName(srvName)?.srvCode)}" name="channelCode" value="${ftTradeFeeInstance.channelCode}" id="channelCode" optionKey="code" optionValue="name" noSelection="${['':'-全部-']}" class="right_top_h2_input"></g:select>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftTradeFee.feeModel.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'feeModel', 'errors')}">
                    <g:select name="feeModel" value="${ftTradeFeeInstance.feeModel}" from="${FtTradeFee.categoryMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input" onchange="changeCategory(this.value)"/>
                </td>
            </tr>


            <tr id='feeType1' style="display:none">
                <td class="right label_name"><g:message code="ftTradeFee.feeType.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'feeType', 'errors')}">
                    <g:select name="feeType" value="${ftTradeFeeInstance.feeType}" from="${FtTradeFee.feeTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input" onchange="changeFeeType(this.value)"/>
                </td>
            </tr>


            <tr id='feeValue1' style="display:none">
                <td class="right label_name"><g:message code="ftTradeFee.feeValue.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'feeValue', 'errors')}">
                    <g:textField name="feeValue" maxlength="5" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.feeValue}"/> %
                    最低 <g:textField name="feeMin" maxlength="7" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.feeMin}"/>元/笔
                    最高 <g:textField name="feeMax" maxlength="7" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.feeMax}"/>元/笔
                </td>
            </tr>

            <tr id='feeValue2' style="display:none">
                <td class="right label_name"><g:message code="ftTradeFee.feeValue.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'feeValue', 'errors')}">
                    <g:textField name="feeValue12" maxlength="12" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.feeValue}"/>元/笔
                </td>
            </tr>

            <tr id='feeValue3' style="display:none">
                <td class="right label_name"><g:message code="ftTradeFee.feeValue.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'feeValue', 'errors')}">
                    <g:textField name="feeValue13" maxlength="12" style="width:60px;" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${ftTradeFeeInstance?.feeValue}"/>元/
                    <g:textField name="packLen" maxlength="5" style="width:60px;" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${ftTradeFeeInstance?.packLen}"/>
                    <g:select name="packType" value="${ftTradeFeeInstance.packType}" from="${FtTradeFee.packTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
                </td>
            </tr>

            <tr id='packLen1' style="display:none">
                <td class="right label_name"><g:message code="ftTradeFee.packLen.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'packLen', 'errors')}">
                    <g:textField name="packLen11" maxlength="5" style="width:60px;" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${ftTradeFeeInstance?.packLen}"/>
                    <g:select name="packType11" value="${ftTradeFeeInstance.packType}" from="${FtTradeFee.packTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
                </td>
            </tr>

            <tr id="firstLiqDate1" style="display:none">
                <td class="right label_name"><g:message code="ftTradeFee.firstLiqDate.label"/>：</td>
                <td>
                    <g:textField name="firstLiqDate2" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${firstDate}" class="right_top_h2_input"/>
                </td>
            </tr>


            <tr>
                <td class="right label_name"><g:message code="ftTradeFee.fetchType.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'fetchType', 'errors')}">
                    <g:select name="fetchType" value="${ftTradeFeeInstance.fetchType}" from="${FtTradeFee.fetchTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftTradeFee.tradeWeight.label"/>：</td>
                <td class="${hasErrors(bean: ftTradeFeeInstance, field: 'tradeWeight', 'errors')}">
                    <g:select name="tradeWeight" value="${ftTradeFeeInstance.tradeWeight}" from="${FtTradeFee.tradeWeightMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="ftTradeFee.dateBegin.label"/>：</td>
                <td><g:textField name="dateBegin1" readonly="true" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${beginDate}" class="right_top_h2_input"/>--
                    <g:textField name="dateEnd1"  readonly="true" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${endDate}" class="right_top_h2_input"/></td>
                <script>
                    $(function() {
                        $("#dateBegin1").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
                        $("#dateEnd1").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
                        $("#firstLiqDate2").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
                    });
                </script>
            </tr>
            <tr>
                <td class="right label_name">${message(code:"是否提示费率",default:"是否提示费率")}：</td>
                <td colspan = "8">
                    <g:checkBox name="isViewDate" value="${ftTradeFeeInstance?.isViewDate}"/>到期
                </td>
            </tr>


            <tr id="jt" style="display:none">
                <td colspan="2">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="fljt">
                        <tr>
                            <td colspan="5">费率阶梯：</td>
                            <td><input type="button" value="添加阶梯" onclick="AddAction()"/></td>
                        </tr>
                        <tr>
                            <td>
                                0~<g:textField name="step1To" id="step1To" maxlength="12" style="width:60px;" onblur="value=value.replace(/[ ]/g,'');checkMoney(this.value,1)" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${step1To}"/>元
                            </td>
                            <td>
                                <g:select name="step1FeeType" value="${ftTradeFeeInstance.step1FeeType}" from="${FtTradeFee.feeTypeMap}" optionKey="key" optionValue="value" class="right_top_h2_input" onchange="changeStepFeeType('1',this.value)"/>
                            </td>
                            <td id="11">
                                <g:textField name="step1FeeValue" maxlength="12" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${step1FeeValue}"/>%
                            </td>

                            <td id="12">
                                最低 <g:textField name="step1FeeMin" maxlength="7" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.step1FeeMin}"/>元/笔
                            </td>
                            <td id="13" colspan="2">
                                最高 <g:textField name="step1FeeMax" maxlength="7" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.step1FeeMax}"/>元/笔
                            </td>
                            <td id="14" colspan="4" style="display:none">
                                <g:textField name="step1FeeValue1" maxlength="12" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${step1FeeValue}"/>元
                            </td>
                            <td>
                                <g:hiddenField name="num" value="1"></g:hiddenField>
                            </td>
                        </tr>
                        <g:if test="${ftTradeFeeInstance?.step2To!=0 && ftTradeFeeInstance?.step2To!=null}">
                            <tr>
                                <td>
                                    <g:textField name="step2From" style="width:60px;" readonly="true" value="${step2From}" onblur="checkMoney1(this.value,2)"></g:textField>~ <g:textField name="step2To" id="step2To" maxlength="12" style="width:60px;" onblur="value=value.replace(/[ ]/g,'');checkMoney(this.value,2);checkMoney1(this.value,2)" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${step2To}"/> 元
                                </td>
                                <td>
                                    <g:select name="step2FeeType" value="${ftTradeFeeInstance.step2FeeType}" from="${FtTradeFee.feeTypeMap}" optionKey="key" optionValue="value" class="right_top_h2_input" onchange="changeStepFeeType('2',this.value)"/>
                                </td>
                                <td id="21">
                                    <g:textField name="step2FeeValue" maxlength="12" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${step2FeeValue}"/>%
                                </td>

                                <td id="22">
                                    最低 <g:textField name="step2FeeMin" maxlength="7" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.step2FeeMin}"/>元/笔
                                </td>
                                <td id="23" colspan="2">
                                    最高 <g:textField name="step2FeeMax" maxlength="7" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.step2FeeMax}"/>元/笔
                                </td>
                                <td id="24" colspan="4" style="display:none">
                                    <g:textField name="step2FeeValue1" maxlength="12" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${step2FeeValue}"/>元
                                </td>

                                <td id="bt2" style="display:none">
                                    <input type='button' name='button2' id='button2' value='删除' style='width:60px;' onclick='TableDel()'/>
                                </td>
                                <td>
                                    <g:hiddenField name="num" value="2"></g:hiddenField>
                                </td>
                            </tr>
                        </g:if>
                        <g:if test="${ftTradeFeeInstance?.step3To!=0 && ftTradeFeeInstance?.step3To!=null}">
                            <tr>
                                <td>
                                    <g:textField name="step3From" style="width:60px;" readonly="true" value="${step3From} " onblur="checkMoney1(this.value,3)"></g:textField>~ <g:textField name="step3To" id="step3To" maxlength="12" style="width:60px;" onblur="value=value.replace(/[ ]/g,'');checkMoney(this.value,3);checkMoney1(this.value,3)" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${step3To}"/> 元
                                </td>
                                <td>
                                    <g:select name="step3FeeType" value="${ftTradeFeeInstance.step3FeeType}" from="${FtTradeFee.feeTypeMap}" optionKey="key" optionValue="value" class="right_top_h2_input" onchange="changeStepFeeType('3',this.value)"/>
                                </td>
                                <td id="31">
                                    <g:textField name="step3FeeValue" maxlength="12" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${step3FeeValue}"/>%
                                </td>

                                <td id="32">
                                    最低 <g:textField name="step3FeeMin" maxlength="7" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.step3FeeMin}"/>元/笔
                                </td>
                                <td id="33" colspan="2">
                                    最高 <g:textField name="step3FeeMax" maxlength="7" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.step3FeeMax}"/>元/笔
                                </td>
                                <td id="34" colspan="4" style="display:none">
                                    <g:textField name="step3FeeValue1" maxlength="12" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${step3FeeValue}"/>元
                                </td>
                                <td id="bt3" style="display:none">
                                    <input type='button' name='button' id='button3' value='删除' style='width:60px;' onclick='TableDel()'/>
                                </td>
                                <td>
                                    <g:hiddenField name="num" value="3"></g:hiddenField>
                                </td>
                            </tr>
                        </g:if>
                        <g:if test="${ftTradeFeeInstance?.step4To!=0 && ftTradeFeeInstance?.step4To!=null}">
                            <tr>
                                <td>
                                    <g:textField name="step4From" style="width:60px;" readonly="true" value="${step4From}" onblur="checkMoney1(this.value,4)"></g:textField>~ <g:textField name="step4To" id="step4To" maxlength="12" style="width:60px;" onblur="value=value.replace(/[ ]/g,'');checkMoney(this.value,4);checkMoney1(this.value,4)" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${step4To}"/> 元
                                </td>
                                <td>
                                    <g:select name="step4FeeType" value="${ftTradeFeeInstance.step4FeeType}" from="${FtTradeFee.feeTypeMap}" optionKey="key" optionValue="value" class="right_top_h2_input" onchange="changeStepFeeType('4',this.value)"/>
                                </td>
                                <td id="41">
                                    <g:textField name="step4FeeValue" maxlength="12" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${step4FeeValue}"/>%
                                </td>

                                <td id="42">
                                    最低 <g:textField name="step4FeeMin" maxlength="7" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.step4FeeMin}"/>元/笔
                                </td>
                                <td id="43" colspan="2">
                                    最高 <g:textField name="step4FeeMax" maxlength="7" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.step4FeeMax}"/>元/笔
                                </td>
                                <td id="44" colspan="4" style="display:none">
                                    <g:textField name="step4FeeValue1" maxlength="12" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${step4FeeValue}"/>元
                                </td>
                                <td>
                                    <input type='button' name='button' id='button4' value='删除' style='width:60px;' onclick='TableDel()'/>
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
                                大于<g:textField name="step5To" style="width:60px;" readonly="true" value="${step5To}"></g:textField>元
                            </td>
                            <td>
                                <g:select name="step5FeeType" value="${ftTradeFeeInstance.step5FeeType}" from="${FtTradeFee.feeTypeMap}" optionKey="key" optionValue="value" class="right_top_h2_input" onchange="changeStepFeeType('5',this.value)"/>
                            </td>
                            <td id="51">
                                <g:textField name="step5FeeValue" maxlength="12" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${step5FeeValue}"/>%
                            </td>
                            <td id="52">
                                最低 <g:textField name="step5FeeMin" maxlength="7" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.step5FeeMin}"/>元/笔
                            </td>
                            <td id="53" colspan="2">
                                最高 <g:textField name="step5FeeMax" maxlength="7" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${ftTradeFeeInstance?.step5FeeMax}"/>元/笔
                            </td>
                            <td id="54" colspan="4" style="display:none">
                                <g:textField name="step5FeeValue1" maxlength="12" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${step5FeeValue}"/>元
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    %{--<span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定"></span>--}%
                    <span class="content"><g:actionSubmit value="确定" action="update" class="rigt_button" onclick="return checkFiled()"></g:actionSubmit>
                </td>
            </tr>
        </table>

    </g:form>
</div>
</body>
</html>
