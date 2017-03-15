<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######资源页面 > 资源信息对话框模板页######-->
<div id="div_addResources_form" data-role-form class="m-form-inline f-mt20 f-pb10 f-dn" style="overflow:auto" >

	<div id="div_resources_img_upload" class="u-upload alone f-ib f-tac f-vam u-upload-img" data-alone-file=true>
		<div id="div_file_list" class="uploader-list"></div>
		<div id="div_file_picker" class="f-mt10"><spring:message code="btn.file.choose"/></div>
	</div>

	<div class="m-form-group">
		<label><spring:message code="lbl.portalResources.name"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_name" class="required useTitle max-length-50 validate-special-char"
				   data-attr-scan="name" required-title=<spring:message code="lbl.must.input"/> />
		</div>
	</div>

	<div class="m-form-group">
		<label><spring:message code="lbl.portalResources.version"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_version" class="required useTitle max-length-50 validate-special-char"
				   data-attr-scan="version" required-title=<spring:message code="lbl.must.input"/> />
		</div>
	</div>

	<div class="m-form-group">
		<label><spring:message code="lbl.portalResources.platformType"/><spring:message code="spe.colon"/></label>
		<div class="m-form-control">
			<input type="text" id="inp_select_platform_type" data-type="select" data-attr-scan="platformType">
		</div>
	</div>

	<div class="m-form-group">
		<label><spring:message code="lbl.portalResources.developLan"/><spring:message code="spe.colon"/></label>
		<div class="m-form-control">
			<input type="text" id="inp_select_portal_develop_lan" data-type="select" data-attr-scan="developLan">
		</div>
	</div>


	<div class="m-form-group" id="inp_content_div">
		<label><spring:message code="lbl.portalResources.description"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<textarea id="inp_description" class="f-w240 max-length-256 validate-special-char"
					  data-attr-scan="description" ></textarea>
		</div>
	</div>

	<div class="m-form-control pane-attribute-toolbar">
		<div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="div_btn_add">
			<span><spring:message code="btn.save"/></span>
		</div>
		<div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
			<span><spring:message code="btn.close"/></span>
		</div>
	</div>

</div>