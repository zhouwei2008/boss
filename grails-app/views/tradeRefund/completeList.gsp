<%@ page import="boss.Perm; gateway.GwTransaction; ismp.TradeCharge; ismp.TradePayment; ismp.TradeBase; ismp.TradeRefund" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tradeRefund.completeList.label', default: 'TradeRefund')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });
    function checkDate() {
        var startDate = document.getElementById("startDateCreated").value;
        var endDate = document.getElementById("endDateCreated").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endDateCreated").focus();
            return false;
        }
    }
      /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startDateCreated = document.getElementById('startDateCreated').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endDateCreated').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间！');
                document.getElementById('endDateCreated').focus();
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
              alert('每次只能查询1个月范围内的数据！');
              return false;
          }
    }
        function empty() {
        $(':input') .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');

        return false;
    }
</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <g:form>
            <div class="table_serch">
                <table>
                    <tr>
                        <td>交易流水号：</td><td><g:textField name="tradeNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.tradeNo}" class="right_top_h2_input"/></td>
                        <td>退款人名称：</td><td><g:textField name="payerName" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerName}" class="right_top_h2_input"/></td>
                        <td>退款人账户：</td><td><p><g:textField name="payerAccountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.payerAccountNo}" class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td>退款金额：</td><td><p><g:textField name="startAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px;" value="${params.startAmount}" class="right_top_h2_input"/>--
                        <g:textField name="endAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endAmount}" style="width:60px;" class="right_top_h2_input"/></p></td>
                        <td>处理状态：</td><td><p><g:select name="handleStatus" value="${params.handleStatus}" from="${TradeRefund.handleMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                        <td>申请时间：</td><td><g:textField name="startDateCreated" value="${params.startDateCreated}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--
                        <g:textField name="endDateCreated" value="${params.endDateCreated}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/></td>
                        <g:hiddenField name="flag" value="2"></g:hiddenField>
                    </tr>
                    <tr>
                        <td colspan="2" class="left"><g:actionSubmit class="right_top_h2_button_serch" action="completeList" value="查询" onclick="return checkDate()"/>
                            <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
                            <bo:hasPerm perm="${Perm.Trade_RfdHis_Dl}"><g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()"/></bo:hasPerm></td>
                    </tr>
                </table>
            </div>
        </g:form>
        <table align="center" class="right_list_table" id="test">

            <tr>
                <th>${message(code: 'tradeRefund.tradeNo.label')}</th>
                <th>${message(code: 'tradeRefund.payerName.label')}</th>
                <th>${message(code: 'tradeRefund.payerAccountNo.label')}</th>
                <th>原订单金额</th>
                <th>${message(code: 'tradeRefund.amount.label')}</th>
                <th>${message(code: 'tradeRefund.handleStatus.label')}</th>
                <th>银行订单号</th>
                <th>${message(code: 'tradeRefund.dateCreated.label')}</th>
                <th>原交易时间</th>
            </tr>

            <g:each in="${tradeRefundInstanceList}" status="i" var="tradeRefund">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:if test="${bo.hasPerm(perm:Perm.Trade_RfdHis_View){true}}" ><g:link action="completeShow" id="${tradeRefund.id}">${fieldValue(bean: tradeRefund, field: "tradeNo")}</g:link></g:if><g:else>${fieldValue(bean: tradeRefund, field: "tradeNo")}</g:else></td>
                    <td>${fieldValue(bean: tradeRefund, field: "payerName")}</td>
                    <td>${fieldValue(bean: tradeRefund, field: "payerAccountNo")}</td>
                    <g:if test="${tradeRefund.partnerId==null}">
                        <g:if test="${TradeBase.findByRootIdAndTradeType(tradeRefund.rootId,'charge')?.amount>0}">
                            <td><g:formatNumber number="${TradeBase.findByRootIdAndTradeType(tradeRefund.rootId,'charge')?.amount/100}" type="currency" currencyCode="CNY"/></td>
                        </g:if>
                    </g:if>
                    <g:elseif test="${tradeRefund.partnerId!=null}">
                        <g:if test="${TradePayment.get(tradeRefund.originalId)?.amount>0}">
                            <td><g:formatNumber number="${TradePayment.get(tradeRefund.originalId)?.amount/100}" type="currency" currencyCode="CNY"/></td>
                        </g:if>
                    </g:elseif>
                    <g:else>
                        <td></td>
                    </g:else>
                    <td><g:formatNumber number="${tradeRefund?.amount/100}" type="currency" currencyCode="CNY"/></td>
                    <td>${TradeRefund.handleStatusMap[tradeRefund?.handleStatus]}</td>
                    <td><g:link action="show" controller="gwTransaction" id="${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.id}">${GwTransaction.get(TradeCharge.findByRootId(tradeRefund.rootId)?.tradeNo)?.bankTransNo}</g:link></td>
                    <td><g:formatDate date="${tradeRefund?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <g:if test="${tradeRefund.partnerId==null}">
                        <td>
                            <g:formatDate date="${TradeBase.findByRootIdAndTradeType(tradeRefund.rootId,'charge')?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                    </g:if>
                    <g:elseif test="${tradeRefund.partnerId!=null}">
                        <td>
                            <g:formatDate date="${TradePayment.findByRootIdAndTradeType(tradeRefund.rootId,'payment')?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                    </g:elseif>
                    <g:else>
                        <td></td>
                    </g:else>
                </tr>
            </g:each>
        </table>
         合计：原订单金额总计：${totalAmount?totalAmount/100:0}元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;退款金额总计：${refundAmount?refundAmount/100:0}元
        <div class="paginateButtons">
            <span style=" float:left;">共${tradeRefundInstanceTotal}条记录</span>
            <g:paginat total="${tradeRefundInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
