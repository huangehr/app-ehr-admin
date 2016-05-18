<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="div_hos_release_info_form" data-role-form class="m-form-inline f-mt20 f-ml30" data-role-form>

    <input type="hidden" id="id" data-attr-scan="id"/>
    <div class="m-form-group">
        <label class="label_title"><spring:message code="lbl.hosRelease.systemCode"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_system_code" class="required useTitle f-w240 max-length-200 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> placeholder="请输入<spring:message code="lbl.hosRelease.systemCode"/>"  data-attr-scan="systemCode"/>
        </div>
    </div>
    <div class="m-form-group">
        <label class="label_title"><spring:message code="lbl.hosRelease.file"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_file" class="required useTitle f-w240 max-length-200 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> placeholder="请输入<spring:message code="lbl.hosRelease.file"/>"  data-attr-scan="file"/>
        </div>
    </div>

    <div class="m-form-group">
        <label class="label_title"><spring:message code="lbl.hosRelease.versionName"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_version_name" class="required useTitle f-w240 max-length-200 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> placeholder="请输入<spring:message code="lbl.hosRelease.versionName"/>"  data-attr-scan="versionName"/>
        </div>
    </div>

    <div class="m-form-group">
        <label class="label_title"><spring:message code="lbl.hosRelease.versionCode"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_version_code" class="required useTitle f-w240 max-length-10 validate-special-char validate-integer"  required-title=<spring:message code="lbl.must.input"/> placeholder="请输入<spring:message code="lbl.hosRelease.versionCode"/>"  data-attr-scan="versionCode"/>
        </div>
    </div>

    <div class="m-form-group f-pa" style="right: 10px;bottom:0;">
        <div class="m-form-control" >
            <input type="button" value="<spring:message code="btn.save"/>" id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" />
            <div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
                <span><spring:message code="btn.close"/></span>
            </div>
        </div>
    </div>
</div>

