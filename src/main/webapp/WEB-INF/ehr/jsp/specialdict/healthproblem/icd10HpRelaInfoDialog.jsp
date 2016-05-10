<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<input type="text" id="ipt_info_hpId" hidden="hidden" value="${hpId}"/>
<div id="div_wrapper" >
	<!-- ####### 查询条件部分 ####### -->
	<div class="m-retrieve-area f-pr m-form-inline" data-role-form>
		<div class="m-form-group f-m10" style="padding-bottom: 0px;">
			<div class="m-form-control">
				<!--输入框-->
				<input type="text" id="ipt_info_search" placeholder="请输入编码或名称" class="f-ml10" data-attr-scan="searchNm"/>
			</div>
			<!--批量关联-->
			<div class="m-form-control m-form-control-fr">
				<div  id="btn_relation_new" class="f-w120 l-button u-btn u-btn-primary u-btn-large f-ib f-vam" >
					<span>添加</span>
				</div>
			</div>
			<div class="m-form-control m-form-control-fr f-mr10">
				<div id="btn_relation_deletes" class="f-w120 l-button u-btn u-btn-primary u-btn-large f-ib f-vam" >
					<span>批量解除</span>
				</div>
			</div>

		</div>
	</div>
	<!-- ####### 数据表格 ####### -->

	<div id="div_icd10_include_info_grid" class="f-m10" >
	</div>
</div>


