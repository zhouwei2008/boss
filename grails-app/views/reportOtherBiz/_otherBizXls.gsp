<%@ page import="ismp.TradeBase; gateway.GwTransaction; ismp.TradeCharge; ismp.TradePayment; ismp.TradeRefund" %>
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
        vertical-align: middle; /*border: .5pt solid windowtext;*/
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
        <col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:
        5704;width:110pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        5536;width:130pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>
        <col class=xl637821 width=55 style='mso-width-source:userset;mso-width-alt:
        5760;width:41pt'>
        <col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:
        4704;width:110pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        5536;width:130pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>
        <tr height=18 style='height:13.5pt'>
            <td height=18 class=xl637821 colspan=2 width=100 style='height:13.5pt;
            width:51pt'>吉高其他业务统计报表<span style='mso-spacerun:yes'>&nbsp;</span></td>
            <td class=xl637821 width=75 style='width:56pt'>导出时间:</td>
            <td class=xl637821 colspan=2 width=169 style='width:127pt'>${new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date())}</td>
            <td class=xl637821 width=136 style='width:120pt'></td>
            <td class=xl637821 width=136 style='width:102pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=136 style='width:102pt'></td>
            <td class=xl637821 width=96 style='width:72pt'></td>
            <td class=xl637821 width=136 style='width:102pt'></td>
            <td class=xl637821 width=80 style='width:60pt'></td>
            <td class=xl637821 width=136 style='width:102pt'></td>
            <td class=xl637821 width=96 style='width:72pt'></td>
            <td class=xl637821 width=136 style='width:102pt'></td>
            <td class=xl637821 width=80 style='width:102pt'></td>
            <td class=xl637821 width=150 style='width:150pt'></td>
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
        </tr>

        <tr>
        <th class=xl667821 style='border-left:none' rowspan="2">区域</th>
        <th class=xl667821 style='border-left:none' rowspan="2">商户名称</th>
        <th class=xl667821 style='border-left:none' colspan="4">充值</th>
        <th class=xl667821 style='border-left:none' colspan="4">提现</th>
        <th class=xl667821 style='border-left:none' colspan="4">转账</th>
      </tr>
      <tr>
        <th class=xl667821 style='border-left:none'>交易笔数</th>
        <th class=xl667821 style='border-left:none'>交易净额</th>
        <th class=xl667821 style='border-left:none'>手续费收入</th>
        <th class=xl667821 style='border-left:none'>银行手续费成本</th>
        <th class=xl667821 style='border-left:none'>交易笔数</th>
        <th class=xl667821 style='border-left:none'>交易净额</th>
        <th class=xl667821 style='border-left:none'>手续费收入</th>
        <th class=xl667821 style='border-left:none'>银行手续费成本</th>
        <th class=xl667821 style='border-left:none'>交易笔数</th>
        <th class=xl667821 style='border-left:none'>交易净额</th>
        <th class=xl667821 style='border-left:none'>手续费收入</th>
        <th class=xl667821 style='border-left:none'>银行手续费成本</th>
      </tr>
%{--[                      t.area,
                           t.cus_accountid,
                           t.cus_name,
                           t.charge_total_count,
                           t.charge_total_amount,
                           t.charge_fee,
                           t.charge_bank_cost,
                           t.withdrawn_count,
                           t.withdrawn_amount,
                           t.withdrawn_fee,
                           t.withdrawn_bank_cost,
                           t.transfer_count,
                           t.transfer_amount,
                           t.transfer_fee,
                           t.transfer_bank_cost]--}%
       <g:each in="${list}" status="i" var="item">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td height=18 class=xl677821 align=right style='height:13.5pt;'>${item.get('AREA')}</td>
                    <td height=18 class=xl677821 align=right style='height:13.5pt;'>${item.get('CUS_NAME')}</td>
                    <td height=18 class=xl677821 align=right style='height:13.5pt;'>${item.get('CC')}</td>
                    <td height=18 class=xl727821 align=right style='height:13.5pt;'>${item.get('CS')?item.get('CS')/100:0}</td>
                    <td height=18 class=xl727821 align=right style='height:13.5pt;'>${item.get('CF')}</td>
                    <td height=18 class=xl727821 align=right style='height:13.5pt;'>${item.get('CBC')}</td>
                    <td height=18 class=xl677821 align=right style='height:13.5pt;'>${item.get('WC')}</td>
                    <td height=18 class=xl727821 align=right style='height:13.5pt;'>${item.get('WS')?item.get('WS')/100:0}</td>
                    <td height=18 class=xl727821 align=right style='height:13.5pt;'>${item.get('WF')}</td>
                    <td height=18 class=xl727821 align=right style='height:13.5pt;'>${item.get('WBC')}</td>
                    <td height=18 class=xl677821 align=right style='height:13.5pt;'>${item.get('TC')}</td>
                    <td height=18 class=xl727821 align=right style='height:13.5pt;'>${item.get('TS')?item.get('TS')/100:0}</td>
                    <td height=18 class=xl727821 align=right style='height:13.5pt;'>${item.get('TF')}</td>
                    <td height=18 class=xl727821 align=right style='height:13.5pt;'>${item.get('TBC')}</td>
                </tr>
      </g:each>

        <tr>
            <td class=xl637821>合计</td>
            <td class=xl637821></td>
            <td class=xl637821>${cC}</td>
            <td class=xl165>${cA}</td>
            <td class=xl165>${cF}</td>
            <td class=xl165>${cB}</td>
            <td class=xl637821>${wC}</td>
            <td class=xl165>${wA}</td>
            <td class=xl165>${wF}</td>
            <td class=xl165>${wB}</td>
            <td class=xl637821>${tC}</td>
            <td class=xl165>${tA}</td>
            <td class=xl165>${tF}</td>
            <td class=xl165>${tB}</td>
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
            <td width=86 style='width:65pt'></td>
            <td width=96 style='width:102pt'></td>
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
