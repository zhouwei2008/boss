<%--
  Created by IntelliJ IDEA.
  User: zhaoshuang
  Date: 12-2-24
  Time: 上午9:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="boss.Perm" %>
<%@ page import="boss.BoCustomerInvoiceInit" %>
<%@ page import="boss.BoCustomerInvoice" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <link rel="stylesheet" type="text/css" href="../ext/css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="../ext/css/style.css" />
    <script type="text/javascript" src="../ext/js/ext-base.js"></script>
    <script type="text/javascript" src="../ext/js/ext-all.js"></script>
    <script type="text/javascript" src="../ext/js/ext-lang-zh_CN.js"></script>
    <title>快递信息录入</title>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">发票信息列表</h1>
    <form id="submitForm" action="invoiceInfoCanceling">
    <h2>
        费用日期：<g:select name="dateFlag" from="${BoCustomerInvoiceInit.dateSelect}" onchange="dateChange1()" optionKey="key" optionValue="value" value="${params.dateFlag}" class="right_top_h2_input"/>
        <g:textField name="startTime" value="${params.startTime}" onchange="dateChange2()" onfocus="this.select();" onblur="value=value.replace(/[ ]/g,'')" size="10" class="right_top_h2_input" style="width:80px"/>
        &nbsp; &nbsp;批次号：<input id="batchNo" name="batchNo" value="${params.batchNo}" onfocus="this.select();" onblur="value=value.replace(/[^\d^]/g,'');" onkeyup="value=value.replace(/[^\d^]/g, '')" onbeforepaste="clipboardData.setData( 'text',clipboardData.getData('text').replace(/[^\d]/g, ''))" class="right_top_h2_input" style="width:160px" maxlength="24"/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;客户号：<textarea rows="100" cols="100" id="customerNo" name="customerNo" onblur="value=value.replace(/[^\d^.^\n^\r^]/g, '');" onkeyup="value=value.replace(/[^\d^.^\n^\r^]/g, '');" onbeforepaste="value=value.replace(/[^\d^.^\n^\r^]/g, '');" style="width:140px;height:60px;"></textarea>
    </h2>
    <h2>
        客户名称：<g:textField id="customerName" name="customerName" onfocus="this.select();" onblur="value=value.replace(/[ ]/g,'').replace(/\'/g,  '');" value="${params.customerName}" class="right_top_h2_input" style="width:160px" maxlength="32"/>
        发票金额：<input id="minAmount" name="minAmount" value="${params.minAmount}" onfocus="this.select();" onblur="chkAmount(this);" onkeyup="value=value.replace(/[^\d^.^]/g, '')" onbeforepaste="clipboardData.setData( 'text',clipboardData.getData('text').replace(/[^\d.^]/g, ''))" class="right_top_h2_input" style="width:60px" maxlength="18"/>&nbsp;-&nbsp;
        <input id="maxAmount" name="maxAmount" value="${params.maxAmount}" onfocus="this.select();" onblur="chkAmount(this);" onkeyup="value=value.replace(/[^\d^.^]/g, '')" onbeforepaste="clipboardData.setData( 'text',clipboardData.getData('text').replace(/[^\d.^]/g, ''))" class="right_top_h2_input" style="width:60px" maxlength="18"/>元&nbsp;&nbsp;
        发票状态：<g:select name="status" from="${BoCustomerInvoice.statusCancelMap}" optionKey="key" optionValue="value" value="${params.status}" class="right_top_h2_input"/>
        <input type="button" class="right_top_h2_button_serch" onclick="doSelect();" value="查询"/>
    </h2>
    <h2>
        <input type="button" onclick="doClean()" value="清空" class="rigt_button">
        <bo:hasPerm perm="${Perm.WithDraw_InV_CancelSave}"><input type="button" onclick="cancel()" value="发票退回" class="rigt_button"></bo:hasPerm>
        <bo:hasPerm perm="${Perm.WithDraw_InV_Download04}"><input type="button" onclick="down()" value="下载发票" class="rigt_button"></bo:hasPerm>
        <input type="hidden" id="customerNoStr" name="customerNoStr" value="${params.customerNoStr}"/>
        <input type="hidden" id="info" name="info" value="${params.info}"/>
        <input type="hidden" id="hidDate" name="hidDate" value="${params.hidDate}"/>
        <input type="hidden" id="initFlag" name="initFlag" value="${params.initFlag}"/>
    </h2>
    </form>
    <table align="center" class="right_list_table" id="infoTable">
      <tr>

        <td><input type="checkbox" onclick="doCheck(this)" name="allChk"/>选择</td>

        <td style="display:none">ID</td>

        <td style="display:none">客户ID</td>

        <g:sortableColumn params="${params}"  property="batch_no" title="批次号"/>

        <g:sortableColumn params="${params}"  property="customer_no" title="客户号"/>

        <g:sortableColumn params="${params}"  property="name" title="客户名称"/>

        <g:sortableColumn params="${params}"  property="date_end" title="费用日期"/>

        <g:sortableColumn params="${params}"  property="amt" title="应开金额"/>

        <g:sortableColumn params="${params}"  property="amt_adj" title="调整金额"/>

        <g:sortableColumn params="${params}"  property="amt_total" title="实开票额"/>

        <g:sortableColumn params="${params}"  property="adj_reason" title="调整原因"/>

        <g:sortableColumn params="${params}"  property="status" title="发票状态"/>

        <g:sortableColumn params="${params}"  property="invoice_no" title="发票号"/>

        <g:sortableColumn params="${params}"  property="invoice_time" title="发票时间"/>

        <g:sortableColumn params="${params}"  property="express_no" title="快递号"/>

        <g:sortableColumn params="${params}"  property="express_no" title="退回原因"/>

        <bo:hasPerm perm="${Perm.WithDraw_InV_Detail04}"><g:sortableColumn params="${params}"  property="detail" title="明细"/></bo:hasPerm>

      </tr>

      <g:each in="${listCm}" status="i" var="showInfo">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

          <td>
              <input type="checkbox" id="${i}" name="checkBoxes"/>${params.offset+i+1}
          </td>

          <td style="display:none"><input name="ids" value="${showInfo.id}"/></td>

          <td style="display:none"><input name="customer_id" value="${showInfo.customer_id}"/></td>

          <td><input type="hidden" name="batch_no" value="${showInfo.batch_no}"/>${showInfo.batch_no}</td>

          <td>${showInfo.customer_no}</td>

          <td title="${showInfo.customer_name}">
              <input type="hidden" name="customer_name" value="${showInfo.customer_name}"/>
              <g:if test="${String.valueOf(showInfo.customer_name).length()>12}">${String.valueOf(showInfo.customer_name).substring(0,12)}...</g:if>
              <g:else>${showInfo.customer_name}</g:else>
          </td>

          <td>${showInfo.date_end}</td>

          <td>${showInfo.amt} </td>

          <td>￥${showInfo.amt_adj}</td>

          <td>
              <span style="color:#ff0000">￥${showInfo.amt_total}</span>
          </td>

          <td title="${showInfo.adj_reason}">
              <g:if test="${String.valueOf(showInfo.adj_reason).length()>10}">${String.valueOf(showInfo.adj_reason).substring(0,10)}...</g:if>
              <g:else>${showInfo.adj_reason}</g:else>
          </td>

          <td>${BoCustomerInvoice.statusMap[showInfo.status]}</td>

          <td>${showInfo.invoice_no}</td>

          <td>${showInfo.invoice_time}</td>

          <td>${showInfo.express_no}</td>

          <td><input name="canceledReason" value="${showInfo.canceled_reason}" maxlength="255" style="width:120px" onpropertychange="onChk(${i});" oninput="onChk(${i});" onfocus="this.select();" onblur="value=value.replace(/[\']/g, '').replace(/[' ']/g, '');" onkeyup="value=value.replace(/[\']/g, '').replace(/[' ']/g, '')" onbeforepaste="clipboardData.setData('text',clipboardData.getData( 'text').replace(/[\']/g, ''))"/></td>

          <bo:hasPerm perm="${Perm.WithDraw_InV_Detail04}"><td><input type="button" value="明细" onclick="detailWinOpen(${showInfo.id})"/></td></bo:hasPerm>

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
        document.getElementById("batchNo").value = '';
        document.getElementById("customerNo").value = '';
        document.getElementById("customerName").value = '';
        document.getElementById("minAmount").value = '';
        document.getElementById("maxAmount").value = '';
        document.getElementById("status").value = '-1';
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
    function chkAmount(obj) {
        var numVal = obj.value;
        if (numVal != '') {
            numVal = numVal.replace(/[^\d^.^]/g, '');
            var resutl = (parseFloat(numVal)).toFixed(2);
            if (resutl == "NaN") {
                alert("金额格式错误，请重新输入");
                obj.focus();
                obj.select();
                return false;
            } else {
                obj.value = resutl;
                return true;
            }
        }
    }

    // 查询
    function doSelect() {
        if ((document.getElementById("minAmount").value != '')&&(document.getElementById("maxAmount").value != '')&&(document.getElementById("minAmount").value > document.getElementById("maxAmount").value)) {
            alert("金额大小输入错误，请重新输入");
            document.getElementById("minAmount").focus();
        } else {
            var customerNos = document.getElementById("customerNo").value.replace(/[\r\n]/g,' ');
            document.getElementById("customerNoStr").value = customerNos;
            submitForm.submit();
        }
    }

    // 发票退回可行性检查
    function chkInvInfo(id) {
        var flag = 0;

        var baseUrl = "${createLink(controller:'boCustomerInvoice', action:'chkInvoiceInfo')}";
        $.ajax({
            url: baseUrl,
            type: 'post',
            async:false,
            dataType: 'String',
            data:'id='+id,
            success: function(result){
                if (result != "success") {
                    flag = 1;
                }
            }
        });
        return flag;
    }

    // 发票退回
    function cancel() {
        var permInfo = "";
        var node = "";
        var chkInfo = document.getElementsByName("checkBoxes");
        var len = chkInfo.length;
        for (i = 0;  i < len; i++) {
            if (document.getElementsByName("checkBoxes")[i].checked) {
                var id = document.getElementsByName("ids")[i].value;
                var canceledReason = document.getElementsByName("canceledReason")[i].value;
                var cmId = document.getElementsByName("customer_id")[i].value;
                if ((canceledReason == null) || (canceledReason == "")) {
                    alert("请输入退回原因");
                    document.getElementsByName("canceledReason")[i].focus();
                    return;
                } else if (chkInvInfo(id) == 1) {
                    alert("该条不是最新开具的发票，不能退回\n发票批次："+document.getElementsByName("batch_no")[i].value+"\n客户名称："+document.getElementsByName("customer_name")[i].value);
                    document.getElementsByName("canceledReason")[i].focus();
                    return;
                } else {
                    permInfo = permInfo + node + id + "thisIsASubLine" + canceledReason + "thisIsASubLine" + cmId;
                    node = "thisIsALine";
                }
            }
        }
        if (permInfo == "") {
            alert("请选择需要更改的数据");
        } else {
            if (confirm('确定要退回发票吗？')) {
                var submitForm = document.getElementById("submitForm");
                document.getElementById("info").value = permInfo;
                submitForm.action = "invoiceInfoCancelSave";
                submitForm.submit();
            }
        }
    }

    // 下载发票
    function down() {
        var permInfo = "";
        var node = "";
        var chkInfo = document.getElementsByName("checkBoxes");
        var len = chkInfo.length;
        for (i = 0;  i < len; i++) {
            if (document.getElementsByName("checkBoxes")[i].checked) {
                var invId = document.getElementsByName("ids")[i].value;
                permInfo = permInfo + node + invId;
                node = ",";
            }
        }
        if (permInfo == "") {
            alert("请选择需要下载的数据");
        } else {
            var submitForm = document.getElementById("submitForm");
            document.getElementById("info").value = permInfo;
            submitForm.action = "invoiceDown";
            submitForm.submit();
            setTimeout(function(){location.reload();},1000);
        }
    }

    // 弹出明细页面
    var detailWin;
    function detailWinOpen(id, customerId) {
        var url = "invoiceDetailInfo?invoice_id="+id;
        detailWin = new Ext.Window({
               id:'detailWin',
               title:"发票明细信息",
               modal:true,
               width:800,
               height:600,
               html: "<iframe src="+url+" height='100%' width='100%' name='adjWin' scrolling='auto' frameborder='0' onLoad='Ext.MessageBox.hide();'>",
               maximizable:true
        });
        detailWin.show();
    }
</script>
</body>
</html>