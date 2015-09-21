<%@ page import="boss.BoMerchant; boss.AppNote; boss.BoAcquirerAccount; boss.BoBankDic; ismp.TradeBase; gateway.GwTransaction; ismp.TradeCharge; ismp.TradePayment; ismp.TradeRefund" %>
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
        2760;width:41pt'>
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
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>
        <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
        5400;width:56pt'>
        <tr height=18 style='height:13.5pt'>
            <td height=28 class=xl637821 colspan=12 width=100 style='height:18.5pt;width:51pt;text-align:center'><font size="5"><b>退款历史查询</b></font></td>
            <td class=xl637821 width=75 style='width:56pt'></td>
            <td class=xl637821 width=169 style='width:127pt'></td>
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
            <td height=18 class=xl637821 style='height:13.5pt'>导出时间:${new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date())}</td>
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
            <td height=18 class=xl637821 style='height:13.5pt'>汇总信息</td>
            <td class=xl637821 colspan="2">退款金额汇总：${refundAmount == null ? 0 : refundAmount / 100}</td>
            <td class=xl637821>记录条数汇总：${total == null ? 0 : total}</td>
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
        %{--<tr height=18 style='height:13.5pt'>--}%
        %{--<td height=18 class=xl637821 style='height:13.5pt'></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--<td class=xl637821></td>--}%
        %{--</tr>--}%
        <tr class=xl637821 height=18 style='height:13.5pt'>
            <td class=xl667821 style='border-left:none'>序号</td>
            <td class=xl667821 style='border-left:none'>批次号</td>
            <td height=18 class=xl667821 style='height:13.5pt;width:150px'>交易流水号</td>
            <td class=xl667821 style='border-left:none'>退款客户名称</td>
            <td class=xl667821 style='border-left:none'>退款客户账户</td>

            <td class=xl667821 style='border-left:none'>原银行订单号</td>
            <td class=xl667821 style='border-left:none'>原订单金额</td>
            <td class=xl667821 style='border-left:none'>原订单支付时间</td>
            <td class=xl667821 style='border-left:none'>退款金额</td>
            <td class=xl667821 style='border-left:none'>支付方式</td>
            <td class=xl667821 style='border-left:none'>支付银行</td>

            <td class=xl667821 style='border-left:none'>退款银行</td>
            <td class=xl667821 style='border-left:none'>申请时间</td>
            <td class=xl667821 style='border-left:none'>终审时间</td>
            <td class=xl667821 style='border-left:none'>退款状态</td>

        </tr>
        <g:each in="${tradeRefundInstanceList}" status="i" var="tradeRefundInstance">
            <tr height=18 style='height:13.5pt'>
                <td class=xl717821 align=right style='border-left:none'>${i + 1}</td>
                <td class=xl707821 style='border-left:none'>${tradeRefundInstance?.refundBatchNo}</td>
                <td height=18 class=xl707821 align=right style='height:13.5pt;'>${tradeRefundInstance?.tradeNo}</td>
                <td class=xl717821 style='border-left:none'>${tradeRefundInstance?.payerName}</td>
                <td class=xl707821 style='border-left:none'>${tradeRefundInstance?.payerAccountNo}</td>


                <td class=xl707821 style='border-left:none'>${GwTransaction.get(TradeCharge.findByRootId(tradeRefundInstance.rootId)?.tradeNo)?.bankTransNo}</td>
                <g:if test="${tradeRefundInstance.partnerId==null}">
                    <g:if test="${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId,'charge')?.amount>0}">
                        <td class=xl717821 style='border-left:none'>${TradeBase.findByRootIdAndTradeType(tradeRefundInstance.rootId, 'charge')?.amount / 100}</td>
                    </g:if>
                </g:if>
                <g:elseif test="${tradeRefundInstance.partnerId!=null}">
                    <g:if test="${TradePayment.get(tradeRefundInstance.originalId)?.amount>0}">
                        <td class=xl717821 style='border-left:none'>${TradePayment.get(tradeRefundInstance.originalId)?.amount / 100}</td>
                    </g:if>
                </g:elseif>
                <g:else>
                    <td class=xl707821 style='border-left:none'></td>
                </g:else>
                %{--增加原订单支付时间 as sunweiguo 2012-08-10--}%
                <td class=xl707821 style='border-left:none'><g:formatDate date="${ismp.TradeBase.findByRootIdAndTradeTypeInList(tradeRefundInstance.rootId,['payment','charge'])?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>

                <td class=xl717821 style='border-left:none'>${tradeRefundInstance?.amount / 100}</td>
                <td class=xl707821 style='border-left:none'>${TradeRefund.channelMap[tradeRefundInstance?.channel]}</td>
                <g:if test="${tradeRefundInstance.acquirerMerchantNo!=null && tradeRefundInstance.acquirerMerchantNo!=''}">
                    <td class=xl707821 style='border-left:none'>${BoBankDic.get(BoAcquirerAccount.get(BoMerchant.findByAcquireMerchant(tradeRefundInstance.acquirerMerchantNo)?.acquirerAccount?.id)?.bank?.id)?.name}</td>
                </g:if>
                <g:else>
                    <td class=xl707821 style='border-left:none'></td>
                </g:else>


                <td class=xl707821 style='border-left:none'>${BoBankDic.get(BoAcquirerAccount.get(tradeRefundInstance?.acquirer_account_id)?.bank?.id)?.name}</td>
                <td class=xl707821 style='border-left:none'><g:formatDate date="${tradeRefundInstance?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
                <td class=xl707821 style='border-left:none'><g:formatDate date="${tradeRefundInstance?.lastAppDate}" format="yyyy-MM-dd HH:mm:ss"/></td>
                <td class=xl707821 style='border-left:none'>${TradeRefund.handleStatusMap[tradeRefundInstance?.handleStatus]}</td>

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
        </tr>
        <![endif]>
    </table>

</div>


<!----------------------------->
<!--“从 EXCEL 发布网页”向导结束-->
<!----------------------------->
</body>

</html>
