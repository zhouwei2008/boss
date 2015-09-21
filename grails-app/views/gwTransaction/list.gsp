<%@ page import="boss.Perm; gateway.GwTransaction" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'gwTransaction.label', default: 'GwTransaction')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<script type="text/javascript">
    $(function() {
        $("#startTime").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endTime").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#startCompletionTime").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endCompletionTime").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
    });
    function checkDate() {
        var startDate = document.getElementById("startTime").value;
        var endDate = document.getElementById("endTime").value;
        if (startDate > endDate && endDate != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endTime").focus();
            return false;
        }

        var starTime = document.getElementById("startCompletionTime").value;
        var endTime = document.getElementById("endCompletionTime").value;
        if (startTime > endTime && endTime != '') {
            alert("开始时间不能大于结束时间！");
            document.getElementById("endCompletionTime").focus();
            return false;
        }

        if( endTime == '')
        {
            document.getElementById("endCompletionTime").focus();
            return false;
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
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <div class="table_serch">
            <table>
                <g:form>
                    <tr>
                        <td>${message(code: 'gwOrder.sellerCustomerNo.label')}：</td>
                        <td><g:textField name="customerNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.customerNo}" class="right_top_h2_input"/></td>
                        <td>${message(code: 'gwOrder.buyerCode.label')}：</td>
                        <td><p><g:textField name="buyerCode" onblur="value=value.replace(/[ ]/g,'')" value="${params.buyerCode}" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'gwTransaction.amount.label')}：</td>
                        <td><p><g:textField name="startAmount" value="${params.startAmount}" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" style="width:60px" class="right_top_h2_input"/>--<g:textField name="endAmount" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="${params.endAmount}" style="width:60px" class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td>${message(code: 'gwTransaction.id.label')}：</td>
                        <td><g:textField name="id" onblur="value=value.replace(/[ ]/g,'')" value="${params.id}" class="right_top_h2_input"/></td>
                        <td>${message(code: 'gwTransaction.orderId.label')}：</td>
                        <td><p><g:textField name="orderId" onblur="value=value.replace(/[ ]/g,'')" value="${params.orderId}" class="right_top_h2_input"/><p></td>
                        <td>${message(code: 'gwOrder.outTradeNo.label')}：</td>
                        <td><p><g:textField name="outTradeNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.outTradeNo}" class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td>${message(code: 'gwTransaction.acquirerCode.label')}：</td>
                        <td><g:textField name="acquirerCode" onblur="value=value.replace(/[ ]/g,'')" value="${params.acquirerCode}" class="right_top_h2_input"/></td>
                        <td>${message(code: 'gwTransaction.bankTransNo.label')}：</td>
                        <td><p><g:textField name="bankTransNo" value="${params.bankTransNo}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input"/><p></td>
                        <td>${message(code: 'gwTransaction.authNo.label')}：</td>
                        <td><p><g:textField name="authNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.authNo}" class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'gwTransaction.status.label')}：</td>
                        <td><p><g:select name="status" value="${params.status}" from="${GwTransaction.statusMap}" optionKey="key" optionValue="value" noSelection="${['':'-全部-']}" class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>

                        <!--update 2012-06-12 sunweiguo add 交易完成时间-->
                        <td>${message(code:'交易完成时间',default:'交易完成时间')}：</td>
                        <td><p><g:textField name="startCompletionTime" value="${params.startCompletionTime}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--
                        <g:textField name="endCompletionTime" value="${params.endCompletionTime}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/></p></td>

                        <td>时间范围：</td>
                        <td><g:textField name="startTime" value="${params.startTime}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/>--
                        <g:textField name="endTime" value="${params.endTime}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" class="right_top_h2_input"/></td>
                        <td colspan='2'class='left'>默认只检查30天的数据</td>

                        <td class='left'><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return checkDate()" />
                        <td class='left'><g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/></td>
                        <td class='left'>
                            <bo:hasPerm perm="${Perm.Gworder_Trans_Dl}">
                                <g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return checkDate()" />
                            </bo:hasPerm>
                        </td>
                    </tr>
                </g:form>
            </table>
        </div>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <th>${message(code: 'gwTransaction.id.label')}</th>
                <th>${message(code: 'gwTransaction.orderId.label')}</th>
                <th>${message(code: 'gwTransaction.bankTransNo.label')}</th>
                <th>${message(code: 'gwTransaction.acquirerName.label')}</th>
                <th>${message(code: 'gwTransaction.channel.label')}</th>
                <th>${message(code: 'gwTransaction.amount.label')}</th>
                <th>${message(code: 'gwTransaction.status.label')}</th>
                <th>${message(code: 'gwTransaction.dateCreated.label')}</th>
                <th>${message(code: 'gwTransaction.acquirerDate.label')}</th>
                <!--update sunweiguo 交易完成时间--><th>${message(code:'交易完成时间',default:'交易完成时间')}</th>
                <th>操作</th>
            </tr>

            <g:each in="${gwTransList}" status="i" var="gwTrans">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>
                        <g:if test="${bo.hasPerm(perm:Perm.Gworder_Trans_View){true}}"><g:link action="show" id="${gwTrans.id}">${fieldValue(bean: gwTrans, field: "id")}</g:link></g:if>
                        <g:else>${fieldValue(bean: gwTrans, field: "id")}</g:else>
                    </td>
                    <td>
                        <g:if test="${gwTrans.order}">
                            <g:if test="${bo.hasPerm(perm:Perm.Gworder_Trans_View){true}}"><g:link controller="gwOrder" action="show" id="${gwTrans.order.id}">${gwTrans.order.id}</g:link></g:if>
                            <g:else>${gwTrans.order.id}</g:else>
                        </g:if>
                    </td>
                    <td>
                        ${fieldValue(bean: gwTrans, field: "bankTransNo")}
                    </td>
                    <td>${fieldValue(bean: gwTrans, field: "acquirerName")}</td>
                    <td>${GwTransaction.channelMap[gwTrans.channel]}</td>
                    <td><g:formatNumber number="${gwTrans.amount/100}" type="currency" currencyCode="CNY"/></td>
                    <td>${GwTransaction.statusMap[gwTrans.status]}</td>
                    <td>
                        <g:formatDate date="${gwTrans.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/>
                    </td>
                    <td>
                        <g:formatDate date="${gwTrans.completionTime}" format="yyyy-MM-dd HH:mm:ss"/>
                    </td>
                    <td>
                        <g:formatDate date="${gwTrans.completionTime}" format="yyyy-MM-dd HH:mm:ss"/>
                    </td>
                    <td>
                        <g:if test="${gwTrans.status=='0'}"><!-- 等待支付 -->
                            <g:if test="${bo.hasPerm(perm:Perm.Gworder_Trans_Auto){true}}"><g:link action="autoCheck" id="${gwTrans.id}">自动核对</g:link> |</g:if>
                            <g:if test="${bo.hasPerm(perm:Perm.Gworder_Trans_Succ){true}}"><g:link action="editFinished" id="${gwTrans.id}">改成功</g:link> |</g:if>
                            <g:if test="${bo.hasPerm(perm:Perm.Gworder_Trans_Fail){true}}"><g:link action="toFailed" id="${gwTrans.id}" onclick="return confirm('你确定将这笔支付(${gwTrans.id})改成失败？')">改成失败</g:link></g:if>
                        </g:if>
                        <g:elseif test="${gwTrans.status=='1'}"><!-- 支付完成 -->
                        </g:elseif>
                        <g:elseif test="${gwTrans.status=='2'}"><!-- 支付失败 -->
                            <g:if test="${bo.hasPerm(perm:Perm.Gworder_Trans_Succ){true}}"><g:link action="editFinished" id="${gwTrans.id}">改成功</g:link></g:if>
                        </g:elseif>
                        <g:elseif test="${gwTrans.status=='3'}"><!-- 有效期内未付 -->
                            <g:if test="${bo.hasPerm(perm:Perm.Gworder_Trans_Succ){true}}"><g:link action="editFinished" id="${gwTrans.id}">改成功</g:link> |</g:if>
                            <g:if test="${bo.hasPerm(perm:Perm.Gworder_Trans_Fail){true}}"><g:link action="toFailed" id="${gwTrans.id}" onclick="return confirm('你确定将这笔支付(${gwTrans.id})改成失败？')">改失败</g:link></g:if>
                        </g:elseif>
                    </td>
                </tr>
            </g:each>
        </table>
        合计：支付金额总计：<g:formatNumber number="${totalAmount?totalAmount/100:0}" format="#.##"/>元
        <div class="paginateButtons">
            <span style=" float:left;">共${gwTransTotal}条记录</span>
            <g:paginat total="${gwTransTotal}" params="${params}"/>
        </div>

        <div class="paginateButtons">
            <span class="button"><input type="button" class="rigt_button" onclick="history.go(-1)" value="返回"/></span>
        </div>
    </div>
</div>
</body>
</html>
