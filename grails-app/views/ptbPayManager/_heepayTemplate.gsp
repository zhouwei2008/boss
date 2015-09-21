<%@ page import="pay.PtbPayTrade; pay.PtbPayBatch; dsf.TbPcInfo; dsf.TbAgentpayDetailsInfo; dsf.TbAgentpayDetailsInfo;boss.BoAcquirerAccount" %>
<html xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:x="urn:schemas-microsoft-com:office:excel"
      xmlns="http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 12">
<style id="template_26326_Styles">
<!--
table {
    mso-displayed-decimal-separator: "\.";
    mso-displayed-thousand-separator: "\,";
}

.font57821 {
    color: windowtext;
    font-size: 9.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
}

.xl733956 {
    padding-top: 1px;
    padding-right: 1px;
    padding-left: 1px;
    mso-ignore: padding;
    color: black;
    font-size: 11.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
    mso-number-format: "0_ ";
    text-align: general;
    vertical-align: middle;
    border: .5pt solid windowtext;
    mso-background-source: auto;
    mso-pattern: auto;
    white-space: nowrap;
}

.xl637821 {
    padding-top: 1px;
    padding-right: 1px;
    padding-left: 1px;
    mso-ignore: padding;
    color: black;
    font-size: 11.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
    mso-number-format: "\@";
    text-align: general;
    vertical-align: middle;
    mso-background-source: auto;
    mso-pattern: auto;
    white-space: nowrap;
}

.xl647821 {
    padding-top: 1px;
    padding-right: 1px;
    padding-left: 1px;
    mso-ignore: padding;
    color: black;
    font-size: 11.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
    mso-number-format: "\@";
    text-align: general;
    vertical-align: middle;
    border: .5pt solid windowtext;
    mso-background-source: auto;
    mso-pattern: auto;
    white-space: nowrap;
}

.xl657821 {
    padding-top: 1px;
    padding-right: 1px;
    padding-left: 1px;
    mso-ignore: padding;
    color: black;
    font-size: 11.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
    mso-number-format: General;
    text-align: general;
    vertical-align: middle;
    border: .5pt solid windowtext;
    mso-background-source: auto;
    mso-pattern: auto;
    white-space: nowrap;
}

.xl667821 {
    padding-top: 1px;
    padding-right: 1px;
    padding-left: 1px;
    mso-ignore: padding;
    color: white;
    font-size: 11.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
    mso-number-format: "\@";
    text-align: center;
    vertical-align: middle;
    border-top: .5pt solid windowtext;
    border-right: .5pt solid windowtext;
    border-bottom: none;
    border-left: .5pt solid windowtext;
    background: #0070C0;
    mso-pattern: black none;
    white-space: nowrap;
}

.xl677821 {
    padding-top: 1px;
    padding-right: 1px;
    padding-left: 1px;
    mso-ignore: padding;
    color: black;
    font-size: 11.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
    mso-number-format: "\@";
    text-align: general;
    vertical-align: middle;
    border: .5pt solid windowtext;
    mso-background-source: auto;
    mso-pattern: auto;
    white-space: nowrap;
}

.xl687821 {
    padding-top: 1px;
    padding-right: 1px;
    padding-left: 1px;
    mso-ignore: padding;
    color: black;
    font-size: 11.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
    mso-number-format: General;
    text-align: right;
    vertical-align: middle;
    border: .5pt solid windowtext;
    mso-background-source: auto;
    mso-pattern: auto;
    white-space: nowrap;
}

.xl697821 {
    padding-top: 1px;
    padding-right: 1px;
    padding-left: 1px;
    mso-ignore: padding;
    color: black;
    font-size: 11.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
    mso-number-format: 000000;
    text-align: right;
    vertical-align: middle;
    border: .5pt solid windowtext;
    mso-background-source: auto;
    mso-pattern: auto;
    white-space: nowrap;
}

.xl707821 {
    padding-top: 1px;
    padding-right: 1px;
    padding-left: 1px;
    mso-ignore: padding;
    color: black;
    font-size: 11.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
    mso-number-format: "\@";
    text-align: right;
    vertical-align: middle;
    border: .5pt solid windowtext;
    mso-background-source: auto;
    mso-pattern: auto;
    white-space: nowrap;
}

.xl717821 {
    padding-top: 1px;
    padding-right: 1px;
    padding-left: 1px;
    mso-ignore: padding;
    color: black;
    font-size: 11.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
    mso-number-format: General;
    text-align: center;
    vertical-align: middle;
    border: .5pt solid windowtext;
    mso-background-source: auto;
    mso-pattern: auto;
    white-space: nowrap;
}

.xl165 {
    padding-top: 1px;
    padding-right: 1px;
    padding-left: 1px;
    mso-ignore: padding;
    color: black;
    font-size: 11.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
    mso-number-format: "0\.00_ ";
    text-align: general;
    vertical-align: middle;
    /*border: .5pt solid windowtext;*/
    mso-background-source: auto;
    mso-pattern: auto;
    white-space: nowrap;
}

.xl727821 {
    padding-top: 1px;
    padding-right: 1px;
    padding-left: 1px;
    mso-ignore: padding;
    color: black;
    font-size: 11.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
    mso-number-format: "0\.00_ ";
    text-align: general;
    vertical-align: middle;
    border: .5pt solid windowtext;
    mso-background-source: auto;
    mso-pattern: auto;
    white-space: nowrap;
}

ruby {
    ruby-align: left;
}

rt {
    color: windowtext;
    font-size: 9.0pt;
    font-weight: 400;
    font-style: normal;
    text-decoration: none;
    font-family: 宋 体;
    mso-generic-font-family: auto;
    mso-font-charset: 134;
    mso-char-type: none;
}

-->
</style>
</head>

<body>
<!--[if !excel]>　　<![endif]-->
<!--下列信息由 Microsoft Office Excel 的“发布为网页”向导生成。-->
<!--如果同一条目从 Excel 中重新发布，则所有位于 DIV 标记之间的信息均将被替换。-->
<!----------------------------->
<!--“从 EXCEL 发布网页”向导开始-->
<!----------------------------->

<div id="template_26326" align=center x:publishsource="Excel">

    <table border=0 cellpadding=0 cellspacing=0 width=1524 class=xl637821
           style='border-collapse:collapse;table-layout:fixed;width:1143pt'>
        <col class=xl637821 width=55 style='mso-width-source:userset;mso-width-alt:
        2000;width:41pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        4000;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5500;width:56pt'>
        <col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:
        5500;width:110pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        4000;width:130pt'>

        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        4000;width:56pt'>
        <col class=xl637821 width=55 style='mso-width-source:userset;mso-width-alt:
        10000;width:41pt'>
        <col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:
        4000;width:110pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        5800;width:130pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        3000;width:56pt'>


        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl667821 style='height:13.5pt;width:20px'>序号</td>
            <td class=xl667821 style='height:13.5pt;width:30px'>收款人姓名</td>
            <td class=xl667821 style='height:13.5pt;width:30px'>银行编码</td>
            <td class=xl667821 style='height:13.5pt;width:50px'>银行卡号</td>
            <td class=xl667821 style='height:13.5pt;width:30px'>省/直辖市</td>
            <td class=xl667821 style='height:13.5pt;width:30px'>城市</td>
            <td class=xl667821 style='height:13.5pt;width:50px'>开户行名称</td>
            <td class=xl667821 style='height:13.5pt;width:50px'>付款金额</td>
            <td class=xl667821 style='height:13.5pt;width:70px'>0(对私付款)/1(对公付款)</td>
            <td class=xl667821 style='height:13.5pt;width:30px'>备注</td>


        </tr>
        <g:each in="${ptbPayTradeList}" status="i" var="ptbPayTrade">
            <tr height=18 style='height:13.5pt'>
                <td height=18 class=xl677821 align=right style='height:13.5pt;width:20px'>${i+1}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeCardname}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeBank}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeCardnum}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeProvince}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeCity}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeNote2}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${BigDecimal.valueOf(ptbPayTrade.tradeAmount).toPlainString()}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeAcctype}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeNote}</td>
            </tr>
        </g:each>

        <tr height=18 style='height:13.5pt'>
            <td height=18 class=xl677821  align=right style='height:13.5pt;'>10000</td>
        </tr>

        <tr height=18 style='height:13.5pt'>
            <td height=18  class=xl677821 align=right style='height:13.5pt;'><font color="red">必须以10000结尾，请不要删除10000</font></td>
        </tr>

        <tr height=18 style='height:13.5pt'>
            <td height=18 align=right style='height:13.5pt;'></td>
        </tr>
        <tr height=18 style='height:13.5pt'>
            <td height=18  align=right style='height:13.5pt;'></td>
        </tr>
        <tr height=18 style='height:13.5pt'>
            <td height=18 align=right style='height:13.5pt;'></td>
        </tr>

        <tr height=18 style='height:13.5pt'>
            <td height=18   align=right style='height:13.5pt;'>NOTE</td>
        </tr>
        <tr height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>1.模板上传只支持工商银行，农业银行，建设银行，招商银行，交通银行，中信银行，浦发银行，深发展银行，民生银行，其余银行请在付款页面选择添加</td>
        </tr>
        <tr height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>2.单笔付款金额限额为5万元（不含）。</td>
        </tr>
        <tr height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>3.备注内容仅本人可见，最多20字。</td>
        </tr>
        <tr height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>4.文件必须为excel文件。</td>
        </tr>
        <tr height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>5.一次最多向100人付款。</td>
        </tr>
        <tr height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>6.对公对私：0代表个人；1代表公司（表中不能同时存在对公和对私付款，要么全部对公付款，要么全部对私付款）</td>
        </tr>
        <tr height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>7.excel文件命名规则：YYYYMMDD+当日批次号，当日批次号使用4位数字，例如2013年09月25第7笔，excel文件命名为201309250007。*文件不可重名。</td>
        </tr>

        <tr height=18 style='height:13.5pt'>
            <td height=18  align=right style='height:13.5pt;'></td>
        </tr>

        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl667821 style='height:13.5pt;width:20px'>编码</td>
            <td class=xl667821 style='height:13.5pt;width:30px'>支付名称</td>
            <td class=xl667821 style='height:13.5pt;width:30px'>说明</td>
        </tr>

        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>1</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>工商银行</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到工商银行</td>
        </tr>


        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>2</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>建设银行</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到建设银行</td>
        </tr>

        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>3</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>农业银行</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到农业银行</td>
        </tr>


        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>4</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>邮政储蓄银行</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到邮政储蓄银行</td>
        </tr>


        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>5</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>中国银行</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到中国银行</td>
        </tr>

        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>6</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>交通银行</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到交通银行</td>
        </tr>
        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>7</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>招商银行</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到招商银行</td>
        </tr>

        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>8</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>光大银行</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到光大银行</td>
        </tr>

        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>9</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>浦发银行</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到浦发银行</td>
        </tr>

        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>10</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>华夏银行</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到华夏银行</td>
        </tr>

        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>11</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>广东发展银行</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到广东发展银行</td>
        </tr>

        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>12</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>中信银行</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到中信银行</td>
        </tr>

    <tr class=xl637821 height=18 style='height:13.5pt'>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>13</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>兴业银行</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到兴业银行</td>
    </tr>

    <tr class=xl637821 height=18 style='height:13.5pt'>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>14</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>民生银行</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到民生银行</td>
    </tr>

    <tr class=xl637821 height=18 style='height:13.5pt'>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>15</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>杭州银行</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到杭州银行</td>
    </tr>

    <tr class=xl637821 height=18 style='height:13.5pt'>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>16</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>上海银行</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到上海银行</td>
    </tr>

    <tr class=xl637821 height=18 style='height:13.5pt'>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>17</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>宁波银行</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到宁波银行</td>
    </tr>

    <tr class=xl637821 height=18 style='height:13.5pt'>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>18</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>平安银行</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>付款到平安银行</td>
    </tr>




    <![if supportMisalignedColumns]>
        <tr height=0 style='display:none'>
            <td width=55 style='width:41pt'></td>
            <td width=147 style='width:110pt'></td>
            <td width=173 style='width:130pt'></td>
            <td width=75 style='width:56pt'></td>
            <td width=83 style='width:62pt'></td>
            <td width=86 style='width:65pt'></td>
            <td width=96 style='width:72pt'></td>
            <td width=136 style='width:102pt'></td>
            <td width=75 style='width:56pt'></td>
            <td width=83 style='width:62pt'></td>
        </tr>
        <![endif]>
    </table>

</div>


<!----------------------------->
<!--“从 EXCEL 发布网页”向导结束-->
<!----------------------------->
</body>

</html>
