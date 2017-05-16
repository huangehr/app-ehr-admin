<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="div_rs_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
	<input type="hidden" id="id" data-attr-scan="id"/>
	<input type="hidden" id="orgIdstr" data-attr-scan="orgId"/>


	<div class="m-form-group">
		<label>姓名<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_userId"  data-type="select"  class="required useTitle ajax f-h28 f-w240"
				   placeholder="请选择用户" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="userId">
		</div>
	</div>
	<div class="m-form-group">
		<label>职务<spring:message code="spe.colon"/></label>
		<div class="m-form-control ">
			<input id="inp_dutyName" class="useTitle ajax validate-special-char f-h28 f-w240" data-attr-scan="dutyName"/>
		</div>
	</div>

	<%--<div class="m-form-group">--%>
		<%--<label>部门<spring:message code="spe.colon"/></label>--%>
		<%--<div class="m-form-control essential ">--%>
			<%--<input id="inp_deptId" class="required useTitle f-h28 f-w240 validate-special-char" data-type="select"--%>
				   <%--placeholder="请选择部门"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="deptId"/>--%>
		<%--</div>--%>
	<%--</div>--%>

	<div class="m-form-group">
		<label>上级用户<spring:message code="spe.colon"/></label>
		<div class="m-form-control ">
			<input type="text" id="inp_parentUserId"  data-type="select"  class="required useTitle ajax f-h28 f-w240"
				   placeholder="请选择上级用户"  data-attr-scan="parentUserId">
		</div>
	</div>

	<div class="m-form-group">
		<label>描述<spring:message code="spe.colon"/></label>
		<div class="m-form-control ">
			<textarea id="inp_remark" class=" f-w240 description  max-length-256 validate-special-char" data-attr-scan="remark"/>
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

