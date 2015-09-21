
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: '', default: '')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
    <g:javascript library="prototype"/>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'PassGuardCtrl1026.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-1.4.4.min.js')}"></script>

    <script type="text/javascript">
        $(function() {
                var  photoUrl = "${photoUrl}";
                var srcUrl = "${createLink(controller:'cmCorporationInfo',action:'previewPhoto')}?photoUrl="+photoUrl;
                $("#photo").attr("src",srcUrl);
        });
     </script>
</head>
<body>
<div class="main">
    <g:if test="${flash.message}">
        <div class="message" style="word-wrap: break-word;word-break:break-all;">${flash.message}</div>
    </g:if>

    <div class="right_top">

        <table id="myTable" align="center" class="rigt_tebl">
            <tr>
                <th colspan="2">图片预览</th>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <img src="" id="photo"/>
                </td>
            </tr>
          </table>
    </div>
</div>
</body>
</html>