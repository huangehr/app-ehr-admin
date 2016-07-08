<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######资源浏览页面Title设置######-->
<div class="f-dn" data-head-title="true">人员配置</div>
<div class="f-mat" id="div_wrapper">
	<div class="">
		<div class="f-ml20 f-mb10" style="display: inline-block">
			<input type="text" id="inp_title_msg" style="height:35px;border:none " class="f-w400 f-fs18 f-fwb" value="角色管理>维护组人员配置">
		</div>
		<div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar f-fr f-mr20 f-mb20" id="div_save_btn">
			<span>保存</span>
		</div>
	</div>
	<div class="div_roles_users_config f-ml20 f-mr20 f-h200" style="border: 1px solid red;">
		<div class="f-fl f-mpr">
			<%--人员--%>
			<div id="div_left" class="f-fl f-bd-configuration" >
				<div class="f-h30 f-mt10 f-mb10" >
                        <span class="f-mt10 f-fs14 f-ml10 f-fl" >
                            <strong class="f-fwb">人员:</strong>
                        </span>
                        <span class="f-fl f-ml10">
                            <input type="text" id="inp_users_search" placeholder="请输入人员名称">
                        </span>
				</div>
				<div id="div_users_grid" class="f-wat"></div>
			</div>
			<%--已配置人员--%>
			<div id="div_right" class="f-fr f-bd-configuration">
				<div class="f-h30 f-mt10 f-mb10">
                        <span class="f-mt10 f-fs14 f-ml10 f-fl">
                            <strong class="f-fwb">已配置人员:</strong>
                        </span>
				</div>
				<div id="div_roles_users_grid_true"></div>
			</div>
		</div>
	</div>
</div>