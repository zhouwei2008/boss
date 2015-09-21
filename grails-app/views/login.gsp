
<%@ page import="javax.servlet.http.Cookie" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <title>业务系统管理平台</title>
     <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css', file: 'publicStyle.css')}" media="all"/>
     <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css', file: 'lgoin.css')}" media="all"/>
    <g:javascript library="prototype"/>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'PassGuardCtrl1026.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-1.4.4.min.js')}"></script>

     <style>
    .ocx_style{border:1px solid #7F9DB9; width:175px; height:22px;margin-left:1px}
    .down{border:1px solid #7F9DB9;	line-height: 20px;text-align:center;}
    </style>

    <script type="text/javascript">
        function dosubmit(){
            document.loginForm.submit();
        }

        document.onkeydown = function(event){
            event = getEvent(event);
            if(event.keyCode==13){
                do_login();
            }
        }

        function do_clean()
        {
            document.getElementById("account").value = "";
            document.getElementById("password").value = "";
            document.getElementById("loing_inpyzm").value = "";
            document.getElementById("mobile_captcha").value = "";
        }

        function do_login()
        {
            document.loginForm.submit();
        }

        function getCaptcha(){
            var account = document.getElementById("account").value;
            if(account == ''){
                alert("用户名不能为空！");
                return;
            }
            document.getElementById("btn_reload").disabled=true;
            smsTool.sendCaptcha(account)
        }

        var Server={
            sendRequest : function(url,data,callback){
                new Ajax.Request(url,{asynchronous:true,evalScripts:true,onSuccess:function(e){callback(e)},parameters:data});
            }
        }

        var timer0;

        var smsTool = {
            sendCaptcha : function(account){
                document.getElementById("btn_reload").disabled=true;
                timer0=setInterval("timere()",1000);
                var url = "login/sendMobileCaptcha?account="+account;
                Server.sendRequest(url,'',this.callbackSuccess);
            },
            callbackSuccess : function(response){
                alert("系统已经发送本次登陆的验证到您绑定的手机上了，请查收");
            }

        }

        var time=60;
        function timere()
        {
            if(time==0){
                document.getElementById("btn_reload").disabled  = false;
                document.getElementById("btn_reload").value =" 获取验证码 ";
                clearInterval(timer0);
                time = 60;
                return false;
            }
            time = time-1;
            document.getElementById("btn_reload").value = "  剩 余("+time+")  ";
        }



    </script>
</head>
%{--<%--}%
    %{--if(request.getSession() != null){--}%
        %{--request.getSession().invalidate();//清空session--}%
        %{--Cookie cookie = request.getCookies()[0];//获取cookie--}%
        %{--cookie.setMaxAge(0);//让cookie过期 ；--}%
    %{--}--}%
%{--%>--}%
<body>
<g:form controller="login" action="login" name="loginForm" onsubmit="dosubmit();return false;">
 <div class="loing_box">
            <div class="loing_cnt">
                <div class="loing_tab txtLeft">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                        <td width="26%" height="38" scope="col">用户名<br /></td>
                                        <td width="74%" scope="col" colspan="2"><label for="login"></label>
                                        <input class="loing_inp1" type="text" name="account" id="account" value="" onfocus="this.select();"/></td>
                                </tr>
                                <tr>
                                        <td height="31">密   &nbsp;码</td>
                                        <td colspan="2"><input class="loing_inp2" name="password" type="password" id="password" value="" onfocus="this.select();"/></td>
                                </tr>
                               <tr>
                                   <td height="31">验证码：</td>
                                  <td width="36%" class="txtLeft"><input class="loing_inpyzm" name="captcha" type="text" class="captchacla"></td>
                                  <td width="40%" class="txtLeft">&nbsp;<img src="${createLink(controller: 'captcha')}" alt="看不清换一张" width="59" height="18" onclick="this.src='${createLink(controller: 'captcha')}?'+new Date().getTime()"></td>
                                </tr>

                                <tr>
                                    <td height="31">手机验证码</td>
                                    <td class="txtLeft"><input class="loing_inpyzm" name="mobile_captcha" id="mobile_captcha" type="text" maxlength="6"></td>
                                    <td class="txtLeft">&nbsp; <input id="btn_reload" type="button" value="获取验证码" onClick="getCaptcha();return false;"/></td>
                                <tr>

                                <tr>
                                        <td height="38">&nbsp;</td>
                                        <td  colspan="2">
                                           <span class="loing_btn"><a href="javascript:void(0);" onClick="do_login();return false;">登录</a></span>
                                            <span class="loing_btn"><a href="javascript:void(0);" onClick="do_clean();return false;">重置</a></span>
                                        </td>
                                </tr>
                            <g:if test="${flash.message}">
							    <div class="message">${flash.message}</div>
						    </g:if>
                        </table>
                </div>
            </div>
            <p class="txtCenter">版权所有：吉高</p>
        </div>
</g:form>
</body>
</html>

