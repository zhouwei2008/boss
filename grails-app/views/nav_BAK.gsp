<%@ page import="boss.Perm" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
    <title>导航</title>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7"/>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'css.css')}"/>

    <style>
    Body {
        scrollbar-arrow-color: #434242; /*图6,三角箭头的颜色*/
        scrollbar-face-color: #dcdcdc; /*图5,立体滚动条的颜色*/
        scrollbar-3dlight-color: #dcdcdc; /*图1,立体滚动条亮边的颜色*/
        scrollbar-highlight-color: #f3f3f3; /*图2,滚动条空白部分的颜色*/
        scrollbar-shadow-color: #999; /*图3,立体滚动条阴影的颜色*/
        scrollbar-darkshadow-color: #dcdcdc; /*图4,立体滚动条强阴影的颜色*/
        scrollbar-track-color: #f3f3f3; /*图7,立体滚动条背景颜色*/
        scrollbar-base-color: #f3f3f3; /*滚动条的基本颜色*/
        font: 12px Tahoma, Helvetica, Arial, Simsun;
        color: #4d4d4d;
        background: #fff;
        overflow: scroll;
        overflow-x: hidden;
        overflow-x: auto !important;
    }
    </style>
    <g:javascript library="yahoo-dom-event/yahoo-dom-event"/>
    <g:javascript library="hc-menu-source"/>
    <script type="text/javascript">
        function changeColor(liId) {
            var li = document.getElementsByTagName("li");
            for (var i = 0; i < li.length; i++) {
                li[i].style.backgroundColor = "";
            }
            liId.style.backgroundColor = "#e2e7eb";
        }
    </script>

</head>

<body>
<table class="leftman">
<tr>
<td valign="top">
<div id="container" style="width:194px;">

<div class="mod-content-np">
<ul id="qMenu">
<bo:hasPerm perm="${Perm.Cust}">
    <li class="activeItem">
        客户管理
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.Cust_Corp}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'cmCorporationInfo')}" target="right">企业客户管理</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Cust_Per}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'cmPersonalInfo')}" target="right">个人客户管理</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Cust_Application}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'cmApplication')}" target="right">在线申请客户管理</a></li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.WithDraw}">
    <li>
        客户结算管理
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.WithDraw_Wait}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tradeWithdrawn', action: 'unCheckList')}" target="right">待处理提现请求</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.WithDraw_Chk}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tradeWithdrawn', action: 'refuseList')}" target="right">单笔提现审批</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.WithDraw_ChkBth}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'withdrawnBatch', action: 'list')}" target="right">批量提现审批</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.WithDraw_RfdBthChk}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tradeWithdrawn', action: 'checkList')}" target="right">提现处理</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.WithDraw_RfdBthRef}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tradeWithdrawn', action: 'reCheckList')}" target="right">提现复核</a>
            </li></bo:hasPerm>

            <bo:hasPerm perm="${Perm.WithDraw_His}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tradeWithdrawn', action: 'histList')}" target="right">提现历史查询</a>
            </li></bo:hasPerm>
        %{--
        <bo:hasPerm perm="${Perm.WithDraw_InV_Init}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boCustomerInvoice', action: 'invoiceInitShow')}" target="right">发票初始化信息</a></li></bo:hasPerm>
        <bo:hasPerm perm="${Perm.WithDraw_InV_Osd}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boCustomerInvoice', action: 'invoiceOutstandingShow')}" target="right">待开发票信息</a></li></bo:hasPerm>
        <bo:hasPerm perm="${Perm.WithDraw_InV_Info}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boCustomerInvoice', action: 'invoiceInfoShow')}" target="right">发票信息查询</a></li></bo:hasPerm>
        <bo:hasPerm perm="${Perm.WithDraw_InV_Entering}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boCustomerInvoice', action: 'invoiceInfoEntering')}" target="right">发票信息录入</a></li></bo:hasPerm>
        <bo:hasPerm perm="${Perm.WithDraw_InV_Expressing}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boCustomerInvoice', action: 'invoiceInfoExpressing')}" target="right">快递信息录入</a></li></bo:hasPerm>
        <bo:hasPerm perm="${Perm.WithDraw_InV_Canceling}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boCustomerInvoice', action: 'invoiceInfoCanceling')}" target="right">发票退回</a></li></bo:hasPerm>
        --}%
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.Account}">
    <li>
        客户帐户管理
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.Account_Acc}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'acAccount')}" target="right">账户查询</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Account_Bill}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'acSequential')}" target="right">账务流水查询</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Account_Trans}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'acAccount', action: 'accountAdjust')}" target="right">账户调账</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Account_TransChk}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'boAccountAdjustInfo')}" target="right">账户调账审核</a></li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.Bank}">
    <li>
        银行管理
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.Bank_Manage}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'boBankDic')}" target="right">银行管理</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Bank_Issu}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'boAcquirerAccount')}" target="right">收单银行账户管理</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Bank_Charge}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'boAcquirerAccount', action: 'charge')}" target="right">银行账户充值</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Bank_WithDraw}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'boAcquirerAccount', action: 'withDraw')}" target="right">银行账户提款</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Bank_Trans}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'boAcquirerAccount', action: 'transfer')}" target="right">银行账户转账</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Bank_TransChk}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'boVerify', action: 'list')}" target="right">银行充提转审核</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Bank_TransRec}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'boVerify', action: 'recordList')}" target="right">银行充提转记录</a>
            </li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.Gworder}">
    <li>
        网关订单及支付管理
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.Gworder_Qry}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'gwOrder', action: 'index')}" target="right">网关订单查询</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Gworder_Trans}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'gwTransaction', action: 'index')}" target="right">网关支付管理</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Gworder_ExcpChk}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'acquireFaultTrx', action: 'appList')}" target="right">异常订单审核</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Gworder_ExcpQry}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'acquireFaultTrx', action: 'index')}" target="right">异常订单查询</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Gworder_Sync}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'acquireSynTrx', action: 'list')}" target="right">交易对账</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Gworder_AccountTrade}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'acquireAccountTrade', action: 'list')}" target="right">批量对账</a>
            </li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.Trade}">
    <li>
        交易管理
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.Trade_Qry}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tradeBase', action: 'index')}" target="right">交易查询</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Trade_RfdWait}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tradeRefund', action: 'unCheckList')}" target="right">待处理退款请求</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Trade_RfdChk}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tradeRefund', action: 'unRefuseList')}" target="right">单笔退款审批</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Trade_RfdBthChk}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tradeRefundBatch', action: 'index')}" target="right">批量退款审批</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Trade_RfdBthRef}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tradeRefund', action: 'checkList')}" target="right">退款处理</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Trade_RfdBthReChk}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tradeRefund', action: 'reCheckList')}" target="right">退款复核</a>
            </li></bo:hasPerm>
        %{--<bo:hasPerm perm="${Perm.Trade_RfdHis}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tradeRefund', action: 'completeList')}" target="right">退款查询</a></li></bo:hasPerm>--}%
            <bo:hasPerm perm="${Perm.Trade_RfdHis}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tradeRefund', action: 'historyList')}" target="right">退款历史明细</a>
            </li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.Settle}">
    <li>
        清结算管理
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.Settle_SrvType}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ftSrvType')}" target="right">业务类型管理</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Settle_TradeType}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ftSrvTradeType')}" target="right">业务交易类型管理</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Settle_Fee}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ftCustomer', action: "list")}" target="right">费率管理</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Settle_Cycle}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'stCustomer', action: "list")}" target="right">结算周期管理</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Settle_PreManualSettle}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ftLiquidate')}" target="right">净额及即扣手续费手工结算</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Settle_PostManualSettle}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'postFeeSettle', action: "merchant_list")}"
                    target="right">后返手续费手工结算</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Settle_PreSettleChk}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ftFoot')}" target="right">结算单审核</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Settle_SettleHis}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'postFeeSettle', action: "settle_his_list")}"
                    target="right">结算历史查询</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Settle_PostSettleChk}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'postFeeSettle', action: "shenhe_list")}"
                    target="right">后返手续费结算审核</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Settle_PostSettleHis}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'postFeeSettle', action: "shenhe_his_list")}"
                    target="right">后返手续费结算历史查询</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Settle_withDraw}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tradeWithdrawn', action: "withdraw")}" target="right">客户提现</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Settle_AutoWithDrawCycleSetting}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'boCustomerWithdrawCycle', action: "list")}"
                    target="right">自动提现周期设置</a></li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.Agent_new}">
    <li>
        委托结算管理
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.AgentPay_Check}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tbAgentpayInfo', action: 'dklist')}" target="right">打款审核</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.AgentColl_Check}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tbAgentpayInfo', action: 'sklist')}" target="right">收款审核</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Agent_RfdPreChk}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tbAgentpayInfo', action: 'reFcheckPage')}" target="right">退款初审</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Agent_RfdFinalChk}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tbAgentpayInfo', action: 'reTcheckPage')}" target="right">退款终审</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Agent_TradeQuery}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tbAgentpayInfo', action: 'transactionList')}"
                    target="right">交易查询</a></li></bo:hasPerm>

            <bo:hasPerm perm="${Perm.Agent_FeeNew}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'acSequential', action: 'feeSettList')}" target="right">手续费结算</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Agent_EntrustPermAdd}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tbEntrustPermSingle', action: 'create')}"
                    target="right">代收授权账户录入</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Agent_EntrustPermBatchAdd}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tbEntrustPermsImport', action: 'tbEntrustPermsImport')}"
                    target="right">授权账户批量导入</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Agent_EntrustPermAdmin}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tbEntrustPermSingle', action: 'showList')}"
                    target="right">代收授权账户管理</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Agent_TbErrorLogAdmin}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tbErrorLog', action: 'showList')}" target="right">异常订单查询管理</a>
            </li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.NewAgPay}">
    <li>
        打款平台
        <a>&nbsp;</a>
        <ul class="qMenu2">

            <bo:hasPerm perm="${Perm.NewAgPay_PayTradeType}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ptbPayTradeType', action: 'pdklist')}" target="right">打款交易类型管理</a>
            </li></bo:hasPerm>
        %{--<bo:hasPerm perm="${Perm.NewAgPay_PreChk}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tbAgentpayDetailsInfo', action: 'dklist')}" target="right">打款初审</a></li></bo:hasPerm>--}%
        %{--<bo:hasPerm perm="${Perm.NewAgPay_FinalChk}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tbAgentpayDetailsInfo', action: 'dkteminalList')}" target="right">打款终审</a></li></bo:hasPerm>--}%
            <bo:hasPerm perm="${Perm.NewAgPay_PayChannel}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ptbPayManager', action: 'pdkList')}" target="right">选择打款渠道</a>
            </li></bo:hasPerm>
        %{--<bo:hasPerm perm="${Perm.NewAgPay_BankChannel}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tbBindBank', action: 'dklist')}" target="right">绑定银行渠道</a></li></bo:hasPerm>--}%
            <bo:hasPerm perm="${Perm.NewAgPay_Trade}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ptbPayQueryManager', action: 'tradesManagerF')}"
                    target="right">打款明细查询</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.NewAgPay_Sync}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ptbPayManager', action: 'pdkCheckPage')}" target="right">打款对账</a>
            </li></bo:hasPerm>
        %{--<bo:hasPerm perm="${Perm.NewAgPay_RfdPreChk}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tbAgentpayDetailsInfo', action: 'reFcheckPage')}" target="right">退款初审</a></li></bo:hasPerm>--}%
        %{--<bo:hasPerm perm="${Perm.NewAgPay_RfdFinalChk}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tbAgentpayDetailsInfo', action: 'reTcheckPage')}" target="right">退款终审</a></li></bo:hasPerm>--}%
            <bo:hasPerm perm="${Perm.NewAgPay_Batch}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ptbPayQueryManager', action: 'batchsManagerF')}"
                    target="right">打款批次管理</a></li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.NewAgCol}">
    <li>
        收款平台
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.NewAgCol_PayTradeType}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ptbPayTradeType', action: 'psklist')}" target="right">收款交易类型管理</a>
            </li></bo:hasPerm>
        %{--<bo:hasPerm perm="${Perm.NewAgCol_PreChk}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tbAgentpayDetailsInfo', action: 'sklist')}" target="right">收款初审</a></li></bo:hasPerm>--}%
        %{--<bo:hasPerm perm="${Perm.NewAgCol_FinalChk}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tbAgentpayDetailsInfo', action: 'skteminalList')}" target="right">收款终审</a></li></bo:hasPerm>--}%
            <bo:hasPerm perm="${Perm.NewAgCol_ColChannel}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ptbPayManager', action: 'pskList')}" target="right">选择收款渠道</a>
            </li></bo:hasPerm>
        %{--<bo:hasPerm perm="${Perm.NewAgCol_BankChannel}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tbBindBank', action: 'sklist')}" target="right">绑定银行渠道</a></li></bo:hasPerm>--}%
            <bo:hasPerm perm="${Perm.NewAgCol_Trade}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ptbPayQueryManager', action: 'tradesManagerS')}"
                    target="right">收款明细查询</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.NewAgCol_Sync}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ptbPayManager', action: 'pskCheckPage')}" target="right">收款对账</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.NewAgCol_Batch}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'ptbPayQueryManager', action: 'batchsManagerS')}"
                    target="right">收款批次管理</a></li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.InterruptOrder}">
    <li>
        订单掉单管理
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.InterruptOrder_Manage}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'notifyFailProof', action: 'list')}" target="right">订单掉单处理</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.InterruptOrder_Watcher_Setting}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'notifyFailWatcher', action: 'list')}" target="right">通知名单设置</a>
            </li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.Report}">
    <li>
        系统报表
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.Report_BankDaily}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'report', action: 'queryBank')}" target="right">银行交易日报</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Report_CustDaily}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'report', action: 'queryCustom')}" target="right">客户交易日报</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Report_FeeDaily}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'report', action: 'queryFee')}" target="right">系统手续费日报</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Report_FailDaily}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'report', action: 'queryFault')}" target="right">差错交易日报</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Report_BankTypeDaily}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'report', action: 'bankType')}" target="right">按银行划分系统数据统计表</a>
            </li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Report_AgentcollDaily}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'reportAgentpayDaily', action: 'list', params: ['tradeType': 'S'])}"
                    target="right">代收业务统计报表</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Report_AgentpayDaily}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'reportAgentpayDaily', action: 'list', params: ['tradeType': 'F'])}"
                    target="right">代付业务统计报表</a></li></bo:hasPerm>
        %{-- <bo:hasPerm perm="${Perm.Report_PersonPortalShow}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'report', action: 'queryPersonPortalShow')}" target="right">个人门户报表</a></li></bo:hasPerm>--}%
            <bo:hasPerm perm="${Perm.Report_OtherBizShow}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'reportOtherBiz', action: 'queryOtherBizDailyShow')}"
                    target="right">其他业务统计报表</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Report_AdjustShow}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'reportAdjust', action: 'queryAdjustDailyShow')}"
                    target="right">调账类统计报表</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Report_OnlinePayDaily}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'reportOnlinePayDaily', action: 'list')}"
                    target="right">在线支付业务系统报表</a></li></bo:hasPerm>
        %{--<bo:hasPerm perm="${Perm.Report_RoyaltyDaily}"><li onClick="changeColor(this)"><a href="${createLink(controller: 'reportRoyaltyDaily', action: 'list')}" target="right">分润业务系统报表</a></li></bo:hasPerm> --}%
            <bo:hasPerm perm="${Perm.Report_AllServicesDaily}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'reportAllServicesDaily', action: 'list')}"
                    target="right">吉高业务统计总报表</a></li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.News}">
    <li>
        信息发布管理
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.News_Manage}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'boNews')}" target="right">信息发布管理</a></li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.Security}">
    <li>
        安全管理
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.Security_Op}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'boOperator')}" target="right">操作员管理</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.Security_Role}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'bossRole')}" target="right">角色管理</a></li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>
<bo:hasPerm perm="${Perm.SysLog}">
    <li>
        系统日志
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.SysLog_Merc}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'mapiAsyncNotify')}" target="right">商户日志查询</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.SysLog_Op_Log}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'boOpLog')}" target="right">BOSS后台操作日志查询</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.SysLog_Op_Relation}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'boOpRelation')}" target="right">BOSS后台操作名称管理</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.SysLog_Cm_Op_Log}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'cmOpLog')}" target="right">商户后台操作日志查询</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.SysLog_Cm_Op_Relation}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'cmOpRelation')}" target="right">商户后台操作名称管理</a></li></bo:hasPerm>
        </ul>
    </li>
</bo:hasPerm>

<bo:hasPerm perm="${Perm.RiskManager}">
    <li>
        风控管理
        <a>&nbsp;</a>
        <ul class="qMenu2">
            <bo:hasPerm perm="${Perm.RiskManager_InsideBlackList}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'backList')}" target="right">内部黑名单管理</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.RiskManager_BlackList}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'backList')}" target="right">黑名单管理</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.RiskManager_Risk_Rule}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tbRiskControl')}" target="right">交易规则管理</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.RiskManager_Risk_List}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tbRiskList')}" target="right">风险交易列表</a></li></bo:hasPerm>
            <bo:hasPerm perm="${Perm.RiskManager_Risk_Notifier}"><li onClick="changeColor(this)"><a
                    href="${createLink(controller: 'tbRiskNotifier')}" target="right">风险通知人</a></li></bo:hasPerm>

        </ul>
    </li>
</bo:hasPerm>

</ul>
</div>
</div>
</div>

</div>
</td>
<td class="leftright"></td>
</tr>
</table>

</body>
</html>