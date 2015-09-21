
<%@ page import="boss.Perm; ismp.TbRiskControl" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'tbRiskControl.label', default: '交易规则')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body style="overflow-x:hidden">
<div class="main">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>

  <table align="center" class="rigt_tebl">
    <tr>
      <th colspan="2"><g:message code="default.show.label" args="[entityName]"/></th>
    </tr>

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
          <td class="right label_name"><g:message code="规则状态"/>：</td>
          <td><span class="rigt_tebl_font">${TbRiskControl.StatusMap[tbRiskControlInstance?.status]}</span></td>
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
          <td class="right label_name"><g:message code="审核人"/>：</td>
          <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskControlInstance, field: "verifyOp")}</span></td>
      </tr>

      <tr>
          <td class="right label_name"><g:message code="审核时间"/>：</td>
          <td><span class="rigt_tebl_font">${fieldValue(bean: tbRiskControlInstance, field: "verifyTime")}</span></td>
      </tr>

    <tr>
      <td colspan="2" align="center">
        <g:form>
          <g:hiddenField name="id" value="${tbRiskControlInstance?.id}"/>
          <span class="button"><input type="button" class="rigt_button back_btn" value="返回"/></span>
               <bo:hasPerm perm="${Perm.RiskManager_Risk_Rule_Edit}">
                  <span class="button"><g:actionSubmit class="rigt_button" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>
               </bo:hasPerm>
              <bo:hasPerm perm="${Perm.RiskManager_Risk_Rule_Delete}">
                 <span class="button"><g:actionSubmit class="rigt_button" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: '确认删除?')}');"/></span>
              </bo:hasPerm>
          </g:form>
      </td>
    </tr>
  </table>

</div>
</body>
</html>