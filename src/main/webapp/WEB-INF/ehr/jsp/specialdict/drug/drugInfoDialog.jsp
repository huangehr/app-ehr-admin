<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="div_drug_info_form" data-role-form class="m-form-inline f-mt20" data-role-form>
	<input type="hidden" id="id" data-attr-scan="id"/>
	<div class="m-form-group">
		<label >药品编码:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_drug_code" class="required useTitle ajax f-w240 max-length-50 "  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="code">
		</div>
	</div>
	<div class="m-form-group">
		<label >药品名称:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_drug_name" class="required useTitle ajax f-w240 max-length-200"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name">
		</div>
	</div>
	<div class="m-form-group">
		<label >药品类别:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_drug_type" data-type="select" class="required useTitle f-w240"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="type">
		</div>
	</div>
	<div class="m-form-group">
		<label >药品标识:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_drug_flag" data-type="select" class="required useTitle f-w240"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="flag">
		</div>
	</div>
	<div class="m-form-group">
		<label >商品名:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_drug_tradeName" class="required useTitle f-w240 max-length-50"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="tradeName">
		</div>
	</div>
	<div class="m-form-group">
		<label >单位:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_drug_unit" class="required useTitle f-w240 max-length-50"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="unit">
		</div>
	</div>
	<div class="m-form-group">
		<label >规格:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_drug_specifications" class="required useTitle f-w240 max-length-50"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="specifications">
		</div>
	</div>
	<div class="m-form-group">
		<label >说明:</label>
		<div class="m-form-control">
			<textarea id="inp_drug_description" class="f-w240  validate-special-char max-length-200" data-attr-scan="description"></textarea>
		</div>
	</div>
	<div class="m-form-group f-pa" style="bottom: 0;right: 10px;">
		<div class="m-form-control">
			<input type="button" value="<spring:message code="btn.save"/>" id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" />
			<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
				<span><spring:message code="btn.close"/></span>
			</div>
		</div>
	</div>
</div>