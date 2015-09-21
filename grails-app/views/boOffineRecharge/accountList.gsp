
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
    <script type="text/javascript" src="/js/jquery-1.4.4.min.js"></script>
    <script type="text/javascript" src="/js/json2.js"></script>
    <script type="text/javascript">
        function trim(s)
		{
			return s.replace(/(^\s*)|(\s*$)/g, "");
		}
        function chooseResult(no,name)
        {
            window.parent.document.getElementById("accountNo").value=no;
            window.parent.document.getElementById("accountName").value=name;
            window.parent.win1.close();
        }
        function winClose()
        {
            window.parent.win1.close();
        }

    </script>
  </head>
<body style="overflow-x:hidden">
<div class="main">
<div class="right_top">
        <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">账户列表</h1>
        <g:form action="accountList">
            <div class="table_serch">
                <table>
                    <tr>
                         <td>客户号：</td>
                        <td><g:textField name="customerNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.customerNo}" class="right_top_h2_input"/></td>
                        <td>账户号：</td>
                        <td><g:textField name="accountNo" onblur="value=value.replace(/[ ]/g,'')" value="${params.accountNo}" class="right_top_h2_input"/></td>
                     </tr>
                    <tr>
                        <td>账户名称：</td>
                        <td><g:textField name="name" onblur="value=value.replace(/[ ]/g,'')" value="${params.name}" class="right_top_h2_input"/></td>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="accountList" value="查询"/></td>
                    </tr>
                </table>
            </div>
        </g:form>
        <table align="center" class="right_list_table" id="test">
            <tr>
                <td>选择</td>
                <td>客户号</td>
                <td>账户号</td>
                <td>账户名称</td>
            </tr>

            <g:each in="${cmCustomerInstanceList}" status="i" var="acAccountInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td><input type="radio" id="choose" name="choose" onclick="javascript:chooseResult('${fieldValue(bean: acAccountInstance, field: "accountNo")}','${fieldValue(bean: acAccountInstance, field: "name")}')"/></td>
                    <td>${fieldValue(bean: acAccountInstance, field: "customerNo")}</td>
                    <td>${fieldValue(bean: acAccountInstance, field: "accountNo")}</td>
                    <td>${fieldValue(bean: acAccountInstance, field: "name")}</td>
                </tr>
            </g:each>
        </table>
        <div class="paginateButtons">
            <span style=" float:left;">共${cmCustomerInstanceTotal}条记录</span>
            <g:paginat total="${cmCustomerInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
