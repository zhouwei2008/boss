

<%@ page import="ismp.TbRiskControl" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="风险交易规则"/>
  <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:hasErrors bean="${tbRiskControlInstance}">
    <div class="errors">
      <g:renderErrors bean="${tbRiskControlInstance}" as="list"/>
    </div>
  </g:hasErrors>

  <g:form action="save" name="saveForm">
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.create.label" args="[entityName]"/></th>
      </tr>

        <tr>
            <td class="right label_name">业务类型：</td>
            <td class="${hasErrors(bean: tbRiskControlInstance, field: 'bType', 'errors')}"><g:select name="bType" from="${TbRiskControl.BTypeMap}" optionKey="key" optionValue="value" /></td>
        </tr>

        <tr>
            <td class="right label_name">规则简介：</td>
            <td class="${hasErrors(bean: tbRiskControlInstance, field: 'ruleAbout', 'errors')}"><g:textField name="ruleAbout" maxlength="32" value="${tbRiskControlInstance?.ruleAbout}"/></td>
        </tr>

      <tr>
        <td class="right label_name">规则描述：</td>
        <td class="${hasErrors(bean: tbRiskControlInstance, field: 'bDesc', 'errors')}"><g:textArea name="bDesc" cols="40" rows="5" value="${tbRiskControlInstance?.bDesc}"/></td>
      </tr>
      
      <tr>
        <td class="right label_name">规则脚本：</td>
        <td class="${hasErrors(bean: tbRiskControlInstance, field: 'rule', 'errors')}"><g:textArea name="rule" cols="40" rows="5" value="${tbRiskControlInstance?.rule}"/></td>
      </tr>

        <tr>
            <td class="right label_name">规则参数：</td>
            <td class="${hasErrors(bean: tbRiskControlInstance, field: 'ruleParams', 'errors')}"><g:textField name="ruleAbout" maxlength="50" value="${tbRiskControlInstance?.ruleParams}" /></td>
        </tr>

      <tr>
        <td colspan="2" align="center">
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
          <span class="content"><input type="submit" name="button" id="button" class="rigt_button" value="确定"></span>
        </td>
      </tr>
    </table>

  </g:form>
</div>

<script type="text/javascript">
    $(function() {
        $("#saveForm").validate({
            rules: {
                ruleAbout: {required: true},
                bDesc: {required: true},
                rule: {required: true}
            },
            focusInvalid: false,
            onkeyup: false
        });
    })
</script>
</body>
</html>
