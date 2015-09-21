<%@ page import="gateway.GwOrder; boss.BoMerchant; boss.BoAcquirerAccount; ismp.TradeTransfer; ismp.TradeCharge; ismp.TradePayment; gateway.GwTransaction; ismp.TradeBase" %>
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
        1760;width:41pt'>
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
        5704;width:110pt'>
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
            <td height=18 class=xl637821 colspan=2 width=100 style='height:13.5pt;
            width:51pt'>交易查询下载<span style='mso-spacerun:yes'>&nbsp;</span></td>
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
        <tr height=18 style='height:13.5pt'>
            %{--<td height=18 class=xl637821 style='height:13.5pt'></td>--}%
            <td class=xl637821>汇总信息：</td>
            <td class=xl637821></td>
            <td class=xl637821>金额总计：</td>
            <td class=xl165>${totalAmount == null ? 0 : totalAmount / 100}</td>
            <td class=xl637821>支付金额：</td>
            <td class=xl165>${payAmount == null ? 0 : payAmount / 100}</td>
            <td class=xl637821>转账金额：</td>
            <td class=xl165>${transferAmount == null ? 0 : transferAmount / 100}</td>
            <td class=xl637821>退款金额：</td>
            <td class=xl165>${refundAmount == null ? 0 : refundAmount / 100}</td>
            <td class=xl637821>充值金额：</td>
            <td class=xl165>${chargeAmount == null ? 0 : chargeAmount / 100}</td>
            <td class=xl637821>提现金额：</td>
            <td class=xl165>${withdrawnAmount == null ? 0 : withdrawnAmount / 100}</td>
            <td class=xl637821>分润金额：</td>
            <td class=xl165>${royaltyAmount == null ? 0 : royaltyAmount / 100}</td>
            <td class=xl637821>退分润金额：</td>
            <td class=xl165>${royalty_rfdAmount == null ? 0 : royalty_rfdAmount / 100}</td>
            <td class=xl637821>冻结金额：</td>
            <td class=xl165>${frozenAmount == null ? 0 : frozenAmount / 100}</td>
            <td class=xl637821>解冻结金额：</td>
            <td class=xl165>${unfrozenAmount == null ? 0 : unfrozenAmount / 100}</td>
            <td class=xl637821></td>
            <td class=xl637821></td>
        </tr>

        <tr height=18 style='height:13.5pt'>
            %{--<td height=18 class=xl637821 style='height:13.5pt'></td>--}%
            <td class=xl637821></td>
            <td class=xl637821></td>
            <td class=xl637821>数量总计：</td>
            <td class=xl637821>${total == null ? 0 : total}</td>
            <td class=xl637821>支付数量：</td>
            <td class=xl637821>${payCount == null ? 0 : payCount}</td>
            <td class=xl637821>转账数量：</td>
            <td class=xl637821>${transferCount == null ? 0 : transferCount}</td>
            <td class=xl637821>退款数量：</td>
            <td class=xl637821>${refundCount == null ? 0 : refundCount}</td>
            <td class=xl637821>充值数量：</td>
            <td class=xl637821>${chargeCount == null ? 0 : chargeCount}</td>
            <td class=xl637821>提现数量：</td>
            <td class=xl637821>${withdrawnCount == null ? 0 : withdrawnCount}</td>
            <td class=xl637821>分润数量：</td>
            <td class=xl637821>${royaltyCount == null ? 0 : royaltyCount}</td>
            <td class=xl637821>退分润数量：</td>
            <td class=xl637821>${royalty_rfdCount == null ? 0 : royalty_rfdCount}</td>
            <td class=xl637821>冻结数量：</td>
            <td class=xl637821>${frozenCount == null ? 0 : frozenCount}</td>
            <td class=xl637821>解冻结数量：</td>
            <td class=xl637821>${unfrozenCount == null ? 0 : unfrozenCount}</td>
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
            <td class=xl667821 style='border-left:none'>序号</td>
            <td height=18 class=xl667821 style='height:13.5pt;width:150px'>交易流水号</td>
            <td class=xl667821 style='border-left:none'>外部交易号</td>
            <td class=xl667821 style='border-left:none'>银行订单号</td>
            <td class=xl667821 style='border-left:none'>创建时间</td>
            <td class=xl667821 style='border-left:none'>交易客户号</td>

            <td class=xl667821 style='border-left:none'>交易账户</td>
            <td class=xl667821 style='border-left:none'>交易时间</td>
            <td class=xl667821 style='border-left:none'>付款客户</td>
          
            <td class=xl667821 style='border-left:none'>付款账户</td>

            <td class=xl667821 style='border-left:none'>收款客户</td>
            <td class=xl667821 style='border-left:none'>收款账户</td>
            <td class=xl667821 style='border-left:none'>交易客户</td>
            <td class=xl667821 style='border-left:none'>交易类型</td>
            <td class=xl667821 style='border-left:none'>服务类型</td>

            <td class=xl667821 style='border-left:none'>交易状态</td>
            <td class=xl667821 style='border-left:none'>支付方式</td>
            <td class=xl667821 style='border-left:none'>订单金额</td>
            <td class=xl667821 style='border-left:none'>交易手续费</td>
            <td class=xl667821 style='border-left:none'>交易金额</td>
            <td class=xl667821 style='border-left:none'>完成时间</td>

            <td class=xl667821 style='border-left:none'>银行通道</td>
            <td class=xl667821 style='border-left:none'>渠道编码</td>
            <td class=xl667821 style='border-left:none'>交易摘要</td>
            <td class=xl667821 style='border-left:none'>交易备注</td>
        </tr>
        <g:each in="${tradeBaseInstanceList}" status="i" var="tradeBaseInstance">
            <tr height=18 style='height:13.5pt'>
                <td height=18 class=xl707821 align=right style='height:13.5pt;'>${i + 1}</td>
                <td height=18 class=xl677821 align=right style='height:13.5pt;'>${tradeBaseInstance.tradeNo}</td>
                <td class=xl707821 style='border-left:none'>${tradeBaseInstance.outTradeNo}</td>
                 <td class=xl707821 style='border-left:none'>
                    <g:if test="${tradeBaseInstance.tradeType== 'payment' }">
                        ${GwTransaction.findWhere(order:GwOrder.get(tradeBaseInstance.tradeNo))?.bankTransNo}
                    </g:if>
                    <g:else>
                        &nbsp;
                    </g:else>
                </td>
                <td class=xl677821 align=right style='border-left:none'><g:formatDate date="${tradeBaseInstance.dateCreated}" format="yyyy-MM-dd HH:mm:ss"></g:formatDate></td>
                <td class=xl707821 style='border-left:none'>${tradeBaseInstance.partner?.customerNo}</td>

                <td class=xl707821 style='border-left:none'>${tradeBaseInstance.partner?.accountNo}</td>
                <td class=xl707821 align=right style='border-left:none'>${String.valueOf(tradeBaseInstance.tradeDate).substring(0,4) + '-' + String.valueOf(tradeBaseInstance.tradeDate).substring(4,6) + '-' + String.valueOf(tradeBaseInstance.tradeDate).substring(6,8)}</td>
                <td class=xl707821 style='border-left:none'>${tradeBaseInstance?.payerName}</td>
               
                <td class=xl707821 style='border-left:none'>${tradeBaseInstance?.payerName}</td>

                <td class=xl707821 style='border-left:none'>${tradeBaseInstance?.payeeName}</td>
                <td class=xl707821 style='border-left:none'>${tradeBaseInstance?.payeeName}</td>
                <td class=xl707821 style='border-left:none'>${tradeBaseInstance.partner?.name}</td>
                <td class=xl707821 style='border-left:none'>${TradeBase.tradeTypeMap[tradeBaseInstance.tradeType]}</td>
                <td class=xl707821 style='border-left:none'>${TradeBase.serviceTypeMap[tradeBaseInstance.serviceType]}</td>

                <td class=xl707821 style='border-left:none'>${TradeBase.statusMap[tradeBaseInstance.status]}</td>
                <td class=xl707821 style='border-left:none'>${TradeBase.paymentTypeMap[tradeBaseInstance.paymentType]}</td>
                <td class=xl727821 style='border-left:none'>${tradeBaseInstance.amount == null ? 0 : (tradeBaseInstance.amount-(tradeBaseInstance.feeAmount==null?0:tradeBaseInstance.feeAmount)) / 100}</td>
                <td class=xl727821 style='border-left:none'>${tradeBaseInstance.feeAmount == null ? 0 : tradeBaseInstance.feeAmount / 100}</td>
                <td class=xl727821 style='border-left:none'>${tradeBaseInstance.amount == null ? 0 : tradeBaseInstance.amount / 100}</td>
                <td class=xl707821 align=right style='border-left:none'><g:formatDate date="${tradeBaseInstance.lastUpdated}" format="yyyy-MM-dd HH:mm:ss"></g:formatDate></td>
                <td class=xl707821 style='border-left:none'>
                    <g:if test="${tradeBaseInstance.tradeType== 'payment' }">
                        ${GwTransaction.findWhere(order:GwOrder.get(tradeBaseInstance.tradeNo))?.acquirerName}
                    </g:if>
                    <g:if test="${tradeBaseInstance.tradeType== 'charge' }">
                        ${GwTransaction.findWhere(id:tradeBaseInstance.tradeNo)?.acquirerName}
                    </g:if>
                </td>
                 <td class=xl707821 style='border-left:none'>
                    <g:if test="${tradeBaseInstance.tradeType== 'payment' }">
                        ${GwTransaction.findWhere(order:GwOrder.get(tradeBaseInstance.tradeNo))?.gwServiceCode}
                    </g:if>
                    <g:if test="${tradeBaseInstance.tradeType== 'charge' }">
                        ${GwTransaction.findWhere(id:tradeBaseInstance.tradeNo)?.gwServiceCode}
                    </g:if>
                </td>
                <td class=xl707821 style='border-left:none'>${tradeBaseInstance?.subject}</td>
                <td class=xl707821 style='border-left:none'>${tradeBaseInstance?.note}</td>

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
