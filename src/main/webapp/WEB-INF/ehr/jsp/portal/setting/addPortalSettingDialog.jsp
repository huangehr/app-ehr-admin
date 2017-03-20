<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<div id="div_addPortalSetting_form" data-role-form class="m-form-inline f-mt20 f-pb10 f-dn" style="overflow:auto" >

	<div class="m-form-group">
		<label><spring:message code="lbl.portalSetting.orgId"/><spring:message code="spe.colon"/></label>
		<div class="m-form-control">
			<input type="text" id="inp_orgId"  data-attr-scan="orgId" class="f-w240 description  max-length-50 validate-special-char">
		</div>
	</div>

	<div class="m-form-group">
		<label><spring:message code="lbl.portalSetting.appId"/><spring:message code="spe.colon"/></label>
		<div class="m-form-control">
			<input type="text" id="inp_appId" data-attr-scan="appId"  class="f-w240 description  max-length-50 validate-special-char">
		</div>
	</div>

	<div class="m-form-group">
		<label><spring:message code="lbl.portalSetting.columnUri"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control">
			<input type="text" id="inp_columnUri" data-attr-scan="columnUri"   class="f-w240 description  max-length-50 validate-special-char"/>
		</div>
	</div>

	<div class="m-form-group" id="inp_content_div">
		<label><spring:message code="lbl.portalSetting.columnName"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control ">
			<input id="inp_columnName"   data-attr-scan="columnName" class=" f-w240 description  max-length-256 validate-special-char"
					 />
		</div>
	</div>

	<%--<div class="m-form-group">--%>
		<%--<label><spring:message code="lbl.portalSetting.columnRequestType"/><spring:message code="spe.colon"/></label>--%>
		<%--<div class="m-form-control">--%>
			<%--<input type="text" id="inp_columnRequestType" data-type="select" data-attr-scan="columnRequestType">--%>
		<%--</div>--%>
	<%--</div>--%>

	<div class="m-form-group">
		<label><spring:message code="lbl.portalSetting.appApiId"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control " >
			<input id="inp_appApiId"   data-attr-scan="appApiId" class=" f-w240 description  max-length-56 validate-special-char"/>
		</div>
	</div>

	<%--<div class="m-form-group">--%>
		<%--<label><spring:message code="lbl.portalSetting.status"/><spring:message code="spe.colon"/></label>--%>
		<%--<div class="l-text-wrapper m-form-control ">--%>
			<%--&lt;%&ndash;<input type="text" id="inp_status" data-type="select" data-attr-scan="status"  />&ndash;%&gt;--%>
			<%--<select name="status" id="inp_status" data-attr-scan="status" style=" width: 150px;height: 25px;" >--%>
				<%--<option value="0" />有效--%>
				<%--<option value="1" />无效--%>
			<%--</select>--%>
		<%--</div>--%>
	<%--</div>--%>

	<div class="m-form-control pane-attribute-toolbar">
		<div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="div_btn_add">
			<span><spring:message code="btn.save"/></span>
		</div>
		<div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
			<span><spring:message code="btn.close"/></span>
		</div>
	</div>

</div>