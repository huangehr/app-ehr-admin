<%--
  Created by IntelliJ IDEA.
  User: yww
  Date: 2016/5/13
  Time: 17:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div class="f-dn" data-head-title="true">补采任务配置</div>
<div id="div_wrapper" >
	<!-- ####### 查询条件部分 ####### -->
	<div class="m-retrieve-area f-h100 f-pr m-form-inline" data-role-form>
		<div class="m-form-group f-mt10 ">
			<div class="m-form-control">
				<!--下拉框-->
				<input type="text" id="inp_code" class="f-h28 f-w1240" placeholder="请输入机构代码或系统代码" data-type="select" data-attr-scan="orgSysCode">
			</div>
			<div class="m-form-control f-ml20">
				<!--下拉框-->
				<input type="text" id="inp_status" class="f-h28 f-w160" placeholder="请选择状态" data-type="select" data-attr-scan="status">
			</div>
			<div class="m-form-control">
				<!--按钮:查询 & 新增-->
				<div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span><spring:message code="btn.search"/></span>
				</div>
			</div>
			<div class="m-form-control m-form-control-fr">
				<div id="div_new_record" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span><spring:message code="btn.create"/></span>
				</div>
			</div>
		</div>
		<div class="m-form-group f-mt10">
			<div class="m-form-control">
				<!--下拉框-->
				<input type="text" id="inp_start_time_low" class="f-h28 f-w160" placeholder="开始时间下限"  data-attr-scan="startTimeLow">
			</div>
			<div class="m-form-control f-ml20">
				<!--下拉框-->
				<input type="text" id="inp_start_time_up" class="f-h28 f-w160" placeholder="开始时间上限"  data-attr-scan="startTimeUp">
			</div>
			<div class="m-form-control f-ml20">
				<!--下拉框-->
				<input type="text" id="inp_end_time_low" class="f-h28 f-w160" placeholder="结束时间下限" data-attr-scan="endTimeLow">
			</div>
			<div class="m-form-control f-ml20">
				<!--下拉框-->
				<input type="text" id="inp_end_time_up" class="f-h28 f-w160" placeholder="结束时间上限" data-attr-scan="endTimeUp">
			</div>
		</div>
	</div>
	<div id="div_acq_info_grid" ></div>
</div>