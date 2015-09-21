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
<% response.setHeader("Pragma", "No-cache");
 response.setHeader("Cache-Control", "no-cache");
 response.setDateHeader("Expires", 0); %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <link rel="stylesheet" type="text/css" href="../ext/css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="../ext/css/style.css" />
    <script type="text/javascript" src="../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../ext/js/ext-lang-zh_CN.js"></script>
    <title>待开发票信息</title>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">待开发票信息列表</h1>
    <form id="submitForm" action="invoiceOutstandingShow">
    <h2>
        费用日期：<g:select name="dateFlag" from="${BoCustomerInvoiceInit.dateSelect}" onchange="dateChange1()" optionKey="key" optionValue="value" value="${params.dateFlag}" class="right_top_h2_input"/>
        <g:textField name="startTime" value="${params.startTime}" onchange="dateChange2()" onfocus="this.select();" onblur="value=value.replace(/[ ]/g,'')" size="10" class="right_top_h2_input" style="width:80px"/>
        金额下限：<input id="minAmount" name="minAmount" value="${params.minAmount}" onfocus="this.select();" onblur="chkAmount(value);" onkeyup="value=value.replace(/[^\d^.^]/g, '')" onbeforepaste="clipboardData.setData( 'text',clipboardData.getData('text').replace(/[^\d.^]/g, ''))" class="right_top_h2_input" style="width:100px" maxlength="13"/>元&nbsp;&nbsp;
        客户号：<textarea rows="100" cols="100" id="customerNo" name="customerNo" onblur="value=value.replace(/[^\d^.^\n^\r^]/g, '');" onkeyup="value=value.replace(/[^\d^.^\n^\r^]/g, '');" onbeforepaste="value=value.replace(/[^\d^.^\n^\r^]/g, '');" style="width:140px;height:60px;"></textarea>
        <input type="button" class="right_top_h2_button_serch" onclick="doSelect();" value="查询"/>
    </h2>
    <h2>
        <input type="button" onclick="doClean()" value="清空" class="rigt_button">
        <bo:hasPerm perm="${Perm.WithDraw_InV_Create}"><input type="button" onclick="save(false)" value="生成发票" class="rigt_button"></bo:hasPerm>
        <bo:hasPerm perm="${Perm.WithDraw_InV_CreateAndDoenload}"><input type="button" onclick="save(true)" value="生成并下载" class="rigt_button"></bo:hasPerm>
        <input type="hidden" id="customerNoStr" name="customerNoStr" value="${params.customerNoStr}"/>
        <input type="hidden" id="info" name="info" value="${params.info}"/>
        <input type="hidden" id="hidDate" name="hidDate" value="${params.hidDate}"/>
        <input type="hidden" id="factDate" name="factDate" value="${params.factDate}"/>
        <input type="hidden" id="saveFlag" name="saveFlag" value="${params.saveFlag}"/>
    </h2>
    </form>
    <table align="center" class="right_list_table" id="infoTable">
      <tr>

        <td><input type="checkbox" onclick="doCheck(this)" name="allChk"/>选择</td>

        <td style="display:none">客户ID</td>

        <g:sortableColumn params="${params}"  property="customer_no" title="客户号"/>

        <g:sortableColumn params="${params}"  property="name" title="客户名称"/>

        <g:sortableColumn params="${params}"  property="amt" title="应开金额"/>

        <g:sortableColumn params="${params}"  property="amt_adj" title="调整金额"/>

        <g:sortableColumn params="${params}"  property="amt_total" title="实开票额"/>

        <g:sortableColumn params="${params}"  property="adj_reason" title="调整原因"/>

        <g:sortableColumn params="${params}"  property="tax_registration_no" title="税务登记号"/>

        <g:sortableColumn params="${params}"  property="contact" title="财务接收人"/>

        <g:sortableColumn params="${params}"  property="contact_phone" title="联系电话"/>

        <g:sortableColumn params="${params}"  property="office_location" title="邮寄地址"/>

        <g:sortableColumn params="${params}"  property="zip_code" title="邮编"/>

      </tr>

      <g:each in="${listCm}" status="i" var="showInfo">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

          <td>
              <input type="checkbox" id="${i}" name="checkBoxes"/>${params.offset+i+1}
          </td>

          <td style="display:none"><input name="cmIds" value="${showInfo.customer_id}"/></td>

          <td>
              <input type="hidden" name="customer_no" value="${showInfo.customer_no}"/>
              ${showInfo.customer_no}
          </td>

          <td title="${showInfo.customer_name}">
              <input type="hidden" name="customer_name" value="${showInfo.customer_name}"/>
              <g:if test="${String.valueOf(showInfo.customer_name).length()>12}">${String.valueOf(showInfo.customer_name).substring(0,12)}...</g:if>
              <g:else>${showInfo.customer_name}</g:else>
          </td>

          <td>
              <input type="hidden" name="amt" value="${String.valueOf(showInfo.amt).replaceAll(",", "")}"/>
              ￥${showInfo.amt}
          </td>

          <td>
              <input type="hidden" name="amt_adj" value="${String.valueOf(showInfo.amt_adj).replaceAll(",", "")}"/>
              ￥<span id="amt_adj${i}">${showInfo.amt_adj}</span><bo:hasPerm perm="${Perm.WithDraw_InV_Adjust}"><br/><input type="button" value="…" onclick="adjWinOpen(${showInfo.customer_id})"/></bo:hasPerm><input type="hidden" name="amt_chg" value="" onpropertychange="onChk(${i});" oninput="onChk(${i});"/>
          </td>

          <td>
              <input type="hidden" name="amt_total" value="${String.valueOf(showInfo.amt_total).replaceAll(",", "")}"/>
              <span style="color:#ff0000">￥</span><span id="amt_total${i}" style="color:#ff0000">${showInfo.amt_total}</span>
          </td>

          <td><input name="adj_reason" value="" maxlength="255" onpropertychange="onChk(${i});" oninput="onChk(${i});" onfocus="this.select();" onblur="value=value.replace(/[\']/g, '')" onkeyup="value=value.replace(/[\']/g, '')" onbeforepaste="clipboardData.setData('text',clipboardData.getData( 'text').replace(/[\']/g, ''))"/></td>

          <td title="${showInfo.customer_tax_no}">
              <g:if test="${String.valueOf(showInfo.customer_tax_no).length()>10}">${String.valueOf(showInfo.customer_tax_no).substring(0,10)}...</g:if>
              <g:else>${showInfo.customer_tax_no}</g:else>
          </td>

          <td title="${showInfo.customer_contact}">
              <g:if test="${String.valueOf(showInfo.customer_contact).length()>5}">${String.valueOf(showInfo.customer_contact).substring(0,5)}...</g:if>
              <g:else>${showInfo.customer_contact}</g:else>
          </td>

          <td>${showInfo.customer_contact_phone}</td>

          <td title="${showInfo.customer_location}">
              <g:if test="${String.valueOf(showInfo.customer_location).length()>10}">${String.valueOf(showInfo.customer_location).substring(0,10)}...</g:if>
              <g:else>${showInfo.customer_location}</g:else>
          </td>

          <td title="${showInfo.customer_zip_code}">
              <g:if test="${String.valueOf(showInfo.customer_zip_code).length()>6}">${String.valueOf(showInfo.customer_zip_code).substring(0,6)}...</g:if>
              <g:else>${showInfo.customer_zip_code}</g:else>
          </td>

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
        $("#startTime").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true });
        var customerNos = "${params.customerNoStr}";
        document.getElementById("customerNo").value = customerNos.replace(/[\,]/g,'\r\n');
    });

    // 日期类型转化
    function dateChange1() {
        var dateFlag = document.getElementsByName("dateFlag")[0].value;
        var dateValue = document.getElementsByName("startTime")[0].value;
        if (dateFlag == '1') {
            document.getElementsByName("startTime")[0].value = document.getElementById("hidDate").value;
        } else {
            dateValue = dateValue.substr(0, 7);
            document.getElementsByName("startTime")[0].value = dateValue;
        }
    }
    function dateChange2() {
        var dateFlag = document.getElementsByName("dateFlag")[0].value;
        var dateValue = document.getElementsByName("startTime")[0].value;
        document.getElementById("hidDate").value = dateValue;
        if (dateFlag == '1') {
        } else {
            dateValue = dateValue.substr(0, 7);
            document.getElementsByName("startTime")[0].value = dateValue;
        }
    }

    // 清空检索条件
    function doClean() {
        document.getElementsByName("dateFlag")[0].value = 0;
        document.getElementsByName("startTime")[0].value = '';
        document.getElementsByName("hidDate")[0].value = '';
        document.getElementById("minAmount").value = '';
        document.getElementById("customerNo").value = '';
    }

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

    // 金额校验
    function chkAmount(num) {
        var numVal = num;
        if (numVal == '') {
            document.getElementById("minAmount").value = '0.00';
        } else {
            numVal = numVal.replace(/[^\d^.^]/g, '');
            var resutl = (parseFloat(numVal)).toFixed(2);
            if (resutl == "NaN") {
                alert("金额格式错误，请重新输入");
                document.getElementById("minAmount").focus();
                document.getElementById("minAmount").select();
                return false;
            } else {
                document.getElementById("minAmount").value = resutl;
                return true;
            }
        }
    }

    // 查询
    function doSelect() {
        if (document.getElementsByName("startTime")[0].value == '') {
            alert("请输入费用日期");
            document.getElementsByName("startTime")[0].focus();
        } else {
            var customerNos = document.getElementById("customerNo").value.replace(/[\r\n]/g,' ');
            document.getElementById("customerNoStr").value = customerNos;
            var submitForm = document.getElementById("submitForm");
            submitForm.action = "invoiceOutstandingShow";
            submitForm.submit();
        }
    }

    // 生成发票 下载发票
    function save(flag) {
        var permInfo = "";
        var node = "";
        var nodeNo = "";
        var chkInfo = document.getElementsByName("checkBoxes");
        var len = chkInfo.length;
        for (i = 0;  i < len; i++) {
            if ((document.getElementsByName("checkBoxes")[i].checked)&&(document.getElementsByName("checkBoxes")[i].disabled == false)) {
                var cmId = document.getElementsByName("cmIds")[i].value;
                var amt = document.getElementsByName("amt")[i].value;
                var amt_adj = document.getElementsByName("amt_adj")[i].value;
                var amt_total = document.getElementsByName("amt_total")[i].value;
                var adj_reason = document.getElementsByName("adj_reason")[i].value;
                if ((amt_adj != 0)&&(adj_reason == "")) {
                    alert("调整金额不为0时，调整原因不可为空");
                    document.getElementsByName("adj_reason")[i].focus();
                    document.getElementsByName("adj_reason")[i].select();
                    return;
                } else if (amt_total == 0) {
                    alert("不可开具金额为0的发票\n客户号：" + document.getElementsByName("customer_no")[i].value + "\n客户名称：" + document.getElementsByName("customer_name")[i].value);
                    return;
                } else {
                    if (flag) {
                        document.getElementsByName("checkBoxes")[i].disabled = true;
                    }
                    if (adj_reason == "") {
                        adj_reason = "adjust_reason_null_effect_AdjustReasonNullEffect";
                    }
                    permInfo = permInfo + node + cmId + "thisIsASubLine" + amt + "thisIsASubLine" + amt_adj + "thisIsASubLine" + amt_total + "thisIsASubLine" + adj_reason;
                    node = "thisIsALine";
                    nodeNo = ",";
                }
            }
        }
        if (permInfo == "") {
            alert("请选择需要更改的数据");
        } else {
                var submitForm = document.getElementById("submitForm");
                document.getElementById("info").value = permInfo;
            if (flag) {
                document.getElementById("saveFlag").value = "21";
            } else {
                document.getElementById("saveFlag").value = "1";
            }
            submitForm.action = "invoiceCreate";
            submitForm.submit();
            if (flag) {
                setTimeout(function(){location.reload();},1000);
            }
        }
    }

    // 弹出调账页面
    var adjWin;
    function adjWinOpen(customerId) {
        var url = "invoiceAdjustInfo?customerId=" + customerId + "&factDate=" + document.getElementById("factDate").value;
        adjWin = new Ext.Window({
               id:'adjWin',
               title:"选择调账记录",
               modal:true,
               width:900,
               height:500,
               html: "<iframe src="+url+" height='100%' width='100%' name='adjWin' scrolling='auto' frameborder='0' onLoad='Ext.MessageBox.hide();'>",
               maximizable:true
        });
        adjWin.show();
    }
</script>
</body>
</html>