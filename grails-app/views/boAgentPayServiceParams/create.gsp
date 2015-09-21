

<%@ page import="boss.BoAgentPayServiceParams" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'boAgentPayServiceParams.label', default: 'boAgentPayServiceParams')}"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
    <script type="text/javascript">
    function trim(s)
    {
        return s.replace(/(^\s*)|(\s*$)/g, "");
    }
    function isNum(obj)
    {
        if(isNaN(obj.value.replace(/,/g,""))){
           alert("您只能输入数字");
           obj.focus();
           return false;
        }
    }
    /**
    * 格式化金额
    */
    function fmoney(s, n)
    {
       var flag = 0;
       var svalue;
       if(isNaN(s.value.replace(/,/g,""))){
           alert("您只能输入数字");
           s.focus();
           return false;
       }
       if(s.value=="0" ||s.value=="0.00"){
           flag=1;
       }
       n = n>0 && n<=20?n:2;
       svalue = parseFloat((s.value + "").replace(/[^\d\.-]/g, "")).toFixed(n)+"";
       var l = svalue.split(".")[0].split("").reverse(),
       r = svalue.split(".")[1];
       t = "";
       for(i=0; i<l.length; i++ )
       {
          t +=l[i]+((i+1)%3==0 && (i+1)!=l.length?",":"");
       }
       s.value=t.split("").reverse().join("")+"."+r;
       if(s.value=="NaN.undefined"){
           s.value="";
       }else if(s.value=="0.00" && flag==0){
           alert("该字段值保留2位小数");
           s.value="";
       }
    }

    /**
    * 还原金额
    */
    function rmoney(s)
    {
       return parseFloat(s.replace(/[^\d\.-]/g, ""));
    }
    function doSave()
		{
			var digitnum = /^\d{1,5}\.\d{1,2}$/;
            var regnum_ = /^\d{1,9}$/;
			var regnum = /^\d{1,8}$/;
			var daytrans = /^\d{1,6}$/;
			var monthtrans = /^\d{1,10}$/;
			var produreFee="";
			var perprodureFee="";
            if("${serviceCode}"=="agentpay"){
                produreFee = document.getElementById("procedureFee").value;
                perprodureFee = document.getElementById("perprocedureFee").value;
            }
			var limitMoney = document.getElementById("limitMoney").value;
			var dayLimitTrans = document.getElementById("dayLimitTrans").value;
			var dayLimitMoney =document.getElementById("dayLimitMoney").value;
			var monthLimitTrans = document.getElementById("monthLimitTrans").value;
			var monthLimitMoney = document.getElementById("monthLimitMoney").value;
			var remark = document.getElementById("remark").value;

			if(trim(remark)!="" && trim(remark).replace(/[^\x00-\xFF]/g,'**').length>50)
			{
				alert("备注最多输入50个字符");
				 document.getElementById("remark").focus();
				return false;
			}
            if("${serviceCode}"=="agentpay"){
                    if(trim(produreFee)!="")
                    {
                        if(!isNaN(rmoney(trim(produreFee))))
                        {
                            if(rmoney(trim(produreFee)).toString().indexOf(".")>0)
                            {
                                if(!digitnum.test(rmoney(trim(produreFee))) || trim(produreFee).toString().replace(/,/g,"").length>9)
                                {
                                    alert("按笔收费对公每笔 只能输入数字且最多输入9位");
                                    document.getElementById("procedureFee").focus();
                                    return false;
                                }else if(parseFloat(rmoney(trim(produreFee)))<0){
                                    alert("按笔收费对公每笔 必须大于零");
                                    document.getElementById("procedureFee").focus();
                                    return false;
                                }else if(trim(produreFee).toString().replace(/,/g,"").length>9){
                                    alert("按笔收费对公每笔 最多输入9位");
                                    document.getElementById("procedureFee").focus();
                                    return false;
                                }
                            }else{
                                if(!regnum_.test(rmoney(trim(produreFee))) || rmoney(trim(produreFee)).toString().replace(/,/g,"").length>9)
                                {
                                    alert("按笔收费对公每笔 只能输入数字且最多输入9位");
                                    document.getElementById("procedureFee").focus();
                                    return false;
                                }else if(parseInt(rmoney(trim(produreFee)))<0){
                                    alert("按笔收费对公每笔 必须大于零");
                                    document.getElementById("procedureFee").focus();
                                    return false;
                                }else if(rmoney(trim(produreFee)).toString().replace(/,/g,"").length>9){
                                    alert("按笔收费对公每笔 最多输入9位");
                                    document.getElementById("procedureFee").focus();
                                    return false;
                                }
                            }
                        }else{
                            alert("按笔收费对公每笔 必须输入数字");
                            document.getElementById("procedureFee").focus();
                            return false;
                        }

                    }else if(trim(produreFee)==""){
                        alert("按笔收费对公每笔 不能为空");
                        document.getElementById("procedureFee").focus();
                        return false;
                    }
                    if(trim(perprodureFee)!="")
                    {
                        if(!isNaN(rmoney(trim(perprodureFee))))
                        {
                            if(rmoney(trim(perprodureFee)).toString().indexOf(".")>0)
                            {
                                if(!digitnum.test(rmoney(trim(perprodureFee))) || trim(perprodureFee).toString().replace(/,/g,"").length>9)
                                {
                                    alert("按笔收费对私每笔 只能输入数字且最多输入9位");
                                    document.getElementById("perprocedureFee").focus();
                                    return false;
                                }else if(parseFloat(rmoney(trim(perprodureFee)))<0){
                                    alert("按笔收费对私每笔 必须大于零");
                                    document.getElementById("perprocedureFee").focus();
                                    return false;
                                }else if(trim(perprodureFee).toString().replace(/,/g,"").length>9){
                                    alert("按笔收费对私每笔 最多输入9位");
                                    document.getElementById("perprocedureFee").focus();
                                    return false;
                                }
                            }else{
                                if(!regnum_.test(rmoney(trim(perprodureFee))) || rmoney(trim(perprodureFee)).toString().replace(/,/g,"").length>9)
                                {
                                    alert("按笔收费对私每笔 只能输入数字且最多输入9位");
                                    document.getElementById("perprocedureFee").focus();
                                    return false;
                                }else if(parseInt(rmoney(trim(perprodureFee)))<0){
                                    alert("按笔收费对私每笔 必须大于零");
                                    document.getElementById("perprocedureFee").focus();
                                    return false;
                                }else if(rmoney(trim(perprodureFee)).toString().replace(/,/g,"").length>9){
                                    alert("按笔收费对私每笔 最多输入9位");
                                    document.getElementById("perprocedureFee").focus();
                                    return false;
                                }
                            }
                        }else{
                            alert("按笔收费对私每笔 必须输入数字");
                            document.getElementById("perprocedureFee").focus();
                            return false;
                        }
                    }else if(trim(perprodureFee)==""){
                        alert("按笔收费对私每笔 不能为空");
                        document.getElementById("perprocedureFee").focus();
                        return false;
                    }
            }

			if(trim(limitMoney)!="")
			{
				if(!isNaN(rmoney(trim(limitMoney))))
				{
					if(rmoney(trim(limitMoney)).toString().indexOf(".")>0)
					{
						if(!digitnum.test(rmoney(trim(limitMoney))) || trim(limitMoney).toString().replace(/,/g,"").length>8)
						{
							alert("单笔交易限额 只能输入数字且最多输入8位");
							document.getElementById("limitMoney").focus();
							return false;
						}else if(parseFloat(rmoney(trim(limitMoney)))<=0){
                            alert("单笔交易限额 必须大于零");
							document.getElementById("limitMoney").focus();
							return false;
                        }else if(trim(limitMoney).toString().replace(/,/g,"").length>8){
                            alert("单笔交易限额 最多输入8位");
							document.getElementById("limitMoney").focus();
							return false;
                        }
					}else{
						if(!regnum_.test(rmoney(trim(limitMoney))) || rmoney(trim(limitMoney)).toString().replace(/,/g,"").length>8)
						{
							alert("单笔交易限额 只能输入数字且最多输入8位");
							document.getElementById("limitMoney").focus();
							return false;
						}else if(parseInt(rmoney(trim(limitMoney)))<=0){
                            alert("单笔交易限额 必须大于零");
							document.getElementById("limitMoney").focus();
							return false;
                        }else if(rmoney(trim(limitMoney)).toString().replace(/,/g,"").length>8){
                            alert("单笔交易限额 最多输入8位");
							document.getElementById("limitMoney").focus();
							return false;
                        }
					}
				}else{
					alert("单笔交易限额 必须输入数字");
					document.getElementById("limitMoney").focus();
					return false;
				}
			}else if(trim(limitMoney)==""){
				alert("单笔交易限额 不能为空");
				document.getElementById("limitMoney").focus();
				return false;
			}
			if(trim(dayLimitMoney)!="")
			{
				if(!isNaN(rmoney(trim(dayLimitMoney))))
				{
					if(rmoney(trim(dayLimitMoney)).toString().indexOf(".")>0)
					{
						if(!digitnum.test(rmoney(trim(dayLimitMoney))) || trim(dayLimitMoney).toString().replace(/,/g,"").length>9)
						{
							alert("日交易限额（金额）只能输入数字且最多输入9位");
                            document.getElementById("dayLimitMoney").focus();
							return false;
						}else if(parseFloat(rmoney(trim(dayLimitMoney)))<=0){
                            alert("日交易限额（金额）必须大于零");
                            document.getElementById("dayLimitMoney").focus();
							return false;
                        }else if(trim(dayLimitMoney).toString().replace(/,/g,"").length>9){
                            alert("日交易限额（金额）最多输入9位");
                            document.getElementById("dayLimitMoney").focus();
							return false;
                        }
					}else{
						if(!regnum_.test(rmoney(trim(dayLimitMoney))) || rmoney(trim(dayLimitMoney)).toString().replace(/,/g,"").length>9)
						{
							alert("日交易限额（金额）只能输入数字且最多输入9位");
							document.getElementById("dayLimitMoney").focus();
							return false;
						}else if(parseInt(rmoney(trim(dayLimitMoney)))<=0){
                            alert("日交易限额（金额）必须大于零");
							document.getElementById("dayLimitMoney").focus();
							return false;
                        }else if(rmoney(trim(dayLimitMoney)).toString().replace(/,/g,"").length>9){
                            alert("日交易限额（金额）最多输入9位");
							document.getElementById("dayLimitMoney").focus();
							return false;
                        }
					}
				}else{
					alert("日交易限额（金额）输入错误");
					document.getElementById("dayLimitMoney").focus();
					return false;
				}
			}else if(trim(dayLimitMoney)==""){
				alert("日交易限额（金额）不能为空");
				document.getElementById("dayLimitMoney").focus();
				return false;
			}
			if(trim(monthLimitMoney)!="")
			{
				if(!isNaN(rmoney(trim(monthLimitMoney))))
				{
					if(rmoney(trim(monthLimitMoney)).toString().indexOf(".")>0)
					{
						if(!digitnum.test(rmoney(trim(monthLimitMoney))) || trim(monthLimitMoney).toString().replace(/,/g,"").length>9)
						{
							alert("月交易限额（金额）只能输入数字且最多输入9位");
                            document.getElementById("monthLimitMoney").focus();
							return false;
						}else if(parseFloat(rmoney(trim(monthLimitMoney)))<=0){
                            alert("月交易限额（金额）必须大于零");
                            document.getElementById("monthLimitMoney").focus();
							return false;
                        }else if(trim(monthLimitMoney).toString().replace(/,/g,"").length>9){
                            alert("月交易限额（金额）最多输入9位");
                            document.getElementById("monthLimitMoney").focus();
							return false;
                        }
					}else{
						if(!regnum_.test(rmoney(trim(monthLimitMoney))) || rmoney(trim(monthLimitMoney)).toString().replace(/,/g,"").length>9)
						{
							alert("月交易限额（金额）只能输入数字且最多输入9位");
							document.getElementById("monthLimitMoney").focus();
							return false;
						}else if(parseInt(rmoney(trim(monthLimitMoney)))<=0){
                            alert("月交易限额（金额）必须大于零");
							document.getElementById("monthLimitMoney").focus();
							return false;
                        }else if(rmoney(trim(monthLimitMoney)).toString().replace(/,/g,"").length>9){
                            alert("月交易限额（金额）最多输入9位");
							document.getElementById("monthLimitMoney").focus();
							return false;
                        }
					}
				}else{
					alert("月交易限额（金额）输入错误");
					document.getElementById("monthLimitMoney").focus();
					return false;
				}
			}else if(trim(monthLimitMoney)==""){
				alert("月交易限额（金额）不能为空");
				document.getElementById("monthLimitMoney").focus();
				return false;
			}
            if(trim(dayLimitTrans)!="")
			{
				if(!isNaN(rmoney(trim(dayLimitTrans))))
				{
					if(rmoney(trim(dayLimitTrans)).toString().indexOf(".")>0)
					{
						alert("日交易限额（笔数）输入错误，只能输入整数");
                        document.getElementById("dayLimitTrans").focus();
						return false;
					}else{
						if(!daytrans.test(rmoney(trim(dayLimitTrans))) || trim(dayLimitTrans).toString().replace(/,/g,"").length>6)
						{
							alert("日交易限额（笔数）只能输入整数最多输入6位");
							document.getElementById("dayLimitTrans").focus();
							return false;
						}else if(parseInt(rmoney(trim(dayLimitTrans)))<=0){
                            alert("日交易限额（笔数）必须大于零");
							document.getElementById("dayLimitTrans").focus();
							return false;
                        }else if(rmoney(trim(dayLimitTrans)).toString().replace(/,/g,"").length>6){
                            alert("日交易限额（笔数）最多输入6位");
							document.getElementById("dayLimitTrans").focus();
							return false;
                        }
					}
				}else{
					alert("日交易限额（笔数）输入错误");
					document.getElementById("dayLimitTrans").focus();
					return false;
				}
			}else if(trim(dayLimitTrans)=="")
            {
                alert("日交易限额（笔数）不能为空");
                return false;
            }
			/*else if(trim(dayLimitTrans)!="" && !daytrans.test(trim(dayLimitTrans)))
			{
				alert("日交易限额（笔数）输入错误，只能输入数字");
                document.getElementById("dayLimitTrans").value="";
                document.getElementById("dayLimitTrans").focus();
				return false;
			}*/
            if(trim(monthLimitTrans)!="")
			{
				if(!isNaN(rmoney(trim(monthLimitTrans))))
				{
					if(rmoney(trim(monthLimitTrans)).toString().indexOf(".")>0)
					{
						alert("月交易限额（笔数）输入错误，只能输入整数");
                        document.getElementById("monthLimitTrans").focus();
						return false;
					}else{
						if(!monthtrans.test(rmoney(trim(monthLimitTrans))) || trim(monthLimitTrans).toString().replace(/,/g,"").length>10)
						{
							alert("月交易限额（笔数）只能输入整数最多输入10位");
							document.getElementById("monthLimitTrans").focus();
							return false;
						}else if(parseInt(rmoney(trim(monthLimitTrans)))<=0){
                            alert("月交易限额（笔数）必须大于零");
							document.getElementById("monthLimitTrans").focus();
							return false;
                        }else if(rmoney(trim(monthLimitTrans)).toString().replace(/,/g,"").length>10){
                            alert("月交易限额（笔数）最多输入10位");
							document.getElementById("monthLimitTrans").focus();
							return false;
                        }
					}
				}else{
					alert("月交易限额（笔数）输入错误");
					document.getElementById("monthLimitTrans").focus();
					return false;
				}
			}else if(trim(monthLimitTrans)=="")
            {
                alert("日交易限额（笔数）不能为空");
                return false;
            }
			/*else if(trim(monthLimitTrans)!="" && !monthtrans.test(trim(monthLimitTrans)))
			{
				alert("月交易限额（笔数）输入错误，只能输入数字");
                document.getElementById("monthLimitTrans").value="";
                document.getElementById("monthLimitTrans").focus();
				return false;
			}*/
			if(parseInt(trim(dayLimitTrans))>parseInt(trim(monthLimitTrans)))
			{
				alert("日交易限额（笔数）不能大于月交易限额（笔数）");
				return false;
			}
			if(parseInt(rmoney(trim(dayLimitMoney)))>parseInt(rmoney(trim(monthLimitMoney))))
			{
				alert("日交易限额（金额）不能大于月交易限额（金额）");
				return false;
			}
            if("${serviceCode}"=="agentpay"){
                document.getElementById("procedureFee").value=rmoney(produreFee);
                document.getElementById("perprocedureFee").value=rmoney(perprodureFee);
            }
            document.getElementById("limitMoney").value=rmoney(limitMoney);
            document.getElementById("dayLimitMoney").value=rmoney(dayLimitMoney);
            document.getElementById("monthLimitMoney").value=rmoney(monthLimitMoney);
            document.forms[0].submit();

		}
</script>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${boAgentPayServiceParamsInstance}">
    <div class="errors">
      <g:renderErrors bean="${boAgentPayServiceParamsInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" name="form1" >
      <g:hiddenField name="id" value="${id}"/>
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>

      <tr id="gatherWayLabel">
        <td class="right label_name"><g:message code="boAgentPayServiceParams.gatherWay.label"/>：</td>
        <td>
            <g:hiddenField name="gatherWay" value="0"/>
            <g:message code="boAgentPayServiceParams.gatherWay.transaction.label"/><g:textField id="procedureFee" name="procedureFee"  value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'procedureFee')}"  onBlur="fmoney(this,2)"/>
            <g:message code="boAgentPayServiceParams.gatherWay.perTransaction.label"/><g:textField id="perprocedureFee" name="perprocedureFee"  value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'perprocedureFee')}"  onBlur="fmoney(this,2)"/>元
        </td>
      </tr>
      
      <tr>
        <td class="right label_name"><g:message code="boAgentPayServiceParams.transactionMoney.label"/>：</td>
        <td>
            <g:message code="boAgentPayServiceParams.singleTransactionMoney.label"/>&nbsp;<g:textField id="limitMoney" name="limitMoney"  value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'limitMoney')}"  onBlur="fmoney(this,2)"/> 元
             <br/><g:message code="boAgentPayServiceParams.daySingleTransaction.label"/><g:textField id="dayLimitTrans" name="dayLimitTrans"  value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'dayLimitTrans')}" onBlur="isNum(this)"/>
             <br/><g:message code="boAgentPayServiceParams.daySingleTransactionMoney.label"/><g:textField id="dayLimitMoney" name="dayLimitMoney"  value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'dayLimitMoney')}"  onBlur="fmoney(this,2)"/>元
             <br/><g:message code="boAgentPayServiceParams.monthSingleTransaction.label"/><g:textField id="monthLimitTrans" name="monthLimitTrans"  value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'monthLimitTrans')}" onBlur="isNum(this)"/>
             <br/><g:message code="boAgentPayServiceParams.monthSingleTransactionMoney.label"/><g:textField id="monthLimitMoney" name="monthLimitMoney"  value="${fieldValue(bean: boAgentPayServiceParamsInstance, field: 'monthLimitMoney')}"  onBlur="fmoney(this,2)"/>元
        </td>
      </tr>

      %{--<tr id="isBackFeeLabel">--}%
        %{--<td class="right label_name"><g:message code="boAgentPayServiceParams.isBackFee.label"/>：</td>--}%
        %{--<td>--}%
            %{--<select id="backFee" name="backFee">--}%
                %{--<option value="0" selected="selected">不退</option>--}%
                %{--<option value="1">退</option>--}%
            %{--</select>--}%
        %{--</td>--}%
      %{--</tr>--}%

      <tr id="settWayLabel">
        <td class="right label_name"><g:message code="boAgentPayServiceParams.settWay.label"/>：</td>
        <td>
            <select id="settWay" name="settWay">
                <option value="0" selected="selected">即扣</option>
                <option value="1">后返</option>
            </select>
            %{--<g:hiddenField name="settWay" value="1"/>后返--}%
        </td>
      </tr>

      <tr>
        <td class="right label_name"><g:message code="boAgentPayServiceParams.remark.label"/>：</td>
        <td><g:textArea id="remark" name="remark" rows="5" cols="100"></g:textArea></td>
      </tr>

      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="button" name="button" id="button" onclick="doSave()" class="rigt_button" value="确定"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>
<script type="text/javascript">
    if("${serviceCode}"=="agentcoll"){
        document.getElementById("gatherWayLabel").style.display="none";
        document.getElementById("isBackFeeLabel").style.display="none";
        document.getElementById("settWayLabel").style.display="none";
    }
</script>
</body>
</html>
