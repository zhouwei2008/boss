<%@ page import="ismp.CmCorporationInfo; ismp.CmCustomer; boss.ReportAgentpayDaily" %>
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
        6760;width:23pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        3400;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        3400;width:56pt'>
        <col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:
        3704;width:110pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        3536;width:130pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        3400;width:56pt'>
        <col class=xl637821 width=55 style='mso-width-source:userset;mso-width-alt:
        3760;width:41pt'>
        <col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:
        3704;width:110pt'>
        <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
        3536;width:130pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        3400;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        3400;width:56pt'>

        <tr height=18 style='height:13.5pt'>
            <td height=28 class=xl637821 colspan=11 style='height:18.5pt;text-align:center'><font size="5"><b><g:if test="${params.tradeType == 'S'}">代收</g:if><g:else>代付</g:else>${message(code: 'reportAgentpayDaily.label', default: '')}</b></font></td>
        </tr>
        <tr height=18 style='height:13.5pt'>
            <td class=xl637821 style="text-align:left">导出时间:<g:formatDate date="${date}" format="yyyy-MM-dd HH:mm:ss"/></td>
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
        <tr height=18 style='height:13.5pt'>
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
            <td class=xl667821 style='border-left:none' rowspan="2">${message(code: 'reportAgentpayDaily.customerRegion.label', default: '')}</td>
            <td class=xl667821 style='border-left:none' rowspan="2">${message(code: 'reportAgentpayDaily.customerName.label', default: '')}</td>
            <td class=xl667821 style='border-left:none' colspan="10"><g:if test="${params.tradeType == 'S'}">代收</g:if><g:else>代付</g:else></td>
        </tr>
        <tr>
            <td class=xl667821 style='border-left:none'><g:if test="${params.tradeType == 'S'}">代收</g:if><g:else>代付</g:else>${message(code: 'reportAgentpayDaily.count.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'><g:if test="${params.tradeType == 'S'}">代收</g:if><g:else>代付</g:else>${message(code: 'reportAgentpayDaily.amount.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'><g:if test="${params.tradeType == 'S'}">代收</g:if><g:else>代付</g:else>${message(code: 'reportAgentpayDaily.tradeCountSuccess.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'><g:if test="${params.tradeType == 'S'}">代收</g:if><g:else>代付</g:else>${message(code: 'reportAgentpayDaily.tradeAmountSuccess.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'><g:if test="${params.tradeType == 'S'}">代收</g:if><g:else>代付</g:else>${message(code: 'reportAgentpayDaily.tradeCountFail.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'><g:if test="${params.tradeType == 'S'}">代收</g:if><g:else>代付</g:else>${message(code: 'reportAgentpayDaily.tradeAmountFail.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'>${message(code: 'reportAgentpayDaily.tradeSettleAmount.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'>${message(code: 'reportAgentpayDaily.tradeSettleFee.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'>${message(code: 'reportAgentpayDaily.bankfee.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'>${message(code: 'reportAgentpayDaily.netAmount.label', default: '')}</td>
        </tr>

        <g:each in="${reportAgentpayDailyInstanceList}" status="i" var="instance">
                <tr>
                    <td class=xl707821 style='border-left:none'>${CmCorporationInfo.get(instance.CUSTOMER_ID)?.belongToArea}</td>
                    <td class=xl707821 style='border-left:none'>${CmCustomer.get(instance.CUSTOMER_ID)?.name}</td>
                    <td class=xl717821 style='border-left:none'>${instance.CC?instance.CC:0}</td>
                    <td class=xl717821 style='border-left:none'><g:formatNumber number="${instance.AA?(instance.AA as Long)/100:0.00}" format="#.##"/></td>
                    <td class=xl717821 style='border-left:none'>${instance.CS?instance.CS:0}</td>
                    <td class=xl717821 style='border-left:none'><g:formatNumber number="${instance.TS?(instance.TS as Long)/100:0.00}" format="#.##"/></td>
                    <td class=xl717821 style='border-left:none'>${instance.CF?instance.CF:0}</td>
                    <td class=xl717821 style='border-left:none'><g:formatNumber number="${instance.AF?(instance.AF as Long)/100:0.00}" format="#.##"/></td>
                    <td class=xl717821 style='border-left:none'><g:formatNumber number="${instance.SA?(instance.SA as Long)/100:0.00}" format="#.##"/></td>
                    <td class=xl717821 style='border-left:none'><g:formatNumber number="${instance.SF?(instance.SF as Long)/100:0.00}" format="#.##"/></td>
                    <td class=xl717821 style='border-left:none'>&nbsp;</td>
                    <td class=xl717821 style='border-left:none'><g:formatNumber number="${instance.SN?(instance.SN as Long)/100:0.00}" format="#.##"/></td>
                </tr>
            </g:each>
            <tr>
                <td colspan="2" class=xl707821 style='border-left:none'>合计:${reportAgentpayDailyInstanceTotal}</td>
                <td class=xl717821 style='border-left:none'>${totalAgent.tcc?totalAgent.tcc:0}</td>
                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.taa?(totalAgent.taa as Long)/100:0.00}" format="#.##"/></td>
                <td class=xl717821 style='border-left:none'>${totalAgent.tcs?totalAgent.tcs:0}</td>
                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tts?(totalAgent.tts as Long)/100:0.00}" format="#.##"/></td>
                <td class=xl717821 style='border-left:none'>${totalAgent.tcf?totalAgent.tcf:0}</td>
                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.taf?(totalAgent.taf as Long)/100:0.00}" format="#.##"/></td>
                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tsa?(totalAgent.tsa as Long)/100:0.00}" format="#.##"/></td>
                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tsf?(totalAgent.tsf as Long)/100:0.00}" format="#.##"/></td>
                <td class=xl717821 style='border-left:none'>&nbsp;</td>
                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tsn?(totalAgent.tsn as Long)/100:0.00}" format="#.##"/></td>
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
