<%--
  Created by IntelliJ IDEA.
  User: zhaoshuang
  Date: 12-2-21
  Time: 下午3:3
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="boss.BoCustomerInvoiceDetail" %>
<%@ page import="boss.BoCustomerInvoice" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <title>发票明细信息</title>
</head>
<body>
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message.encodeAsHTML()}</div>
  </g:if>
    <div class="right_top">
    <B>&nbsp;&nbsp;客户信息</B>
    <table align="center" class="right_list_table" id="infoTable1">

        <tr class="odd">

          <td>客户号：${params.customer_no}</td>

          <td title="${params.customer_name}">客户名称：
              <g:if test="${String.valueOf(params.customer_name).length()>12}">${String.valueOf(params.customer_name).substring(0,12)}...</g:if>
              <g:else>${params.customer_name}</g:else>
          </td>

          <td>税务登记号：${params.customer_tax_no}</td>

        </tr>

        <tr class="odd">

          <td>客户联系人：${params.customer_contact}</td>

          <td>客户联系电话：${params.customer_contact_phone}</td>

          <td>邮编：${params.customer_zip_code}</td>

        </tr>

        <tr class="odd">

          <td colspan="3" align="left" title="${params.customer_location}">邮寄地址：
              <g:if test="${String.valueOf(params.customer_location).length()>40}">${String.valueOf(params.customer_location).substring(0,40)}...</g:if>
              <g:else>${params.customer_location}</g:else>
          </td>

        </tr>
    </table>
  </div>

    <div class="right_top">
    <B>&nbsp;&nbsp;发票信息</B>
    <table align="center" class="right_list_table" id="infoTable2">

        <tr class="odd">

          <td>发票号：${params.invoice_no}</td>

          <td>发票日期：${params.invoice_time}</td>

          <td>发票状态：${BoCustomerInvoice.statusMap[params.status]}</td>

        </tr>

        <tr class="odd">

          <td>截止日期：${params.date_end}</td>

          <td>应开金额：${params.amt}</td>

          <td>实开金额：${params.nvoice_amt}</td>

        </tr>

        <tr class="odd">

          <td>调整金额：${params.amt_adj}</td>

          <td colspan="2" align="left" title="${params.adj_reason}">调整原因：
              <g:if test="${String.valueOf(params.adj_reason).length()>28}">${String.valueOf(params.adj_reason).substring(0,28)}...</g:if>
              <g:else>${params.adj_reason}</g:else>
          </td>

        <tr class="odd">

          <td>发票录入时间：${params.invoice_input_time}</td>

          <td colspan="2" align="left">发票录入人：${params.invoice_input_name}</td>

        <tr class="odd">

          <td>发票退回时间：${params.canceled_time}</td>

          <td colspan="2" align="left" title="${params.canceled_reason}">退回原因：
              <g:if test="${String.valueOf(params.canceled_reason).length()>28}">${String.valueOf(params.canceled_reason).substring(0,28)}...</g:if>
              <g:else>${params.canceled_reason}</g:else>
          </td>

        </tr>
    </table>
  </div>

  <div class="right_top">
    <B>&nbsp;&nbsp;快递信息</B>
    <table align="center" class="right_list_table" id="infoTable3">

        <tr class="odd">

          <td>快递单号：${params.express_no}</td>

          <td>快递录入时间：${params.express_input_time}</td>

          <td>快递录入人：${params.express_input_name}</td>

        </tr>
    </table>
  </div>

  <div class="right_top">
    <B>&nbsp;&nbsp;业务明细</B>
    <table align="center" class="right_list_table" id="detailTable">
      <tr>

        <g:sortableColumn params="${params}"  property="no" title="序"/>

        <g:sortableColumn params="${params}"  property="bill_type" title="手续费类型"/>

        <g:sortableColumn params="${params}"  property="bill_no" title="业务单号"/>

        <g:sortableColumn params="${params}"  property="bill_date" title="日期"/>

        <g:sortableColumn params="${params}"  property="bill_amount" title="金额"/>

      </tr>

      <g:each in="${detailList}" status="i" var="detailInfo">
        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

          <td>${params.offset+i+1}</td>

          <td>${BoCustomerInvoiceDetail.billTypeMap[String.valueOf(detailInfo.bill_type)]}</td>

          <td>${detailInfo.bill_no}</td>

          <td>${detailInfo.bill_date}</td>

          <td><font <g:if test="${String.valueOf(detailInfo.bill_amount).indexOf('-') < 0}">color="green"</g:if><g:else>color="red"</g:else>>￥${detailInfo.bill_amount}</font></td>

        </tr>
      </g:each>
    </table>

    <div class="paginateButtons">
        <div align="left"><div style="position:absolute;">共${count}条记录</div></div>
      <g:paginat total="${count}" params="${params}"/>
    </div>
    <form id="submitForm" action="detailDown">
        <h2>
            <input type="button" onclick="detailDown()" value="明细下载" class="rigt_button">
            <input type="button" onclick="confirmClose()" value="关闭" class="rigt_button">
            <input type="hidden" id="invoice_id" name="invoice_id" value="${params.invoice_id}"/>
            <input type="hidden" id="batch_no_show" name="batch_no_show" value="${params.batch_no}"/>
            <input type="hidden" id="customer_name_show" name="customer_name_show" value="${params.customer_name}"/>
        </h2>
    </form>
  </div>
</div>
<script type="text/javascript">

    // 关闭
    function confirmClose() {
        parent.detailWin.hide();
        parent.location.reload();
    }

    // 下载
    function detailDown() {
        submitForm.submit();
    }
</script>
</body>
</html>