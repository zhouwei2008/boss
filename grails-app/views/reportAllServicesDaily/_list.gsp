<%@ page import="boss.ReportAllServicesDaily; ismp.CmCorporationInfo; ismp.CmCustomer; boss.ReportAgentpayDaily" %>
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
            <td height=28 class=xl637821 colspan=11 style='height:18.5pt;text-align:center'><font size="5"><b>${message(code: 'reportAllServicesDaily.label', default: '')}</b></font></td>
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
            <td class=xl667821 style='border-left:none' rowspan="2">${message(code: 'reportAllServicesDaily.customerRegion.label', default: '')}</td>
            <td class=xl667821 style='border-left:none' rowspan="2">${message(code: 'reportAllServicesDaily.customerName.label', default: '')}</td>
            <g:each in="${params.serviceType}" status="ie" var="ite">
                   <td class=xl667821 style='border-left:none' colspan="4">${ReportAllServicesDaily.serviceMap.get(ite)}</td>
             </g:each>
            <td class=xl667821 style='border-left:none' colspan="4">${message(code: 'reportAllServicesDaily.total.label', default: '')}</td>
        </tr>
        <tr>
            <g:each in="${params.serviceType}" status="ip" var="itp">
            <td class=xl667821 style='border-left:none'>${message(code: 'reportAllServicesDaily.tradeCount.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'>${message(code: 'reportAllServicesDaily.tradeNetAmount.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'>${message(code: 'reportAllServicesDaily.tradeNetFee.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'>${message(code: 'reportAllServicesDaily.tradeBankFee.label', default: '')}</td>
            </g:each>
            <td class=xl667821 style='border-left:none'>${message(code: 'reportAllServicesDaily.tradeCountTotal.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'>${message(code: 'reportAllServicesDaily.tradeNetAmountTotal.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'>${message(code: 'reportAllServicesDaily.tradeNetFeeTotal.label', default: '')}</td>
            <td class=xl667821 style='border-left:none'>${message(code: 'reportAllServicesDaily.tradeBankFeeTotal.label', default: '')}</td>
        </tr>

        <g:each in="${reportAllServicesDailyInstanceList}" status="im" var="instance">
                <tr>
                    <td class=xl707821 style='border-left:none'>${CmCorporationInfo.get(instance.CUSTOMER_ID)?.belongToArea}</td>
                    <td class=xl707821 style='border-left:none'>${CmCustomer.get(instance.CUSTOMER_ID)?.name}</td>
                    <g:each in="${params.serviceType}" status="iw" var="itw">
                        <g:if test="${itw == 'online'}">
                                    <td class=xl707821 style='border-left:none'>${instance.OC?instance.OC:0}</td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.OA?(instance.OA as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.NF?(instance.NF as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'>&nbsp;</td>
                        </g:if>
                        <g:if test="${itw == 'royalty'}">
                                    <td class=xl707821 style='border-left:none'>${instance.RC?instance.RC:0}</td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.RA?(instance.RA as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.RF?(instance.RF as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'>&nbsp;</td>
                        </g:if>
                        <g:if test="${itw == 'agentcoll'}">
                                    <td class=xl707821 style='border-left:none'>${instance.SC?instance.SC:0}</td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.SA?(instance.SA as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.SF?(instance.SF as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'>&nbsp;</td>
                        </g:if>
                        <g:if test="${itw == 'agentpay'}">
                                    <td class=xl707821 style='border-left:none'>${instance.FC?instance.FC:0}</td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.FA?(instance.FA as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.FF?(instance.FF as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'>&nbsp;</td>
                        </g:if>
                        <g:if test="${itw == 'transfer'}">
                                    <td class=xl707821 style='border-left:none'>${instance.TC?instance.TC:0}</td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.TA?(instance.TA as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.TF?(instance.TF as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'>&nbsp;</td>
                        </g:if>
                        <g:if test="${itw == 'charge'}">
                                    <td class=xl707821 style='border-left:none'>${instance.CC?instance.CC:0}</td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.CA?(instance.CA as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.CF?(instance.CF as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'>&nbsp;</td>
                        </g:if>
                        <g:if test="${itw == 'withdrawn'}">
                                    <td class=xl707821 style='border-left:none'>${instance.WC?instance.WC:0}</td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.WA?(instance.WA as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.WF?(instance.WF as Long)/100:0.00}" format="#.##"/></td>
                                    <td class=xl707821 style='border-left:none'>&nbsp;</td>
                        </g:if>
                    </g:each>
                    <td class=xl707821 style='border-left:none'>${instance.SAC?instance.SAC:0}</td>
                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.SAA?(instance.SAA as Long)/100:0.00}" format="#.##"/></td>
                    <td class=xl707821 style='border-left:none'><g:formatNumber number="${instance.SAF?(instance.SAF as Long)/100:0.00}" format="#.##"/></td>
                    <td class=xl707821 style='border-left:none'>&nbsp;</td>
                </tr>
            </g:each>
            <tr>
                <td colspan="2" class=xl717821 style='border-left:none'>合计:${reportAllServicesDailyInstanceTotal}</td>
                 <g:each in="${params.serviceType}" status="iu" var="itt">
                    <g:if test="${itt == 'online'}">
                        <td class=xl717821 style='border-left:none'>${totalAgent.toc?totalAgent.toc:0}</td>
                        <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.toa?(totalAgent.toa as Long)/100:0.00}" format="#.##"/></td>
                        <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tnf?(totalAgent.tnf as Long)/100:0.00}" format="#.##"/></td>
                        <td class=xl717821 style='border-left:none'>&nbsp;</td>
		            </g:if>
		            <g:if test="${itt == 'royalty'}">
                        <td class=xl717821 style='border-left:none'>${totalAgent.trc?totalAgent.trc:0}</td>
                        <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tra?(totalAgent.tra as Long)/100:0.00}" format="#.##"/></td>
                        <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.trf?(totalAgent.trf as Long)/100:0.00}" format="#.##"/></td>
                        <td class=xl717821 style='border-left:none'>&nbsp;</td>
		            </g:if>
		            <g:if test="${itt == 'agentcoll'}">
                        <td class=xl717821 style='border-left:none'>${totalAgent.tsc?totalAgent.tsc:0}</td>
                        <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tsa?(totalAgent.tsa as Long)/100:0.00}" format="#.##"/></td>
                        <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tsf?(totalAgent.tsf as Long)/100:0.00}" format="#.##"/></td>
                        <td class=xl717821 style='border-left:none'>&nbsp;</td>
		            </g:if>
		            <g:if test="${itt == 'agentpay'}">
                        <td class=xl717821 style='border-left:none'>${totalAgent.tfc?totalAgent.tfc:0}</td>
                        <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tfa?(totalAgent.tfa as Long)/100:0.00}" format="#.##"/></td>
                        <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tff?(totalAgent.tff as Long)/100:0.00}" format="#.##"/></td>
                        <td class=xl717821 style='border-left:none'>&nbsp;</td>
                    </g:if>
                    <g:if test="${itt == 'transfer'}">
                                <td class=xl717821 style='border-left:none'>${totalAgent.ttc?totalAgent.ttc:0}</td>
                                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tta?(totalAgent.tta as Long)/100:0.00}" format="#.##"/></td>
                                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.ttf?(totalAgent.ttf as Long)/100:0.00}" format="#.##"/></td>
                                <td class=xl717821 style='border-left:none'>&nbsp;</td>
                    </g:if>
                    <g:if test="${itt == 'charge'}">
                                <td class=xl717821 style='border-left:none'>${totalAgent.tcc?totalAgent.tcc:0}</td>
                                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tca?(totalAgent.tca as Long)/100:0.00}" format="#.##"/></td>
                                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tcf?(totalAgent.tcf as Long)/100:0.00}" format="#.##"/></td>
                                <td class=xl717821 style='border-left:none'>&nbsp;</td>
                    </g:if>
                    <g:if test="${itt == 'withdrawn'}">
                                <td class=xl717821 style='border-left:none'>${totalAgent.twc?totalAgent.twc:0}</td>
                                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.twa?(totalAgent.twa as Long)/100:0.00}" format="#.##"/></td>
                                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.twf?(totalAgent.twf as Long)/100:0.00}" format="#.##"/></td>
                                <td class=xl717821 style='border-left:none'>&nbsp;</td>
                    </g:if>
                  </g:each>

                <td class=xl717821 style='border-left:none'>${totalAgent.tsac?(totalAgent.tsac as Long):0}</td>
                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tsaa?(totalAgent.tsaa as Long)/100:0.00}" format="#.##"/></td>
                <td class=xl717821 style='border-left:none'><g:formatNumber number="${totalAgent.tsaf?(totalAgent.tsaf as Long)/100:0.00}" format="#.##"/></td>
                <td class=xl717821 style='border-left:none'>&nbsp;</td>
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
