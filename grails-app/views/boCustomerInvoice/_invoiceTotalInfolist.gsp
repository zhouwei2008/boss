<%@ page import="boss.BoCustomerInvoice" %>
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
        5760;width:41pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5760;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        6400;width:56pt'>
        <col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:
        4704;width:110pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        5536;width:130pt'>

        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>
        <col class=xl637821 width=55 style='mso-width-source:userset;mso-width-alt:
        4760;width:41pt'>
        <col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:
        4704;width:110pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        4536;width:130pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        7400;width:56pt'>

        <col class=xl637821 width=55 style='mso-width-source:userset;mso-width-alt:
        5760;width:41pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>
        <col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:
        4704;width:110pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        5536;width:130pt'>

        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>
        <col class=xl637821 width=55 style='mso-width-source:userset;mso-width-alt:
        4760;width:41pt'>
        <col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:
        4704;width:110pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        4536;width:130pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>

        <col class=xl637821 width=55 style='mso-width-source:userset;mso-width-alt:
        5760;width:41pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        6400;width:56pt'>
        <col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:
        6704;width:110pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        6536;width:130pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        6536;width:130pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        6536;width:130pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        6536;width:130pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        6536;width:130pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        6536;width:130pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        6536;width:130pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        6536;width:130pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        6536;width:130pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        6536;width:130pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        6536;width:130pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        6536;width:130pt'>

        <tr height=18 style='height:13.5pt'>
            <td height=18 class=xl637821 colspan=2 width=100 style='height:13.5pt;width:51pt'>发票信息列表<span style='mso-spacerun:yes'>&nbsp;</span></td>
            <td class=xl637821 width=136 style='width:120pt'></td>
            <td class=xl637821 width=136 style='width:102pt'></td>
            <td class=xl637821 width=96 style='width:72pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=136 style='width:102pt'></td>
            <td class=xl637821 width=136 style='width:102pt'></td>
            <td class=xl637821 width=75 style='width:56pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
        </tr>
        <tr height=18 style='height:13.5pt'>
            <td height=18 class=xl637821 style='height:13.5pt'></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821></td>
        </tr>
        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td height=18 class=xl667821 style='height:13.5pt;width:50px'>批次号</td>
            <td class=xl667821 style='border-left:none'>客户号</td>
            <td class=xl667821 style='border-left:none'>客户名称</td>
            <td class=xl667821 style='border-left:none'>税务登记号</td>
            <td class=xl667821 style='border-left:none'>截止日期</td>
            <td class=xl667821 style='border-left:none'>应开金额</td>
            <td class=xl667821 style='border-left:none'>调整金额</td>
            <td class=xl667821 style='border-left:none'>开票金额</td>
            <td class=xl667821 style='border-left:none'>调整原因</td>
            <td class=xl667821 style='border-left:none'>发票状态</td>
            <td class=xl667821 style='border-left:none'>发票号</td>
            <td class=xl667821 style='border-left:none'>发票日期</td>
            <td class=xl667821 style='border-left:none'>发票录入时间</td>
            <td class=xl667821 style='border-left:none'>发票录入人</td>
            <td class=xl667821 style='border-left:none'>快递单号</td>
            <td class=xl667821 style='border-left:none'>快递单录入时间</td>
            <td class=xl667821 style='border-left:none'>快递单录入人</td>
            <td class=xl667821 style='border-left:none'>发票退回原因</td>
            <td class=xl667821 style='border-left:none'>发票退回时间</td>
            <td class=xl667821 style='border-left:none'>联系人</td>
            <td class=xl667821 style='border-left:none'>联系电话</td>
            <td class=xl667821 style='border-left:none'>邮寄地址</td>
            <td class=xl667821 style='border-left:none'>邮编</td>
        </tr>
        <g:each in="${infolist}" status="i" var="infolist">
            <tr height=18 style='height:13.5pt'>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.batch_no}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.customer_no}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.customer_name}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.customer_tax_no}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.date_end}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>￥${infolist.amt}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>￥${infolist.amt_adj}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>￥${infolist.amt_total}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.adj_reason}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${BoCustomerInvoice.statusMap[infolist.status]}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.invoice_no}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.invoice_time}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.invoice_input_time}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.invoice_input_name}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.express_no}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.express_input_time}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.express_input_name}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.canceled_reason}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.canceled_time}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.customer_contact}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.customer_contact_phone}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.customer_location}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${infolist.customer_zip_code}</td>
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
            <td width=86 style='width:65pt'></td>
            <td width=96 style='width:102pt'></td>
            <td width=136 style='width:150pt'></td>
            <td width=136 style='width:150pt'></td>
            <td width=136 style='width:150pt'></td>
            <td width=136 style='width:150pt'></td>
            <td width=136 style='width:150pt'></td>
            <td width=136 style='width:150pt'></td>
            <td width=136 style='width:150pt'></td>
            <td width=136 style='width:150pt'></td>
            <td width=136 style='width:150pt'></td>
        </tr>
        <![endif]>
    </table>

</div>


<!----------------------------->
<!--“从 EXCEL 发布网页”向导结束-->
<!----------------------------->
</body>

</html>
