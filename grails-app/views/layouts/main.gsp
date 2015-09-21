<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http：//www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
  <title><g:layoutTitle default="支付管理后台"/></title>
  <%--link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}"/--%>
  <link rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}"/>
  <link rel="stylesheet" href="${resource(dir: 'css', file: 'css.css')}"/>
  <g:layoutHead/>
  <g:javascript library="jquery-1.4.4.min"/>
  <g:javascript library="jquery-ui-1.8.7.custom.min"/>
  <g:javascript library="jquery.form"/>
  <g:javascript library="jquery.validate"/>
  <g:javascript library="json2"/>
  <g:javascript library="region"/>
  <g:javascript library="application"/>
</head>
<body>
<div id="spinner" class="spinner" style="display:none;">
  <img src="${resource(dir: 'images', file: 'spinner.gif')}" alt="${message(code: 'spinner.alt', default: 'Loading...')}"/>
</div>

<script type="text/javascript">
  $(function() {
    $(".back_btn").click(function() {
      window.history.back();
    })
  })
</script>

<g:layoutBody/>
</body>
</html>