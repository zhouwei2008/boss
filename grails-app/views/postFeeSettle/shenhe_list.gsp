<%@ page import="boss.Perm; boss.BoAcquirerAccount" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'postFeeSettleshenhe.lable')}"/>
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
<script type="text/javascript">
    $(function() {
        $("#startTradeDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endTradeDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#startFootDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endFootDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });

    function checkDate2() {
        if (!document.getElementById('endTradeDate').value.length == 0) {
            var startDateCreated = document.getElementById('startTradeDate').value;
            var endDateCreated = document.getElementById('endTradeDate').value;
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始日期不能大于结束日期!');
                document.getElementById('endTradeDate').focus();
                return false;
            }
        }

        if (!document.getElementById('endFootDate').value.length == 0) {
            var startDateCreated = document.getElementById('startFootDate').value;
            var endDateCreated = document.getElementById('endFootDate').value;
            if (Number(startDateCreated > endDateCreated)) {
                alert('提交开始日期不能大于提交结束日期!');
                document.getElementById('endFootDate').focus();
                return false;
            }
        }
    }

         /*---guonan update 2011-12-30----*/
    function checkDate() {
        var startDateCreated = document.getElementById('startTradeDate').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endTradeDate').value.replace(/-/g,"//");
        var startFootDate = document.getElementById('startFootDate').value.replace(/-/g,"//");
        var endFootDate = document.getElementById('endFootDate').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endTradeDate').focus();
                return false;
            }
        }
        if (endFootDate.length != 0) {
            if (Number(startFootDate > endFootDate)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endFootDate').focus();
                return false;
            }
        }

    }

    function checkMaxInput(obj) {
        var maxlength = 80;
        if (obj.value.length > maxlength) {
            obj.value = obj.value.substring(0, maxlength);
        }
    }

    function showDialog(cus_no, foot_no, srvcode, trade_code, post_fee, fee_type) {
        document.getElementById("cusid_shenhe").value = cus_no;
        document.getElementById("footno_shenhe").value = foot_no;
        document.getElementById("srvcode_shenhe").value = srvcode;
        document.getElementById("tradecode_shenhe").value = trade_code;
        document.getElementById("postfee_shenhe").value = post_fee;
        document.getElementById("feetype_shenhe").value = fee_type;

        $('#dialog').dialog({
            autoOpen:false,
            title:'后返手续费结算审核',
            iconCls:'icon-ok',
            buttons: {
                "通过": function() {
                    var bank = document.getElementById("bank").value;
                    var footno = document.getElementById("footno_shenhe").value;
                    var result = document.getElementById("reson_shenhe").value;
                    var cusid = document.getElementById("cusid_shenhe").value;
                    var postfee = document.getElementById("postfee_shenhe").value;
                    var srvcode = document.getElementById("srvcode_shenhe").value;
                    var tradecode = document.getElementById("tradecode_shenhe").value;
                    var zhanghuanfangshi = $('input[name="zhanghuanfangshi_shenhe"]:checked').val();

                    var url = '${createLink(controller:'postFeeSettle',action:'shenhe_allow')}?bank=' + bank + '&zhanghuanfangshi=' + zhanghuanfangshi + "&result=" + result + "&footno=" + footno + "&cusid=" + cusid + "&postfee=" + postfee + "&srvcode=" + srvcode + "&tradecode=" + tradecode;

                    window.location.href = url;
                    $(this).dialog("close");
                },
                "拒绝": function() {
                    var bank = document.getElementById("bank").value;
                    var zhanghuanfangshi = $('input[name="zhanghuanfangshi_shenhe"]:checked').val();
                    var result = document.getElementById("reson_shenhe").value;
                    var footno = document.getElementById("footno_shenhe").value;
                    var cusid = document.getElementById("cusid_shenhe").value;
                    var postfee = document.getElementById("postfee_shenhe").value;
                    var srvcode = document.getElementById("srvcode_shenhe").value;
                    var tradecode = document.getElementById("tradecode_shenhe").value;
                    var feetype = document.getElementById("feetype_shenhe").value;
                    var url = '${createLink(controller:'postFeeSettle',action:'shenhe_deny')}?bank=' + bank + '&zhanghuanfangshi=' + zhanghuanfangshi + "&result=" + result + "&footno=" + footno + "&srvcode=" + srvcode + "&tradecode=" + tradecode + "&feetype=" + feetype + "&postfee=" + postfee + "&cusid=" + cusid;

                    window.location.href = url;
                    $(this).dialog("close");
                },
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
            function empty() {
        $(':input') .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
        return false;
    }
</script>

<div id="dialog" style="padding:5px;width:400px;height:200px;display:none">
    <input type="hidden" name="cusid_shenhe" id="cusid_shenhe" value='${cus_id}'>
    <input type="hidden" name="postfee_shenhe" id="postfee_shenhe" value='${postfee}'>
    <input type="hidden" name="srvcode_shenhe" id="srvcode_shenhe" value='${srvcode}'>
    <input type="hidden" name="tradecode_shenhe" id="tradecode_shenhe" value='${tradecode}'>
    <input type="hidden" name="footno_shenhe" id="footno_shenhe" value='${footno}'>
    <input type="hidden" name="feetype_shenhe" id="feetype_shenhe">
    <input type="hidden" name="zhanghuanfangshi">
    <input type="radio" name="zhanghuanfangshi_shenhe" value="1" checked="checked"/>资金账户
    <br>
    <input type="radio" name="zhanghuanfangshi_shenhe" value="2"/>银行转账/支票
<g:select name="bank" from="${BoAcquirerAccount.list()}" optionKey="id" optionValue="branchName"/>
    <br>
    请输入原因
    <br>
    <g:textArea cols="30" rows="10" name="reson_shenhe" onkeydown="checkMaxInput(this)" onkeyup="checkMaxInput(this)" onblur="checkMaxInput(this)"></g:textArea>
    <br>
    可输入80个汉字
</div>

<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top" style="width:auto;">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="postFeeSettleshenhe.lable"/></h1>
        <h2>
            <g:form controller="postFeeSettle" action="shenhe_list">
                商户编码：<g:textField name="customerNo" maxlength="24" onblur="value=value.replace(/[ ]/g,'')" value="${params.customerNo}" class="right_top_h2_input"/>
                名称：<g:textField name="name" maxlength="64" onblur="value=value.replace(/[ ]/g,'')" value="${params.name}" class="right_top_h2_input"/>
                手续费结算类型：<g:select id="selectFeeType" name="feeType" from="${settle.FtFoot.settleFeeTypeMap}" optionKey="key" optionValue="value" value="${params.feeType}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
                日期：<g:textField name="startTradeDate" value="${params.startTradeDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--<g:textField name="endTradeDate" value="${params.endTradeDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>
                提交日期：<g:textField name="startFootDate" value="${params.startFootDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--<g:textField name="endFootDate" value="${params.endFootDate}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>
                <g:actionSubmit class="right_top_h2_button_serch" action="shenhe_list" value="查询" onclick="return checkDate()" />
                <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
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
            <th>日期</th>
            <th>提交日期</th>
            <th>业务类型</th>
            <th>交易类型</th>
            <th>交易笔数</th>
            <th>金额</th>
            <th>后返手续费</th>
            <th>还款金额</th>
            <th>操作</th>
            <th>提交人</th>
            <th>状态</th>
            <th>手续费结算类型</th>
            <th style="display:none;">手续费结算类型</th>
            <th>生成结算单</th>
        </tr>
        <g:each in="${ftTradeFeeList}" status="i" var="item">
            <tr>
                <td>${i + 1}</td>
                <td>${item.CUSTOMER_NO}</td>
                <g:set var="cu" value="${ismp.CmCustomer.findByCustomerNo(item.CUSTOMER_NO)}"/>
                <td>${cu?.name}/${cu?.registrationName}</td>
                <td>${item.FOOT_NO}</td>
                <td><g:formatDate format="yyyy.MM.dd" date="${item.MINTIME}"/>-<g:formatDate format="yyyy.MM.dd" date="${item.MAXTIME}"/></td>
                <td><g:formatDate format="yyyy.MM.dd" date="${item.FOOT_DATE}"/></td>
                <td>${item.SRV_NAME}</td>
                <td>${item.TRADE_NAME}</td>
                <td>${item.TRANS_NUM}</td>
                <td>${item.AMOUNT / 100}</td>
                <td><g:if test="${item.POST_FEE}">${item.POST_FEE / 100}</g:if></td>
                <td><g:if test="${item.POST_FEE}">${item.POST_FEE / 100}</g:if></td>
                <td>
                    <g:if test="${item.FEE_TYPE == 2}">
                        无清算明细
                    </g:if>
                    <g:else>
                        <bo:hasPerm perm="${Perm.Settle_PostSettleChk_Detail}" ><a href='${createLink(controller: 'postFeeSettle', action: 'shenhe_show', params: ['customerNo': item.CUSTOMER_NO, 'FOOT_NO': item.FOOT_NO, 'tradecode': item.TRADE_CODE, 'srvcode': item.SRV_CODE, 'status': 1])}'>查看明细</a></bo:hasPerm>
                    </g:else>
                </td>
                <td>${boss.BoOperator.get(item.CREATE_OP_ID)?.account}</td>
                <td>${settle.FtFoot.checkStatusMap[item.CHECK_STATUS.toString()]}</td>
                <td>${settle.FtFoot.feetypeMap[item.FEE_TYPE.toString()]}</td>
                <td style="display:none;">${item.FEE_TYPE}</td>
                <td>
                    <bo:hasPerm perm="${Perm.Settle_PostSettleChk_Proc}" ><input type="button" value="审核" onclick="showDialog('${item.CUSTOMER_NO}', '${item.FOOT_NO}', '${item.SRV_CODE}', '${item.TRADE_CODE}', '${item.POST_FEE}', '${item.FEE_TYPE}')"/></bo:hasPerm>
                </td>
            </tr>
        </g:each>
    </table>
    </div>
    合计：金额：<g:formatNumber number="${total_amount / 100}" format="#.##"/>元，后返手续费金额：<g:formatNumber number="${total_postfee / 100}" format="#.##"/>元，还款金额：<g:formatNumber number="${total_postfee / 100}" format="#.##"/>元

    <div class="paginateButtons">
        <div align="left"><div style="position:absolute;">共${total}条记录</div></div>
        <g:paginat total="${total}" params="${params}"/>
    </div>
</div>
</body>
</html>