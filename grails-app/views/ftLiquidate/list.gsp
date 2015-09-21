<%@ page import="boss.Perm; ismp.CmCorporationInfo; settle.FtLiquidate" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftLiquidate.label', default: 'FtLiquidate')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
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
        });
          function empty() {
        $(':input') .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
        return false;
    }
</g:javascript>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form>
                <g:message code="ftLiquidate.customerNo.label"/>：<g:textField name="mid" onblur="value=value.replace(/[ ]/g,'')" maxlength="20" value="${params?.mid}" class="right_top_h2_input" style="width:120px"/>
                <g:message code="default.search.name.label"/>：<g:textField name="name" onblur="value=value.replace(/[ ]/g,'')" maxlength="20" value="${params?.name}" class="right_top_h2_input" style="width:120px"/>
                <g:message code="ftLiquidate.srvCode.label"/>：<g:select id="sel_srv_code" class="right_top_h2_input" style="width:100px" name="bType" from="${bTypeList}" value="${params?.bType}" optionKey="srvCode" optionValue="srvName" noSelection="${['':message(code:'default.select.none.label')]}"/>
                <g:message code="ftLiquidate.tradeCode.label"/>：
                <g:if test="tTypeList"><g:select id="sel_trade_code" class="right_top_h2_input" style="width:100px" name="tType" from="${tTypeList}" value="${params?.tType}" optionKey="tradeCode" optionValue="tradeName" noSelection="${['':message(code:'default.select.none.label')]}"/></g:if>
                <g:else><select id="sel_trade_code" name="tType" class="right_top_h2_input" style="width:100px"><option value="">${message(code: 'default.select.none.label')}</option></select></g:else>
                <g:actionSubmit class="right_top_h2_button_serch" action="list" value="${message(code: 'default.search.label', args:[''])}"/>
                <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
            </g:form>
        </h2>
    </div>
    <div class="right_list_tablebox">
    <table align="center" class="right_list_table" id="test">
        <tr>

            <th><g:message code="default.serial.number.label"/></th>

            <th><g:message code="ftLiquidate.customerNo.label"/></th>

            <th><g:message code="default.search.result.name.label"/></th>

            <th><g:message code="ftLiquidate.liqDate.label"/></th>

            <th><g:message code="ftLiquidate.srvCode.label"/></th>

            <th><g:message code="ftLiquidate.tradeCode.label"/></th>

            <th><g:message code="ftLiquidate.transNum.label"/></th>

            <th><g:message code="ftLiquidate.amount.label"/></th>

            <th><g:message code="ftLiquidate.preFee.label"/></th>

            <th><g:message code="ftLiquidate.postFee.label"/></th>

            <th><g:message code="ftLiquidate.footAmount.label"/></th>

            <th><g:message code="ftLiquidate.operation.label"/></th>

            <th><g:message code="ftLiquidate.generateFoot.label"/></th>
        </tr>

        <g:each in="${result}" status="i" var="item">
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                <td>${i + 1}</td>

                <td>${item.CUSTOMERNO}</td>

                <g:set var="cu" value="${ismp.CmCustomer.findByCustomerNo(item.CUSTOMERNO)}"/>
                <td>${cu?.name}/${cu?.registrationName}</td>

                <td><g:formatDate format="yyyy.MM.dd" date="${item.MINTIME}"/>-<g:formatDate format="yyyy.MM.dd" date="${item.MAXTIME}"/></td>

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

                <td><bo:hasPerm perm="${Perm.Settle_PreManualSettle_Detail}" ><g:link controller="ftTrade" action="detailLiquidate" params="${[bt:item.SRVCODE,tt:item.TRADECODE,mid:item.CUSTOMERNO,feeType:item.FEETYPE,start:item.MINTIME,end:item.MAXTIME]}">${message(code: 'ftLiquidate.queryDetail.label', default: 'QueryDetail')}</g:link></bo:hasPerm></td>

                <td>
                    <bo:hasPerm perm="${Perm.Settle_PreManualSettle_Manual}" ><input type="button" onclick="window.location.href = '${createLink(controller:'ftLiquidate', action:'generate', params:[bt:item.SRVCODE,tt:item.TRADECODE,mid:item.CUSTOMERNO,amt:item.AMOUNT,tn:item.TRANSNUM,pref:item.PREFEE,postf:item.POSTFEE,feeType:item.FEETYPE])}'" value="生成"/></bo:hasPerm>
                </td>
            </tr>
        </g:each>
    </table>
      </div>
    合计：交易笔数总计：${totalTransNum}笔，&nbsp;&nbsp;&nbsp;&nbsp;清算金额总计：${totalAmount/ 100}元，&nbsp;&nbsp;&nbsp;&nbsp;即收手续费总计：${totalPreFee/100}元，&nbsp;&nbsp;&nbsp;&nbsp;
          后返手续费总计：${totalPostFee/100}元，&nbsp;&nbsp;&nbsp;&nbsp;结算金额总计：<g:if test="${totalPreFee}">${(totalAmount - totalPreFee) / 100}</g:if><g:else>${totalAmount / 100}</g:else>元
    <div class="paginateButtons">
        <div align="left"><div style="position:absolute;">共${total}条记录</div></div>
        <g:paginat total="${total}" params="${params}"/>
    </div>
</div>
</body>
</html>
