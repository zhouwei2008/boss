<%@ page import="boss.Perm; ismp.CmCorporationInfo; ismp.CmCustomer; boss.ReportAllServicesDaily" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName"
           value="${message(code: 'reportAllServicesDaily.label', default: 'ReportAllServicesDaily')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <style type="text/css">
   .titleClass  {
       text-align: left;
       padding-left: 1px;
       float: left;
}
         #uptable td  {
       text-align: left;
       padding-left: 10px;
}
    </style>
</head>

<body>
<div class="main">
    <script type="text/javascript">
    $(function() {
        $("#startDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        $("#endDateCreated").datepicker({ dateFormat: 'yy-mm-dd',changeYear: true, changeMonth: true });
        if(${params.allServiceTypes == '1'}){
           $("#allServiceTypes").attr("indeterminate",'true');//半选
        }

    });

    function empty() {
        $(':input') .not(':button, :submit, :reset, :hidden,:checkbox')
        .val('').removeAttr('selected');
       $("input[type='checkbox']")
        .removeAttr('checked')
        .removeAttr("indeterminate");
        return false;
    }
     //全选
   function checkAll(obj){
      if(obj.checked){
        $("input[type='checkbox']").attr("checked",'true');//全选
        }else{
            $("input[type='checkbox']").removeAttr("checked");//全不选
        }
        }

          //判断半全选
       function checkOther(){
           var ids = document.getElementsByName("serviceType");
           var ch=0;
           var len=ids.length;
           for(var i=0;i<ids.length;i++){
               if(ids[i].checked){
                   ch++;
               }
           }
           if(ch<len&&ch>0){
                 $("#allServiceTypes").removeAttr("checked");//移除全选
                 $("#allServiceTypes").attr("indeterminate",'true');//半选
           }
           if(ch==len){
                 $("#allServiceTypes").removeAttr("indeterminate");//移除半选
                 $("#allServiceTypes").attr("checked",'true');//全选
           }
           if(ch==0){
                $("#allServiceTypes").removeAttr("checked");//移除全选
                $("#allServiceTypes").removeAttr("indeterminate");//移除半选
           }
        }

     function check() {

        var ids = document.getElementsByName("serviceType");
           var ch=0;
           var len=ids.length;
           for(var i=0;i<ids.length;i++){
               if(ids[i].checked){
                   ch++;
               }
           }
        if(len>0&&ch==0){
            alert("请至少选择一个业务类型!");
            return false;
        }
        var startDateCreated = document.getElementById('startDateCreated').value.replace(/-/g,"//");
        var endDateCreated = document.getElementById('endDateCreated').value.replace(/-/g,"//");
        if (endDateCreated.length != 0) {
            if (Number(startDateCreated > endDateCreated)) {
                alert('开始时间不能大于结束时间!');
                document.getElementById('endDateCreated').focus();
                return false;
            }
        }
    }
</script>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="right_top">
        <h1>${message(code: 'reportAllServicesDaily.label', default: '')}</h1>
        <div class="table_serch">
            <table>
                <g:form>
                    <tr>
                        <td>${message(code: 'reportAllServicesDaily.serviceType.label')}：</td>
                        <td colspan="7">
                            <span class="titleClass">
                             <g:if test="${params.allServiceTypes == '2'}">
                            <input type="checkbox" name="allServiceTypes" value="" id="allServiceTypes" onclick="checkAll(this)" checked="true"/>全选</span>
                            </g:if>
                            <g:if test="${params.allServiceTypes == '1'}">
                            <input type="checkbox" name="allServiceTypes" value="" id="allServiceTypes" onclick="checkAll(this)" indeterminate="true"/>全选</span>
                            </g:if>
                            <g:if test="${params.allServiceTypes == '0'}">
                            <input type="checkbox" name="allServiceTypes" value="" id="allServiceTypes" onclick="checkAll(this)" />全选</span>
                            </g:if>
                            </br>
                             <span class="titleClass">
                            <g:each in="${ReportAllServicesDaily.serviceMap}" status="nx" var="serviceCode">

                             <g:if test="${(params.serviceType instanceof String) && params.serviceType==serviceCode.key}">
                               <input type="checkBox" name="serviceType" value="${serviceCode.key}" onclick="checkOther()"  checked="true" /> ${serviceCode.value}
                            </g:if>
                                <g:elseif test="${!(params.serviceType instanceof String)&&(serviceCode.key in params.serviceType)}">
                                    <input type="checkBox" name="serviceType" value="${serviceCode.key}" onclick="checkOther()"  checked="true" /> ${serviceCode.value}
                                </g:elseif>
                                <g:else>
                                    <input type="checkBox" name="serviceType" value="${serviceCode.key}" onclick="checkOther()" /> ${serviceCode.value}
                                </g:else>
                       </g:each>  </span>
                        </td>
                    </tr>
                    <tr>
                        <td>${message(code: 'reportAllServicesDaily.customerRegion.label')}：</td>
                        <td><p><g:textField name="region"  value="${params.region}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'reportAllServicesDaily.customerName.label')}：</td>
                        <td><p><g:textField name="customerName"  value="${params.customerName}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'reportAllServicesDaily.customerNo.label')}：</td>
                        <td><p><g:textField name="customerNo"  value="${params.customerNo}"  onblur="value=value.replace(/[ ]/g,'')"  class="right_top_h2_input"/></p></td>
                        <td>${message(code: 'reportAllServicesDaily.customerType.label')}：</td>
                        <td><p><g:select name="customerType" from="${ReportAllServicesDaily.customerTypeMap}" value="${params.customerType}" optionKey="key" optionValue="value"  class="right_top_h2_input"  noSelection="${['':'全部']}" /></p></td>
                    </tr>
                    <tr>
                    <td>${message(code: 'reportAllServicesDaily.tradeFinishdate.label')}：</td>
                    <td><p><g:textField name="startDateCreated" id='startDateCreated' onchange="checkDate()" onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.startDateCreated}" class="right_top_h2_input"/>--<g:textField name="endDateCreated"  id='endDateCreated' onblur="value=value.replace(/[ ]/g,'')" style="width:80px" value="${params.endDateCreated}" onchange="checkDate()" class="right_top_h2_input"/><p></td>
                    <td>${message(code: 'reportAllServicesDaily.displayType.label', default: '')}:</td>
                    <td><p><g:select name="selType" from="${ReportAllServicesDaily.selTypeMap}" value="${params.selType}" optionKey="key" optionValue="value"  class="right_top_h2_input"/></p></td>
                    </tr>
                    <tr>
                        <td> &nbsp;</td>
                        <td><g:actionSubmit class="right_top_h2_button_serch" action="list" value="查询" onclick="return check()"/></td>
                        <td><g:actionSubmit class="right_top_h2_button_clear" action="" value="清空" onclick="return empty()"/></td>
                        <bo:hasPerm perm="${Perm.Report_AllServicesDaily_Dl}">
                        <td><g:actionSubmit class="right_top_h2_button_download" action="listDownload" value="下载" onclick="return check()" /></td>
                         </bo:hasPerm>
                    </tr>
                    <g:hiddenField name="applyTest" value="0007"/>
                </g:form>
            </table>
        </div>


        <table align="center" class="right_list_table" id="test">
            <tr>
                <th rowspan="2">${message(code: 'reportAllServicesDaily.customerRegion.label', default: '')}</th>

                <th rowspan="2">${message(code: 'reportAllServicesDaily.customerName.label', default: '')}</th>
                <g:each in="${params.serviceType}" status="ie" var="ite">
                     <th colspan="4">${ReportAllServicesDaily.serviceMap.get(ite)}</th>
                 </g:each>
                <th colspan="4">${message(code: 'reportAllServicesDaily.total.label', default: '')}</th>
            </tr>
            <tr>
            <g:each in="${params.serviceType}" status="ip" var="itp">
		<g:if test="${itp == 'online'}">
	        <g:sortableColumn params="${params}" property="oc" title="${message(code: 'reportAllServicesDaily.tradeCount.label', default: 'tradeCount')}"/>
	        <g:sortableColumn params="${params}" property="oa" title="${message(code: 'reportAllServicesDaily.tradeNetAmount.label', default: 'tradeNetAmount')}"/>
	        <g:sortableColumn params="${params}" property="nf" title="${message(code: 'reportAllServicesDaily.tradeNetFee.label', default: 'tradeNetFee')}"/>
	        <g:sortableColumn params="${params}" property="nf" title="${message(code: 'reportAllServicesDaily.tradeBankFee.label', default: 'tradeBankFee')}"/>
                </g:if>
		<g:if test="${itp == 'royalty'}">
	        <g:sortableColumn params="${params}" property="rc" title="${message(code: 'reportAllServicesDaily.tradeCount.label', default: 'tradeCount')}"/>
	        <g:sortableColumn params="${params}" property="ra" title="${message(code: 'reportAllServicesDaily.tradeNetAmount.label', default: 'tradeNetAmount')}"/>
	        <g:sortableColumn params="${params}" property="rf" title="${message(code: 'reportAllServicesDaily.tradeNetFee.label', default: 'tradeNetFee')}"/>
	        <g:sortableColumn params="${params}" property="rf" title="${message(code: 'reportAllServicesDaily.tradeBankFee.label', default: 'tradeBankFee')}"/>
                </g:if>
		<g:if test="${itp == 'agentcoll'}">
	        <g:sortableColumn params="${params}" property="sc" title="${message(code: 'reportAllServicesDaily.tradeCount.label', default: 'tradeCount')}"/>
	        <g:sortableColumn params="${params}" property="sa" title="${message(code: 'reportAllServicesDaily.tradeNetAmount.label', default: 'tradeNetAmount')}"/>
	        <g:sortableColumn params="${params}" property="sf" title="${message(code: 'reportAllServicesDaily.tradeNetFee.label', default: 'tradeNetFee')}"/>
	        <g:sortableColumn params="${params}" property="sf" title="${message(code: 'reportAllServicesDaily.tradeBankFee.label', default: 'tradeBankFee')}"/>
                </g:if>
		<g:if test="${itp == 'agentpay'}">
	        <g:sortableColumn params="${params}" property="fc" title="${message(code: 'reportAllServicesDaily.tradeCount.label', default: 'tradeCount')}"/>
	        <g:sortableColumn params="${params}" property="fa" title="${message(code: 'reportAllServicesDaily.tradeNetAmount.label', default: 'tradeNetAmount')}"/>
	        <g:sortableColumn params="${params}" property="ff" title="${message(code: 'reportAllServicesDaily.tradeNetFee.label', default: 'tradeNetFee')}"/>
	        <g:sortableColumn params="${params}" property="ff" title="${message(code: 'reportAllServicesDaily.tradeBankFee.label', default: 'tradeBankFee')}"/>
                </g:if>
		<g:if test="${itp == 'transfer'}">
	        <g:sortableColumn params="${params}" property="tc" title="${message(code: 'reportAllServicesDaily.tradeCount.label', default: 'tradeCount')}"/>
	        <g:sortableColumn params="${params}" property="ta" title="${message(code: 'reportAllServicesDaily.tradeNetAmount.label', default: 'tradeNetAmount')}"/>
	        <g:sortableColumn params="${params}" property="tf" title="${message(code: 'reportAllServicesDaily.tradeNetFee.label', default: 'tradeNetFee')}"/>
	        <g:sortableColumn params="${params}" property="tf" title="${message(code: 'reportAllServicesDaily.tradeBankFee.label', default: 'tradeBankFee')}"/>
                </g:if>
		<g:if test="${itp == 'charge'}">
	        <g:sortableColumn params="${params}" property="cc" title="${message(code: 'reportAllServicesDaily.tradeCount.label', default: 'tradeCount')}"/>
	        <g:sortableColumn params="${params}" property="ca" title="${message(code: 'reportAllServicesDaily.tradeNetAmount.label', default: 'tradeNetAmount')}"/>
	        <g:sortableColumn params="${params}" property="cf" title="${message(code: 'reportAllServicesDaily.tradeNetFee.label', default: 'tradeNetFee')}"/>
	        <g:sortableColumn params="${params}" property="cf" title="${message(code: 'reportAllServicesDaily.tradeBankFee.label', default: 'tradeBankFee')}"/>
                </g:if>
		<g:if test="${itp == 'withdrawn'}">
	        <g:sortableColumn params="${params}" property="wc" title="${message(code: 'reportAllServicesDaily.tradeCount.label', default: 'tradeCount')}"/>
	        <g:sortableColumn params="${params}" property="wa" title="${message(code: 'reportAllServicesDaily.tradeNetAmount.label', default: 'tradeNetAmount')}"/>
	        <g:sortableColumn params="${params}" property="wf" title="${message(code: 'reportAllServicesDaily.tradeNetFee.label', default: 'tradeNetFee')}"/>
	        <g:sortableColumn params="${params}" property="wf" title="${message(code: 'reportAllServicesDaily.tradeBankFee.label', default: 'tradeBankFee')}"/>
                </g:if>
		</g:each>
	        <g:sortableColumn params="${params}" property="sac" title="${message(code: 'reportAllServicesDaily.tradeCountTotal.label', default: 'tradeCountTotal')}"/>
	        <g:sortableColumn params="${params}" property="saa" title="${message(code: 'reportAllServicesDaily.tradeNetAmountTotal.label', default: 'tradeNetAmountTotal')}"/>
	        <g:sortableColumn params="${params}" property="saf" title="${message(code: 'reportAllServicesDaily.tradeNetFeeTotal.label', default: 'tradeNetFeeTotal')}"/>
	        <g:sortableColumn params="${params}" property="saf" title="${message(code: 'reportAllServicesDaily.tradeBankFeeTotal.label', default: 'tradeBankFeeTotal')}"/>
             </tr>

            <g:each in="${reportAllServicesDailyInstanceList}" status="im" var="instance">
                <tr class="${(im % 2) == 0 ? 'odd' : 'even'}">
                    <td>${CmCorporationInfo.get(instance.CUSTOMER_ID)?.belongToArea}</td>
                    <td>${CmCustomer.get(instance.CUSTOMER_ID)?.name}</td>
                    <g:each in="${params.serviceType}" status="iw" var="itw">
                        <g:if test="${itw == 'online'}">
                                    <td>${instance.OC?instance.OC:0}</td>
                                    <td><g:formatNumber number="${instance.OA?(instance.OA as Long)/100:0.00}" format="#.##"/></td>
                                    <td><g:formatNumber number="${instance.NF?(instance.NF as Long)/100:0.00}" format="#.##"/></td>
                                    <td>&nbsp;</td>
                        </g:if>
                        <g:if test="${itw == 'royalty'}">
                                    <td>${instance.RC?instance.RC:0}</td>
                                    <td><g:formatNumber number="${instance.RA?(instance.RA as Long)/100:0.00}" format="#.##"/></td>
                                    <td><g:formatNumber number="${instance.RF?(instance.RF as Long)/100:0.00}" format="#.##"/></td>
                                    <td>&nbsp;</td>
                        </g:if>
                        <g:if test="${itw == 'agentcoll'}">
                                    <td>${instance.SC?instance.SC:0}</td>
                                    <td><g:formatNumber number="${instance.SA?(instance.SA as Long)/100:0.00}" format="#.##"/></td>
                                    <td><g:formatNumber number="${instance.SF?(instance.SF as Long)/100:0.00}" format="#.##"/></td>
                                    <td>&nbsp;</td>
                        </g:if>
                        <g:if test="${itw == 'agentpay'}">
                                    <td>${instance.FC?instance.FC:0}</td>
                                    <td><g:formatNumber number="${instance.FA?(instance.FA as Long)/100:0.00}" format="#.##"/></td>
                                    <td><g:formatNumber number="${instance.FF?(instance.FF as Long)/100:0.00}" format="#.##"/></td>
                                    <td>&nbsp;</td>
                        </g:if>
                        <g:if test="${itw == 'transfer'}">
                                    <td>${instance.TC?instance.TC:0}</td>
                                    <td><g:formatNumber number="${instance.TA?(instance.TA as Long)/100:0.00}" format="#.##"/></td>
                                    <td><g:formatNumber number="${instance.TF?(instance.TF as Long)/100:0.00}" format="#.##"/></td>
                                    <td>&nbsp;</td>
                        </g:if>
                        <g:if test="${itw == 'charge'}">
                                    <td>${instance.CC?instance.CC:0}</td>
                                    <td><g:formatNumber number="${instance.CA?(instance.CA as Long)/100:0.00}" format="#.##"/></td>
                                    <td><g:formatNumber number="${instance.CF?(instance.CF as Long)/100:0.00}" format="#.##"/></td>
                                    <td>&nbsp;</td>
                        </g:if>
                        <g:if test="${itw == 'withdrawn'}">
                                    <td>${instance.WC?instance.WC:0}</td>
                                    <td><g:formatNumber number="${instance.WA?(instance.WA as Long)/100:0.00}" format="#.##"/></td>
                                    <td><g:formatNumber number="${instance.WF?(instance.WF as Long)/100:0.00}" format="#.##"/></td>
                                    <td>&nbsp;</td>
                        </g:if>
                    </g:each>
                     <td>${instance.SAC?instance.SAC:0}</td>
                     <td><g:formatNumber number="${instance.SAA?(instance.SAA as Long)/100:0.00}" format="#.##"/></td>
                     <td><g:formatNumber number="${instance.SAF?(instance.SAF as Long)/100:0.00}" format="#.##"/></td>
                     <td>&nbsp;</td>
                </tr>
            </g:each>
            <tr>
                <td colspan="2">${message(code: 'reportAllServicesDaily.total.label', default: '')}:${reportAllServicesDailyInstanceTotal}</td>
                <g:each in="${params.serviceType}" status="iu" var="itt">
                    <g:if test="${itt == 'online'}">
                        <td>${totalAgent.toc?totalAgent.toc:0}</td>
                        <td><g:formatNumber number="${totalAgent.toa?(totalAgent.toa as Long)/100:0.00}" format="#.##"/></td>
                        <td><g:formatNumber number="${totalAgent.tnf?(totalAgent.tnf as Long)/100:0.00}" format="#.##"/></td>
                        <td>&nbsp;</td>
		            </g:if>
		            <g:if test="${itt == 'royalty'}">
                        <td>${totalAgent.trc?totalAgent.trc:0}</td>
                        <td><g:formatNumber number="${totalAgent.tra?(totalAgent.tra as Long)/100:0.00}" format="#.##"/></td>
                        <td><g:formatNumber number="${totalAgent.trf?(totalAgent.trf as Long)/100:0.00}" format="#.##"/></td>
                        <td>&nbsp;</td>
		            </g:if>
		            <g:if test="${itt == 'agentcoll'}">
                        <td>${totalAgent.tsc?totalAgent.tsc:0}</td>
                        <td><g:formatNumber number="${totalAgent.tsa?(totalAgent.tsa as Long)/100:0.00}" format="#.##"/></td>
                        <td><g:formatNumber number="${totalAgent.tsf?(totalAgent.tsf as Long)/100:0.00}" format="#.##"/></td>
                        <td>&nbsp;</td>
		            </g:if>
		            <g:if test="${itt == 'agentpay'}">
                        <td>${totalAgent.tfc?totalAgent.tfc:0}</td>
                        <td><g:formatNumber number="${totalAgent.tfa?(totalAgent.tfa as Long)/100:0.00}" format="#.##"/></td>
                        <td><g:formatNumber number="${totalAgent.tff?(totalAgent.tff as Long)/100:0.00}" format="#.##"/></td>
                        <td>&nbsp;</td>
                    </g:if>
                    <g:if test="${itt == 'transfer'}">
                                <td>${totalAgent.ttc?totalAgent.ttc:0}</td>
                                <td><g:formatNumber number="${totalAgent.tta?(totalAgent.tta as Long)/100:0.00}" format="#.##"/></td>
                                <td><g:formatNumber number="${totalAgent.ttf?(totalAgent.ttf as Long)/100:0.00}" format="#.##"/></td>
                                <td>&nbsp;</td>
                    </g:if>
                    <g:if test="${itt == 'charge'}">
                                <td>${totalAgent.tcc?totalAgent.tcc:0}</td>
                                <td><g:formatNumber number="${totalAgent.tca?(totalAgent.tca as Long)/100:0.00}" format="#.##"/></td>
                                <td><g:formatNumber number="${totalAgent.tcf?(totalAgent.tcf as Long)/100:0.00}" format="#.##"/></td>
                                <td>&nbsp;</td>
                    </g:if>
                    <g:if test="${itt == 'withdrawn'}">
                                <td>${totalAgent.twc?totalAgent.twc:0}</td>
                                <td><g:formatNumber number="${totalAgent.twa?(totalAgent.twa as Long)/100:0.00}" format="#.##"/></td>
                                <td><g:formatNumber number="${totalAgent.twf?(totalAgent.twf as Long)/100:0.00}" format="#.##"/></td>
                                <td>&nbsp;</td>
                    </g:if>
                  </g:each>
                <td>${totalAgent.tsac?totalAgent.tsac:0}</td>
                <td><g:formatNumber number="${totalAgent.tsaa?(totalAgent.tsaa as Long)/100:0.00}" format="#.##"/></td>
                <td><g:formatNumber number="${totalAgent.tsaf?(totalAgent.tsaf as Long)/100:0.00}" format="#.##"/></td>
                <td>&nbsp;</td>
            </tr>
        </table>

        <div class="paginateButtons">
            <span style=" float:left;">共${reportAllServicesDailyInstanceTotal}条记录</span>
            <g:paginat total="${reportAllServicesDailyInstanceTotal}" params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>
