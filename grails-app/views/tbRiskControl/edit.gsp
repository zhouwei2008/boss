

<%@ page import="ismp.TbRiskControl" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbRiskControl.label', default: '交易规则')}"/>
  <title><g:message code="default.edit.label" args="[entityName]"/></title>
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


  <g:form action="${verify == ''?'update':'updateStatus'}" name="updateForm ">

    <g:hiddenField name="id" value="${tbRiskControlInstance?.id}"/> 
    <table align="center" class="rigt_tebl">
      <tr>
        <th colspan="2"><g:message code="default.edit.label" args="[entityName]"/></th>
      </tr>

        <g:if test="${verify != ''}">
            <tr>
                <td class="right label_name"><g:message code="业务类型"/>：</td>

                <td><span class="rigt_tebl_font">${TbRiskControl.BTypeMap[tbRiskControlInstance?.bType]}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="规则简介"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskControlInstance, field: "ruleAbout")}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="规则描述"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskControlInstance, field: "bDesc")}</span></td>

            </tr>


            <tr>
                <td class="right label_name"><g:message code="规则脚本"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskControlInstance, field: "rule")}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="规则参数"/>：</td>

                <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskControlInstance, field: "ruleParams")}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="创建人"/>：</td>
                <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskControlInstance, field: "createOp")}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="创建时间"/>：</td>
                <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskControlInstance, field: "createTime")}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="编辑人"/>：</td>
                <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskControlInstance, field: "editOp")}</span></td>
            </tr>

            <tr>
                <td class="right label_name"><g:message code="编辑时间"/>：</td>
                <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskControlInstance, field: "editTime")}</span></td>
            </tr>

            <tr>
                <td class="right label_name">规则状态：</td>
                <td class="${hasErrors(bean: tbRiskControlInstance, field: 'status', 'errors')}"><g:select name="status"  value="${tbRiskControlInstance?.status}" from="${TbRiskControl.StatusMap}" optionKey="key" optionValue="value" /></td>
            </tr>

        </g:if>
        <g:else>
            <tr>
                <td class="right label_name">业务类型：</td>
                <td class="${hasErrors(bean: tbRiskControlInstance, field: 'bType', 'errors')}"><g:select name="bType" value="${tbRiskControlInstance?.bType}" from="${tbRiskControlInstance.BTypeMap}"  optionKey="key" optionValue="value"/></td>
            </tr>

            <tr>
                <td class="right label_name">规则简介：</td>
                <td class="${hasErrors(bean: tbRiskControlInstance, field: 'ruleAbout', 'errors')}"><g:textField name="ruleAbout" maxlength="32" value="${tbRiskControlInstance?.ruleAbout}" /></td>
            </tr>

            <tr>
                <td class="right label_name">规则描述：</td>
                <td class="${hasErrors(bean: tbRiskControlInstance, field: 'bDesc', 'errors')}"><g:textArea name="bDesc" cols="40" rows="5" value="${tbRiskControlInstance?.bDesc}" /></td>
            </tr>

            <tr>
                <td class="right label_name">规则脚本：</td>
                <td class="${hasErrors(bean: tbRiskControlInstance, field: 'rule', 'errors')}"><g:textArea name="rule" cols="40" rows="5" value="${tbRiskControlInstance?.rule}" /></td>
            </tr>

            <tr>
                <td class="right label_name">规则参数：</td>
                <td class="${hasErrors(bean: tbRiskControlInstance, field: 'ruleParams', 'errors')}"><g:textField name="ruleParams" maxlength="50" value="${tbRiskControlInstance?.ruleParams}" /></td>
            </tr>
        </g:else>

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
        $("#updateForm").validate({
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
