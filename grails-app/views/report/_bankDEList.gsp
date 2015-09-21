<%@ page import=" boss.BoAcquirerAccount; ismp.TradeRefund" %>
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
        6760;width:41pt'>
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
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        3400;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        3400;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        3400;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        3400;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        3400;width:56pt'>

        <tr height=18 style='height:13.5pt'>
            <td height=28 class=xl637821 colspan=12 width=100 style='height:18.5pt;
            width:51pt;text-align:center'><font size="5"><b>按银行划分系统数据统计表</b></font></td>
            <td class=xl637821 width=75 style='width:56pt'></td>
            <td class=xl637821 colspan=2 width=169 style='width:127pt'></td>
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
            <td class=xl637821 style="text-align:left">导出时间:<g:formatDate date="${date}" format="yyyy-MM-dd"/></td>
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
        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td class=xl667821 style='border-left:none' rowspan="2">银行类贷记账户</td>
            <td height=18 class=xl667821 style='height:13.5pt;width:150px' rowspan="2">银行通道</td>
            <td class=xl667821 style='border-left:none' colspan="3">交易入账</td>
            <td class=xl667821 style='border-left:none' colspan="3">退款</td>
            <td class=xl667821 style='border-left:none' colspan="3">付款结算金额</td>
            <td class=xl667821 style='border-left:none' rowspan="2">银行手续费<br>（成本合计）</td>

        </tr>
        <tr>
            <td class=xl667821 style='border-left:none'>笔数</td>
            <td class=xl667821 style='border-left:none'>金额</td>
            <td class=xl667821 style='border-left:none'>银行手续费成本</td>

            <td class=xl667821 style='border-left:none'>笔数</td>
            <td class=xl667821 style='border-left:none'>金额</td>
            <td class=xl667821 style='border-left:none'>银行手续费成本</td>

            <td class=xl667821 style='border-left:none'>笔数</td>
            <td class=xl667821 style='border-left:none'>金额</td>
            <td class=xl667821 style='border-left:none'>银行手续费成本</td>
        </tr>

        <g:each in="${result1}" status="i" var="trade1">
            <% int j = 0; l = 0; m = 0; n = 0; flag = 0; %>
            <tr>
                <td rowspan="2" class=xl707821 style='border-left:none'>${trade1.NAME}</td>
                <td class=xl707821 style='border-left:none'>大额通道</td>
                <td class=xl717821 style='border-left:none'>
                    <g:each in="${result}" status="K5" var="trade5">
                        <g:if test="${trade5.NUM==trade1.NO && trade5.CHANNEL=='3'}">${trade5.CO}<% flag = 1 %></g:if>
                    </g:each>
                    <g:if test="${flag==0}">
                        0
                    </g:if>
                    <% flag = 0 %>
                </td>
                <td class=xl717821 style='border-left:none'>
                    <g:each in="${result}" status="K6" var="trade6">
                        <g:if test="${trade6.NUM==trade1.NO && trade6.CHANNEL=='3'}">${trade6.AM == null ? 0 : trade6.AM / 100}<% flag = 1 %></g:if>
                    </g:each>
                    <g:if test="${flag==0}">
                        0
                    </g:if>
                    <% flag = 0 %>
                </td>
                <td class=xl717821 style='border-left:none'>0</td>
                <td class=xl717821 style='border-left:none'>
                    <g:each in="${result2}" status="r4" var="refund4">
                        <g:if test="${refund4.NO==trade1.NO && refund4.CHANNEL=='3'}">${refund4.CO}<% flag = 1 %></g:if>
                    </g:each>
                    <g:if test="${flag==0}">
                        0
                    </g:if>
                    <% flag = 0 %>
                </td>
                <td class=xl717821 style='border-left:none'>
                    <g:each in="${result2}" status="r5" var="refund5">
                        <g:if test="${refund5.NO==trade1.NO && refund5.CHANNEL=='3'}">${refund5.AM == null ? 0 : refund5.AM / 100}<% flag = 1 %></g:if>
                    </g:each>
                    <g:if test="${flag==0}">
                        0
                    </g:if>
                    <% flag = 0 %>
                </td>
                <td class=xl717821 style='border-left:none'>0</td>
                <td rowspan="2" class=xl717821 style='border-left:none'>
                    <g:each in="${result3}" status="w" var="withdrawn">
                        <g:if test="${withdrawn.NO==trade1.NO }">${withdrawn.CO}<% flag = 1 %></g:if>
                    </g:each>
                    <g:if test="${flag==0}">
                        0
                    </g:if>
                    <% flag = 0 %>
                </td>
                <td rowspan="2" class=xl717821 style='border-left:none'>
                    <g:each in="${result3}" status="w" var="withdrawn">
                        <g:if test="${withdrawn.NO==trade1.NO }">${withdrawn.AM == null ? 0 : withdrawn.AM / 100}<% flag = 1 %></g:if>
                    </g:each>
                    <g:if test="${flag==0}">
                        0
                    </g:if>
                    <% flag = 0 %>
                </td>
                <td class=xl717821 style='border-left:none' rowspan="2">0</td>
                <td class=xl717821 style='border-left:none' rowspan="2">0</td>
            </tr>

            <tr>
                <td class=xl707821 style='border-left:none'>小计</td>
                <td class=xl717821 style='border-left:none'>

                    <g:each in="${result}" status="K7" var="trade7">
                        <g:if test="${trade7.NUM==trade1.NO }"><% j = j + trade7.CO %></g:if>
                    </g:each>
                    <font color="red"><%=j%></font>
                </td>
                <td class=xl717821 style='border-left:none'>
                    <g:each in="${result}" status="K8" var="trade8">
                        <g:if test="${trade8.NUM==trade1.NO }"><% l = l + trade8.AM / 100 %></g:if>
                    </g:each>
                    <font color="red"><%=l%></font>
                </td>
                <td class=xl717821 style='border-left:none'>0</td>
                <td class=xl717821 style='border-left:none'>
                    <% int %>
                    <g:each in="${result2}" status="r6" var="refund6">
                        <g:if test="${refund6.NO==trade1.NO }"><% m = m + refund6.CO %></g:if>
                    </g:each>
                    <font color="red"><%=m%></font>
                </td>
                <td class=xl717821 style='border-left:none'>
                    <g:each in="${result2}" status="r7" var="refund7">
                        <g:if test="${refund7.NO==trade1.NO }"><% n = n + refund7.AM / 100 %></g:if>
                    </g:each>
                    <font color="red"><%=n%></font>
                </td>
                <td class=xl717821 style='border-left:none'>0</td>

            </tr>
        </g:each>
        <tr>
            <td colspan="2" class=xl707821 style='border-left:none'>合计</td>
            <td class=xl717821 style='border-left:none'>${inTotalCo == null ? 0 : inTotalCo}</td>
            <td class=xl717821 style='border-left:none'>${inTotalAm == null ? 0 : inTotalAm / 100}</td>
            <td class=xl717821 style='border-left:none'>0</td>
            <td class=xl717821 style='border-left:none'>${totalCo == null ? 0 : totalCo}</td>
            <td class=xl717821 style='border-left:none'>${totalAm == null ? 0 : totalAm / 100}</td>
            <td class=xl717821 style='border-left:none'>0</td>
            <td class=xl717821 style='border-left:none'>${totalWithdrawnCo == null ? 0 : totalWithdrawnCo}</td>
            <td class=xl717821 style='border-left:none'>${totalWithdrawnAm == null ? 0 : totalWithdrawnAm / 100}</td>
            <td class=xl717821 style='border-left:none'>0</td>
            <td class=xl717821 style='border-left:none'>0</td>
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
