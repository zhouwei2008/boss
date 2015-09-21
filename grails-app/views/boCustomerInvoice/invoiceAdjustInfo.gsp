<%--
  Created by IntelliJ IDEA.
  User: zhaoshuang
  Date: 12-2-15
  Time: 下午1:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <title>选择调账记录</title>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <div class="right_top">
    <table align="center" class="right_list_table" id="infoTable">
      <tr>

        <td><input type="checkbox" onclick="doCheck(this)" name="allChk"/>选择</td>

        <td style="display:none">调账记录ID</td>

        <g:sortableColumn params="${params}"  property="customer_no" title="调账账号"/>

        <g:sortableColumn params="${params}"  property="customer_name" title="调账对方账号"/>

        <g:sortableColumn params="${params}"  property="init_status" title="金额"/>

        <g:sortableColumn params="${params}"  property="init_date" title="调账日期"/>

        <g:sortableColumn params="${params}"  property="init_amount" title="备注"/>

      </tr>

      <g:each in="${listAdjust}" status="i" var="adjustInfo">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

          <td>
            <input type="checkbox" id="${i}" name="checkBoxes" <g:if test="${adjustInfo.choose_flag == 1}">checked="checked"</g:if> onclick="save(this.checked, ${adjustInfo.id})"/>
          </td>

          <td style="display:none"><input name="id" value="${adjustInfo.id}"/></td>

          <td>${adjustInfo.account_no}</td>

          <td>${adjustInfo.opp_acc_no}</td>

          <td><font <g:if test="${String.valueOf(adjustInfo.amt).indexOf('-') < 0}">color="green"</g:if><g:else>color="red"</g:else>>￥${adjustInfo.amt}</font></td>

          <td>${adjustInfo.sponsor_time}</td>

          <td>${adjustInfo.remark}</td>

        </tr>
      </g:each>
    </table>

    <div class="paginateButtons">
        <div align="left"><div style="position:absolute;">共${count}条记录</div></div>
      <g:paginat total="${count}" params="${params}"/>
    </div>
    <form id="submitForm" action="invoiceAdjustInfo">
        <h2>
            <input type="button" onclick="confirmClose()" value="确定" class="rigt_button">
            <input type="hidden" id="info" name="info" value="${params.info}"/>
            <input type="hidden" id="chkNos" name="chkNos" value="${params.chkNos}"/>
        </h2>
    </form>
  </div>
</div>
<script type="text/javascript">

    // 全选
    function doCheck(obj) {
        var ids = '';
        var node = '';
        var chooseFlag = 0;
        var boxs = document.getElementsByName("checkBoxes");
        var len = boxs.length;
        if (obj.checked) {
            chooseFlag = 1;
            for (i = 0;  i < len; i++) {
                document.getElementsByName("checkBoxes")[i].checked = true;
                var id = document.getElementsByName("id")[i].value;
                ids = ids + node + id;
                node = ',';
            }
        } else {
            for (i = 0;  i < len; i++) {
                document.getElementsByName("checkBoxes")[i].checked = false;
                var id = document.getElementsByName("id")[i].value;
                ids = ids + node + id;
                node = ',';
            }
        }
        save(chooseFlag, ids);
    }

    // 确定
    function confirmClose() {
        parent.adjWin.hide();
        parent.location.reload();
    }

    // 保存
    function save(chkStatus, ids) {

        var chooseFlag = 0;
        if (chkStatus) {
            chooseFlag = 1;
        }
        var baseUrl = "${createLink(controller:'boCustomerInvoice', action:'saveAdjustInfo')}";
        $.ajax({
            url: baseUrl,
            type: 'post',
            dataType: 'String',
            data:'ids='+ids+'&chooseFlag='+chooseFlag,
            success: function(result){
                if (result != "success") {
                    alert("选择调账记录失败！");
                }
            }
        });
    }
</script>
</body>
</html>