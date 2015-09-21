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
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">支付通道设置</h1>
        <h2>
            <label><input id="checkAll" type="checkbox" onclick="ckAll()" value="全选"/> 全选</label><label><input id="checkB2CAll" type="checkbox" onclick="SelectB2CAll()" value="全选"/> B2C通道全选</label>        <label><input id="checkB2BAll" type="checkbox" onclick="SelectCAll()" value="全选"/> 信用通道全选</label>  <label><input id="checkCAll" type="checkbox" onclick="SelectB2BAll()" value="全选"/> B2B通道全选</label>
        </h2>
        <g:form action="updateChannelLs" onsubmit="return checkMoney()" >
            <g:hiddenField name="id" value="${params.id}"/>
            <table align="center" class="right_list_table" id="banks">
                <tr>
                    <!--<th>分配</th> -->
                    <th>序号</th>
                    <th>银行</th>
                    <th>B2C借记通道</th>
                    <th>B2C贷记通道</th>
                    <th>B2B通道</th>
                </tr>

                <g:each in="${BoBankDic.findAll()}" status="i" var="bank">
                     <% int n=0;String str;%>
                     <g:each in="${b2cchannellist}" status="j" var="b2c">
                         <g:if test="${b2c.bankid==bank.id}">
                               <% n=n+1;str =b2c.acquire_indexc %>
                         </g:if>
                     </g:each>
                     <% int s=0;String s2%>
                         <g:each in="${cchannellist}" status="t" var="c">
                             <g:if test="${c.bankid==bank.id}">
                                <% s=s+1;s2=c.acquire_indexc%>
                              </g:if>
                         </g:each>
                     <% int m=0;String s1;%>
                       <g:each in="${b2bchannellist}" status="j" var="b2b">
                         <g:if test="${b2b.bankid==bank.id}">
                             <% m=m+1;s1=b2b.acquire_indexc %>
                         </g:if>
                       </g:each>
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td>${i+1}</td>
                        <td style="text-align:left">${bank?.name}</td>
                            <td>
                                 <g:if test="${n==0}">
                                     - -
                                </g:if>
                                <g:else>
                                     <input type="checkbox" name="b2cbank"value="${str}" <g:each in="${cmChannelList}" status="o" var="channel"> <g:if test="${channel.channelCode.toUpperCase()==str.toUpperCase()&&channel.channelType=='1'&&channel.paymentType=='1'}">  checked="checked"  </g:if> </g:each>/>
                                </g:else>
                            </td>
                            <td>
                                    <g:if test="${s==0}">
                                            - -
                                    </g:if>
                                    <g:else>
                                          <input type="checkbox" name="cbank" value="${s2}" <g:each in="${cmChannelList}" status="o" var="channel"> <g:if test="${channel.channelCode.toUpperCase()==s2.toUpperCase()&&channel.channelType=='2'&&channel.paymentType=='2'}">checked="checked"</g:if></g:each> />
                                    </g:else>
                            </td>
                            <td>
                                  <g:if test="${m==0}">
                                             - -
                                    </g:if>
                                  <g:else>
                                      <input type="checkbox" name="b2bbank" value="${s1}" <g:each in="${cmChannelList}" status="o" var="channel">  <g:if test="${channel.channelCode.toUpperCase()==s1.toUpperCase()&&channel.channelType=='3'&&channel.paymentType=='1'}">  checked="checked" </g:if> </g:each> />
                                  </g:else>
                            </td>
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



//复选框全选、反选效果


    function ckAll() {
                SelectB2CAll();
         SelectB2BAll();
         SelectCAll();
    }

    function SelectB2CAll() {
     var name = document.getElementById("checkB2CAll").value;
        var len = document.getElementsByName("b2cbank").length;
        if (name == "全选") {
            for (i = 0; i < len; i++) {
                document.getElementsByName("b2cbank")[i].checked = true;
                document.getElementById("checkB2CAll").value = "反选";
            }
        } else {
            for (i = 0; i < len; i++) {
                document.getElementsByName("b2cbank")[i].checked = false;
                document.getElementById("checkB2CAll").value = "全选";
            }
        }
    }
     function SelectB2BAll() {
      var name = document.getElementById("checkB2BAll").value;
        var len = document.getElementsByName("b2bbank").length;
        if (name == "全选") {
            for (i = 0; i < len; i++) {
                document.getElementsByName("b2bbank")[i].checked = true;
                document.getElementById("checkB2BAll").value = "反选";
            }
        } else {
            for (i = 0; i < len; i++) {
                document.getElementsByName("b2bbank")[i].checked = false;
                document.getElementById("checkB2BAll").value = "全选";
            }
        }
    }
     function SelectCAll() {
        var name = document.getElementById("checkCAll").value;
        var len = document.getElementsByName("cbank").length;
        if (name == "全选") {
            for (i = 0; i < len; i++) {
                document.getElementsByName("cbank")[i].checked = true;
                document.getElementById("checkCAll").value = "反选";
            }
        } else {
            for (i = 0; i < len; i++) {
                document.getElementsByName("cbank")[i].checked = false;
                document.getElementById("checkCAll").value = "全选";
            }
        }
    }

</script>
</body>
</html>
