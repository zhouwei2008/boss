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

<table border=0 cellpadding=0 cellspacing=0 width=2000 class=xl637821 style='border-collapse:collapse;table-layout:fixed;width:1143pt'>
<col class=xl637821 width=55 style='mso-width-source:userset;mso-width-alt:2500;width:41pt'>
<col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:2800;width:56pt'>
<col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:2500;width:56pt'>
<col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:2500;width:110pt'>
<col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:6000;width:130pt'>
<col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:5500;width:56pt'>
<col class=xl637821 width=55 style='mso-width-source:userset;mso-width-alt:5500;width:41pt'>
<col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:7000;width:110pt'>
<col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:4000;width:130pt'>
<col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:4000;width:56pt'>
<col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:4000;width:56pt'>
<col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:6000;width:56pt'>
<col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:4000;width:110pt'>
<col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:3500;width:130pt'>
<col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:3500;width:56pt'>
<col class=xl637821 width=55 style='mso-width-source:userset;mso-width-alt:3000;width:41pt'>
<col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:3000;width:110pt'>
<col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:6000;width:130pt'>
<col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:3000;width:56pt'>


<tr class=xl637821 height=18 style='height:13.5pt'>
    <td height=18 class=xl667821 style='height:13.5pt;width:20px'>币种</td>
    <td class=xl667821 style='height:13.5pt;width:30px'>日期</td>
    <td class=xl667821 style='height:13.5pt;width:30px'>明细标志</td>
    <td class=xl667821 style='height:13.5pt;width:50px'>顺序号</td>
    <td class=xl667821 style='height:13.5pt;width:30px'>付款账号开户行</td>
    <td class=xl667821 style='height:13.5pt;width:30px'>付款账号</td>
    <td class=xl667821 style='height:13.5pt;width:50px'>付款账号名称</td>
    <td class=xl667821 style='height:13.5pt;width:50px'>收款账号开户行</td>
    <td class=xl667821 style='height:13.5pt;width:70px'>收款账号省份</td>
    <td class=xl667821 style='height:13.5pt;width:30px'>收款账号地市</td>

    <td class=xl667821 style='height:13.5pt;width:50px'>收款账号地区码</td>
    <td class=xl667821 style='height:13.5pt;width:50px'>收款账号</td>
    <td class=xl667821 style='height:13.5pt;width:70px'>收款账号名称</td>
    <td class=xl667821 style='height:13.5pt;width:30px'>金额</td>

    <td class=xl667821 style='height:13.5pt;width:30px'>汇款用途</td>
    <td class=xl667821 style='height:13.5pt;width:30px'>备注信息</td>
    <td class=xl667821 style='height:13.5pt;width:30px'>汇款方式</td>
    <td class=xl667821 style='height:13.5pt;width:30px'>收款账户短信通知手机号码</td>
    <td class=xl667821 style='height:13.5pt;width:30px'>自定义序号</td>
</tr>


<g:each in="${ptbPayTradeList}" status="i" var="ptbPayTrade">
    <tr height=18 style='height:13.5pt'>
        <td height=18 class=xl677821 align=right style='height:13.5pt;width:20px'>${ptbPayTrade.tradeAmttype}</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.checkway}</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>2</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${i+1}</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeBranchbank}</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeNote1}</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeNote2}</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeSubbank}</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeProvince}</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeCity}</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeCode}</td>

        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeCardnum}</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeCardname}</td>

        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${BigDecimal.valueOf(ptbPayTrade.tradeAmount).toPlainString()}</td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeNote}</td>

        <td height=18 class=xl677821 align=right style='height:13.5pt;'></td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${ptbPayTrade.tradeType}</td>

        <td height=18 class=xl677821 align=right style='height:13.5pt;'></td>
        <td height=18 class=xl677821 align=right style='height:13.5pt;'>${i+1}</td>
    </tr>
</g:each>


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
