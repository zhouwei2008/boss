<%@ page import="boss.BoAgentPayServiceParams" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:if test="${boAgentPayServiceParamsInstance.serviceCode == 'agentcoll'}">
        <g:set var="entityName" value="${message(code: 'boAgentPayServiceParams.coll.label', default: 'boAgentPayServiceParams')}"/>
    </g:if>
    <g:elseif test="${boAgentPayServiceParamsInstance.serviceCode=='agentpay'}">
        <g:set var="entityName" value="${message(code: 'boAgentPayServiceParams.pay.label', default: 'boAgentPayServiceParams')}"/>
    </g:elseif>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
    <script type="text/javascript">

        /**
         * 校验所有输入域是否含有特殊符号
         * 所要过滤的符号写入正则表达式中，注意，一些符号要用'\'转义.
         * 要转义的字符包括：  1,  点号 .
         *                   2,  中括号 []
         *                   3,  大括号 {}
         *                   4,  加号   +
         *                   5,  星号   *
         *                   6,  减号   -
         *                   7,  斜杠   \
         *                   8,  竖线   |
         *                   9,  尖号   ^
         *                   10, 钱币   $
         *                   11, 问号   ？
         * 试例：
         * if(checkAllTextValid(document.forms[0]))
         *         alert("表单中所有文本框通过校验！");
         */
        function checkAllTextValid(form) {
            //记录不含引号的文本框数量
            var resultTag = 0;
            //记录所有text文本框数量
            var flag = 0;
            alert(form.elements.length);
            for (var i = 0; i < form.elements.length; i ++) {
                if (form.elements[i].type == "text") {
                    flag = flag + 1;
                    //此处填写所要过滤的特殊符号
                    //注意：修改####处的字符，其它部分不许修改.
                    //if(/^[^####]*$/.test(form.elements[i].value))
                    //  alert(/^[^\|"'<>]*$/.test(document.getElementById('remark').value));
                    if (/^[^\|"'<>]*$/.test(form.elements[i].value)) resultTag = resultTag + 1;
                    else form.elements[i].select();
                }
            }

            //如果含引号的文本框等于全部文本框的值，则校验通过
            if (resultTag == flag) return true;
            else {
                alert("文本框中不能含有\n\n 1 单引号: ' \n 2 双引号: \" \n 3 竖  杠: | \n 4 尖角号: < > \n\n请检查输入！");
                return false;
            }
        }

        function checkTextValueIsAllowed(obj, lableName) {
            if (!/^[^\|"'<>]*$/.test(obj.value)) {
                alert(lableName + "不能含有\n\n 1 单引号: ' \n 2 双引号: \" \n 3 竖  杠: | \n 4 尖角号: < > \n\n请检查输入！");
                obj.focus();
                return false;
            }
            return true;
        }

        function disWtdq() {
            if ("${cmCustomerBankAccountInstanceList.size()}" == 0) {
                alert("请设置有效的银行账户");
                document.getElementById("dq").checked = false;
                document.getElementById("wtdq").style.display = "none";

            }
            if (document.getElementById("dq").checked) {
                document.getElementById("wtdq").style.display = "block";
            } else {
                document.getElementById("wtdq").style.display = "none";
            }

        }
        function disEmail() {
            if (document.getElementById("mailMessage").checked) {
                document.getElementById("showEmail").style.display = "block";
            } else {
                document.getElementById("entrustEmail").value = '';
                document.getElementById("showEmail").style.display = "none";
            }
        }
        function disNeedCheckAgain(selectValue) {
            if ('0' == selectValue) {
                document.getElementById("windowTimeSpan").style.display = "block";
            } else {
                document.getElementById("windowTimeSpan").style.display = "none";
            }

        }
        function trim(s) {
            return s.replace(/(^\s*)|(\s*$)/g, "");
        }
        function isNum(obj) {
            if (isNaN(obj.value.replace(/,/g, ""))) {
                alert("您只能输入数字");
                obj.focus();
                return false;
            }

            return true;
        }
        function isEmail(obj) {
            var patrn = /^\s*\w+(?:\.{0,1}[\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\.[a-zA-Z]+\s*$/;
            if (!patrn.exec(obj.value)) {
                //如果email字符串不符合正则要做的操作
                alert("请输入正确的Email地址");
                obj.focus();
                return false;
            }
            return true;
        }
        /**
         * 格式化金额
         */
        function fmoney(s, n) {
            var flag = 0;
            var svalue;
            if (isNaN(s.value.replace(/,/g, ""))) {
                alert("您只能输入数字");
                s.focus();
                return false;
            }
            if (s.value == "0" || s.value == "0.00") {
                flag = 1;
            }
            n = n > 0 && n <= 20 ? n : 2;
            svalue = parseFloat((s.value + "").replace(/[^\d\.-]/g, "")).toFixed(n) + "";
            var l = svalue.split(".")[0].split("").reverse();
            r = svalue.split(".")[1];
            t = "";
            for (i = 0; i < l.length; i++) {
                t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? "," : "");
            }
            s.value = t.split("").reverse().join("") + "." + r;
            if (s.value == "NaN.undefined") {
                s.value = "";
            } else if (s.value == "0.00" && flag == 0) {
                alert("该字段值保留2位小数");
                s.value = "";
            }
        }

        /**
         * 还原金额
         */
        function rmoney(s) {
            return parseFloat(s.replace(/[^\d\.-]/g, ""));
        }

        function check(s, lableName) {

            var digitnum = /^\d{1,9}\.\d{1,2}$/;
            var regnum_ = /^\d{1,9}$/;
            var daytrans = /^\d{1,6}$/;
            var monthtrans = /^\d{1,10}$/;
            var intValue = rmoney(trim(s));

            if (trim(s) != "") {
                if (!isNaN(rmoney(trim(s)))) {
                    if (rmoney(trim(s)).toString().indexOf(".") > 0) {
                        if (!digitnum.test(rmoney(trim(s))) || trim(s).toString().replace(/,/g, "").length > 12) {
                            //alert(rmoney(trim(s)));
                            alert(lableName + " 只能输入数字,整数最多输入9位,2位小数位");
                            document.getElementById(s).focus();
                            return false;
                        } else if (parseFloat(rmoney(trim(s))) < 0) {
                            alert(lableName + " 必须大于零");
                            document.getElementById(s).focus();
                            return false;
                        } else if (trim(s).toString().replace(/,/g, "").length > 12) {
                            alert(lableName + " 最多输入9位");
                            document.getElementById(s).focus();
                            return false;
                        }
                    } else {
                        if (!regnum_.test(rmoney(trim(s))) || rmoney(trim(s)).toString().replace(/,/g, "").length > 9) {
                            alert(lableName + " 只能输入数字且最多输入9位");
                            document.getElementById(s).focus();
                            return false;
                        } else if (parseInt(rmoney(trim(s))) < 0) {
                            alert(lableName + " 必须大于零");
                            document.getElementById(s).focus();
                            return false;
                        } else if (rmoney(trim(s)).toString().replace(/,/g, "").length > 9) {
                            alert(lableName + " 最多输入9位");
                            document.getElementById(s).focus();
                            return false;
                        }
                    }
                } else {
                    alert(lableName + " 输入错误");
                    document.getElementById(s).focus();
                    return false;
                }

            } else if (trim(s) == "") {
                //alert(s)
                alert(lableName + "不能为空");
                document.getElementById(s).focus();
                return false;
            }
        }
        //校验钱数 对象，提示标签名，整数长度，小数长度
        function checkForAllNumber(obj, lableName, iLength, fLength) {
            var objValue = obj.value.replace(/[^\d\.-]/g, "");
            var isValidate = true;
            //校验日限额
            if (trim(objValue) != "") {

                if (isNum(obj)) {

                    if (parseFloat(trim(objValue)) < 0) {
                        alert(lableName + "必须大于0");
                        obj.focus();
                        isValidate = false;
                    } else {
                        var objValueLength = objValue.split(".").length;
                        if (objValueLength > 1) {
                            if (trim(objValue).split(".")[1].length > fLength) {
                                alert(lableName + "最多输入" + fLength + "位小数");
                                obj.focus();
                                isValidate = false;
                            }
                            if (trim(objValue).split(".")[0].length > iLength) {
                                alert(lableName + "最多输入" + iLength + "位整数" + (fLength ? "，" + fLength + "位小数" : ""));
                                obj.focus();
                                isValidate = false;
                            }
                        } else {
                            if (trim(objValue).length > iLength) {
                                alert(lableName + "最多输入" + iLength + "位整数");
                                obj.focus();
                                isValidate = false;
                            }
                        }
                    }
                }
            } else if (trim(objValue) == "") {
                alert(lableName + "不能为空");
                isValidate = false;
            }
            return isValidate;
        }

        function doSave() {

            var daytrans = /^\d{1,6}$/;
            var monthtrans = /^\d{1,10}$/;
            //校验:在商户后台审核选择为不需要时，窗口期不能为空

            var batchPubFee = "";
            var batchPriFee = "";
            var singlePubFee = "";
            var singlePriFee = "";
            var interfacePubFee = "";
            var interfacePriFee = "";
            if ("${boAgentPayServiceParamsInstance.serviceCode}" == "agentpay") {
                batchPubFee = document.getElementById("batchPubFee").value;
                batchPriFee = document.getElementById("batchPriFee").value;
                singlePubFee = document.getElementById("singlePubFee").value;
                singlePriFee = document.getElementById("singlePriFee").value;
                interfacePubFee = document.getElementById("interfacePubFee").value;
                interfacePriFee = document.getElementById("interfacePriFee").value;
            }
            var pubLimitMoney = document.getElementById("pubLimitMoney").value;
            var priLimitMoney = document.getElementById("priLimitMoney").value;
            var dayLimitTrans = document.getElementById("dayLimitTrans").value;
            var dayLimitMoney = document.getElementById("dayLimitMoney").value;
            var monthLimitTrans = document.getElementById("monthLimitTrans").value;
            var monthLimitMoney = document.getElementById("monthLimitMoney").value;
            var remark = document.getElementById("remark").value;
            var windowTime = document.getElementById("windowTime").value;
            if (trim(remark) != "" && trim(remark).replace(/[^\x00-\xFF]/g, '**').length > 50) {
                alert("备注最多输入50个字符");
                document.getElementById("remark").focus();
                return false;
            }

            if ("${boAgentPayServiceParamsInstance.serviceCode}" == "agentpay") {
                var batchChannelTemp = document.getElementById('batchChannel');
                var singleChannelTemp = document.getElementById('singleChannel');
                var interfaceChannelTemp = document.getElementById('interfaceChannel');

                if (batchChannelTemp.checked) {
                    if (trim(batchPubFee) == "" || trim(batchPriFee) == "") {
                        alert("批量对公或批量对私不能为空!");
                        return false;
                    }
                    else {
                        ///check(batchPubFee, "批量对公"); //按笔收费 对公每笔
                        //check(batchPriFee, "批量对私");
                        if (!checkForAllNumber(document.getElementById('batchPubFee'), '批量对公', 5, 2)) return false;
                        if (!checkForAllNumber(document.getElementById('batchPriFee'), '批量对私', 5, 2)) return false;
                    }
                }

                if (singleChannelTemp.checked) {
                    if (trim(singlePubFee) == "" || trim(singlePriFee) == "") {
                        alert("单笔对公或单笔对私不能为空!");
                        return false;
                    } else {
                        //check(singlePubFee, "单笔对公");
                        if (!checkForAllNumber(document.getElementById('singlePubFee'), '单笔对公', 5, 2)) return false;
                        // check(singlePriFee, "单笔对私");
                        if (!checkForAllNumber(document.getElementById('singlePriFee'), '单笔对私', 5, 2)) return false;
                    }

                }
                if (interfaceChannelTemp.checked) {
                    if (trim(interfacePubFee) == "" || trim(interfacePriFee) == "") {
                        alert("接口对公或接口对私不能为空!");
                        return false;
                    } else {
                        //check(interfacePubFee, "接口对公");
                        //check(interfacePriFee, "接口对私");
                        if (!checkForAllNumber(document.getElementById('interfacePubFee'), '接口对公', 5, 2)) return false;
                        if (!checkForAllNumber(document.getElementById('interfacePriFee'), '接口对私', 5, 2)) return false;
                    }
                }


            }
            //check(pubLimitMoney, '单笔限额 对公');
            //check(priLimitMoney, "单笔限额 对私");
            //check(dayLimitMoney, '日限额（金额）');
            if (!checkForAllNumber(document.getElementById('pubLimitMoney'), '单笔限额 对公', 9, 2)) return false;
            if (!checkForAllNumber(document.getElementById('priLimitMoney'), '单笔限额 对私', 9, 2)) return false;
            if (!checkForAllNumber(document.getElementById('monthLimitMoney'), '月限额（金额）', 10, 2)) return false;
            if (!checkForAllNumber(document.getElementById('dayLimitMoney'), '日限额（金额）', 10, 2)) return false;
            if (!checkForAllNumber(document.getElementById('dayLimitTrans'), '日交易限额（笔数）', 10)) return false;
            if (!checkForAllNumber(document.getElementById('monthLimitTrans'), '月交易限额（笔数）', 10)) return false;


            /*            if (trim(monthLimitTrans) != "") {
             if (!isNaN(rmoney(trim(monthLimitTrans)))) {
             if (rmoney(trim(monthLimitTrans)).toString().indexOf(".") > 0) {
             alert("月交易限额（笔数）输入错误");
             document.getElementById("monthLimitTrans").focus();
             return false;
             } else {
             if (!monthtrans.test(rmoney(trim(monthLimitTrans))) || trim(monthLimitTrans).toString().replace(/,/g, "").length > 10) {
             alert("月交易限额（笔数）只能输入整数最多输入10位");
             document.getElementById("monthLimitTrans").focus();
             return false;
             } else if (parseInt(rmoney(trim(monthLimitTrans))) <= 0) {
             alert("月交易限额（笔数）必须大于零");
             document.getElementById("monthLimitTrans").focus();
             return false;
             } else if (rmoney(trim(monthLimitTrans)).toString().replace(/,/g, "").length > 10) {
             alert("月交易限额（笔数）最多输入10位");
             document.getElementById("monthLimitTrans").focus();
             return false;
             }
             }
             } else {
             alert("月交易限额（笔数）输入错误");
             document.getElementById("monthLimitTrans").focus();
             return false;
             }
             } else if (trim(monthLimitTrans) == "") {
             alert("月交易限额（笔数）不能为空");
             return false;
             }*/
            if (parseInt(rmoney(trim(dayLimitTrans))) > parseInt(rmoney(trim(monthLimitTrans)))) {
                alert("日交易限额（笔数）不能大于月交易限额（笔数）");
                return false;
            }
            if (parseInt(rmoney(trim(dayLimitMoney))) > parseInt(rmoney(trim(monthLimitMoney)))) {
                alert("日交易限额（金额）不能大于月交易限额（金额）");
                return false;
            }
            if ("${boAgentPayServiceParamsInstance.serviceCode}" == "agentpay") {
                var batchChannelTemp = document.getElementById("batchChannel");
                var singleChannelTemp = document.getElementById('singleChannel');
                var interfaceChannelTemp = document.getElementById('interfaceChannel');
                if (batchChannelTemp.checked) {
                    document.getElementById("batchPubFee").value = rmoney(batchPubFee);
                    document.getElementById("batchPriFee").value = rmoney(batchPriFee);
                }
                if (singleChannelTemp.checked) {
                    document.getElementById("singlePubFee").value = rmoney(singlePubFee);
                    document.getElementById("singlePriFee").value = rmoney(singlePriFee);
                }
                if (interfaceChannelTemp.checked) {
                    document.getElementById("interfacePubFee").value = rmoney(interfacePubFee);
                    document.getElementById("interfacePriFee").value = rmoney(interfacePriFee);
                }


            }
            document.getElementById("pubLimitMoney").value = rmoney(pubLimitMoney);
            document.getElementById("priLimitMoney").value = rmoney(priLimitMoney);
            document.getElementById("dayLimitTrans").value = rmoney(dayLimitTrans);
            document.getElementById("dayLimitMoney").value = rmoney(dayLimitMoney);
            document.getElementById("monthLimitTrans").value = rmoney(monthLimitTrans);
            document.getElementById("monthLimitMoney").value = rmoney(monthLimitMoney);
            if (document.getElementById("dq") && document.getElementById("dq").checked) {
                document.getElementById("isDq").value = "1";
                /*if (!document.getElementById('userCompactno').value) {
                 alert('请填写用户协议号');
                 document.getElementById("userCompactno").focus();
                 return false;
                 }*/
                if (!document.getElementById('dqId').value) {

                    alert('请选择收款账号');
                    document.getElementById("dqId").focus();
                    return false;
                }
                document.getElementById("dqAccountId").value = document.getElementById("dqId").value;
            } else {
                document.getElementById("isDq").value = "";
            }
            if (document.getElementById("mailMessage")) {
                if (document.getElementById("mailMessage").checked) {
                    document.getElementById("isMailMessage").value = "1";

                } else {
                    document.getElementById("isMailMessage").value = "";
                }

            }


            //校验:在商户后台审核选择为不需要时，窗口期不能为空
            if (document.getElementById('ismpCheck').value == '0') {
                /*if (trim(windowTime) != "") {

                 if (isNum(document.getElementById('windowTime'))) {
                 if (parseInt(trim(windowTime)) < 0) {
                 alert("窗口期（时）必须大于0");
                 document.getElementById("windowTime").focus();
                 return false;
                 }
                 var timeLength = windowTime.split(".").length;
                 if (timeLength > 1) {
                 if (trim(windowTime.split(".")[1]).length > 2) {
                 alert("窗口期（时）最多输入2位小数");
                 document.getElementById("windowTime").focus();
                 return false;
                 }
                 }

                 if (trim(windowTime.split(".")[0]).length > 3) {
                 alert("窗口期（时）最多输入3位整数，2位小数");
                 document.getElementById("windowTime").focus();
                 return false;
                 }
                 }
                 } else if (trim(windowTime) == "") {
                 alert("窗口期（时）不能为空");
                 return false;
                 }*/
                if (!checkForAllNumber(document.getElementById('windowTime'), '窗口期（时）', 3, 2)) return false;
                if (!(parseFloat(trim(document.getElementById('windowTime').value)) > 0)) {
                        alert("窗口期（时）" + "必须大于0");
                        document.getElementById('windowTime').focus();
                         return false;
                    }
            }

            if (document.getElementById('mailMessage')) {
                var entrustEmail = document.getElementById('entrustEmail').value;
                //校验:在商户后台审核选择为不需要时，窗口期不能为空
                if (document.getElementById('mailMessage').checked) {
                    if (trim(entrustEmail) != "") {
                        if (isEmail(document.getElementById('entrustEmail'))) {
                            if (trim(entrustEmail).length > 50) {
                                alert("通知Email最多输入50位");
                                document.getElementById("entrustEmail").focus();
                                return false;
                            }
                        } else {
                            // isEmail(document.getElementById('entrustEmail'));
                            return false;
                        }
                    } else if (trim(entrustEmail) == "") {
                        alert("通知Email不能为空");
                        return false;
                    }

                }
            }

            //校验特殊字符
            if (!checkTextValueIsAllowed(document.getElementById('remark'), "备注")) {
                return false;
            }
            //校验用户协议号特殊字符
            if (document.getElementById('userCompactno')) {
                if (document.getElementById('userCompactno').value) {
                    if (!checkTextValueIsAllowed(document.getElementById('userCompactno'), "用户协议号")) {
                        return false;
                    }
                    if (trim(document.getElementById('userCompactno').value).length > 15) {
                        alert("用户协议号最多输入15位");
                        document.getElementById("userCompactno").focus();
                        return false;
                    }
                }
            }


            document.forms[0].submit();
        }

    </script>
</head>
<body style="overflow-x:hidden" onload="checkDFHasChecked();">
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${boAgentPayServiceParamsInstance}">
        <div class="errors">
            <g:renderErrors bean="${boAgentPayServiceParamsInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="update">
        <g:hiddenField name="id" value="${boAgentPayServiceParamsInstance.id}"/>
        <g:hiddenField name="isDq" id="isDq" value="${boAgentPayServiceParamsInstance?.isDq}"/>
        <g:hiddenField name="isMailMessage" value="${boAgentPayServiceParamsInstance?.isMailMessage}"/>
        <g:hiddenField name="dqAccountId" id="dqAccountId" value="${boAgentPayServiceParamsInstance?.dqAccountId}"/>
    %{--<g:hiddenField name="customerServiceId" value="${boAgentPayServiceParamsInstance?.customerServiceId}"/>--}%
        <g:hiddenField name="gatherWay" value="${boAgentPayServiceParamsInstance?.gatherWay}"/>
    %{--<g:hiddenField name="settWay" value="${boAgentPayServiceParamsInstance?.settWay}"/>--}%
        <table align="center" class="rigt_tebl">
            <tr>
                <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
            </tr>
            <div id="a">
                <g:if test="${serviceCode!='agentcoll'}">
                    <tr id="gatherWayLabel">

                        <td class="right label_name"><g:checkBox id="batchChannel" name="batchChannel" value="${boAgentPayServiceParamsInstance?.batchChannel}" onclick="checkDFHasChecked();"></g:checkBox>批量&nbsp;&nbsp;&nbsp;<g:message code="boAgentPayServiceParams.gatherWay.label"/>：</td>
                        <td>
                            <g:message code="boAgentPayServiceParams.gatherWay.transaction.label"/> <g:textField id="batchPubFee" name="batchPubFee" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'batchPubFee')}" onBlur="fmoney(this,2)"/>
                            <g:message code="boAgentPayServiceParams.gatherWay.perTransaction.label"/> <g:textField id="batchPriFee" name="batchPriFee" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'batchPriFee')}" onBlur="fmoney(this,2)"/> 元
                        </td>
                    </tr>
                    <tr id="gatherWayLabel1">
                        <td class="right label_name"><g:checkBox id="singleChannel" name="singleChannel" value="${boAgentPayServiceParamsInstance?.singleChannel}" onclick="checkDFHasChecked();"></g:checkBox>单笔&nbsp;&nbsp;&nbsp;<g:message code="boAgentPayServiceParams.gatherWay.label"/>：</td>
                        <td>
                            <g:message code="boAgentPayServiceParams.gatherWay.transaction.label"/> <g:textField id="singlePubFee" name="singlePubFee" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'singlePubFee')}" onBlur="fmoney(this,2)"/>
                            <g:message code="boAgentPayServiceParams.gatherWay.perTransaction.label"/> <g:textField id="singlePriFee" name="singlePriFee" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'singlePriFee')}" onBlur="fmoney(this,2)"/> 元
                        </td>
                    </tr>
                    <tr id="gatherWayLabel2">
                        <td class="right label_name"><g:checkBox id="interfaceChannel" name="interfaceChannel" value="${boAgentPayServiceParamsInstance?.interfaceChannel}" onclick="checkDFHasChecked();"></g:checkBox>接口&nbsp;&nbsp;&nbsp;<g:message code="boAgentPayServiceParams.gatherWay.label"/>：</td>
                        <td>
                            <g:message code="boAgentPayServiceParams.gatherWay.transaction.label"/> <g:textField id="interfacePubFee" name="interfacePubFee" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'interfacePubFee')}" onBlur="fmoney(this,2)"/>
                            <g:message code="boAgentPayServiceParams.gatherWay.perTransaction.label"/> <g:textField id="interfacePriFee" name="interfacePriFee" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'interfacePriFee')}" onBlur="fmoney(this,2)"/> 元
                        </td>
                    </tr>
                </g:if>

                <g:if test="${serviceCode=='agentcoll'}">
                    <tr id="gatherWayLabel3">
                        <td class="right label_name" style="border-right:none">
                        </td>
                        <td style="border-left:none">
                            <g:checkBox id="batchChannel" name="batchChannel" value="${boAgentPayServiceParamsInstance?.batchChannel}"></g:checkBox>批量代收&nbsp;&nbsp;&nbsp;
                            <g:checkBox id="singleChannel" name="singleChannel" value="${boAgentPayServiceParamsInstance?.singleChannel}"></g:checkBox>单笔代收&nbsp;&nbsp;&nbsp;
                            <g:checkBox id="interfaceChannel" name="interfaceChannel" value="${boAgentPayServiceParamsInstance?.interfaceChannel}"></g:checkBox>接口代收&nbsp;&nbsp;&nbsp;
                        </td>
                    </tr>

                </g:if>

            </div>


            <tr>
                <td class="right label_name" style="width:30%"><g:message code="boAgentPayServiceParams.transactionMoney.label"/>：</td>
                <td>
                    <g:message code="boAgentPayServiceParams.singleTransactionMoney.label"/>&nbsp;对公：&nbsp;<g:textField name="pubLimitMoney" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'pubLimitMoney')}" onBlur="fmoney(this,2)"/>元&nbsp;&nbsp;
                    对私：&nbsp;<g:textField name="priLimitMoney" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'priLimitMoney')}" onBlur="fmoney(this,2)"/>元
                    <br/><g:message code="boAgentPayServiceParams.daySingleTransaction.label"/> <g:textField id="dayLimitTrans" name="dayLimitTrans" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'dayLimitTrans')}" onBlur="isNum(this)"/>笔
                    <br/><g:message code="boAgentPayServiceParams.daySingleTransactionMoney.label"/> <g:textField id="dayLimitMoney" name="dayLimitMoney" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'dayLimitMoney')}" onBlur="fmoney(this,2)"/>元
                    <br/><g:message code="boAgentPayServiceParams.monthSingleTransaction.label"/> <g:textField id="monthLimitTrans" name="monthLimitTrans" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'monthLimitTrans')}" onBlur="isNum(this)"/> 笔
                    <br/><g:message code="boAgentPayServiceParams.monthSingleTransactionMoney.label"/> <g:textField id="monthLimitMoney" name="monthLimitMoney" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'monthLimitMoney')}" onBlur="fmoney(this,2)"/>元
                </td>
            </tr>
            <tr id="isBackDSLabel">
                 <td style="border-right:none"></td>
                <td  align="left" style="border-left:none">
                    <span id="isBackFeeLabel">
                        %{--<g:message code="手续费"/>：--}%
                        %{--<select id="backFee" name="backFee">--}%
                            %{--<g:if test="${boAgentPayServiceParamsInstance?.backFee!='1'}">--}%
                                %{--<option value="0" selected="selected">不退</option>--}%
                                %{--<option value="1">退</option>--}%
                            %{--</g:if>--}%
                            %{--<g:if test="${boAgentPayServiceParamsInstance?.backFee=='1'}">--}%
                                %{--<option value="0">不退</option>--}%
                                %{--<option value="1" selected="selected">退</option>--}%
                            %{--</g:if>--}%

                        %{--</select>--}%
                        <g:message code="boAgentPayServiceParams.settWay.label"/>：
                        <select id="settWay" name="settWay">
                            <g:if test="${boAgentPayServiceParamsInstance?.settWay!='1'}">
                                <option value="0" selected="selected">即扣</option>
                                <option value="1">后返</option>
                            </g:if>
                            <g:if test="${boAgentPayServiceParamsInstance?.settWay=='1'}">
                                <option value="0">即扣</option>
                                <option value="1" selected="selected">后返</option>
                            </g:if>
                        </select>
                    </span>
                    <g:message code="短信通知"/>：

                    <select name="messageNotify">
                        <g:if test="${boAgentPayServiceParamsInstance?.messageNotify!='1'}">
                            <option value="0" selected="selected">关闭</option>
                            <option value="1">开启</option>
                        </g:if>
                        <g:if test="${boAgentPayServiceParamsInstance?.messageNotify=='1'}">
                            <option value="1" selected="selected">开启</option>
                            <option value="0">关闭</option>
                        </g:if>
                    </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="模板类型"/>：</td>
                <td>
                    <g:if test="${boAgentPayServiceParamsInstance?.templateType!='1'}">
                        <g:radio value="0" name="templateType" checked="true"/>标准模板
     %{--&nbsp;&nbsp;<g:radio value="1" name="templateType"/>华安模板--}%
                    </g:if>
                    <g:if test="${boAgentPayServiceParamsInstance?.templateType=='1'}">
                        <g:radio value="0" name="templateType"/>标准模板
     %{--&nbsp;&nbsp;<g:radio value="1" name="templateType" checked="true"/>华安模板--}%
                    </g:if>

                </td>
            </tr>
            <g:if test="${serviceCode=='agentpay'}">
                <tr>
                    <td class="right label_name"><g:message code="是否委托代扣"/>：</td>

                    <td><input type="checkbox" id="dq" name="dq" value="${boAgentPayServiceParamsInstance?.isDq}" onclick="disWtdq();"/></td>
                </tr>
                <tr id="wtdq">
                    <td class="right label_name" valign="top">
                        代扣相关信息：
                    </td>
                    <td>
                         请选择如下收款账号：<br>
                        <g:each in="${cmCustomerBankAccountInstanceList}" status="i" var="cmCustomerBankAccountInstanceList">
                            <g:radio value="${cmCustomerBankAccountInstanceList.id}" id="dqId" name="dqId"/>${cmCustomerBankAccountInstanceList.bankAccountName + '-' + cmCustomerBankAccountInstanceList.bankAccountNo}<br>
                        </g:each>
                        用户协议号：<g:textField id="userCompactno" name="userCompactno" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'userCompactno')}"/><br>
                        是否邮件通知：<input type="checkbox" id="mailMessage" name="mailMessage" value="${boAgentPayServiceParamsInstance?.isMailMessage}" onclick="disEmail();"/>
                        <span id='showEmail'><g:message code="邮件地址"/>：<input type="text" id="entrustEmail" name="entrustEmail" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'entrustEmail')}"/></span>
                    </td>
                </tr>
            </g:if>

            <tr>
                <td class="right label_name"><g:message code="商户后台审核"/>：</td>
                <td>
                    <select id="ismpCheck" name="ismpCheck" onchange="disNeedCheckAgain(this.value)">
                        <g:if test="${boAgentPayServiceParamsInstance?.ismpCheck!='0'}">
                            <option value="1" selected="selected">需要</option>
                            <option value="0">不需要</option>
                        </g:if>
                        <g:if test="${boAgentPayServiceParamsInstance?.ismpCheck=='0'}">
                            <option value="0" selected="selected">不需要</option>
                            <option value="1">需要</option>
                        </g:if>
                    </select>
                    <span id="windowTimeSpan">
                        <g:message code="窗口期"/>：

                        <input type="text" id="windowTime" name="windowTime" value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'windowTime')}" onBlur="isNum(this)"/>时
                    </span>

                </td>

            </tr>
            <tr>
                <td class="right label_name"><g:message code="BOSS后台审核"/>：</td>
                <td>
                    <select id="bossCheck" name="bossCheck">
                        <g:if test="${boAgentPayServiceParamsInstance?.bossCheck!='0'}">
                            <option value="1" selected="selected">需要</option>
                            <option value="0">不需要</option>
                        </g:if>
                        <g:if test="${boAgentPayServiceParamsInstance?.bossCheck=='0'}">
                            <option value="0" selected="selected">不需要</option>
                            <option value="1">需要</option>
                        </g:if>
                </td>
            </tr>



            <tr>
                <td class="right label_name"><g:message code="boAgentPayServiceParams.remark.label"/>：</td>
                <td><g:textArea id="remark" name="remark" value="${boAgentPayServiceParamsInstance?.remark}" rows="5" cols="100"></g:textArea></td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                    <span class="content"><input type="button" name="button" id="button" onclick="doSave();" class="rigt_button" value="确定"></span>
                </td>
            </tr>
        </table>
    </g:form>
</div>
<script type="text/javascript">
    document.getElementById("dayLimitTrans").value = document.getElementById("dayLimitTrans").value.replace(/,/g, "");
    document.getElementById("monthLimitTrans").value = document.getElementById("monthLimitTrans").value.replace(/,/g, "");

    if (document.getElementById("windowTime").value != '') {
        var windowTimeValue = parseInt(document.getElementById("windowTime").value.replace(/,/g, "")) / 3600;
        //根据实际情况进行小数点的取舍
        var pointLength = windowTimeValue.toString().length - windowTimeValue.toString().indexOf(".") - 1;

        document.getElementById("windowTime").value = windowTimeValue.toString().indexOf(".") == -1 ? windowTimeValue : windowTimeValue.toFixed(2);
    }
    var fl = 'agentcoll';
    if (document.getElementById("dq") != null) {
        var radios = document.getElementsByName("dqId");
        var dqid = '${boAgentPayServiceParamsInstance?.dqAccountId}';
        for (var i = 0; i < radios.length; i++) {
            if (radios[i].value == dqid) {
                radios[i].checked = true
            }
        }
        if (document.getElementById("dq").value == '1') {
            document.getElementById("wtdq").style.display = "block";
            document.getElementById("dq").checked = true
        } else {
            document.getElementById("wtdq").style.display = "none";
        }
        if (document.getElementById("isMailMessage").value == '1') {
            document.getElementById("mailMessage").checked = true
            document.getElementById("showEmail").style.display = "block";
        } else {
            document.getElementById("showEmail").style.display = "none";
        }
    }

    if ("${serviceCode}" == fl) {


        // document.getElementById("gatherWayLabel").style.display="none";
        // document.getElementById("gatherWayLabel1").style.display="none";
        //document.getElementById("gatherWayLabel2").style.display="none";


        document.getElementById("isBackFeeLabel").style.display = "none";

    } else {
        checkDFHasChecked();
        document.getElementById("batchPubFee").value = document.getElementById("batchPubFee").value.replace(/,/g, "");
        document.getElementById("batchPriFee").value = document.getElementById("batchPriFee").value.replace(/,/g, "");
        document.getElementById("singlePubFee").value = document.getElementById("singlePubFee").value.replace(/,/g, "");
        document.getElementById("singlePriFee").value = document.getElementById("singlePriFee").value.replace(/,/g, "");
        document.getElementById("interfacePubFee").value = document.getElementById("interfacePubFee").value.replace(/,/g, "");
        document.getElementById("interfacePriFee").value = document.getElementById("interfacePriFee").value.replace(/,/g, "");

    }
    if ("${boAgentPayServiceParamsInstance.ismpCheck}" != 0 || "${boAgentPayServiceParamsInstance.ismpCheck}" == '') {
        document.getElementById("windowTimeSpan").style.display = "none";
    }
    function checkDFHasChecked() {
        //批量代付勾选校验
        if (document.getElementById('batchChannel').checked == false) {

            document.getElementById('batchPubFee').value = "";
            document.getElementById('batchPubFee').disabled = true;
            document.getElementById('batchPriFee').value = "";
            document.getElementById('batchPriFee').disabled = true;
        } else {
            document.getElementById('batchPubFee').disabled = false;
            document.getElementById('batchPriFee').disabled = false;
        }
        //单笔代付勾选校验
        if (document.getElementById('singleChannel').checked == false) {

            document.getElementById('singlePubFee').value = "";
            document.getElementById('singlePubFee').disabled = true;
            document.getElementById('singlePriFee').value = "";
            document.getElementById('singlePriFee').disabled = true;
        } else {
            document.getElementById('singlePubFee').disabled = false;
            document.getElementById('singlePriFee').disabled = false;
        }
        //接口代付勾选校验
        if (document.getElementById('interfaceChannel').checked == false) {

            document.getElementById('interfacePubFee').value = "";
            document.getElementById('interfacePubFee').disabled = true;
            document.getElementById('interfacePriFee').value = "";
            document.getElementById('interfacePriFee').disabled = true;
        } else {
            document.getElementById('interfacePubFee').disabled = false;
            document.getElementById('interfacePriFee').disabled = false;
        }

    }

</script>
</body>
</html>
