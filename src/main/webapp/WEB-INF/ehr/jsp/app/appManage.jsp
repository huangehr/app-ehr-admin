<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true"><spring:message code="title.app.manage"/></div>
<!-- ####### 页面部分 ####### -->
<div id="div_wrapper" >
    <!-- ####### 查询条件部分 ####### -->
    <div class="m-retrieve-area f-dn f-pr m-form-inline" data-role-form>
        <div class="m-form-group f-mt10">
            <div class="m-form-control f-mb10">
                <!--输入框-->
                <input type="text" id="inp_search" placeholder="请输入应用ID或名称" class="f-ml10" data-attr-scan="searchNm"/>
            </div>
			<div class="m-form-control f-ml10 f-mb10">
				<!--输入框-->
				<input type="text" id="inp_search_org" placeholder="请输入机构代码" class="f-ml10" data-attr-scan="org"/>
			</div>
            <div class="m-form-control f-ml10 f-mb10">
                <input type="text" data-type="select" id="ipt_sourceType" placeholder="应用来源" data-attr-scan="sourceType">
            </div>
            <div class="m-form-control f-ml10 f-mb10">
                <!--下拉框-->
                <input type="text" id="ipt_catalog" data-type="select" placeholder="请选择应用类型" data-attr-scan="catalog">
            </div>
            <div class="m-form-control f-ml10 f-mb10">
                <input type="text" data-type="select" id="ipt_status" placeholder="应用状态" data-attr-scan="status">
            </div>
            <div class="m-form-control f-ml10 f-mb10">
                <!--按钮:查询 & 新增-->
					<div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam f-mr10" >
						<span><spring:message code="btn.search"/></span>
					</div>
            </div>
            <div class="m-form-control m-form-control-fr">
				<sec:authorize url="/app/template/appInfo">
					<div id="btn_add" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
						<span ><spring:message code="btn.create"/></span>
					</div>
				</sec:authorize>
            </div>
        </div>
    </div>

    <!--###### 查询明细列表 ######-->
    <div id="div_app_info_grid" ></div>
</div>