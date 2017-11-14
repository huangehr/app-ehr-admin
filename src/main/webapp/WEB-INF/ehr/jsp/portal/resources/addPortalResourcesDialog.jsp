<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>


<style>
	.i-text{
		width: 185px;
		height: 30px;
		line-height: 30px;
		padding-right: 17px;
		color: #555555;
		padding-left: 5px;
		vertical-align: middle;
	}
	.uploadBtn{
		position: relative;
		vertical-align: middle;
		overflow: hidden;
	}
	.uploadBtn .file{
		width: 50px;
		height: 30px;
		position: absolute;
		top: 0;
		left: 0;
		opacity: 0;
		z-index: 999;
	}
</style>

<!--######资源页面 > 资源信息对话框模板页######-->
<div id="div_addResources_form" data-role-form class="m-form-inline f-mt20 f-pb10 f-dn" style="overflow:auto" >

	<form id ="uploadForm" enctype="multipart/form-data">

		<div id="div_resources_img_upload" class="u-upload alone f-ib f-tac f-vam u-upload-img" data-alone-file=true>
			<div id="div_file_list" class="uploader-list"></div>
			<div id="div_file_picker" class="f-mt10"><spring:message code="btn.file.choose"/></div>
		</div>

		<div class="m-form-group">
			<label>apkUrl</label>
			<div class="l-text-wrapper m-form-control ">
				<input type="text" class="i-text" id="apkUrl" data-attr-scan="url" readonly="readonly" />
				<div class="uploadBtn">上传
					<input type="file" id="inp_file_apk" name="apkFile" class="file" value="" />
				</div>
				<%--<input type="button" value="上传" id="apkUploadButton" class="uploadBtn"  />--%>
			</div>
		</div>

		<div class="m-form-group">
			<label>AndroidUrl</label>
			<div class="l-text-wrapper m-form-control ">
				<input type="text" class="i-text" id="androidUrl" data-attr-scan="androidQrCodeUrl" readonly="readonly" />
				<div class="uploadBtn">上传
					<input type="file" id="inp_file_android" name="androidFile"  class="file">
				</div>
				<%--<input type="button" value="上传" id="androidUploadButton"  class="uploadBtn"/>--%>
			</div>
		</div>

		<div class="m-form-group">
			<label>IOSUrl</label>
			<div class="l-text-wrapper m-form-control ">
				<input type="text"  class="i-text" id="iosUrl" data-attr-scan="iosQrCodeUrl"  readonly="readonly" />
				<div class="uploadBtn">上传
					<input type="file" id="inp_file_iosUrl" name="iosFile" class="file">
				</div>
				<%--<input type="button" value="上传" id="iosUploadButton" class="uploadBtn" />--%>
			</div>
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
			<textarea id="inp_description" class="required f-w240 max-length-256 validate-special-char"
					  data-attr-scan="description" ></textarea>
			</div>
		</div>

		<div class="m-form-control pane-attribute-toolbar">
			<div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar f-mr10" id="div_btn_add">
				<span><spring:message code="btn.save"/></span>
			</div>
			<div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar f-mr20" id="div_cancel_btn">
				<span><spring:message code="btn.close"/></span>
			</div>
		</div>

	</form>

</div>