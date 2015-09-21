<%@ page import="boss.Perm;boss.BoVerify" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'boVerify.label', default: 'BoVerify')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <link rel="stylesheet" type="text/css" href="../ext/css/ext-all.css"/>
    <link rel="stylesheet" type="text/css" href="../ext/css/style.css"/>
    <script type="text/javascript" src="../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../ext/js/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../ext/js/common.js"></script>
    <script type="text/javascript">
        function OpenDiv(str) {
//            var win1 = window.showModalDialog("editRea.gsp");
            var url = 'editRea.gsp?id=' + str;
            win1 = new Ext.Window({
                id:'win1',
                title:"拒绝原因",
                width:400,
                modal:true,
                height:300,
                html: '<iframe src=' + url + ' height="100%" width="100%" name="userlist" scrolling="auto" frameborder="0" onLoad="Ext.MessageBox.hide();">',
                maximizable:true
            });
            win1.show();
        }
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
                alert('开始时间不能大于结束时间!');
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
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="充提转审核" args="[entityName]"/></h1>
        <div class="table_serch">
            <table>
            <g:form action="list" name="list">
                <tr>
                    <td><g:message code="类型"/>：</td><td><p><g:select name="type" value="${params.type}" from="${BoVerify.typeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/></p></td>
                    <td><g:message code="转入银行帐户"/>：</td><td><g:textField name="inBankAccountNo" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" onblur="value=value.replace(/[ ]/g,'')" value="${params.inBankAccountNo}" class="right_top_h2_input" style="width:120px"/>    </td>
                    <td><g:message code="转出银行帐户"/>：</td><td><g:textField name="outBankAccountNo" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" onblur="value=value.replace(/[ ]/g,'')" value="${params.outBankAccountNo}" class="right_top_h2_input" style="width:120px"/>    </td>
                </tr>
                <tr>
                    <td><g:message code="创建时间"/>：</td><td><g:textField name="startDateCreated" value="${params.startDateCreated}" onblur="value=value.replace(/[ ]/g,'')" onchange="checkDate()" class="right_top_h2_input" style="width:80px"/>--<g:textField name="endDateCreated" value="${params.endDateCreated}" onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input" style="width:80px"/></td>
                    <td><g:message code="操作员"/>：</td><td><g:textField name="operName" value="${params.operName}" onblur="value=value.replace(/[ ]/g,'')" class="right_top_h2_input" style="width:120px"/></td>
                    <td><input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkDate()"></td>
                    <td><g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/></td>
                </tr>
            </table>
        </div>
            <table align="center" class="right_list_table" id="test">
                <tr>

                    <g:sortableColumn params="${params}" property="dateCreated" title="${message(code: 'boVerify.dateCreated.label', default: '创建日期')}"/>

                    <g:sortableColumn params="${params}" property="type" title="${message(code: 'boVerify.type.label', default: '类型')}"/>


                    <g:sortableColumn params="${params}" property="inBankName" title="${message(code: 'boVerify.inBankName.label', default: '转入银行名称')}"/>

                    <g:sortableColumn params="${params}" property="outBankName" title="${message(code: 'boVerify.outBankName.label', default: '转出银行名称')}"/>

                    <g:sortableColumn params="${params}" property="outAmount" title="${message(code: 'boVerify.outBankName.label', default: '金额')}"/>

                    <g:sortableColumn params="${params}" property="operate" title="${message(code: 'boVerify.outBankName.label', default: '操作')}"/>

                </tr>

                <g:each in="${boVerifyInstanceList}" status="i" var="boVerifyInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td><g:formatDate date="${boVerifyInstance.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>
                            ${BoVerify.typeMap[boVerifyInstance.type]}
                        </td>
                        <td>${fieldValue(bean: boVerifyInstance, field: "inBankName")}</td>
                        <td>${fieldValue(bean: boVerifyInstance, field: "outBankName")}</td>
                        <td>
                            <g:set var="amt" value="${boVerifyInstance.outAmount ? boVerifyInstance.outAmount : 0}"/>
                            <g:formatNumber number="${amt/100}" type="currency" currencyCode="CNY"/>
                        </td>
                        <td>
                            <bo:hasPerm perm="${Perm.Bank_TransChk_View}"><g:link action="show" id="${boVerifyInstance.id}">详细</g:link> |</bo:hasPerm>
                            <bo:hasPerm perm="${Perm.Bank_TransChk_Pass}"><g:link action="dispartchImpl" id="${boVerifyInstance.id}">通过</g:link> |</bo:hasPerm>
                            <bo:hasPerm perm="${Perm.Bank_TransChk_Ref}"><g:link onclick="return appPass(${boVerifyInstance.id})" id="${boVerifyInstance.id}">拒绝</g:link></bo:hasPerm>
                        %{--<g:link onClick="OpenDiv()" id="${boVerifyInstance.id}">拒绝1</g:link>--}%
                        %{--<a onclick="OpenDiv(${boVerifyInstance.id})">拒绝2</a>--}%
                        </td>
                    </tr>

                </g:each>
                <tr style="display:none" id="reason">
                    <td colspan="6">
                        <div id="messages" align="left">
                            <font color="red">拒绝原因：</font> <input type="text" name="note" size="200" style="width:400px" id="note" onfocus="value = ''" value="请输入拒绝原因"/>
                            <span><input type="button" name="button" value="确定" onclick="checkReason()"/></span>
                        </div>
                    </td>
                </tr>
            </table>
        </g:form>
        合计：金额总计：<g:formatNumber number="${totalAmount?totalAmount/100:0}" format="#.##"/>元
        <div class="paginateButtons">
            <span style=" float:left;">共${boVerifyInstanceTotal}条记录</span>
            <g:paginat total="${boVerifyInstanceTotal}" params="${params}"/>
        </div>

    </div>
</div>
<script type="text/javascript">
    var id;
    function appPass(str) {
        document.getElementById("reason").style.display = '';
        id = str;
        return false;
    }
    function checkReason() {
        if (document.getElementById("note").value == '请输入拒绝原因' || document.getElementById("note").value == '') {
            alert("请输入拒绝原因!");
        } else {
            var reason = document.getElementById("note").value;
            window.location.href = '${createLink(controller:'boVerify', action:'refuse', params:['statusFlag':'1'])}&id=' + id + '&appNote=' + reason;
        }
    }
    $(function() {
        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeMonth: true,changeYear:true });
        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd', changeMonth: true,changeYear:true });
    });
</script>
</body>
</html>
