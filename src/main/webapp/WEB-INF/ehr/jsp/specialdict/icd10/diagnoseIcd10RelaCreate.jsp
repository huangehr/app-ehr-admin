<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="div_diagnose_info_form" data-role-form class="m-form-inline f-mt20" data-role-form>
	<input type="hidden" icd10Id="${icd10Id}" data-attr-scan="icd10Id"/>
	<input type="hidden" id="id" data-attr-scan="id"/>
	<div class="m-form-group">
		<label >诊断名称:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_diagnose_name" class="required useTitle ajax f-w240 max-length-200"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name">
		</div>
	</div>
	<div class="m-form-group">
		<label >说明:</label>
		<div class="m-form-control">
			<textarea id="inp_diagnose_description" class="f-w240  validate-special-char max-length-200" data-attr-scan="description"></textarea>
		</div>
	</div>
	<div class="m-form-group f-pa my-footer" style="bottom: 0;right: 10px;" hidden="hidden">
		<div class="m-form-control">
			<input type="button" value="关联" id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" />
			<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
				<span>关闭</span>
			</div>
		</div>
	</div>
</div>