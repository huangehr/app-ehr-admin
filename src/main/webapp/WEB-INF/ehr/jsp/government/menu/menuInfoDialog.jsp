<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<%@ include file="menuInfoDialogCss.jsp" %>
<input value="${id}" class="f-dn" id="health_id"/>
<div id="div_patient_info_form" data-role-form class="m-form-inline f-mt20" style="overflow:auto">
    <div>
        <div class="m-form-group">
            <label>编码：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_code" class="required ajax useTitle max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="code"/>
            </div>
        </div>
        <div class="m-form-group ">
            <label>名称：</label>

            <div class="l-text-wrapper m-form-control essential ">
                <input type="text" id="inp_name" class="required useTitle ajax" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name"/>
            </div>
        </div>

        <div class="m-form-group">
            <label>链接地址：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_url" class="required useTitle ajax" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="url"/>
            </div>
        </div>

        <div class="m-form-group">
            <label>状态：</label>

            <div class="u-checkbox-wrap m-form-control">
                <input type="radio" value="1" name="inp_status">有效
                <input type="radio" value="0" name="inp_status">失效
            </div>
        </div>
    </div>

    <div class="m-form-control pane-attribute-toolbar" style="text-align: right;">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" id="div_update_btn">
            <span>保存</span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
            <span>关闭</span>
        </div>
    </div>
</div>

<input type="hidden" id="execTime">


<script src="${staticRoot}/lib/ligerui/plugins/ligerSpinner.js"></script>
<%@ include file="menuInfoDialogJs.jsp" %>

