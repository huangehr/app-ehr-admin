<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<div id="div_app_insetr" class="f-mw100">
	<div class="f-mw50 f-fl f-mt15 f-ds1">
		<div class="f-fl f-mw100 f-mt10" >
			<span class="f-fl f-ml10 f-lh30">人员：</span>
			<div class="f-fl">
				<input type="text" id="inp_user_search" placeholder="请输入人员名称" class="f-ml10"/>
			</div>
		</div>
		<div id="div_user_grid" class="f-fl f-mt10"></div>
	</div>
	<div class="f-mw50 f-fr f-mt15 f-ds1">
		<div class="f-fl f-mw100 f-mt10" >
			<span class="f-fl f-ml10 f-lh30">已配置人员：</span>
		</div>
		<div id="div_config_user_grid" class="f-fr f-mt10"></div>
	</div>
</div>