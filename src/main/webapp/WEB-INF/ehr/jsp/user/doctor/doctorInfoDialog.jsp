<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######医生管理页面 > 医生信息对话框模板页######-->
<div id="div_info_form" data-role-form class="m-form-inline f-mt20 f-pb10" style="overflow:auto">
    <input data-attr-scan="id" hidden="hidden"/>
    <%--保存初始数据------%>

    <div id="div_img_upload" class="u-upload alone f-ib f-tac f-vam u-upload-img" data-alone-file=true>
        <!--用来存放item-->
        <div id="div_file_list" class="uploader-list"></div>
        <div id="div_file_picker" class="f-mt10"><spring:message code="btn.file.choose"/></div>
    </div>
    <div class="m-form-group m-form-readonly">
        <label><spring:message code="lbl.loginCode"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_code" class="required useTitle" data-attr-scan="code"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.name"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_name" class="required useTitle max-length-50 validate-special-char" required-title=<spring:message code="lbl.must.input"/>
                   data-attr-scan="name"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.sex"/><spring:message code="spe.colon"/></label>
        <div class="u-checkbox-wrap m-form-control">
            <input type="radio" value="1" name="sex" data-attr-scan><spring:message code="lbl.male"/>
            <input type="radio" value="2" name="sex" data-attr-scan><spring:message code="lbl.female"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.doctor.skill"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_skill" class="required useTitle max-length-100 validate-special-char"  required-title=<spring:message code="lbl.must.input"/>  validate-mobile-phone-title=<spring:message code="lbl.input.true.tel"/> data-attr-scan="skill"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.doctor.portal"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_portal" class="required useTitle max-length-256 validate-special-char"  required-title=<spring:message code="lbl.must.input"/>  validate-mobile-phone-title=<spring:message code="lbl.input.true.tel"/> data-attr-scan="workPortal"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.email"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_email" class="required useTitle validate-email ajax max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> validate-email-title=<spring:message code="lbl.input.true.email"/> data-attr-scan="email"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.doctor.phone"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_phone" class="required useTitle validate-mobile-phone"  required-title=<spring:message code="lbl.must.input"/>  validate-mobile-phone-title=<spring:message code="lbl.input.true.tel"/> data-attr-scan="phone"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.doctor.secondPhone"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_secondPhone" class="useTitle validate-mobile-phone" data-attr-scan="secondPhone"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.doctor.familyTel"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_familyTel" class="useTitle validate-phone" data-attr-scan="familyTel"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.doctor.officeTel"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_officeTel" class="required useTitle validate-phone"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="officeTel"/>
        </div>
    </div>

    <div class="m-form-group" id="inp_introduction_div">
        <label><spring:message code="lbl.doctor.introduction"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <textarea id="inp_introduction" class="f-w240 description  max-length-256 validate-special-char" data-attr-scan="introduction" ></textarea>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.doctor.jxzc"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_jxzc" class="useTitle max-length-50 validate-special-char" data-attr-scan="jxzc"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.doctor.lczc"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_lczc" class="useTitle max-length-50 validate-special-char" data-attr-scan="lczc"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.doctor.xlzc"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_xlzc" class="useTitle max-length-50 validate-special-char" data-attr-scan="xlzc"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.doctor.xzzc"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_zxzc" class="useTitle max-length-50 validate-special-char" data-attr-scan="xzzc"/>
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