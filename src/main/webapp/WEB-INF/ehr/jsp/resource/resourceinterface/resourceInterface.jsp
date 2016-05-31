<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2016/5/24
  Time: 9:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<div class="f-dn" data-head-title="true">资源接口</div>
<div id="div_wrapper" >
	<!-- ####### 查询条件部分 ####### -->
	<div class="m-retrieve-area f-h50 f-pr m-form-inline" data-role-form>
		<div class="m-form-group f-mt10 ">
			<div class="m-form-control">
				<!--下拉框-->
				<input type="text" id="inp_searchNm" class="f-h28 f-w1240" placeholder="请输入接口名称或编码" data-attr-scan="searchNm">
			</div>
			<div class="m-form-control f-ml10">
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
	</div>
	<div id="div_data_info_grid" ></div>
</div>