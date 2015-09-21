<%@ page import="boss.Perm; ismp.CmCorporationInfo; ismp.CmPersonalInfo; settle.FtFoot" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftFoot.label', default: 'FtFoot')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <style>
    table {
        width: 100%;
        border: 1px solid #999;
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
    <g:javascript library="jquery-1.4.4.min"/>
    <g:javascript>
        $(function(){
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
                                    tag += '<option value="'+json.tradeCode+'">'+json.tradeName+'</option>'
                                }
                            }
                            $('#sel_trade_code').empty().append(tag);
                        }
                    });
                }else{
                    $('#sel_trade_code').empty().append(tag);
                }
            });

            $( "#dialog-form" ).dialog({
                autoOpen: false,
                height: 250,
                width: 350,
                modal: true,
                buttons:{
                    "${message(code: 'ftFoot.button.reject.label')}": function() {
                        var msg = $('#reject_form_msg').val();
                        if(msg && msg.length < 81){
                            $('#reject_form').submit();
                            $(this).dialog( "close" );
                        }else{
                            $('#dialog_error_msg').empty().append('${message(code: 'ftFoot.invalid.reject.message.label')}');
                        }
                    },
                    "${message(code: 'ftFoot.button.cancel.label')}": function() {
                        $(this).dialog( "close" );
                    }
                }
            });

            $( ".reject_link" ).click(function(){
                var id = $(this).attr('id');
                if(id){
                    $('#reject_form_id').val(id.substring(7));
                    $( "#dialog-form" ).dialog( "open" );
                }else{
                    alert('lose item id');
                }
            });
        });
        function empty() {
        $(':input') .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
        return false;
    }
    </g:javascript>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top" style="width:auto;">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form>
                <g:message code="ftLiquidate.customerNo.label"/>：<g:textField name="mid" onblur="value=value.replace(/[ ]/g,'')" maxlength="20" value="${params?.mid}" class="right_top_h2_input" style="width:120px"/>
                <g:message code="default.search.name.label"/>：<g:textField name="name" onblur="value=value.replace(/[ ]/g,'')" maxlength="20" value="${params?.name}" class="right_top_h2_input" style="width:120px"/>
                <g:message code="ftLiquidate.srvCode.label"/>：<g:select id="sel_srv_code" style="width:100px" class="right_top_h2_input" name="bType" from="${bTypeList}" value="${params?.bType}" optionKey="srvCode" optionValue="srvName" noSelection="${['':message(code:'default.select.none.label')]}"/>
                <g:message code="ftLiquidate.tradeCode.label"/>：
                <g:if test="tTypeList"><g:select id="sel_trade_code" style="width:100px" class="right_top_h2_input" name="tType" from="${tTypeList}" value="${params?.tType}" optionKey="tradeCode" optionValue="tradeName" noSelection="${['':message(code:'default.select.none.label')]}"/></g:if>
                <g:else><select id="sel_trade_code" style="width:100px" class="right_top_h2_input" name="tType"><option value="">${message(code: 'default.select.none.label')}</option></select></g:else>
                <g:actionSubmit class="right_top_h2_button_serch" action="list" value="${message(code: 'default.search.label', args:[''])}"/>
                <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
            </g:form>
        </h2>
    </div>
    <div class="right_list_tablebox">
    <table align="center" class="right_list_table" id="test">
        <tr>
            <th><g:message code="default.serial.number.label"/></th>

            <th><g:message code="ftFoot.customerNo.label"/></th>

            <th><g:message code="default.search.result.name.label"/></th>

            <th><g:message code="ftFoot.footNo.label"/></th>

            <th><g:message code="ftLiquidate.liqDate.label"/></th>

            <th><g:message code="ftFoot.footDate.label"/></th>

            <th><g:message code="ftFoot.srvCode.label"/></th>

            <th><g:message code="ftFoot.tradeCode.label"/></th>

            <th><g:message code="ftFoot.transNum.label"/></th>

            <th><g:message code="ftFoot.amount.label"/></th>

            <th><g:message code="ftFoot.preFee.label"/></th>

            <th><g:message code="ftFoot.postFee.label"/></th>

            <th><g:message code="ftLiquidate.footAmount.label"/></th>

            <th><g:message code="ftFoot.checkStatus.label"/></th>

            <th><g:message code="ftFoot.createOpId.label"/></th>

            <th><g:message code="ftLiquidate.operation.label"/></th>

            <th><g:message code="ftFoot.check.label"/></th>

        </tr>

        <g:each in="${result}" status="i" var="item">
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                <td>${i + 1}</td>

                <td>${item.CUSTOMERNO}</td>

                <g:set var="cu" value="${ismp.CmCustomer.findByCustomerNo(item.CUSTOMERNO)}"/>
                <td>${cu?.name}/${cu instanceof CmPersonalInfo ? cu?.name : cu?.registrationName}</td>

                <td>${item.FOOTNO}</td>

                <td><g:formatDate format="yyyy.MM.dd" date="${item.MINTIME}"/>-<g:formatDate format="yyyy.MM.dd" date="${item.MAXTIME}"/></td>

                <td><g:formatDate format="yyyy.MM.dd HH:mm:ss" date="${item.FOOTDATE}"/></td>

                <td>${item.SRVNAME}</td>

                <td>${item.TRADENAME}</td>

                <td>${item.TRANSNUM}</td>

                <td>${item.AMOUNT / 100}</td>

                <td><g:if test="${item.PREFEE}">${item.PREFEE / 100}</g:if></td>

                <td><g:if test="${item.POSTFEE}">${item.POSTFEE / 100}</g:if></td>

                <td>
                    <g:if test="${item.PREFEE}">${(item.AMOUNT - item.PREFEE) / 100}</g:if>
                    <g:else>${item.AMOUNT / 100}</g:else>
                </td>

                <td>${FtFoot.checkStatusMap[item.CHECKSTATUS.toString()]}</td>

                <td>${boss.BoOperator.get(item.CREATEOPID)?.account}</td>

                <td>
                    <bo:hasPerm perm="${Perm.Settle_PreSettleChk_Detail}" ><g:link controller="ftTrade" action="detailFoot" params="${[id:item.ID]}">${message(code: 'ftLiquidate.queryDetail.label', default: 'QueryDetail')}</g:link></bo:hasPerm>
                </td>

                <td>
                  <bo:hasPerm perm="${Perm.Settle_PreSettleChk_Proc}">
                    <g:link controller="ftFoot" action="pass" params="${[id:item.ID]}">${message(code: 'ftFoot.pass.label', default: 'Pass')}</g:link>
                    <a href="javascript:void(0)" id="reject_${item.ID}" class="reject_link">${message(code: 'ftFoot.reject.label', default: 'Reject')}</a>
                  </bo:hasPerm>
                </td>

            </tr>
        </g:each>
    </table>
    </div>
    <g:message code="ftFoot.text.total.label"/>: <g:message code="ftFoot.amount.label"/>:${totalAmount / 100}<g:message code="ftFoot.text.unit.label"/> <g:message code="ftFoot.preFee.label"/>:${totalPreFee / 100}<g:message code="ftFoot.text.unit.label"/> <g:message code="ftLiquidate.footAmount.label"/>:${(totalAmount - totalPreFee) / 100}<g:message code="ftFoot.text.unit.label"/>

    <div class="paginateButtons">
        <div align="left"><div style="position:absolute;">共${total}条记录</div></div>
        <g:paginat total="${total}" params="${params}"/>
    </div>
</div>
<div id="dialog-form">
    <p class="validateTips"><g:message code="ftFoot.text.prompt.reject.label"/></p>
    <form id="reject_form" action="${request.getContextPath()}/ftFoot/reject">
        <input id="reject_form_id" name="id" type="hidden"/>
        <textarea name="msg" id="reject_form_msg" rows="4" cols="20"></textarea>
    </form>
    <p class="validateTips"><g:message code="ftFoot.text.prompt.reject.maxsize.label"/></p>
    <div id="dialog_error_msg" style="color:red"></div>
</div>
</body>
</html>
