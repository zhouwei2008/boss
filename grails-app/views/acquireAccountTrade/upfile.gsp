
<%@ page import="boss.Perm; boss.BoBankDic; ismp.AcquireAccountTrade" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'acquireAccountTrade.label', default: 'AcquireAccountTrade')}"/>
  <title><g:message code="default.list.label" args="[entityName]"/></title>
    <g:javascript library="My97DatePicker/WdatePicker"/>
     <script language="JavaScript" type="text/javascript">
     //取银行账户号
          function setBankAccounts(id){
                  if(id==''){
                      $("#interfaced").empty();
                      $("#selectAcquirerAccount option").remove();
                      $("#selectAcquirerAccount").append("<option value=''>全部</option>");
                      $("#selectMerchant option").remove();
                      $("#selectMerchant").append("<option value=''>全部</option>");
                  }else{
            var baseUrl = "${createLink(controller:'acquireAccountTrade', action:'getAcquireAccountsJson')}";
               $.ajax({
                    url: baseUrl,
                    type: 'post',
                    dataType: 'json',
                    data:'bankCode='+ id,
                    error: function(){
                        alert('对不起，加载失败！');
                    },
                    success: function(json){
                              $("#interfaced").empty();
                              $("#selectAcquirerAccount option").remove();
                              $("#selectAcquirerAccount").append("<option value=''>全部</option>");
                              $("#selectMerchant option").remove();
                              $("#selectMerchant").append("<option value=''>全部</option>");
                             $.each(json,function(i){
                               $("#selectAcquirerAccount").append("<option value='"+json[i].id+"'>"+json[i].bankAccountNo+"</option>");
                             } )
                        }
                });
                  }
              }

          //取收单商户号
          function setMerchants(id){
                  if(id==''){
                      $("#interfaced").empty();
                      $("#selectMerchant option").remove();
                      $("#selectMerchant").append("<option value=''>全部</option>");
                  }else{
            var baseUrl = "${createLink(controller:'acquireAccountTrade', action:'getMerchantsJson')}";
               $.ajax({
                    url: baseUrl,
                    type: 'post',
                    dataType: 'json',
                    data:'acquirerAccountId='+ id,
                    error: function(){
                        alert('对不起，加载失败！');
                    },
                    success: function(json){
                              $("#interfaced").empty();
                              $("#selectMerchant option").remove();
                              $("#selectMerchant").append("<option value=''>全部</option>");
                             $.each(json,function(i){
                               $("#selectMerchant").append("<option value='"+json[i].ACQUIRE_MERCHANT+"'>"+json[i].ACQUIRE_MERCHANT+"</option>");
                             } )
                        }
                });
                  }
              }

           //取银行接口
          function setInterfaces(id){
              if(id==''){
                      $("#interfaced").empty();
                  }else{
            var baseUrl = "${createLink(controller:'acquireAccountTrade', action:'getInterfacesJson')}";
               $.ajax({
                    url: baseUrl,
                    type: 'post',
                    dataType: 'json',
                    data:'acquireMerchant='+ id,
                    error: function(){
                        alert('对不起，加载失败！');
                    },
                    success: function(json){
                             $("#interfaced").empty();
                        if(json.length>0) {
                             $("#interfaced").append('<span class="titleClass"><input type="checkbox" name="checkAllInterfaces" value="" id="checkAllInterfaces" onclick="checkAll(this)" checked="true"/>全选</span></br>');
                             $.each(json,function(i){
                                 var valued = json[i].channelDesc ?json[i].channelDesc :json[i].acquireName
                                $("#interfaced").append('<span class="titleClass"><input type="checkbox" name="interfaceIds" value="'+json[i].serviceCode+'" checked="true" onclick="checkOther()" />'+valued+'('+json[i].acquireIndexc+')'+'</span>');
                               if((i+1) % 3 == 0){
                                $("#interfaced").append('</br>');
                               }
                             })
                             }
                     }
                  });
              }
          }

          //全选
      function checkAll(obj){
                  if(obj.checked){
        $("#interfaced input[type='checkbox']").attr("checked",'true');//全选
        }else{
            $("#interfaced input[type='checkbox']").removeAttr("checked");//全不选
        }
        }

          //判断半全选
       function checkOther(){
           var ids = document.getElementsByName("interfaceIds");
           var ch=0;
           var len=ids.length;
           for(var i=0;i<ids.length;i++){
               if(ids[i].checked){
                   ch++;
               }
           }
           if(ch<len&&ch>0){
                 $("#checkAllInterfaces").removeAttr("checked");//移除全选
                 $("#checkAllInterfaces").attr("indeterminate",'true');//半选
           }
           if(ch==len){
                 $("#checkAllInterfaces").removeAttr("indeterminate");//移除半选
                 $("#checkAllInterfaces").attr("checked",'true');//全选
           }
           if(ch==0){
                $("#checkAllInterfaces").removeAttr("checked");//移除全选
                $("#checkAllInterfaces").removeAttr("indeterminate");//移除半选
           }
        }

    function check() {
        if (document.getElementById("selectBank").value.length == 0) {
            alert("请选择银行名称!");
            document.getElementById("selectBank").focus();
            return false;
        }
        var ids = document.getElementsByName("interfaceIds");
           var ch=0;
           var len=ids.length;
           for(var i=0;i<ids.length;i++){
               if(ids[i].checked){
                   ch++;
               }
           }
        if(len>0&&ch==0){
            alert("请至少选择一个银行接口!");
            return false;
        }
        if (document.getElementById("upFile").value == "") {
            alert("请选择要上传的文件!");
            document.getElementById("upFile").focus();
            return false;
        }
        if (document.getElementById("beginTime").value.length == 0&&document.getElementById("endTime").value.length == 0) {
            alert("请选择对账时间!");
            document.getElementById("beginTime").focus();
            return false;
        }
    }



        </script>
    <style type="text/css">
   .titleClass  {
       width: 240px;
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
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:if test="${flash.error}">
    <div class="errors">${flash.error}</div>
  </g:if>
 <g:if test="${msg}">
    <div class="message">${msg}</div>
  </g:if>
  <g:if test="${err}">
    <div class="errors">${err}</div>
  </g:if>
  <div class="right_top">
    <h1><img src="${resource(dir: 'images', file: 'ico_4.gif')}" width="16" height="15">上传银行对账文件</h1>
    <div class="table_serch">
        <g:form action="upLoad" method="post" enctype="multipart/form-data">
            <table id='uptable'>
                    <tr>
                        <td>对账银行：</td>
                        <td>
                            <g:select id ="selectBank" name="bankCode" from="${banks}" value="${params.bankCode}" optionKey="code" optionValue="name" noSelection="${['':'--请选择--']}" onchange="setBankAccounts(this.options[this.selectedIndex].value)"  style="width:150px"/>
                        </td>
                        <td>
                            银行账号：
                        </td>
                        <td>
                            <g:select id ="selectAcquirerAccount" name="acquirerAccountId" from="${bankAccounts}" value="${params.acquirerAccountId}" optionKey="id" optionValue="bankAccountNo" noSelection="${['':'全部']}" onchange="setMerchants(this.options[this.selectedIndex].value)"  style="width:150px"/>
                        </td>
                        <td>
                            收单商户号：
                        </td>
                        <td>
                          <select id="selectMerchant"  name="acquireMerchant" style="width:150px" onchange="setInterfaces(this.options[this.selectedIndex].value)">
                              <option value="" selected="true">全部</option>
                           </select>
                        </td>
                    </tr>
                    <tr>
                        <td>银行接口：</td>
                        <td  colspan="3">
                            <div id="interfaced" style="width:750px">
                                 <span class="titleClass"> </span>
                             </div>
                        </td>
                    </tr>
                     <tr>
                        <td>对账时间：</td>
                        <td colspan="3">
                            <input name="beginTime" id="beginTime" class='Wdate' type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'endTime\')}'})" value="${params.beginTime}" />
                            --<input name="endTime" id="endTime" class='Wdate' type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'beginTime\')}'})" value="${params.endTime}" />
                        </td>
                    </tr>
                     <tr>
                        <td>对账文件：</td>
                        <td colspan="3">
                            <input type="file" name="myFile" id="upFile"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                        <td><bo:hasPerm perm="${Perm.Gworder_AccountTrade_UpLoad}">
                            <g:actionSubmit class="right_top_h2_button_serch" value="上传" action="upLoad" onclick="return check()"/>
                           </bo:hasPerm>
                            <g:actionSubmit class="right_top_h2_button_tj1" value="返回对账结果列表" action="list" />
                        </td>

                    </tr>
            </table>
            </g:form>
     </div>
  </div>
</div>
</body>
</html>
