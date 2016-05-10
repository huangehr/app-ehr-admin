<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<input type="text" id="ipt_create_icd10Id" hidden="hidden" value="${icd10Id}"/>
<div id="div_wrapper" >
	<!-- ####### 查询条件部分 ####### -->
	<div class="m-retrieve-area f-pr m-form-inline" data-role-form>
		<div class="m-form-group f-m10" style="padding-bottom: 0px;">
			<div class="m-form-control">
				<!--输入框-->
				<input type="text" id="ipt_create_search" data-type="select" placeholder="请输入编码或名称" class="f-h28 f-w240" data-attr-scan="searchNm"/>
			</div>
		</div>
	</div>
	<!-- ####### 数据表格 ####### -->

	<div id="div_indicator_create_grid" class="f-m10" >
	</div>

	<!-- ####### 确认、取消按钮 ####### -->
	<div class="m-form-group pane-attribute-toolbar f-mr10">
		<div class="m-form-control f-mr10">
			<input type="button" value="关联" id="btn_relation_create" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" />
		</div>
	</div>
</div>


