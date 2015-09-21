<%@ page import="boss.BoRole" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>顶部</title>
  <link rel="stylesheet" href="${resource(dir: 'css', file: 'css.css')}"/>
</head>
<body>
	<div class="topmain">
    	<div class="logo"><img src="${resource(dir:'images', file:'logo.gif')}" alt="吉高" width="280" height="90" /></div>
        <div class="top_menu">
        	<ul>
            	<li><img src="${resource(dir:'images', file:'ico_1.gif')}" alt="用户" width="20" height="21" /></li>
                <li style="width:150px;">欢迎<span class="fonthong"><a href="${createLink(controller:'boOperator', action: 'view',id:session.op?.id)}" target="right">${session.op?.name}(${BoRole.findByRoleCode(session.op?.roleSet)?.roleName})</a></span></li>
                <li><img src="${resource(dir:'images', file:'ico_2.gif')}" alt="修改密码" width="20" height="21" /></li>
                <li style="width:50px"><a href="${createLink(controller:'boOperator',action:'modPasswd')}" target="right">修改密码</a></li>
                <li><img src="${resource(dir:'images', file:'ico_3.gif')}" alt="退出系统" width="20" height="21" /></li>
                <li style="width:50px"><a href="${createLink(controller:'login', action: 'logout')}">退出系统</a></li>
            </ul>
        </div>
        <div class="top_xh"></div>
</div>

</body>
</html>