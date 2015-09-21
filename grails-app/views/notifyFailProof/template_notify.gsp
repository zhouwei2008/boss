<%@ page contentType="text/html" %>
<%@ page import="gateway.GwOrder; gateway.GwTransaction; ismp.CmDynamicKey" %>
<html>
<body>
<style>
.main {
    width: 100%;
    height: auto;
    margin: 10px 10px;
    font-size:12px;
}
.right_top {
  width: 99%;
  height: auto;
  border: solid 1px #efefef;
  margin-top: 10px;
}

.right_top h1 {
  line-height: 30px;
  color: #333;
  font-weight: bold;
  font-size: 14px;
  padding-left: 10px;
  text-align: left;
}

.right_top h1 img {
  width: 16px;
  height: 16px;
  margin: 7px;
  float: left;
}

.right_top h2 {
  line-height: 30px;
  color: #656565;
  padding-left: 10px;
  text-align: left;
  font-weight: normal;
  margin-top: 15px;
}

.right_top_h2_input {
  line-height: 20px;
  height: 20px;
  border: 1px solid #C4C4C4;
  margin-right: 10px;
}
 /*表格样式*/
.right_list_tablebox{
    width:99%; overflow-x:auto;
}
.right_list_table {
    width:100%;
  border-collapse: collapse;
  margin-top: 5px;
  border: solid 1px #ccc;
  height:auto;
}

.right_list_table tr th {
  height: 25px;
  text-align: center;
  background: #f6f6f6;
  font-weight: bold;
  color: #656565;
  border-collapse: collapse;
  border: solid 1px #d1d1d1;
  line-height: 25px;
  padding: 0px 6px;
  white-space : nowrap;
    font-size:12px;
}

.right_list_table tr td {
  border: solid 1px #dadada;
  text-align: center;
  height: 30px;
  color: #333;
  line-height: 30px;
  padding: 0px 6px;
     font-size:12px;
}

.right_list_table tr td p {
  color: #900;
}
</style>

<br/>
<br/>
<p style="padding-left:5px">${item?.name}:</p>
<p style="padding-left:25px">系统发现以下订单疑似掉单，请核实以下信息，并进行处理。</p>
<p style="padding-left:5px">订单内容：</p>


        <table class="right_list_table" width="100%">
            <tr>
                <th nowrap>商户订单号</th>
                <th nowrap>交易流水号</th>
                <th nowrap>订单创建时间</th>
                <th nowrap>银行订单号</th>
                <th nowrap>订单金额（元）</th>
                <th nowrap>支付完成时间</th>
                <th nowrap>卖家客户号</th>
                <th nowrap>卖家客户名称</th>
                <th nowrap>联系人</th>
                <th nowrap>联系电话</th>
                <th nowrap>管理员邮箱</th>
            </tr>
            <tr>
                <td nowrap>${item.OUTTRADENO}</td>
                <td nowrap>${item.TRADENO}</td>
                <td nowrap>${item.ORDERCREATETIME}</td>
                <td nowrap>${GwTransaction.findByOrder(GwOrder.get(item.ORDERID.toString()))?.bankTransNo}</td>
                <td nowrap>${item.ORDERAMOUNT ? item.ORDERAMOUNT / 100 : 0}</td>
                <td nowrap>${item.PAYCOMPLETETIME}</td>
                <td nowrap>${item.SELLERCUSTOMERNO}</td>
                <td nowrap>${item.SELLERNAME}</td>
                <td nowrap>${item.CONTACT}</td>
                <td nowrap>${item.CONTACTPHONE}</td>
                <td nowrap>${item.SELLERADMINMAIL}</td>
            </tr>
        </table>


<p style="padding-left:25px">系统自动发送邮件，请不要回复，谢谢。</p>
<p style="padding-left:825px">吉高</p>
</body>
</html>