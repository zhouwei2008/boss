<%--
  Created by IntelliJ IDEA.
  User: zhaoshuang
  Date: 12-1-13
  Time: 上午10:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="boss.Perm" %>
<%@ page import="boss.BoCustomerInvoiceInit" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <title>发票初始化信息</title>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">客户发票初始化列表</h1>
    <form id="submitForm" action="invoiceInitShow">
    <h2>
        客户号：<g:textField id="customerNo" name="customerNo" onfocus="this.select();" onblur="value=value.replace(/[ ]/g,'').replace(/\'/g,  '');" value="${params.customerNo}" class="right_top_h2_input" style="width:140px" maxlength="24"/>
        客户名称：<g:textField id="customerName" name="customerName" onfocus="this.select();" onblur="value=value.replace(/[ ]/g,'').replace(/\'/g,  '');" value="${params.customerName}" class="right_top_h2_input" style="width:140px" maxlength="32"/>
        启用状态：<g:select name="status" from="${BoCustomerInvoiceInit.statusSelect}" optionKey="key" optionValue="value" value="${params.status}" class="right_top_h2_input"/>
          <input type="submit" class="right_top_h2_button_serch" value="查询"/>
    </h2>
    <h2>
        填充启用日期：<g:textField name="startTime" value="${params.startTime}" onblur="value=value.replace(/[ ]/g,'')" size="10" class="right_top_h2_input" style="width:80px"/>
        <input type="button" onclick="fillDate()" value="填充" class="rigt_button">
        <bo:hasPerm perm="${Perm.WithDraw_InV_InitSave}"><input type="button" onclick="save(false)" value="保存" class="rigt_button"></bo:hasPerm>
        <bo:hasPerm perm="${Perm.WithDraw_InV_InitStart}"><input type="button" onclick="save(true)" value="启用" class="rigt_button"></bo:hasPerm>
        <input type="hidden" id="info" name="info" value="${params.info}"/>
        <input type="hidden" id="saveFlag" name="saveFlag" value="${params.saveFlag}"/>
        <input type="hidden" id="chkNos" name="chkNos" value="${params.chkNos}"/>
    </h2>
    </form>
    <table align="center" class="right_list_table" id="infoTable">
      <tr>

        <td><input type="checkbox" onclick="doCheck(this)" name="allChk"/>选择</td>

        <td style="display:none">客户ID</td>

        <g:sortableColumn params="${params}"  property="customer_no" title="客户号"/>

        <g:sortableColumn params="${params}"  property="customer_name" title="客户名称"/>

        <g:sortableColumn params="${params}"  property="init_status" title="启用状态"/>

        <g:sortableColumn params="${params}"  property="init_date" title="启用日期"/>

        <g:sortableColumn params="${params}"  property="init_amount" title="初始金额"/>

        <td style="display:none">上次开票日期</td>

      </tr>

      <g:each in="${listCm}" status="i" var="initInfo">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

          <td>
              <g:if test="${initInfo.status == '0'}">
                  <input type="checkbox" id="${i}" name="checkBoxes" <g:if test="${(String.valueOf(params.chkNos)).indexOf(String.valueOf(initInfo.customer_no)) > -1}">checked="checked"</g:if>/>
              </g:if>
              <g:else>
                  <span style="display:none">
                      <input type="checkbox" id="${i}" name="checkBoxes"/>
                  </span>
              </g:else>
          </td>

          <td style="display:none"><input name="cmIds" value="${initInfo.customer_id}"/></td>

          <td><input type="hidden" name="customer_no" value="${initInfo.customer_no}"/>${initInfo.customer_no}</td>

          <td>${initInfo.customer_name}</td>

          <td>${BoCustomerInvoiceInit.statusMap[initInfo.status]}</td>

          <td name="times">
              <g:if test="${initInfo.status == '0'}">
                  <g:textField id="startTimes${i}" name="startTimes" value="${initInfo.init_date}" onchange="onChk(${i});" onblur="value=value.replace(/[ ]/g,'')" size="10" class="right_top_h2_input" style="width:80px"/>
                    <script type="text/javascript">
                        $(function() {
                            $("#startTimes${i}").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
                        });
                    </script>
              </g:if>
              <g:else>
                  <input type="hidden" name="startTimes" value="${initInfo.init_date}"/>
                  <span style="color:#ff0000">${initInfo.init_date}</span>
              </g:else>
          </td>

          <td>
              <g:if test="${initInfo.status == '0'}">
                  ￥<input name="amount" value="${initInfo.init_amount}" style="width:100px" onpropertychange="onChk(${i});" oninput="onChk(${i});" onfocus="this.select();" onblur="chkAmount(value, ${i});" onkeyup="value=value.replace(/[^\d^.^]/g, '')" onbeforepaste="clipboardData.setData( 'text',clipboardData.getData('text').replace(/[^\d.^]/g, ''))" maxlength="13"/>
              </g:if>
              <g:else>
                  <input type="hidden" name="amount" value="${initInfo.init_amount}"/>
                  <span style="color:#ff0000">￥${initInfo.init_amount}</span>
              </g:else>
          </td>

          <td style="display:none">${initInfo.init_date}</td>

        </tr>
      </g:each>
    </table>

    <div class="paginateButtons">
        <div align="left"><div style="position:absolute;">共${count}条记录</div></div>
      <g:paginat total="${count}" params="${params}"/>
    </div>
  </div>
</div>
<script type="text/javascript">

    // 页面初始化
    $(function() {
        document.getElementById("customerNo").focus();
        $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
    });

    // 全选
    function doCheck(obj) {
        var boxs = document.getElementsByName("checkBoxes");
        var len = boxs.length;
        if (obj.checked) {
            for (i = 0;  i < len; i++) {
                 document.getElementsByName("checkBoxes")[i].checked = true;
            }
        } else {
            for (i = 0;  i < len; i++) {
                 document.getElementsByName("checkBoxes")[i].checked = false;
            }
        }
    }

    // 选择联动
    function onChk(i) {
        document.getElementsByName("checkBoxes")[i].checked = true;
    }

    // 填充
    function fillDate() {
        var startDate = document.getElementById("startTime").value;
        if ((startDate == null) || (startDate == "")) {
            alert("请输入填充时间");
            document.getElementById("startTime").focus();
        } else {
            var times = document.getElementsByName("startTimes");
            var len = times.length;
            for (i = 0;  i < len; i++) {
                 document.getElementsByName("startTimes")[i].value = startDate;
                 document.getElementsByName("checkBoxes")[i].checked = true;
                 document.getElementsByName("allChk")[0].checked = true;
            }
        }
    }

    // 金额校验
    function chkAmount(num, i) {
        var numVal = num;
        if (numVal == '') {
            document.getElementsByName("amount")[i].value = '0.00';
        } else {
            numVal = numVal.replace(/[^\d^.^]/g, '');
            var resutl = (parseFloat(numVal)).toFixed(2);
            if (resutl == "NaN") {
                alert("金额格式错误，请重新输入");
                document.getElementsByName("amount")[i].focus();
                document.getElementsByName("amount")[i].select();
                return false;
            } else {
                document.getElementsByName("amount")[i].value = resutl;
                return true;
            }
        }
    }

    // 保存 启用
    function save(flag) {
        var permInfo = "";
        var chkNos = "";
        var node = "";
        var nodeNo = "";
        var chkInfo = document.getElementsByName("checkBoxes");
        var len = chkInfo.length;
        for (i = 0;  i < len; i++) {
            if (document.getElementsByName("checkBoxes")[i].checked) {
                var cmId = document.getElementsByName("cmIds")[i].value;
                var cmNo = document.getElementsByName("customer_no")[i].value;
                var startTime = document.getElementsByName("startTimes")[i].value;
                var amount = document.getElementsByName("amount")[i].value;
                if ((startTime == null) || (startTime == "")) {
                    alert("请输入启动时间");
                    document.getElementsByName("startTimes")[i].focus();
                    return;
                } else if ((amount == null) || (amount == "")) {
                    alert("请输入初始金额");
                    document.getElementsByName("amount")[i].focus();
                    return;
                } else if (!chkAmount(amount, i)) {
                    return;
                } else if (amount > 9999999999.99) {
                    alert("初始金额过大，请重新输入");
                    document.getElementsByName("amount")[i].focus();
                    document.getElementsByName("amount")[i].select();
                    return;
                } else {
                    permInfo = permInfo + node + cmId + "thisIsASubLine" + startTime + "thisIsASubLine" + amount;
                    chkNos = chkNos + nodeNo + cmNo;
                    node = "thisIsALine";
                    nodeNo = ","
                }
            }
        }
        if (permInfo == "") {
            alert("请选择需要更改的数据");
        } else {
            if (flag) {
                if (confirm('启用后客户发票信息将不可再编辑，确定要启用吗？')) {
                    var submitForm = document.getElementById("submitForm");
                    document.getElementById("info").value = permInfo;
                    document.getElementById("saveFlag").value = "1";
                    document.getElementById("chkNos").value = chkNos;
                    submitForm.action = "invoiceInitSave";
                    submitForm.submit();
                }
            } else {
                    var submitForm = document.getElementById("submitForm");
                    document.getElementById("info").value = permInfo;
                    document.getElementById("saveFlag").value = "0";
                    document.getElementById("chkNos").value = chkNos;
                    submitForm.action = "invoiceInitSave";
                    submitForm.submit();
            }
        }
    }
</script>
</body>
</html>