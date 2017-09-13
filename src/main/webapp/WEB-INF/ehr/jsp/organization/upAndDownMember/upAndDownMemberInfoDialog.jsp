<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<style>
	.l-text {
		width: 240px;
	}

</style>
<div id="div_rs_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
	<div class="m-form-group">
		<label>姓名<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_userId"  data-type="select"  class="required useTitle ajax f-h28 f-w240"
				   placeholder="请选择用户" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="userId">
		</div>
		<input type="hidden" value="" id="userName" data-attr-scan="userName" />
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

