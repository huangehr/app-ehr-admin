<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######关联关系审核######-->
<div class="f-dn" data-head-title="true"><spring:message code="title.correlation.audit"/></div>
<div id="div_wrapper" >
	<!-- ####### 查询条件部分 ####### -->
	<div class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" data-role-form>
		<div class="m-form-group">
			<div class="m-form-control">
				<input type="text" id="beginTime" class="useTitle u-f-mt5"  placeholder="申请开始时间" data-attr-scan="beginTime" />
			</div>

			<div class="m-form-control">
				<div style="margin-top: 10px;font-weight:bold;font-size:35px;"> ~</div>
			</div>

			<div class="m-form-control">
				<input type="text" id="endTime" class="useTitle u-f-mt5"   placeholder="申请结束时间" data-attr-scan="endTime" />
			</div>

			<div class="m-form-control f-ml10" >
				<!--下拉框-->
				<input type="text" id="auditStatus" style="width:240px;"  data-type="select" class="validate-org-length f-w240" data-attr-scan="auditStatus"/>
			</div>

			<div class="m-form-control f-ml10">
				<input type="text" id="applyName" class="useTitle u-f-mt5"   placeholder=<spring:message code="title.correlation.applyname"/> data-attr-scan="applyName" />
			</div>
			<div class="m-form-control f-ml20">
				<!--按钮:查询-->
				<div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span><spring:message code="btn.search"/></span>
				</div>
			</div>
		</div>

	</div>
	<!--######关联关系审核列表#开始######-->
	<div id="div_correlation_audit_grid" >

	</div>
	<!--######关联关系审核列表#结束######-->
</div>