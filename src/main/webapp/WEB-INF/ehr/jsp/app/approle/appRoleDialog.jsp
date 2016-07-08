<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######新增角色组页面######-->
<div id="div_add_appRole_group_form" data-role-form class="m-form-inline f-mt20 f-pb30" style="overflow:auto">

    <div class="m-form-group">
        <label>角色组ID</label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_appRole_groupId" class="required useTitle"
                   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="realName"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>角色组名称</label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_appRole_groupName" class="required useTitle ajax validate-id-number" required-title=
            <spring:message code="lbl.must.input"/> validate-id-number-title=<spring:message
                    code="ehr.user.invalid.identity.no"/> data-attr-scan="idCardNo"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>描述</label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_appRole_explain" data-attr-scan="idCardNo"/>
        </div>
    </div>
    <div class="m-form-control pane-attribute-toolbar">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar div-roleGroup-btn" id="div_add_roleGroup_btn">
            <span><spring:message code="btn.save"/></span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar div-roleGroup-btn" id="div_cancel_roleGroup_btn">
            <span><spring:message code="btn.close"/></span>
        </div>
    </div>
</div>