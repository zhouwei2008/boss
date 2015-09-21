<%@ page import="boss.BoAcquirerAccount; boss.BoMerchant; boss.BoBankDic; ismp.CmCorporationInfo; boss.BoCustomerService" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boCustomerService.label', default: 'BoCustomerService')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">大额通道设置</h1>
        <h2>
            <label><input id="checkAll" type="checkbox" onclick="$('#banks').find('input[type=\'checkbox\']').each(function(i, elem) {
                $(elem).attr('checked', $('#checkAll').attr('checked'))
            })"/> 全选</label>
        </h2>
        <g:form action="updateBankLs" onsubmit="return checkMoney()" >
            <g:hiddenField name="id" value="${params.id}"/>
            <table align="center" class="right_list_table" id="banks">
                <tr>
                    <th>分配</th>
                    <th>银行</th>
                    <th>通道</th>
                    <th>额度(元)</th>
                </tr>

            %{--<g:each in="${BoBankDic.list()}" status="i" var="bank">--}%
            %{--<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">--}%
            %{--<td><input type="checkbox" name="bank" value="${bank.id}" <% if (bankList.any {it.bank.id == bank.id}) {out << 'checked'} %>/></td>--}%
            %{--<td>${bank.name}</td>--}%
            %{--<td><input type="text" name="quota_${bank.id}" value="<% out << bankList.find {it.bank.id == bank.id}?.quota %>"/></td>--}%
            %{--</tr>--}%
            %{--</g:each>--}%
                <g:each in="${BoMerchant.findAllByBankTypeAndChannelSts('2','0')}" status="i" var="bank">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td><input type="checkbox" name="bank" value="${bank.id}" <% if (bankList.any {it.bank.id == bank.id}) {out << 'checked'} %>/></td>
                        <td>${boss.BoBankDic.get(BoAcquirerAccount.get(bank.acquirerAccount?.id).bank?.id)?.name}</td>
                        <td>${bank.acquireMerchant}(${bank.acquireName})</td>
                        <td><input type="text" maxlength="8" onblur="value=value.replace(/[ ]/g,'')" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" name="quota_${bank.id}" id="xxx_${i}" value="<% if (bankList.find {it.bank.id == bank.id}?.quota!=null) {out << bankList.find {it.bank.id == bank.id}?.quota/100} %>"/></td>
                    </tr>
                </g:each>
            </table>
            <div class="paginateButtons">
                <span class="button">
                    <span class="button"><input type="submit" class="rigt_button" value="确定"/></span>
                    <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
                </span>
            </div>
        </g:form>
    </div>
</div>
<script type="text/javascript">
    function checkMoney(){
        var flag=1;
        for(i=0;i<document.getElementsByName("bank").length;i++){
            if(document.getElementsByName("bank")[i].checked){
                if(document.getElementById("xxx_"+i).value==""){
                    document.getElementById("xxx_"+i).focus();
                    flag=0;
                }
            }
        }
        if(flag==0){
             alert("请输入金额！");
             return false;
        }
        return true;
    }
</script>
</body>
</html>
