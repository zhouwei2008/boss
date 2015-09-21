<%@ page import="boss.Perm; ismp.CmCorporationInfo;" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'FeeSettleshenhe_his_list.lable')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <style>
    table {
        width: 100%;
    }

    table th {
        word-break: keep-all;
        white-space: nowrap;
    }

    table td {
        word-break: keep-all;
        white-space: nowrap;
    }
    </style>
</head>
<body>
<g:javascript>
        $(function(){
            $("#startTradeDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
            $("#endTradeDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });

            $('#sel_srv_code').change(function(){
                var selValue = $('#sel_srv_code option:selected').val();
                var tag = '<option value="">${message(code: 'default.select.none.label')}</option>';
                if(selValue != ''){
                    $.ajax({
                        type: "POST",
                        url: "${createLink(controller: 'ftLiquidate', action: 'queryTrade')}",
                        data: "srvCode="+selValue,
                        dataType: "json",
                        success: function(jsonArr){
                            if(jsonArr && jsonArr.length >  0){
                                for(var i in jsonArr){
                                    var json = jsonArr[i];
                                    tag += '<option value="'+json.tradeCode+'">'+json.tradeName+'</option>';
                                }
                            }
                            $('#sel_trade_code').empty().append(tag);
                        }
                    });
                }else{
                    $('#sel_trade_code').empty().append(tag);
                }
            });
        });

        function checkDate() {
            if (!document.getElementById('endTradeDate').value.length == 0) {
                var startDateCreated = document.getElementById('startTradeDate').value;
                var endDateCreated = document.getElementById('endTradeDate').value;
                if (Number(startDateCreated > endDateCreated)) {
                    alert('开始日期不能大于结束日期!');
                    document.getElementById('endTradeDate').focus();
                    return false;
                }
            }
        }
      /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startDateCreated = document.getElementById('startTradeDate').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endTradeDate').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endTradeDate').focus();
                return false;
            }
        }
        // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectF=new Date(startDateCreated);
        var dSelectT=new Date(endDateCreated);
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
    }
        function checkDateFormate(Field) {
            var inputDateValue = Field.value;
            var desc = Field.description;
            if (inputDateValue == null || inputDateValue == '') {
                return false;
            }

            //获取输入字符串的长度
            var inputValueLength = inputDateValue.length;
            //如果满足下面判断的所有条件才算合法的日期，否则不合法
            if (checkNumeric(inputDateValue) && checkLegth(inputValueLength) && checkSpecialChar(inputDateValue)) {
                return true;
            } else {
                errorMessage("请输入合法的" + desc + "\n类型为日期，格式为YYYY-MM-DD 或者YYYYMMDD");
                Field.focus();
                return false;
            }
        }

        //日期只能是8~10位
        function checkLegth(length) {
            if (length < 8 || length > 10) {
                return false;
            }
            return true;
        }

        //如果输入的内容中包含‘-’，则按照‘-’分割来去年月日，否则直接按照位数取
        function checkSpecialChar(inputDateValue) {
            var index = inputDateValue.indexOf('-');
            var year = 0;
            var month = 0;
            var day = 0;

            if (index > -1) {
                var lastIndex = inputDateValue.lastIndexOf('-');

                //只能是YYYY-M-DD或者YYYY-MM-DD的形式
                if (lastIndex - index < 1 || lastIndex - index > 3) {
                    return false;
                }

                var arrDate = inputDateValue.split('-');
                year = arrDate[0];
                month = arrDate[1];
                day = arrDate[2];
            } else {
                year = inputDateValue.substring(0, 4);
                month = inputDateValue.substring(4, 6);
                day = inputDateValue.substring(6, 8);
            }

            if (Number(month) > 12 || Number(day) > 31 || Number(month) < 1 || Number(day) < 1 || year.length != 4) {
                return false;
            } else if (day > getLastDayOfMonth(Number(year), Number(month))) {
                return false;
            }

            return true;
        }

        //判断输入的内容将‘-’替换成为数字1后，是否全部为数字
        function checkNumeric(inputDateValue) {
            var replacedValue = inputDateValue.replace(/-/g, '1');
            return isNumeric(replacedValue);
        }

        //判断是否为数字
        function isNumeric(strValue) {
            var result = regExpTest(strValue, /\d*[.]?\d*/g);
            return result;
        }

        function regExpTest(source, re) {
            var result = false;
            if (source == null || source == ""){
                return false;
            }

            if (source == re.exec(source)) {
                result = true;
            }
            return result;
        }

        //获得一个月中的最后一天
        function getLastDayOfMonth(year, month) {
            var days = 0;
            switch (month) {
            case 1: case 3: case 5: case 7: case 8: case 10: case 12: days = 31;break;
            case 4: case 6: case 9: case 11: days = 30;break;
            case 2: if (isLeapYear(year)) days = 29; else days = 28;break;
        }

        return days;
    }

    //判断是否为闰年
    function isLeapYear(year) {
        if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
             return true;
        } else {
            return false;
        }
    }

    function showDialog(cus_no, cus_name, foot_no, reason, feetype) {
        document.getElementById('reson_div').value = reason;

        $('#dialog').dialog({
            autoOpen:false,
            title:'查看拒绝原因',
            iconCls:'icon-ok',
            buttons: {
                "关闭": function() {
                    $(this).dialog("close");
                }
            }
            //    buttons:[{
            //        text:'关闭',
            //        id:"btn",
            //        handler:function(){alert("hello");}
            //    }]
        });

        $('#dialog').dialog('open');
    }

    function checkMaxInput(obj) {
        var maxlength = 80;
        if (obj.value.length > maxlength) {
            obj.value = obj.value.substring(0, maxlength);
        }
    }
    function empty() {
        $(':input') .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
        return false;
    }
</g:javascript>
<div id="dialog" style="padding:5px;width:400px;height:200px;display:none">
    <g:textArea name="reson_div" rows="" cols="" id="reson_div" onkeydown="checkMaxInput(this)" onkeyup="checkMaxInput(this)" onblur="checkMaxInput(this)" value="${REJECT_REASON}" disabled="true"></g:textArea>
</div>

<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top" style="width:auto;">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form controller="postFeeSettle" action="settle_his_list">
                商户编号：<g:textField name="customerNo" maxlength="24" onblur="value=value.replace(/[ ]/g,'')" value="${params.customerNo}" class="right_top_h2_input"/>
                名称：<g:textField name="name" maxlength="64" onblur="value=value.replace(/[ ]/g,'')" value="${params.name}" class="right_top_h2_input"/>
                日期：<g:textField name="startTradeDate" value="${params.startTradeDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--<g:textField name="endTradeDate"  value="${params.endTradeDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>
                结算单提交人：<g:textField name="createopt" maxlength="20" onblur="value=value.replace(/[ ]/g,'')" value="${params.createopt}" class="right_top_h2_input"/>
                <br/>
                结算单复核人：<g:textField name="checkopt" maxlength="20" onblur="value=value.replace(/[ ]/g,'')" value="${params.checkopt}" class="right_top_h2_input"/>
                状态：<g:select name="checkstatus" value="${params.checkstatus}" from="${settle.FtFoot.checkStatusMap}" optionKey="key" optionValue="value" class="right_top_h2_input"/>
                <g:message code="ftLiquidate.srvCode.label"/>：<g:select style="width:100px" class="right_top_h2_input" id="sel_srv_code" name="bType" value="${params?.bType}" from="${bTypeList}" optionKey="srvCode" optionValue="srvName" noSelection="${['':message(code:'default.select.none.label')]}"/>
                <g:message code="ftLiquidate.tradeCode.label"/>：
                    <g:if test="tTypeList">
                        <g:select id="sel_trade_code" name="tType" style="width:100px" class="right_top_h2_input" value="${params?.tType}" from="${tTypeList}" optionKey="tradeCode" optionValue="tradeName" noSelection="${['':message(code:'default.select.none.label')]}"/>
                    </g:if>
                    <g:else>
                        <select id="sel_trade_code" style="width:100px" class="right_top_h2_input" name="tType">
                            <option value="">${message(code: 'default.select.none.label')}</option>
                        </select>
                    </g:else>
                <g:actionSubmit class="right_top_h2_button_serch" action="settle_his_list" value="查询" onclick="return checkDate()" />
                <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
                <g:actionSubmit class="right_top_h2_button_download" action="settle_his_Download" value="下载" onclick="return checkDate()"/>
            </g:form>
        </h2>
    </div>
    <div class="right_list_tablebox">
    <table align="center" class="right_list_table" id="test">
        <tr>
            <th>序号</th>
            <th>商户编号</th>
            <th>名称/商户名称</th>
            <tH>批次号</tH>
            <tH>复核日期</tH>
            <th>日期</th>
            <th>业务类型</th>
            <th>交易类型</th>
            <th>交易笔数</th>
            <th>金额</th>
            <th>即收手续费</th>
            <th>后返手续费</th>
            <th>结算金额</th>
            <th>操作</th>
            <th>提交人</th>
            <th>复核人</th>
            <th>费率类型</th>
            <th>状态</th>
            <th>结算类型</th>
            <th>备注</th>
        </tr>
        <g:each in="${ftTradeFeeList}" status="i" var="item">
            <tr>
                <td>${i + 1}</td>
                <td>${item.CUSTOMER_NO}</td>
                <g:set var="cu" value="${ismp.CmCustomer.findByCustomerNo(item.CUSTOMER_NO)}"/>
                <td>${cu?.name}/${cu?.registrationName}</td>
                <td>${item.FOOT_NO}</td>
                <td><g:formatDate date="${item.CHECK_DATE}" format="yyyy-MM-dd HH:mm:ss"/></td>
                <td><g:formatDate format="yyyy.MM.dd" date="${item.MINTIME}"/>-<g:formatDate format="yyyy.MM.dd" date="${item.MAXTIME}"/></td>
                <td>${item.SRV_NAME}</td>
                <td>${item.TRADE_NAME}</td>
                <td>${item.TRANS_NUM}</td>
                <td>${item.AMOUNT / 100}</td>
                <td><g:if test="${item.PRE_FEE}">${item.PRE_FEE / 100}</g:if></td>
                <td><g:if test="${item.POST_FEE}">${item.POST_FEE / 100}</g:if></td>
                <td><g:if test="${item.PRE_FEE}">${(item.AMOUNT - item.PRE_FEE) / 100}</g:if></td>
                <td>
                  <bo:hasPerm perm="${Perm.Settle_SettleHis_Detail}" >
                    <g:if test="${item.CHECK_STATUS.toString() != '2'}">
                        <a href="${createLink(controller: 'postFeeSettle', action: 'settle_his_showdetails', params: ['id': item.ID])}">查看明细</a>
                    </g:if>
                  </bo:hasPerm>
                </td>
                <td>${boss.BoOperator.get(item.CREATE_OP_ID)?.account}</td>
                <td>${boss.BoOperator.get(item.CHECK_OP_ID)?.account}</td>
                <td>${settle.FtFoot.feetypeMap[item.FEE_TYPE.toString()]}</td>
                <td>${settle.FtFoot.checkStatusMap[item.CHECK_STATUS.toString()]}</td>
                <td>${item.TYPE}</td>
                <td>${item.REJECT_REASON}</td>
            </tr>
        </g:each>
    </table>
    </div>
    合计：金额总计：<g:formatNumber number="${amount / 100}" format="#.##"/>元，&nbsp;&nbsp;&nbsp;&nbsp;即收手续费总计：<g:formatNumber number="${preFee/100}" format="#.##"/>元，&nbsp;&nbsp;&nbsp;&nbsp;后返手续费总计：<g:formatNumber number="${postFee/100}" format="#.##"/>元，&nbsp;&nbsp;&nbsp;&nbsp;结算金额总计：<g:formatNumber number="${totalAmount / 100}" format="#.##"/>元
    <div class="paginateButtons">
        <div align="left"><div style="position:absolute;">共${total}条记录</div></div>
        <g:paginat total="${total}" params="${params}"/>
    </div>
</div>
</body>
</html>