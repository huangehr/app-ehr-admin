<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<!--######用户管理页面 > 用户信息对话框模板页######-->
<div id="div_addUser_form" data-role-form class="m-form-inline f-mt20 f-pb10 f-dn" style="overflow:auto" >
	<div id="div_user_img_upload" class="u-upload alone f-ib f-tac f-vam u-upload-img" data-alone-file=true>
		<!--用来存放item-->
		<div id="div_file_list" class="uploader-list"></div>
		<div id="div_file_picker" class="f-mt10"><spring:message code="btn.file.choose"/></div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.loginCode"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input onkeyup="value=value.replace(/[^\w\.\/]/ig,'')" type="text" id="inp_loginCode" class="required  ajax useTitle max-length-50" placeholder="输入账号"  required-title=<spring:message code="lbl.must.input"/>  data-attr-scan="loginCode"/>

		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.name"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_userName" class="required useTitle max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="realName"/>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.identity.card"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_idCard" class="required useTitle ajax validate-id-number"  required-title=<spring:message code="lbl.must.input"/> validate-id-number-title=<spring:message code="ehr.user.invalid.identity.no"/>  data-attr-scan="idCardNo"/>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.user.sex"/><spring:message code="spe.colon"/></label>
		<div class="u-checkbox-wrap m-form-control">
			<input type="radio" value="1" name="gender" data-attr-scan><spring:message code="lbl.male"/>
			<input type="radio" value="2" name="gender" data-attr-scan><spring:message code="lbl.female"/>
		</div>
	</div>
	<%--<div class="m-form-group">--%>
	<%--<label><spring:message code="lbl.marriage.status"/><spring:message code="spe.colon"/></label>--%>
	<%--<div class="m-form-control">--%>
	<%--<input type="text" id="inp_select_marriage" data-type="select" data-attr-scan="martialStatus">--%>
	<%--</div>--%>
	<%--</div>--%>
	<div class="m-form-group">
		<label><spring:message code="lbl.user.mail"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control">
			<input type="text" id="inp_userEmail" class="useTitle validate-email ajax max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> validate-email-title=<spring:message code="lbl.input.true.email"/> data-attr-scan="email"/>
		</div>
	</div>
	<div class="m-form-group">
		<label><spring:message code="lbl.user.tel"/><spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_userTel" class="required useTitle validate-mobile-phone ajax"  required-title=<spring:message code="lbl.must.input"/>  validate-mobile-phone-title=<spring:message code="lbl.input.true.tel"/> data-attr-scan="telephone"/>
		</div>
	</div>
	<%--<div class="m-form-group">--%>
	<%--<label>现居住地:</label>--%>
	<%--<div class="l-text-wrapper m-form-control">--%>
	<%--<input type="text" id="location"  class="max-length-500" data-type="comboSelect" />--%>
	<%--</div>--%>
	<%--</div>--%>
	<div class="m-form-group">
		<label><spring:message code="lbl.user.role"/><spring:message code="spe.colon"/></label>
		<div  class="l-text-wrapper m-form-control essential" style="padding-right: 0px;">
			<input type="text" id="inp_select_userType"  data-type="select" placeholder="请选择用户类别" data-attr-scan="userType">
		</div>
		<input type="hidden" id="inp_select_setrole">
		<div class="l-button u-btn u-btn-primary u-btn f-ib f-vam f-mr10 f-ml10" id="div_btn_setrole">
			<span>编辑权限</span>
		</div>
	</div>
	<%--<div class="m-form-group">--%>
	<%--<label>用户来源<spring:message code="spe.colon"/></label>--%>
	<%--<div class="l-text-wrapper m-form-control ">--%>
	<%--<input type="text" id="inp_source" class="max-length-150 validate-special-char" data-attr-scan=""/>--%>
	<%--</div>--%>
	<%--</div>--%>
	<%--<div class="m-form-group">--%>
	<%--<label><spring:message code="lbl.org.belong"/><spring:message code="spe.colon"/></label>--%>
	<%--<div class="l-text-wrapper m-form-control f-w250" id="inp_org1">--%>
	<%--<input type="text" id="inp_org"  data-type="comboSelect" class="validate-org-length"--%>
	<%--data-attr-scan="organization"/>--%>
	<%--</div>--%>
	<%--</div>--%>
	<%--<div class="m-form-group" id="inp_major_div">--%>
		<%--<label><spring:message code="lbl.specialized.belong"/><spring:message code="spe.colon"/></label>--%>
		<%--<div class="l-text-wrapper m-form-control">--%>
			<%--<input type="text" id="inp_major" class="max-length-150 validate-special-char"  data-attr-scan="major"/>--%>
		<%--</div>--%>
	<%--</div>--%>
	<div class="m-form-group">
		<label>选择机构部门:</label>
		<div class="l-text-wrapper m-form-control essential">
			<div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10 required" style="width: 238px !important;    height: 30px;line-height: 30px;margin-right: 0px;" id="divBtnShow">
				<span>选择机构部门</span>
			</div>
		</div>
	</div>
	<%--<div class="m-form-group" style="display: none">--%>
		<%--<label >角色组:</label>--%>
		<%--<div id="roleDiv" class="l-text-wrapper m-form-control essential f-pr0" >--%>
			<%--<input type="text"  id="jryycyc" class=" useTitle f-h28 f-w240 ">--%>
		<%--</div>--%>
	<%--</div>--%>
	<div class="m-form-control pane-attribute-toolbar">
		<div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar f-mr10" id="div_btn_add">
			<span><spring:message code="btn.save"/></span>
		</div>
		<div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
			<span><spring:message code="btn.close"/></span>
		</div>
	</div>

</div>