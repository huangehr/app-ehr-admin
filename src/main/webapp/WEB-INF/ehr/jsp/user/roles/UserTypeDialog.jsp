<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<div id="div_feature_config">
    <div class="f-ml10 f-mb10 f-mt10">
        <div class="m-form-group">
            <label><spring:message code="lbl.name"/><spring:message code="spe.colon"/></label>
            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_userName" class="required useTitle max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="realName"/>
            </div>
        </div>
        <div class="m-form-group">
            <label><spring:message code="lbl.identity.card"/><spring:message code="spe.colon"/></label>
            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_idCard" class="required useTitle ajax validate-id-number"  required-title=<spring:message code="lbl.must.input"/> validate-id-number-title=<spring:message code="ehr.user.invalid.identity.no"/>  data-attr-scan="idCardNo"/>
            </div>
        </div>
    </div>
    <div class="f-mw100"><div class="f-mw50 f-fl f-ml10 f-mb10">全部角色组</div><div class="f-mw50 f-fl f-ml10 f-mb10">已选择角色组</div></div>
    <div class="f-mw100">
        <div class="f-mw50 f-ds1 f-fl f-ml10 div-appRole-grid-scrollbar" style="height: 450px">
            <div id="div_api_featrue_grid" class="f-dn"></div>
        </div>
        <div class="f-mw50 f-ds1 f-fr f-mr10 div-appRole-grid-scrollbar" style="height: 450px">
            <div id="div_configApi_featrue_grid" class="f-dn"></div>
        </div>
    </div>
    <div class="m-form-control pane-attribute-toolbar">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar f-mr10" id="div_btn_add">
            <span><spring:message code="btn.save"/></span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
            <span><spring:message code="btn.close"/></span>
        </div>
    </div>
</div>