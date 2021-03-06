<%--
  Created by IntelliJ IDEA.
  User: yww
  Date: 2016/5/13
  Time: 17:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<div class="f-dn" data-head-title="true">HIS穿透查询</div>
<div id="div_wrapper" >
	<!-- ####### 查询条件部分 ####### -->
	<div class="m-retrieve-area f-h50 f-pr m-form-inline" data-role-form>
		<div class="m-form-group f-mt10 ">
			<div class="m-form-control">
				<!--下拉框-->
				<input type="text" id="inp_code" class="f-h28 f-w240" placeholder="请输入机构代码或系统代码" data-type="select" data-attr-scan="orgSysCode">
			</div>
			<div class="m-form-control f-ml10">
				<!--下拉框-->
				<input type="text" id="inp_status" class="f-h28" placeholder="请选择状态" data-type="select" data-attr-scan="status">
			</div>
			<div class="m-form-control f-ml10">
				<!--按钮:查询 & 新增-->
				<div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span><spring:message code="btn.search"/></span>
				</div>
			</div>
			<sec:authorize url='/esb/sqlTask/hosSqlTaskInfoDialog'>
			<div class="m-form-control m-form-control-fr">
				<div id="div_new_record" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span><spring:message code="btn.create"/></span>
				</div>
			</div>
			</sec:authorize>
		</div>
	</div>
	<div id="div_his_info_grid" ></div>
</div>