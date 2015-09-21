<%@ page import="ismp.CmCustomer; boss.Perm; gateway.GwOrder" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'gwOrder.label', default: 'GwOrder')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true,changeMonth: true });
        $("#endTime").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#startLastUpdated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endLastUpdated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
    });
    function checkDate() {
        var startDate = document.getElementById("startTime").value;
        var endDate = document.getElementById("endTime").value;

        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endTime").focus();
            return false;
        }

        //update sunweiguo 2012-06-06
       if (!document.getElementById('endLastUpdated').value.length == 0) {
            var startLastUpdated = document.getElementById('startLastUpdated').value;
            var endLastUpdated = document.getElementById('endLastUpdated').value;
            if (Number(startLastUpdated > endLastUpdated)) {
                alert("修改开始时间不能大于结束时间!");
                document.getElementById('endLastUpdated').focus();
                return false;
            }
        }
    }

        /*---guonan update 2011-12-30----*/
    function checkDate2() {
        var startDateCreated = document.getElementById('startTime').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endTime').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endTime').focus();
                return false;
            }
        }
        // 格式为‘2011/11/11’的形式可以直接转化为日期类型
        var dSelectF=new Date(startDateCreated.substring(0,4)+'/'+startDateCreated.substring(4,6)+'/'+startDateCreated.substring(6,8));
        var dSelectT=new Date(endDateCreated.substring(0,4)+'/'+endDateCreated.substring(4,6)+'/'+endDateCreated.substring(6,8));
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
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">
            <g:message code="default.list.label" args="[entityName]"/>
        </h1>
        <div class="table_serch">
            <table>
                <g:form>
                    <tr>
                        <td>${message(code: 'gwOrder.sellerCustomerNo.label')}：</td>
                        <td><p><g:textField name="sellerCustomerNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.sellerCustomerNo}" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'gwOrder.buyerCode.label')}：</td>
                        <td><g:textField name="buyerCode" onblur="value=value.replace(/[ ]/g,'')" value="${params.buyerCode}" class="right_top_h2_input"/></td>
                        <td>${message(code: 'gwOrder.id.label')}：</td>
                        <td><p><g:textField name="id" onblur="value=value.replace(/[ ]/g,'')" value="${params.id}" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'gwOrder.amount.label')}：</td>
                        <td><p><g:textField name="startAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.startAmount}" style="width:60px" class="right_top_h2_input"/>--<g:textField name="endAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endAmount}" style="width:60px" class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td>${message(code: 'gwOrder.outTradeNo.label')}：</td>
                        <td><p><g:textField name="outTradeNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.outTradeNo}" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'gwOrder.transactionId.label')}：</td>
                        <td><g:textField name="transactionId" value="${params.transactionId}" class="right_top_h2_input"/></td>
                        <td>${message(code: 'gwTransaction.acquirerCode.label')}：</td>
                        <td><p><g:textField name="acquirerCode" onblur="value=value.replace(/[ ]/g,'')" value="${params.acquirerCode}" class="right_top_h2_input"/></p></td>
                         %{--${message(code: 'gwTransaction.bankTransNo.label')}：--}%
                        %{--<g:textField name="bankTransNo" value="${params.bankTransNo}" class="right_top_h2_input"/>--}%
                        <td>${message(code: 'gwTransaction.authNo.label')}：</td>
                        <td><g:textField name="authNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.authNo}" class="right_top_h2_input"/></td>
                    </tr>
                    <tr>
                        <td>${message(code: 'gwOrder.status.label')}：
                        <td><p><g:select name="status" value="${params.status}" from="${GwOrder.statusMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                        <!--update sunweiguo 2012-06-05 增加卖家名称查询条件-->
                        <td>卖家名称：</td>
                        <td><p><g:textField name="sellerName" onblur="value=value.replace(/[ ]/g,'')" value="${params.sellerName}" class="right_top_h2_input"/></p></td>
                        <!--update sunweiguo 2012-06-06 增加交易完成时间查询条件-->
                        <td>完成时间：</td>
                        <td><g:textField name="startLastUpdated" value="${params.startLastUpdated}" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" style="width:80px" class="right_top_h2_input"/> --
                           <g:textField name="endLastUpdated" value="${params.endLastUpdated}" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" style="width:80px" class="right_top_h2_input"/> </td>
                    </tr>
                    <tr>
                        <td>时间范围：</td>
                        <td><g:textField name="startTime" value="${params.startTime}" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" style="width:80px" class="right_top_h2_input"/> --
                        <g:textField name="endTime" value="${params.endTime}" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" style="width:80px" class="right_top_h2_input"/> </td>
                        <td colspan="2" class="left">默认只检查30天的数据</td>

　　　　　　　　　　　　
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkDate()"/></td>
                        <td><g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/></td>
                        <td class="left">
                            <bo:hasPerm perm="${Perm.Gworder_Qry_Dl}">
                                <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()" />
                            </bo:hasPerm>
                        </td>
                    </tr>
                </g:form>
            </table>
        </div>


        <div class="right_list_tablebox">
            <table align="center" class="right_list_table" id="test">
                <tr>
                    <th>${message(code: 'gwOrder.id.label')}</th>
                    <th>${message(code: 'gwOrder.transactionId.label')}</th>
                    <th>${message(code: 'gwOrder.outTradeNo.label')}</th>
                    <th>${message(code: 'gwOrder.sellerCustomerNo.label')}</th>
                    <th>${message(code: '卖家名称',default:'卖家名称')}</th>
                    <th>${message(code: 'gwOrder.sellerCode.label')}</th>
                    <th>${message(code: 'gwOrder.buyerCode.label')}</th>
                    <th>${message(code: 'gwOrder.amount.label')}</th>
                    <th>${message(code: 'gwOrder.status.label')}</th>
                    <th>${message(code: '完成时间',default:'完成时间')}</th>
                    <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'gwOrder.dateCreated.label')}"/>
                    <th>相关查询</th>
                    <th>操作</th>
                </tr>

                <g:each in="${gwOrderList}" status="i" var="gwOrder">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td nowrap="nowrap">
                            <g:if test="${bo.hasPerm(perm:Perm.Gworder_Qry_View){true}}"><g:link action="show" id="${gwOrder.id}">${fieldValue(bean: gwOrder, field: "id")}</g:link></g:if>
                            <g:else>${fieldValue(bean: gwOrder, field: "id")}</g:else>
                        </td>
                        <td nowrap="nowrap">
                            <g:each in="${gwOrder.transactions}" status="j" var="trans">
                                ${j == 0 ? '' : ','}${trans.id}
                            </g:each>
                        </td>
                        <td nowrap="nowrap">
                            ${fieldValue(bean: gwOrder, field: "outTradeNo")}
                        </td>
                        <td nowrap="nowrap">${fieldValue(bean: gwOrder, field: "sellerCustomerNo")}</td>
                        <!--update 2012-06-05 sunweiguo -->
                        <td nowrap="nowrap">
                           ${CmCustomer.findByCustomerNo(gwOrder.sellerCustomerNo)?.name}
                        </td>
                        <td nowrap="nowrap">
                            ${fieldValue(bean: gwOrder, field: "sellerCode")}
                        </td>

                        <td nowrap="nowrap">
                            ${fieldValue(bean: gwOrder, field: "buyerCode")}
                        </td>

                        <td nowrap="nowrap"><g:formatNumber number="${gwOrder.amount/100}" type="currency" currencyCode="CNY"/></td>
                        <td nowrap="nowrap">${GwOrder.statusMap[gwOrder.status]}</td>
                        <td nowrap="nowrap"><g:formatDate date="${gwOrder.closeDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        <td nowrap="nowrap"><g:formatDate date="${gwOrder.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        <td nowrap="nowrap">
                            <g:link controller="gwTransaction" action="list" params="[orderId: gwOrder.id]">网关支付</g:link>
                            <g:if test="${gwOrder.royaltyType=='12'}">
                                |
                                <g:link controller="gwSubOrders" action="list" params="[gwordersid: gwOrder.id]">合单明细</g:link>
                            </g:if>
                            <g:if test="${gwOrder.status=='3'}">
                                |
                                <g:link controller="tradeBase" action="list" params="[tradeNo: gwOrder.id]">系统交易</g:link> |
                                <g:link controller="acSequential" action="list" params="[tradeNo: gwOrder.id]">账户流水</g:link>
                            </g:if>
                        </td>
                        <td>
                            <g:if test="${gwOrder.status =='0'}">
                                <input type="button" onclick="window.location.href = '${createLink(controller:'gwOrder', action:'close', params:['orderId':gwOrder?.id])}'" value="关闭"/>
                            </g:if>
                        </td>
                    </tr>
                </g:each>
            </table>
        </div>
        合计：订单金额总计：<g:formatNumber number="${totalAmount?totalAmount/100:0}" format="#.##"/>元
        <div class="paginateButtons">
            <span style=" float:left;">共${gwOrderTotal}条记录</span>
            <g:paginat total="${gwOrderTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
