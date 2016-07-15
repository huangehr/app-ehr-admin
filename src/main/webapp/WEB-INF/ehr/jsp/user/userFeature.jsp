<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<div class="f-dn" data-head-title="true">用户权限浏览</div>
<div id="div_wrapper" >
	<div id="div_app_top" class="f-mt20">
		<div id="div_app_roles_grid" ></div>
	</div>
	<div class="f-mt10 f-fs14 f-ml10 f-fl f-fwb">
		<span id="left_title">具体权限：</span>
	</div>
	<div id="div_feature_bottom" class="feature_bottom">
		<div id="div_user_features_grid" class="features_grid" ></div>
	</div>
</div>