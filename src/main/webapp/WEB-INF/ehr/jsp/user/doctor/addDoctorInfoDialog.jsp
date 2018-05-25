<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<!--######医生管理页面 > 医生信息对话框模板页######-->
<div id="div_addDoctor_form" data-role-form class="m-form-inline f-mt20 f-pb10 f-dn" style="overflow:auto" >
	<div id="div_doctor_img_upload" class="u-upload alone f-ib f-tac f-vam u-upload-img" data-alone-file=true>
		<!--用来存放item-->
		<div id="div_file_list" class="uploader-list"></div>
		<div id="div_file_picker" class="f-mt10"><spring:message code="btn.file.choose"/></div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.loginCode"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input onkeyup="value=value.replace(/[^\w\.\/]/ig,'')" type="text" id="inp_code" class="required  ajax useTitle max-length-50" placeholder="输入账号"  required-title=<spring:message code="lbl.must.input"/>  data-attr-scan="code"/>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.name"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_name" class="required useTitle max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name"/>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.card"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_idCardNo" class="required useTitle ajax validate-id-number"  required-title=<spring:message code="lbl.must.input"/> validate-id-number-title=<spring:message code="lbl.input.true.idCard"/>  data-attr-scan="idCardNo"/>
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
		<div class="l-text-wrapper m-form-control">
			<input type="text" id="inp_portal" class="useTitle max-length-256 validate-special-char" data-attr-scan="workPortal"/>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.email"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_email" class="required useTitle validate-email ajax max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> validate-email-title=<spring:message code="lbl.input.true.email"/> data-attr-scan="email"/>
		</div>
		<label><spring:message code="lbl.sex"/><spring:message code="spe.colon"/></label>
		<div class="u-checkbox-wrap m-form-control">
			<input type="radio" value="1" name="sex" data-attr-scan><spring:message code="lbl.male"/>
			<input type="radio" value="2" name="sex" data-attr-scan><spring:message code="lbl.female"/>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.doctor.officeTel"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control">
			<input type="text" id="inp_officeTel" class=" useTitle validate-phone" data-attr-scan="officeTel"/>
		</div>
		<label>是否制证</label>
		<div class="l-text-wrapper m-form-control">
			<div class="l-text-wrapper m-form-control f-pr0">
				<input type="text" id="inp_jxzc" data-type="select" class="useTitle max-length-50"
					   placeholder="请选是否制证" data-attr-scan="jxzc"/>
			</div>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.doctor.phone"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_phone" class="required useTitle ajax validate-mobile-phone"  required-title=<spring:message code="lbl.must.input"/>  validate-mobile-phone-title=<spring:message code="lbl.input.true.tel"/> data-attr-scan="phone"/>
		</div>
		<label>技术职称</label>
		<div class="l-text-wrapper m-form-control">
			<div class="l-text-wrapper m-form-control f-pr0">
				<input type="text" id="inp_lczc" data-type="select" class="useTitle max-length-50"
					   placeholder="请选技术职称" data-attr-scan="lczc"/>
			</div>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.doctor.secondPhone"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control">
			<input type="text" id="inp_secondPhone" class="useTitle validate-mobile-phone" data-attr-scan="secondPhone"/>
		</div>
		<label><spring:message code="lbl.doctor.xlzc"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control">
			<input type="text" id="inp_xlzc" class="useTitle max-length-50 validate-special-char" data-attr-scan="xlzc"/>
		</div>
	</div>
	<div class="m-form-group">
		<label>选择机构部门:</label>
		<div class="l-text-wrapper m-form-control">
			<div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" style="width: 238px !important;    height: 30px;line-height: 30px;" id="divBtnShow">
				<span>选择机构部门</span>
			</div>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.doctor.familyTel"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control">
			<input type="text" id="inp_familyTel" class="useTitle validate-phone" data-attr-scan="familyTel"/>
		</div>
		<label><spring:message code="lbl.doctor.xzzc"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control">
			<input type="text" id="inp_zxzc" class="useTitle max-length-50 validate-special-char" data-attr-scan="xzzc"/>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.doctor.roleType"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control f-pr0">
            <input type="text" id="inp_roleType" data-type="select" class="useTitle max-length-50"
                   placeholder="请选择类别" data-attr-scan="roleType"/>
        </div>
		<label>执业类别</label>
		<div class="l-text-wrapper m-form-control f-pr0">
			<input type="text" id="inp_jobType" data-type="select" class="useTitle max-length-20"
				   placeholder="请选择执业类别" data-attr-scan="jobType"/>
		</div>
	</div>
	<div class="m-form-group">
		<label>从事专业类别代码</label>
		<div class="l-text-wrapper m-form-control f-pr0">
			<input type="text" id="inp_jobLevel" data-type="select" class="useTitle max-length-20"
				   placeholder="请选择从事专业类别代码" data-attr-scan="jobLevel"/>
		</div>
		<label>执业范围</label>
		<div class="l-text-wrapper m-form-control f-pr0">
			<input type="text" id="inp_jobScope" data-type="select" class="useTitle max-length-20"
				   placeholder="请选择执业范围" data-attr-scan="jobScope"/>
		</div>
	</div>
	<div class="m-form-group">
		<label>执业状态</label>
		<div class="l-text-wrapper m-form-control f-pr0">
			<input type="text" id="inp_jobState" data-type="select" class="useTitle max-length-20"
				   placeholder="请选择执业状态" data-attr-scan="jobState"/>
		</div>
		<label>考试库连带注册</label>
		<div class="u-checkbox-wrap m-form-control">
			<input type="radio" value="0" name="registerFlag" data-attr-scan>是
			<input type="radio" value="1" name="registerFlag" data-attr-scan>否
		</div>
	</div>
	<div class="m-form-group" id="inp_introduction_div">
		<label><spring:message code="lbl.doctor.introduction"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control">
			<textarea id="inp_introduction" class="f-w240 description  max-length-256 validate-special-char" data-attr-scan="introduction" ></textarea>
		</div>
	</div>
	<div class="m-form-control pane-attribute-toolbar">
		<div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" style="margin-left: 120px;" id="div_btn_add">
			<span><spring:message code="btn.save"/></span>
		</div>
		<div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
			<span><spring:message code="btn.close"/></span>
		</div>
	</div>

</div>