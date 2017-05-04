<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>

<div id="div_app_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
	<%--<input type="hidden" id="inp_source_type"  data-attr-scan="sourceType" value="0">--%>

	<div class="m-form-group">
		<label><spring:message code="lbl.designation"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_app_name" class="required useTitle max-length-50 validate-special-char" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name"/>
		</div>
	</div>

	<div class="m-form-group">
		<label>应用来源:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_source_type" data-type="select" class="required useTitle max-length-50 validate-special-char"
				   placeholder="请选择应用来源" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="sourceType"/>
		</div>
	</div>
	<%--增加图标 查看单个应用不需要图标--%>
	<div class="m-form-group">
		<label>应用图标:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_app_icon" class="required useTitle max-length-50 validate-special-char" placeholder="请选择应用图标" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="icon"/>
			<%----%>

			<%----%>
		</div>
	</div>
	<%--增加在线状态--%>
	<div class="m-form-group">
		<label>是否在线:</label>
		<div class="u-checkbox-wrap m-form-control">
			<input type="radio"  class="releaseFlag" name="releaseFlag" checked="checked" value="1" data-attr-scan>是
			<input type="radio"  class="releaseFlag" name="releaseFlag" value="0" data-attr-scan>否
		</div>
	</div>
	<div class="m-form-group">
		<label>应用代码<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_app_code" class="required max-length-50 validate-code-char ajax"  data-attr-scan="code"/>
		</div>
	</div>
	<div class="m-form-group">
		<label >机构名称:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_org_code" class="required f-h28 f-w240" data-type="select" placeholder="请输入机构代码或名称检索" data-attr-scan="org">
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.type"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control ">
			<input type="text" id="inp_dialog_catalog" data-type="select" class="required" data-attr-scan="catalog">
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.status"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control u-ui-readonly">
			<input type="text" id="inp_dialog_status" data-type="select"  data-attr-scan="status">
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.tip"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control">
			<input type="text" id="inp_tags" class="max-length-100 validate-special-char" placeholder="若输入多个标签，请用分号隔开" data-attr-scan="tags"/>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.internal.code"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control u-ui-readonly">
			<input type="text" id="inp_app_id" data-attr-scan="id"/>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.secret.key"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control u-ui-readonly">
			<input type="text" id="inp_app_secret"  data-attr-scan="secret"/>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.callback.URL"/><spring:message code="spe.colon"/></label>
		<div class="m-form-control essential">
			<textarea id="inp_url" class="required useTitle max-length-500 validate-special-char" placeholder="请输入回调URL"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="url" maxlength="500"></textarea>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.description"/><spring:message code="spe.colon"/></label>
		<div class="m-form-control ">
			<textarea id="inp_description" class="f-w240 max-length-500 validate-special-char" data-attr-scan="description" maxlength="500"></textarea>
		</div>
	</div>
	<div class="m-form-group" >
		<label >角色组:</label>
		<div id="roleDiv" class="l-text-wrapper m-form-control essential">
			<input style="color: #fff" type="text" id="jryycyc" class="ajax f-h28" data-type="select" data-attr-scan="role">
		</div>
	</div>
	<div class="m-form-group f-pr my-footer" align="right" hidden="hidden">
		<div class="m-form-control f-pa" style="right: 10px">
			<div id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" >
				<span><spring:message code="btn.save"/></span>
			</div>
			<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
				<span><spring:message code="btn.close"/></span>
			</div>
		</div>
	</div>
</div>

