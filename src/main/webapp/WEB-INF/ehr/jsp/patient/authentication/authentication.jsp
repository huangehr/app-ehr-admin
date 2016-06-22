<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<div class="f-dn" data-head-title="true">身份认证</div>
<div id="div_wrapper" >
	<!-- ####### 查询条件部分 ####### -->
	<div class="m-retrieve-area f-h50 f-pr m-form-inline" data-role-form>
		<div class="m-form-group f-mt10 ">
			<div class="m-form-control">
				<!--下拉框-->
				<input type="text" id="inp_start_time" class="f-h28 f-w160" placeholder="起始时间"  data-attr-scan="startTimeLow">
			</div>
			<div class="m-form-control" style="margin-top: 10px;font-weight:bold;font-size:35px;"> ~</div>
			<div class="m-form-control">
				<input type="text" id="inp_end_time" class="f-h28 f-w160" placeholder="截止时间"  data-attr-scan="startTimeUp">
			</div>
			<div class="m-form-control f-ml10">
				<!--下拉框-->
				<input type="text" id="inp_status" class="f-h28 f-w160" placeholder="请选择状态" data-type="select" data-attr-scan="status">
			</div>
			<div class="m-form-control f-ml10">
				<!--下拉框-->
				<input type="text" id="inp_name" class="f-h28 f-w1240" placeholder="请输入姓名" data-type="select" data-attr-scan="orgSysCode">
			</div>
			<div class="m-form-control f-ml10">
				<!--按钮:查询 & 新增-->
				<div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span><spring:message code="btn.search"/></span>
				</div>
			</div>
		</div>
	</div>
	<div id="div_info_grid" ></div>
</div>
