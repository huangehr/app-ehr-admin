<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="div_roles_info_form" data-role-form class="m-form-inline f-mt20 f-ml30" data-role-form>
	<input type="hidden" id="rolesId" data-attr-scan="id"/>
	<input type="hidden" id="stdAppId" data-attr-scan="stdAppId"/>
	<div class="m-form-group">
		<label class="label_title" style="width:120px">角色组编码<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_roles_code" class="required useTitle f-w240 validate-special-char"  required-title=<spring:message code="lbl.must.input"/>  data-attr-scan="rolesCode"/>
		</div>
	</div>
	<div class="m-form-group">
		<label class="label_title" style="width:120px">角色组名称<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_roles_name" class="required useTitle f-w240 validate-special-char"  required-title=<spring:message code="lbl.must.input"/>  data-attr-scan="rolesName"/>
		</div>
	</div>

	<div class="m-form-group">
		<label class="label_title" style="width:120px">描述<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control">
			<textarea type="text" id="inp_description" class="max-length-200 validate-special-char"  data-attr-scan="description"></textarea>
		</div>
	</div>

	<div class="m-form-group f-pa" style="right: 10px;bottom: 0;">
		<div class="m-form-control">
			<input type="button" value="<spring:message code="btn.save"/>" id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" />
			<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
				<span><spring:message code="btn.close"/></span>
			</div>
		</div>
	</div>
</div>

