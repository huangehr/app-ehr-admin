<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<div id="div_data_info_form" data-role-form class="m-form-inline f-mt20">
	<input type="hidden" id="id" data-attr-scan="id"/>
	<input type="hidden" id="sourceId" data-attr-scan="resourcesId"/>
	<input type="hidden" id="sourceCode" data-attr-scan="resourcesCode"/>
	<div class="m-form-group">
		<label>参数名:</label>
		<div class="m-form-control essential">
			<input type="text" data-type="select" id="inp_paramKey"  class="required useTitle f-w350 f-h28 max-length-50"  required-title=<spring:message code="lbl.must.input"/>  data-attr-scan="paramKey">
		</div>
	</div>
	<div class="m-form-group">
		<label >参数值:</label>
		<div class="m-form-control essential">
			<textarea id="inp_paramValue" class=" required useTitle ajax f-w350  validate-special-char max-length-500"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="paramValue"></textarea>
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