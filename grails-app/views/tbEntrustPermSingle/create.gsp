<%@ page import="ismp.CmCustomer; dsf.TbEntrustPerm" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbEntrustPerm.label', default: 'TbEntrustPerm')}"/>
    <title><g:message code="default.add.label" args="[entityName]"/></title>
</head>

<body style="overflow-x:hidden">
<script type="text/javascript">
    $(function() {
        $("#entrustStarttime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true});
        $("#entrustEndtime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true,minDate :new Date()});
    });
</script>


<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <g:hasErrors bean="${tbEntrustPermInstance}">
        <div class="errors">
            <g:renderErrors bean="${tbEntrustPermInstance}" as="list"/>
        </div>
    </g:hasErrors>

    <g:form action="save" name="saveForm">
        <table align="center" class="rigt_tebl" >
            <tr>
                <th colspan="2"><g:message code="default.add.label" args="[entityName]"/></th>
            </tr>

            <tr>
                <td class="right label_name" style="width:20%"><g:message code="tbEntrustPerm.cardname.label" /><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: tbEntrustPermInstance, field: 'cardname', 'errors')}"><g:textField name="cardname" maxlength="25" value="${tbEntrustPermInstance?.cardname}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tbEntrustPerm.accountname.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: tbEntrustPermInstance, field: 'accountname', 'errors')}"><g:select name="accountname" from="${bankNameList}" optionKey="${2}" optionValue="${2}" value="${params.tradeAccountname}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tbEntrustPerm.cardnum.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: tbEntrustPermInstance, field: 'cardnum', 'errors')}"><g:textField name="cardnum"  maxlength="33" value="${tbEntrustPermInstance?.cardnum}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tbEntrustPerm.entrustUsercode.label"/>：</td>
                <td class="${hasErrors(bean: tbEntrustPermInstance, field: 'entrustUsercode', 'errors')}"><g:textField name="entrustUsercode" maxlength="15" value="${tbEntrustPermInstance?.entrustUsercode}"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tbEntrustPerm.entrustStarttime.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: tbEntrustPermInstance, field: 'entrustStarttime', 'errors')}"><g:textField id="entrustStarttime" name="entrustStarttime" value="${tbEntrustPermInstance?.entrustStarttime}"  onchange="checkEntrustIsEffect()"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tbEntrustPerm.entrustEndtime.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: tbEntrustPermInstance, field: 'entrustEndtime', 'errors')}"><g:textField id="entrustEndtime" name="entrustEndtime" value="${tbEntrustPermInstance?.entrustEndtime}" onchange="checkEntrustIsEffect()"/></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="tbEntrustPerm.entrustStatus.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: tbEntrustPermInstance, field: 'entrustStatus', 'errors')}"><g:select name="entrustStatus" from="${tbEntrustPermInstance.entrustStatusMap}" value="${tbEntrustPermInstance?.entrustStatus}" optionKey="key" optionValue="value" onchange="checkEntrustIsEffect()"/></td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="tbEntrustPerm.entrustIsEffect.label"/>：</td>
                <td class="${hasErrors(bean: tbEntrustPermInstance, field: 'entrustIsEffect', 'errors')}">
                    &nbsp;<g:radio value="0" name="entrustIsEffectRadio" checked="true" disabled="true"/>是
                    <g:radio value="1" name="entrustIsEffectRadio" disabled="true"/>否
                </td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="tbEntrustPerm.accounttype.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: tbEntrustPermInstance, field: 'accounttype', 'errors')}"><g:select name="accounttype" from="${tbEntrustPermInstance.accounttypeMap}" value="${tbEntrustPermInstance?.accounttype}" optionKey="key" optionValue="value"/></td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="tbEntrustPerm.certificateType.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: tbEntrustPermInstance, field: 'certificateType', 'errors')}"><g:select name="certificateType" from="${tbEntrustPermInstance.certificateTypeMap}" value="${tbEntrustPermInstance?.certificateType}" optionKey="key" optionValue="value"/></td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="tbEntrustPerm.certificateNum.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: tbEntrustPermInstance, field: 'certificateNum', 'errors')}"><g:textField name="certificateNum" maxlength="50" value="${tbEntrustPermInstance?.certificateNum}"/></td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="tbEntrustPerm.customerNoForCreate.label"/><font color="red">*</font>：</td>
                <td class="${hasErrors(bean: tbEntrustPermInstance, field: 'customerNo', 'errors')}"><g:textField name="customerNo" maxlength="50" value="${tbEntrustPermInstance?.customerNo}" onblur="showCustomerName(this)"/></td>
            </tr>
            <tr>
                <td class="right label_name"><g:message code="tbEntrustPerm.customerName.label"/>：</td>
                <td id='customerNameShow' class="${hasErrors(bean: tbEntrustPermInstance, field: 'customerName', 'errors')}"></td>

            </tr>
            <tr>
                <td class="right label_name" style="border-right:none"></td>
                <td style="border-left:none">

                    %{--<span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>--}%
                    <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定" onclick="return validateForm()"></span>
                </td>
            </tr>
        </table>
        <g:hiddenField name="customerName" id="customerName" value=""/>
        <g:hiddenField name="entrustIsEffect" value=""/>
    </g:form>
</div>

<script type="text/javascript">



    //获取用户信息
    function showCustomerName(obj) {
        var customerNo = obj.value;
        if (customerNo) {
            $.getJSON('${createLink(action:'getCustomerInfo')}', {customerNo: customerNo}, function(data) {
                $('#customerNameShow').html("<font color='blue'>&nbsp;" + data.customerName + "</font>");
                document.forms['saveForm'].customerName.value = data.customerName;
            })
        }
    }
    /**
    *校验表单
     */
    function validateForm() {

        var saveFrom = document.forms['saveForm']
        //校验非空 ---start-----
        if (!checkNotEmpty('<g:message code="tbEntrustPerm.cardname.label"/>', saveFrom.cardname)) return false;
        if (!checkNotEmpty('<g:message code="tbEntrustPerm.accountname.label"/>', saveFrom.accountname)) return false;
        if (!checkNotEmpty('<g:message code="tbEntrustPerm.cardnum.label"/>', saveFrom.cardnum)) return false;
        if (!checkNotEmpty('<g:message code="tbEntrustPerm.entrustStarttime.label"/>', saveFrom.entrustStarttime)) return false;
        if (!checkNotEmpty('<g:message code="tbEntrustPerm.entrustEndtime.label"/>', saveFrom.entrustEndtime)) return false;
        if (!checkNotEmpty('<g:message code="tbEntrustPerm.certificateNum.label"/>', saveFrom.certificateNum)) return false;
        if (!checkNotEmpty('<g:message code="tbEntrustPerm.customerNoForCreate.label"/>', saveFrom.customerNo)) return false;
        //校验非空 ---end----
        //校验卡号，身份证号，的长度   --start---

        //if(!checkForAllObjLength('<g:message code="tbEntrustPerm.cardnum.label"/>',saveFrom.cardnum,9,33)) return false;

        //if(!checkForAllObjLength('<g:message code="tbEntrustPerm.certificateNum.label"/>',saveFrom.certificateNum,6,30)) return false;
        //校验卡号，身份证号，的长度   --end---
        //校验卡号的样式


        //校验授权日期和截止日期
        if (saveFrom.entrustStarttime.value >= saveFrom.entrustEndtime.value) {
            alert('<g:message code="tbEntrustPerm.entrustStarttime.label"/>' + '不能大于' + '<g:message code="tbEntrustPerm.entrustEndtime.label"/>' + '，请检查！');
            saveFrom.entrustStarttime.focus();
            return false;
        }
        //校验商户的信息是否在系统中存在
        if (!saveFrom.customerName.value) {
            alert('<g:message code="tbEntrustPerm.customerNoForCreate.label"/>' + '在系统中不存在，请检查！');
            saveFrom.customerNo.focus();
            return false;
        };
        //给后台传送是否生效的值
       // checkEntrustIsEffect();
        //校验银行卡号
       if(!isCardNum(saveFrom.cardnum)) return false;
        if(!iscertificateNum(saveFrom.certificateNum)) return false;
      if(!isDateReg(saveFrom.entrustStarttime)) return false;
        if(!isDateReg(saveFrom.entrustEndtime)) return false;
         if(!isNumOrW(saveFrom.entrustUsercode)) return false;
    }

     //协议号，数字或者字母
 function isNumOrW(s)
    {
    /*var patrn=/^[0-9a-zA-Z]{0,15}$/;
    if (!patrn.exec(s.value)){
        alert('协议号必须为15个字符以内的数字或者字母，请检查！');
        s.focus();
        return false;
    }*/
     var objValue = s.value;
     var dataLenth =  getBytesLength(objValue);
      if(dataLenth>objValue.length){
         alert('协议号有全角字符或汉字，请检查！');
        s.focus();
        return false;
      }
       if(objValue.length>15){
        alert('协议号长度不能大于15，请检查！');
        s.focus();
        return false;
       }
        return true;
    }
     /**
        *获取字节数
    * @param str
      */
    function getBytesLength(str)
     {
     var intLength=0;
     for(var i=0;i<str.length;i++){
     if((str.charCodeAt(i) < 0) || (str.charCodeAt(i) > 255))
     intLength=intLength+2;
     else
     intLength=intLength+1;
     }
     return intLength;
     }

//校验手机号码：必须以数字开头，除数字外，可含有“-”
    function isMobil(s)
    {
    var patrn=/^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/;
    if (!patrn.exec(s)) return false
    return true
    }
//校验银行卡号
    function isCardNum(s)
    {
    var patrn=/^([0-9]|[-]){9,30}$/;
    if (!patrn.exec(s.value)){
        alert("银行卡号必须为9至33个数字和字符'-'，请检查！");
        s.focus();
        return false;
    }
    return true
    }

   //证件号校验30个数字
 function iscertificateNum(s)
    {
   /* var patrn=/^[0-9a-zA-Z]{1,30}$/;

    if (!patrn.exec(s.value)){
        alert('证件号长度不能大于30，请检查！');
        s.focus();
        return false;
    }*/

         var objValue = s.value;
        var dataLenth =  getBytesLength(objValue);

        if(dataLenth>objValue.length){
         alert('证件号有全角字符或汉字，请检查！');
        s.focus();
        return false;
      }
        if(objValue.length>30){
            alert('证件号长度不能大于30，请检查！');
        s.focus();
        return false;
        }
    return true
    }
     //校验日期格式
 function isDateReg(s)
    {
    var patrn=/\d{4}-\d{2}-\d{2}/;
    if (!patrn.exec(s.value)){
        alert('日期格式不对，请检查！');
        s.focus();
        return false;
    }
    return true
    }
    /**
    * 校验内容是否为空，自定义提示信息,(第三个参数可以加入不希望录入的值)
    * @param labelName
    * @param obj
    * @param notEquValue
         */
    function checkNotEmpty(labelName, obj, notEquValue) {
        var checkResult = true;
        var objValue = obj.value;
        if (null == objValue || '' == objValue || notEquValue == objValue) {
            alert(labelName + '不能为空，请检查！');
            obj.focus();
            checkResult = false;
        }
        return checkResult;
    }
    /**
    *校验是否有效
     */
    function checkEntrustIsEffect() {
        var saveFrom = document.forms['saveForm'];
        var entrustStarttime = saveFrom.entrustStarttime.value
        var entrustEndtime = saveFrom.entrustEndtime.value
        var entrustStatus = saveFrom.entrustStatus.value
        var nowDate = new Date();

        //账户状态设置为关闭
        if (entrustStatus == '1'){
              saveFrom.entrustIsEffectRadio[1].checked = true;
            saveFrom.entrustIsEffect.value = 1;
        }
        //账户状态设置为正常，需要判断截止日期
        if (entrustStatus == '0') {
            //判断是否填写截止日期
            if (entrustEndtime) {
                //截止日期包含当天
                var entrustStarttimeForDate = new Date(Date.parse(entrustStarttime.replace(/\-/g, "/")));
                var entrustEndtimeForDate = new Date(Date.parse(entrustEndtime.replace(/\-/g, "/")+" 23:59:59"));
                //时间段是否包含当天，如果不包含则为失效

                if (nowDate< entrustEndtimeForDate&&entrustStarttimeForDate<nowDate) {
                    saveFrom.entrustIsEffectRadio[0].checked = true;
                    saveFrom.entrustIsEffect.value = 0;
                } else {
                    saveFrom.entrustIsEffectRadio[1].checked = true;
                    saveFrom.entrustIsEffect.value = 1;
                }
            } else {
                saveFrom.entrustIsEffectRadio[0].checked = true;
                saveFrom.entrustIsEffect.value = 0;
            }
        }

    }

    //校验长度的对象，提示标签名，最小长度，最大长度
        function checkForAllObjLength( lableName,obj, minLength, maxLength,isRequired) {
            var objValue = trim(obj.value);
            var isValidate = true;
            if (objValue!=''&&objValue!=null){
                var objValueLength = objValue.length;
                if (objValueLength < minLength) {
                    alert(lableName + "至少输入" + minLength + "个字符");
                    obj.focus();
                    isValidate = false;
                }
                if (objValueLength > maxLength) {
                    alert(lableName + "最多输入" +  maxLength + "个字符");
                    obj.focus();
                    isValidate = false;
                }
            } else {
                    if(isRequired){
                        alert(lableName + "不能为空，请检查！");
                        obj.focus();
                        isValidate = false;
                    }

            }


            return isValidate;
        }

   function trim(s) {
            return s.replace(/(^\s*)|(\s*$)/g, "");
        }
    //校验
    /* $(function() {
     $("#saveForm").validate({
     rules: {
     //defaultEmail: {required: true, email: true}
     cardname: {required: true},
     accountname: {required: true},
     cardnum:{required:true},
     //entrustUsercode: {required: true},
     entrustStarttime: {required: true},
     entrustEndtime: {required: true},
     entrustStatus: {required: true},
     entrustIsEffect: {required: true},
     accounttype: {required: true},
     certificateType: {required: true},
     certificateNum: {required: true},
     customerNo: {required: true}
     },
     focusInvalid: true,
     onkeyup: false
     });
     })*/
</script>
</body>
</html>
