<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="div_rs_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
	<div class="m-form-group">
		<label>机构<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential f-pr0">
			<input type="text" id="inp_orgId"  data-type="select"  class="required useTitle ajax f-h28 f-w240"
				   placeholder="请选择机构" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="orgId">
		</div>
	</div>

	<div class="m-form-group f-pa" style="bottom: 0;right: 20px;">
		<div class="m-form-control">
			<input type="button" value="<spring:message code="btn.save"/>" id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" />
			<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
				<span><spring:message code="btn.close"/></span>
			</div>
		</div>
	</div>
</div>

