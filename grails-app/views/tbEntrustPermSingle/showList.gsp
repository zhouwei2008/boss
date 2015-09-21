<%@ page import="ismp.CmCustomer; boss.Perm; dsf.TbEntrustPerm" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'tbEntrustPerm.label', default: '代收授权账户查询')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<style>
/*字符串截取*/
.aa {
    width: 150px;
    height: 24px;
    line-height: 24px;
    overflow: hidden;
    margin: 0px;
    color: #666;
    display: block;
    padding-left: 100px
}

span {
    display: -moz-inline-box;
    display: inline-block;
}

</style>
<script type="text/javascript">
    $(function() {
        $("#entrustStarttimeS").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#entrustStarttimeE").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });
    $(function() {
        $("#entrustEndtimeS").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        $("#entrustEndtimeE").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });

    /**
     *校验授权日期的开始日期和结束日期
     */
    function checkDate() {

        var entrustStarttimeS = document.forms['showList'].entrustStarttimeS.value;
        var entrustStarttimeE = document.forms['showList'].entrustStarttimeE.value;

        if (entrustStarttimeS&&entrustStarttimeE&&entrustStarttimeS > entrustStarttimeE) {
            alert('授权开始时间不能大于授权结束时间!');
            document.forms['showList'].entrustStarttimeS.focus();
            return false;
        }
        var entrustEndtimeS = document.forms['showList'].entrustEndtimeS.value;
        var entrustEndtimeE = document.forms['showList'].entrustEndtimeE.value;
        if (entrustEndtimeS&&entrustEndtimeE&&entrustEndtimeS > entrustEndtimeE) {
            alert('截止开始时间不能大于截止结束时间!');
            document.forms['showList'].entrustEndtimeS.focus();
            return false;
        }
    }



     function empty() {
        $(':input') .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
     var showList = document.forms['showList'];

         showList.entrustIsEffectRadio[0].checked = true;
        // showList.entrustIsEffect.value = '0';
        return false;
    }

</script>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form name="showList" action="showList">

                <span>
                    开户名：<g:textField name="cardname" value="${params.cardname}" size="20" class="right_top_h2_input" style="width:150px"/>
                </span>
                <span>
                    开户行：<g:select name="accountname" from="${bankNameList}" optionKey="${1}" optionValue="${2}" value="${params.accountname}" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/>
                </span>
                <span>
                    开户账号：<g:textField name="cardnum" value="${params.cardnum}" size="10" class="right_top_h2_input" style="width:150px"/>
                </span>
                <span>
                    状态：<g:select name="entrustStatus" from="${TbEntrustPerm.entrustStatusMap}" optionKey="key" optionValue="value" value="${params.entrustStatus}" noSelection="${['':'-全部-']}" class="right_top_h2_input"/>
                </span>
                <span>
                    授权日期：<g:textField name="entrustStarttimeS" value="${params.entrustStarttimeS}" size="10" class="right_top_h2_input" style="width:100px"/>
                    到：<g:textField name="entrustStarttimeE" value="${params.entrustStarttimeE}" size="10" class="right_top_h2_input" style="width:100px"/>
                </span>
                <span>
                    账户类型：<g:select name="accounttype" from="${TbEntrustPerm.accounttypeMap}" optionKey="key" optionValue="value" value="${params.accounttype}" noSelection="${['':'-全部-']}" class="right_top_h2_input"/>
                </span>
                <span>
                    是否生效：
                    <g:if test="${params.entrustIsEffect=='0'||params.entrustIsEffect==null||params.entrustIsEffect==''}">
                    <g:radio value="0" name="entrustIsEffectRadio"  checked="true" />是
                    <g:radio value="1" name="entrustIsEffectRadio" />否
                    </g:if>
                    <g:if test="${params.entrustIsEffect=='1'}">
                    <g:radio value="0" name="entrustIsEffectRadio" />是
                    <g:radio value="1" name="entrustIsEffectRadio" checked="true"/>否
                    </g:if>
                </span>
                <span>
                    截止日期：<g:textField name="entrustEndtimeS" value="${params.entrustEndtimeS}" size="10" class="right_top_h2_input" style="width:100px"/>
                    到：<g:textField name="entrustEndtimeE" value="${params.entrustEndtimeE}" size="10" class="right_top_h2_input" style="width:100px"/>
                </span>
                <span>
                    所属商户编号：<g:textField name="customerNo" value="${params.customerNo}" size="20" class="right_top_h2_input" style="width:150px" onblur="showCustomerName(this)"/>
                </span>
                <span>
                    所属商户名称：<g:textField name="customerName" value="${params.customerName}" size="20" class="right_top_h2_input" style="width:150px" readonly="true" disabled="true"/>
                </span>

                <span>
                    <input type="submit" class="right_top_h2_button_serch" value="查询" onclick="return checkQuery();">
                    <g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/>
                    <bo:hasPerm perm="${Perm.Agent_EntrustPermAdmin_Download}"><g:actionSubmit class="right_top_h2_button_download" action="downloadTbEntrustPerm" onclick="return checkDate()" value="下载"/></bo:hasPerm>
                </span>
                  <g:hiddenField name="entrustIsEffect" value=""/>
                <g:hiddenField name="delID" value=""/>
                <g:hiddenField name="delCustomerNo" value=""/>
                <g:hiddenField name="delOffset" value="${params.offset}"/>
            </g:form>
        </h2>
        <div class="right_list_tablebox" style="height: 380px">
            <table align="center" class="right_list_table" id="test">
                <tr>
                    <td nowrap="nowrap">序号</td>
                    <g:sortableColumn params="${params}" property="cardname" title="${message(code: 'tbEntrustPerm.cardname.label', default: 'TbEntrustPerm cardname')}"/>
                    <g:sortableColumn params="${params}" property="accountname" title="${message(code: 'tbEntrustPerm.accountname.label', default: 'TbEntrustPerm accountname')}"/>
                    <g:sortableColumn params="${params}" property="cardnum" title="${message(code: 'tbEntrustPerm.cardnum.label', default: 'tbEntrustPerm cardnum')}"/>
                    <g:sortableColumn params="${params}" property="accounttype" title="${message(code: 'tbEntrustPerm.accounttype.label', default: 'tbEntrustPerm accounttype')}"/>
                    <g:sortableColumn params="${params}" property="entrustStarttime" title="${message(code: 'tbEntrustPerm.entrustStarttime.label', default: 'tbEntrustPerm entrustStarttime')}"/>

                    <g:sortableColumn params="${params}" property="entrustEndtime" title="${message(code: 'tbEntrustPerm.entrustEndtime.label', default: 'tbEntrustPerm entrustEndtime')}"/>
                    <g:sortableColumn params="${params}" property="entrustUsercode" title="${message(code: 'tbEntrustPerm.entrustUsercode.label', default: 'tbEntrustPerm entrustUsercode')}"/>

                    <g:sortableColumn params="${params}" property="certificateType" title="${message(code: 'tbEntrustPerm.certificateType.label', default: 'tbEntrustPerm certificateType')}"/>
                    <g:sortableColumn params="${params}" property="certificateNum" title="${message(code: 'tbEntrustPerm.certificateNum.label', default: 'tbEntrustPerm certificateNum')}"/>
                    <g:sortableColumn params="${params}" property="customerNo" title="${message(code: 'tbEntrustPerm.customerNoForCreate.label', default: 'tbEntrustPerm customerNo')}"/>
                    <td nowrap="nowrap">客户名称</td>

                    <g:sortableColumn params="${params}" property="entrustStatus" title="${message(code: 'tbEntrustPerm.entrustStatus.label', default: 'tbEntrustPerm entrustStatus')}"/>
                    <g:sortableColumn params="${params}" property="entrustIsEffect" title="${message(code: 'tbEntrustPerm.entrustIsEffect.label', default: 'tbEntrustPerm entrustIsEffect')}"/>
                    <td nowrap="nowrap" colspan="2">操作</td>
                </tr>

                <g:each in="${tbEntrustPermList}" status="i" var="tbEntrustPerm">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td nowrap="nowrap">${i+1}</td>
                        <td nowrap="nowrap">${tbEntrustPerm?.cardname}</td>
                        <td nowrap="nowrap">${tbEntrustPerm?.accountname}</td>
                        <td nowrap="nowrap">${tbEntrustPerm.cardnum.length()>8?(tbEntrustPerm.cardnum.substring(0,8)+"****"+(tbEntrustPerm.cardnum.length()>12?tbEntrustPerm.cardnum.substring(12,tbEntrustPerm.cardnum.length()):"")):tbEntrustPerm.cardnum}</td>
                        <td nowrap="nowrap">${TbEntrustPerm.accounttypeMap[tbEntrustPerm.accounttype]}</td>
                        <td nowrap="nowrap"><g:formatDate date="${tbEntrustPerm.entrustStarttime}" format="yyyy-MM-dd"/></td>
                        <td nowrap="nowrap"><g:formatDate date="${tbEntrustPerm.entrustEndtime}" format="yyyy-MM-dd"/></td>
                        <td nowrap="nowrap">${tbEntrustPerm?.entrustUsercode}</td>
                        <td nowrap="nowrap">${TbEntrustPerm.certificateTypeMap[tbEntrustPerm.certificateType]}</td>
                        <td nowrap="nowrap">${tbEntrustPerm.certificateNum.length()>6?(tbEntrustPerm.certificateNum.substring(0,6)+"****"+(tbEntrustPerm.certificateNum.length()>10?tbEntrustPerm.certificateNum.substring(10,tbEntrustPerm.certificateNum.length()):"")):tbEntrustPerm.certificateNum}</td>
                        <td nowrap="nowrap">${tbEntrustPerm?.customerNo}</td>
                        <td nowrap="nowrap">${CmCustomer.findByCustomerNo(tbEntrustPerm?.customerNo)?.name}</td>
                        <td nowrap="nowrap">${TbEntrustPerm.entrustStatusMap[tbEntrustPerm.entrustStatus]}</td>
                        <td nowrap="nowrap">${TbEntrustPerm.entrustIsEffectMap[tbEntrustPerm.entrustIsEffect]}</td>
                        <td nowrap="nowrap"><bo:hasPerm perm="${Perm.Agent_EntrustPermAdmin_Modify}"><g:link action="updateItem" params="[tbEntrustPermId:tbEntrustPerm.id,params:params]">修改</g:link></bo:hasPerm></td>
                        %{--<td nowrap="nowrap"><bo:hasPerm perm="${Perm.Agent_EntrustPermAdmin_delete}"><g:link action="deleteItem" params="[tbEntrustPermId:tbEntrustPerm.id,customerNo:tbEntrustPerm.customerNo]" onclick="return confirm('确认删除？')" >删除</g:link></bo:hasPerm></td>--}%
                        %{--<td nowrap="nowrap"><bo:hasPerm perm="${Perm.Agent_EntrustPermAdmin_delete}"><g:link action="deleteItem" onclick="delPerm('${tbEntrustPerm.id}')" >删除</g:link></bo:hasPerm></td>--}%
                        <td nowrap="nowrap"><bo:hasPerm perm="${Perm.Agent_EntrustPermAdmin_delete}"><a href="#" onclick="delPerm('${tbEntrustPerm.id}','${tbEntrustPerm.customerNo}')" >删除</a></bo:hasPerm></td>

                    </tr>
                </g:each>
            </table>
        </div>
        <div class="paginateButtons">
            <span class="left">共${tbEntrustPermTotal}条记录</span>
            <g:paginat total="${tbEntrustPermTotal}" params="${params}"/>
        </div>


    </div>
</div>
 <script type="text/javascript">
      var customerNo = document.forms['showList'].customerNo.value;
        if (customerNo) {
          $.getJSON('${createLink(action:'getCustomerInfo')}', {customerNo: customerNo}, function(data) {
              document.forms['showList'].customerName.value = data.customerName;
          })
        }
     //获取用户信息
    function showCustomerName(obj) {
        var customerNo = obj.value;
        if (customerNo) {
            $.getJSON('${createLink(action:'getCustomerInfo')}', {customerNo: customerNo}, function(data) {
                //$('#customerNameShow').html("<font color='blue'>&nbsp;" + data.customerName + "</font>");
                document.forms['showList'].customerName.value = data.customerName;
            })
        }
    }
function checkQuery() {
       var showList = document.forms['showList'];
           if(showList.entrustIsEffectRadio[1].checked){
            showList.entrustIsEffectRadio[1].checked = true;
            showList.entrustIsEffect.value = '1';
         }else{

            showList.entrustIsEffectRadio[0].checked = true;
            showList.entrustIsEffect.value = '0';
         }
        return checkDate();
    }


    function delPerm(delID,delCustomerNo){
            if(!confirm('确认删除？')){
              return false;
            }
        var showList = document.forms['showList'];
           if(showList.entrustIsEffectRadio[1].checked){
            showList.entrustIsEffectRadio[1].checked = true;
            showList.entrustIsEffect.value = '1';
         }else{

            showList.entrustIsEffectRadio[0].checked = true;
            showList.entrustIsEffect.value = '0';
         }
            var frm = document.forms['showList'];
            frm.delID.value = delID;
            frm.delCustomerNo.value =delCustomerNo;
            frm.action="deleteItem";
            frm.method="post";
            frm.submit();
        }

 </script>
</body>

</html>


