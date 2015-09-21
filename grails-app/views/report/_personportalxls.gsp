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
            width:51pt'>吉高个人门户类统计报表<span style='mso-spacerun:yes'>&nbsp;</span></td>
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
            <td class=xl667821 style='border-left:none' rowspan="2">客户数量</td>
            <td class=xl667821 style='border-left:none' rowspan="2">初期余额</td>
            <td class=xl667821 style='border-left:none' colspan="2">充值</td>
            <td class=xl667821 style='border-left:none' colspan="2">支付</td>
            <td class=xl667821 style='border-left:none' colspan="2">提现</td>
            <td class=xl667821 style='border-left:none' colspan="2">退款</td>
            <td class=xl667821 style='border-left:none' colspan="2">转账</td>
            <td class=xl667821 style='border-left:none' rowspan="2">手续费收入</td>
            <td class=xl667821 style='border-left:none' rowspan="2">银行成本</td>
            <td class=xl667821 style='border-left:none' rowspan="2">期末余额</td>
          </tr>
          <tr>
            <td class=xl667821 style='border-left:none'>笔数</td>
            <td class=xl667821 style='border-left:none'>金额</td>
            <td class=xl667821 style='border-left:none'>笔数</td>
            <td class=xl667821 style='border-left:none'>金额</td>
            <td class=xl667821 style='border-left:none'>笔数</td>
            <td class=xl667821 style='border-left:none'>金额</td>
            <td class=xl667821 style='border-left:none'>笔数</td>
            <td class=xl667821 style='border-left:none'>金额</td>
            <td class=xl667821 style='border-left:none'>笔数</td>
            <td class=xl667821 style='border-left:none'>金额</td>
          </tr>

        <tr height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>${totalCus?totalCus:""}</td>
            <td height=18 class=xl727821 align=right style='height:13.5pt;'>${intBa?intBa/100:0}</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>${chargeC}</td>
            <td height=18 class=xl727821 align=right style='height:13.5pt;'>${chargeM?chargeM/100:0}</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>${paymentC}</td>
            <td height=18 class=xl727821 align=right style='height:13.5pt;'>${paymentM?paymentM/100:0}</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>${withdrawnC}</td>
            <td height=18 class=xl727821 align=right style='height:13.5pt;'>${withdrawnM?withdrawnM/100:0}</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>${refundC}</td>
            <td height=18 class=xl727821 align=right style='height:13.5pt;'>${refundM?refundM/100:0}</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'>${transferC}</td>
            <td height=18 class=xl727821 align=right style='height:13.5pt;'>${transferM?transferM/100:0}</td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'></td>
            <td height=18 class=xl677821 align=right style='height:13.5pt;'></td>
            <td height=18 class=xl727821 align=right style='height:13.5pt;'>${lastBa?lastBa/100:0}</td>

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
        %{--<tr class=xl637821 height=18 style='height:13.5pt'>--}%
            %{--<td height=18 class=xl667821 style='height:13.5pt;width:150px'>交易流水号</td>--}%
            %{--<td class=xl667821 style='border-left:none'>原交易时间</td>--}%
            %{--<td class=xl667821 style='border-left:none'>申请时间</td>--}%
            %{--<td class=xl667821 style='border-left:none'>退款人名称</td>--}%
            %{--<td class=xl667821 style='border-left:none'>退款人账户</td>--}%
            %{--<td class=xl667821 style='border-left:none'>原订单金额</td>--}%
            %{--<td class=xl667821 style='border-left:none'>退款金额</td>--}%
            %{--<td class=xl667821 style='border-left:none'>银行订单号</td>--}%
            %{--<td class=xl667821 style='border-left:none'>处理状态</td>--}%
        %{--</tr>--}%
        %{--<g:each in="${tradeRefundInstanceList}" status="i" var="tradeRefundInstance">--}%
            %{--<tr height=18 style='height:13.5pt'>--}%
                %{--<td height=18 class=xl677821 align=right style='height:13.5pt;'>${tradeRefundInstance.tradeNo}</td>--}%

            %{--<g:if test="${tradeRefundInstance.partnerId==null}">--}%
                %{--<td class=xl677821 align=right style='border-left:none'>--}%
                    %{--<g:formatDate date="${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'charge')?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/>--}%
                %{--</td>--}%
            %{--</g:if>--}%
            %{--<g:elseif test="${tradeRefundInstance.partnerId!=null}">--}%
                %{--<td class=xl677821 align=right style='border-left:none'>--}%
                    %{--<g:formatDate date="${TradePayment.findByRootIdAndTradeType(tradeRefundInstance.rootId,'payment')?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/>--}%
                %{--</td>--}%
            %{--</g:elseif>--}%
            %{--<g:else>--}%
                %{--<td class=xl677821 align=right style='border-left:none'></td>--}%
            %{--</g:else>--}%

            %{--<td class=xl707821 style='border-left:none'><g:formatDate date="${tradeRefundInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>--}%
            %{--<td class=xl707821 style='border-left:none'>${tradeRefundInstance?.payerName}</td>--}%
            %{--<td class=xl707821 style='border-left:none'>${tradeRefundInstance.payerAccountNo}</td>--}%
            %{--<g:if test="${tradeRefundInstance.partnerId==null}">--}%
            %{--<g:if test="${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'charge')?.amount>0}">--}%
                %{--<td class=xl727821 style='border-left:none'>${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'charge')?.amount/100}</td>--}%
            %{--</g:if>--}%
        %{--</g:if>--}%
            %{--<g:elseif test="${tradeRefundInstance.partnerId!=null}">--}%
                %{--<g:if test="${TradePayment.get(tradeRefundInstance.originalId)?.amount>0}">--}%
                    %{--<td class=xl727821 style='border-left:none'>${TradePayment.get(tradeRefundInstance.originalId)?.amount/100}</td>--}%
                %{--</g:if>--}%
            %{--</g:elseif>--}%
            %{--<g:else>--}%
                %{--<td class=xl707821 style='border-left:none'></td>--}%
            %{--</g:else>--}%
            %{--<td class=xl727821 style='border-left:none'>${tradeRefundInstance?.amount / 100}</td>--}%
            %{--<td class=xl707821 style='border-left:none'>${GwTransaction.get(TradeCharge.findByRootId(tradeRefundInstance.rootId)?.tradeNo)?.bankTransNo}</td>--}%
            %{--<td class=xl707821 style='border-left:none'>${TradeRefund.handleStatusMap[tradeRefundInstance?.handleStatus]}</td>--}%
            %{--</tr>--}%
        %{--</g:each>--}%
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
