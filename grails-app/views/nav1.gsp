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

                <div class="sidebar">
                    <div id="help-menu" class="mod">
                        <div class="mod-title">
                            <h2>功能菜单</h2>
                        </div>
                        <div class="mod-content-np">
                            <ul id="qMenu">
                                <li>
                                    银行管理
                                    <a name="A2">&nbsp;</a>
                                    <ul class="qMenu2">
                                        <bo:permChk perm="bank"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boBankDic')}" target="right">银行管理</a></li></bo:permChk>
                                        <bo:permChk perm="bankAccout"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boAcquirerAccount')}" target="right">收单银行账户管理</a></li></bo:permChk>
                                        <bo:permChk perm="bankCharge"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boAcquirerAccount', action: 'charge')}" target="right">银行账户充值</a></li></bo:permChk>
                                        <bo:permChk perm="bankDraw"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boAcquirerAccount', action: 'withDraw')}" target="right">银行账户提款</a></li></bo:permChk>
                                        <bo:permChk perm="bankTransfer"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boAcquirerAccount', action: 'transfer')}" target="right">银行账户转账</a></li></bo:permChk>
                                    </ul>
                                </li>
                                <bo:permChk perm="customer"><li class="activeItem">
                                    客户管理
                                    <a name="A3">&nbsp;</a>
                                    <ul class="qMenu2">
                                        <bo:permChk perm="customerCor"><li onClick="changeColor(this)"><a href="${createLink(controller: 'cmCorporationInfo')}" target="right">商户客户管理</a></li></bo:permChk>
                                        <bo:permChk perm="customerPer"><li onClick="changeColor(this)"><a href="${createLink(controller: 'cmPersonalInfo')}" target="right">个人客户管理</a></li></bo:permChk>
                                    </ul>
                                </li></bo:permChk>
                                <li class="activeItem">
                                    客户结算管理
                                    <a name="A3">&nbsp;</a>
                                    <ul class="qMenu2">
                                        <bo:permChk perm="settleCash"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tradeWithdrawn', action: 'unCheckList')}" target="right">待处理提现请求</a></li></bo:permChk>
                                        <bo:permChk perm="settleApp"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tradeWithdrawn', action: 'refuseList')}" target="right">待审批提现请求</a></li></bo:permChk>
                                        <bo:permChk perm="settleSearch"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tradeWithdrawn', action: 'histList')}" target="right">提现历史查询</a></li></bo:permChk>
                                    </ul>
                                </li>
                                <li class="activeItem">
                                    客户帐户管理
                                    <a name="A3">&nbsp;</a>
                                    <ul class="qMenu2">
                                        <bo:permChk perm="accountSearch"><li onClick="changeColor(this)"><a href="${createLink(controller: 'acAccount')}" target="right">账户查询</a></li></bo:permChk>
                                        <bo:permChk perm="accountFlush"><li onClick="changeColor(this)"><a href="${createLink(controller: 'acSequential')}" target="right">账务流水查询</a></li></bo:permChk>
                                    </ul>
                                </li>
                                <li class="activeItem">
                                    网关订单及支付管理
                                    <a name="A3">&nbsp;</a>
                                    <ul class="qMenu2">

                                        <bo:permChk perm="gatewaySearch"><li onClick="changeColor(this)"><a href="${createLink(controller: 'gwOrder', action: 'index')}" target="right">网关订单查询</a></li></bo:permChk>
                                        <bo:permChk perm="gatewayPay"><li onClick="changeColor(this)"><a href="${createLink(controller: 'gwTransaction', action: 'index')}" target="right">网关支付管理</a></li></bo:permChk>
                                        <bo:permChk perm="gatewayApp"><li onClick="changeColor(this)"><a href="${createLink(controller: 'acquireFaultTrx', action: 'appList')}" target="right">异常订单审核</a></li></bo:permChk>
                                        <bo:permChk perm="gatewayAppSearch"><li onClick="changeColor(this)"><a href="${createLink(controller: 'acquireFaultTrx', action: 'index')}" target="right">异常订单查询</a></li></bo:permChk>
                                    </ul>
                                </li>
                                <li class="activeItem">
                                    交易管理
                                    <a name="A3">&nbsp;</a>
                                    <ul class="qMenu2">
                                        <bo:permChk perm="transferSearch"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tradeBase', action: 'index')}" target="right">交易查询</a></li></bo:permChk>
                                        <bo:permChk perm="transferRequest"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tradeRefund', action: 'unCheckList')}" target="right">待处理退款请求</a></li></bo:permChk>
                                        <bo:permChk perm="transferApp"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tradeRefund', action: 'unRefuseList')}" target="right">待审批退款请求</a></li></bo:permChk>
                                        <bo:permChk perm="transferAppSearch"><li onClick="changeColor(this)"><a href="${createLink(controller: 'tradeRefund', action: 'completeList')}" target="right">退款查询</a></li></bo:permChk>
                                    </ul>
                                </li>

                                <li class="activeItem">
                                    风险管理
                                    <a name="A3">&nbsp;</a>
                                    <ul class="qMenu2">
                                        <bo:permChk perm="slaEvents"><li onClick="changeColor(this)"><a href="${createLink(controller: 'slaEvents', action: 'list')}" target="right">风险事件</a></li></bo:permChk>
                                    </ul>
                                </li>

                                <li class="activeItem">
                                    系统报表
                                    <a name="A3">&nbsp;</a>
                                    <ul class="qMenu2">
                                        <bo:permChk perm="sysReportBank"><li onClick="changeColor(this)"><a href="${createLink(controller: 'report', action: 'queryBank')}" target="right">银行交易日报</a></li></bo:permChk>
                                        <bo:permChk perm="sysReportCustomer"><li onClick="changeColor(this)"><a href="${createLink(controller: 'report', action: 'queryCustom')}" target="right">客户交易日报</a></li></bo:permChk>
                                        <bo:permChk perm="sysReportFree"><li onClick="changeColor(this)"><a href="${createLink(controller: 'report', action: 'queryFee')}" target="right">系统手续费日报</a></li></bo:permChk>
                                        <bo:permChk perm="sysReportFault"><li onClick="changeColor(this)"><a href="${createLink(controller: 'report', action: 'queryFault')}" target="right">差错交易日报</a></li></bo:permChk>
                                    </ul>
                                </li>

                                <li class="activeItem">
                                    信息发布管理
                                    <a name="A3">&nbsp;</a>
                                    <ul class="qMenu2">
                                        <bo:permChk perm="news"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boNews')}" target="right">信息发布管理</a></li></bo:permChk>
                                    </ul>
                                </li>

                                <li class="activeItem">
                                    人员管理
                                    <a name="A3">&nbsp;</a>
                                    <ul class="qMenu2">
                                        <bo:permChk perm="userManager"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boOperator')}" target="right">操作员管理</a></li></bo:permChk>
                                        <bo:permChk perm="userRole"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boRole')}" target="right">角色管理</a></li></bo:permChk>
                                        <bo:permChk perm="userPormission"><li onClick="changeColor(this)"><a href="${createLink(controller: 'boPromission')}" target="right">权限管理</a></li></bo:permChk>
                                    </ul>
                                </li>

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