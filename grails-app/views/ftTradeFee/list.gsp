<%@ page import="settle.FtSrvTradeType; boss.Perm; settle.FtTradeFee" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8;pageEncoding=GBK"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'ftTradeFee.label', default: 'FtTradeFee')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15"><g:message code="default.list.label" args="[entityName]"/></h1>
        <h2>
            <g:form>
                <table>
                    <tr>
                        <td>
                            客户：${customerName}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            服务：${srvName}
                            <g:hiddenField name="customerNo" value="${customerNo}"></g:hiddenField>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="button" name="add" class="right_top_h2_button_tj" onclick=" window.location.href = '${createLink(controller:'ftTradeFee', action:'create',params:['customerName':customerName,'srvName':srvName,'customerNo':customerNo,'srvId':srvId])}'" value="${message(code: 'default.add.label', args: [entityName])}"/>
                            %{--<g:actionSubmit class="right_top_h2_button_tj" action="create" value="${message(code: 'default.add.label', args:[entityName])}"/>--}%
                        </td>
                    </tr>
                </table>
            </g:form>
        </h2>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <th>交易类型</th>
                <th>费率通道</th>
                <th>计费模式</th>
                <th>分类</th>
                <th>费率</th>
                <th>结算方式</th>
                <th>收取方向</th>
                <th>有效期</th>
                <th>操作</th>
            </tr>

            <g:each in="${ftTradeFeeList}" status="i" var="ftTradeFeeList">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>${FtSrvTradeType.get(ftTradeFeeList?.tradeType?.id)?.tradeName}</td>
                    <td><g:if test="${settle.FtFeeChannel.findByCodeAndFtSrvTypeId(ftTradeFeeList?.channelCode, ftTradeFeeList?.srv?.id)?.name !=null}">
                        ${settle.FtFeeChannel.findByCodeAndFtSrvTypeId(ftTradeFeeList?.channelCode, ftTradeFeeList?.srv?.id)?.name}
                    </g:if><g:else>
                        全部
                    </g:else>
                    </td>
                    <td>${FtTradeFee.categoryMap[ftTradeFeeList?.feeModel]}</td>
                    <td>${FtTradeFee.feeType2Map[ftTradeFeeList?.feeType]}</td>
                    <td><g:if test="${ftTradeFeeList?.feeModel==2}"></g:if><g:else><g:formatNumber number="${ftTradeFeeList.feeValue}" format="###,##0.00"></g:formatNumber><g:if test="${ftTradeFeeList?.feeType==0}">元</g:if><g:elseif test="${ftTradeFeeList?.feeType==1}">%</g:elseif></g:else></td>
                    <td>${FtTradeFee.fetchTypeMap[ftTradeFeeList?.fetchType]}</td>
                    <td>${FtTradeFee.tradeWeightMap[ftTradeFeeList?.tradeWeight]}</td>
                    <td><g:formatDate date="${ftTradeFeeList?.dateBegin}" format="yyyy.MM.dd"/>-<g:formatDate date="${ftTradeFeeList?.dateEnd}" format="yyyy.MM.dd"/></td>
                    <td><bo:hasPerm perm="${Perm.Settle_Fee_Edit}">
                        <input type="button" value="修改" onclick="window.location.href = '${createLink(controller:'ftTradeFee', action:'edit', params:['id':ftTradeFeeList.id,'srvName':srvName,'customerNo':customerNo])}'">
                    </bo:hasPerm>
                    %{--增加查看按钮 sunweiguo as 2012-08-09--}%
                        <bo:hasPerm perm="${Perm.Settle_Fee_View}">
                            <input type="button" value="查看" onclick="window.location.href = '${createLink(controller:'ftTradeFee', action:'edit', params:['id':ftTradeFeeList.id,'srvName':srvName,'flag':3])}'">
                        </bo:hasPerm>

                        <bo:hasPerm perm="${boss.Perm.Settle_Fee_Check}">
                            <input type="button" value="审核" onclick="window.location.href = '${createLink(controller:'ftTradeFee', action:'edit', params:['id':ftTradeFeeList.id,'srvName':srvName,'customerNo':customerNo,'flag':'check'])}'">
                        </bo:hasPerm>
                    </td>
                </tr>
            </g:each>
        </table>

        <div class="paginateButtons">
            <div align="left"><div style="position:absolute;">共${ftTradeFeeTotal}条记录</div></div>
            <g:paginat total="${ftTradeFeeTotal}" params="${params}"/>

        </div>
    </div>
    <div align="center">
        <input type="button" class="rigt_button back_btn" value="返回"/>
        %{--<input type="button" class="rigt_button" onclick="window.location.href = '${createLink(controller:'ftCustomer', action:'list')}'" value="返回"/>--}%
    </div>
</div>
</body>
</html>

