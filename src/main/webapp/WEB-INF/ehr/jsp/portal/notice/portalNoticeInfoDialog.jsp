<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######医生管理页面 > 医生信息对话框模板页######-->
<div id="div_info_form" data-role-form class="m-form-inline f-mt20 f-pb10" style="overflow:auto">
    <input data-attr-scan="id" hidden="hidden"/>
    <%--保存初始数据------%>

    <div class="m-form-group">
        <label><spring:message code="lbl.portalNotice.type"/><spring:message code="spe.colon"/></label>
        <div class="m-form-control">
            <input type="text" id="inp_select_type" data-type="select" data-attr-scan="type">
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.portalNotice.title"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_title" class="required useTitle max-length-50 validate-special-char" data-attr-scan="title"  required-title=<spring:message code="lbl.must.input"/> />
        </div>
    </div>
    <div class="m-form-group" id="inp_content_div">
        <label><spring:message code="lbl.portalNotice.content"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <textarea id="inp_content" class="required f-w240 description  max-length-256 validate-special-char" data-attr-scan="content" required-title=<spring:message code="lbl.must.input"/>></textarea>
        </div>
    </div>

    <div id="div_toolbar" class="m-form-control pane-attribute-toolbar">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" id="div_update_btn">
            <span><spring:message code="btn.save"/></span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
            <span><spring:message code="btn.close"/></span>
        </div>
    </div>

</div>