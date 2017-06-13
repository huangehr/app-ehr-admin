<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    .f-pr0{padding-right: 0}
</style>

<input value="${weiDuId}" class="f-dn" id="inp_weiDuId"/>
<div id="div_weidu_info_form" data-role-form class="m-form-inline f-mt20" style="overflow:hidden" >
    <div>
        <div class="m-form-group">
            <label>编码：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_code" class="required useTitle max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="code"/>
            </div>
        </div>
        <div class="m-form-group ">
            <label>名称：</label>

            <div class="l-text-wrapper m-form-control essential ">
                <input type="text" id="inp_name" class="required useTitle max-length-50 validate-special-char"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name"/>
            </div>
        </div>
        <div class="m-form-group">
            <label>类型：</label>

            <div class="l-text-wrapper m-form-control essential f-pr0">
                <input type="text" id="inp_type" class="required"  required-title=<spring:message code="lbl.must.input"/> placeholder="请选择类型" data-type="select" data-attr-scan="type">
            </div>
        </div>
        <div class="m-form-group">
            <label>状态：</label>

            <div class="l-text-wrapper m-form-control essential f-pr0">
                <input type="text" id="inp_status" class="required"  required-title=<spring:message code="lbl.must.input"/> placeholder="请选择状态" data-type="select" data-attr-scan="status">
            </div>
        </div>
        <div class="m-form-group f-mb30">
            <label>备注：</label>
            <div class="l-text-wrapper m-form-control">
                <textarea id="inp_introduction" class="f-w240 description  max-length-256 validate-special-char" data-attr-scan="remark" ></textarea>
            </div>
        </div>
    </div>

    <div class="m-form-control pane-attribute-toolbar f-fr f-mr20">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" id="div_update_btn">
            <span>保存</span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
            <span>关闭</span>
        </div>
    </div>
</div>