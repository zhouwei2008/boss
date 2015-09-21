<%@ page import="pay.PtbPayTrade; pay.PtbPayBatch; dsf.TbPcInfo; dsf.TbAgentpayDetailsInfo; dsf.TbAgentpayDetailsInfo;boss.BoAcquirerAccount" %>
<html xmlns:o="urn:schemas-microsoft-com:office:office"
        xmlns:x="urn:schemas-microsoft-com:office:word"
        xmlns="http://www.w3.org/TR/REC-html40">

<head>
    <meta http-equiv=Content-Type content="text/html; charset=utf-8">
    <meta name=ProgId content=Excel.Sheet>
    <meta name=Generator content="Microsoft Word 12">
    <style id="template_26326_Styles">
    <!--
    table {
        mso-displayed-decimal-separator: "\.";
        mso-displayed-thousand-separator: "\,";
    }

    .font57821 {
        color: windowtext;
        font-size: 7.5pt;
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
        font-size: 7.5pt;
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
        font-size: 7.5pt;
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
        font-size: 7.5pt;
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
        font-size: 7.5pt;
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
        font-size: 7.5pt;
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
        font-size: 7.5pt;
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
        font-size: 7.5pt;
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
        font-size: 7.5pt;
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
        font-size: 7.5pt;
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
        font-size: 7.5pt;
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
        font-size: 7.5pt;
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
        font-size: 7.5pt;
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
        font-size: 7.5pt;
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

<div id="template_26326" align=center x:publishsource="Word">

    <table border=0 cellpadding=0 cellspacing=0
            style='border-collapse:collapse;width: 650px'>


        <tr height=18 style='height:54pt'>
            <td class=xl677821 colspan=13 style="text-align: center;border: none">
                <g:if test="${batchType=='F'}">
                    <strong style="font-size: 18">代付业务（${bankName}）付款申请单</strong>
                </g:if>
                <g:if test="${batchType=='S'}">
                    <strong style="font-size: 18">代收（${bankName}）明细表</strong>
                </g:if>

            </td>
        </tr>
        <tr class=xl677821 height=18 style='height:13.5pt'>
            <td height=18 class=xl677821 style='height:13.5pt;'>序号</td>
            <td class=xl677821 style='border-left:none;'>外部交易号</td>
            <td class=xl677821 style='border-left:none;'>批次号</td>
            <g:if test="${batchType=='F'}">
                <td class=xl677821 style='border-left:none;'>收款人</td>
            </g:if>
            <g:if test="${batchType=='S'}">
                <td class=xl677821 style='border-left:none;'>付款人</td>
            </g:if>
            <g:if test="${batchType=='F'}">
                <td class=xl677821 style='border-left:none;'>收款帐号</td>
            </g:if>
            <g:if test="${batchType=='S'}">
                <td class=xl677821 style='border-left:none;'>付款帐号</td>
            </g:if>
            <g:if test="${batchType=='F'}">
                <td class=xl677821 style='border-left:none;width: 50px;word-wrap: break-word;word-break:break-all;'>收款银行</td>
            </g:if>
            <g:if test="${batchType=='S'}">
                <td class=xl677821 style='border-left:none;width: 50px;word-wrap: break-word;word-break:break-all;'>付款银行</td>
            </g:if>
            <td class=xl677821 style='border-left:none;width: 50px;word-wrap: break-word;word-break:break-all;'>分行</td>
            <td class=xl677821 style='border-left:none;width: 50px;word-wrap: break-word;word-break:break-all;'>支行</td>
            <td class=xl677821 style='border-left:none;'>请求时间</td>
            <td class=xl677821 style='border-left:none;'>账号类型</td>
            <td class=xl677821 style='border-left:none;'>金额</td>
           <td class=xl677821 style='border-left:none;'>状态</td>
            <td class=xl677821 style='border-left:none;width: 50px;word-wrap: break-word;word-break:break-all;'>备注</td>

        </tr>
        <g:each in="${ptbPayTradeList}" status="i" var="ptbPayTrade">
            <tr height=18 style='height:13.5pt'>
                <td height=18 class=xl677821  style='height:13.5pt;'>${i+1}</td>
                <td height=18 class=xl677821  style='height:13.5pt;'>${ptbPayTrade.OUT_TRADEORDER}</td>
                <td height=18 class=xl677821  style='height:13.5pt;'>${ptbPayTrade.BATCH_ID}</td>
                <td height=18 class=xl677821  style='height:13.5pt;width: 35px;word-wrap: break-word;word-break:break-all;'>${ptbPayTrade.TRADE_CARDNAME}</td>
                <td height=18 class=xl677821  style='height:13.5pt;'>${ptbPayTrade.TRADE_CARDNUM}</td>
                <td height=18 class=xl677821  style='height:13.5pt;width: 70px;word-wrap: break-word;word-break:break-all;'>${ptbPayTrade.TRADE_BANK}</td>
                <td height=18 class=xl677821  style='height:13.5pt;width: 50px;word-wrap: break-word;word-break:break-all;'>${ptbPayTrade.TRADE_BRANCHBANK}</td>
                <td height=18 class=xl727821  style='height:13.5pt;width: 60px;word-wrap: break-word;word-break:break-all;'>${ptbPayTrade.TRADE_SUBBANK}</td>
                <td height=18 class=xl677821  style='height:13.5pt;'><g:formatDate date="${ptbPayTrade.TRADE_SUBDATE}" format="yyyy-MM-dd HH:mm:ss"/></td>
                <td height=18 class=xl677821  style='height:13.5pt;'>${PtbPayTrade.TradeAccTypeMap[ptbPayTrade.TRADE_ACCTYPE]}</td>
                <td height=18 class=xl727821  style='height:13.5pt;'>
                    <g:set var="amt" value="${ptbPayTrade.TRADE_AMOUNT ? ptbPayTrade.TRADE_AMOUNT : 0}"/>
                    ${amt}
                </td>
                <td height=18 class=xl727821  style='height:13.5pt;'>${PtbPayTrade.TradeStatusMap[ptbPayTrade.TRADE_STATUS]}</td>
                 <td height=18 class=xl677821  style='height:13.5pt;width: 50px;word-wrap: break-word;word-break:break-all;'>${ptbPayTrade.TRADE_NOTE}</td>
            </tr>
        </g:each>

        <tr height=18 style='height:54pt'>
            <td class=xl677821 colspan=13 style="text-align: left;border: none">
                <div style="text-align: left;border: none">
                    <br/><br/><br/>
                    编制人：<br/><br/><br/>


                    复核人：<br/><br/><br/>


                    部门负责人：<br/><br/><br/>


                    公司领导： <br/><br/><br/>


                    代收状态确认人：<br/><br/><br/>

                </div>
            </td>
        </tr>

    </table>

</div>







</body>

</html>
