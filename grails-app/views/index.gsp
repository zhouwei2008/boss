<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <title>业务系统管理平台</title>
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

  }

   .white_content_showWait {
         display: none;
         position: absolute;
         top: 30%;
         left: 40%;
         width: 20%;
         padding: 6px 16px;
         border: 1px solid #555;
         background-color: #FFF;
         z-index:1002;
         overflow: auto;
        }
        .black_overlay_showWait {
         display: none;
         position: absolute;
         top: 0%;
         left: 0%;
         width: 100%;
         height: 100%;
         background-color:#333;
         z-index:1001;
         -moz-opacity: 0.5;
         opacity:.50;
         filter: alpha(opacity=50);
        }


  </style>
</head>
<SCRIPT language=JavaScript type=text/javascript>
  function check1(obj, menu) {

    if (obj.style.display == 'block') {
      obj.style.display = 'none';
      menu.src = "${resource(dir:'images', file:'Arrow_08.gif')}";
    }
    else {
      obj.style.display = 'block';
      menu.src = "${resource(dir:'images', file:'Arrow_07.gif')}";
    }

  }
  function check(obj) {
    if (obj.style.display == 'none') {
      obj.style.display = 'block'
    } else {
      obj.style.display = 'none'
    }
  }


  function showWait(){
             var light=document.getElementById('showWait_light');
             var fade=document.getElementById('showWait_fade');
             light.style.display='block';
             fade.style.display='block';
     }
    function hideWait(){
         var light=document.getElementById('showWait_light');
         var fade=document.getElementById('showWait_fade');
         light.style.display='none';
         fade.style.display='none';
    }

  function load(){
      var message = "${flash.message}";
      if(message !=null && message != ""){
          window.parent.right.location.href =  "${createLink(controller:'boOperator',action:'modPasswd')}?message="+message;
      }
  }
</SCRIPT>

<body style="overflow-x: hidden; overflow-y: auto;" onload="load()">
<table class="tabelmain">
  <tr>
    <td colspan="2" class="tabel_top">
      <iframe width="100%" height="96" src="${resource(dir:'/',file:'top.gsp')}" name="TOP" frameborder="0" scrolling="no"></iframe>
    </td>
  </tr>
  <tr>
    <td valign="top" class="tabel_left" height="99.9%" id=t1 style="display:block; width:220px;">
      <iframe width="220px" height="99.9%" src="${resource(dir:'/',file:'nav.gsp')}" frameborder="0" id="LEFT" name="LEFT" scrolling="auto"></iframe>
      <span><img src="${resource(dir: 'images', file: 'zwt.gif')}" width="194" height="1"></span>
    </td>
    <td align="left" valign="middle" class="tabel_right">
      <table width="100%" height="100%">
        <tr>
          <td style="width:10px;"><A href="javascript:check1(t1, mt1);void(0);"><IMG src="${resource(dir: 'images', file: 'Arrow_07.gif')}" name="mt1" border=0 id=mt1></A></td>
          <td><iframe width="100%" height="100%" src="" frameborder="0" id="right" scrolling="auto" name="right"></iframe></td>
        </tr>
      </table>

    </td>
  </tr>
</table>

<div id="showWait_light" class="white_content_showWait" align="center">
      <br/>
      <br/>
      <img src="${request.contextPath}/images/wait.gif" border="1"/>
      <br/>
      <br/>
      <strong>正在处理，请耐心等待……</strong>
      <br/>
      <br/>
</div>

<div id="showWait_fade" class="black_overlay_showWait"></div>
</body>
</html>
